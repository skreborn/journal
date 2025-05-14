import 'dart:io';

import 'package:journal/journal.dart';
import 'package:journal_stdio/journal_stdio.dart';

/// {@macro interface/StdioOutputInterface}
final class StdioOutput extends StdioOutputInterface {
  @override
  bool get isSupported => true;

  /// {@macro interface/StdioOutputInterface/StdioOutputInterface}
  const StdioOutput({
    super.forceFormat,
    super.timestampSerializer,
    super.levelSerializer,
    super.formatter,
    super.displayTimestamp,
    super.displayLevel,
    super.displayContext,
    super.displayContextValues,
    super.displayValues,
    super.displayTrace,
  });

  @override
  void write(Entry entry) {
    String format(Span span) {
      if (stdout.supportsAnsiEscapes || forceFormat) {
        final color = switch (span.color) {
          null => null,
          final color => switch (color.source) {
            Level.error => color.target == SpanColorTarget.foreground ? const [31] : const [41, 37],
            Level.warn => color.target == SpanColorTarget.foreground ? const [33] : const [43, 37],
            Level.info => color.target == SpanColorTarget.foreground ? const [32] : const [42, 37],
            Level.debug => color.target == SpanColorTarget.foreground ? const [34] : const [44, 37],
            Level.trace => color.target == SpanColorTarget.foreground ? const [35] : const [45, 37],
          },
        };

        final codes = [
          if (color != null)
            for (final code in color) code,
          if (span.isBold) 1,
          if (span.isDim) 2,
          if (span.isEmphasized) 3,
        ];

        return '\x1b[${codes.join(';')}m${span.text}\x1b[0m';
      }

      return span.text;
    }

    final message = formatter(
      timestampSerializer: timestampSerializer,
      levelSerializer: levelSerializer,
      time: entry.time,
      level: entry.level,
      context: entry.context,
      name: entry.name,
      message: entry.message,
      values: entry.values,
      trace: entry.trace,
      displayTimestamp: displayTimestamp,
      displayLevel: displayLevel,
      displayContext: displayContext,
      displayContextValues: displayContextValues,
      displayValues: displayValues,
      displayTrace: displayTrace,
    );

    stdout.writeln(message.map(format).join());
  }

  @override
  String toString() {
    final props = {
      'forceFormat': forceFormat.toString(),
      'displayTimestamp': displayTimestamp.toString(),
      'displayLevel': displayLevel.toString(),
      'displayContext': displayContext.toString(),
      'displayContextValues': displayContextValues.toString(),
      'displayValues': displayValues.toString(),
      'displayTrace': displayTrace.toString(),
    }.entries.map((prop) => '${prop.key}: ${prop.value}').join(', ');

    return 'StdioOutput($props)';
  }
}
