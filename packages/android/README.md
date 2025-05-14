# Journal Android output

An output targeting Android devices for [`journal`].

**Writes entries [using native functions][ndk-logging].**
[Logcat] may be used to observe its output.

This package only works on Android devices.
In all other environments, it simply ignores the output.

Published to [the pub.dev package registry][registry].

[`journal`]: https://pub.dev/packages/journal
[ndk-logging]: https://developer.android.com/ndk/reference/group/logging
[Logcat]: https://developer.android.com/tools/logcat
[registry]: https://pub.dev/packages/journal_android

## Usage

To use this output, add it to `Journal.outputs`.

```dart
import 'package:journal/journal.dart';
import 'package:journal_android/journal_android.dart';

Journal.outputs = const [AndroidOutput()];
```

## Release history

See the [changelog](CHANGELOG.md) for a detailed list of changes throughout the package's history.
