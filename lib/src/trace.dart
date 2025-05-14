import 'dart:math';

import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

/// A single, aligned frame from a [Trace].
///
/// Obtained through [TraceExt.alignedFrames].
@immutable
final class AlignedFrame {
  /// Original [Frame] from which `this` was derived.
  final Frame source;

  /// Code location.
  ///
  /// Padded on the right with spaces (`' '`) to align with all other [location]s from the same
  /// [Trace].
  final String location;

  /// Member name.
  ///
  /// - Anonymous closures are represented as `<fn>`.
  /// - Unknown members are represented as `<unknown>`.
  final String member;

  /// Creates a new [AlignedFrame] from [source] and [locationLength].
  AlignedFrame(this.source, int locationLength)
    : location = source.location.padRight(locationLength),
      member = source.member ?? '<unknown>';

  /// Returns the [String] representation of `this`.
  @override
  String toString() => '$location in $member';
}

/// Extension on a [Trace] to obtain [AlignedFrame] instances from [frames].
extension TraceExt on Trace {
  /// Iterable over [AlignedFrame] instances sourced from [frames].
  Iterable<AlignedFrame> get alignedFrames {
    final longest = frames.map((frame) => frame.location.length).fold(0, max);

    return frames.map((frame) => AlignedFrame(frame, longest));
  }
}
