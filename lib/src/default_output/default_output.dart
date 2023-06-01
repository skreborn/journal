import 'package:journal/src/entry.dart';
import 'package:journal/src/journal.dart';
import 'package:journal/src/output.dart';
import 'package:meta/meta.dart';

// ignore: always_use_package_imports
import 'default_output_web.dart' if (dart.library.io) 'default_output_io.dart';

/// The default implementation of [JournalOutput].
@immutable
final class DefaultJournalOutput implements JournalOutput {
  /// Whether to display [JournalEntry.time] in the output.
  final bool displayTimestamp;

  /// Whether to display [JournalEntry.level] in the output.
  final bool displayLevel;

  /// Whether to display [JournalEntry.zone] in the output.
  ///
  /// Dart doesn't give zones names by default, so the only possible values out of the box are
  /// `"root"` for `Zone.root` and `"<unknown>"` for all others.
  ///
  /// To display a meaningful name for your zones, make sure that they have a [String] value set for
  /// `#journalName`.
  ///
  /// ``` dart
  /// runZoned(() { /* ... */ }, zoneValues: const {#journalName: 'some-zone-name'});
  /// ```
  ///
  /// If a [JournalEntry] has no zone specified, `"<unspecified>"` will be printed.
  final bool displayZone;

  /// Whether to display [Journal.name] in the output.
  final bool displayName;

  /// Whether to display [JournalEntry.trace] in the output.
  final bool displayTrace;

  /// Creates a new [DefaultJournalOutput].
  const DefaultJournalOutput({
    this.displayTimestamp = true,
    this.displayLevel = true,
    this.displayZone = false,
    this.displayName = true,
    this.displayTrace = true,
  });

  @pragma('vm:always-consider-inlining')
  @pragma('dart2js:tryInline')
  @override
  void write(String name, JournalEntry entry) {
    return writeImpl(
      name,
      entry,
      displayTimestamp: displayTimestamp,
      displayLevel: displayLevel,
      displayZone: displayZone,
      displayName: displayName,
      displayTrace: displayTrace,
    );
  }
}
