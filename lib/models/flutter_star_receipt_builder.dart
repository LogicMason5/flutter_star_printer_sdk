import 'package:flutter/foundation.dart';
import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/star_printer_receipt.dart';

class FlutterStarReceiptBuilder extends StarPrinterReceipt {
  final List<Map> _actions = [];

  @override
  String get type => 'print';

  void style({
    StarPrinterStyleAlignment? alignment,
    StarPrinterStyleFontType? fontType,
    bool? bold,
    bool? invert,
    bool? underLine,
    StarPrinterStyleMagnification? magnification,
    double? characterSpace,
    double? lineSpace,
    double? horizontalPositionTo,
    double? horizontalPositionBy,
    List<int>? horizontalTabPosition,
    StarPrinterStyleInternationalCharacter? internationalCharacter,
    StarPrinterStyleCharacterEncodingType? secondPriorityCharacterEncoding,
    List<StarPrinterStyleCjkCharacterType>? cjkCharacterPriority,
  }) {
    _actions.add({
      'action': 'style',
      'alignment': alignment?.name,
      'fontType': fontType?.name,
      'bold': bold,
      'invert': invert,
      'underLine': underLine,
      'magnification': magnification?.toMap(),
      'characterSpace': characterSpace,
      'lineSpace': lineSpace,
      'horizontalPositionTo': horizontalPositionTo,
      'horizontalPositionBy': horizontalPositionBy,
      'horizontalTabPosition': horizontalTabPosition,
      'internationalCharacter': internationalCharacter?.name,
      'secondPriorityCharacterEncoding': secondPriorityCharacterEncoding?.name,
      'cjkCharacterPriority': cjkCharacterPriority?.map((e) => e.name).toList()
    }..trim());
  }

  void add(FlutterStarReceiptBuilder print) {
    _actions.add({'action': 'add', 'data': print.getData()});
  }

  void actionCut(StarPrinterCutType type) {
    _actions.add({'action': 'cut', 'type': type.name});
  }

  void actionFeed(double height) {
    _actions.add({'action': 'feed', 'height': height});
  }

  void actionFeedLine(int lines) {
    _actions.add({'action': 'feedLine', 'lines': lines});
  }

  void actionPrintText(String text) {
    _actions.add({'action': 'printText', 'text': text});
  }

  void actionPrintLogo(String keyCode) {
    _actions.add({'action': 'printLogo', 'keyCode': keyCode});
  }

  void actionPrintBarcode(String content,
      {StarPrinterBarcodeSymbology? symbology,
      bool? printHri,
      int? barDots,
      StarPrinterBarcodeBarRatioLevel? barRatioLevel,
      double? height}) {
    _actions.add({
      'action': 'printBarcode',
      'content': content,
      'symbology': symbology?.name,
      'printHri': printHri,
      'barDots': barDots,
      'barRatioLevel': barRatioLevel?.name,
      'height': height
    }..trim());
  }

  void actionPrintPdf417(String content,
      {int? column,
      int? line,
      int? module,
      int? aspect,
      StarPrinterPdf417Level? level}) {
    _actions.add({
      'action': 'printPdf417',
      'content': content,
      'line': line,
      'module': module,
      'aspect': aspect,
      'level': level?.name
    }..trim());
  }

  void actionPrintQRCode(String content,
      {StarPrinterQRCodeModel? model,
      StarPrinterQRCodeLevel? level,
      int? cellSize}) {
    _actions.add({
      'action': 'printQRCode',
      'content': content,
      'model': model?.name,
      'level': level?.name,
      'cellSize': cellSize
    }..trim());
  }

  void actionPrintImage(Uint8List image, int width) {
    _actions.add({'action': 'printImage', 'image': image, 'width': width});
  }

  @override
  Map getData() {
    return {"actions": _actions};
  }
}

extension MapTrim on Map {
  trim() {
    removeWhere((key, value) => value == null);
  }
}
