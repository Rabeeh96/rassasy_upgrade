// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as Img;
// import 'package:intl/intl.dart';
// import 'package:rassasy_new/Print/bluetoothPrint.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
// import 'package:rassasy_new/new_design/back_ground_print/USB/test_page/test_file.dart';
// import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
// import 'package:rassasy_new/new_design/back_ground_print/bluetooth/new.dart';
// import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
// import 'package:rassasy_new/new_design/back_ground_print/wifi_print/customisation_template/customisation_template.dart';
// import 'package:rassasy_new/new_design/dashboard/invoices/controller/invoice_controller_a.dart';
// import 'package:rassasy_new/new_design/dashboard/invoices/model/invoice_model.dart';
// import 'package:rassasy_new/new_design/dashboard/invoices/view/preview_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ViewInvoice extends StatefulWidget {
//   const ViewInvoice({super.key});

//   @override
//   State<ViewInvoice> createState() => _ViewInvoiceState();
// }

// class _ViewInvoiceState extends State<ViewInvoice> {
//   final InvoiceControllerA invoiceController = Get.put(InvoiceControllerA());
//   @override
//   var messageShow = "";

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     invoiceList.clear();
//     fromDateNotifier = ValueNotifier(DateTime.now());
//     toDateNotifier = ValueNotifier(DateTime.now());
//     viewList();
//   }

//   DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
//   DateFormat timeFormat = DateFormat.jm();
//   DateFormat dateFormat = DateFormat("dd/MM/yyy");

//   late ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
//   late ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());

//   Future<Null> viewList() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       dialogBox(context, "Please check your network connection");
//     } else {
//       try {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         start(context);
//         String baseUrl = BaseUrl.baseUrl;
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         // pr(accessToken);
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;

//         final String url = '$baseUrl/posholds/list-pos-hold-invoices/';
//         String selectedType = invoiceController.selectedPosValue.value;
//         pr("radioselect $selectedType");
//         Map data = {
//           "CompanyID": companyID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "page_number": pageNumber,
//           "page_size": itemPerPage,
//           "from_date": apiDateFormat.format(fromDateNotifier.value),
//           "to_date": apiDateFormat.format(toDateNotifier.value),
//           "Type": selectedType
//         };
//         print(url);
//         print(data);

//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);

//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(status);

//         var responseJson = n["data"];
//         print(response.body);

//         if (status == 6000) {
//           if (firstTime == 1) {
//             invoiceList.clear();
//             stop();
//           }
//           isLoading = false;
//           stop();
//           setState(() {
//             messageShow = "";

//             for (Map user in responseJson) {
//               invoiceList.add(InvoiceModelClass.fromJson(user));
//             }
//             if (invoiceList.isEmpty) {
//               messageShow = "No sale during these period";
//             }
//           });
//         } else if (status == 6001) {
//           if (firstTime == 1) {
//             stop();
//           }
//           isLoading = false;
//           messageShow = "No sale during these period";
//           stop();
//         } else {
//           if (firstTime == 1) {
//             stop();
//           }
//           isLoading = false;
//           stop();
//         }
//       } catch (e) {
//         if (firstTime == 1) {
//           stop();
//         }
//         isLoading = false;
//         stop();
//         print("Error ${e.toString()}");
//       }
//     }
//   }

//   var networkConnection = true;

