import 'package:logging/logging.dart' as logging;
import 'package:meta/meta.dart';

/// The associated category and granularity of a [JournalEntry].
enum JournalEntryLevel {
  /// Used to output potentially large amounts of fine-grained entries.
  trace,

  /// Used to output entries that aid debugging a library or application.
  debug,

  /// Used to output user-facing information.
  info,

  /// Used to output user-facing warnings.
  warn,

  /// Used to output user-facing errors.
  error;

  /// Creates a [JournalEntryLevel] from a [`logging`] library compatible [level].
  ///
  /// [`logging`]: https://pub.dev/packages/logging
  factory JournalEntryLevel.fromLogging(logging.Level level) {
    return switch (level.value) {
      < 500 => JournalEntryLevel.trace,
      < 800 => JournalEntryLevel.debug,
      < 900 => JournalEntryLevel.info,
      < 1000 => JournalEntryLevel.warn,
      _ => JournalEntryLevel.error,
    };
  }

  /// Whether `this` is finer than [other].
  @useResult
  bool operator <(JournalEntryLevel other) => index < other.index;

  /// Whether `this` is coarser than [other].
  @useResult
  bool operator >(JournalEntryLevel other) => index > other.index;

  /// Whether `this` is finer than or equal to [other].
  @useResult
  bool operator <=(JournalEntryLevel other) => index <= other.index;

  /// Whether `this` is coarser than or equal to [other].
  @useResult
  bool operator >=(JournalEntryLevel other) => index >= other.index;

  /// Returns the `String` representation of `this`.
  @override
  @useResult
  String toString() => name;
}
