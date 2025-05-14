// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:journal/journal.dart';
import 'package:journal_android/journal_android.dart';
import 'package:journal_example/example.dart';

void main() {
  Journal.outputs = const [AndroidOutput()];

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var _isRunning = false;

  Future<void> _handle() async {
    setState(() => _isRunning = true);

    await run();

    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16,
            children: [
              const Text('Press the button to run the example scenario.'),
              IconButton.filled(
                icon:
                    _isRunning
                        ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator())
                        : const Icon(Icons.rocket),
                onPressed: _isRunning ? null : _handle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
