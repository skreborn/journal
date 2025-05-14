import 'package:journal/journal.dart';
import 'package:logging/logging.dart' as logging;
import 'package:stack_trace/stack_trace.dart';

/// Creates a new [Entry] from [record].
Entry loggingToJournal(logging.LogRecord record) {
  final values = switch (record.object) {
    null => const <String, Value>{},
    final Map<Object?, Object?> map => map.map((key, value) {
      return MapEntry(key.toString(), value != null ? Value.from(value) : null);
    }),
    final other => {'value': Value.from(other)},
  };

  final error = record.error;
  final stackTrace = record.stackTrace;

  return Entry(
    name: record.loggerName,
    time: record.time,
    level: switch (record.level.value) {
      < 500 => Level.trace,
      < 800 => Level.debug,
      < 900 => Level.info,
      < 1000 => Level.warn,
      _ => Level.error,
    },
    context: const [],
    message: record.message,
    values: {...values, if (error != null) '_error': Value.from(error)},
    trace: stackTrace != null ? Trace.from(stackTrace).terse : null,
  );
}
