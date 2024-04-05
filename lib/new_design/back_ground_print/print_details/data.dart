// import 'package:flutter/material.dart';
// import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
//
// class PrinterTest extends StatefulWidget {
//   @override
//   _PrinterTestState createState() => _PrinterTestState();
// }//
//
// class _PrinterTestState extends State<PrinterTest> {
//   USBPrinterManager printerManager = USBPrinterManager();
//
//   @override
//   void initState() {
//     super.initState();
//     printerManager.scanResults.listen((printers) {
//       for (USBPrinter printer in printers) {
//         print(printer.name);
//         print(printer.vendorId);
//         print(printer.productId);
//         // Connect to the printer
//         connectToPrinter(printer);
//         break; // Only connect to the first printer found
//       }
//     });
//   }
//
//   void connectToPrinter(USBPrinter printer) async {
//     final PosPrintResult res = await printerManager.connect(printer);
//     if (res != PosPrintResult.success) {
//       print('Failed to connect to printer: $res');
//     } else {
//       // Connection successful, now print
//       await printTestReceipt();
//       printerManager.disconnect();
//     }
//   }
//
//   Future<void> printTestReceipt() async {
//     final profile = await CapabilityProfile.load();
//     final printer = NetworkPrinter(PaperSize.mm80, profile);
//
//     printer.text('Hello, world!');
//     printer.feed(2);
//     printer.cut();
//
//     printerManager.writeBytes(printer.bytes);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Printer Test'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             printerManager.startScan();
//           },
//           child: Text('Scan and Print'),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     printerManager.stopScan();
//     super.dispose();
//   }
// }
