import 'package:journal/src/entry.dart';
import 'package:meta/meta.dart';

/// A [MapEntry] of [String] and optional [Value] pairs.
typedef ValueEntry = MapEntry<String, Value?>;

/// A value to be used in an [Entry].
@immutable
sealed class Value {
  const Value();

  /// Creates a new [BoolValue] from [inner].
  const factory Value.bool(bool inner) = BoolValue;

  /// Creates a new [IntValue] from [inner].
  const factory Value.int(int inner) = IntValue;

  /// Creates a new [DoubleValue] from [inner].
  const factory Value.double(double inner) = DoubleValue;

  /// Creates a new [StringValue] from [inner].
  const factory Value.string(String inner) = StringValue;

  /// Creates a new [IterableValue] from [inner].
  const factory Value.iterable(Iterable<Value?> inner) = IterableValue;

  /// Creates a new [EntriesValue] from [inner].
  const factory Value.entries(Iterable<ValueEntry> inner) = EntriesValue;

  /// Creates a new [Value] from [object] by recursively converting it to the appopriate
  /// subtype.
  ///
  /// If [object] or any of its descendants can not be converted to [Value], their [String]
  /// representations will be used instead.
  factory Value.from(Object object) {
    switch (object) {
      case final Value value:
        return value;
      case final Map<Object, Object?> map:
        return Value.entries(
          map.entries.map((entry) {
            final value = entry.value;

            return MapEntry(entry.key.toString(), value != null ? Value.from(value) : null);
          }),
        );
      case final Iterable<MapEntry<Object, Object?>> entries:
        return Value.entries(
          entries.map((entry) {
            final value = entry.value;

            return MapEntry(entry.key.toString(), value != null ? Value.from(value) : null);
          }),
        );
      case final Iterable<Object?> iterable:
        return Value.iterable(
          iterable.map((value) {
            return value != null ? Value.from(value) : null;
          }),
        );
      case final bool value:
        return Value.bool(value);
      case final int value:
        return Value.int(value);
      case final double value:
        return Value.double(value);
      case final String value:
        return Value.string(value);
      case final other:
        return Value.string(other.toString());
    }
  }

  /// Returns the [String] representation of `this`.
  @override
  @mustBeOverridden
  String toString();
}

/// A [Value] containing a [bool] value.
final class BoolValue extends Value {
  /// Contained value.
  final bool inner;

  /// Creates a new [BoolValue] from [inner].
  const BoolValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert a [bool] value to a [Value].
extension ValueFromBool on bool {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.bool(this);
}

/// A [Value] containing an [int] value.
final class IntValue extends Value {
  /// Contained value.
  final int inner;

  /// Creates a new [IntValue] from [inner].
  const IntValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert an [int] value to a [Value].
extension ValueFromInt on int {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.int(this);
}

/// A [Value] containing a [double] value.
final class DoubleValue extends Value {
  /// Contained value.
  final double inner;

  /// Creates a new [DoubleValue] from [inner].
  const DoubleValue(this.inner);

  @override
  String toString() => inner.toString();
}

/// An extension to convert a [double] value to a [Value].
extension ValueFromDouble on double {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.double(this);
}

/// A [Value] containing a [String] value.
final class StringValue extends Value {
  /// Contained value.
  final String inner;

  /// Creates a new [StringValue] from [inner].
  const StringValue(this.inner);

  @override
  String toString() => inner;
}

/// An extension to convert a [String] value to a [Value].
extension ValueFromString on String {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.string(this);
}

/// A [Value] containing an [Iterable] of optional [Value] objects.
final class IterableValue extends Value {
  /// Contained value.
  final Iterable<Value?> inner;

  /// Creates a new [IterableValue] from [inner].
  const IterableValue(this.inner);

  @override
  String toString() => '[${inner.join(', ')}]';
}

/// An extension to convert an [Iterable] of optional [Value] objects to a [Value].
extension ValueFromIterable on Iterable<Value?> {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.iterable(this);
}

/// A [Value] containing an [Iterable] of [ValueEntry] objects.
final class EntriesValue extends Value {
  /// Contained value.
  final Iterable<ValueEntry> inner;

  /// Creates a new [EntriesValue] from [inner].
  const EntriesValue(this.inner);

  @override
  String toString() => '{${inner.map((entry) => '${entry.key}: ${entry.value}').join(', ')}}';
}

/// An extension to convert an [Iterable] of [ValueEntry] objects to a [Value].
extension ValueFromEntries on Iterable<ValueEntry> {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.entries(this);
}

/// An extension to convert a [Map] of [String] and [Value] pairs to a [Value].
extension ValueFromMap on Map<String, Value?> {
  /// Converts `this` to a [Value].
  Value get toJournal => Value.entries(entries);
}
