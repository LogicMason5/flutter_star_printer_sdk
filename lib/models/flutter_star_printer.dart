// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_star_printer_sdk/models/enums.dart';

/// `FlutterStarPrinter` is a class that represents a Star printer device in a Flutter
/// application. It contains information about the printer model, identifier, and connection
/// interface. It also provides methods for converting the object to and from JSON and a string
/// representation of the object.
class FlutterStarPrinter {
  final StarPrinterModel model;
  final String identifier;
  final StarConnectionInterface connection;

  FlutterStarPrinter({
    required this.model,
    required this.identifier,
    required this.connection,
  });

  FlutterStarPrinter copyWith({
    StarPrinterModel? model,
    String? identifier,
    StarConnectionInterface? connection,
  }) {
    return FlutterStarPrinter(
      model: model ?? this.model,
      identifier: identifier ?? this.identifier,
      connection: connection ?? this.connection,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model': model,
      'identifier': identifier,
      'connection': connection,
    };
  }

  factory FlutterStarPrinter.fromMap(Map<String, dynamic> map) {
    return FlutterStarPrinter(
      model: StarPrinterModel.fromName(map['model']),
      identifier: map['identifier'],
      connection: StarConnectionInterface.fromName(map['connection']),
    );
  }

  String toJson() => json.encode(toMap());

  factory FlutterStarPrinter.fromJson(String source) =>
      FlutterStarPrinter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FlutterStarPrinter(model: $model, identifier: $identifier, connection: $connection)';

  @override
  bool operator ==(covariant FlutterStarPrinter other) {
    if (identical(this, other)) return true;

    return other.model == model &&
        other.identifier == identifier &&
        other.connection == connection;
  }

  @override
  int get hashCode =>
      model.hashCode ^ identifier.hashCode ^ connection.hashCode;
}
