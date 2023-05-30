import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_platform_interface.dart';
import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterStarPrinterSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterStarPrinterSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

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

void main() {
  final FlutterStarPrinterSdkPlatform initialPlatform = FlutterStarPrinterSdkPlatform.instance;

  test('$MethodChannelFlutterStarPrinterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterStarPrinterSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterStarPrinterSdk flutterStarPrinterSdkPlugin = FlutterStarPrinterSdk();
    MockFlutterStarPrinterSdkPlatform fakePlatform = MockFlutterStarPrinterSdkPlatform();
    FlutterStarPrinterSdkPlatform.instance = fakePlatform;

    expect(await flutterStarPrinterSdkPlugin.getPlatformVersion(), '42');
  });
}
