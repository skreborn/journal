/// Developer-facing utility functions to ease the implemention of custom [JournalOutput]s.
library developer;

import 'dart:async';
import 'dart:math' as math;

import 'package:journal/journal.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

extension ZoneExt on Zone? {
  String get name {
    final self = this;

    if (self == null) {
      return '<unspecified>';
    }

    if (self == Zone.root) {
      return 'root';
    }

    return self[zoneNameKey]?.toString() ?? '<unknown>';
  }
}

@immutable
final class AlignedFrame {
  final String location;
  final String member;

  const AlignedFrame(this.location, this.member);
}

extension TraceExt on Trace {
  Iterable<AlignedFrame> get alignedFrames {
    final longest = frames.map((frame) => frame.location.length).fold(0, math.max);

    return frames.map((frame) {
      return AlignedFrame(frame.location.padRight(longest), frame.member ?? '<unknown>');
    });
  }
}
