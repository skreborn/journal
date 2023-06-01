import 'package:journal/src/default_output/default_output.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/journal.dart';

/// Interface for [Journal] outputs.
///
/// The default implementation is [DefaultJournalOutput].
abstract interface class JournalOutput {
  /// Writes [entry] for [name].
  void write(String name, JournalEntry entry);
}
