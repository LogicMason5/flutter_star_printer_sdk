import 'dart:async';

import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_broadcast_listeners.dart';
import 'package:flutter_star_printer_sdk/models/connection_response.dart';
import 'package:flutter_star_printer_sdk/models/disconnect_response.dart';
import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';
import 'package:flutter_star_printer_sdk/models/star_printer_document.dart';

import 'flutter_star_printer_sdk_platform_interface.dart';

class FlutterStarPrinterSdk {
  final FlutterStarPrinterBroadcastListeners _broadcastListeners =
      FlutterStarPrinterBroadcastListeners();

  /// This line of code is defining a getter method called `scanResults` that returns a `Stream` of
  /// `FlutterStarPrinter` objects. The `Stream` is obtained from the `broadcastListeners` object, which
  /// is an instance of `FlutterStarPrinterBroadcastListeners` class. This getter method is used to
  /// listen for scan results when discovering printers.
  Stream<FlutterStarPrinter?> get scanResults =>
      _broadcastListeners.scanResults;

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
  Future<void> discoverPrinter({
    required List<StarConnectionInterface> interfaces,
  }) async {
    assert(interfaces.isNotEmpty);
    FlutterStarPrinterSdkPlatform.instance.discoverPrinter(
      interfaces: interfaces,
    );
  }

  /// This function attempts to connect to a printer using the FlutterStarPrinterSdkPlatform and returns
  /// a boolean indicating whether the connection was successful or not.
  ///
  /// Returns:
  ///   A `Future<bool>` object is being returned.
  Future<ConnectionResponse> connectPrinter({
    required FlutterStarPrinter printer,
  }) async {
    assert(
      printer.connection != StarConnectionInterface.unknown &&
          printer.identifier.isNotEmpty,
    );

    return FlutterStarPrinterSdkPlatform.instance.connectPrinter(
      printer: printer,
    );
  }

  /// This function disconnects the printer using the FlutterStarPrinterSdkPlatform instance.
  ///
  /// Returns:
  ///   A `Future<bool>` object is being returned.
  Future<DisconnectResponse> disconnectPrinter({
    required FlutterStarPrinter printer,
  }) async {
    return FlutterStarPrinterSdkPlatform.instance
        .disconnectPrinter(printer: printer);
  }

  /// This function resets the discovery result for a Flutter Star Printer SDK platform instance.
  void resetDiscoveryResult() =>
      FlutterStarPrinterSdkPlatform.instance.resetDiscoveryResult();

  /// This function calls the print method of the FlutterStarPrinterSdkPlatform instance.
  ///
  /// Returns:
  ///   A `Future<void>` object is being returned.
  Future<void> printReceipt({
    required FlutterStarPrinter printer,
    required FlutterStarPrinterDocument document,
  }) async {
    return FlutterStarPrinterSdkPlatform.instance.printReceipt(
      printer: printer,
      document: document,
    );
  }
}
