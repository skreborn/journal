# Journal

A simple log writer and subscriber usable both from libraries and applications.

## Example

To create a journal, simply instantiate `Journal` with a unique name, normally the name of the
package that emits the entries.

```dart
import 'package:journal/journal.dart';

const journal = Journal('http_server');
```

Following that, you can simply log entries.

```dart
journal.info('Started HTTP server.', values: {'port': port.toJournal});

if (address.isUnbound) {
  journal.warn('Be careful when not binding the server to a concrete address.');
}
```

## Default output

The default output uses a pretty-printed format on all supported platforms.

_Note that you might need to set `Journal.forceFormatTerminalOutput` to get properly formatted
output in your terminal._

<p align="center">
  <img src="https://raw.githubusercontent.com/skreborn/journal/master/assets/terminal.png" style="max-width: 100%">
  <br>
  <em>Default output in Windows Terminal</em>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/skreborn/journal/master/assets/web-firefox.png" style="max-width: 100%">
  <br>
  <em>Default output in Mozilla Firefox</em>
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/skreborn/journal/master/assets/web-chrome.png" style="max-width: 100%">
  <br>
  <em>Default output in Google Chrome</em>
</p>

## Configuration

To configure `journal`, you can either implement your own `JournalOutput` or override the parameters
of the default one.

```dart
Journal.outputs = const [
  DefaultJournalOutput(
    displayTimestamp: true,
    displayLevel: true,
    displayZone: false,
    displayName: true,
    displayTrace: true,
  ),
];
```

## Compatibility

For compatibility with the `logging` package, simply direct its records to `journal`.

```dart
import 'package:logging/logging.dart'

Logger.root.onRecord.listen((record) {
  Journal.record(
    record.loggerName,
    JournalEntry.fromLogging(record),
  );
});
```

## Release history

See the [changelog] for a detailed list of changes throughout the package's history.

[changelog]: https://github.com/skreborn/journal/blob/master/CHANGELOG.md
