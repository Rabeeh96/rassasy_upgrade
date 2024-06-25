// import 'dart:convert';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
// import 'package:rassasy_new/new_design/dashboard/dashboard.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/new_method/pos_list_section.dart';
// import 'package:rassasy_new/new_design/organization/list_organization.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class EnterPinNumber extends StatefulWidget {
//   const EnterPinNumber({Key? key}) : super(key: key);
//
//   @override
//   State<EnterPinNumber> createState() => _EnterPinNumberState();
// }
//
// class _EnterPinNumberState extends State<EnterPinNumber> {
//   Color c1 = Colors.white;
//   Color c2 = Colors.white;
//   Color c3 = Colors.white;
//   Color c4 = Colors.white;
//   Color c5 = Colors.white;
//   Color c6 = Colors.white;
//
//   List<int> num = [];
//   final FocusNode _focusNode = FocusNode();
//   final ValueNotifier<String> _enteredNumbersNotifier = ValueNotifier<String>('');
//
//   @override
//   void initState() {
//     super.initState();
//     // Request focus when the widget is first initialized
//     _focusNode.requestFocus();
//     defaultAPi();
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     _enteredNumbersNotifier.dispose();
//     super.dispose();
//   }
//   defaultAPi() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
//   }
//
//   KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
//     // Check if the event is a RawKeyDownEvent
//     final logicalKey = event.logicalKey;
//     // Check if the key is a numeric key and the entered numbers length is less than 6
//     if (RegExp('[0-9]').hasMatch(logicalKey.keyLabel!) &&
//         _enteredNumbersNotifier.value.length < 6) {
//       // Append numeric keys to the entered numbers
//       _enteredNumbersNotifier.value += logicalKey.keyLabel!;
//     }
//     return KeyEventResult.handled;
//   }
//   void _clearEnteredNumbers() {
//     _enteredNumbersNotifier.value = '';
//   }
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//
//
//     // bool isTablet = true;
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Scaffold(
//       // appBar: AppBar(
//       //   elevation: 0.0,
//       //   backgroundColor: Color(0xffF3F3F3),
//       //   actions: [
//       //     Padding(
//       //       padding: const EdgeInsets.all(8.0),
//       //       child: IconButton(
//       //           onPressed: () {
//       //             _asyncConfirmDialog(context);
//       //           },
//       //           icon: SvgPicture.asset('assets/svg/logout_from_pinNo.svg')),
//       //     )
//       //
//       //   ],
//       // ),
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/png/coverpage.png"), fit: BoxFit.cover),
//           ),
//           child: Center(
//               child: SizedBox(
//                   height: isTablet?screenHeight/ 1:screenHeight/1, //height of button
//                   width: isTablet?screenWidth / 1.1:screenWidth/1,
//                   child: Column(
//                     //  crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: IconButton(
//                             onPressed: () {
//                               _asyncConfirmDialog(context);
//                             },
//                             icon: SvgPicture.asset(
//                                 'assets/svg/logout_from_pinNo.svg')),
//                       ),
//                       // DefaultTextStyle(
//                       //
//                       //   style:const TextStyle(fontSize: 16,color: Colors.red),
//                       //   child: Focus(
//                       //     focusNode: _focusNode,
//                       //     onKeyEvent: (node, event) => _handleKeyEvent(node, event),
//                       //
//                       //     // onKey: _handleKeyEvent,
//                       //     child: Column(
//                       //       mainAxisAlignment: MainAxisAlignment.center,
//                       //       children: [
//                       //         ListenableBuilder(
//                       //           listenable: _enteredNumbersNotifier,
//                       //           builder: (context, enteredNumbers) {
//                       //             return Text(
//                       //               'Entered Numbers: ${_enteredNumbersNotifier.value.padRight(6, ' ')}',
//                       //               textAlign: TextAlign.center,
//                       //             );
//                       //           },
//                       //         ),
//                       //         SizedBox(height: 50),
//                       //         ElevatedButton(
//                       //           onPressed: _clearEnteredNumbers,
//                       //           child: Text('Clear'),
//                       //         ),
//                       //         ElevatedButton(
//                       //           onPressed: () {
//                       //             print(_enteredNumbersNotifier.value.padRight(6, ' '));
//                       //             //2233 print(Platform.isWindows);
//                       //           },
//                       //           child: Text('Print'),
//                       //         ),
//                       //       ],
//                       //     ),
//                       //   ),
//                       // ),
//                       Container(
//
//                         // height: MediaQuery.of(context).size.height / 1.3, //height of button
//                         width:  isTablet?screenWidth/ 3:screenWidth/1,
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                   alignment: Alignment.center,
//                                   height: MediaQuery.of(context).size.height /
//                                       16, //height of button
//                                   width: MediaQuery.of(context).size.width / 3,
//                                   child: Text(
//                                     'enter_pin'.tr,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold, fontSize: 14),
//                                   )),
//                               passwordEnteringField(),
//
//                               oneToThreeNumbers(),
//                               fourToSixNumber(),
//                               sevenToNineNumber(), //
//                               zeroNumberAndClearButton(),
//                             ]),
//                       ),
//                     ],
//                   ))),
//         ));
//   }
//
//   Future<Null> userTypeData(roleID) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//     } else {
//       try {
//         start(context);
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var companyID = prefs.getString('companyID') ?? '';
//
//         baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
//         String baseUrl = BaseUrl.baseUrlV11;
//         var token = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/list-detail/pos-role/';
//         print(url);
//         Map data = {
//           "CompanyID": companyID,
//           "Role_id": roleID,
//           "BranchID": branchID
//         };
//         print(data);
//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $token',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         print(response.body);
//         print(token);
//         var status = n["StatusCode"];
//         var userRollData = n["data"] ?? [];
//         if (status == 6000) {
//           for (var i = 0; i < userRollData.length; i++) {
//             if (userRollData[i]["Key"] == "other"|| userRollData[i]["Key"] == "report") {
//               prefs.setBool(userRollData[i]["Name"], userRollData[i]["Value"]);
//             } else {
//               prefs.setBool(userRollData[i]["Name"] + userRollData[i]["Key"],
//                   userRollData[i]["Value"]);
//             }
//           }
//
//           stop();
//
//           await Future.delayed(Duration(seconds: 1), () {
//             print("start   01");
//
//             bool result = checkConditions(userRollData);
//             if (result) {
//               prefs.setBool('IsSelectPos', false) ?? '';
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => DashboardNew()),
//               );
//             } else {
//               prefs.setBool('IsSelectPos', true) ?? '';
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => POSListItemsSection()),
//               );
//             }
//             print("result__________________________$result");
//           });
//
//
//         } else if (status == 6001) {
//           stop();
//         } else {}
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   bool checkConditions(data) {
//     // Initialize flags for the required conditions
//     bool diningView = false;
//     bool takeAwayView = false;
//     bool carView = false;
//
//     // Iterate through the data list and check the conditions
//     for (var item in data) {
//       if (item["Name"] == "Dining" && item["Key"] == "view") {
//         diningView = item["Value"];
//       } else if (item["Name"] == "Take away" && item["Key"] == "view") {
//         takeAwayView = item["Value"];
//       } else if (item["Name"] == "Car" && item["Key"] == "view") {
//         carView = item["Value"];
//       }
//     }
//
//     if (diningView || takeAwayView || carView) {
//       // Check if any one true exists in the remaining items
//       for (var item in data) {
//         if (item["Name"] != "Dining" &&
//             item["Name"] != "Take away" &&
//             item["Name"] != "Car") {
//           if (item["Value"] == true) {
//             print(item["Name"]);
//             return true;
//           }
//         }
//
//         // if (item["Value"] && item["Name"] != "Dining" && item["Name"] != "Take away" && item["Name"] != "Car") {
//         //   return true;
//         // }
//       }
//     }
//
//     return false;
//   }
//
//   ///color changing
//   changeColor() {
//     setState(() {
//       if (num.length == 1) {
//         c1 = const Color(0xff000000);
//         c2 = Colors.white;
//         c3 = Colors.white;
//         c4 = Colors.white;
//         c5 = Colors.white;
//         c6 = Colors.white;
//       } else if (num.length == 2) {
//         c1 = const Color(0xff000000);
//         c2 = const Color(0xff000000);
//         c3 = Colors.white;
//         c4 = Colors.white;
//         c5 = Colors.white;
//         c6 = Colors.white;
//       } else if (num.length == 3) {
//         c1 = const Color(0xff000000);
//         c2 = const Color(0xff000000);
//         c3 = const Color(0xff000000);
//         c4 = Colors.white;
//         c5 = Colors.white;
//         c6 = Colors.white;
//       } else if (num.length == 4) {
//         c1 = const Color(0xff000000);
//         c2 = const Color(0xff000000);
//         c3 = const Color(0xff000000);
//         c4 = const Color(0xff000000);
//         c5 = Colors.white;
//         c6 = Colors.white;
//       } else if (num.length == 5) {
//         c1 = const Color(0xff000000);
//         c2 = const Color(0xff000000);
//         c3 = const Color(0xff000000);
//         c4 = const Color(0xff000000);
//         c5 = const Color(0xff000000);
//         c6 = Colors.white;
//       } else if (num.length == 6) {
//         c1 = const Color(0xff000000);
//         c2 = const Color(0xff000000);
//         c3 = const Color(0xff000000);
//         c4 = const Color(0xff000000);
//         c5 = const Color(0xff000000);
//         c6 = const Color(0xff000000);
//       } else {
//         c1 = Colors.white;
//         c2 = Colors.white;
//         c3 = Colors.white;
//         c4 = Colors.white;
//         c5 = Colors.white;
//         c6 = Colors.white;
//       }
//       if (num.length == 6) {
//         String passData = num.join('');
//         getProductCode(passData);
//       } else {
//         print('length is not 6');
//       }
//     });
//   }
//
//   ///number enter field
//   Widget passwordEnteringField() {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Container(
//       // color: Colors.red,
//       alignment: Alignment.center,
//       height: isTablet?screenHeight/16:screenHeight/16,
//       width: isTablet?screenWidth/ 6:screenWidth/2,
//
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17, //height of button
//             width:   isTablet?screenWidth / 38:screenWidth/17,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: c1,
//                 border: Border.all(color: const Color(0xff707070))),
//             child: const Text(''),
//           ),
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17, //height of button
//             width:   isTablet?screenWidth / 38:screenWidth/17,            decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: c2,
//               border: Border.all(color: const Color(0xff707070))),
//           ),
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17, //height of button
//             width:   isTablet?screenWidth / 38:screenWidth/17,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: c3,
//                 border: Border.all(color: const Color(0xff707070))),
//           ),
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17,
//             width:   isTablet?screenWidth / 38:screenWidth/17,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: c4,
//                 border: Border.all(color: const Color(0xff707070))),
//           ),
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17,
//             width:   isTablet?screenWidth / 38:screenWidth/17,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: c5,
//                 border: Border.all(color: const Color(0xff707070))),
//           ),
//           Container(
//             height: isTablet?screenHeight / 38:screenHeight/17, ///height of button
//             width:   isTablet?screenWidth / 38:screenWidth/17,
//             decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: c6,
//                 border: Border.all(color: const Color(0xff707070))),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///first row
//   Widget oneToThreeNumbers() {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Container(
//
//       height: isTablet?screenHeight/9:screenHeight/9,
//       width: isTablet?screenWidth/ 3.5:screenWidth/1.2,
//
//       padding: const EdgeInsets.all(11),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//
//
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: const Color(0xffFFFFFF),
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(1);
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '1',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(2);
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '2',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(3);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '3',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///second row
//   Widget fourToSixNumber() {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Container(
//       //  color: Colors.yellow,
//       height: isTablet?screenHeight/9:screenHeight/9,
//       width: isTablet?screenWidth/ 3.5:screenWidth/1.2,
//       padding: const EdgeInsets.all(11),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   setState(() {
//                     if (num.length >= 6) {
//                     } else {
//                       num.add(4);
//
//                       changeColor();
//                     }
//                   });
//                 },
//                 icon: const Text(
//                   '4',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(5);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '5',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(6);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '6',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///third row
//   Widget sevenToNineNumber() {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Container(
//       // color: Colors.purple,
//       height: isTablet?screenHeight/9:screenHeight/9,
//       width: isTablet?screenWidth/ 3.5:screenWidth/1.2,
//       padding: const EdgeInsets.all(11),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   //  passList.add(7);
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(7);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '7',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(8);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '8',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(9);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '9',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///clear button
//   Widget zeroNumberAndClearButton() {
//     Size screenSize = MediaQuery.of(context).size;
//     double screenWidth = screenSize.width;
//     double screenHeight = screenSize.height;
//     bool isTablet = screenWidth > defaultScreenWidth;
//     return Container(
//       // color: Colors.amber,
//       height: isTablet?screenHeight/9:screenHeight/9,
//       width: isTablet?screenWidth/ 3.5:screenWidth/1.2,
//       padding: const EdgeInsets.all(11),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//           ),
//           Container(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//             decoration: BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 color: Colors.white,
//                 border: Border.all(color: Color(0xffD9D9D9)),
//                 borderRadius: const BorderRadius.all(Radius.circular(22))),
//             child: IconButton(
//                 highlightColor: Colors.transparent,
//                 onPressed: () {
//                   if (num.length >= 6) {
//                   } else {
//                     num.add(0);
//
//                     changeColor();
//                   }
//                 },
//                 icon: const Text(
//                   '0',
//                   style: TextStyle(
//                       color: Color(0xff000000),
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600),
//                 )),
//           ),
//           SizedBox(
//             height: isTablet?screenHeight/12:screenHeight/ 13,
//             width: isTablet?screenWidth/ 17:screenWidth/5,
//
//             child: IconButton(
//
//               tooltip: 'clear fields',
//               onPressed: () {
//                 setState(() {
//                   if (num.isNotEmpty) {
//                     num.removeLast();
//                     changeColor();
//                   } else {}
//                 });
//               },
//               icon: SvgPicture.asset('assets/svg/backspace.svg'),
//               iconSize: 60,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   test() {
//     c1 = Colors.white;
//     c2 = Colors.white;
//     c3 = Colors.white;
//     c4 = Colors.white;
//     c5 = Colors.white;
//     c6 = Colors.white;
//   }
//
//   Future<Null> getProductCode(String pin) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       dialogBox(context, "Connect to internet");
//       stop();
//     } else {
//       try {
//         print('1');
//         String baseUrl = BaseUrl.baseUrlV11;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         print('464.....................');
//         print(baseURlApi);
//         print(prefs.getString('BaseURL'));
//         baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
//         var companyID = prefs.getString('companyID') ?? '';
//
//         var branchID = prefs.getInt('branchID') ?? 1;
//         print('2');
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/validate-user-pin/';
//         print(accessToken);
//         print(url);
//         print('3');
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "PinNo": pin,
//         };
//         print(data);
//         print('4');
//         //encode Map to JSON
//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         print('5');
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(response.body);
//         print('6');
//         if (status == 6000) {
//           setState(() {
//             stop();
//             prefs.setString('pos_user_id', n["user_id"]);
//             prefs.setString('user_name', n["user_name"]);
//             prefs.setString('role', n["role"]);
//             prefs.setString('role_name', n["role_name"]);
//             prefs.setInt('employee_ID', n["EmployeeID"]);
//
//             /// employee ID save to
//             userTypeData(n["role"]);
//
//             // prefs.setBool("dining_perm", true);
//             // prefs.setBool("take_away_perm", true);
//             // prefs.setBool("car_perm", true);
//             // prefs.setBool("print_perm", true);
//             // prefs.setBool("cancel_order_perm", true);
//             // prefs.setBool("pay_perm", true);
//             // prefs.setBool("kitchen_print_perm", true);
//             // prefs.setBool("remove_table_perm", true);
//             // prefs.setBool("convert_type_perm", true);
//             // prefs.setBool("reservation_perm", true);
//             //
//             // print("__________________________________");
//             // Navigator.pushReplacement(
//             //   context, MaterialPageRoute(builder: (context) => DashboardNew()),
//             //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashBoard()),
//             // );
//           });
//         } else if (status == 6001) {
//           dialogBox(context, " Please Enter Correct Password");
//           //    dialogBox(context," Please Enter Correct Password");
//           setState(() {
//             c1 = Colors.white;
//             c2 = Colors.white;
//             c3 = Colors.white;
//             c4 = Colors.white;
//             c5 = Colors.white;
//             c6 = Colors.white;
//
//             stop();
//             num.clear();
//             print('111');
//           });
//           print('222');
//
//           //  changeColor();
//         } else {
//           print('333');
//           stop();
//         }
//       } catch (e) {
//         print('444');
//         stop();
//       }
//     }
//   }
//
//   Future<void> selectedItem(BuildContext context, item) async {
//     switch (item) {
//       case 0:
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setBool('companySelected', false);
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => OrganizationList()));
//         break;
//
//       case 1:
//         final Future<ConfirmAction?> action =
//         await _asyncConfirmDialog(context);
//         print("Confirm Action $action");
//
//         // Navigator.of(context).pushReplacement(
//         //   MaterialPageRoute(builder: (context) => const LoginPage()),
//         // );
//         break;
//     }
//   }
// }
//
// enum ConfirmAction { cancel, accept }
//
// Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
//   return showDialog<ConfirmAction>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//           'msg6'.tr,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Yes'.tr, style: TextStyle(color: Colors.red)),
//             onPressed: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.setBool('isLoggedIn', false);
//               prefs.setBool('companySelected', false);
//
//               Navigator.of(context).pushAndRemoveUntil(
//                 CupertinoPageRoute(builder: (context) => LoginPageNew()),
//                     (_) => false,
//               );
//             },
//           ),
//           TextButton(
//             child: Text('No', style: TextStyle(color: Colors.black)),
//             onPressed: () {
//               Navigator.of(context).pop(ConfirmAction.cancel);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
//
// List<PasswordScreenModel> passWordList = [];
//
// class PasswordScreenModel {}
