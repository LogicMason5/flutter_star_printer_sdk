import 'dart:async';

import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';

/// Singleton that broadcasts discovered Star printers 🔍
class FlutterStarPrinterBroadcastListeners {
  FlutterStarPrinterBroadcastListeners._internal();

  /// Singleton instance
  static final FlutterStarPrinterBroadcastListeners _instance =
      FlutterStarPrinterBroadcastListeners._internal();

  factory FlutterStarPrinterBroadcastListeners() => _instance;

  final StreamController<FlutterStarPrinter?> _discoverController =
      StreamController<FlutterStarPrinter?>.broadcast();

  /// Stream of discovered printers
  Stream<FlutterStarPrinter?> get scanResults =>
      _discoverController.stream;

  /// Whether controller is closed
  bool get _isClosed => _discoverController.isClosed;

  /// Emit discovered printer
  void whenDiscovered(FlutterStarPrinter printer) {
    if (_isClosed) return;
    _discoverController.add(printer);
  }

  /// Reset discovery result (emit null)
  void reset() {
    if (_isClosed) return;
    _discoverController.add(null);
  }

  /// Dispose controller safely
  Future<void> dispose() async {
    if (_isClosed) return;
    await _discoverController.close();
  }
}
