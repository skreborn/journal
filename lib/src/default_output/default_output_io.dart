// ignore_for_file: public_member_api_docs

import 'dart:io' as io;

import 'package:journal/src/default_output/spans.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/journal.dart';
import 'package:journal/src/level.dart';
import 'package:stack_trace/stack_trace.dart';

void writeImpl(
  String name,
  JournalEntry entry, {
  required bool displayTimestamp,
  required bool displayLevel,
  required bool displayZone,
  required bool displayName,
  required bool displayTrace,
}) {
  final trace = entry.trace;

  String format(Span span) {
    switch (span) {
      case SpacingSpan():
        return ' ';
      case LevelSpan(:final level):
        final color = switch (level) {
          JournalEntryLevel.error => 31,
          JournalEntryLevel.warn => 33,
          JournalEntryLevel.info => 32,
          JournalEntryLevel.debug => 34,
          JournalEntryLevel.trace => 35,
        };

        return '\x1b[${color}m${level.name.toUpperCase().padLeft(5)}\x1b[0m';
      case TextSpan(:final text, :final isBold, :final isDim, :final isEmphasized):
        if (io.stdout.supportsAnsiEscapes || Journal.forceFormatTerminalOutput) {
          final codes = [
            if (isBold) 1,
            if (isDim) 2,
            if (isEmphasized) 3,
          ];

          return '\x1b[${codes.nonNulls.join(';')}m$text\x1b[0m';
        }

        return text;
    }
  }

  final message = formatMessage(
    name,
    entry,
    displayTimestamp: displayTimestamp,
    displayLevel: displayLevel,
    displayZone: displayZone,
    displayName: displayName,
  );

  io.stdout.writeln(message.map(format).join());

  if (displayTrace && trace != null) {
    for (final line in formatTrace(Trace.from(trace).terse)) {
      io.stdout.writeln('  ${line.map(format).join()}');
    }
  }
}
