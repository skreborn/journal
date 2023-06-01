import 'dart:async';

import 'package:journal/src/default_output/default_output.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/output.dart';
import 'package:journal/src/value.dart';
import 'package:meta/meta.dart';
import 'package:source_maps/source_maps.dart';

var _minimumLevel = JournalEntryLevel.info;
var _autoCaptureZones = true;
var _forceFormatTerminalOutput = false;
var _outputs = const <JournalOutput>[DefaultJournalOutput()];

JournalSourceMapSettings? _sourceMapSettings;

/// Source map settings for [Journal].
@immutable
final class JournalSourceMapSettings {
  /// The mapping created from a source map.
  final Mapping mapping;

  /// The prefix mapping associating URI prefixes with package names.
  final Map<Uri, String> prefixes;

  /// Creates a new [JournalSourceMapSettings] with the specified [mapping] and [prefixes].
  const JournalSourceMapSettings({
    required this.mapping,
    this.prefixes = const {},
  });
}

/// A named log writer.
@immutable
final class Journal {
  /// The mimumum granularity of log entries to output.
  ///
  /// Defaults to [JournalEntryLevel.info].
  ///
  /// # Examples
  ///
  /// You may use this to check whether an entry will be output proactively to prevent expensive
  /// operations.
  ///
  /// ```dart
  /// if (JournalEntryLevel.warn >= Journal.minimumLevel) {
  ///   journal.warn('A warning with an expensive operation.', {'value': calculateValue()});
  /// }
  /// ```
  @useResult
  static JournalEntryLevel get minimumLevel => _minimumLevel;

  static set minimumLevel(JournalEntryLevel value) => _minimumLevel = value;

  /// Whether to automatically capture the current zone when it's not explicitly specified.
  ///
  /// Defaults to `true`.
  ///
  /// This can be overriden individually in [log], [trace], [debug], [info], [warn], and [error].
  @useResult
  static bool get autoCaptureZones => _autoCaptureZones;

  static set autoCaptureZones(bool value) => _autoCaptureZones = value;

  /// Whether to force terminal output formatting.
  ///
  /// Defaults to `false`.
  ///
  /// Useful when the platform falsely reports no support.
  @useResult
  static bool get forceFormatTerminalOutput => _forceFormatTerminalOutput;

  static set forceFormatTerminalOutput(bool value) => _forceFormatTerminalOutput = value;

  /// The outputs to direct journal entries to.
  ///
  /// Defaults to [DefaultJournalOutput] only.
  @useResult
  static Iterable<JournalOutput> get outputs => _outputs;

  static set outputs(Iterable<JournalOutput> value) => _outputs = value.toList(growable: false);

  /// The source map settings associated with the application.
  ///
  /// Used to clean up the stack traces for web builds.
  @useResult
  static JournalSourceMapSettings? get sourceMapSettings => _sourceMapSettings;

  static set sourceMapSettings(JournalSourceMapSettings? value) => _sourceMapSettings = value;

  /// Records [entry] with the given [name].
  ///
  /// {@template journal/Journal/record/entry}
  /// See the individual members of [JournalEntry] for further details on the parameters.
  /// {@endtemplate}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  static void record(String name, JournalEntry entry) {
    if (entry.level >= _minimumLevel) {
      for (final output in _outputs) {
        output.write(name, entry);
      }
    }
  }

  /// The name of this writer.
  @useResult
  final String name;

  /// Creates a new [Journal] of the given [name].
  const Journal(this.name);

  /// Records an entry at [level] with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@template journal/Journal/log/zone}
  /// [autoCaptureZone] defaults to [autoCaptureZones] if unspecified.
  /// {@endtemplate}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void log(
    JournalEntryLevel level,
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    final entry = JournalEntry(
      time: DateTime.now(),
      level: level,
      zone: zone ?? (autoCaptureZone ?? autoCaptureZones ? Zone.current : null),
      message: message,
      values: values,
      trace: trace,
    );

    record(name, entry);
  }

  /// Records an entry at the [JournalEntryLevel.trace] level with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@macro journal/Journal/log/zone}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void trace(
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    log(
      JournalEntryLevel.trace,
      message,
      zone: zone,
      autoCaptureZone: autoCaptureZone,
      values: values,
      trace: trace,
    );
  }

  /// Records an entry at the [JournalEntryLevel.debug] level with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@macro journal/Journal/log/zone}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void debug(
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    log(
      JournalEntryLevel.debug,
      message,
      zone: zone,
      autoCaptureZone: autoCaptureZone,
      values: values,
      trace: trace,
    );
  }

  /// Records an entry at the [JournalEntryLevel.info] level with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@macro journal/Journal/log/zone}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void info(
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    log(
      JournalEntryLevel.info,
      message,
      zone: zone,
      autoCaptureZone: autoCaptureZone,
      values: values,
      trace: trace,
    );
  }

  /// Records an entry at the [JournalEntryLevel.warn] level with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@macro journal/Journal/log/zone}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void warn(
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    log(
      JournalEntryLevel.warn,
      message,
      zone: zone,
      autoCaptureZone: autoCaptureZone,
      values: values,
      trace: trace,
    );
  }

  /// Records an entry at the [JournalEntryLevel.error] level with the specified [message].
  ///
  /// {@macro journal/Journal/record/entry}
  ///
  /// {@macro journal/Journal/log/zone}
  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  void error(
    String message, {
    Zone? zone,
    bool? autoCaptureZone,
    Map<String, JournalValue?> values = const {},
    StackTrace? trace,
  }) {
    log(
      JournalEntryLevel.error,
      message,
      zone: zone,
      autoCaptureZone: autoCaptureZone,
      values: values,
      trace: trace,
    );
  }

  /// Returns the `String` representation of `this`.
  @override
  @useResult
  String toString() => 'Journal($name)';
}
