/// A simple log writer and subscriber usable both from libraries and applications.
///
/// # Examples
///
/// To create a journal, simply instantiate [Journal] with a unique name, normally the name of the
/// package that emits the entries.
///
/// ```dart
/// import 'package:journal/journal.dart';
///
/// const journal = Journal('http_server');
/// ```
///
/// Following that, you can simply log entries.
///
/// ```dart
/// journal.info('Started HTTP server.', values: {'port': port.toJournal});
///
/// if (address.isUnbound) {
///   journal.warn('Be careful when not binding the server to a concrete address!');
/// }
/// ```
library journal;

export 'src/default_output/default_output.dart';
export 'src/entry.dart';
export 'src/journal.dart';
export 'src/level.dart';
export 'src/output.dart';
export 'src/value.dart';

const zoneNameKey = #_journalZoneName;
