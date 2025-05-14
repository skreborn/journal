import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:journal/journal.dart';
import 'package:journal_web/journal_web.dart';
import 'package:web/web.dart';

/// {@macro interface/WebOutputInterface}
final class WebOutput extends WebOutputInterface {
  @override
  bool get isSupported => true;

  /// {@macro interface/WebOutputInterface/WebOutputInterface}
  const WebOutput({
    super.levelSerializer,
    super.messageFormatter,
    super.contextFormatter,
    super.traceFormatter,
    super.displayLevel,
    super.displayContext,
    super.displayContextValues,
    super.displayValues,
    super.displayTrace,
  });

  @override
  void write(Entry entry) {
    final context = entry.context;
    final trace = entry.trace;

    List<String> format(Span span) {
      String levelColor(Level level) => switch (level) {
        Level.error => '#a12',
        Level.warn => '#970',
        Level.info => '#071',
        Level.debug => '#23c',
        Level.trace => '#71b',
      };

      final (background, foreground) = switch (span.color) {
        null => (null, 'currentColor'),
        final color =>
          color.target == SpanColorTarget.foreground
              ? (null, levelColor(color.source))
              : (levelColor(color.source), '#fff'),
      };

      final props = {
        if (background != null) ...{
          'background': background,
          'border-radius': '4px',
          'padding': '2px 6px',
        },
        'font-weight': span.isBold ? 'bold' : 'normal',
        'color': span.isDim ? 'color-mix(in srgb, $foreground 50%, transparent)' : foreground,
      };

      return [
        props.entries.map((property) => '${property.key}: ${property.value}').join(';'),
        span.text,
      ];
    }

    List<JSAny?> toJsFormat(Iterable<Span> spans, [JSObject? object]) {
      return [
        [...spans.map((_) => '%c%s'), if (object != null) '%O'].join().toJS,
        ...spans.expand(format).map((arg) => arg.toJS),
        if (object != null) object,
      ];
    }

    JSAny? toJsValue(Value? value) {
      switch (value) {
        case null:
          return null;
        case BoolValue(:final inner):
          return inner.toJS;
        case IntValue(:final inner):
          return inner.toJS;
        case DoubleValue(:final inner):
          return inner.toJS;
        case StringValue(:final inner):
          return inner.toJS;
        case IterableValue(:final inner):
          final iterator = inner.iterator;
          final array = JSArray();

          for (var i = 0; iterator.moveNext(); ++i) {
            array[i] = toJsValue(iterator.current);
          }

          return array;
        case EntriesValue(:final inner):
          final entries = JSObject();

          for (final entry in inner) {
            entries[entry.key] = toJsValue(entry.value);
          }

          return entries;
      }
    }

    JSObject toJsValues(Map<String, Value?> values) {
      final entries = JSObject();

      for (final entry in values.entries) {
        entries[entry.key] = toJsValue(entry.value);
      }

      return entries;
    }

    final hasContext = displayContext && context.isNotEmpty;
    final hasValues = displayValues && entry.values.isNotEmpty;
    final hasTrace = displayTrace && trace != null;

    final hasDetails = hasValues || hasTrace;

    console.callMethodVarArgs(
      hasDetails ? 'groupCollapsed'.toJS : 'log'.toJS,
      toJsFormat(
        messageFormatter(
          levelSerializer: levelSerializer,
          level: entry.level,
          name: entry.name,
          message: entry.message,
          displayLevel: displayLevel,
        ),
      ),
    );

    if (hasDetails) {
      if (hasContext) {
        console.groupCollapsed(contextLabel.toJS);

        for (final entry in context) {
          final hasValues = displayContextValues && entry.values.isNotEmpty;

          console.callMethodVarArgs(
            'log'.toJS,
            toJsFormat(
              contextFormatter(
                levelSerializer: levelSerializer,
                name: entry.name,
                level: entry.level,
              ),
              hasValues ? toJsValues(entry.values) : null,
            ),
          );
        }

        console.groupEnd();
      }

      if (hasValues) {
        console.callMethodVarArgs(
          'log'.toJS,
          toJsFormat([Span(valuesLabel)], hasValues ? toJsValues(entry.values) : null),
        );
      }

      if (hasTrace) {
        console.groupCollapsed(traceLabel.toJS);
        console.callMethodVarArgs('log'.toJS, toJsFormat(traceFormatter(trace: trace)));
        console.groupEnd();
      }

      console.groupEnd();
    }
  }

  @override
  String toString() {
    final props = {
      'contextLabel': contextLabel,
      'valuesLabel': valuesLabel,
      'traceLabel': traceLabel,
      'displayLevel': displayLevel.toString(),
      'displayContext': displayContext.toString(),
      'displayContextValues': displayContextValues.toString(),
      'displayValues': displayValues.toString(),
      'displayTrace': displayTrace.toString(),
    }.entries.map((prop) => '${prop.key}: ${prop.value}').join(', ');

    return 'WebOutput($props)';
  }
}
