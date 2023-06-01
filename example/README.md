# Example

## Native

Running on native platforms is straightforward.

```sh
dart run lib/main.dart
```

## Web

For the web platform the Dart code has to be compiled to JavaScript first.

```sh
dart compile js -o build/example.js lib/main.dart
```

Afterwards, opening _example.html_ in your browser should display the generated logs in its
developer console.

### Source maps

Modern browsers refuse to load source maps from local files. To work around this, you will have to
start a local server that serves both _example.html_ and the _build_ folder. The included example
will check to make sure you're accessing the page on a protocol other than `file:` and automatically
load the associated source map if so.
