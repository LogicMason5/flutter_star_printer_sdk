import 'package:flutter_star_printer_sdk/flutter_star_sdk.dart';

class FlutterStarPrinterReceipt {
  static Future<FlutterStarReceiptBuilder> buildReceipt() async {
    final builder = FlutterStarReceiptBuilder(paper: StarPrinterPaper.mm80);
    builder.style(
      alignment: StarPrinterStyleAlignment.center,
      magnification: StarPrinterStyleMagnification(height: 2, width: 2),
      bold: true,
      fontType: StarPrinterStyleFontType.a,
    );
    builder.actionPrintText("Flutter");
    builder.style(
      alignment: StarPrinterStyleAlignment.right,
      magnification: StarPrinterStyleMagnification(height: 1, width: 1),
      bold: false,
    );
    builder.actionPrintText("Start Printer SDK");
    builder.style(
      alignment: StarPrinterStyleAlignment.left,
    );
    builder.actionPrintTextOnLeftAndRight(
      texts: ['NAME', 'SANKARANARAYANAN P'],
    );
    builder.actionPrintRuledLine();
    builder.actionPrintTextOnRow(
      ratios: <int>[5, 3, 1, 3],
      texts: <String>["ITEM", "PRICE", "QTY", "TOTAL"],
    );
    builder.actionFeed(20.0);
    builder.actionCut(StarPrinterCutType.full);

    return builder;
  }
}