//   showDatePickerFunction(context, ValueNotifier dateNotifier) {
//     final mHeight = MediaQuery.of(context).size.height;
//     final mWidth = MediaQuery.of(context).size.width / 2;
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         content: SizedBox(
//           width: mWidth * .98,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding:
//                         EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
//                     child: Center(
//                       child: Text(
//                         'select_date'.tr,
//                         style: customisedStyle(
//                             context, Colors.black, FontWeight.bold, 18.0),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               CalendarDatePicker(
//                 onDateChanged: (selectedDate) {
//                   messageShow = "";
//                   dateNotifier.value = selectedDate;
//                   viewList();
//                   Navigator.pop(context);
//                 },
//                 initialDate: DateTime.now(),
//                 firstDate: DateTime.now().add(
//                   const Duration(days: -100000000),
//                 ),
//                 lastDate: DateTime.now().add(const Duration(days: 6570)),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: const Color(0xffF8F8F8),
//         appBar: AppBar(
//           backgroundColor: const Color(0xffF3F3F3),
//           elevation: 0.0,
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Invoices'.tr,
//                 style: customisedStyle(
//                     context, Colors.black, FontWeight.bold, 18.0),
//               ),
//             ],
//           ),
//           actions: const [],
//         ),
//         body: networkConnection == true
//             ? Column(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 10,
//                     child: Row(
//                       children: [
//                         ValueListenableBuilder(
//                             valueListenable: fromDateNotifier,
//                             builder: (BuildContext ctx,
//                                 DateTime fromDateNewValue, _) {
//                               return GestureDetector(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         'from'.tr,
//                                         style: customisedStyle(
//                                             context,
//                                             Colors.black,
//                                             FontWeight.w800,
//                                             12.0),
//                                       ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color:
//                                                     const Color(0xffCBCBCB))),
//                                         height:
//                                             MediaQuery.of(context).size.height /
//                                                 15,
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 7,
//                                         child: Row(
//                                           children: [
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             const Icon(
//                                               Icons.calendar_today_outlined,
//                                               color: Colors.black,
//                                             ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                     dateFormat.format(
//                                                         fromDateNewValue),
//                                                     style: customisedStyle(
//                                                         context,
//                                                         Colors.black,
//                                                         FontWeight.w700,
//                                                         12.0)),

//                                                 //  Text("12.00", style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
//                                               ],
//                                             )
//                                           ],
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   showDatePickerFunction(
//                                       context, fromDateNotifier);
//                                 },
//                               );
//                             }),
//                         ValueListenableBuilder(
//                             valueListenable: toDateNotifier,
//                             builder: (BuildContext ctx,
//                                 DateTime fromDateNewValue, _) {
//                               return GestureDetector(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Row(
//                                     children: [
//                                       Text(
//                                         'to'.tr,
//                                         style: customisedStyle(
//                                             context,
//                                             Colors.black,
//                                             FontWeight.w800,
//                                             12.0),
//                                       ),
//                                       const SizedBox(
//                                         width: 10,
//                                       ),
//                                       Container(
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color:
//                                                     const Color(0xffCBCBCB))),
//                                         height:
//                                             MediaQuery.of(context).size.height /
//                                                 15,
//                                         width:
//                                             MediaQuery.of(context).size.width /
//                                                 7,
//                                         child: Row(
//                                           children: [
//                                             const SizedBox(
//                                               width: 10,
//                                             ),
//                                             const Icon(
//                                               Icons.calendar_today_outlined,
//                                               color: Colors.black,
//                                             ),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Text(
//                                                     dateFormat.format(
//                                                         fromDateNewValue),
//                                                     style: customisedStyle(
//                                                         context,
//                                                         Colors.black,
//                                                         FontWeight.w700,
//                                                         12.0)),
//                                                 //  Text("12.00", style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(width: screenSize.width * 0.01),
//                                       Obx(
//                                         () => Row(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Radio(
//                                                   activeColor:
//                                                       const Color(0xFF00428E),
//                                                   value: 'Dining',
//                                                   groupValue: invoiceController
//                                                       .selectedPosValue.value,
//                                                   onChanged: (value) {
//                                                     invoiceController
//                                                         .updateValue(
//                                                             value.toString());
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Dining",
//                                                   style: customisedStyle(
//                                                       context,
//                                                       Colors.black,
//                                                       FontWeight.w700,
//                                                       12.0),
//                                                 )
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Radio(
//                                                   activeColor:
//                                                       const Color(0xFF00428E),
//                                                   value: 'TakeAway',
//                                                   groupValue: invoiceController
//                                                       .selectedPosValue.value,
//                                                   onChanged: (value) {
//                                                     invoiceController
//                                                         .updateValue(
//                                                             value.toString());
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Takeout",
//                                                   style: customisedStyle(
//                                                       context,
//                                                       Colors.black,
//                                                       FontWeight.w700,
//                                                       12.0),
//                                                 )
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Radio(
//                                                   activeColor:
//                                                       const Color(0xFF00428E),
//                                                   value: 'Order',
//                                                   groupValue: invoiceController
//                                                       .selectedPosValue.value,
//                                                   onChanged: (value) {
//                                                     invoiceController
//                                                         .updateValue(
//                                                             value.toString());
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Order",
//                                                   style: customisedStyle(
//                                                       context,
//                                                       Colors.black,
//                                                       FontWeight.w700,
//                                                       12.0),
//                                                 )
//                                               ],
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Radio(
//                                                   activeColor:
//                                                       const Color(0xFF00428E),
//                                                   value: 'Car',
//                                                   groupValue: invoiceController
//                                                       .selectedPosValue.value,
//                                                   onChanged: (value) {
//                                                     invoiceController
//                                                         .updateValue(
//                                                             value.toString());
//                                                   },
//                                                 ),
//                                                 Text(
//                                                   "Car",
//                                                   style: customisedStyle(
//                                                       context,
//                                                       Colors.black,
//                                                       FontWeight.w700,
//                                                       12.0),
//                                                 )
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(width: screenSize.width * 0.01),
//                                       SizedBox(
//                                         width: screenSize.width * 0.2,
//                                         child: const TextField(
//                                           decoration: InputDecoration(
//                                               border: OutlineInputBorder(),
//                                               hintText: "Search"),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   showDatePickerFunction(
//                                       context, toDateNotifier);
//                                 },
//                               );
//                             }),
//                       ],
//                     ),
//                   ),
//                   const Divider(),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * .7,
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: NotificationListener<ScrollNotification>(
//                             onNotification: (ScrollNotification scrollInfo) {
//                               print("-**********************1");
//                               if (!isLoading &&
//                                   scrollInfo.metrics.pixels ==
//                                       scrollInfo.metrics.maxScrollExtent) {
//                                 print("-**********************");
//                                 pageNumber = pageNumber + 1;
//                                 firstTime = 10;
//                                 viewList();
//                                 setState(() {
//                                   isLoading = true;
//                                 });
//                               }
//                               return true;
//                             },
//                             child: RefreshIndicator(
//                                 color: Colors.blue,
//                                 onRefresh: () async {
//                                   pageNumber = 1;
//                                   invoiceList.clear();
//                                   viewList();
//                                 },
//                                 child: ListView.builder(
//                                     // the number of items in the list
//                                     itemCount: invoiceList.length,
//                                     // display each item of the product list
//                                     itemBuilder: (context, index) {
//                                       return GestureDetector(
//                                           onTap: () async {
//                                             var result =
//                                                 await Get.to(InvoiceDetailPage(
//                                               MasterUID: invoiceList[index]
//                                                   .salesMasterID,
//                                               detailID: invoiceList[index]
//                                                   .saleOrderID,
//                                               masterType: 'SI',
//                                             ));

//                                             if (result != null) {
//                                               pageNumber = 1;
//                                               invoiceList.clear();
//                                               viewList();
//                                             }
//                                           },
//                                           child: Card(
//                                             elevation: 0,
//                                             shape: RoundedRectangleBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(3),
//                                                 side: const BorderSide(
//                                                     width: 1,
//                                                     color: Color(0xffDFDFDF))),
//                                             color: const Color(0xffffffff),
//                                             child: SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width /
//                                                   1.1,
//                                               child: Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
                                                
//                                                   SizedBox(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width /
//                                                             1.5,
//                                                     child: Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           SizedBox(
//                                                             width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width /
//                                                                 8,
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   invoiceList[
//                                                                           index]
//                                                                       .voucherNo,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       Colors
//                                                                           .black,
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       13.0),
//                                                                 ),
//                                                                 Text(
//                                                                   invoiceList[
//                                                                           index]
//                                                                       .date,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       const Color(
//                                                                           0xff585858),
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       12.0),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width /
//                                                                 8,
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   'token_no'.tr,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       const Color(
//                                                                           0xff9A9A9A),
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       12.0),
//                                                                 ),
//                                                                 Text(
//                                                                   invoiceList[
//                                                                           index]
//                                                                       .tokenNo,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       Colors
//                                                                           .black,
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       12.0),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width /
//                                                                 3,
//                                                             child: Column(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .start,
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(
//                                                                   'customer'.tr,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       Colors
//                                                                           .black,
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       13.0),
//                                                                 ),
//                                                                 Text(
//                                                                   invoiceList[
//                                                                           index]
//                                                                       .custName,
//                                                                   style: customisedStyle(
//                                                                       context,
//                                                                       const Color(
//                                                                           0xff585858),
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       12.0),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width:
//                                                         MediaQuery.of(context)
//                                                                 .size
//                                                                 .width /
//                                                             5,
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment.end,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .only(
//                                                                   right: 15.0),
//                                                           child: Text(
//                                                               roundStringWith(
//                                                                   invoiceList[
//                                                                           index]
//                                                                       .salesData[
//                                                                           "GrandTotal"]
//                                                                       .toString()),
//                                                               style:
//                                                                   customisedStyle(
//                                                                       context,
//                                                                       Colors
//                                                                           .black,
//                                                                       FontWeight
//                                                                           .w600,
//                                                                       13.0)),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ));
//                                     })),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             : noNetworkConnectionPage(),
//       ),
//     );
//   }

//   bool isLoading = false;
//   var pageNumber = 1;
//   var itemPerPage = 10;
//   var firstTime = 1;
//   var listLength = 1;
//   Uint8List? resizedImageBytes;

//   void _resizeImage() async {
//     print(
//         "Date ---------1   ---------1   ---------1    ${DateTime.now().second} ");

//     var id = "9eee65e7-d6f7-4ece-b0dc-5341a33365e6";
//     var arabicImageBytes =
//         await printHelperNew.printDetails(id: id, type: "SI", context: context);

//     print(
//         "Date ---------4   ---------4   ---------4    ${DateTime.now().second} ");
//     // Step 1: Decode and resize the image using the image package

//     print(
//         "Date ---------5   ---------5   ---------5    ${DateTime.now().second} ");

//     pr("--------------${arabicImageBytes.runtimeType}---------$arabicImageBytes");

//     final Img.Image? image = Img.decodeImage(arabicImageBytes);

//     print(
//         "Date ---------6   ---------6   ---------6    ${DateTime.now().second} ");
//     final Img.Image resizedImage = Img.copyResize(image!, width: 570);
//     print(
//         "Date ---------7   ---------7   ---------7    ${DateTime.now().second} ");
//     // Step 2: Convert the Img.Image back to Uint8List
//     resizedImageBytes = Uint8List.fromList(Img.encodePng(resizedImage));
//     print(
//         "Date ---------8   ---------8   ---------8    ${DateTime.now().second} ");
//     // Trigger a rebuild to display the resized image
//     setState(() {});
//   }

//   //
//   var printHelperNew = USBPrintClassTest();
//   var printHelperUsb = USBPrintClass();
//   var printHelperIP = AppBlocs();
//   var bluetoothHelper = AppBlocsBT();
//   var wifiNewMethod = WifiPrintClassTest();

//   printDetail(id, voucherType) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var defaultIp = prefs.getString('defaultIP') ?? '';
//     var printType = prefs.getString('PrintType') ?? 'Wifi';
//     var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
//     var temp = prefs.getString("template") ?? "template4";
//     if (defaultIp == "") {
//       popAlert(
//           head: "Error",
//           message: "Please select a printer",
//           position: SnackPosition.TOP);
//     } else {
//       if (printType == 'Wifi') {
//         if (temp == "template5") {
//           var ip = "";
//           if (PrintDataDetails.type == "SO") {
//             ip = defaultOrderIP;
//           } else {
//             ip = defaultIp;
//           }

//           print("temp  $temp");
//           wifiNewMethod.printDetails(
//               id: id,
//               type: voucherType,
//               context: context,
//               ipAddress: ip,
//               isCancelled: false,
//               orderSection: false);
//         } else {
//           var ret = await printHelperIP.printDetails();
//           if (ret == 2) {
//             var ip = "";
//             if (PrintDataDetails.type == "SO") {
//               ip = defaultOrderIP;
//             } else {
//               ip = defaultIp;
//             }
//             printHelperIP.print_receipt(ip, context, false, false);
//           } else {
//             popAlert(
//                 head: "Error",
//                 message: "Please try again later",
//                 position: SnackPosition.TOP);
//           }
//         }
//       } else if (printType == 'USB') {
//         if (temp == "template5") {
//           print(
//               "Date ---------step 1   ---------   ---------     ${DateTime.now().second} ");
//           printHelperNew.printDetails(
//               id: id, type: voucherType, context: context);
//         } else {
//           var ret = await printHelperUsb.printDetails();
//           if (ret == 2) {
//             var ip = "";
//             if (PrintDataDetails.type == "SO") {
//               ip = defaultOrderIP;
//             } else {
//               ip = defaultIp;
//             }
//             printHelperUsb.printReceipt(ip, context);
//           } else {
//             popAlert(
//                 head: "Error",
//                 message: "Please try again later",
//                 position: SnackPosition.TOP);
//           }
//         }

//         /// commented
//       } else {
//         var loadData =
//             await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
//         // handlePrint(context);

//         if (loadData) {
//           var printStatus = await bluetoothHelper.scan(false);
//           if (printStatus == 1) {
//             dialogBox(context, "Check your bluetooth connection");
//           } else if (printStatus == 2) {
//             dialogBox(context, "Your default printer configuration problem");
//           } else if (printStatus == 3) {
//             await bluetoothHelper.scan(false);
//             // alertMessage("Try again");
//           } else if (printStatus == 4) {
//             //  alertMessage("Printed successfully");
//           }
//         } else {
//           dialogBox(context, "Try again");
//         }
//       }
//     }
//   }

//   Future<void> handlePrint(BuildContext context) async {
//     var bluetoothHelper = BluetoothHelperNew();
//     var printStatus = await bluetoothHelper.scan();

//     switch (printStatus) {
//       case 1:
//         dialogBox(context, "Check your bluetooth connection");
//         break;
//       case 2:
//         dialogBox(context, "Your default printer configuration problem");
//         break;
//       case 3:
//         await bluetoothHelper.scan();
//         // alertMessage("Try again");
//         break;
//       case 4:
//         // alertMessage("Printed successfully");
//         break;
//     }
//   }

//   Widget noNetworkConnectionPage() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SvgPicture.asset(
//             "assets/svg/warning.svg",
//             width: 100,
//             height: 100,
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Text(
//             'no_network'.tr,
//             style: const TextStyle(
//                 color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           TextButton(
//             onPressed: () {
//               //getAllTax();
//               // defaultData();
//             },
//             style: ButtonStyle(
//                 backgroundColor:
//                     WidgetStateProperty.all(const Color(0xffEE830C))),
//             child: Text('retry'.tr,
//                 style: const TextStyle(
//                   color: Colors.white,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }

// List<InvoiceModelClass> invoiceList = [];
