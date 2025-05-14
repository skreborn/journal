import 'package:journal/journal.dart';
import 'package:stack_trace/stack_trace.dart';

import 'unsupported.dart' if (dart.library.js_interop) 'supported.dart';
export 'unsupported.dart' if (dart.library.js_interop) 'supported.dart';

/// Message formatter function.
typedef MessageFormatter =
    Iterable<Span> Function({
      required LevelSerializer levelSerializer,
      required Level level,
      required String name,
      required String message,
      required bool displayLevel,
    });

/// Default message formatter function.
Iterable<Span> defaultMessageFormatter({
  required LevelSerializer levelSerializer,
  required Level level,
  required String name,
  required String message,
  required bool displayLevel,
}) {
  return [
    if (displayLevel) ...[
      Span(
        levelSerializer(level).content,
        isBold: true,
        color: SpanColor(level, SpanColorTarget.background),
      ),
      const Span.space(),
    ],
    Span('$name: ', isBold: true),
    Span(message, isDim: true),
  ];
}

/// Context formatter function.
typedef ContextFormatter =
    Iterable<Span> Function({
      required LevelSerializer levelSerializer,
      required String name,
      required Level level,
    });

/// Default context formatter function.
Iterable<Span> defaultContextFormatter({
  required LevelSerializer levelSerializer,
  required String name,
  required Level level,
}) {
  return [
    Span(
      levelSerializer(level).content,
      isBold: true,
      color: SpanColor(level, SpanColorTarget.background),
    ),
    const Span.space(),
    Span(name),
  ];
}

/// Trace formatter function.
typedef TraceFormatter = Iterable<Span> Function({required Trace trace});

/// Default trace formatter function.
Iterable<Span> defaultTraceFormatter({required Trace trace}) {
  return [
    for (final (index, frame) in trace.alignedFrames.indexed) ...[
      if (index != 0) const Span.lineBreak(),
      const Span('at ', isDim: true),
      Span(frame.location),
      const Span(' in ', isDim: true),
      Span(frame.member, isBold: true),
    ],
  ];
}

/// {@template interface/WebOutputInterface}
/// An [Output] targeting Javascript environments.
/// {@endtemplate}
abstract class WebOutputInterface implements Output {
  /// Function to serialize [Entry.level] with.
  final LevelSerializer levelSerializer;

  /// Function to format the message with.
  final MessageFormatter messageFormatter;

  /// Function to format the context with.
  final ContextFormatter contextFormatter;

  /// Function to format the trace with.
  final TraceFormatter traceFormatter;

  /// Label to use for the context group in the output.
  final String contextLabel;

  /// Label to use for the values group in the output.
  final String valuesLabel;

  /// Label to use for the trace group in the output.
  final String traceLabel;

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

  /// {@template interface/WebOutputInterface/WebOutputInterface}
  /// Creates a new [WebOutput].
  /// {@endtemplate}
  const WebOutputInterface({
    this.levelSerializer = defaultLevelSerializer,
    this.messageFormatter = defaultMessageFormatter,
    this.contextFormatter = defaultContextFormatter,
    this.traceFormatter = defaultTraceFormatter,
    this.contextLabel = 'Context',
    this.valuesLabel = 'Values',
    this.traceLabel = 'Stack trace',
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
