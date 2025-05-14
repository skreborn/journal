import 'package:journal/journal.dart';
import 'package:stack_trace/stack_trace.dart';

import 'unsupported.dart' if (dart.library.io) 'supported.dart';
export 'unsupported.dart' if (dart.library.io) 'supported.dart';

/// Formatter function.
typedef Formatter =
    Iterable<Span> Function({
      required Level level,
      required List<Context> context,
      required String message,
      required Map<String, Value?> values,
      required Trace? trace,
      required bool displayContext,
      required bool displayContextValues,
      required bool displayValues,
      required bool displayTrace,
    });

/// Default formatter function.
Iterable<Span> defaultFormatter({
  required Level level,
  required List<Context> context,
  required String message,
  required Map<String, Value?> values,
  required Trace? trace,
  required bool displayContext,
  required bool displayContextValues,
  required bool displayValues,
  required bool displayTrace,
}) {
  return [
    Span(message),
    if (displayValues)
      for (final entry in values.entries) ...[
        const Span.space(),
        Span(entry.key),
        Span('=${entry.value}'),
      ],
    if (displayContext)
      for (final entry in context) ...[
        const Span.lineBreak(),
        const Span('  with '),
        Span(entry.name),
        if (displayContextValues)
          for (final entry in entry.values.entries) ...[
            const Span.space(),
            Span(entry.key),
            Span('=${entry.value}'),
          ],
      ],
    if (displayTrace && trace != null)
      for (final frame in trace.alignedFrames) ...[
        const Span.lineBreak(),
        const Span('  at '),
        Span(frame.location),
        const Span(' in '),
        Span(frame.member),
      ],
  ];
}

/// {@template interface/AndroidOutputInterface}
/// An [Output] targeting Android devices.
/// {@endtemplate}
abstract class AndroidOutputInterface implements Output {
  /// Function to format the output with.
  final Formatter formatter;

  /// Whether to display [Entry.context] in the output.
  final bool displayContext;

  /// Whether to display [Context.values] for each [Entry.context] entry in the output.
  final bool displayContextValues;

  /// Whether to display [Entry.values] in the output.
  final bool displayValues;

  /// Whether to display [Entry.trace] in the output.
  final bool displayTrace;

  /// {@template interface/AndroidOutputInterface/AndroidOutputInterface}
  /// Creates a new [AndroidOutput].
  /// {@endtemplate}
  const AndroidOutputInterface({
    this.formatter = defaultFormatter,
    this.displayContext = true,
    this.displayContextValues = true,
    this.displayValues = true,
    this.displayTrace = true,
  });

  /// Returns the [String] representation of `this`.
  @override
  String toString();
}
