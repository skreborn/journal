import 'package:journal/journal.dart';
import 'package:journal_web/journal_web.dart';

/// {@macro interface/WebOutputInterface}
final class WebOutput extends WebOutputInterface {
  @override
  bool get isSupported => false;

  /// {@macro interface/WebOutputInterface/WebOutputInterface}
  const WebOutput({
    super.levelSerializer,
    super.messageFormatter,
    super.contextFormatter,
    super.traceFormatter,
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
