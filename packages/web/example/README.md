# Example

Compile Dart code to WebAssembly:

```sh
dart compile wasm -o web/example.wasm lib/main.dart
```

Run HTTP server:

```sh
dart pub global run dhttpd --path=web
```

Open `http://localhost:8080` in your browser to see the logs in the developer console.
