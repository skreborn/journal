// ignore_for_file: public_member_api_docs

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:journal/src/default_output/spans.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/value.dart';
import 'package:stack_trace/stack_trace.dart';
import 'package:web/web.dart';

extension on $Console {
  @JS('log')
  external void logWithMessage(JSString message, [JSAny? value]);
}

void writeImpl(
  String name,
  JournalEntry entry, {
  required bool displayTimestamp,
  required bool displayLevel,
  required bool displayZone,
  required bool displayName,
  required bool displayTrace,
}) {
  final trace = entry.trace;

  String createStyle(Map<String, String> properties) {
    return properties.entries.map((property) => '${property.key}: ${property.value}').join('; ');
  }

  JSAny? toJs(JournalValue? value) {
    switch (value) {
      case null:
        return null;
      case BoolJournalValue(:final inner):
        return inner.toJS;
      case IntJournalValue(:final inner):
        return inner.toJS;
      case DoubleJournalValue(:final inner):
        return inner.toJS;
      case StringJournalValue(:final inner):
        return inner.toJS;
      case IterableJournalValue(:final inner):
        final iterator = inner.iterator;
        final array = JSArray();

        for (var i = 0; iterator.moveNext(); ++i) {
          array.setProperty(i.toJS, toJs(iterator.current));
        }

        return array;
      case EntriesJournalValue(:final inner):
        final entries = JSObject();

        for (final entry in inner) {
          entries.setProperty(entry.key.toJS, toJs(entry.value));
        }

        return entries;
    }
  }

  String createFormat(Span span) => span is SpacingSpan ? '%c ' : '%c%s';

  List<String> createArguments(Span span) {
    switch (span) {
      case SpacingSpan():
        return const [''];
      case LevelSpan(:final level):
        return [
          createStyle({
            'text-transform': 'uppercase',
            // ignore: unused_result
            'background': switch (entry.level) {
              JournalEntryLevel.error => '#a12',
              JournalEntryLevel.warn => '#970',
              JournalEntryLevel.info => '#071',
              JournalEntryLevel.debug => '#23c',
              JournalEntryLevel.trace => '#71b',
            },
            'font-weight': 'bold',
            'border-radius': '4px',
            'padding': '2px 6px',
            'color': '#fff',
          }),
          level.name,
        ];
      case TextSpan(:final text, :final isBold, :final isDim, :final isEmphasized):
        return [
          createStyle({
            'font-weight': isBold ? 'bold' : 'normal',
            'color': isDim ? 'color-mix(in srgb, currentColor 50%, transparent)' : 'currentColor',
            'font-style': isEmphasized ? 'italic' : 'normal',
          }),
          text,
        ];
    }
  }

  final hasDetails = entry.values.isNotEmpty || (displayTrace && trace != null);

  final message = formatMessage(
    name,
    entry,
    displayTimestamp: displayTimestamp,
    displayLevel: displayLevel,
    displayZone: displayZone,
    displayName: displayName,
  );

  console.callMethodVarArgs(hasDetails ? 'groupCollapsed'.toJS : 'log'.toJS, [
    message.map(createFormat).join().toJS,
    ...message.expand(createArguments).map((arg) => arg.toJS),
  ]);

  if (hasDetails) {
    if (entry.values.isNotEmpty) {
      console.logWithMessage('Values:'.toJS, toJs(entry.values.toJournal));
    }

    if (displayTrace && trace != null) {
      console.groupCollapsed('Stack trace'.toJS);

      final formatted = formatTrace(Trace.from(trace).terse);

      console.callMethodVarArgs('log'.toJS, [
        formatted.map((line) => line.map(createFormat).join('')).join('\n').toJS,
        ...formatted.expand((line) => line.expand(createArguments)).map((arg) => arg.toJS),
      ]);

      console.groupEnd();
    }

    console.groupEnd();
  }
}
