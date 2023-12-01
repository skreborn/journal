/// A library providing a [JournalOutput] implementation for Android Logcat.
library android;

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:journal/developer.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/output.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

@Native<Int Function(Int prio, Pointer<Utf8> tag, Pointer<Utf8> text)>(
  symbol: '__android_log_write',
  isLeaf: true,
)
external int _logWrite(int prio, Pointer<Utf8> tag, Pointer<Utf8> text);

/// Android Logcat implementation of [JournalOutput].
@immutable
final class AndroidJournalOutput implements JournalOutput {
  /// Whether to display [JournalEntry.zone] in the output.
  ///
  /// Dart doesn't give zones names by default. To display a meaningful name for your zones, make
  /// sure that they have a value for [zoneNameKey].
  ///
  /// ``` dart
  /// runZoned(() {}, zoneValues: const {zoneNameKey: 'some-name'});
  /// ```
  final bool displayZone;

  /// Whether to display [JournalEntry.trace] in the output.
  final bool displayTrace;

  /// Creates a new [AndroidJournalOutput].
  const AndroidJournalOutput({
    this.displayZone = false,
    this.displayTrace = true,
  });

  @pragma('vm:always-consider-inlining')
  @override
  void write(String name, JournalEntry entry) {
    // ignore: unused_result
    final priority = switch (entry.level) {
      JournalEntryLevel.trace => 2,
      JournalEntryLevel.debug => 3,
      JournalEntryLevel.info => 4,
      JournalEntryLevel.warn => 5,
      JournalEntryLevel.error => 6,
    };

    final tag = [
      name,
      if (displayZone) '[${entry.zone.name}]',
    ];

    final trace = entry.trace;

    final message = [
      entry.message,
      for (final entry in entry.values.entries) ' ${entry.key}=${entry.value}',
      if (displayTrace && trace != null)
        Trace.from(trace)
            .terse
            .alignedFrames
            .map((frame) => 'at ${frame.location} in ${frame.member}')
            .join('\n'),
    ];

    using((arena) {
      _logWrite(
        priority,
        tag.join().toNativeUtf8(allocator: arena),
        message.join().toNativeUtf8(allocator: arena),
      );
    });
  }
}
