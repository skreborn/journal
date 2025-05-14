import 'package:journal/src/level.dart';
import 'package:journal/src/output.dart';
import 'package:meta/meta.dart';

/// Coloring specification for a [Span].
@immutable
final class SpanColor {
  /// Source to use with [target].
  final Level source;

  /// What to color according to [source].
  final SpanColorTarget target;

  /// Creates a new [SpanColor] with [source] and [target].
  const SpanColor(this.source, this.target);

  /// Returns the [String] representation of `this`.
  @override
  String toString() => 'SpanColor(source: $source, target: $target)';
}

/// What to color in a [Span].
enum SpanColorTarget {
  /// Color the foreground according to [SpanColor.source] and leave the background color unchanged.
  foreground,

  /// Color the background according to [SpanColor.source] and use an appropriately contrasting
  /// color for the foreground.
  background;

  @override
  String toString() => name;
}

/// A generic formatted span of text.
///
/// The definitions of the different styles and whether they are used at all are dependent on the
/// [Output] used.
@immutable
final class Span {
  /// Text content.
  final String text;

  /// Coloring specification, if any.
  final SpanColor? color;

  /// Whether the content is bold.
  final bool isBold;

  /// Whether the content is dim.
  final bool isDim;

  /// Whether the content is emphasized.
  final bool isEmphasized;

  /// Creates a new [Span] of [text].
  const Span(
    this.text, {
    this.color,
    this.isBold = false,
    this.isDim = false,
    this.isEmphasized = false,
  });

  /// Creates a new [Span] of a single space (`' '`) character.
  const Span.space() : this(' ');

  /// Creates a new [Span] of a single line break (`'\n'`) character.
  const Span.lineBreak() : this('\n');

  /// Returns the [String] representation of `this`.
  @override
  String toString() {
    final props = {
      'text': text,
      'color': color,
      'isBold': isBold,
      'isDim': isDim,
      'isEmphasized': isEmphasized,
    }.entries.map((prop) => '${prop.key}: ${prop.value ?? 'n/a'}').join(', ');

    return 'Span($props)';
  }
}
