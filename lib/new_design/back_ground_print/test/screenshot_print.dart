// import 'dart:developer';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/back_ground_print/test/a.dart';
// import 'package:rassasy_new/new_design/back_ground_print/test/b.dart';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'dart:io';
// import 'package:get/get.dart';
//
//
//
// class TestDemoPrintingOption extends StatefulWidget {
//   const TestDemoPrintingOption({Key? key}) : super(key: key);
//
//   @override
//   State<TestDemoPrintingOption> createState() => _TestDemoPrintingOptionState();
// }
//
// class _TestDemoPrintingOptionState extends State<TestDemoPrintingOption> {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   ScreenshotController screenshotController = ScreenshotController();
//   String dir = Directory.current.path;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(dir);
//
//   }
//   void testPrintingme(String printerIp, Uint8List theimageThatComesfr) async {
//     print("printing function called ");
//     // TODO Don't forget to choose printer's paper size
//     const PaperSize paper = PaperSize.mm80;
//     print("1 ");
//     final profile = await CapabilityProfile.load();
//     print("2");
//     final printer = NetworkPrinter(paper, profile);
//     print("3");
//     final PosPrintResult res = await printer.connect(printerIp, port: 9100);
//     print("4");
//     if (res == PosPrintResult.success) {
//       print("5");
//       await testReceiptImage(printer, theimageThatComesfr);
//       print("6");
//       print(res.msg);
//       await Future.delayed(const Duration(seconds: 3), () {
//         printer.disconnect();
//       });
//     }
//   }
//
//   void testPrintingText(String printerIp) async {
//     print("printing function called ");
//     // TODO Don't forget to choose printer's paper size
//     const PaperSize paper = PaperSize.mm80;
//     print("1 ");
//     final profile = await CapabilityProfile.load();
//     print("2");
//     final printer = NetworkPrinter(paper, profile);
//     print("3");
//     final PosPrintResult res = await printer.connect(printerIp, port: 9100);
//     print("4");
//     if (res == PosPrintResult.success) {
//       print("5");
//       await testReceiptText(printer,"Test");
//       print("6");
//       print(res.msg);
//       await Future.delayed(const Duration(seconds: 3), () {
//         printer.disconnect();
//       });
//     }
//   }
//
//
//
//
//   TextEditingController Printer = TextEditingController()..text = "192.168.1.16";
//
//
//   var invoiceType = "SALES INVOICE";
//   var invoiceTypeArabic = "فاتورة المبيعات";
//   var companyName = " VIKNCODES";
//   var companyAddress1 = "Nnear hilte";
//   var companyAddress2 = ",calicut ";
//   var companyDescription = "Company description ";
//   var companyCountry = "India";
//   var companyPhone = "56154154165";
//   var companyTax = "6363636363636";
//   var companyCrNumber = "8858785";
//   var totalQty = "0.00";
//   var currencyCode = "SR";
//   var voucherNumber = "SI ";
//   var customerName = "Rabeeh";
//   var customerVatNumber = "363656589545";
//   var customerCrNumber = "2545874545";
//   var date = "25-02-2023";
//   var phone = "8714152075";
//   var grossAmount = "0.00";
//   var discount = "0.00";
//   var totalTax = "0.00";
//   var grandTotal = "0.00";
//   var companyLogo = "";
//
//   var qrCode = "";
//
//   var fontSize = 10;
//
//
//   Widget demoReciept() {
//     return Container(
// // color: Colors.red,
//         width: MediaQuery
//             .of(context)
//             .size
//             .width,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//           //crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Padding(
//             //   padding: const EdgeInsets.all(8.0),
//             //   child: Container(
//             //       height: 100,
//             //       width: 100,
//             //       child: Image.network(companyLogo+"sd")),
//             // ),
//             Column(
//               children: [
//                 Text(
//                   companyName,
//                   style: TextStyle(
//                       fontSize: 23, fontWeight: FontWeight.bold),
//                 ),
//                 companyDescription != "" ? Text(
//                   companyDescription,
//                   style: TextStyle(
//                       fontSize: 21, fontWeight: FontWeight.bold),
//                 ) : Container(),
//                 Text(
//                   companyAddress1 + companyAddress2,
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             ),
//             Row(
//               children: [
//                 Text(
//                   companyTax + " :",
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "الرقم الضريبي",
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             ),
//             companyCrNumber != ""
//                 ? Row(
//               children: [
//                 Text(
//                   companyCrNumber + " :",
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   "س. ت",
//                   style: TextStyle(
//                       fontSize: 19,
//                       fontWeight: FontWeight.bold),
//                 ),
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             )
//                 : Container(),
//             Row(
//               children: [
//                 Text(
//                   companyPhone,
//                   style: TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ],
//               mainAxisAlignment: MainAxisAlignment.center,
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   invoiceType,
//                   style: TextStyle(
//                       fontSize: 21, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   invoiceTypeArabic,
//                   style: TextStyle(
//                       fontSize: 21, fontWeight: FontWeight.bold),
//                 ),
//               ],
//
//             ),
//             SizedBox(
//               height: 10,
//               child: Text(
//                   "--------------------------------------------------------------------------------------------------------"),
//             ),
//             Container(
//
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         "Voucher No",
//                         style: TextStyle(
//
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         voucherNumber,
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         "رقم الفاتورة",
//                         style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "Date",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       date,
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "تاريخ",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//               ],
//             ),
//             Container(
//
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         'name'.tr,
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         customerName,
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: Text(
//                         "اسم",
//                         style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     flex: 1,
//                   ),
//                 ],
//               ),
//             ),
//             customerCrNumber != ""
//                 ? Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "CR Number",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       customerCrNumber,
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "س. ت",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//               ],
//             )
//                 : Container(),
//             customerVatNumber != ""
//                 ? Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "VAT No",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       customerVatNumber,
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "الرقم الضريبي",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//               ],
//             )
//                 : Container(),
//             phone != ""
//                 ? Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "Phone",
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       phone,
//                       style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//                 Expanded(
//                   child: Center(
//                     child: Text(
//                       "هاتف",
//                       style: TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   flex: 1,
//                 ),
//               ],
//             )
//                 : Container(),
//             SizedBox(
//               height: 20,
//               child: Text(
//                   "--------------------------------------------------------------------------------------------------------"),
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.only(left: 2.0, right: 2.00),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width / 9,
//                     height: 50,
//                     // color: Colors.yellow,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "SL",
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "رقم",
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width / 3,
//                     // color: Colors.red,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Product name",
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "اسم المنتج",
//                           style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width / 8,
//                     // color: Colors.green,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Qty",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "كمية",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width / 8,
//                     // color: Colors.blue,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Rate",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "معدل",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 50,
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width / 8,
//                     // color: Colors.blueGrey,
//                     child: Align(
//                       alignment: Alignment.centerRight,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Net",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "مجموع",
//                             style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10,
//               child: Text(
//                   "--------------------------------------------------------------------------------------------------------"),
//             ),
//             Padding(
//               padding:
//               const EdgeInsets.only(left: 2.0, right: 2.00),
//               child: ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 shrinkWrap: true,
//                 physics: ScrollPhysics(),
//                 itemCount: 2,
//                 itemBuilder: (context, index) {
//                   return Column(
//                     children: [
//                       SizedBox(
//                         height: 5,
//
//                       ),
//                       Row(
//                         mainAxisAlignment:
//                         MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Container(
//                               child: Center(
//                                 child: Text(
//                                   "${index + 1}",
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             flex: 1,
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Column(
//                                 children: [
//                                   Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//
//                                           "productName",
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//
//
//                                   Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       'description'.tr,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   )
//
//                                 ],
//                               ),
//                             ),
//                             flex: 6,
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   roundStringWith(
//                                       "1.00"),
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             flex: 2,
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   roundStringWith(
//                                     "unitPrice"),
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             flex: 2,
//                           ),
//                           Expanded(
//                             child: Center(
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   roundStringWith(
//                                       "120"),
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.w700),
//                                 ),
//                               ),
//                             ),
//                             flex: 2,
//                           ),
//                         ],
//                       ),
//
//                     ],
//                   );
//                 },
//               ),
//             ),
//
//             SizedBox(
//               height: 10,
//               child: Text(
//                   "--------------------------------------------------------------------------------------------------------"),
//             ),
//
//
//             Padding(
//               padding:
//               const EdgeInsets.only(left: 2.0, right: 2.00),
//               child: Column(
//                 children: [
//
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Total Quantity",
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "(الكمية الإجمالية)",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           roundStringWith(totalQty),
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Gross Amount",
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "(المبلغ الإجمالي)",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//
//                         //
//                         // Text(
//                         //   "Gross Amount (المبلغ الإجمالي)",
//                         //   style: TextStyle(
//                         //       fontSize: 13,
//                         //       fontWeight: FontWeight.w700),
//                         // ),
//                         Text(
//                           roundStringWith(grossAmount),
//
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               'disc'.tr,
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "(خصم)",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Text(
//
//                           roundStringWith(discount),
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment:
//                           MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Total Tax",
//                               style: TextStyle(
//                                   fontSize: 15,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "(مجموع الضريبة)",
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                         Text(
//
//                           roundStringWith(totalTax),
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 2,
//                   ),
//                   Container(
//                     width: MediaQuery
//                         .of(context)
//                         .size
//                         .width,
//                     child: Row(
//                       mainAxisAlignment:
//                       MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Grand Total (المبلغ الإجمالي)",
//                           style: TextStyle(
//                               fontSize: 19,
//                               fontWeight: FontWeight.w700),
//                         ),
//                         Container(
//                           child: Text(
//
//                             currencyCode + ' ' + roundStringWith(grandTotal),
//                             style: TextStyle(
//                                 fontSize: 17,
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             SizedBox(
//               height: 20,
//             ),
//           ],
//         ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("معاينة الوصل قبل الطباعة "),
//       ),
//       body: Center(
//           child: ListView(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextField(
//                     controller: Printer,
//                     decoration: InputDecoration(hintText: "printer ip"),
//                   ),
//
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // ElevatedButton(
//                   //   child: Text(
//                   //     'print res',
//                   //     style: TextStyle(fontSize: 40),
//                   //   ),
//                   //   onPressed: () {
//                   //     screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
//                   //       theimageThatComesfromThePrinter = capturedImage!;
//                   //       setState(() {
//                   //         theimageThatComesfromThePrinter = capturedImage;
//                   //         testPrintingme(Printer.text, theimageThatComesfromThePrinter);
//                   //       });
//                   //     }).catchError((onError) {
//                   //       print(onError);
//                   //     });
//                   //   },
//                   // ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//
//                       ElevatedButton(
//                         child: Text(
//                           'print image',
//                           style: TextStyle(fontSize: 40),
//                         ),
//                         onPressed: () {
//                           screenshotController.capture(delay: Duration(milliseconds: 10)).then((capturedImage) async {
//
//                             log("__________________$capturedImage");
//
//                            //
//                             theimageThatComesfromThePrinter = capturedImage!;
//                             setState(() {
//                               theimageThatComesfromThePrinter = capturedImage;
//                               testPrintingme(Printer.text, capturedImage);
//                             });
//                           }).catchError((onError) {
//                             print(onError);
//                           });
//                         },
//                       ),
//                       ElevatedButton(
//                         child: Text(
//                           'print Text',
//                           style: TextStyle(fontSize: 40),
//                         ),
//                         onPressed: () {
//
//                           testPrintingText(Printer.text);
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Screenshot(
//                     controller: screenshotController,
//                     child: Container(
//                         width: 350,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//
//                           //crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             // Padding(
//                             //   padding: const EdgeInsets.all(8.0),
//                             //   child: Container(
//                             //       height: 100,
//                             //       width: 100,
//                             //       child: Image.network(companyLogo+"sd")),
//                             // ),
//                             Column(
//                               children: [
//                                 Text(
//                                   companyName,
//                                   style: TextStyle(
//                                       fontSize: 23, fontWeight: FontWeight.bold),
//                                 ),
//                                 companyDescription != "" ? Text(
//                                   companyDescription,
//                                   style: TextStyle(
//                                       fontSize: 21, fontWeight: FontWeight.bold),
//                                 ) : Container(),
//                                 Text(
//                                   companyAddress1 + companyAddress2,
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                               mainAxisAlignment: MainAxisAlignment.center,
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   companyTax + " :",
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   "الرقم الضريبي",
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                               mainAxisAlignment: MainAxisAlignment.center,
//                             ),
//                             companyCrNumber != ""
//                                 ? Row(
//                               children: [
//                                 Text(
//                                   companyCrNumber + " :",
//                                   style: TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   "س. ت",
//                                   style: TextStyle(
//                                       fontSize: 19,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                               mainAxisAlignment: MainAxisAlignment.center,
//                             )
//                                 : Container(),
//                             Row(
//                               children: [
//                                 Text(
//                                   companyPhone,
//                                   style: TextStyle(
//                                       fontSize: 18, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                               mainAxisAlignment: MainAxisAlignment.center,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   invoiceType,
//                                   style: TextStyle(
//                                       fontSize: 21, fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   invoiceTypeArabic,
//                                   style: TextStyle(
//                                       fontSize: 21, fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//
//                             ),
//                             SizedBox(
//                               height: 10,
//                               child: Text(
//                                   "--------------------------------------------------------------------------------------------------------"),
//                             ),
//                             Container(
//
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         "Voucher No",
//                                         style: TextStyle(
//
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         voucherNumber,
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         "رقم الفاتورة",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "Date",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       date,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "تاريخ",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                               ],
//                             ),
//                             Container(
//
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         'name'.tr,
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         customerName,
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w700),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                   Expanded(
//                                     child: Center(
//                                       child: Text(
//                                         "اسم",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ),
//                                     flex: 1,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             customerCrNumber != ""
//                                 ? Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "CR Number",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       customerCrNumber,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "س. ت",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                               ],
//                             )
//                                 : Container(),
//                             customerVatNumber != ""
//                                 ? Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "VAT No",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       customerVatNumber,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "الرقم الضريبي",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                               ],
//                             )
//                                 : Container(),
//                             phone != ""
//                                 ? Row(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "Phone",
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       phone,
//                                       style: TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 Expanded(
//                                   child: Center(
//                                     child: Text(
//                                       "هاتف",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                   flex: 1,
//                                 ),
//                               ],
//                             )
//                                 : Container(),
//                             SizedBox(
//                               height: 20,
//                               child: Text(
//                                   "--------------------------------------------------------------------------------------------------------"),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.only(left: 2.0, right: 2.00),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width: 50,
//                                     height: 50,
//                                     // color: Colors.yellow,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "SL",
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           "رقم",
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: 100,
//                                     // color: Colors.red,
//                                     child: Column(
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         Text(
//                                           "Product name",
//                                           style: TextStyle(
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         Text(
//                                           "اسم المنتج",
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: 50,
//                                     // color: Colors.green,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Qty",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             "كمية",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width: 50,
//                                     // color: Colors.blue,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Rate",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             "معدل",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Container(
//                                     height: 50,
//                                     width:50,
//                                     // color: Colors.blueGrey,
//                                     child: Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           Text(
//                                             "Net",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                             "مجموع",
//                                             style: TextStyle(
//                                                 fontSize: 15,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                               child: Text(
//                                   "--------------------------------------------------------------------------------------------------------"),
//                             ),
//                             Padding(
//                               padding:
//                               const EdgeInsets.only(left: 2.0, right: 2.00),
//                               child: ListView.builder(
//                                 scrollDirection: Axis.vertical,
//                                 shrinkWrap: true,
//                                 physics: ScrollPhysics(),
//                                 itemCount: 2,
//                                 itemBuilder: (context, index) {
//                                   return Column(
//                                     children: [
//                                       SizedBox(
//                                         height: 5,
//
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               child: Center(
//                                                 child: Text(
//                                                   "${index + 1}",
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.w700),
//                                                 ),
//                                               ),
//                                             ),
//                                             flex: 1,
//                                           ),
//                                           Expanded(
//                                             child: Center(
//                                               child: Column(
//                                                 children: [
//                                                   Align(
//                                                     alignment: Alignment.centerLeft,
//                                                     child: Text(
//
//                                                       "productName",
//                                                       style: TextStyle(
//                                                           fontSize: 16,
//                                                           fontWeight: FontWeight.bold),
//                                                     ),
//                                                   ),
//
//
//                                                   Align(
//                                                     alignment: Alignment.centerLeft,
//                                                     child: Text(
//                                                       'description'.tr,
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           fontWeight: FontWeight.bold),
//                                                     ),
//                                                   )
//
//                                                 ],
//                                               ),
//                                             ),
//                                             flex: 6,
//                                           ),
//                                           Expanded(
//                                             child: Center(
//                                               child: Align(
//                                                 alignment: Alignment.centerRight,
//                                                 child: Text(
//                                                   roundStringWith(
//                                                       "1.00"),
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.w700),
//                                                 ),
//                                               ),
//                                             ),
//                                             flex: 2,
//                                           ),
//                                           Expanded(
//                                             child: Center(
//                                               child: Align(
//                                                 alignment: Alignment.centerRight,
//                                                 child: Text(
//                                                   roundStringWith(
//                                                       "25.0"),
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.w700),
//                                                 ),
//                                               ),
//                                             ),
//                                             flex: 2,
//                                           ),
//                                           Expanded(
//                                             child: Center(
//                                               child: Align(
//                                                 alignment: Alignment.centerRight,
//                                                 child: Text(
//                                                   roundStringWith(
//                                                       "120"),
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight: FontWeight.w700),
//                                                 ),
//                                               ),
//                                             ),
//                                             flex: 2,
//                                           ),
//                                         ],
//                                       ),
//
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//
//                             SizedBox(
//                               height: 10,
//                               child: Text(
//                                   "--------------------------------------------------------------------------------------------------------"),
//                             ),
//
//
//                             Padding(
//                               padding:
//                               const EdgeInsets.only(left: 2.0, right: 2.00),
//                               child: Column(
//                                 children: [
//
//                                   Container(
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total Quantity",
//                                               style: TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Text(
//                                               "(الكمية الإجمالية)",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//                                           roundStringWith(totalQty),
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Gross Amount",
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Text(
//                                               "(المبلغ الإجمالي)",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//
//                                         //
//                                         // Text(
//                                         //   "Gross Amount (المبلغ الإجمالي)",
//                                         //   style: TextStyle(
//                                         //       fontSize: 13,
//                                         //       fontWeight: FontWeight.w700),
//                                         // ),
//                                         Text(
//                                           roundStringWith(grossAmount),
//
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'disc'.tr,
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Text(
//                                               "(خصم)",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//
//                                           roundStringWith(discount),
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Row(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total Tax",
//                                               style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.w600),
//                                             ),
//                                             Text(
//                                               "(مجموع الضريبة)",
//                                               style: TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//
//                                           roundStringWith(totalTax),
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 2,
//                                   ),
//                                   Container(
//                                     width: MediaQuery
//                                         .of(context)
//                                         .size
//                                         .width,
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           "Grand Total (المبلغ الإجمالي)",
//                                           style: TextStyle(
//                                               fontSize: 19,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                         Container(
//                                           child: Text(
//
//                                             currencyCode + ' ' + roundStringWith(grandTotal),
//                                             style: TextStyle(
//                                                 fontSize: 17,
//                                                 fontWeight: FontWeight.w700),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//
//                             SizedBox(
//                               height: 20,
//                             ),
//                           ],
//                         )),
//                   ),
//
//                   // Screenshot(
//                   //   controller: screenshotController,
//                   //   child: Container(
//                   //       width: 300,
//                   //       child: Column(
//                   //         children: [
//                   //           Row(
//                   //             children: [
//                   //               Text(
//                   //                 "محمد نعم 臺灣  ",
//                   //                 style: TextStyle(
//                   //                     fontSize: 30, fontWeight: FontWeight.bold),
//                   //               ),
//                   //             ],
//                   //             mainAxisAlignment: MainAxisAlignment.center,
//                   //           ),
//                   //           Text(
//                   //               "----------------------------------------------------------------------------------"),
//                   //           Padding(
//                   //             padding: const EdgeInsets.only(bottom: 20.0),
//                   //             child: Row(
//                   //               mainAxisAlignment: MainAxisAlignment.center,
//                   //               children: [
//                   //                 Text(
//                   //                   "(  汉字 )",
//                   //                   style: TextStyle(
//                   //                       fontSize: 40, fontWeight: FontWeight.bold),
//                   //                 ),
//                   //                 SizedBox(
//                   //                   width: 10,
//                   //                 ),
//                   //                 Text(
//                   //                   "رقم الطلب",
//                   //                   style: TextStyle(
//                   //                       fontSize: 30, fontWeight: FontWeight.bold),
//                   //                 ),
//                   //               ],
//                   //             ),
//                   //           ),
//                   //           SizedBox(
//                   //             height: 20,
//                   //             child: Text(
//                   //                 "-------------------------------------------------------------------------------------"),
//                   //           ),
//                   //           Row(
//                   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //             crossAxisAlignment: CrossAxisAlignment.start,
//                   //             children: [
//                   //               Expanded(
//                   //                 child: Center(
//                   //                   child: Text(
//                   //                     "التفاصيل",
//                   //                     style: TextStyle(
//                   //                         fontSize: 25,
//                   //                         fontWeight: FontWeight.bold),
//                   //                   ),
//                   //                 ),
//                   //                 flex: 6,
//                   //               ),
//                   //               Expanded(
//                   //                 child: Center(
//                   //                   child: Text(
//                   //                     "السعر ",
//                   //                     style: TextStyle(
//                   //                         fontSize: 25,
//                   //                         fontWeight: FontWeight.bold),
//                   //                   ),
//                   //                 ),
//                   //                 flex: 2,
//                   //               ),
//                   //               Expanded(
//                   //                 child: Center(
//                   //                   child: Text(
//                   //                     "العدد",
//                   //                     style: TextStyle(
//                   //                         fontSize: 25,
//                   //                         fontWeight: FontWeight.bold),
//                   //                   ),
//                   //                 ),
//                   //                 flex: 2,
//                   //               ),
//                   //             ],
//                   //           ),
//                   //           ListView.builder(
//                   //             scrollDirection: Axis.vertical,
//                   //             shrinkWrap: true,
//                   //             physics: ScrollPhysics(),
//                   //             itemCount: 4,
//                   //             itemBuilder: (context, index) {
//                   //               return Card(
//                   //                 child: Row(
//                   //                   mainAxisAlignment:
//                   //                   MainAxisAlignment.spaceBetween,
//                   //                   crossAxisAlignment: CrossAxisAlignment.start,
//                   //                   children: [
//                   //                     Expanded(
//                   //                       child: Center(
//                   //                         child: Text(
//                   //                           "臺灣",
//                   //                           style: TextStyle(fontSize: 25),
//                   //                         ),
//                   //                       ),
//                   //                       flex: 6,
//                   //                     ),
//                   //                     Expanded(
//                   //                       child: Center(
//                   //                         child: Text(
//                   //                           "تجربة عيوني انتة ",
//                   //                           style: TextStyle(fontSize: 25),
//                   //                         ),
//                   //                       ),
//                   //                       flex: 2,
//                   //                     ),
//                   //                     Expanded(
//                   //                       child: Center(
//                   //                         child: Text(
//                   //                           "Test My little pice of huny",
//                   //                           style: TextStyle(fontSize: 25),
//                   //                         ),
//                   //                       ),
//                   //                       flex: 2,
//                   //                     ),
//                   //                   ],
//                   //                 ),
//                   //               );
//                   //             },
//                   //           ),
//                   //           Text(
//                   //               "----------------------------------------------------------------------------------"),
//                   //         ],
//                   //       )),
//                   // ),
//                   SizedBox(
//                     height: 25,
//                   ),
//                 ],
//               ),
//             ],
//           )),
//     );
//   }
// }
