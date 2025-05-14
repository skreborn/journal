# Journal standard IO output

An output targeting standard IO for [`journal`].

**Writes entries to the standard output.**

Supports both pretty, formatted, human-readable, as well as plain JSON output out of the box.

This package only works on platforms with standard IO available.
In all other environments, it simply ignores the output.

Published to [the pub.dev package registry][registry].

[`journal`]: https://pub.dev/packages/journal
[registry]: https://pub.dev/packages/journal_stdio

## Usage

To use this output, add it to `Journal.outputs`.

```dart
import 'package:journal/journal.dart';
import 'package:journal_stdio/journal_stdio.dart';

Journal.outputs = const [StdioOutput()];
```

The default output is pretty, formatted, and human-readable.

_Note that you might need to set `forceFormat` to get properly formatted output in your terminal._

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="https://asciinema.org/a/yssRVNfkYQUigFvYUQkJ2YNI5">
    <img alt="Default output" src="https://asciinema.org/a/yssRVNfkYQUigFvYUQkJ2YNI5.svg" style="max-width: 100%;">
  </a>
</p>

Alternatively, a plain JSON output is also available as `jsonFormatter`.

<p align="center">
  <a target="_blank" rel="noopener noreferrer" href="https://asciinema.org/a/51uq1Ut5eDncgRicI8r8k4mJk">
    <img alt="JSON output" src="https://asciinema.org/a/51uq1Ut5eDncgRicI8r8k4mJk.svg" style="max-width: 100%;">
  </a>
</p>

## Release history

See the [changelog](CHANGELOG.md) for a detailed list of changes throughout the package's history.
