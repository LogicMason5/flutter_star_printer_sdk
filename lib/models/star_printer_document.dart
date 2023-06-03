import 'package:flutter_star_printer_sdk/models/flutter_star_printer_drawer.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_receipt_builder.dart';

abstract class StarPrinterContent {
  String get type;

  Map? getData();

  Map toMap() {
    return {"type": type, "data": getData()};
  }
}

class FlutterStarPrinterDocument {
  final List<StarPrinterContent> _contents = [];
  addPrint(FlutterStarReceiptBuilder builder) => _contents.add(builder);
  addDrawer(StarPrinterDrawer drawer) => _contents.add(drawer);

  Map toMap() {
    return {"contents": _contents.map((e) => e.toMap()).toList()};
  }
}
