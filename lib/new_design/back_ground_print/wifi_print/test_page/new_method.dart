
import 'dart:convert';

import 'package:image/image.dart' as Img;
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewMethod {
  GlobalKey globalKey = GlobalKey();
  GlobalKey invoiceKey = GlobalKey();
  // final GlobalKey<_InvoiceState> invoiceKey = GlobalKey<_InvoiceState>();

  Widget invoiceDesign() {
    return ListView(
      children: <Widget>[
        RepaintBoundary(
          key: globalKey,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Text("Demo data"),
            ),
          ),
        ),
      ],
    );
  }

  createInvoice() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e.toString());
    }
  }
  List<int> _encode(String text) {
    return utf8.encode(text);
  }

  List<int> text(String text) {
    return _encode(text);
  }

  // Example method to demonstrate usage
   printText(String textd) {
    List<int> encodedText = text(textd);
    return encodedText;
    // Print or process encodedText
    print(encodedText); // Just for demonstration
  }
  Future<void> printDemoPage(NetworkPrinter printer,imageData) async {







    final Img.Image? image = Img.decodeImage(imageData);
    print("------113");
    final Img.Image resizedImage = Img.copyResize(image!,width: 550);
    print("------114");
    printer.imageRaster(resizedImage,);



// Using `GS ( L`

    print("------115");
    printer.cut();
  }

  void print_demo(String printerIp,BuildContext ctx,byte) async {
    print("1");
    const PaperSize paper = PaperSize.mm80;
    var profile = await CapabilityProfile.load();
    print("2");
    final printer = NetworkPrinter(paper, profile);
    print("3");
    var port = int.parse("9100");
    print("4");
    final PosPrintResult res = await printer.connect(printerIp, port: port);
    print("5");
    if (res == PosPrintResult.success) {
      print("6");
      await printDemoPage(printer,byte);
      print("7");
      Future.delayed(const Duration(seconds: 2), () async {
        printer.disconnect();
      });
    } else {
      popAlert(head: "Error", message: "Check your printer connection",position: SnackPosition.TOP);
    }
  }
}
class InvoiceDesignWidget extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  Uint8List? pngBytes;

  Future<void> createInvoice() async {
    try {
      print("1010101010");
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      print("1010101010");
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      pngBytes = byteData!.buffer.asUint8List();
      print(pngBytes);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        color: Colors.white, // Transparent to not affect layout
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Title',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text('Customer Name: John Doe'),
            Text('Invoice Date: July 2, 2024'),
            SizedBox(height: 20.0),
            Text(
              'Items:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            ListTile(
              title: Text('Item 1'),
              subtitle: Text('Description: Example description'),
              trailing: Text('\$100'),
            ),
            ListTile(
              title: Text('Item 2'),
              subtitle: Text('Description: Another example description'),
              trailing: Text('\$50'),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: \$150',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
