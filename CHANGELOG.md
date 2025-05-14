## 0.4.0

This is a rewrite of almost every part of the library for greater modularity.

**Everything about this release is a breaking change.** Classes were renamed, moved, created, and
removed. In a lot of cases, the `Journal` prefix went away. If you have name collisions, use import
aliasing or `show`/`hide`.

`journal` now requires Dart 3.7.

The developer-facing utilities were reorganized into the main `journal` library and the separate
`developer` one was dropped.

`DefaultOutput` was separated into `StdioOutput` and `WebOutput`, and all `Output` implementations,
as well as the `logging` compatibility adapter, were moved to separate packages.

Support for contextual information was added. This makes it possible to provide additional values to
any number of logs recorded within its scope.

The filtering function changed from a simple `level` comparison (`minimumLevel`) to a function that
takes both `level` and `name` into account to determine whether a given context or entry will be
allowed.

Zone support was removed entirely. Use contexts instead.

The default output format has slightly changed for all outputs - mostly to include support for
contexts. The standard IO output now also comes with a JSON output format. All outputs are now also
vastly more customizable.

Outputs incompatible with the target system no longer need to be conditionally included - they now
do this internally so they're simply ignored on unsupported targets.

## 0.3.0

- **\[BREAKING\]** Require Dart 3.3.
- **\[BREAKING\]** Remove source map support.

## 0.2.0

- **\[BREAKING\]** Use the constant symbol `zoneNameKey` instead of the literal `#journalName`
  to specify the name of a `Zone`.
- Fix `JournalEntry.level` being unconditionally formatted.
- Introduce `developer` library.
- Introduce `android` library and `AndroidJournalOutput`.

## 0.1.0

Initial release.
