import 'package:journal/src/entry.dart';

/// Interface for [Journal] outputs.
///
/// The default implementation is [DefaultJournalOutput].
abstract interface class JournalOutput {
  /// Writes [entry] for [name].
  void write(String name, JournalEntry entry);
}
