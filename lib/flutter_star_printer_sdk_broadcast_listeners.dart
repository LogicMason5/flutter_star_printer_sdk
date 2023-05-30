import 'dart:async';

import 'package:flutter_star_printer_sdk/models/flutter_star_printer.dart';

/// This is a singleton class that manages a stream controller for broadcasting discovered
/// FlutterStarPrinter devices.
class FlutterStarPrinterBroadcastListeners {
  /// Creating a private static final instance of the `FlutterStarPrinterBroadcastListeners` class,
  /// which can only be accessed within the class. This is a common implementation of the Singleton
  /// design pattern in Dart. The `factory` constructor then returns this instance, ensuring that only
  /// one instance of the class is ever created.
  static final FlutterStarPrinterBroadcastListeners _instance =
      FlutterStarPrinterBroadcastListeners._internal();

  factory FlutterStarPrinterBroadcastListeners() => _instance;

  FlutterStarPrinterBroadcastListeners._internal();

  final _discoverController = StreamController<FlutterStarPrinter?>.broadcast();
  Stream<FlutterStarPrinter?> get scanResults => _discoverController.stream;

  /// This function adds a FlutterStarPrinter object to a stream controller.
  ///
  /// Args:
  ///   result (FlutterStarPrinter): result is an object of type FlutterStarPrinter that is being passed
  /// as a parameter to the whenDiscovered function. It is likely that this function is part of a larger
  /// codebase related to discovering and connecting to a Star Printer using the Flutter framework. The
  /// purpose of this function seems to be to add
  void whenDiscovered(FlutterStarPrinter result) {
    _discoverController.sink.add(result);
  }

  /// This function reset the discovery result to null
  void reset() {
    _discoverController.sink.add(null);
  }

  /// This function dispose the discovery stream controller
  void dispose() {
    _discoverController.close();
  }
}
