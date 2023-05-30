import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';

import 'flutter_star_printer_sdk_platform_interface.dart';

/// An implementation of [FlutterStarPrinterSdkPlatform] that uses method channels.
class MethodChannelFlutterStarPrinterSdk
    implements FlutterStarPrinterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
      'co.uk.ferns.flutter_plugins/flutter_star_printer_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> connectPrinter() {
    // TODO: implement connectPrinter
    throw UnimplementedError();
  }

  @override
  Future<bool> disconnectPrinter() {
    // TODO: implement disconnectPrinter
    throw UnimplementedError();
  }

  @override
  Future<FlutterStarPrinter> discoverPrinter() {
    // TODO: implement discoverPrinter
    throw UnimplementedError();
  }

  @override
  Future<void> print() {
    // TODO: implement print
    throw UnimplementedError();
  }
}
