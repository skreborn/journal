import 'package:journal/journal.dart';
import 'package:journal_stdio/journal_stdio.dart';

/// {@macro interface/StdioOutputInterface}
final class StdioOutput extends StdioOutputInterface {
  @override
  bool get isSupported => false;

  /// {@macro interface/StdioOutputInterface/StdioOutputInterface}
  const StdioOutput({
    super.forceFormat,
    super.timestampSerializer,
    super.levelSerializer,
    super.formatter,
    super.displayTimestamp,
    super.displayLevel,
    super.displayContext,
    super.displayContextValues,
    super.displayValues,
    super.displayTrace,
  });

  @override
  void write(Entry entry) => throw UnsupportedError('Not supported on this platform.');

  @override
  String toString() => throw UnsupportedError('Not supported on this platform.');
}
