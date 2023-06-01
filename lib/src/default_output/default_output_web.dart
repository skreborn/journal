// ignore_for_file: public_member_api_docs

import 'dart:html';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:journal/src/default_output/spans.dart';
import 'package:journal/src/entry.dart';
import 'package:journal/src/journal.dart';
import 'package:journal/src/level.dart';
import 'package:journal/src/value.dart';
import 'package:source_map_stack_trace/source_map_stack_trace.dart';
import 'package:stack_trace/stack_trace.dart';

@JS('Window')
@staticInterop
class _Window implements JSObject {}

extension on _Window {
  external _Console get console;
}

@JS('Console')
@staticInterop
class _Console implements JSObject {}

extension on _Console {
  external void log(JSString message, [JSAny? value]);
  external void groupCollapsed(JSString label);
  external void groupEnd();
}

@JS()
@anonymous
@staticInterop
class _Entries implements JSObject {
  external factory _Entries();
}

final _console = (window as _Window).console;

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
        final entries = _Entries();

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

  _console.callMethodVarArgs(hasDetails ? 'groupCollapsed'.toJS : 'log'.toJS, [
    message.map(createFormat).join().toJS,
    ...message.expand(createArguments).map((arg) => arg.toJS),
  ]);

  if (hasDetails) {
    if (entry.values.isNotEmpty) {
      _console.log('Values:'.toJS, toJs(entry.values.toJournal));
    }

    if (displayTrace && trace != null) {
      StackTrace tryMap(StackTrace trace) {
        final settings = Journal.sourceMapSettings;

        if (settings != null) {
          return mapStackTrace(
            settings.mapping,
            trace,
            packageMap: {for (final entry in settings.prefixes.entries) entry.value: entry.key},
            sdkRoot: Uri.parse('org-dartlang-sdk://'),
          );
        }

        return trace;
      }

      _console.groupCollapsed('Stack trace'.toJS);

      final formatted = formatTrace(Trace.from(tryMap(trace)).terse);

      _console.callMethodVarArgs('log'.toJS, [
        formatted.map((line) => line.map(createFormat).join('')).join('\n').toJS,
        ...formatted.expand((line) => line.expand(createArguments)).map((arg) => arg.toJS),
      ]);

      _console.groupEnd();
    }

    _console.groupEnd();
  }
}
