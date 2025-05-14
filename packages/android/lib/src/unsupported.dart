import 'package:journal/journal.dart';
import 'package:journal_android/journal_android.dart';

/// {@macro interface/AndroidOutputInterface}
final class AndroidOutput extends AndroidOutputInterface {
  @override
  bool get isSupported => false;

  /// {@macro interface/AndroidOutputInterface/AndroidOutputInterface}
  const AndroidOutput({
    super.formatter,
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
