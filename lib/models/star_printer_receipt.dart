abstract class StarPrinterReceipt {
  String get type;

  Map? getData();

  Map toMap() {
    return {"type": type, "data": getData()};
  }
}
