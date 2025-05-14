# Journal adapter for `logging`

[`logging`] compatibility adapter for [`journal`].

[`logging`]: https://pub.dev/packages/logging
[`journal`]: https://pub.dev/packages/journal

## Usage

To record the output of `logging`, simply direct its entries to `journal`.

```dart
import 'package:journal/journal.dart';
import 'package:journal_logging/journal_logging.dart';
import 'package:logging/logging.dart';

Logger.root.onRecord.map(loggingToJournal).listen(Journal.record);
```

## Release history

See the [changelog](CHANGELOG.md) for a detailed list of changes throughout the package's history.
