import 'dart:async';

import 'package:flutter_star_printer_sdk/flutter_star_printer_sdk_broadcast_listeners.dart';
import 'package:flutter_star_printer_sdk/models/connection_response.dart';
import 'package:flutter_star_printer_sdk/models/disconnect_response.dart';
import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';
import 'package:flutter_star_printer_sdk/models/star_printer_document.dart';

import 'flutter_star_printer_sdk_platform_interface.dart';

/// High-level API for Star Printer SDK
/// Optimized for production use
class FlutterStarPrinterSdk {
  FlutterStarPrinterSdk._internal();

  /// Singleton instance
  static final FlutterStarPrinterSdk _instance =
      FlutterStarPrinterSdk._internal();

  factory FlutterStarPrinterSdk() => _instance;

  final FlutterStarPrinterBroadcastListeners _broadcastListeners =
      FlutterStarPrinterBroadcastListeners();

  /// Stream of discovered printers during scanning 🔍
  Stream<FlutterStarPrinter?> get scanResults =>
      _broadcastListeners.scanResults;

  /// Get platform version
  Future<String?> getPlatformVersion() async {
    try {
      return await FlutterStarPrinterSdkPlatform.instance
          .getPlatformVersion();
    } catch (e) {
      throw Exception('Failed to get platform version: $e');
    }
  }

  /// Discover printers on specified interfaces
  Future<void> discoverPrinter({
    required List<StarConnectionInterface> interfaces,
  }) async {
    assert(
      interfaces.isNotEmpty,
      'Interfaces list cannot be empty',
    );

    try {
      await FlutterStarPrinterSdkPlatform.instance.discoverPrinter(
        interfaces: interfaces,
      );
    } catch (e) {
      throw Exception('Printer discovery failed: $e');
    }
  }

  /// Connect to a printer 🔌
  Future<ConnectionResponse> connectPrinter({
    required FlutterStarPrinter printer,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    assert(
      printer.connection != StarConnectionInterface.unknown,
      'Printer connection type cannot be unknown',
    );
    assert(
      printer.identifier.isNotEmpty,
      'Printer identifier cannot be empty',
    );

    try {
      return await FlutterStarPrinterSdkPlatform.instance
          .connectPrinter(printer: printer)
          .timeout(timeout);
    } on TimeoutException {
      throw Exception('Connection timed out');
    } catch (e) {
      throw Exception('Failed to connect to printer: $e');
    }
  }

  /// Disconnect printer ❌
  Future<DisconnectResponse> disconnectPrinter({
    required FlutterStarPrinter printer,
  }) async {
    try {
      return await FlutterStarPrinterSdkPlatform.instance
          .disconnectPrinter(printer: printer);
    } catch (e) {
      throw Exception('Failed to disconnect printer: $e');
    }
  }

  /// Reset discovery results
  void resetDiscoveryResult() {
    FlutterStarPrinterSdkPlatform.instance.resetDiscoveryResult();
  }

  /// Print receipt 🧾
  Future<void> printReceipt({
    required FlutterStarPrinter printer,
    required FlutterStarPrinterDocument document,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      await FlutterStarPrinterSdkPlatform.instance
          .printReceipt(
            printer: printer,
            document: document,
          )
          .timeout(timeout);
    } on TimeoutException {
      throw Exception('Printing timed out');
    } catch (e) {
      throw Exception('Printing failed: $e');
    }
  }
}
