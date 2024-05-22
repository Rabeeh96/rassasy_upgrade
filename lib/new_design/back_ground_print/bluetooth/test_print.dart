// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/services.dart';
// import 'package:rassasy_new/Print/service.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:pos_printer_manager/pos_printer_manager.dart';
// import 'package:get/get.dart';
//
// class PrintSettingsBluetooth extends StatefulWidget {
//   @override
//   _PrintSettingsBluetoothState createState() => _PrintSettingsBluetoothState();
// }
//
// class _PrintSettingsBluetoothState extends State<PrintSettingsBluetooth> {
//   // List<BluetoothPrinter> _printers = [];
//   // late BluetoothPrinterManager _manager;
//
//   @override
//   void initState() {
//     super.initState();
//     load();
//   }
//
//   // TextEditingController ipController = TextEditingController()..text = "192.168.1.169";
//
//   bool arabic = false;
//
//   load() async {
//     _printers = [];
//     _printers = await BluetoothPrinterManager.discover();
//     setState(() {});
//   }
//
//   scan(index) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {});
//     var paperSize = PaperSize.mm80;
//
//     if (_printers.length == 0) {
//       print("Switch on bluetooth");
//       print(
//           "---------------------1----------------------------------------------");
//       return 1;
//
//       /// exit when no item connected
//     } else {
//       print(
//           "----------------------2---------------------------------------------");
//       bool connected = true;
//
//       for (var i = 0; i < _printers.length; i++) {
//         if (_printers[i].address == _printers[i].address) {
//           index = i;
//           connected = true;
//           break;
//         }
//       }
//       if (connected == true) {
//         if (_printers[index].connected == true) {
//           print(
//               "----------------------3---------------------------------------------");
//         } else {
//           print(
//               "----------------------4---------------------------------------------");
//           var paperSize = PaperSize.mm80;
//           var profile_mobile = await CapabilityProfile.load();
//
//           var manager =
//               BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
//           var printResult = await manager.connect();
//
//           _printers[index].connected = true;
//           _manager = manager;
//           stop();
//         }
//         if (_manager != null) {
//           print("isConnected ${_manager.isConnected}");
//           if (_manager.isConnected == false) {
//             var profile_mobile = await CapabilityProfile.load();
//             var manager =
//                 BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
//             await manager.disconnect();
//             return 3;
//           } else {
//             print(
//                 "---------------------9----------------------------------------------");
//
//             var profile_mobile = await CapabilityProfile.load();
//             var paperSize = PaperSize.mm80;
//             var paper = "80mm";
//             var copies = "1";
//             var no_of_copies = int.parse(copies.toString());
//
//             var extraLine = "0";
//
//             var data;
//             final content;
//             var qrVisible = false;
//             var blankSpace = int.parse(extraLine);
//
//             if (paper == "80mm") {
//               paperSize = PaperSize.mm80;
//             } else if (paper == "58mm") {
//               paperSize = PaperSize.mm58;
//             } else if (paper == "72mm") {
//               paperSize = PaperSize.mm72;
//             } else {
//               //   paperSize = PaperSize.mm110;
//             }
//
//             /// customised
//
//             var service;
//
//             if (arabic) {
//               service =
//                   ESCPrinterServicesArabix(false, false, blankSpace, prefs);
//             } else {
//               service =
//                   ESCPrinterServicesExpense(false, false, blankSpace, prefs);
//             }
//
//             data = await service.getBytes(
//                 paperSize: PaperSize.mm80, profile_mobile: profile_mobile);
//
//             if (no_of_copies == 0) {
//               no_of_copies = 1;
//             }
//
//             for (var i = 1; i <= no_of_copies; i++) {
//               _manager.writeBytes(data, isDisconnect: false);
//             }
//           }
//         }
//       } else {
//         print('--print-  2--$connected');
//         return 2;
//       }
//
//       print('--print---$connected');
//     }
//   }
//
//   _scan() async {
//     print("scan");
//     setState(() {
//       _printers = [];
//     });
//     var printers = await BluetoothPrinterManager.discover();
//     print(printers);
//     setState(() {
//       _printers = printers;
//     });
//     //  connectToPrinter();
//   }
//
//   connectToPrinter() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var ip = prefs.get("defaultIP") ?? "";
//     for (var i = 0; i < _printers.length; i++) {
//       if (_printers[i].address == ip) {
//         _connect(_printers[i]);
//       }
//     }
//   }
//
//   _connect(BluetoothPrinter printer) async {
//     // dialogBox(context,"Please wait");
//     //
//     // if (printer.connected) {
//     //   _startPrinter();
//     // }
//     // else {
//     //   var paperSize = PaperSize.mm80;
//     //   var profile_mobile = await CapabilityProfile.load();
//     //   var manager = BluetoothPrinterManager(printer, paperSize, profile_mobile);
//     //   await manager.connect();
//     //   print(" -==== connected =====- ");
//     //   setState(() {
//     //     _manager = manager;
//     //     printer.connected = true;
//     //     _startPrinter();
//     //   });
//     // }
//   }
//
//   disconnect(BluetoothPrinter printer) async {
//     var paperSize = PaperSize.mm80;
//     var profile_mobile = await CapabilityProfile.load();
//     var manager = BluetoothPrinterManager(printer, paperSize, profile_mobile);
//     await manager.disconnect();
//     print(" -==== connected =====- ");
//     setState(() {
//       _manager = manager;
//     });
//   }
//
//   Future<String> getDirectoryPath() async {
//     Directory appDocDirectory = await getApplicationDocumentsDirectory();
//     Directory directory = await Directory(appDocDirectory.path + '/' + 'dir')
//         .create(recursive: true);
//     return directory.path;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     stop();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ), //
//           title: const Text(
//             'printer_set'.tr,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//               fontSize: 23,
//             ),
//           ),
//           backgroundColor: Colors.grey[300],
//           actions: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(right: 18.0),
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     // Background color
//                     foregroundColor: Colors.red,
//                     backgroundColor: Colors.transparent,
//                     // Padding
//                     padding: EdgeInsets.all(16.0),
//                     // Shape of the button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     // Elevation
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       _printers.clear();
//                     });
//                     load();
//                   },
//                   child: Text(
//                     'Refresh'.tr,
//                     style: customisedStyle(
//                         context, Colors.red, FontWeight.w500, 15.0),
//                   )),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 18.0),
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     // Background color
//                     foregroundColor: Colors.red,
//                     backgroundColor: Colors.transparent,
//                     // Padding
//                     padding: EdgeInsets.all(16.0),
//                     // Shape of the button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     // Elevation
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       arabic = true;
//                     });
//                   },
//                   child: Text(
//                     "AR",
//                     style: customisedStyle(
//                         context, Colors.red, FontWeight.w500, 15.0),
//                   )),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(right: 18.0),
//               child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     // Background color
//                     foregroundColor: Colors.red,
//                     backgroundColor: Colors.transparent,
//                     // Padding
//                     padding: EdgeInsets.all(16.0),
//                     // Shape of the button
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                     // Elevation
//                     elevation: 0,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       arabic = false;
//                     });
//                   },
//                   child: Text(
//                     "En",
//                     style: customisedStyle(
//                         context, Colors.red, FontWeight.w500, 15.0),
//                   )),
//             )
//           ]),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 80.0),
//           child: Container(
//               width: 500,
//               child: ListView.builder(
//                 itemCount: _printers.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     child: ListTile(
//                         title: Text(_printers[index].name!),
//                         onTap: () {
//                           scan(index);
//                         }),
//                   );
//                 },
//               )),
//         ),
//       ),
//     );
//   }
//
//   /// new method
// }
//
// class ESCPrinterServicesExpense {
//   bool autoCut;
//   bool openDrawer;
//   int blankSpace;
//   var prefs;
//
//   List<int>? _bytes;
//
//   List<int>? get bytes => _bytes;
//   PaperSize? _paperSize;
//   CapabilityProfile? _profile;
//
//   ESCPrinterServicesExpense(
//       this.autoCut, this.openDrawer, this.blankSpace, this.prefs);
//
//   Future<List<int>> getBytes({
//     PaperSize paperSize = PaperSize.mm80,
//     required CapabilityProfile profile_mobile,
//     String name = "default",
//   }) async {
//     List<int> bytes = [];
//     _profile = profile_mobile;
//     _paperSize = paperSize;
//     Generator generator = Generator(_paperSize!, _profile!);
//     var textStyleSwitch = true;
//
//     var invoiceType = "EXPENSE";
//     var invoiceTypeArabic = "";
//
//     bytes += generator.emptyLines(1);
//     bytes += generator.text(
//       invoiceType,
//       styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size1,
//           fontType: PosFontType.fontB,
//           bold: textStyleSwitch),
//     );
//     bytes += generator.emptyLines(1);
//
//     /// company phone number
//
//     /// customer phone number
//
//     bytes += generator.setGlobalFont(PosFontType.fontA);
//
//     bytes += generator.hr();
//     bytes += generator.text('Token',
//         styles: PosStyles(
//             height: PosTextSize.size1,
//             width: PosTextSize.size1,
//             bold: true,
//             align: PosAlign.center));
//     bytes += generator.text('25',
//         styles: PosStyles(
//             height: PosTextSize.size3,
//             width: PosTextSize.size3,
//             bold: true,
//             align: PosAlign.center));
//     bytes += generator.hr();
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'Token No ',
//           width: 3,
//           styles: PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           text: 'tokenEnc',
//           width: 3,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//       PosColumn(
//           text: '25',
//           styles: PosStyles(
//               height: PosTextSize.size3,
//               width: PosTextSize.size3,
//               bold: true,
//               align: PosAlign.center),
//           width: 6),
//     ]);
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'Voucher No  ',
//           width: 3,
//           styles: PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           text: "voucherNoEnc",
//           width: 3,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//       PosColumn(
//           text: 'SE 52', width: 6, styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'Date  ',
//           width: 3,
//           styles: PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           text: 'Date',
//           width: 3,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//       PosColumn(
//           text: "23-02-2013",
//           width: 6,
//           styles: PosStyles(align: PosAlign.right)),
//     ]);
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'Name    ',
//           width: 3,
//           styles:
//               PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           text: "Name",
//           width: 3,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//       PosColumn(
//           text: 'Rabeeh',
//           width: 6,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//     ]);
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'Order type    ',
//           width: 3,
//           styles:
//               PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           text: "Sales Invoice",
//           width: 3,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//       PosColumn(
//           text: 'orderType',
//           width: 6,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.right)),
//     ]);
//     bytes += generator.hr();
//     bytes += generator.row([
//       PosColumn(
//           text: 'SL',
//           width: 1,
//           styles: PosStyles(
//             height: PosTextSize.size1,
//           )),
//       PosColumn(
//           text: 'Item Name',
//           width: 5,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(
//           text: 'Qty',
//           width: 1,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(
//           text: 'Rate',
//           width: 2,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(
//           text: 'Net',
//           width: 3,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//     bytes += generator.row([
//       PosColumn(
//           text: 'slNoEnc',
//           width: 1,
//           styles: PosStyles(
//             height: PosTextSize.size1,
//           )),
//       PosColumn(
//           text: 'product',
//           width: 5,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(
//           text: 'qtyEnc',
//           width: 1,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(
//           text: 'rateEnc',
//           width: 2,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(
//           text: 'netEnc',
//           width: 3,
//           styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//     bytes += generator.hr();
//
//     bytes += generator.hr();
//     bytes += generator.emptyLines(0);
//     // bytes += generator.row([
//     //   PosColumn(text: 'Name', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(
//     //       text: "supplier_name",
//     //       width: 7,
//     //       styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left, bold: textStyleSwitch)),
//     // ]);
//     //
//     // /// customer cr number
//     // ///
//     //
//     // /// customer vat number
//     //
//     // bytes += generator.row([
//     //   PosColumn(text: 'Voucher No', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(
//     //       text: "voucherNumber",
//     //       width: 7,
//     //       styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left, bold: textStyleSwitch)),
//     // ]);
//     //
//     // bytes += generator.row([
//     //   PosColumn(text: 'Date', width: 4, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: textStyleSwitch)),
//     //   PosColumn(
//     //       text: "date",
//     //       width: 7,
//     //       styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left, bold: textStyleSwitch)),
//     // ]);
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     //
//     // bytes +=  generator.text("companyNameEnc", styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
//     //
//     // bytes +=   generator.text("companyNameEnc", styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
//     //
//     //
//     //
//     //
//     //
//     //
//     // bytes +=   generator.text("invoiceTypeEnc", styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     // bytes +=  generator.text("invoiceTypeArabicEnc", styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
//     //
//     // generator.emptyLines(1);
//     //
//     //
//     //
//     //
//     //
//     // generator.row([
//     //   PosColumn(text: 'Token No ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "tokenEnc", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: '25', width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     //
//     //
//     // generator.row([
//     //   PosColumn(text: 'Voucher No  ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: "SE 254", width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     //
//     // generator.row([
//     //   PosColumn(text: 'Date  ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: "20-02-2021", width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     //
//     //
//     //
//     //
//     //
//     // // printer.row([
//     // //   PosColumn(text: '', width: 5, styles: PosStyles(fontType: PosFontType.fontB)),
//     // //   PosColumn(text: "", width: 7, styles: PosStyles(align: PosAlign.right)),
//     // // ]);
//     //
//     // // printer.row([
//     // //   PosColumn(text: 'Token No ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: token, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // // ]);
//     //
//     // // printer.row([
//     // //   PosColumn(text: 'Voucher No :', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: voucherNumber, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // // ]);
//     // // printer.row([
//     // //   PosColumn(text: 'Date      ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: date, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // // ]);
//     //
//     // // if(customerName != ""){
//     // //   printer.row([
//     // //     PosColumn(text: 'Name    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //     PosCol
//     // //     umn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //     PosColumn(textEncoded: customerNameEnc, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   ]);
//     // // }
//     // //
//     // // if(customerPhone != ""){
//     // //   printer.row([
//     // //     PosColumn(text: 'Phone    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //     PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //     PosColumn(textEncoded: phoneNoEncoded, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   ]);
//     // // }
//     // //
//     //
//     //
//     // // printer.row([
//     // //   PosColumn(text: 'Order type    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // //   PosColumn(text: orderType, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // // ]);
//     //
//     //
//     //
//     // // printer.setStyles(PosStyles(align: PosAlign.center));
//     // // printer.setStyles(PosStyles(align: PosAlign.left));
//     //
//     // generator.row([
//     //   PosColumn(
//     //       text: 'SL',
//     //       width: 1,
//     //       styles: PosStyles(
//     //         height: PosTextSize.size1,
//     //       )),
//     //   PosColumn(
//     //       text: 'Item Name',
//     //       width: 5,
//     //       styles: PosStyles(
//     //           height: PosTextSize.size1,
//     //           align:PosAlign.center
//     //       )),
//     //   PosColumn(text: 'Qty', width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     //   PosColumn(text: 'Rate', width: 2, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: 'Net', width: 3, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     // ]);
//     //
//     //
//     // generator.hr();
//     //
//     // for (var i = 0; i < 5; i++) {
//     //   var slNo = i + 1;
//     //
//     //
//     //   generator.row([
//     //     PosColumn(
//     //         text: "$slNo",
//     //         width: 1,
//     //         styles: PosStyles(
//     //           height: PosTextSize.size1,
//     //         )),
//     //     PosColumn(text: 'productName', width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //     PosColumn(text: '25', width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     //     PosColumn(text: roundStringWith('25'), width: 2, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     //     PosColumn(text: roundStringWith('58'), width: 3, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     //   ]);
//     //
//     //   generator.row([
//     //     PosColumn(text: 'description', width: 7, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
//     //     PosColumn(
//     //         text: '',
//     //         width: 5,
//     //         styles: PosStyles(
//     //           height: PosTextSize.size1,
//     //         ))]);
//     //   generator.hr();
//     // }
//     // generator.emptyLines(1);
//     // generator.row([
//     //   PosColumn(text: 'Gross Amount', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "grossAmount", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: roundStringWith("8877"), width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     // generator.row([
//     //   PosColumn(text: 'Total Tax', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "tt", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: roundStringWith("98"), width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     // generator.row([
//     //   PosColumn(text: 'Discount', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "dis", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     //   PosColumn(text: roundStringWith('36'), width: 6, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//     // generator.setStyles(PosStyles.defaults());
//     // generator.setStyles(PosStyles(codeTable: 'CP864'));
//     // generator.hr();
//     // generator.row([
//     //   PosColumn(text: 'Grand Total', width: 3, styles: PosStyles(bold: true, fontType: PosFontType.fontB)),
//     //   PosColumn(text: "gt", width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right, bold: true)),
//     //   PosColumn(
//     //       text: "SAR" + " " + roundStringWith("2541"),
//     //       width: 6,
//     //       styles: PosStyles(fontType: PosFontType.fontA, bold: true, align: PosAlign.right)),
//     // ]);
//     //
//     //
//     //
//     //
//     //
//     // bytes += generator.hr();
//     //
//     // bytes += generator.hr();
//     //
//     // bytes += generator.hr();
//     return bytes;
//   }
// }
//
// class ESCPrinterServicesArabix {
//   bool autoCut;
//   bool openDrawer;
//   int blankSpace;
//   var prefs;
//
//   List<int>? _bytes;
//
//   List<int>? get bytes => _bytes;
//   PaperSize? _paperSize;
//   CapabilityProfile? _profile;
//
//   ESCPrinterServicesArabix(
//       this.autoCut, this.openDrawer, this.blankSpace, this.prefs);
//
//   Future<List<int>> getBytes({
//     PaperSize paperSize = PaperSize.mm80,
//     required CapabilityProfile profile_mobile,
//     String name = "default",
//   }) async {
//     List<int> bytes = [];
//     _profile = profile_mobile;
//     _paperSize = paperSize;
//     Generator generator = Generator(_paperSize!, _profile!);
//     var textStyleSwitch = true;
//
//     var invoiceType = "EXPENSE";
//     var invoiceTypeArabic = "";
//
//     bytes += generator.emptyLines(1);
//     bytes += generator.text(
//       invoiceType,
//       styles: PosStyles(
//           align: PosAlign.center,
//           height: PosTextSize.size2,
//           width: PosTextSize.size1,
//           fontType: PosFontType.fontB,
//           bold: textStyleSwitch),
//     );
//     bytes += generator.emptyLines(1);
//
//     /// company phone number
//
//     /// customer phone number
//
//     bytes += generator.setGlobalFont(PosFontType.fontA);
//
//     /// customer vat number
//
//     bytes += generator.row([
//       PosColumn(
//           text: 's',
//           width: 4,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               bold: textStyleSwitch)),
//       PosColumn(
//           text: ':',
//           width: 1,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               bold: textStyleSwitch)),
//       PosColumn(
//           text: "السلام عليكم",
//           width: 7,
//           styles: PosStyles(
//               height: PosTextSize.size1,
//               width: PosTextSize.size1,
//               align: PosAlign.left,
//               bold: textStyleSwitch)),
//     ]);
//
//     bytes += generator.hr();
//
//     bytes += generator.hr();
//
//     bytes += generator.hr();
//     return bytes;
//   }
// }
