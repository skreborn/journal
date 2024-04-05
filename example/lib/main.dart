import 'dart:async';

import 'package:journal/journal.dart';

void main() async {
  Journal.minimumLevel = JournalEntryLevel.trace;
  Journal.autoCaptureZones = true;
  Journal.forceFormatTerminalOutput = true;
  Journal.outputs = const [DefaultJournalOutput(displayZone: true)];

  const journal = Journal('example');

  for (final level in JournalEntryLevel.values) {
    if (level != JournalEntryLevel.error) {
      journal.log(level, 'This is a log message.', values: {
        'bool': true.toJournal,
        'int': 42.toJournal,
        'double': 3.14.toJournal,
        'string': 'value'.toJournal,
        'iterable': [1, 2, 3].map(JournalValue.int).toJournal,
        'entries': {'a': 1, 'b': 2, 'c': 3}.map((key, value) {
          return MapEntry(key, value.toJournal);
        }).toJournal,
      });
    }
  }

  runZoned(() {
    try {
      throw const FormatException('this does not seem right');
    } on FormatException catch (ex, trace) {
      journal.error('Caught an error.', values: {'error': ex.toString().toJournal}, trace: trace);
    }
  }, zoneValues: const {zoneNameKey: 'error-zone'});
}
