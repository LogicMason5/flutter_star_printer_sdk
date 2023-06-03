enum StarConnectionInterface {
  unknown,
  usb,
  bluetooth,
  lan;

  static StarConnectionInterface fromName(String name) =>
      StarConnectionInterface.values.firstWhere((e) => e.name == name);
}

enum StarPrinterPaper {
  mm58('58mm'), // 385
  mm76('76mm'), // 530
  mm80('80mm'), // 567
  mm112('112mm');

  final String label;

  const StarPrinterPaper(this.label);
}

enum StarPrinterModel {
  tsp650II('TSP 650 II', [StarPrinterPaper.mm80]),
  tsp700II('TSP 600 II', [StarPrinterPaper.mm80]),
  tsp800II('TSP 800 II', [StarPrinterPaper.mm80]),
  tsp100IIUPlus('TSP 100 II U+', [StarPrinterPaper.mm80]),
  tsp100IIIW('TSP 100 III W', [StarPrinterPaper.mm80]),
  tsp100IIILAN('TSP 100 III LAN', [StarPrinterPaper.mm80]),
  tsp100IIIBI('TSP 100 III BI', [StarPrinterPaper.mm80]),
  tsp100IIIU('TSP 100 III U', [StarPrinterPaper.mm80]),
  tsp100IV('TSP 800II', [StarPrinterPaper.mm80]),
  mPOP('mPOP', [StarPrinterPaper.mm58]),
  mCPrint2('mC-Print2', [StarPrinterPaper.mm58]),
  mCPrint3('mC-Print3', [StarPrinterPaper.mm80]),
  smS210i('SM-S210i', [StarPrinterPaper.mm58]),
  smS230i('SM-S230i', [StarPrinterPaper.mm58]),
  smT300('SM-T300', [StarPrinterPaper.mm80]),
  smT300i('SM-T300i', [StarPrinterPaper.mm80]),
  smT400i('SM-T400i', [StarPrinterPaper.mm112]),
  smL200('SM-L200', [StarPrinterPaper.mm58]),
  smL300('SM-L300', [StarPrinterPaper.mm58]),
  sp700('SP-700', [StarPrinterPaper.mm76]),
  unknown('Unknown', []);

  final String label;
  final List<StarPrinterPaper> paper;

  const StarPrinterModel(this.label, this.paper);
  static StarPrinterModel fromName(String name) =>
      StarPrinterModel.values.firstWhere((e) => e.name == name);
}

enum StarPrinterCutType { full, partial, fullDirect, partialDirect }

enum StarPrinterBarcodeSymbology {
  upcE,
  upcA,
  jan8,
  ean8,
  jan13,
  ean13,
  code39,
  itf,
  code128,
  code93,
  nw7
}

enum StarPrinterBarcodeBarRatioLevel { levelPlus1, level0, levelMinus1 }

enum StarPrinterPdf417Level {
  ecc0,
  ecc1,
  ecc2,
  ecc3,
  ecc4,
  ecc5,
  ecc6,
  ecc7,
  ecc8
}

enum StarPrinterQRCodeModel { model1, model2 }

enum StarPrinterQRCodeLevel { l, m, q, h }

enum StarPrinterStyleAlignment { left, center, right }

enum StarPrinterStyleFontType { a, b }

enum StarPrinterLineStyle {single, double }

enum StarPrinterStyleInternationalCharacter {
  usa,
  france,
  germany,
  uk,
  denmark,
  sweden,
  italy,
  spain,
  japan,
  norway,
  denmark2,
  spain2,
  latinAmerica,
  korea,
  ireland,
  slovenia,
  croatia,
  china,
  vietnam,
  arabic,
  legal
}

enum StarPrinterStyleCharacterEncodingType {
  japanese,
  simplifiedChinese,
  traditionalChinese,
  korean,
  codePage
}

enum StarPrinterStyleCjkCharacterType {
  japanese,
  simplifiedChinese,
  traditionalChinese,
  korean
}

enum StarPrinterDrawerChannel { no1, no2 }
