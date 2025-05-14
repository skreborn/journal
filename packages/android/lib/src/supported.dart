import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';

import 'package:journal/journal.dart';
import 'package:journal_android/journal_android.dart';

final class _LogMessage extends Struct {
  @Size()
  external int structSize;

  @Int32()
  external int bufferId;

  @Int32()
  external int prority;

  external Pointer<Utf8> tag;

  external Pointer<Utf8> file;

  @Uint32()
  external int line;

  external Pointer<Utf8> message;
}

@Native<Int Function(Pointer<Utf8> key, Pointer<Utf8> value)>(
  symbol: '__system_property_get',
  isLeaf: true,
)
external int _getProperty(Pointer<Utf8> key, Pointer<Utf8> value);

@Native<Int Function(Int prio, Pointer<Utf8> tag, Pointer<Utf8> text)>(
  symbol: '__android_log_write',
  isLeaf: true,
)
external int _writeLog(int prio, Pointer<Utf8> tag, Pointer<Utf8> text);

@Native<Int Function(Int prio, Pointer<Utf8> tag, Int defaultPrio)>(
  symbol: '__android_log_is_loggable',
  isLeaf: true,
)
external int _isLoggable(int prio, Pointer<Utf8> tag, int defaultPrio);

@Native<Void Function(Pointer<_LogMessage> logMessage)>(
  symbol: '__android_log_write_log_message',
  isLeaf: true,
)
external void _writeLogAdvanced(Pointer<_LogMessage> logMessage);

extension on Level {
  int get priority {
    return switch (this) {
      Level.trace => 2,
      Level.debug => 3,
      Level.info => 4,
      Level.warn => 5,
      Level.error => 6,
    };
  }
}

/// {@macro interface/AndroidOutputInterface}
final class AndroidOutput extends AndroidOutputInterface {
  static final int? _sdkVersion = _getSdkVersion();

  static String? _readProperty(String key, {Allocator allocator = malloc}) {
    final keyPtr = key.toNativeUtf8(allocator: allocator);
    final valuePtr = allocator.allocate(92).cast<Utf8>();

    final length = _getProperty(keyPtr, valuePtr);
    final result = valuePtr.toDartString(length: length);

    allocator.free(keyPtr);
    allocator.free(valuePtr);

    return result.isNotEmpty ? result : null;
  }

  static int? _getSdkVersion() {
    if (Platform.isAndroid) {
      final sdkVersionString = _readProperty('ro.build.version.sdk');

      return sdkVersionString != null ? int.parse(sdkVersionString) : null;
    }

    return null;
  }

  @override
  bool get isSupported => _sdkVersion != null;

  /// {@macro interface/AndroidOutputInterface/AndroidOutputInterface}
  const AndroidOutput({
    super.formatter,
    super.displayContext,
    super.displayContextValues,
    super.displayValues,
    super.displayTrace,
  });

  @override
  void write(Entry entry) {
    String strip(Span span) => span.text;

    final message = formatter(
      level: entry.level,
      context: entry.context,
      message: entry.message,
      values: entry.values,
      trace: entry.trace,
      displayContext: displayContext,
      displayContextValues: displayContextValues,
      displayValues: displayValues,
      displayTrace: displayTrace,
    );

    final file = entry.trace?.frames.firstOrNull?.uri.toString();
    final line = entry.trace?.frames.firstOrNull?.line;

    using((arena) {
      const minLevel = Level.trace;

      final namePtr = entry.name.toNativeUtf8(allocator: arena);
      final messagePtr = message.map(strip).join().toNativeUtf8(allocator: arena);

      final sdkVersion = _sdkVersion ?? -1;

      if (sdkVersion < 30) {
        _writeLog(entry.level.priority, namePtr, messagePtr);
      } else if (_isLoggable(entry.level.priority, namePtr, minLevel.priority) != 0) {
        const mainBufferId = 0;

        final message = arena<_LogMessage>();

        message.ref
          ..structSize = sizeOf<_LogMessage>()
          ..bufferId = mainBufferId
          ..prority = entry.level.priority
          ..tag = namePtr
          ..file = file?.toNativeUtf8(allocator: arena) ?? nullptr
          ..line = line ?? 0
          ..message = messagePtr;

        _writeLogAdvanced(message);
      }
    });
  }

  @override
  String toString() {
    final props = {
      'displayContext': displayContext.toString(),
      'displayContextValues': displayContextValues.toString(),
      'displayValues': displayValues.toString(),
      'displayTrace': displayTrace.toString(),
    }.entries.map((prop) => '${prop.key}: ${prop.value}').join(', ');

    return 'AndroidOutput($props)';
  }
}
