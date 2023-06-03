import 'package:flutter_star_printer_sdk/models/enums.dart';
import 'package:flutter_star_printer_sdk/models/star_printer_document.dart';

class StarPrinterDrawer extends StarPrinterContent {
  final StarPrinterDrawerChannel channel;
  StarPrinterDrawer({this.channel = StarPrinterDrawerChannel.no1});

  @override
  String get type => 'drawer';

  @override
  Map getData() {
    return {"channel": channel.name};
  }
}
