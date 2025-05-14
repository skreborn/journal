// ignore_for_file: public_member_api_docs

import 'package:journal/journal.dart';
import 'package:journal_example/example.dart';
import 'package:journal_web/journal_web.dart';

Future<void> main() async {
  Journal.outputs = const [WebOutput()];

  await run();
}
