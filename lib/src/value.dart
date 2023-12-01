import 'package:meta/meta.dart';

/// A [MapEntry] of [String] and optional [JournalValue] pairs.
typedef JournalValueEntry = MapEntry<String, JournalValue?>;

/// A value to be used in a [JournalEntry].
@immutable
sealed class JournalValue {
  const JournalValue();

  /// Creates a new [BoolJournalValue] from [inner].
  const factory JournalValue.bool(bool inner) = BoolJournalValue;

  /// Creates a new [IntJournalValue] from [inner].
  const factory JournalValue.int(int inner) = IntJournalValue;

  /// Creates a new [DoubleJournalValue] from [inner].
  const factory JournalValue.double(double inner) = DoubleJournalValue;

  /// Creates a new [StringJournalValue] from [inner].
  const factory JournalValue.string(String inner) = StringJournalValue;

  /// Creates a new [IterableJournalValue] from [inner].
  const factory JournalValue.iterable(Iterable<JournalValue?> inner) = IterableJournalValue;

  /// Creates a new [EntriesJournalValue] from [inner].
  const factory JournalValue.entries(Iterable<JournalValueEntry> inner) = EntriesJournalValue;

  /// Creates a new [JournalValue] from [object] by recursively converting it to the appopriate
  /// subtype.
  ///
  /// If [object] or any of its descendants can not be converted to [JournalValue], their [String]
  /// representations will be used instead.
  factory JournalValue.from(Object object) {
    switch (object) {
      case final JournalValue value:
        return value;
      case final Map<Object, Object?> map:
        return JournalValue.entries(map.entries.map((entry) {
          final value = entry.value;

          return MapEntry(entry.key.toString(), value != null ? JournalValue.from(value) : null);
        }));
      case final Iterable<MapEntry<Object, Object?>> entries:
        return JournalValue.entries(entries.map((entry) {
          final value = entry.value;

          return MapEntry(entry.key.toString(), value != null ? JournalValue.from(value) : null);
        }));
      case final Iterable<Object?> iterable:
        return JournalValue.iterable(iterable.map((value) {
          return value != null ? JournalValue.from(value) : null;
        }));
      case final bool value:
        return JournalValue.bool(value);
      case final int value:
        return JournalValue.int(value);
      case final double value:
        return JournalValue.double(value);
      case final String value:
        return JournalValue.string(value);
      case final other:
        return JournalValue.string(other.toString());
    }
  }

  /// Returns the [String] representation of `this`.
  @override
  @useResult
  @mustBeOverridden
  String toString();
}

/// A [JournalValue] containing a [bool] value.
final class BoolJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final bool inner;

  /// Creates a new [BoolJournalValue] from [inner].
  const BoolJournalValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert a [bool] value to a [JournalValue].
extension JournalValueFromBool on bool {
  /// Converts `this` to a [JournalValue].
  @useResult
  JournalValue get toJournal => JournalValue.bool(this);
}

/// A [JournalValue] containing an [int] value.
final class IntJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final int inner;

  /// Creates a new [IntJournalValue] from [inner].
  const IntJournalValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert a [int] value to a [JournalValue].
extension JournalValueFromInt on int {
  /// Converts `this` to a [JournalValue].
  @useResult
  JournalValue get toJournal => JournalValue.int(this);
}

/// A [JournalValue] containing a [double] value.
final class DoubleJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final double inner;

  /// Creates a new [DoubleJournalValue] from [inner].
  const DoubleJournalValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert a [double] value to a [JournalValue].
extension JournalValueFromDouble on double {
  /// Converts `this` to a [JournalValue].
  @useResult
  JournalValue get toJournal => JournalValue.double(this);
}

/// A [JournalValue] containing a [String] value.
final class StringJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final String inner;

  /// Creates a new [StringJournalValue] from [inner].
  const StringJournalValue(this.inner);

  @override
  String toString() => inner;
}

/// An extension to convert a [String] value to a [JournalValue].
extension JournalValueFromString on String {
  /// Converts `this` to a [JournalValue].
  @useResult
  JournalValue get toJournal => JournalValue.string(this);
}

/// A [JournalValue] containing an [Iterable] of optional [JournalValue] objects.
final class IterableJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final Iterable<JournalValue?> inner;

  /// Creates a new [IterableJournalValue] from [inner].
  const IterableJournalValue(this.inner);

  @override
  String toString() => '[${inner.join(', ')}]';
}

/// An extension to convert an [Iterable] of optional [JournalValue] objects to a [JournalValue].
extension JournalValueFromIterable on Iterable<JournalValue?> {
  /// Converts `this` to a [JournalValue].
  @useResult
  JournalValue get toJournal => JournalValue.iterable(this);
}

/// A [JournalValue] containing an [Iterable] of [JournalValueEntry] objects.
final class EntriesJournalValue extends JournalValue {
  /// The contained value.
  @useResult
  final Iterable<JournalValueEntry> inner;

  /// Creates a new [EntriesJournalValue] from [inner].
  const EntriesJournalValue(this.inner);

  @override
  String toString() => '{${inner.map((entry) => '${entry.key}: ${entry.value}').join(', ')}}';
}

/// An extension to convert an [Iterable] of [JournalValueEntry] objects to a [JournalValue].
extension JournalValueFromEntries on Iterable<JournalValueEntry> {
  @useResult

  /// Converts `this` to a [JournalValue].
  JournalValue get toJournal => JournalValue.entries(this);
}

/// An extension to convert a [Map] of [String] and [JournalValue] pairs to a [JournalValue].
extension JournalValueFromMap on Map<String, JournalValue?> {
  @useResult

  /// Converts `this` to a [JournalValue].
  JournalValue get toJournal => JournalValue.entries(entries);
}
