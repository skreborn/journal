// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math' as math;

import 'package:journal/src/entry.dart';
import 'package:journal/src/level.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

@immutable
sealed class Span {
  const Span();

  const factory Span.spacing() = SpacingSpan;
  const factory Span.level(JournalEntryLevel level) = LevelSpan;

  const factory Span.text(
    String text, {
    bool isBold,
    bool isDim,
    bool isEmphasized,
  }) = TextSpan;
}

final class SpacingSpan extends Span {
  const SpacingSpan();
}

final class LevelSpan extends Span {
  final JournalEntryLevel level;

  const LevelSpan(this.level);
}

final class TextSpan extends Span {
  final String text;
  final bool isBold;
  final bool isDim;
  final bool isEmphasized;

  const TextSpan(
    this.text, {
    this.isBold = false,
    this.isDim = false,
    this.isEmphasized = false,
  });
}

List<Span> formatMessage(
  String name,
  JournalEntry entry, {
  required bool displayTimestamp,
  required bool displayLevel,
  required bool displayZone,
  required bool displayName,
}) {
  final zone = entry.zone;

  return [
    if (displayTimestamp) ...[
      Span.text(entry.time.toUtc().toIso8601String(), isDim: true),
      const SpacingSpan(),
    ],
    if (displayLevel) ...[
      Span.level(entry.level),
      const SpacingSpan(),
    ],
    if (displayZone)
      if (zone == Zone.root)
        const Span.text('root')
      else if (zone == null)
        const Span.text('<unspecified>')
      else
        Span.text(zone[#journalName]?.toString() ?? '<unknown>'),
    if (displayZone && displayName) const Span.text('/'),
    if (displayName) Span.text('$name:', isBold: true),
    if (displayZone || displayName) const SpacingSpan(),
    Span.text(entry.message, isDim: true),
    for (final entry in entry.values.entries) ...[
      const SpacingSpan(),
      Span.text(entry.key, isEmphasized: true),
      Span.text('=${entry.value}', isDim: true),
    ],
  ];
}

List<List<Span>> formatTrace(Trace trace) {
  final longest = trace.frames.map((frame) => frame.location.length).fold(0, math.max);

  return trace.frames.map((frame) {
    final location = frame.location.padRight(longest);

    return [
      const Span.text('at', isDim: true),
      const SpacingSpan(),
      Span.text(location),
      const SpacingSpan(),
      const Span.text('in', isDim: true),
      const SpacingSpan(),
      Span.text(frame.member ?? '<unknown>', isBold: true),
    ];
  }).toList();
}
