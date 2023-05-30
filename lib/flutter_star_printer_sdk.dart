// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'flutter_star_printer_sdk_platform_interface.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';

class FlutterStarPrinterSdk {
  /// This function returns the platform version of the FlutterStarPrinterSdkPlatform instance as a
  /// Future<String?>.
  ///
  /// Returns:
  ///   A `Future` object that will eventually contain a `String` or `null` value.
  Future<String?> getPlatformVersion() {
    return FlutterStarPrinterSdkPlatform.instance.getPlatformVersion();
  }

  /// This function returns a Future object that discovers a printer using the
  /// FlutterStarPrinterSdkPlatform instance.
  ///
  /// Returns:
  ///   A `Future` object that will eventually resolve to a `FlutterStarPrinter` object after
  /// discovering a printer using the `FlutterStarPrinterSdkPlatform` instance.
  Future<FlutterStarPrinter> discoverPrinter() async {
    return FlutterStarPrinterSdkPlatform.instance.discoverPrinter();
  }

  /// This function attempts to connect to a printer using the FlutterStarPrinterSdkPlatform and returns
  /// a boolean indicating whether the connection was successful or not.
  ///
  /// Returns:
  ///   A `Future<bool>` object is being returned.
  Future<bool> connectPrinter() async {
    return FlutterStarPrinterSdkPlatform.instance.connectPrinter();
  }

  /// This function disconnects the printer using the FlutterStarPrinterSdkPlatform instance.
  ///
  /// Returns:
  ///   A `Future<bool>` object is being returned.
  Future<bool> disconnectPrinter() async {
    return FlutterStarPrinterSdkPlatform.instance.disconnectPrinter();
  }

  /// This function calls the print method of the FlutterStarPrinterSdkPlatform instance.
  ///
  /// Returns:
  ///   A `Future<void>` object is being returned.
  Future<void> print() async {
    return FlutterStarPrinterSdkPlatform.instance.print();
  }
}
