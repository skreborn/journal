import 'package:meta/meta.dart';

/// Alignment specifier to be used with [Cell.format].
enum CellAlignment {
  /// Align content on the left.
  ///
  /// Padding will be added on the right.
  left,

  /// Align content to the center.
  ///
  /// Padding will be added equallity to both sides.
  ///
  /// If the padding is not evenly divisible, the extra padding will be added on the left.
  center,

  /// Align content to the right.
  ///
  /// Padding will be added on the left.
  right,
}

/// A cell in tabular data.
@immutable
final class Cell {
  /// Text content.
  final String content;

  /// Maximum [rune] count, if bounded.
  ///
  /// [rune]: https://api.flutter.dev/flutter/dart-core/Runes-class.html
  final int? maxLength;

  /// Creates a new [Cell] with [content] bounded to [maxLength].
  const Cell.bounded(this.content, this.maxLength);

  /// Creates a new unbounded [Cell] with [content].
  const Cell.unbounded(this.content) : maxLength = null;

  /// Formats [content] according to the [alignment].
  ///
  /// [padding] will be repeated to fill the available space.
  String format(CellAlignment alignment, [String padding = ' ']) {
    final maxLength = this.maxLength;

    if (maxLength == null) {
      return content;
    }

    final contentLength = content.runes.length;

    if (contentLength > maxLength) {
      return String.fromCharCodes(content.runes.take(maxLength));
    }

    final difference = maxLength - contentLength;

    final filling = Iterable<int>.generate(difference).expand((_) => padding.runes);

    switch (alignment) {
      case CellAlignment.left:
        return String.fromCharCodes(content.runes.followedBy(filling.take(difference)));
      case CellAlignment.center:
        return String.fromCharCodes(
          filling
              .take((difference / 2).ceil())
              .followedBy(content.runes)
              .followedBy(filling.take((difference / 2).floor())),
        );
      case CellAlignment.right:
        return String.fromCharCodes(filling.take(difference).followedBy(content.runes));
    }
  }

  @override
  String toString() => 'Cell(content: $content, maxLength: ${maxLength ?? 'n/a'})';
}
