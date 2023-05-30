import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_star_printer_sdk_method_channel.dart';

abstract class FlutterStarPrinterSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterStarPrinterSdkPlatform.
  FlutterStarPrinterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterStarPrinterSdkPlatform _instance =
      MethodChannelFlutterStarPrinterSdk();

  /// The default instance of [FlutterStarPrinterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterStarPrinterSdk].
  static FlutterStarPrinterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterStarPrinterSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterStarPrinterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> discoverPrinter() async {
    throw UnimplementedError('discoverPrinter() has not been implemented.');
  }

  Future<bool> connectPrinter() async {
    throw UnimplementedError('connectPrinter() has not been implemented.');
  }

  Future<bool> disconnectPrinter() async {
    throw UnimplementedError('disconnectPrinter() has not been implemented.');
  }

  Future<void> print() async {
    throw UnimplementedError('print() has not been implemented.');
  }
}
