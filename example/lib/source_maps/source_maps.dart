// ignore: always_use_package_imports
import 'source_maps_web.dart' if (dart.library.io) 'source_maps_io.dart';

Future<void> loadSourceMaps() async => loadSourceMapsImpl();
