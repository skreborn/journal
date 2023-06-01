import 'dart:html';

import 'package:journal/journal.dart';
import 'package:source_maps/source_maps.dart' as source_maps;

Future<void> loadSourceMapsImpl() async {
  if (window.location.protocol != 'file:') {
    const map = 'build/example.js.map';

    final base = Uri.parse(document.baseUri!);

    Journal.sourceMapSettings = JournalSourceMapSettings(
      mapping: source_maps.parse(
        await HttpRequest.getString(map),
        mapUrl: base.resolve(map),
      ),
    );
  }
}
