import 'package:flutter/material.dart';

import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
class IpTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Printer Demo'),
      ),
      body: Center(
        child: ElevatedButton(

          onPressed: () {
            _printReceipt();
          },
          child: Text('Print'),
        ),
      ),
    );
  }

  void _printReceipt() async {
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(PaperSize.mm80, profile);

    final PosPrintResult res = await printer.connect('192.168.1.46', port: 9100);

    if (res != PosPrintResult.success) {

      print('Could not connect to printer${res.msg}');
      return;
    }

    printer.text('Hello, world!', styles: PosStyles(align: PosAlign.center));
    printer.feed(2);
    printer.cut();
    printer.disconnect();
  }
}
