import 'package:journal/journal.dart';
import 'package:stack_trace/stack_trace.dart';

// This is separated so `dart:convert` doesn't get loaded on unsupported platforms.
// ignore: always_use_package_imports
import 'json_unsupported.dart' if (dart.library.io) 'json_supported.dart';

import 'unsupported.dart' if (dart.library.io) 'supported.dart';
export 'unsupported.dart' if (dart.library.io) 'supported.dart';

/// Formatter function.
typedef Formatter =
    Iterable<Span> Function({
      required TimestampSerializer timestampSerializer,
      required LevelSerializer levelSerializer,
      required DateTime time,
      required Level level,
      required List<Context> context,
      required String name,
      required String message,
      required Map<String, Value?> values,
      required Trace? trace,
      required bool displayTimestamp,
      required bool displayLevel,
      required bool displayContext,
      required bool displayContextValues,
      required bool displayValues,
      required bool displayTrace,
    });

/// Default formatter function.
Iterable<Span> defaultFormatter({
  required TimestampSerializer timestampSerializer,
  required LevelSerializer levelSerializer,
  required DateTime time,
  required Level level,
  required List<Context> context,
  required String name,
  required String message,
  required Map<String, Value?> values,
  required Trace? trace,
  required bool displayTimestamp,
  required bool displayLevel,
  required bool displayContext,
  required bool displayContextValues,
  required bool displayValues,
  required bool displayTrace,
}) {
  return [
    if (displayTimestamp) ...[
      Span(timestampSerializer(time).format(CellAlignment.left), isDim: true),
      const Span.space(),
    ],
    if (displayLevel) ...[
      Span(
        levelSerializer(level).format(CellAlignment.left),
        color: SpanColor(level, SpanColorTarget.foreground),
      ),
      const Span.space(),
    ],
    Span(name, isBold: true),
    const Span(': '),
    Span(message, isDim: true),
    if (displayValues)
      for (final entry in values.entries) ...[
        const Span.space(),
        Span(entry.key, isEmphasized: true),
        Span('=${entry.value}', isDim: true),
      ],
    if (displayContext)
      for (final entry in context) ...[
        const Span.lineBreak(),
        const Span('  with ', isDim: true),
        Span(entry.name),
        if (displayContextValues)
          for (final entry in entry.values.entries) ...[
            const Span.space(),
            Span(entry.key, isEmphasized: true),
            Span('=${entry.value}', isDim: true),
          ],
      ],
    if (displayTrace && trace != null)
      for (final frame in trace.alignedFrames) ...[
        const Span.lineBreak(),
        const Span('  at ', isDim: true),
        Span(frame.location),
        const Span(' in ', isDim: true),
        Span(frame.member, isBold: true),
      ],
  ];
}

/// JSON formatter function.
Iterable<Span> jsonFormatter({
  required TimestampSerializer timestampSerializer,
  required LevelSerializer levelSerializer,
  required DateTime time,
  required Level level,
  required List<Context> context,
  required String name,
  required String message,
  required Map<String, Value?> values,
  required Trace? trace,
  required bool displayTimestamp,
  required bool displayLevel,
  required bool displayContext,
  required bool displayContextValues,
  required bool displayValues,
  required bool displayTrace,
}) {
  Object? toPlainValue(Value? value) {
    return switch (value) {
      null => null,
      BoolValue(:final inner) => inner,
      IntValue(:final inner) => inner,
      DoubleValue(:final inner) => inner,
      StringValue(:final inner) => inner,
      IterableValue(:final inner) => inner.map(toPlainValue).toList(),
      EntriesValue(:final inner) => Map.fromEntries(
        inner.map((entry) => MapEntry(entry.key, toPlainValue(entry.value))),
      ),
    };
  }

  Map<String, Object?> valuesToPlain(Map<String, Value?> values) {
    return values.map((key, value) => MapEntry(key, toPlainValue(value)));
  }

  Map<String, Object?> contextToPlain(Context context) {
    return {
      'level': levelSerializer(context.level).content,
      'name': context.name,
      if (displayContextValues && context.values.isNotEmpty)
        'values': valuesToPlain(context.values),
    };
  }

  Map<String, Object?> frameToPlain(Frame frame) {
    return {
      'library': frame.library,
      'line': frame.line,
      'column': frame.column,
      'member': frame.member,
    };
  }

  return [
    Span(
      jsonEncode({
        if (displayTimestamp) 'time': timestampSerializer(time).content,
        if (displayLevel) 'level': levelSerializer(level).content,
        'name': name,
        if (displayContext && context.isNotEmpty) 'context': context.map(contextToPlain).toList(),
        'message': message,
        if (displayValues && values.isNotEmpty) 'values': valuesToPlain(values),
        if (displayTrace && trace != null) 'trace': trace.frames.map(frameToPlain).toList(),
      }),
    ),
  ];
}

/// {@template interface/StdioOutputInterface}
/// An [Output] targeting standard IO.
/// {@endtemplate}
abstract class StdioOutputInterface implements Output {
  /// Whether to force terminal output formatting.
  ///
  /// Useful when the platform falsely reports no support.
  final bool forceFormat;

  /// Function to serialize [Entry.time] with.
  final TimestampSerializer timestampSerializer;

  /// Function to serialize [Entry.level] with.
  final LevelSerializer levelSerializer;

  /// Function to format the output with.
  final Formatter formatter;

  /// Whether to display [Entry.time] in the output.
  final bool displayTimestamp;

  /// Whether to display [Entry.level] in the output.
  final bool displayLevel;

  /// Whether to display [Entry.context] in the output.
  final bool displayContext;

  /// Whether to display [Context.values] for each [Entry.context] entry in the output.
  final bool displayContextValues;

  /// Whether to display [Entry.values] in the output.
  final bool displayValues;

  /// Whether to display [Entry.trace] in the output.
  final bool displayTrace;

  /// {@template interface/StdioOutputInterface/StdioOutputInterface}
  /// Creates a new [StdioOutput].
  /// {@endtemplate}
  const StdioOutputInterface({
    this.forceFormat = false,
    this.timestampSerializer = iso8601TimestampSerializer,
    this.levelSerializer = defaultLevelSerializer,
    this.formatter = defaultFormatter,
    this.displayTimestamp = true,
    this.displayLevel = true,
    this.displayContext = true,
    this.displayContextValues = true,
    this.displayValues = true,
    this.displayTrace = true,
  });

  /// Returns the [String] representation of `this`.
  @override
  String toString();
}
