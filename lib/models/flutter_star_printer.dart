import 'package:flutter_star_printer_sdk/models/enums.dart';

class FlutterStarPrinter {
  /// This is a constructor for the `FlutterStarPrinter` class in Dart. It takes a map of values as input
  /// and initializes the `model`, `identifier`, and `interface` instance variables of the
  /// `FlutterStarPrinter` object using the values from the map. The `StarPrinterModel.fromName` and
  /// `StarConnectionInterface.fromName` methods are used to convert the string values in the map to the
  /// corresponding enum values.
  FlutterStarPrinter.fromMap(Map<String, dynamic> response)
      : model = StarPrinterModel.fromName(response['model']),
        identifier = response['identifier'],
        connection = StarConnectionInterface.fromName(response['connection']);

  /// These are instance variables of the `FlutterStarPrinter` class in Dart. They are used to store the
  /// model, identifier, and interface of a Star printer. The `StarPrinterModel` and
  /// `StarConnectionInterface` are enums that define the possible values for the printer model and
  /// interface. The `fromMap` constructor initializes these variables from a map of values, and the
  /// `toMap` method returns a map representation of the printer object. The `toString` method returns a
  /// string representation of the printer object.

  StarPrinterModel model;
  String identifier;
  StarConnectionInterface connection;

  /// The function returns a string representation of an object with its model, identifier, and
  /// interface properties.
  ///
  /// Returns:
  ///   A string representation of the object's model, identifier, and interface properties.

  @override
  String toString() {
    return 'model: $model, identifier: $identifier, connection: $connection';
  }

  /// The function returns a map containing the name of a model, an identifier, and the name of an
  /// interface.
  ///
  /// Returns:
  ///   A Map object with three key-value pairs: 'model' with the name of a model as a String value,
  /// 'identifier' with a dynamic value, and 'interface' with the name of an interface as a String
  /// value.
  Map<String, dynamic> toMap() {
    return {
      'model': model.name,
      'identifier': identifier,
      'connection': connection.name
    };
  }
}
