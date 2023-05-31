import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_broadcast_listeners.dart';
import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';
import 'package:flutter_star_printer_sdk/utils/utils.dart';

import 'flutter_star_printer_sdk_platform_interface.dart';

/// An implementation of [FlutterStarPrinterSdkPlatform] that uses method channels.
class MethodChannelFlutterStarPrinterSdk
    implements FlutterStarPrinterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(
    'co.uk.ferns.flutter_plugins/flutter_star_printer_sdk',
  );

  final FlutterStarPrinterBroadcastListeners broadcastListeners =
      FlutterStarPrinterBroadcastListeners();

  MethodChannelFlutterStarPrinterSdk() {
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == "onDiscovered") {
        final model = StarPrinterModel.fromName(
          Utils.snakeCaseToCamelCase(call.arguments['model']),
        );
        final identifier = call.arguments['identifier'] as String;
        final connection = StarConnectionInterface.fromName(
          call.arguments['connection'].toString().toLowerCase(),
        );

        final printer = FlutterStarPrinter(
          model: model,
          identifier: identifier,
          connection: connection,
        );
        
        broadcastListeners.whenDiscovered(printer);
      }
    });
  }

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
  Future<void> discoverPrinter() async {
    await methodChannel.invokeMethod<String>('discoverPrinter', {
      "interfaces": [
        StarConnectionInterface.bluetooth.name,
        StarConnectionInterface.lan.name
      ]
    });
    // final printer = FlutterStarPrinter.fromMap(<String, dynamic>{
    //   'model': 'mCPrint3',
    //   'identifier': '12345',
    //   'connection': 'bluetooth'
    // });
    // broadcastListeners.whenDiscovered(printer);
  }

  @override
  Future<void> printReceipt() {
    // TODO: implement printReceipt
    throw UnimplementedError();
  }
}
