import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_method_channel.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_platform_interface.dart';
import 'package:flutter_star_printer_sdk/models/connection_response.dart';
import 'package:flutter_star_printer_sdk/models/disconnect_response.dart';
import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterStarPrinterSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterStarPrinterSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<DisconnectResponse> disconnectPrinter({
    required FlutterStarPrinter printer,
  }) {
    // TODO: implement disconnectPrinter
    throw UnimplementedError();
  }

  @override
  Future<void> printReceipt({
    required FlutterStarPrinter printer,
  }) {
    // TODO: implement print
    throw UnimplementedError();
  }

  @override
  Future<void> discoverPrinter(
      {required List<StarConnectionInterface> interfaces}) {
    // TODO: implement discoverPrinter
    throw UnimplementedError();
  }

  @override
  Future<ConnectionResponse> connectPrinter(
      {required FlutterStarPrinter printer}) {
    // TODO: implement connectPrinter
    throw UnimplementedError();
  }
}

void main() {
  final FlutterStarPrinterSdkPlatform initialPlatform =
      FlutterStarPrinterSdkPlatform.instance;

  test('$MethodChannelFlutterStarPrinterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterStarPrinterSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterStarPrinterSdk flutterStarPrinterSdkPlugin = FlutterStarPrinterSdk();
    MockFlutterStarPrinterSdkPlatform fakePlatform =
        MockFlutterStarPrinterSdkPlatform();
    FlutterStarPrinterSdkPlatform.instance = fakePlatform;

    expect(await flutterStarPrinterSdkPlugin.getPlatformVersion(), '42');
  });
}
