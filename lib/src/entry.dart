import 'package:journal/src/journal.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/value.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

/// A single log entry.
@immutable
final class Entry {
  /// Name of the [Journal] used to record `this`.
  final String name;

  /// Time of creation.
  final DateTime time;

  /// Category and granularity.
  final Level level;

  /// Additional context, if any.
  final List<Context> context;

  /// Plain-text description.
  final String message;

  /// Additional values.
  final Map<String, Value?> values;

  /// Captured stack trace, if any.
  final Trace? trace;

  /// Creates a new [Entry] at [time] and [level] with [message].
  const Entry({
    required this.name,
    required this.time,
    required this.level,
    required this.context,
    required this.message,
    required this.values,
    this.trace,
  });

  /// Returns the [String] representation of `this`.
  @override
  String toString() {
    final props = {
      'name': name,
      'time': time.toIso8601String(),
      'level': level.name,
      'context': context.toString(),
      'message': message,
      'values': values.toString(),
      'trace': trace?.frames.toString(),
    }.entries.map((prop) => '${prop.key}: ${prop.value ?? 'n/a'}').join(', ');

    return 'Entry($props)';
  }
}
