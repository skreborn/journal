import 'package:journal/src/level.dart';

/// Filter function.
///
/// Must return `true` for a context or entry to be allowed.
typedef Filter = bool Function(Level level, String name);

/// A [Filter] that allows all contexts and entries.
bool allowAll(Level level, String name) => true;

/// Creates a [Filter] that disallows contexts and entries with a level less than [minimumLevel].
///
/// You may use [overrides] to specify a different minimum level based on the name of the context or
/// entry.
Filter levelFilter(Level minimumLevel, [Map<String, Level> overrides = const {}]) {
  return (level, name) => level >= (overrides[name] ?? minimumLevel);
}
