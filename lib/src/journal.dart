import 'package:journal/src/entry.dart';
import 'package:journal/src/filter.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/output.dart';
import 'package:journal/src/value.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

/// A named log recorder.
@immutable
final class Journal {
  /// Optional filter to determine which contexts and entries are allowed.
  ///
  /// A disallowed context will simply not apply its contextual name and values within its scope,
  /// but the entries in it may still be recorded regardless if they pass the filter individually.
  ///
  /// A disallowed entry will not be recorded at all.
  static Filter? filter;

  /// Outputs to direct journal entries to.
  ///
  /// Defaults to no outputs.
  static List<Output> outputs = const [];

  /// Records [entry].
  ///
  /// {@template journal/Journal/record/entry}
  /// See the individual members of [Entry] for further details on the parameters.
  ///
  /// If any of your [values][Entry.values] are a result of an expensive calculation, you should
  /// check whether [Journal.filter] allows for it to be recorded at all before executing it.
  /// See [isAllowed].
  /// {@endtemplate}
  static void record(Entry entry) {
    if (filter?.call(entry.level, entry.name) ?? true) {
      for (final output in outputs) {
        if (output.isSupported) {
          output.write(entry);
        }
      }
    }
  }

  /// Name.
  final String name;

  /// Additional context.
  final List<Context> context;

  /// Creates a new [Journal] of [name].
  const Journal(this.name, [this.context = const []]);

  /// Returns whether an entry with a given [level] will pass [filter].
  ///
  /// ```dart
  /// if (journal.isAllowed(Level.trace)) {
  ///   final result = expensiveCalculation();
  ///
  ///   journal.trace('This is the way.', values: {'result': result.toJournal});
  /// }
  /// ```
  bool isAllowed(Level level) => filter?.call(level, name) ?? true;

  /// Records an entry at [level] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void log(
    Level level,
    String message, {
    Map<String, Value?> values = const {},
    StackTrace? trace,
  }) {
    record(
      Entry(
        name: name,
        time: DateTime.now(),
        level: level,
        context: context,
        message: message,
        values: values,
        trace: trace != null ? Trace.from(trace).terse : null,
      ),
    );
  }

  /// Records an entry at [Level.trace] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void trace(String message, {Map<String, Value?> values = const {}, StackTrace? trace}) {
    log(Level.trace, message, values: values, trace: trace);
  }

  /// Records an entry at [Level.debug] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void debug(String message, {Map<String, Value?> values = const {}, StackTrace? trace}) {
    log(Level.debug, message, values: values, trace: trace);
  }

  /// Records an entry at [Level.info] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void info(String message, {Map<String, Value?> values = const {}, StackTrace? trace}) {
    log(Level.info, message, values: values, trace: trace);
  }

  /// Records an entry at [Level.warn] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void warn(String message, {Map<String, Value?> values = const {}, StackTrace? trace}) {
    log(Level.warn, message, values: values, trace: trace);
  }

  /// Records an entry at [Level.error] with [message].
  ///
  /// {@macro journal/Journal/record/entry}
  void error(String message, {Map<String, Value?> values = const {}, StackTrace? trace}) {
    log(Level.error, message, values: values, trace: trace);
  }

  /// Executes [fn] with the additional [context].
  R withContext<R>(Context context, R Function(Journal journal) fn) {
    return fn(_applyContext(context));
  }

  Journal _applyContext(Context context) {
    if (filter?.call(context.level, context.name) ?? true) {
      return Journal(name, [...this.context, context]);
    }

    return this;
  }

  /// Returns the [String] representation of `this`.
  @override
  String toString() => 'Journal(name: $name, context: $context)';
}

/// Additional context for [Journal].
@immutable
final class Context {
  /// Category and granularity.
  final Level level;

  /// Category and granularity.
  final String name;

  /// Contextual values.
  final Map<String, Value?> values;

  /// Creates a new [Context] at [level] with [name].
  const Context(this.level, this.name, [this.values = const {}]);

  /// Creates a new [Context] at [Level.trace] with [name].
  const Context.trace(this.name, [this.values = const {}]) : level = Level.trace;

  /// Creates a new [Context] at [Level.debug] with [name].
  const Context.debug(this.name, [this.values = const {}]) : level = Level.debug;

  /// Creates a new [Context] at [Level.info] with [name].
  const Context.info(this.name, [this.values = const {}]) : level = Level.info;

  /// Creates a new [Context] at [Level.warn] with [name].
  const Context.warn(this.name, [this.values = const {}]) : level = Level.warn;

  /// Creates a new [Context] at [Level.error] with [name].
  const Context.error(this.name, [this.values = const {}]) : level = Level.error;

  /// Returns the [String] representation of `this`.
  @override
  String toString() => 'Context(name: $name, level: $level, values: $values)';
}
