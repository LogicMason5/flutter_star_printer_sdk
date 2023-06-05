import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_star_printer_sdk/flutter_star_sdk.dart';
import 'package:flutter_star_printer_sdk_example/receipt/star_printer_receipt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterStarPrinterSdkPlugin = FlutterStarPrinterSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterStarPrinterSdkPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white)),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: StreamBuilder<FlutterStarPrinter?>(
              stream: _flutterStarPrinterSdkPlugin.scanResults,
              builder: (context, snapshot) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Platform Version: $_platformVersion',
                      ),
                      const SizedBox(height: 16.0),
                      Visibility(
                        visible: snapshot.data != null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ListTile(
                            tileColor: Theme.of(context).primaryColor,
                            selectedColor: Theme.of(context).primaryColor,
                            selectedTileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            selected: connected,
                            leading: const Icon(Icons.print),
                            title: Text(snapshot.data?.model.label ?? ""),
                            subtitle:
                                Text(snapshot.data?.connection.name ?? ""),
                            onTap: () async {
                              if (snapshot.data != null) {
                                final builder = await FlutterStarPrinterReceipt
                                    .buildReceipt();

                                final document = FlutterStarPrinterDocument()
                                  ..addPrint(builder);

                                await _flutterStarPrinterSdkPlugin.printReceipt(
                                  printer: snapshot.data!,
                                  document: document,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _flutterStarPrinterSdkPlugin.discoverPrinter(
                          interfaces: [StarConnectionInterface.lan],
                        ),
                        icon: const Icon(Icons.sync),
                        label: const Text('Discover'),
                      ),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
