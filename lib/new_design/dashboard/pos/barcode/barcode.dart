
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
class BarcodeScannerClass {
  static Future<String?> scanBarcode(BuildContext context) async {
    try {
      String result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // background color
        'Cancel', // cancel button text
        true, // show flash icon
        ScanMode.BARCODE, // scan mode (you can change this to QR code if needed)
      );

      if (result == '-1') {
        // User pressed the back button or canceled the scan
        return null;
      }

      return result;
    } catch (e) {
      // Handle exceptions
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Error while scanning barcode: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return null;
    }
  }




}
