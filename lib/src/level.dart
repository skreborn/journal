import 'package:journal/src/entry.dart';

/// Associated category and granularity of an [Entry].
enum Level {
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

  /// Whether `this` is finer than [other].
  bool operator <(Level other) => index < other.index;

  /// Whether `this` is coarser than [other].
  bool operator >(Level other) => index > other.index;

  /// Whether `this` is finer than or equal to [other].
  bool operator <=(Level other) => index <= other.index;

  /// Whether `this` is coarser than or equal to [other].
  bool operator >=(Level other) => index >= other.index;

  /// Returns the [String] representation of `this`.
  @override
  String toString() => name;
}
