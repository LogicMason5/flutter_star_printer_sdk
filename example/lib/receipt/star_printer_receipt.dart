import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/flutter_star_receipt_builder.dart';

class StarPrinterReceipt {
  static buildStarReceipt() async {




    final builder = FlutterStarReceiptBuilder();
    builder.style(
      alignment: StarPrinterStyleAlignment.center,
      magnification: StarPrinterStyleMagnification(height: 3, width: 3),
    );

    builder.actionPrintText("Flutter");
  }
}
