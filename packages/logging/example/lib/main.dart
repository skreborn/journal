import 'package:journal/journal.dart';
import 'package:journal_logging/journal_logging.dart';
import 'package:journal_stdio/journal_stdio.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  Journal.outputs = const [StdioOutput()];

  Logger.root.onRecord.map(loggingToJournal).listen(Journal.record);

  final logger = Logger('example');

  logger.info('This is a log message.');
}
