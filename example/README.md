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
