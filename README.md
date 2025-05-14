# Journal

A simple log recorder usable both from libraries and applications.

Published to [the pub.dev package registry][registry].

[registry]: https://pub.dev/packages/journal

## Usage from both libraries and applications

As a library developer, you don't need to be concerned with where the logs will end up. If you're
developing an application, make sure also read [Usage from applications](#usage-from-applications).

To create a journal, simply instantiate `Journal` with a unique name - normally the name of the
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

## Usage from applications

As an application developer, it's your responsibility to configure the global `Journal`.

### Setting up outputs

To make use of `journal` in an application, at least one output should be configured.
See [First party outputs](#first-party-outputs) for some options.

```dart
import 'package:journal_stdio/journal_stdio.dart';

Journal.outputs = const [StdioOutput()];
```

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="https://asciinema.org/a/yssRVNfkYQUigFvYUQkJ2YNI5">
    <img alt="Default standard IO output" src="https://asciinema.org/a/yssRVNfkYQUigFvYUQkJ2YNI5.svg" style="max-width: 100%;">
  </a>
</p>

### Additional context

Context may be added to a `Journal` instance using `withContext`.

```dart
journal.withContext(
  Context.trace('connection', {'client': client.address.toString().toJournal}),
  (journal) => journal.debug('Client connected.'),
);
```

### Filtering output

Filtering is useful when you don't necessarily want to display all logs.
By default, no filtering is applied.

Filtering applies to both contexts and entries separately:

- When using `withContext`, the `Context` will only be applied if the filter allows it based on its
  `name` and `level`.
- When using `log` (or any of its wrappers), it will only be forwarded to the configured outputs if
  the filter allows it based on the `name` of the `Journal` used and the `level` specified.

`journal` comes with a built-in filter generator function called `levelFilter` that allows you to
set up a simple filter.

```dart
Journal.filter = levelFilter(Level.info);
```

## First party outputs

`journal` has a few officially supported outputs:

- [`journal_android`]: an output targeting Android devices.
- [`journal_stdio`]: an output targeting standard IO.
- [`journal_web`]: an output targeting Javascript environments.

[`journal_android`]: https://pub.dev/packages/journal_android
[`journal_stdio`]: https://pub.dev/packages/journal_stdio
[`journal_web`]: https://pub.dev/packages/journal_web

## Compatibility with `logging`

`journal` provides a compatibility adapter usable with `logging`.
See the [`journal_logging`] package if any of your dependencies are using `logging` or you're
gradually migrating your own logs.

[`journal_logging`]: https://pub.dev/packages/journal_logging

## Release history

See the [changelog](CHANGELOG.md) for a detailed list of changes throughout the package's history.
