import 'package:journal/src/cell.dart';
import 'package:journal/src/level.dart';

/// Timestamp serializer function.
typedef TimestampSerializer = Cell Function(DateTime value);

/// [ISO 8601][standard] timestamp serializer function.
///
/// Serializes timestamps using [DateTime.toIso8601String].
///
/// [standard]: https://www.iso.org/iso-8601-date-and-time-format.html
Cell iso8601TimestampSerializer(DateTime value) {
  return Cell.bounded(value.toIso8601String(), 26);
}

/// Level serializer function.
typedef LevelSerializer = Cell Function(Level level);

/// Default level serializer function.
Cell defaultLevelSerializer(Level level) {
  return Cell.bounded(switch (level) {
    Level.trace => 'TRACE',
    Level.debug => 'DEBUG',
    Level.info => 'INFO',
    Level.warn => 'WARN',
    Level.error => 'ERROR',
  }, 5);
}
