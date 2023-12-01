import 'dart:async';

import 'package:journal/src/level.dart';
import 'package:journal/src/value.dart';
import 'package:logging/logging.dart' as logging;
import 'package:meta/meta.dart';

/// A single log entry.
@immutable
final class JournalEntry {
  /// Time of creation.
  @useResult
  final DateTime time;

  /// The category and granularity.
  @useResult
  final JournalEntryLevel level;

  /// The originating zone, if known.
  @useResult
  final Zone? zone;

  /// The plain-text description.
  @useResult
  final String message;

  /// Additional values
  @useResult
  final Map<String, JournalValue?> values;

  /// The captured stack trace, if any.
  @useResult
  final StackTrace? trace;

  /// Creates a new [JournalEntry] at [time] and [level] with the specified [message].
  const JournalEntry({
    required this.time,
    required this.level,
    this.zone,
    required this.message,
    required this.values,
    this.trace,
  });

  /// Creates a [JournalEntry] from a [`logging`] library compatible [record].
  ///
  /// [`logging`]: https://pub.dev/packages/logging
  factory JournalEntry.fromLogging(logging.LogRecord record) {
    final values = switch (record.object) {
      null => const <String, JournalValue>{},
      final Map<Object?, Object?> map => map.map((key, value) {
          return MapEntry(key.toString(), value != null ? JournalValue.from(value) : null);
        }),
      final other => {'_object': JournalValue.from(other)},
    };

    final error = record.error;

    return JournalEntry(
      time: record.time,
      level: JournalEntryLevel.fromLogging(record.level),
      zone: record.zone,
      message: record.message,
      values: {...values, if (error != null) '_error': JournalValue.from(error)},
      trace: record.stackTrace,
    );
  }

  /// Returns the [String] representation of `this`.
  @override
  @useResult
  String toString() {
    return [
      time.toIso8601String(),
      level.name,
      message,
      for (final entry in values.entries) '${entry.key}=${entry.value}',
    ].join(' ');
  }
}
