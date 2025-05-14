import 'package:journal/src/entry.dart';
import 'package:journal/src/journal.dart';
import 'package:meta/meta.dart';

/// Interface for [Journal] outputs.
abstract interface class Output {
  /// Whether `this` is supported on the current platform.
  bool get isSupported;

  /// Writes [entry] as defined by the implementation.
  void write(Entry entry);

  @override
  @mustBeOverridden
  String toString();
}
