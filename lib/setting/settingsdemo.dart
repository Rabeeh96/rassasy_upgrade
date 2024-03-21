// import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
//
// class SettingsPageDemo extends StatefulWidget {
//   @override
//   State<SettingsPageDemo> createState() => _SettingsPageDemoState();
// }
//
// class _SettingsPageDemoState extends State<SettingsPageDemo> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     viewList();
//   }
//   TextEditingController tokenNoController=TextEditingController();
//   bool paymentMethod = true;
//   bool quantityIncrement = true;
//   bool kotPrint = true;
//   bool showInvoice = true;
//   bool clearTable = true;
//   bool printAfterPayment = true;
//   bool waiterPay = true;
//   var intialTokenNo="";
//   var compensationHour="";
//   String compensationHourValue = '1 Hr';
//
//   // List of items in our dropdown menu
//   var items = [
//     '1 Hr',
//     '2 Hr',
//     '3 Hr',
//
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: (){
//             viewList();
//           },
//           icon: Icon(Icons.abc,color: Colors.red,),
//         ),
//         title: Text('Settings'.tr),
//
//       ),
//       body: ListView(
//         shrinkWrap: true,
//         //mainAxisAlignment: MainAxisAlignment.start,
//         // crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: MediaQuery.of(context).size.height / 16, //height of button
//             width: MediaQuery.of(context).size.width / 1,
//             child: Text('gen_setting'.tr,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   fontSize: 20,
//                 )),
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height / 1.2, //height of button
//             width: MediaQuery.of(context).size.width / 1.1,
//             child: ListView(children: <Widget>[
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   onTap: () {},
//                   title: Text(
//                     'kot_a_print'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                   ),
//                   trailing: SizedBox(
//                     width: 100,
//                     child: Center(
//                       child: FlutterSwitch(
//                         width: 40.0,
//                         height: 20.0,
//                         valueFontSize: 30.0,
//                         toggleSize: 15.0,
//                         value: kotPrint,
//                         borderRadius: 20.0,
//                         padding: 1.0,
//                         activeColor: Colors.green,
//                         activeTextColor: Colors.green,
//                         inactiveTextColor: Colors.white,
//                         inactiveColor: Colors.grey,
//                         onToggle: (val) {
//                           setState(() {
//                             kotPrint = val;
//                             switchStatus("KOT", kotPrint);
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'qty_inc'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: SizedBox(
//                     width: 100,
//                     child: Center(
//                       child: FlutterSwitch(
//                         width: 40.0,
//                         height: 20.0,
//                         valueFontSize: 30.0,
//                         toggleSize: 15.0,
//                         value: quantityIncrement,
//                         borderRadius: 20.0,
//                         padding: 1.0,
//                         activeColor: Colors.green,
//                         activeTextColor: Colors.green,
//                         inactiveTextColor: Colors.white,
//                         inactiveColor: Colors.grey,
//                         onToggle: (val) {
//
//                           // updateList("IsQuantityIncrement",val,"qtyIncrement");
//
//                           // setState(() {
//                           //   quantityIncrement = val;
//                           //   switchStatus("qtyIncrement", quantityIncrement);
//                           //   updateList("IsQuantityIncrement");
//                           // });
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                     title:   Text(
//                      'show_inv'.tr,
//                       style:
//                       TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                     ),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Center(
//                         child: FlutterSwitch(
//                           width: 40.0,
//                           height: 20.0,
//                           valueFontSize: 30.0,
//                           toggleSize: 15.0,
//                           value: showInvoice,
//                           borderRadius: 20.0,
//                           padding: 1.0,
//                           activeColor: Colors.green,
//                           activeTextColor: Colors.green,
//                           inactiveTextColor: Colors.white,
//                           inactiveColor: Colors.grey,
//
//                           // showOnOff: true,
//                           onToggle: (val) {
//                             setState(() {
//                               showInvoice = val;
//                               switchStatus("AutoClear", showInvoice);
//                               updateList("IsShowInvoice");
//
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         paymentMethod = false;
//                       });
//                     }),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                     title:   Text(
//                       'clear_table'.tr,
//                       style:
//                       TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                     ),
//
//                     // title: const Text('Clear Table After Payment'),
//                     trailing: SizedBox(
//                       width: 100,
//                       child: Center(
//                         child: FlutterSwitch(
//                           width: 40.0,
//                           height: 20.0,
//                           valueFontSize: 30.0,
//                           toggleSize: 15.0,
//                           value: clearTable,
//                           borderRadius: 20.0,
//                           padding: 1.0,
//                           activeColor: Colors.green,
//                           activeTextColor: Colors.green,
//                           inactiveTextColor: Colors.white,
//                           inactiveColor: Colors.grey,
//                           onToggle: (val) {
//                             setState(() {
//                               clearTable = val;
//                               switchStatus(  "tableClearAfterPayment", clearTable);
//                               updateList("IsClearTableAfterPayment");
//
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       setState(() {
//                         paymentMethod = false;
//                       });
//                     }),
//               ),
//
//
//
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'print_after_payment'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: SizedBox(
//                     width: 100,
//                     child: Center(
//                       child: FlutterSwitch(
//                         width: 40.0,
//                         height: 20.0,
//                         valueFontSize: 30.0,
//                         toggleSize: 15.0,
//                         value: printAfterPayment,
//                         borderRadius: 20.0,
//                         padding: 1.0,
//                         activeColor: Colors.green,
//                         activeTextColor: Colors.green,
//                         inactiveTextColor: Colors.white,
//                         inactiveColor: Colors.grey,
//
//                         // showOnOff: true,
//                         onToggle: (val) {
//                           setState(() {
//                             printAfterPayment = val;
//                             switchStatus("printAfterPayment", printAfterPayment);
//                             updateList("IsPrintAfterPayment");
//
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     setState(() {
//                       paymentMethod = false;
//                     });
//                   },
//                 ),
//               ),
//
//
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'custom_print'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: Icon(
//                       Icons.arrow_forward_ios_outlined,
//                       color: Colors.black,
//                     ),
//                   ),
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'reset_time'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: Text(
//                       "12:00 AM Everyday",
//                       style: TextStyle(color: Color(0xffF25F29)),
//                     ),
//                   ),
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'intial_tkn'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width/6,
//                       child: TextField(
//                         controller: tokenNoController,
//                         style: const TextStyle(color: Colors.black),
//
//                       ),
//                     ),
//
//                   ),
//
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'com_hr'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: Padding(
//                     padding: const EdgeInsets.only(right: 30.0),
//                     child:  DropdownButton(
//
//                       // Initial Value
//                       value: compensationHourValue,
//
//                       // Down Arrow Icon
//                       icon: const Icon(Icons.keyboard_arrow_down),
//
//                       // Array list of items
//                       items: items.map((String items) {
//                         return DropdownMenuItem(
//                           value: items,
//                           child: Text(items),
//                         );
//                       }).toList(),
//                       // After selecting the desired option,it will
//                       // change button value to selected value
//                       onChanged: (String? newValue) {
//                         setState(() {
//                           compensationHourValue = newValue!;
//                         });
//                       },
//                     ),
//                   ),
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               Card(
//                 shape: RoundedRectangleBorder(
//                   side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//                 color: Colors.grey[100],
//                 child: ListTile(
//                   title:   Text(
//                     'waiter_pay'.tr,
//                     style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//                   ),
//                   trailing: SizedBox(
//                     width: 100,
//                     child: Center(
//                       child: FlutterSwitch(
//                         width: 40.0,
//                         height: 20.0,
//                         valueFontSize: 30.0,
//                         toggleSize: 15.0,
//                         value: waiterPay,
//                         borderRadius: 20.0,
//                         padding: 1.0,
//                         activeColor: Colors.green,
//                         activeTextColor: Colors.green,
//                         inactiveTextColor: Colors.white,
//                         inactiveColor: Colors.grey,
//
//                         // showOnOff: true,
//                         onToggle: (val) {
//                           setState(() {
//                             waiterPay = val;
//                             switchStatus("waiterCanPay", waiterPay);
//                             updateList("IsWaiterCanPay");
//
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     setState(() {});
//                   },
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ]),
//           )
//         ],
//       ),
//     );
//   }
//
//   void switchStatus(key, value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool(key, value);
//   }
//
//   Future<Null> viewList() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       print("mmmm");
//     } else {
//       print("8888");
//
//       try {
//         print("1");
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         print("2");
//
//         var accessToken =
//             "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3MTM2ODI3LCJpYXQiOjE2ODU2MDA4MjcsImp0aSI6ImNiYmU1NjEzMGFjNjRkNjlhZGQ3MGVjNTQyOGU2YjQ1IiwidXNlcl9pZCI6NjJ9.NKIUe-F_IyTvmkLDo1Q7CYxAzIHLXem4qyhHAf50GQrboGi9kDpVnuCfyAmFAuEVEwmGKfzGxrmUZkeNSZISLyYq7jp5ifKL_tCkSj79kEKHL9Qp_x_98UoK4iZeytoLsWsSPZwSrc_I1UpogR36hs9RWs2rpN_nYrxHrabLUY6eTrd1uShl02xy6OHVuzBfP6bXt1kGUAMiENG58bYAieHGfI-ACxfGl9lPeLerOIAJjSBcWuoGk4uP2q9o7SX2PZvJFrt73wGpMXxUr4QFZiEdeIP6eDkgY8_4yzzXVMbPGiI5Gko1QIO-ylwJhWL3FJzgB60dkGksvzOoLtApdbVJL4vZa_M55jyRqRaExSx9SS7uEEy-laGib1CKa0Vu_YrRhzT8ucofn2obk-fSIhg4BrtOAF-0i0govPyzzLQ0S9wBPcmxDb85e-fJ5Ja28NBZ3bdEec5isJxryW5KgwNZk7h4PRRVzQpF3viobnNx4utkbLCfbs5-Ipm5sBbWBq0f5vzaWLheoFp60Bxg6YMY6ob7-2FzjB6BESNW379bL3zG1MWmxnu7fhe7kbL4cyLz8IqZlvzf5dupdrP0SwjP5jkGDFKLsEvg2ymMvMHFJXzGlTf8-UZUC_oe0Kv_vkgZQgvWrOveY5JKBBMfcfYgiW1pYFg93Zf5iaKRPpE";
//
//         print("3");
//
//         String baseUrl = "https://www.api.viknbooks.tk/api/v10/posholds";
//         print("4");
//
//         final String url = '$baseUrl/pos-hold-settings/';
//         print("5");
//         print("$url");
//
//         Map data = {
//           "CompanyID": "5a09676a-55ef-47e3-ab02-bac62005d847",
//           "IsQuantityIncrement": true,
//           "IsShowInvoice": true,
//           "IsClearTableAfterPayment": true,
//           "IsPrintAfterPayment": true,
//           "IsPayAfterSave": true,
//           "IsPrintPreview": true,
//           "TokenResetTime": true,
//           "InitialTokenNo": "",
//           "CompensationHour": "",
//           "IsWaiterCanPay": true,
//           "action": 0,
//           "key": "",
//           "value": ""
//         };
//         print("6");
//
//         ///date not setted
//         print(data);
//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         print("7");
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(status);
//         print("8");
//
//         var responseJson = n["data"];
//         print(responseJson);
//         print("9");
//
//         print(status);
//         if (status == 6000) {
//           setState(() {
//             print("10");
//
//             paymentMethod = responseJson["IsPayAfterSave"];
//             print("111");
//
//             quantityIncrement =responseJson["IsQuantityIncrement"];            print("122");
//
//             // kotPrint = false;
//             showInvoice = responseJson["IsShowInvoice"];            print("133");
//
//             clearTable = responseJson["IsClearTableAfterPayment"];            print("144");
//
//             printAfterPayment = responseJson["IsPrintAfterPayment"];            print("155");
//
//             waiterPay = responseJson["IsWaiterCanPay"];            print("166");
//
//             // tokenNoController.text=responseJson["InitialTokenNo"];            print("1777");
// //
//             //    compensationHourValue=responseJson["CompensationHour"];            print("188");
//
//             print("11");
//           });
//         } else if (status == 6001) {
//           print("12");
//         } else {
//           print("13");
//         }
//       } catch (e) {
//         print("Error");
//       }
//     }
//   }
//   Future<Null> updateList(String type) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       print("mmmm");
//     } else {
//       print("8888");
//
//       try {
//         print("1");
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         print("2");
//
//         var accessToken =
//             "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3MTM2ODI3LCJpYXQiOjE2ODU2MDA4MjcsImp0aSI6ImNiYmU1NjEzMGFjNjRkNjlhZGQ3MGVjNTQyOGU2YjQ1IiwidXNlcl9pZCI6NjJ9.NKIUe-F_IyTvmkLDo1Q7CYxAzIHLXem4qyhHAf50GQrboGi9kDpVnuCfyAmFAuEVEwmGKfzGxrmUZkeNSZISLyYq7jp5ifKL_tCkSj79kEKHL9Qp_x_98UoK4iZeytoLsWsSPZwSrc_I1UpogR36hs9RWs2rpN_nYrxHrabLUY6eTrd1uShl02xy6OHVuzBfP6bXt1kGUAMiENG58bYAieHGfI-ACxfGl9lPeLerOIAJjSBcWuoGk4uP2q9o7SX2PZvJFrt73wGpMXxUr4QFZiEdeIP6eDkgY8_4yzzXVMbPGiI5Gko1QIO-ylwJhWL3FJzgB60dkGksvzOoLtApdbVJL4vZa_M55jyRqRaExSx9SS7uEEy-laGib1CKa0Vu_YrRhzT8ucofn2obk-fSIhg4BrtOAF-0i0govPyzzLQ0S9wBPcmxDb85e-fJ5Ja28NBZ3bdEec5isJxryW5KgwNZk7h4PRRVzQpF3viobnNx4utkbLCfbs5-Ipm5sBbWBq0f5vzaWLheoFp60Bxg6YMY6ob7-2FzjB6BESNW379bL3zG1MWmxnu7fhe7kbL4cyLz8IqZlvzf5dupdrP0SwjP5jkGDFKLsEvg2ymMvMHFJXzGlTf8-UZUC_oe0Kv_vkgZQgvWrOveY5JKBBMfcfYgiW1pYFg93Zf5iaKRPpE";
//
//         print("3");
//
//         String baseUrl = "https://www.api.viknbooks.tk/api/v10/posholds";
//         print("4");
//
//         final String url = '$baseUrl/pos-hold-settings/';
//         print("5");
//         print("$url");
//
//         Map data = {
//           "CompanyID": "5a09676a-55ef-47e3-ab02-bac62005d847",
//           "key": type,
//           "value": true,
//           "action":1
//         };
//         print("6");
//
//
//
//
//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         print(response.statusCode);
//         print(response.body);
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//
//         if (status == 6000) {
//
//           viewList();
//
//         } else if (status == 6001) {
//           print("12");
//         } else {
//           print("13");
//         }
//       } catch (e) {
//         print("Error");
//       }
//     }
//   }
//
// }
//
