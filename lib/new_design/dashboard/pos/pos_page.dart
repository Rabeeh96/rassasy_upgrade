// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_switch/flutter_switch.dart';
// import 'package:rassasy_new/Print/bluetoothPrint.dart';
// import 'package:rassasy_new/Print/html_kot.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/global/textfield_decoration.dart';
// import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
// import 'package:rassasy_new/new_design/back_ground_print/back_ground_print_wifi.dart';
// import 'package:rassasy_new/new_design/dashboard/Reservation/reservation_list.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/detail/selectDeliveryMan.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../../main.dart';
// import 'package:intl/intl.dart';
// import 'package:pos_printer_manager/pos_printer_manager.dart';
// import 'package:rassasy_new/Print/service.dart';
// import 'package:webcontent_converter/webcontent_converter.dart';
//
// import 'detail/select_cardtype.dart';
// import 'detail/select_customer.dart';
// import 'detail/selected_customer.dart';
// import 'package:popover/popover.dart';
//
// class POSPage extends StatefulWidget {
//   const POSPage({Key? key}) : super(key: key);
//
//   @override
//   State<POSPage> createState() => _POSPageState();
// }
//
// class _POSPageState extends State<POSPage> {
//   Color borderColor = Color(0xffB8B8B8);
//
//   /// scroll controller declaration
//
//   ScrollController productController = ScrollController();
//   ScrollController categoryController = ScrollController();
//   ScrollController flavourController = ScrollController();
//
//   /// text edit  controller declaration
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController reservationCustomerNameController = TextEditingController();
//   TextEditingController loyaltyPhoneNumber = TextEditingController();
//   TextEditingController loyaltyCustomerNameController = TextEditingController();
//   TextEditingController loyaltyPhoneController = TextEditingController();
//   TextEditingController loyaltyLocationController = TextEditingController();
//   TextEditingController loyltyCardTypeController = TextEditingController();
//   TextEditingController loyaltyCardNumberController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   TextEditingController paymentCustomerSelection = TextEditingController();
//   TextEditingController deliveryManSelection = TextEditingController();
//
//   // TextEditingController custNameHeaderController = TextEditingController();
//   // TextEditingController phoneNumberHeaderController = TextEditingController();
//
//   TextEditingController phoneNumberController = TextEditingController()..text = "";
//   TextEditingController customerNameController = TextEditingController()..text = "walk in customer";
//   TextEditingController flavourNameController = TextEditingController();
//
//   /// master
//   TextEditingController discountAmountController = TextEditingController()..text = "0.0";
//   TextEditingController discountPerController = TextEditingController()..text = "0.0";
//   TextEditingController cashReceivedController = TextEditingController()..text = "0.0";
//   TextEditingController bankReceivedController = TextEditingController()..text = "0.0";
//
//   /// detail controller
//   TextEditingController unitPriceDetailController = TextEditingController();
//   TextEditingController qtyDetailController = TextEditingController();
//   TextEditingController searchController1 = TextEditingController();
//
//   TextEditingController tableNameController = TextEditingController();
//   TextEditingController amountController = TextEditingController();
//   TextEditingController cardNoController = TextEditingController();
//   TextEditingController discountController = TextEditingController();
//
//   /// focus node declare
//
//   FocusNode custNameHeaderFcNode = FocusNode();
//   FocusNode phoneNoHeaderFcNode = FocusNode();
//   FocusNode nameFcNode = FocusNode();
//   FocusNode loyaltyPhoneFcNode = FocusNode();
//   FocusNode phoneFcNode = FocusNode();
//   FocusNode locationFcNode = FocusNode();
//   FocusNode cardTypeFcNode = FocusNode();
//   FocusNode cardNoFcNode = FocusNode();
//   FocusNode saveFcNode = FocusNode();
//   FocusNode customerFcNode = FocusNode();
//
//   final nameNode = FocusNode();
//   final phoneNode = FocusNode();
//   final okAlertButton = FocusNode();
//   final submitFocusButton = FocusNode();
//
//   FocusNode suffixFcNode = FocusNode();
//   FocusNode name = FocusNode();
//   FocusNode noFcNode = FocusNode();
//   FocusNode amountFcNode = FocusNode();
//   FocusNode cardType = FocusNode();
//   FocusNode cardNo = FocusNode();
//   FocusNode discountFcNode = FocusNode();
//   FocusNode cashReceivedFcNode = FocusNode();
//
//   bool loyaltyStatus = false;
//   bool isAddLoyalty = false;
//   bool editLoyalty = false;
//   bool networkConnection = true;
//   bool showCardType = false;
//   var netWorkProblem = true;
//   bool isLoading = false;
//   bool isCategory = false;
//   var pageNumber = 1;
//   var firstTime = 1;
//   late int charLength;
//
//   var dateOnly;
//   bool editProductItem = false;
//   bool hide_payment = false;
//   int detailIdEdit = 0;
//
//   Color color1 = Colors.white;
//   Color color2 = const Color(0xffF8F8F8);
//   Color color3 = const Color(0xffF8F8F8);
//   Color color4 = const Color(0xffF8F8F8);
//   Color borderColor1 = Colors.black;
//   Color borderColor2 = Colors.transparent;
//   Color borderColor3 = Colors.transparent;
//   Color borderColor4 = Colors.transparent;
//   Color pageButton1 = Colors.black;
//   Color pageButton2 = Colors.white;
//   Color pageButton3 = Colors.white;
//   Color pageButton4 = Colors.white;
//   Color buttonText1 = Colors.white;
//   Color buttonText2 = Colors.black;
//   Color buttonText3 = Colors.black;
//   Color buttonText4 = Colors.black;
//
//   Color pageButtonColor1 = Colors.black;
//   Color pageButtonColor2 = Colors.white;
//   Color pageButtonTextColor1 = Colors.black;
//   Color pageButtonTextColor2 = Colors.white;
//   var page = 1;
//   bool buttonStyle = true;
//
//   var mainPageIndex = 1;
//   var order = 1;
//   String dropDown = 'A/C Room';
//   String status = "Vacant";
//   String takeAway = "Vacant";
//   String deliveryManID = "";
//
//   bool payment = false;
//   bool veg = false;
//
//   String currency = "SR";
//   String tableHeader = "Table 1";
//
//   bool addTable = false;
//
//   var items = [
//     'A/C Room',
//     'A/C Room 2',
//     'Non A/CRoom',
//     'Non A/CRoom1',
//     'Non A/CRoom2',
//   ];
//
//   /// onchange
//
//   String user_name = "";
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       posFunctions();
//     });
//   }
//
//   final double _width = 520;
//
//   void _animateToIndex(int index) {
//     print(index);
//     print(_width);
//     categoryController.animateTo(
//       index * _width,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.fastOutSlowIn,
//     );
//   }
//
//   bool IsSelectPos = false;
//   String waiterNameInitial = "";
//   bool IsSelectWaiter = false;
//   bool diningStatusPermission = false;
//   bool carStatusPermission = false;
//   bool onlineStatusPermission = false;
//   bool takeawayStatusPermission = false;
//
//   getUserDetails() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       IsSelectPos = prefs.getBool('IsSelectPos')??false;
//       if (IsSelectPos) {
//         user_name = prefs.getString('waiterNameInitial')!;
//         IsSelectWaiter = prefs.getBool('IsSelectWaiter')!;
//         diningStatusPermission = prefs.getBool('diningStatusPermission')!;
//         carStatusPermission = prefs.getBool('carStatusPermission')!;
//         onlineStatusPermission = prefs.getBool('onlineStatusPermission')!;
//         takeawayStatusPermission = prefs.getBool('takeawayStatusPermission')!;
//       } else {
//         user_name = prefs.getString('user_name')!;
//       }
//
//     });
//   }
//
//   Future<Null> posFunctions() async {
//     productSearchNotifier = ValueNotifier(2);
//     reservationDate = ValueNotifier(DateTime.now());
//     timeNotifierFromTime = ValueNotifier(DateTime.now());
//     timeNotifierToTime = ValueNotifier(DateTime.now());
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//         networkConnection = false;
//
//       });
//     } else {
//       networkConnection = true;
//       // await getUserDetails();
//       await ReloadAllData();
//       await getTableOrderList();
//       await getCategoryListDetail();
//       await loadCard();
//
//     }
//   }
//
//   //
//   // initialKot() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     kotLoad = prefs.getBool("KOT") ?? false;
//   //     user_name = prefs.getString("user_name") ?? "";
//   //     if (kotLoad) {
//   //       _scan();
//   //     }
//   //   });
//   // }
//
//   bool kotLoad = false;
//
//   ReloadAllData()async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // setState(() {
//     //   IsSelectPos = prefs.getBool('IsSelectPos')??false;
//     //   if (IsSelectPos) {
//     //     user_name = prefs.getString('waiterNameInitial')!;
//     //     IsSelectWaiter = prefs.getBool('IsSelectWaiter')!;
//     //     diningStatusPermission = prefs.getBool('diningStatusPermission')!;
//     //     carStatusPermission = prefs.getBool('carStatusPermission')!;
//     //     onlineStatusPermission = prefs.getBool('onlineStatusPermission')!;
//     //     takeawayStatusPermission = prefs.getBool('takeawayStatusPermission')!;
//     //   } else {
//     //     user_name = prefs.getString('user_name')!;
//     //   }
//     //
//     // });
//
//
//     paymentCustomerSelection.clear();
//     cashReceivedController.text = "0.00";
//     bankReceivedController.text = "0.00";
//     discountAmountController.text = "0.00";
//     discountPerController.text = "0.00";
//
//     orderDetTable.clear();
//     itemListPayment.clear();
//     productList.clear();
//     cancelReportList.clear();
//     categoryList.clear();
//     cardList.clear();
//     diningOrderList.clear();
//     carOrderLists.clear();
//     takeAwayOrderLists.clear();
//     onlineOrderLists.clear();
//     setState(() {
//
//       IsSelectPos = prefs.getBool('IsSelectPos')??false;
//       if (IsSelectPos) {
//         user_name = prefs.getString('waiterNameInitial')!;
//         IsSelectWaiter = prefs.getBool('IsSelectWaiter')!;
//         diningStatusPermission = prefs.getBool('diningStatusPermission')!;
//         carStatusPermission = prefs.getBool('carStatusPermission')!;
//         onlineStatusPermission = prefs.getBool('onlineStatusPermission')!;
//         takeawayStatusPermission = prefs.getBool('takeawayStatusPermission')!;
//       } else {
//         user_name = prefs.getString('user_name')!;
//       }
//
//
//       totalNetP = 00.0;
//       totalTaxMP = 00.0;
//       totalGrossP = 00.0;
//       vatAmountTotalP = 00.0;
//       cGstAmountTotalP = 00.0;
//       sGstAmountTotalP = 00.0;
//       iGstAmountTotalP = 00.0;
//       PaymentData.ledgerID = 1;
//       PaymentData.loyaltyCustomerID = 0;
//     });
//   }
//
//   var _selectedIndex = 1000;
//   var selectedIndexFlavour = 1000;
//   var parsingJson = [];
//   List<PassingDetails> orderDetTable = [];
//   List<PassingDetails> itemListPayment = [];
//   var deletedList = [];
//   var productName;
//
//   ///
//
//   var item_status;
//   var unique_id;
//   var detailID;
//   var unitName;
//   int productId = 0;
//   int actualProductTaxID = 0;
//   int productID = 0;
//   int branchID = 0;
//   int salesDetailsID = 0;
//   int productTaxID = 0;
//   int createdUserID = 0;
//   int priceListID = 0;
//
//   var productTaxName = "";
//   var flavourID = "";
//   var flavourName = "";
//   var salesPrice = "";
//   var purchasePrice = "";
//   var id = "";
//   var freeQty = "";
//   var rateWithTax = 0.0;
//   var costPerPrice = "";
//   var discountPer = "";
//   var taxType = "";
//   var taxID;
//   var discountAmount = 0.0;
//   var percentageDiscount = 0.0;
//   var taxableAmountPost = 0.0;
//
//   var grossAmount = "";
//   var vatPer = 0.0;
//   var quantity = 1.0;
//   var vatAmount = 0.0;
//   var netAmount = 0.0;
//
//   var sGSTPer = 0.0;
//   var sGSTAmount = 0.0;
//   var cGSTPer = 0.0;
//   var cGSTAmount = 0.0;
//   var iGSTPer = 0.0;
//   var iGSTAmount = 0.0;
//   var totalTax = 0.0;
//   var dataBase = "";
//   var taxableAmount = "";
//   var addDiscPer = "";
//   var addDiscAmt = "";
//   var gstPer = 0.0;
//   var gstAmount = 0.0;
//   bool isInclusive = false;
//   var unitPriceRounded = 0.0;
//   var quantityRounded = 0.0;
//   var netAmountRounded = 0.0;
//   var actualProductTaxName = "";
//   var descriptionD = "";
//
//   var unitPriceAmountWR = "0.00";
//   var inclusiveUnitPriceAmountWR = "0.00";
//   var grossAmountWR = "0.00";
//   int totalCategory = 0;
//
//   Future<bool> _onWillPop() async {
//     print(mainPageIndex);
//     return false;
//
//
//     if (IsSelectPos == false) {
//       return true;
//     }
//     else {
//
//
//
//       return (await showDialog<bool>(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Confirmation'),
//                 content: Text('Are you sure you want to exit?'),
//                 actions: <Widget>[
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0.0,
//                       backgroundColor: Colors.transparent, // Background color
//                     ),
//                     child: Text(
//                       'No',
//                       style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop(false);
//                     },
//                   ),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       elevation: 0.0,
//                       backgroundColor: Colors.transparent, // Background color
//                     ),
//                     child: Text(
//                       'Yes',
//                       style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
//                     ),
//                     onPressed: () {
//                       Navigator.of(context).pop(true);
//                     },
//                   ),
//                 ],
//               );
//             },
//           )) ??
//           false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => _onWillPop(),
//       child: Scaffold(
//         body: networkConnection == true
//             ? GestureDetector(
//                 child: posDetailPage(),
//                 onTap: () {
//                   setState(() {
//                     selectedDiningIndex = 1000;
//                   });
//                 })
//             : noNetworkConnectionPage(),
//       ),
//     );
//   }
//
//   Widget posDetailPage() {
//     return Row(
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height / 1, //height of button
//           width: MediaQuery.of(context).size.width / 1.1,
//           child: selectOrderType(mainPageIndex),
//         ),
//         Container(
//           color: Colors.white,
//           height: MediaQuery.of(context).size.height / 1, //height of button
//           width: MediaQuery.of(context).size.width / 11,
//           child: orderTypeDetailScreen(),
//         )
//       ],
//     );
//   }
//
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
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             'no_network'.tr,
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           TextButton(
//             onPressed: () {
//               posFunctions();
//             },
//             child: Text('retry'.tr,
//                 style: TextStyle(
//                   color: Colors.white,
//                 )),
//             style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffEE830C))),
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// main Page
//   selectOrderType(int index) {
//     if (index == 1) {
//       return diningDetailScreen();
//     } else if (index == 2) {
//       return takeAwayDetailScreen();
//     } else if (index == 3) {
//       return onlineDeliveryDetailScreen();
//     } else if (index == 4) {
//       return carDeliveryDetailScreen();
//     } else if (index == 6) {
//       return paymentMethod();
//     } else if (index == 7) {
//       return posDetailScreen();
//     }
//   }
// // d
//   /// dining section
//
//   Widget diningDetailScreen() {
//
//     return  RefreshIndicator(
//       backgroundColor: Colors.white,
//       color:Color(0xffEE830C),
//       child: ListView(
//
//         children: [
//           Container(
//            // decoration: BoxDecoration(border: Border.all(color: const Color(0xffD6D6D6))),
//             padding: const EdgeInsets.all(10),
//             height: MediaQuery.of(context).size.height / 11,
//             width: MediaQuery.of(context).size.width / 1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 BackButtonAppBar(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//
//                       alignment: Alignment.centerLeft,
//                       height: MediaQuery.of(context).size.height / 11, //height of button
//                       width: MediaQuery.of(context).size.width / 3,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Dining',
//                             style: customisedStyle(context, Color(0xff717171), FontWeight.bold, 15.00),
//                           ),
//                           Text(
//                             'choose_table'.tr,
//                             style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 12.00),
//                           )
//                         ],
//                       ),
//                     ),
//
//                     UserDetailsAppBar(user_name: user_name),
//                     Container(
//                       width: 100,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0347A1)),
//                         onPressed: () {
//                           posFunctions();
//                         },
//                         child: Text(
//                           'Refresh',
//                           style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                         ),
//                       ),
//                     ),
//
//
//                   ],
//                 )
//
//               ],
//             ),
//           ),
//
//           /// contraints commented
//           // ConstrainedBox(
//           //     constraints:
//           //     BoxConstraints(maxHeight: 3500, minHeight:  MediaQuery.of(context).size.height / 1),
//           //     child: GridView.builder(
//           //         physics: NeverScrollableScrollPhysics(),
//           //         padding: const EdgeInsets.all(8),
//           //         shrinkWrap: true,
//           //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           //           crossAxisCount: 4,
//           //           childAspectRatio: 1.6,
//           //           crossAxisSpacing: 10,
//           //           mainAxisSpacing: 10,
//           //         ),
//           //         itemCount: diningOrderList.length,
//           //         itemBuilder: (BuildContext context, int index) {
//           //           return Opacity(
//           //             opacity: selectedDiningIndex == index
//           //                 ? 1
//           //                 : selectedDiningIndex == 1000
//           //                 ? 1
//           //                 : 0.30,
//           //             child: Container(
//           //                 decoration: BoxDecoration(
//           //                     border: Border.all(
//           //                       color: Color(0xff8D8D8D),
//           //                       width: 1.7,
//           //                     )),
//           //                 child: returnDiningListItem(index)),
//           //           );
//           //         })
//           // ),
//
//           Container(
//             height: MediaQuery.of(context).size.height / 1.3, //height of button
//             width: MediaQuery.of(context).size.width / 1,
//             // color: Colors.grey,),
//             child: GridView.builder(
//              // physics: NeverScrollableScrollPhysics(),
//                 padding: const EdgeInsets.all(8),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 1.6,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: diningOrderList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Opacity(
//                     opacity: selectedDiningIndex == index
//                         ? 1
//                         : selectedDiningIndex == 1000
//                         ? 1
//                         : 0.30,
//                     child: Container(
//                         decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Color(0xff8D8D8D),
//                               width: 1.7,
//                             )),
//                         child: returnDiningListItem(index)),
//                   );
//                 }),
//           ),
//
// /// commented widget
//           //
//           // Container(
//           //   child: Row(
//           //     children: [
//           //       Container(
//           //         child: addTable == true
//           //             ? createTables()
//           //             : Container(
//           //          // height: MediaQuery.of(context).size.height / 8,
//           //           width: MediaQuery.of(context).size.width / 3,
//           //           child: SizedBox(),
//           //         ),
//           //       )
//           //     ],
//           //   ),
//           // ),
//           Container(
//             decoration: BoxDecoration(border: Border.all(color: const Color(0xffD6D6D6), width: 0.5)),
//             height: MediaQuery.of(context).size.height / 14, //height of button
//             //width: MediaQuery.of(context).size.width / 1,
//             child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Container(
//                         height: MediaQuery.of(context).size.height / 12, //height of button
//                         // width: MediaQuery.of(context).size.width / 18,
//                         child: IconButton(
//                             onPressed: () {
//                               createTable(context);
//
//                               // setState(() {
//                               //   addTable = true;
//                               // });
//                             },
//                             icon: SvgPicture.asset(
//                               'assets/svg/addmore.svg',
//                             ),
//                             iconSize: 35),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
//                         height: MediaQuery.of(context).size.height / 14, //height of button
//                         // width: MediaQuery.of(context).size.width / 10,
//
//                         child: Text(
//                           'Add table',
//                           style: customisedStyle(context, Colors.black, FontWeight.w500, 14.00),
//                         ),
//                       ),
//                     ],
//                   ),
//                   /// remove table commented
//
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.start,
//                   //   children: [
//                   //     Container(
//                   //       height: MediaQuery.of(context).size.height / 12, //height of button
//                   //       // width: MediaQuery.of(context).size.width / 18,
//                   //       child: IconButton(
//                   //           onPressed: () {
//                   //             setState(() {
//                   //               addTable = true;
//                   //             });
//                   //           },
//                   //           icon: SvgPicture.asset(
//                   //             'assets/svg/remove_item.svg',
//                   //           ),
//                   //           iconSize: 35),
//                   //     ),
//                   //     Container(
//                   //       padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
//                   //       height: MediaQuery.of(context).size.height / 14, //height of button
//                   //       // width: MediaQuery.of(context).size.width / 10,
//                   //
//                   //       child: Text(
//                   //         'Remove table',
//                   //         style: customisedStyle(context, Colors.black, FontWeight.w500, 14.00),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//
//               ///icon
//
//               GestureDetector(
//                   onTap: (){
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => ReservationList()),
//                     );
//                   },
//                   child: AbsorbPointer(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height / 12, //height of button
//                           // width: MediaQuery.of(context).size.width / 18,
//                           child: IconButton(
//                               onPressed: () {
//
//
//                               },
//                               icon: SvgPicture.asset(
//                                 'assets/svg/reserve.svg',
//                               ),
//                               iconSize: 35),
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
//                           height: MediaQuery.of(context).size.height / 14, //height of button
//                           // width: MediaQuery.of(context).size.width / 10,
//
//                           child: Text(
//                             'Reservation',
//                             style: customisedStyle(context, Color(0xff00775E), FontWeight.w500, 14.00),
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//               ),
//             ]),
//           )
//         ],
//       ),
//       onRefresh: () {
//         return Future.delayed(Duration(seconds: 0), () {
//                 posFunctions();
//           },
//         );
//       },
//     );
//
//
//
//
//   }
//
//   /// table resrve api call method
//   reserveTable(customerName, tableID) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       dialogBox(context, "Check your internet connection");
//     } else {
//       try {
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = BaseUrl.branchID;
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/pos-table-reserve/';
//
//         print(url);
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "CreatedUserID": userID,
//           "Table": tableID,
//           "CustomerName": customerName,
//           "Date": apiDateFormat.format(reservationDate.value),
//           "FromTime": timeFormatApiFormat.format(timeNotifierFromTime.value),
//           "ToTime": timeFormatApiFormat.format(timeNotifierToTime.value),
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print(response.body);
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(status);
//         if (status == 6000) {
//           reservationCustomerNameController.clear();
//           Navigator.pop(context);
//           dialogBox(context, "Table reserved successfully");
//           getTableOrderList();
//           stop();
//         } else if (status == 6001) {
//           stop();
//           var msg = n["message"] ?? n["errors"] ?? '';
//           dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   DateTime dateTime = DateTime.now();
//   DateFormat dateFormat = DateFormat("dd/MM/yyy");
//   DateFormat apiDateFormat = DateFormat("y-M-d");
//   DateFormat timeFormat = DateFormat.jm();
//   DateFormat timeFormatApiFormat = DateFormat('HH:mm');
//
//   late ValueNotifier<DateTime> reservationDate;
//   late ValueNotifier<DateTime> timeNotifierFromTime;
//   late ValueNotifier<DateTime> timeNotifierToTime;
//
//   returnDiningListItem(dineIndex) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: GestureDetector(
//           onTap: () {
//
//             setState(() {
//               parsingJson.clear();
//               orderDetTable.clear();
//               itemListPayment.clear();
//               tableID = diningOrderList[dineIndex].tableId;
//               print("--table id-----------------$tableID");
//               if (diningOrderList[dineIndex].status == "Vacant") {
//                 orderType = 1;
//                 orderEdit = false;
//                 mainPageIndex = 7;
//               }
//
//               if (diningOrderList[dineIndex].status == "Ordered") {
//                 mainPageIndex = 7;
//                 orderType = 1;
//                 orderID = diningOrderList[dineIndex].salesOrderID;
//                 orderEdit = true;
//                 order = 1;
//                 getOrderDetails(diningOrderList[dineIndex].salesOrderID);
//               }
//               tableHeader = diningOrderList[dineIndex].title;
//             });
//           },
//           onLongPress: () {
//             IsSelectPos = false;
//             hide_payment = false;
//             if (diningOrderList[dineIndex].status == "Paid") {
//               hide_payment = true;
//             }
//
//             if (diningOrderList[dineIndex].status == "Ordered") {
//               hide_payment = false;
//             }
//
//             if (diningOrderList[dineIndex].status == "Vacant") {
//               IsSelectPos = true;
//               hide_payment = true;
//
//             }
//             selectedDiningIndex = dineIndex;
//             setState(() {
//               orderType = 1;
//             });
//             bottomSheet(context, dineIndex, 1, diningOrderList[dineIndex].status);
//
//           }, //
//           child: AbsorbPointer(
//
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//
//                   width: MediaQuery.of(context).size.width / 5,
//                   height: MediaQuery.of(context).size.height / 18,
//                   child: DottedBorder(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           width: 6,
//                         ),
//                         SvgPicture.asset(
//                           'assets/svg/table.svg',
//                           height: 20,
//                           width: 25,
//                         ),
//                         const SizedBox(
//                           width: 6,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(left: 5),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(diningOrderList[dineIndex].title, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800)),
//                               Text(returnOrderTime(diningOrderList[dineIndex].orderTime, diningOrderList[dineIndex].status),
//                                   //'Table 1',
//                                   style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w800)),
//                             ],
//                           ),
//                         ),
//                         Container()
//                       ],
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(returnText(diningOrderList[dineIndex].status), style: customisedStyle(context, Colors.black, FontWeight.w700, 12.00)),
//                       Row(
//                         children: [
//                           Text(currency + ". " +
//                               roundStringWith(
//                                   diningOrderList[dineIndex].status != "Vacant"?
//                                   diningOrderList[dineIndex].salesOrderGrandTotal:'0'),
//                               style: customisedStyle(context, Colors.black, FontWeight.bold, 12.00)),
//                           // Text
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 5,
//                   height: MediaQuery.of(context).size.height / 16,
//                   child: Row(
//                     children: [
//                       Container(
//                         width: MediaQuery.of(context).size.width / returnWidth(dineIndex),
//                         height: MediaQuery.of(context).size.height / 15,
//                         child: TextButton(
//                           style: TextButton.styleFrom(
//                             backgroundColor: buttonColor(diningOrderList[dineIndex].status),
//                             textStyle: const TextStyle(
//                               fontSize: 12,
//                             ),
//                           ),
//                           onPressed: () {},
//                           child: Text(
//                             diningOrderList[dineIndex].status,
//                             style: customisedStyle(context, Colors.black, FontWeight.w400, 13.00),
//                           ),
//                         ),
//                       ),
//                       diningOrderList[dineIndex].reserved.isNotEmpty
//                           ? Container(
//                               // color: Colors.grey,
//                               width: MediaQuery.of(context).size.width / 9,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 5.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Reservation",
//                                       style: customisedStyle(context, Color(0xff00775E), FontWeight.w500, 10.0),
//                                     ),
//                                     Column(
//                                       // mainAxisAlignment:MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           dateConverter(diningOrderList[dineIndex].reserved[0]["Date"]),
//                                           style: customisedStyle(context, Color(0xff707070), FontWeight.w500, 10.0),
//                                         ),
//                                         Text(
//                                           ReturnDate(diningOrderList[dineIndex].reserved[0]["Date"], diningOrderList[dineIndex].reserved[0]["FromTime"],
//                                               diningOrderList[dineIndex].reserved[0]["ToTime"]),
//                                           style: customisedStyle(context, Color(0xff707070), FontWeight.w500, 9.0),
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : Container()
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
//
//   returnWidth(dineIndex) {
//     if (diningOrderList[dineIndex].reserved.isNotEmpty) {
//       return 12;
//     } else {
//       return 5;
//     }
//   }
//
//   dateConverter(String dt) {
//     DateTime todayDate = DateTime.parse(dt);
//     final DateFormat formatter = DateFormat('dd-MM-yyyy');
//     var asd = formatter.format(todayDate);
//     return asd;
//   }
//
//   ReturnDate(date, timeString, toTime) {
//     DateTime time = DateTime.parse(date + " " + timeString);
//     DateTime timeTo = DateTime.parse(date + " " + toTime);
//     print(time);
//     String formattedTime = DateFormat("hh:mm:ss a").format(time);
//     String formattedToTime = DateFormat("hh:mm:ss a").format(timeTo);
//
//     //   String formattedTime = DateFormat("hh:mm:ss a").format(
//     //     DateTime(
//     //       time.year,
//     //       time.month,
//     //       time.day,
//     //       int.parse(timeString.substring(0, 2)),
//     //       int.parse(timeString.substring(3, 5)),
//     //       int.parse(timeString.substring(6, 8)),
//     //     ),
//     //   );
//
//     return "${formattedTime}-$formattedToTime";
//   }
//
//   void dispose() {
//     super.dispose();
//     stop();
//   }
//
//   returnText(type) {
//     if (type == "Vacant") {
//       return "";
//     } else if (type == "Paid") {
//       return "Paid :";
//     } else {
//       return "To Be Paid :";
//     }
//   }
//
//   /// edit order
//
//   convertStringToDouble(var amt) {
//     var a = "$amt";
//     var rtn = double.parse(a);
//     return rtn;
//   }
//
//   Future<Null> getOrderDetails(id) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       dialogBox(context, "Unable to connect. Please Check Internet Connection");
//     } else {
//       try {
//         print("_________________________________________________________________its called");
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var pk = orderID;
//         final String url = '$baseUrl/posholds/view-pos/salesOrder/$pk/';
//         print(url);
//         Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
//         print(data);
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var message = n["message"];
//         var responseJson = n["data"];
//
//         if (status == 6000) {
//           setState(() {
//             print("_________________________________________________________________1");
//             // "LedgerID": 1,
//             // "LedgerName": "walk in customer",
//             //
//
//             PaymentData.ledgerID = responseJson["LedgerID"];
//             totalNetP = convertStringToDouble(responseJson["NetTotal"]);
//
//             totalTaxMP = convertStringToDouble(responseJson["TotalTax"]);
//             totalGrossP = convertStringToDouble(responseJson["TotalGrossAmt"]);
//             vatAmountTotalP = convertStringToDouble(responseJson["VATAmount"]);
//             cGstAmountTotalP = convertStringToDouble(responseJson["CGSTAmount"]);
//             sGstAmountTotalP = convertStringToDouble(responseJson["SGSTAmount"]);
//             iGstAmountTotalP = convertStringToDouble(responseJson["IGSTAmount"]);
//             iGstAmountTotalP = convertStringToDouble(responseJson["IGSTAmount"]);
//             dateOnly = responseJson["Date"];
//             tokenNumber = responseJson["TokenNumber"];
//             phoneNumberController.text = responseJson["Phone"];
//             customerNameController.text = responseJson["CustomerName"];
//             print("_________________________________________________________________12");
//             var checkVat = prefs.getBool("checkVat") ?? false;
//             var checkGst = prefs.getBool("check_GST") ?? false;
//
//             if (checkVat == true) {
//               taxType = "VAT";
//             }
//             if (checkGst == true) {
//               taxType = "GST Intra-state B2C";
//             }
//
//             parsingJson.clear();
//             orderDetTable.clear();
//             print("_____________1");
//             var details = responseJson["SalesOrderDetails"];
//             for (var i = 0; i < details.length; i++) {
//               parsingJson.add(details[i]);
//             }
//             print('-------------------------');
//             print(parsingJson);
//             print('-------------------------');
//             print("______________________________________________________________________________4");
//             getLoyaltyCustomer();
//
//             listData();
//             stop();
//           });
//         } else if (status == 6001) {
//           stop();
//           dialogBox(context, message);
//         }
//
//         //DB Error
//         else {
//           stop();
//           dialogBox(context, "Some Network Error please try again Later");
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   Future<Null> listItemDetails(id) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       dialogBox(context, "Unable to connect. Please Check Internet Connection");
//     } else {
//       try {
//         print("____________________________1");
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         print("____________________________1");
//         final String url = '$baseUrl/posholds/view-pos/salesOrder/$id/';
//         print(url);
//         Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
//         print(data);
//         var body = json.encode(data);
//         print("____________________________1");
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var message = n["message"];
//         var responseJson = n["data"];
//
//         if (status == 6000) {
//           setState(() {
//             var parsingJsonItem = [];
//             parsingJsonItem.clear();
//             print("____________________________1");
//             itemListPayment.clear();
//             cashReceivedController.text = "0.00";
//             bankReceivedController.text = "0.00";
//             discountPerController.text = "0.00";
//             discountAmountController.text = "0.00";
//             var details = responseJson["SalesOrderDetails"];
//
//             for (var i = 0; i < details.length; i++) {
//               parsingJsonItem.add(details[i]);
//             }
//             print("____________________________12");
//             for (Map user in parsingJsonItem) {
//               itemListPayment.add(PassingDetails.fromJson(user));
//             }
//
//             print("____________________________15");
//             PaymentData.salesOrderID = id;
//             grandTotalAmount = responseJson["GrandTotal"].toString();
//             totalTaxP = responseJson["TotalTax"].toString();
//             netTotal = responseJson["NetTotal"].toString();
//             print("____________________________4");
//             PaymentData.ledgerID = responseJson["LedgerID"];
//             paymentCustomerSelection.text = responseJson["CustomerName"];
//
//             cashReceived = 0.0;
//             bankReceived = 0.0;
//             balance = 0.0;
//             totalDiscount = "0.0";
//             date = dateOnly;
//             roundOff = "0.0";
//
//             calculationOnPayment();
//             stop();
//           });
//         } else if (status == 6001) {
//           stop();
//           dialogBox(context, message);
//         }
//
//         //DB Error
//         else {
//           stop();
//           dialogBox(context, "Some Network Error please try again Later");
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   listData() {
//     setState(() {
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//     });
//   }
//
//   /// create table
//   Widget createTables() {
//     return Container(
//         height: MediaQuery.of(context).size.height / 8,
//         width: MediaQuery.of(context).size.width / 3,
//         color: const Color(0xffEBEBEB),
//         padding: const EdgeInsets.all(7),
//         child: ListView(
//           // crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               'Create Table',
//               style: customisedStyle(context, Colors.black, FontWeight.w700, 13.00),
//             ),
//
//             const SizedBox(
//               height: 5,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(3),
//                   // height: MediaQuery.of(context).size.height / 12, //height of button
//                   width: MediaQuery.of(context).size.width / 5,
//                   child: TextField(
//                     textCapitalization: TextCapitalization.words,
//                     controller: tableNameController,
//                     focusNode: name,
//                     onEditingComplete: () {
//                       FocusScope.of(context).requestFocus(noFcNode);
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Name',
//                       hintStyle: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
//                       filled: true,
//                       fillColor: Colors.white,
//                       isDense: true,
//                       contentPadding: EdgeInsets.all(10),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height / 20, //height of button
//
//                   child: IconButton(
//                       onPressed: () {
//                         if (tableNameController.text == "") {
//                           dialogBox(context, "Please enter table name");
//                         } else {
//                           createTableApi();
//                         }
//                       },
//                       icon: const Icon(
//                         Icons.add,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                       iconSize: 40),
//                   decoration: BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                       // color: c1,
//                       border: Border.all(color: Colors.grey)),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height / 20, //height of button
//                   // width: MediaQuery.of(context).size.width / 25,
//
//                   child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           tableNameController.clear();
//                           addTable = false;
//                         });
//                       },
//                       icon: const Icon(
//                         Icons.close,
//                         size: 20,
//                         color: Colors.white,
//                       ),
//                       iconSize: 40),
//                   decoration: BoxDecoration(
//                       color: Colors.redAccent,
//                       shape: BoxShape.circle,
//                       // color: c1,
//                       border: Border.all(color: Colors.grey)),
//                 ),
//               ],
//             ),
//
//             /// price category commented
//             // Row(
//             //     children: [
//             //   const Text('Price Category', style: TextStyle(fontSize: 13)),
//             //   const SizedBox(
//             //     width: 10,
//             //   ),
//             //   Container(
//             //     padding: const EdgeInsets.all(12),
//             //     decoration: BoxDecoration(
//             //       color: Colors.white,
//             //       border: Border.all(
//             //         color: Colors.grey,
//             //       ),
//             //       borderRadius: BorderRadius.circular(30),
//             //     ),
//             //     height: MediaQuery.of(context).size.height / 19,
//             //     width: MediaQuery.of(context).size.width / 6,
//             //     child: DropdownButton(
//             //       value: dropDown,
//             //       icon: const Icon(Icons.keyboard_arrow_down),
//             //       underline: const SizedBox(),
//             //       items: items.map((String items) {
//             //         return DropdownMenuItem(
//             //           value: items,
//             //           child: Text(
//             //             items,
//             //             style: const TextStyle(fontSize: 13),
//             //           ),
//             //         );
//             //       }).toList(),
//             //       onChanged: (String? newValue) {
//             //         setState(() {
//             //           dropDown = newValue!;
//             //         });
//             //       },
//             //     ),
//             //   ),
//             // ]),
//           ],
//         ));
//   }
//
//   var printHelper = new AppBlocs();
//
//   printDetail() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var defaultIp = prefs.getString('defaultIP') ?? '';
//     var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
//     print('--defaultIp---$defaultIp');
//     print('--defaultOrderIP---$defaultOrderIP');
//
//     if (defaultIp == "") {
//       dialogBox(context, "Please select a default printer");
//     } else {
//       var ret = await printHelper.printDetails();
//       if (ret == 2) {
//         var ip = "";
//         if (PrintDataDetails.type == "SO") {
//           ip = defaultOrderIP;
//         } else {
//           ip = defaultIp;
//         }
//
//         printHelper.testPrint(ip, context);
//       } else {
//         dialogBox(context, 'Please try again later');
//       }
//     }
//   }
//
//   printKOT(ip) async {
//     print('print kot called$id');
//     printHelper.printKotPrint(ip);
//   }
//
//   ReprintKOT(id) async {
//     printHelper.printKotPrintRe(id);
//   }
//
//   returnCancelHead(status) {
//     if (status == "Ordered") {
//       return "Cancel order";
//     } else {
//       return "Clear";
//     }
//   }
//
//   void bottomSheet(BuildContext context, tableIndex, sectionType, status) {
//     showModalBottomSheet<void>(
//         context: context,
//         isDismissible: true,
//         barrierColor: Colors.black.withAlpha(1),
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IsSelectPos == false
//                         ? SizedBox(
//                             height: MediaQuery.of(context).size.height / 5,
//                             width: MediaQuery.of(context).size.width / 12,
//                             child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                               IconButton(
//                                   onPressed: () {
//                                     print(sectionType);
//
//                                     setState(() {
//                                       selectedDiningIndex = 1000;
//
//                                       if (sectionType == 1) {
//                                         if (diningOrderList[tableIndex].status == "Ordered") {
//                                           print(diningOrderList[tableIndex].salesOrderID);
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SO";
//                                           PrintDataDetails.id = diningOrderList[tableIndex].salesOrderID;
//                                           printDetail();
//                                         }
//                                         if (diningOrderList[tableIndex].status == "Paid") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SI";
//                                           PrintDataDetails.id = diningOrderList[tableIndex].salesMasterID;
//
//                                           printDetail();
//                                         }
//                                       } else if (sectionType == 2) {
//                                         if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SO";
//                                           PrintDataDetails.id = takeAwayOrderLists[tableIndex].salesOrderId;
//
//                                           printDetail();
//                                         }
//                                         if (takeAwayOrderLists[tableIndex].status == "Paid") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SI";
//                                           PrintDataDetails.id = takeAwayOrderLists[tableIndex].salesId;
//
//                                           printDetail();
//                                         }
//                                       } else if (sectionType == 3) {
//                                         if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SO";
//                                           PrintDataDetails.id = onlineOrderLists[tableIndex].salesOrderId;
//
//                                           printDetail();
//                                         }
//
//                                         if (onlineOrderLists[tableIndex].status == "Paid") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SI";
//                                           PrintDataDetails.id = onlineOrderLists[tableIndex].salesId;
//
//                                           printDetail();
//                                         }
//                                       } else if (sectionType == 4) {
//                                         if (carOrderLists[tableIndex].status == "Ordered") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SO";
//                                           PrintDataDetails.id = carOrderLists[tableIndex].salesOrderId;
//
//                                           printDetail();
//                                         }
//                                         if (carOrderLists[tableIndex].status == "Paid") {
//                                           Navigator.pop(context);
//                                           PrintDataDetails.type = "SI";
//                                           PrintDataDetails.id = carOrderLists[tableIndex].salesId;
//
//                                           printDetail();
//                                         }
//                                       }
//                                     });
//                                   },
//                                   icon: SvgPicture.asset(
//                                     'assets/svg/print_image.svg',
//                                   ),
//                                   iconSize: 60),
//                               Text(
//                                 "Print",
//                                 style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                               )
//                             ]))
//                         : Container(),
//                     IsSelectPos == false
//                         ? SizedBox(
//                             height: MediaQuery.of(context).size.height / 5,
//                             width: MediaQuery.of(context).size.width / 12,
//                             child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                               IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       selectedDiningIndex = 1000;
//                                       if (sectionType == 1) {
//                                         if (diningOrderList[tableIndex].status == "Ordered") {
//                                           cancelId = diningOrderList[tableIndex].tableId;
//                                           Navigator.pop(context);
//                                           cancelReason(context, tableIndex, sectionType);
//                                         }
//                                         if (diningOrderList[tableIndex].status == "Paid") {
//                                           var deleteId = diningOrderList[tableIndex].tableId;
//                                           var type = "Dining";
//                                           Navigator.pop(context);
//                                           delete(type, deleteId, "");
//                                         }
//                                       } else if (sectionType == 2) {
//                                         if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                           cancelId = takeAwayOrderLists[tableIndex].salesOrderId;
//                                           Navigator.pop(context);
//                                           cancelReason(context, tableIndex, sectionType);
//                                         }
//                                         if (takeAwayOrderLists[tableIndex].status == "Paid") {
//                                           var deleteId = takeAwayOrderLists[tableIndex].salesOrderId;
//                                           var type = "TakeAway";
//                                           Navigator.pop(context);
//                                           delete(type, deleteId, "");
//                                         }
//                                       } else if (sectionType == 3) {
//                                         if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                           cancelId = onlineOrderLists[tableIndex].salesOrderId;
//                                           Navigator.pop(context);
//                                           cancelReason(context, tableIndex, sectionType);
//                                         }
//
//                                         if (onlineOrderLists[tableIndex].status == "Paid") {
//                                           var deleteId = onlineOrderLists[tableIndex].salesOrderId;
//                                           var type = "Online";
//                                           Navigator.pop(context);
//                                           delete(type, deleteId, "");
//                                           // OnlineCar
//                                         }
//                                       } else if (sectionType == 4) {
//                                         if (carOrderLists[tableIndex].status == "Ordered") {
//                                           cancelId = carOrderLists[tableIndex].salesOrderId;
//                                           Navigator.pop(context);
//                                           cancelReason(context, tableIndex, sectionType);
//                                         }
//                                         if (carOrderLists[tableIndex].status == "Paid") {
//                                           var deleteId = carOrderLists[tableIndex].salesOrderId;
//                                           var type = "Car";
//                                           Navigator.pop(context);
//                                           delete(type, deleteId, "");
//
//                                           // OnlineCar
//                                         }
//                                       }
//                                     });
//                                   },
//                                   icon: SvgPicture.asset(
//                                     'assets/svg/cancelorder.svg',
//                                   ),
//                                   iconSize: 60),
//                               Text(
//                                 returnCancelHead(status),
//                                 style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                               )
//                             ]))
//                         : Container(),
//                     hide_payment == false
//                         ? IsSelectPos == false
//                             ? SizedBox(
//                                 height: MediaQuery.of(context).size.height / 5,
//                                 width: MediaQuery.of(context).size.width / 12,
//                                 child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                                   IconButton(
//                                       onPressed: () {
//                                         print("==sectionType======$sectionType");
//                                         selectedDiningIndex = 1000;
//                                         setState(() {
//                                           cashReceivedController..text = "0.0";
//                                           if (sectionType == 1) {
//                                             if (diningOrderList[tableIndex].status == "Ordered") {
//                                               orderDetTable.clear();
//                                               itemListPayment.clear();
//                                               tableID = diningOrderList[tableIndex].tableId;
//                                               orderEdit = false;
//                                               mainPageIndex = 6;
//                                               Navigator.pop(context);
//                                               listItemDetails(diningOrderList[tableIndex].salesOrderID);
//                                             }
//                                           } else if (sectionType == 2) {
//                                             if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                               orderDetTable.clear();
//                                               itemListPayment.clear();
//                                               tableID = "";
//                                               orderEdit = false;
//                                               mainPageIndex = 6;
//                                               Navigator.pop(context);
//                                               listItemDetails(takeAwayOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           } else if (sectionType == 3) {
//                                             if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                               orderDetTable.clear();
//                                               itemListPayment.clear();
//                                               tableID = "";
//                                               orderEdit = false;
//                                               mainPageIndex = 6;
//                                               Navigator.pop(context);
//                                               listItemDetails(onlineOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           } else if (sectionType == 4) {
//                                             if (carOrderLists[tableIndex].status == "Ordered") {
//                                               orderDetTable.clear();
//                                               itemListPayment.clear();
//                                               tableID = "";
//                                               orderEdit = false;
//                                               mainPageIndex = 6;
//                                               Navigator.pop(context);
//                                               listItemDetails(carOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           }
//
//                                           // if (diningOrderList[tableIndex].status ==
//                                           //     "Ordered") {
//                                           //   orderDetTable.clear();
//                                           //   itemListPayment.clear();
//                                           //   tableID =
//                                           //       diningOrderList[tableIndex].tableId;
//                                           //   orderEdit = false;
//                                           //   mainPageIndex = 6;
//                                           //   listItemDetails(
//                                           //       diningOrderList[tableIndex]
//                                           //           .salesOrderID);
//                                           // }
//
//                                           //mainPageIndex = 6;
//                                         });
//                                       },
//                                       icon: SvgPicture.asset(
//                                         'assets/svg/pay.svg',
//                                       ),
//                                       iconSize: 60),
//                                   Text(
//                                     "Pay",
//                                     style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                                   )
//                                 ]))
//                             : Container()
//                         : Container(),
//                     hide_payment == false
//                         ? IsSelectPos == false
//                             ? SizedBox(
//                                 height: MediaQuery.of(context).size.height / 5,
//                                 width: MediaQuery.of(context).size.width / 12,
//                                 child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                                   IconButton(
//                                       onPressed: () {
//                                         setState(() {
//                                           selectedDiningIndex = 1000;
//                                           cashReceivedController..text = "0.0";
//                                           if (sectionType == 1) {
//                                             if (diningOrderList[tableIndex].status == "Ordered") {
//                                               Navigator.pop(context);
//                                               ReprintKOT(diningOrderList[tableIndex].salesOrderID);
//                                             }
//                                           } else if (sectionType == 2) {
//                                             if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                               Navigator.pop(context);
//                                               ReprintKOT(takeAwayOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           } else if (sectionType == 3) {
//                                             if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                               Navigator.pop(context);
//                                               ReprintKOT(onlineOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           } else if (sectionType == 4) {
//                                             if (carOrderLists[tableIndex].status == "Ordered") {
//                                               Navigator.pop(context);
//                                               ReprintKOT(carOrderLists[tableIndex].salesOrderId);
//                                             }
//                                           }
//                                         });
//                                       },
//                                       icon: SvgPicture.asset(
//                                         'assets/svg/KOT.svg',
//                                       ),
//                                       iconSize: 60),
//                                   Text(
//                                     "Kitchen Print",
//                                     style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                                   )
//                                 ]))
//                             : Container()
//                         : Container(),
//                     sectionType == 1
//                         ? SizedBox(
//                             height: MediaQuery.of(context).size.height / 5,
//                             width: MediaQuery.of(context).size.width / 12,
//                             child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                               IconButton(
//                                 icon: SvgPicture.asset(
//                                   'assets/svg/reserve.svg',
//                                 ),
//                                 iconSize: 60,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                   showPopup(context,diningOrderList[tableIndex].tableId);
//                                 },
//                               ),
//                               Text(
//                                 "Reserve",
//                                 style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                               )
//                             ]))
//                         : Container(),
//                     // sectionType ==1? ReserveButton():Container(),
//                   ],
//                 ),
//               ),
//             );
//           });
//         }
//         //     .then((value){
//         //       setState(() {
//         //     //  selectedDiningIndex=1000;
//         //       });
//         //
//         // }
//         )
//         .then((value){
//           setState(() {
//          selectedDiningIndex=1000;
//           });
//
//     });
//
//   }
//
//
//   void reserveVacantTable(BuildContext context, tableIndex, sectionType, status) {
//     showModalBottomSheet<void>(
//         context: context,
//         isDismissible: true,
//         barrierColor: Colors.black.withAlpha(1),
//         backgroundColor: Colors.transparent,
//         builder: (BuildContext context) {
//           return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 30.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     IsSelectPos == false
//                         ? SizedBox(
//                         height: MediaQuery.of(context).size.height / 5,
//                         width: MediaQuery.of(context).size.width / 12,
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedDiningIndex = 1000;
//
//                                   if (sectionType == 1) {
//                                     if (diningOrderList[tableIndex].status == "Ordered") {
//                                       print(diningOrderList[tableIndex].salesOrderID);
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SO";
//                                       PrintDataDetails.id = diningOrderList[tableIndex].salesOrderID;
//
//                                       printDetail();
//                                     }
//                                     if (diningOrderList[tableIndex].status == "Paid") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SI";
//                                       PrintDataDetails.id = diningOrderList[tableIndex].salesMasterID;
//
//                                       printDetail();
//                                     }
//                                   } else if (sectionType == 2) {
//                                     if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SO";
//                                       PrintDataDetails.id = takeAwayOrderLists[tableIndex].salesOrderId;
//
//                                       printDetail();
//                                     }
//                                     if (takeAwayOrderLists[tableIndex].status == "Paid") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SI";
//                                       PrintDataDetails.id = takeAwayOrderLists[tableIndex].salesId;
//
//                                       printDetail();
//                                     }
//                                   } else if (sectionType == 3) {
//                                     if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SO";
//                                       PrintDataDetails.id = onlineOrderLists[tableIndex].salesOrderId;
//
//                                       printDetail();
//                                     }
//
//                                     if (onlineOrderLists[tableIndex].status == "Paid") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SI";
//                                       PrintDataDetails.id = onlineOrderLists[tableIndex].salesId;
//
//                                       printDetail();
//                                     }
//                                   } else if (sectionType == 4) {
//                                     if (carOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SO";
//                                       PrintDataDetails.id = carOrderLists[tableIndex].salesOrderId;
//
//                                       printDetail();
//                                     }
//                                     if (carOrderLists[tableIndex].status == "Paid") {
//                                       Navigator.pop(context);
//                                       PrintDataDetails.type = "SI";
//                                       PrintDataDetails.id = carOrderLists[tableIndex].salesId;
//
//                                       printDetail();
//                                     }
//                                   }
//                                 });
//                               },
//                               icon: SvgPicture.asset(
//                                 'assets/svg/print_image.svg',
//                               ),
//                               iconSize: 60),
//                           Text(
//                             "Print",
//                             style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                           )
//                         ]))
//                         : Container(),
//                     IsSelectPos == false
//                         ? SizedBox(
//                         height: MediaQuery.of(context).size.height / 5,
//                         width: MediaQuery.of(context).size.width / 12,
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedDiningIndex = 1000;
//                                   if (sectionType == 1) {
//                                     if (diningOrderList[tableIndex].status == "Ordered") {
//                                       cancelId = diningOrderList[tableIndex].tableId;
//                                       Navigator.pop(context);
//                                       cancelReason(context, tableIndex, sectionType);
//                                     }
//                                     if (diningOrderList[tableIndex].status == "Paid") {
//                                       var deleteId = diningOrderList[tableIndex].tableId;
//                                       var type = "Dining";
//                                       Navigator.pop(context);
//                                       delete(type, deleteId, "");
//                                     }
//                                   } else if (sectionType == 2) {
//                                     if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                       cancelId = takeAwayOrderLists[tableIndex].salesOrderId;
//                                       Navigator.pop(context);
//                                       cancelReason(context, tableIndex, sectionType);
//                                     }
//                                     if (takeAwayOrderLists[tableIndex].status == "Paid") {
//                                       var deleteId = takeAwayOrderLists[tableIndex].salesOrderId;
//                                       var type = "TakeAway";
//                                       Navigator.pop(context);
//                                       delete(type, deleteId, "");
//                                     }
//                                   } else if (sectionType == 3) {
//                                     if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                       cancelId = onlineOrderLists[tableIndex].salesOrderId;
//                                       Navigator.pop(context);
//                                       cancelReason(context, tableIndex, sectionType);
//                                     }
//
//                                     if (onlineOrderLists[tableIndex].status == "Paid") {
//                                       var deleteId = onlineOrderLists[tableIndex].salesOrderId;
//                                       var type = "Online";
//                                       Navigator.pop(context);
//                                       delete(type, deleteId, "");
//                                       // OnlineCar
//                                     }
//                                   } else if (sectionType == 4) {
//                                     if (carOrderLists[tableIndex].status == "Ordered") {
//                                       cancelId = carOrderLists[tableIndex].salesOrderId;
//                                       Navigator.pop(context);
//                                       cancelReason(context, tableIndex, sectionType);
//                                     }
//                                     if (carOrderLists[tableIndex].status == "Paid") {
//                                       var deleteId = carOrderLists[tableIndex].salesOrderId;
//                                       var type = "Car";
//                                       Navigator.pop(context);
//                                       delete(type, deleteId, "");
//
//                                       // OnlineCar
//                                     }
//                                   }
//                                 });
//                               },
//                               icon: SvgPicture.asset(
//                                 'assets/svg/cancelorder.svg',
//                               ),
//                               iconSize: 60),
//                           Text(
//                             returnCancelHead(status),
//                             style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                           )
//                         ]))
//                         : Container(),
//                     hide_payment == false
//                         ? IsSelectPos == false
//                         ? SizedBox(
//                         height: MediaQuery.of(context).size.height / 5,
//                         width: MediaQuery.of(context).size.width / 12,
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                               onPressed: () {
//                                 print("==sectionType======$sectionType");
//                                 selectedDiningIndex = 1000;
//                                 setState(() {
//                                   cashReceivedController..text = "0.0";
//                                   if (sectionType == 1) {
//                                     if (diningOrderList[tableIndex].status == "Ordered") {
//                                       orderDetTable.clear();
//                                       itemListPayment.clear();
//                                       tableID = diningOrderList[tableIndex].tableId;
//                                       orderEdit = false;
//                                       mainPageIndex = 6;
//                                       Navigator.pop(context);
//                                       listItemDetails(diningOrderList[tableIndex].salesOrderID);
//                                     }
//                                   } else if (sectionType == 2) {
//                                     if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                       orderDetTable.clear();
//                                       itemListPayment.clear();
//                                       tableID = "";
//                                       orderEdit = false;
//                                       mainPageIndex = 6;
//                                       Navigator.pop(context);
//                                       listItemDetails(takeAwayOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   } else if (sectionType == 3) {
//                                     if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                       orderDetTable.clear();
//                                       itemListPayment.clear();
//                                       tableID = "";
//                                       orderEdit = false;
//                                       mainPageIndex = 6;
//                                       Navigator.pop(context);
//                                       listItemDetails(onlineOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   } else if (sectionType == 4) {
//                                     if (carOrderLists[tableIndex].status == "Ordered") {
//                                       orderDetTable.clear();
//                                       itemListPayment.clear();
//                                       tableID = "";
//                                       orderEdit = false;
//                                       mainPageIndex = 6;
//                                       Navigator.pop(context);
//                                       listItemDetails(carOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   }
//
//                                   // if (diningOrderList[tableIndex].status ==
//                                   //     "Ordered") {
//                                   //   orderDetTable.clear();
//                                   //   itemListPayment.clear();
//                                   //   tableID =
//                                   //       diningOrderList[tableIndex].tableId;
//                                   //   orderEdit = false;
//                                   //   mainPageIndex = 6;
//                                   //   listItemDetails(
//                                   //       diningOrderList[tableIndex]
//                                   //           .salesOrderID);
//                                   // }
//
//                                   //mainPageIndex = 6;
//                                 });
//                               },
//                               icon: SvgPicture.asset(
//                                 'assets/svg/pay.svg',
//                               ),
//                               iconSize: 60),
//                           Text(
//                             "Pay",
//                             style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                           )
//                         ]))
//                         : Container()
//                         : Container(),
//                     hide_payment == false
//                         ? IsSelectPos == false
//                         ? SizedBox(
//                         height: MediaQuery.of(context).size.height / 5,
//                         width: MediaQuery.of(context).size.width / 12,
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   selectedDiningIndex = 1000;
//                                   cashReceivedController..text = "0.0";
//                                   if (sectionType == 1) {
//                                     if (diningOrderList[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       ReprintKOT(diningOrderList[tableIndex].salesOrderID);
//                                     }
//                                   } else if (sectionType == 2) {
//                                     if (takeAwayOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       ReprintKOT(takeAwayOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   } else if (sectionType == 3) {
//                                     if (onlineOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       ReprintKOT(onlineOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   } else if (sectionType == 4) {
//                                     if (carOrderLists[tableIndex].status == "Ordered") {
//                                       Navigator.pop(context);
//                                       ReprintKOT(carOrderLists[tableIndex].salesOrderId);
//                                     }
//                                   }
//                                 });
//                               },
//                               icon: SvgPicture.asset(
//                                 'assets/svg/KOT.svg',
//                               ),
//                               iconSize: 60),
//                           Text(
//                             "Kitchen Print",
//                             style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                           )
//                         ]))
//                         : Container()
//                         : Container(),
//                     sectionType == 1
//                         ? SizedBox(
//                         height: MediaQuery.of(context).size.height / 5,
//                         width: MediaQuery.of(context).size.width / 12,
//                         child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                             icon: SvgPicture.asset(
//                               'assets/svg/reserve.svg',
//                             ),
//                             iconSize: 60,
//                             onPressed: () {
//                               Navigator.pop(context);
//                               showPopup(context,diningOrderList[tableIndex].tableId);
//                             },
//                           ),
//                           Text(
//                             "Reserve",
//                             style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                           )
//                         ]))
//                         : Container(),
//                     // sectionType ==1? ReserveButton():Container(),
//                   ],
//                 ),
//               ),
//             );
//           });
//         }
//       //     .then((value){
//       //       setState(() {
//       //     //  selectedDiningIndex=1000;
//       //       });
//       //
//       // }
//     );
//   }
//   /// reservation
//
//
//
//   createTable(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//             backgroundColor: Colors.grey,
//             title: const Text("Create Table"),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 4,
//                     height: MediaQuery.of(context).size.height / 16,
//                     child: TextField(
//                       style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                       controller: tableNameController,
//                       //  focusNode: nameFcNode,
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           contentPadding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//                           filled: true,
//                           suffixStyle: TextStyle(
//                             color: Colors.red,
//                           ),
//                           hintStyle: customisedStyle(context, Color(0xff858585), FontWeight.w400, 14.0),
//                           hintText: "Table name",
//                           fillColor: Color(0xffffffff)),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//
//                   Container(
//                     height: MediaQuery.of(context).size.height / 20,
//                     decoration: BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.circular(4)),
//                     child: TextButton(
//                       onPressed: () {
//
//                         if (tableNameController.text == "") {
//                           dialogBox(context, "Please enter table name");
//                         } else {
//                           createTableApi();
//                         }
//                       },
//                       child: Text(
//                         "Create",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height / 18,
//                     decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   // Other text fields and buttons
//                 ],
//               ),
//             ));
//       },
//     ).then((value) {
//       setState(() {
//         selectedDiningIndex = 1000;
//       });
//     });
//   }
//
//
//   showPopup(BuildContext context, tableID) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//             backgroundColor: Colors.grey,
//             title: const Text("Reserve For Later"),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width / 4,
//                     height: MediaQuery.of(context).size.height / 20,
//                     child: TextField(
//                       style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                       controller: reservationCustomerNameController,
//                       //  focusNode: nameFcNode,
//
//                       keyboardType: TextInputType.text,
//                       textCapitalization: TextCapitalization.words,
//                       decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                           contentPadding: EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//                           filled: true,
//                           suffixStyle: TextStyle(
//                             color: Colors.red,
//                           ),
//                           hintStyle: customisedStyle(context, Color(0xff858585), FontWeight.w400, 14.0),
//                           hintText: "Customer name",
//                           fillColor: Color(0xffffffff)),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 8,
//                   ),
//
//                   ValueListenableBuilder(
//                       valueListenable: reservationDate,
//                       builder: (BuildContext ctx, DateTime dateNewValue, _) {
//                         return GestureDetector(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),
//                             width: MediaQuery.of(context).size.width / 3,
//                             height: MediaQuery.of(context).size.height / 20,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "  Date",
//                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Text(
//                                     dateFormat.format(dateNewValue),
//                                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: () {
//                             showDatePickerFunction(context, reservationDate);
//                           },
//                         );
//                       }),
//                   // timeNotifierFromDate
//                   // timeNotifierToDate
//                   SizedBox(
//                     height: 8,
//                   ),
//                   ValueListenableBuilder(
//                       valueListenable: timeNotifierFromTime,
//                       builder: (BuildContext ctx, DateTime dateNewValue, _) {
//                         return GestureDetector(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),
//                             width: MediaQuery.of(context).size.width / 3,
//                             height: MediaQuery.of(context).size.height / 20,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "  From",
//                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Text(
//                                     timeFormat.format(dateNewValue),
//                                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: () async {
//                             TimeOfDay? pickedTime = await showTimePicker(
//                               initialTime: TimeOfDay.now(),
//                               context: context,
//                             );
//                             if (pickedTime != null) {
//                               timeNotifierFromTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
//                             } else {
//                               print("Time is not selected");
//                             }
//                           },
//                         );
//                       }),
//                   SizedBox(
//                     height: 8,
//                   ),
//
//                   ValueListenableBuilder(
//                       valueListenable: timeNotifierToTime,
//                       builder: (BuildContext ctx, DateTime dateNewValue, _) {
//                         return GestureDetector(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 2,
//                               ),
//                             ),
//                             width: MediaQuery.of(context).size.width / 3,
//                             height: MediaQuery.of(context).size.height / 20,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   "  To",
//                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: Text(
//                                     timeFormat.format(dateNewValue),
//                                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: () async {
//                             TimeOfDay? pickedTime = await showTimePicker(
//                               initialTime: TimeOfDay.now(),
//                               context: context,
//                             );
//                             if (pickedTime != null) {
//                               timeNotifierToTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
//                             } else {
//                               print("Time is not selected");
//                             }
//                           },
//                         );
//                       }),
//
//                   SizedBox(
//                     height: 8,
//                   ),
//                   Container(
//                     height: MediaQuery.of(context).size.height / 18,
//                     decoration: BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.circular(4)),
//                     child: TextButton(
//                       onPressed: () {
//                         if (reservationCustomerNameController.text == "") {
//                           dialogBox(context, "Please enter customer name");
//                         } else {
//                           reserveTable(reservationCustomerNameController.text, tableID);
//                         }
//                       },
//                       child: Text(
//                         "Reserve",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//
//                   Container(
//                     height: MediaQuery.of(context).size.height / 18,
//                     decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
//                     child: TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   // Other text fields and buttons
//                 ],
//               ),
//             ));
//       },
//     ).then((value) {
//       setState(() {
//         selectedDiningIndex = 1000;
//       });
//     });
//   }
//
//   void cancelReason(BuildContext context, ind, section_type) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Center(
//           child: AlertDialog(
//             title: Text('Select an reason for cancel',style: customisedStyle(context, Colors.black, FontWeight.w600, 15.0),),
//             content: Container(
//               width: MediaQuery.of(context).size.width /3, // Set the width of the alert box
//               child: ListView.builder(
//                 itemExtent: MediaQuery.of(context).size.height / 16,
//                 itemCount: cancelReportList.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       title: Column(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 cancelReportList[index].reason,
//                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       onTap: () async {
//                         //  cancelReasonId = cancelReportList[index].id;
//                         String id = cancelId;
//                         String cancelType = "";
//
//                         if (section_type == 1) {
//                           cancelType = "Dining&Cancel";
//                         }
//                         else if (section_type == 2) {
//                           cancelType = "Cancel";
//                         }
//                         else if (section_type == 3) {
//                           cancelType = "Cancel";
//                         }
//                         else if (section_type == 4) {
//                           cancelType = "Cancel";
//                         }
//
//                         Navigator.pop(context);
//                         delete(cancelType, id, cancelReportList[index].id);
//                         // delete()
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   //
//   // void cancelReason(BuildContext context, ind, section_type) {
//   //   showModalBottomSheet<void>(
//   //       context: context,
//   //       isDismissible: true,
//   //       backgroundColor: Colors.transparent,
//   //       builder: (BuildContext context) {
//   //         return Container(
//   //           height: MediaQuery.of(context).size.height / 3, // Change as per your requirement
//   //           width: MediaQuery.of(context).size.width / 4, // Change as per your requirement
//   //           child: ListView.builder(
//   //             itemExtent: MediaQuery.of(context).size.height / 16,
//   //             itemCount: cancelReportList.length,
//   //             itemBuilder: (context, index) {
//   //               return Card(
//   //                 child: ListTile(
//   //                   title: Column(
//   //                     children: <Widget>[
//   //                       Row(
//   //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                         children: [
//   //                           Text(
//   //                             cancelReportList[index].reason,
//   //                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   onTap: () async {
//   //                     //  cancelReasonId = cancelReportList[index].id;
//   //                     String id = cancelId;
//   //                     String cancelType = "";
//   //
//   //                     if (section_type == 1) {
//   //                       cancelType = "Dining&Cancel";
//   //                     }
//   //                     else if (section_type == 2) {
//   //                       cancelType = "Cancel";
//   //                     }
//   //                     else if (section_type == 3) {
//   //                       cancelType = "Cancel";
//   //                     }
//   //                     else if (section_type == 4) {
//   //                       cancelType = "Cancel";
//   //                     }
//   //
//   //                     Navigator.pop(context);
//   //                     delete(cancelType, id, cancelReportList[index].id);
//   //                     // delete()
//   //                   },
//   //                 ),
//   //               );
//   //             },
//   //           ),
//   //         );
//   //       });
//   // }
//
//   /// cancel order
//
//   String cancelId = "";
//
//   Future<Null> delete(String type, String id, cancelReasonId) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//       dialogBox(context, "Check Your Connection");
//     } else {
//       try {
//         if (type == "TakeAway" || type == "Dining" || type == "Online" || type == "Car") {
//           cancelReasonId = "";
//         }
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//
//         final String url = '$baseUrl/posholds/reset-status/';
//         print(url);
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "Type": type,
//           "unqid": id,
//           "reason_id": cancelReasonId,
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//
//         var status = n["StatusCode"];
//         if (status == 6000) {
//           setState(() {
//             stop();
//             getTableOrderList();
//           });
//         } else if (status == 6001) {
//           stop();
//
//         }
//
//         //DB Error
//         else {
//           stop();
//           // _scaffoldKey.currentState.showSnackBar(SnackBar(
//           //   content: Text('Some Network Error please try again Later'),
//           //   duration: Duration(seconds: 1),
//           // ));
//         }
//       } catch (e) {
//         setState(() {
//           stop();
//         });
//         print(e);
//         print('Error In Loading');
//       }
//     }
//   }
//
//   /// create table api
//   createTableApi() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//       dialogBox(context, "Check your internet connection");
//     } else {
//       try {
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/table-create/';
//         var suffix = "";
//
//         var tableName = tableNameController.text;
//         var name = suffix + tableName;
//
//         print(url);
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "TableName": name,
//           "IsActive": true,
//           "PriceCategoryID": "",
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print(response.body);
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(status);
//         if (status == 6000) {
//           Navigator.pop(context);
//           setState(() {
//             getTableOrderList();
//             addTable = false;
//           });
//           tableNameController.clear();
//           dialogBox(context, "Table created");
//           stop();
//         } else if (status == 6001) {
//           stop();
//           var msg = n["message"];
//           dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         setState(() {
//           stop();
//         });
//       }
//     }
//   }
//
//   /// take away section
//   Widget takeAwayDetailScreen() {
//
//
//     return  RefreshIndicator(
//       backgroundColor: Colors.white,
//       color:Color(0xffEE830C),
//       child: ListView(
//
//         children: [
//           Container(
//             padding: const EdgeInsets.all(10),
//             height: MediaQuery.of(context).size.height / 11,
//             //height of button
//             width: MediaQuery.of(context).size.width / 1,
//             decoration: BoxDecoration(border: Border.all(color: const Color(0xffD6D6D6))),
//             //color: Colors.grey,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 BackButtonAppBar(),
//                 Container(
//
//                   alignment: Alignment.centerLeft,
//                   height: MediaQuery.of(context).size.height / 11, //height of button
//                   width: MediaQuery.of(context).size.width / 3,
//
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Take Away',
//                         //  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
//                         style: customisedStyle(context, Color(0xff717171), FontWeight.bold, 15.00),
//                       ),
//                       Text('Create a parcel',
//                           // style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 11.0),
//                           style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 12.00))
//                     ],
//                   ),
//                 ),
//
//                 UserDetailsAppBar(user_name: user_name),
//                 Container(
//                   width: 100,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0347A1)),
//                     onPressed: () {
//                       posFunctions();
//                     },
//                     child: Text(
//                       'Refresh',
//                       style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                     ),
//                   ),
//                 ),
//
//                 // Container(
//                 //     alignment: Alignment.centerRight,
//                 //     height: MediaQuery.of(context).size.height / 11, //height of button
//                 //     width: MediaQuery.of(context).size.width / 3,
//                 //     child: Row(
//                 //       crossAxisAlignment: CrossAxisAlignment.center,
//                 //       mainAxisAlignment: MainAxisAlignment.end,
//                 //       children: [
//                 //         Text(user_name,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),),
//                 //         IconButton(
//                 //             icon: SvgPicture.asset('assets/svg/sidemenu.svg'),
//                 //             onPressed: () {}),
//                 //       ],
//                 //     )),
//               ],
//             ),
//           ),
//           SizedBox(
//          //   height: MediaQuery.of(context).size.height / 1, //height of button
//             width: MediaQuery.of(context).size.width / 1.1,
//
//             child: GridView.builder(
//               physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 1.4,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: takeAwayOrderLists.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return returnTakeAwayListItem(index);
//                   // return Container(
//                   //   height: 280,
//                   //   color: Colors.red,
//                   //   child: returnTakeAwayListItem(index),
//                   // );
//
//
//
//
//
//                 }),
//           ),
//         ],
//       ),
//       onRefresh: () {
//         return Future.delayed(Duration(seconds: 0), () {
//           posFunctions();
//         },
//         );
//       },
//     );
//
//
//
//
//   }
//
//   returnTakeAwayListItem(takeIndex) {
//     if (takeAwayOrderLists.isEmpty) {
//       return GestureDetector(
//         child: Card(
//             margin: const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
//             child: DottedBorder(
//                 color: const Color(0xff8D8D8D),
//                 strokeWidth: 1,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   height: MediaQuery.of(context).size.height / 4.5,
//                   //height of button
//                   width: MediaQuery.of(context).size.width / 4.5,
//                   color: Colors.white,
//                   child: Center(
//                     child: Container(
//                       color: Colors.white,
//                       //  padding: EdgeInsets.all(7),
//                       height: MediaQuery.of(context).size.height / 20, //height of button
//                       width: MediaQuery.of(context).size.width / 20,
//                       child: GestureDetector(
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.add,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                         onTap: () {
//                           setState(() {
//                             parsingJson.clear();
//                             orderDetTable.clear();
//                             orderType = 2;
//                             orderEdit = false;
//                             mainPageIndex = 7;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ))),
//       );
//     } else {
//       if (takeIndex == takeAwayOrderLists.length)
//       {
//         return Card(
//             margin: const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
//             child: DottedBorder(
//                 color: const Color(0xff8D8D8D),
//                 strokeWidth: 1,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   height: MediaQuery.of(context).size.height / 4.5,
//                   //height of button
//                   width: MediaQuery.of(context).size.width / 4.5,
//                   color: Colors.white,
//                   child: Center(
//                     child: Container(
//                       color: Colors.white,
//                       //  padding: EdgeInsets.all(7),
//                       height: MediaQuery.of(context).size.height / 20, //height of button
//                       width: MediaQuery.of(context).size.width / 20,
//
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.orange,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               parsingJson.clear();
//                               orderDetTable.clear();
//                               orderType = 2;
//                               orderEdit = false;
//                               mainPageIndex = 7;
//                               print("-------------------take away");
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.add,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )));
//       }
//       else {
//         return GestureDetector(
//             onTap: () {
//               print("-------------------");
//
//               /// Button();
//               ///
//               setState(() {
//                 tableHeader = "Parcel ${takeIndex + 1}";
//                 orderDetTable.clear();
//                 itemListPayment.clear();
//                 tableID = "";
//                 print("--table id-----------------$tableID");
//                 if (takeAwayOrderLists[takeIndex].status == "Vacant") {
//                   orderType = 2;
//                   orderEdit = false;
//                   mainPageIndex = 7;
//                 }
//
//                 if (takeAwayOrderLists[takeIndex].status == "Ordered") {
//                   mainPageIndex = 7;
//                   orderType = 2;
//                   orderID = takeAwayOrderLists[takeIndex].salesOrderId;
//                   orderEdit = true;
//                   order = 1;
//                   getOrderDetails(takeAwayOrderLists[takeIndex].salesOrderId);
//                 }
//               });
//             },
//             onLongPress: () {
//               if (takeAwayOrderLists[takeIndex].status == "Paid") {
//                 hide_payment = true;
//               }
//               if (takeAwayOrderLists[takeIndex].status == "Ordered") {
//                 hide_payment = false;
//               }
//
//               setState(() {
//                 orderType = 2;
//               });
//               if (IsSelectPos == false) {
//                 bottomSheet(context, takeIndex, 2, takeAwayOrderLists[takeIndex].status);
//               }
//             },
//             child: Card(
//               margin: const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
//               shape: const RoundedRectangleBorder(
//                 side: BorderSide(color: Color(0xff8D8D8D), width: 1),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 9, //height of button
//                     width: MediaQuery.of(context).size.width / 4.9,
//
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Container(
//
//                             height: MediaQuery.of(context).size.height / 19, //height of button
//                             width: MediaQuery.of(context).size.width / 5.1,
//                             child: DottedBorder(
//                               strokeWidth: .5,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: SvgPicture.asset('assets/svg/takeaway.svg'),
//                                       ),
//                                       Column(
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             'Parcel ${takeAwayOrderLists.length - takeIndex}',
//                                             //   style: TextStyle(fontSize: 11, color: Color(0xff000000), fontWeight: FontWeight.w700),
//                                             style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 11.00),
//                                           ),
//                                           Text(takeAwayOrderLists[takeIndex].custName,
//                                               style: customisedStyle(context, Color(0xff2B2B2B), FontWeight.w400, 10.00)
//                                               // style: TextStyle(
//                                               //     fontSize: 10,
//                                               //     color: Color(0xff2B2B2B)),
//                                               ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Text(
//                                     currency + ". " + roundStringWith(takeAwayOrderLists[takeIndex].salesOrderGrandTotal),
//                                     //style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff005B37)),
//                                     style: customisedStyle(context, Color(0xff005B37), FontWeight.w600, 12.00),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 6, top: 6, right: 6, bottom: 0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Token',
//                                       //style: TextStyle(fontSize: 12, color: Color(0xff000000), fontWeight: FontWeight.w600),
//                                       style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 12.00),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 5.0),
//                                       child: Text(
//                                         takeAwayOrderLists[takeIndex].tokenNo,
//                                         //  style: const TextStyle(fontSize: 12, color: Color(0xff4E4E4E), fontWeight: FontWeight.w500),
//                                         style: customisedStyle(context, Color(0xff4E4E4E), FontWeight.w600, 12.00),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                                 Text(
//                                   returnOrderTime(takeAwayOrderLists[takeIndex].orderTime, takeAwayOrderLists[takeIndex].status),
//                                   style: customisedStyle(context, Color(0xff929292), FontWeight.w400, 11.00),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                   Container(
//
//                     // padding: EdgeInsets.all(4),
//                     height: MediaQuery.of(context).size.height / 18, //height of button
//                     width: MediaQuery.of(context).size.width / 4.8,
//                     child: TextButton(
//                       style: TextButton.styleFrom(
//
//                         backgroundColor: takeAwayButton(takeAwayOrderLists[takeIndex].status),
//                         textStyle: const TextStyle(fontSize: 20),
//                       ),
//                       onPressed: () {
//                         // bottomSheet(context);
//                       },
//                       child: Text(
//                         takeAwayOrderLists[takeIndex].status,
//                         //style: const TextStyle(fontSize: 12),
//                         style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 4,
//                   ), // ListTile(),
//                 ],
//               ),
//             ));
//       }
//     }
//   }
//
//   /// online section
//
//   Widget onlineDeliveryDetailScreen() {
//
//
//     return  RefreshIndicator(
//       backgroundColor: Colors.white,
//       color:Color(0xffEE830C),
//       child: ListView(
//
//         children: [
//           Container(
//             decoration: BoxDecoration(border: Border.all(color: const Color(0xffD6D6D6))),
//             padding: const EdgeInsets.all(10),
//             height: MediaQuery.of(context).size.height / 11,
//             //height of button
//             width: MediaQuery.of(context).size.width / 1,
//             //color: Colors.grey,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 BackButtonAppBar(),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   height: MediaQuery.of(context).size.height / 11, //height of button
//                   width: MediaQuery.of(context).size.width / 3,
//
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Online',
//                         //    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
//                         style: customisedStyle(context, Color(0xff717171), FontWeight.w600, 15.0),
//                       ),
//                       Text(
//                         'Create a Order',
//                         // style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 11.0),
//                         style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 11.0),
//                       )
//                     ],
//                   ),
//                 ),
//                 UserDetailsAppBar(user_name: user_name),
//                 Container(
//                   width: 100,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0347A1)),
//                     onPressed: () {
//                       posFunctions();
//                     },
//                     child: Text(
//                       'Refresh',
//                       style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//           //  height: MediaQuery.of(context).size.height / 1, //height of button
//             width: MediaQuery.of(context).size.width / 1.1,
//
//             child: GridView.builder(
//               physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 1.4,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: onlineOrderLists.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return returnOnlineListItem(index);
//                 }),
//           ),
//         ],
//       ),
//       onRefresh: () {
//         return Future.delayed(Duration(seconds: 0), () {
//           posFunctions();
//         },
//         );
//       },
//     );
//
//   }
//
//   returnOnlineListItem(onlineIndex) {
//     if (onlineOrderLists.isEmpty) {
//       return Card(
//           margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
//           child: DottedBorder(
//               color: const Color(0xff8D8D8D),
//               strokeWidth: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 height: MediaQuery.of(context).size.height / 4.5,
//                 //height of button
//                 width: MediaQuery.of(context).size.width / 4.5,
//                 color: Colors.white,
//                 child: Center(
//                   child: Container(
//                     color: Colors.white,
//                     //  padding: EdgeInsets.all(7),
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             parsingJson.clear();
//                             orderDetTable.clear();
//                             orderType = 3;
//                             orderEdit = false;
//                             mainPageIndex = 7;
//                             print("-------------------online");
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )));
//     } else {
//       if (onlineIndex == onlineOrderLists.length) {
//         return Card(
//             margin: const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
//             child: DottedBorder(
//                 color: const Color(0xff8D8D8D),
//                 strokeWidth: 1,
//                 child: Container(
//                     padding: const EdgeInsets.all(8),
//                     height: MediaQuery.of(context).size.height / 4.5,
//                     //height of button
//                     width: MediaQuery.of(context).size.width / 4.5,
//                     color: Colors.white,
//                     child: Center(
//                       child: Container(
//                         color: Colors.white,
//                         //  padding: EdgeInsets.all(7),
//                         height: MediaQuery.of(context).size.height / 20, //height of button
//                         width: MediaQuery.of(context).size.width / 20,
//
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 parsingJson.clear();
//                                 orderDetTable.clear();
//                                 orderType = 3;
//                                 orderEdit = false;
//                                 mainPageIndex = 7;
//                                 print("-------------------online");
//                               });
//                             },
//                             icon: const Icon(
//                               Icons.add,
//                               size: 20,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ))));
//       } else {
//         return GestureDetector(
//           onTap: () {
//             print("-------------------");
//             setState(() {
//               tableHeader = "Order ${onlineIndex + 1}";
//               parsingJson.clear();
//               orderDetTable.clear();
//               itemListPayment.clear();
//               tableID = "";
//               print("--table id-----------------$tableID");
//               if (onlineOrderLists[onlineIndex].status == "Vacant") {
//                 orderType = 3;
//                 orderEdit = false;
//                 mainPageIndex = 7;
//               }
//
//               if (onlineOrderLists[onlineIndex].status == "Ordered") {
//                 mainPageIndex = 7;
//                 orderType = 3;
//                 orderID = onlineOrderLists[onlineIndex].salesOrderId;
//                 orderEdit = true;
//                 order = 1;
//
//                 getOrderDetails(onlineOrderLists[onlineIndex].salesOrderId);
//               }
//             });
//           },
//           onLongPress: () {
//             if (onlineOrderLists[onlineIndex].status == "Paid") {
//               hide_payment = true;
//             }
//             if (onlineOrderLists[onlineIndex].status == "Ordered") {
//               hide_payment = false;
//             }
//             setState(() {
//               orderType = 3;
//             });
//
//             if (IsSelectPos == false) {
//               bottomSheet(context, onlineIndex, 3, onlineOrderLists[onlineIndex].status);
//             }
//           },
//           child: Card(
//             margin: const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
//             shape: const RoundedRectangleBorder(
//               side: BorderSide(color: Color(0xff8D8D8D), width: 1),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 9, //height of button
//                   width: MediaQuery.of(context).size.width / 4.9,
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height / 19, //height of button
//                         width: MediaQuery.of(context).size.width / 4.9,
//                         child: DottedBorder(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {},
//                                     icon: SvgPicture.asset('assets/svg/online.svg'),
//                                   ),
//                                   Column(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//
//                                         'Order ${onlineOrderLists.length - onlineIndex}',
//                                         //style: TextStyle(fontSize: 11, color: Color(0xff000000), fontWeight: FontWeight.w700),
//                                         style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 11.0),
//                                       ),
//                                       Text(
//                                         onlineOrderLists[onlineIndex].custName,
//                                         style: customisedStyle(context, Color(0xff2B2B2B), FontWeight.w400, 10.0),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 currency + ". " + roundStringWith(onlineOrderLists[onlineIndex].salesOrderGrandTotal),
//                                 // 'Rs.23455',
//                                 //  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff005B37))
//                                 style: customisedStyle(context, Color(0xff005B37), FontWeight.w600, 12.0),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 4, top: 2, right: 2, bottom: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Token',
//                               style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 12.0),
//                             ),
//                             Text(
//                               onlineOrderLists[onlineIndex].tokenNo,
//                               // 'Order $index',
//
//                               style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 12.0),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           returnOrderTime(onlineOrderLists[onlineIndex].orderTime, onlineOrderLists[onlineIndex].status),
//
//                           // '23 Minutes Ago',
//                           style: customisedStyle(context, Color(0xff929292), FontWeight.w600, 10.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 18, //height of button
//                   width: MediaQuery.of(context).size.width / 4.8,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                        backgroundColor: onlineButton(onlineOrderLists[onlineIndex].status),
//                       textStyle: const TextStyle(fontSize: 20),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       onlineOrderLists[onlineIndex].status,
//                       style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 5,)
//                 // ListTile(),
//               ],
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   /// car section
//   Widget carDeliveryDetailScreen() {
//
//     return  RefreshIndicator(
//       backgroundColor: Colors.white,
//       color:Color(0xffEE830C),
//       child: ListView(
//
//         children: [
//           Container(
//             decoration: BoxDecoration(border: Border.all(color: const Color(0xffD6D6D6))),
//             padding: const EdgeInsets.all(10),
//             height: MediaQuery.of(context).size.height / 11,
//             //height of button
//             width: MediaQuery.of(context).size.width / 1,
//             //color: Colors.grey,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 BackButtonAppBar(),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   height: MediaQuery.of(context).size.height / 11, //height of button
//                   width: MediaQuery.of(context).size.width / 3,
//
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Car',
//                           // style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
//                           style: customisedStyle(context, Color(0xff717171), FontWeight.bold, 15.0)),
//                       Text('Create a Parcel', style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 11.0))
//                     ],
//                   ),
//                 ),
//                 UserDetailsAppBar(user_name: user_name),
//                 Container(
//                   width: 100,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0347A1)),
//                     onPressed: () {
//                       posFunctions();
//                     },
//                     child: Text(
//                       'Refresh',
//                       style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//           //  height: MediaQuery.of(context).size.height / 1, //height of button
//             width: MediaQuery.of(context).size.width / 1.1,
//
//             child: GridView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 1.4,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: carOrderLists.length + 1,
//                 itemBuilder: (BuildContext context, int index) {
//                   return returnListItem(index);
//                 }),
//           ),
//         ],
//       ),
//       onRefresh: () {
//         return Future.delayed(Duration(seconds: 0), () {
//           posFunctions();
//         },
//         );
//       },
//     );
//   }
//
//   returnListItem(carIndex) {
//     if (carOrderLists.isEmpty) {
//       return Card(
//           margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
//           child: DottedBorder(
//               color: const Color(0xff8D8D8D),
//               strokeWidth: 1,
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 height: MediaQuery.of(context).size.height / 4.5,
//                 //height of button
//                 width: MediaQuery.of(context).size.width / 4.5,
//
//                 child: Center(
//                   child: Container(
//                     color: Colors.white,
//                     //  padding: EdgeInsets.all(7),
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.orange,
//                         shape: BoxShape.circle,
//                       ),
//                       child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             parsingJson.clear();
//                             orderDetTable.clear();
//                             orderType = 4;
//                             orderEdit = false;
//                             mainPageIndex = 7;
//                           });
//                         },
//                         icon: const Icon(
//                           Icons.add,
//                           size: 20,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )));
//     } else {
//       if (carIndex == carOrderLists.length) {
//         return Card(
//             margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
//             child: DottedBorder(
//                 color: const Color(0xff8D8D8D),
//                 strokeWidth: 1,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   height: MediaQuery.of(context).size.height / 4.5,
//                   //height of button
//                   width: MediaQuery.of(context).size.width / 4.5,
//                   color: Colors.white,
//                   child: Center(
//                     child: Container(
//                       color: Colors.white,
//                       //  padding: EdgeInsets.all(7),
//                       height: MediaQuery.of(context).size.height / 20, //height of button
//                       width: MediaQuery.of(context).size.width / 20,
//
//                       child: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.orange,
//                           shape: BoxShape.circle,
//                         ),
//                         child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               parsingJson.clear();
//                               orderDetTable.clear();
//                               orderType = 4;
//                               orderEdit = false;
//                               mainPageIndex = 7;
//                             });
//                           },
//                           icon: const Icon(
//                             Icons.add,
//                             size: 20,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )));
//       } else {
//         return GestureDetector(
//           onTap: () {
//             print("-------------------");
//             setState(() {
//               tableHeader = 'Order ${carIndex + 1}';
//               parsingJson.clear();
//               orderDetTable.clear();
//               itemListPayment.clear();
//               tableID = "";
//               print("--table id-----------------$tableID");
//               if (carOrderLists[carIndex].status == "Vacant") {
//                 orderType = 4;
//                 orderEdit = false;
//                 mainPageIndex = 7;
//               }
//
//               if (carOrderLists[carIndex].status == "Ordered") {
//                 mainPageIndex = 7;
//                 orderType = 4;
//                 orderID = carOrderLists[carIndex].salesOrderId;
//                 orderEdit = true;
//                 order = 1;
//                 getOrderDetails(carOrderLists[carIndex].salesOrderId);
//               }
//             });
//           },
//           onLongPress: () {
//             if (carOrderLists[carIndex].status == "Paid") {
//               hide_payment = true;
//             }
//             if (carOrderLists[carIndex].status == "Ordered") {
//               hide_payment = false;
//             }
//             setState(() {
//               orderType = 4;
//             });
//             if (IsSelectPos == false) {
//               bottomSheet(context, carIndex, 4, carOrderLists[carIndex].status);
//             }
//           },
//           child: Card(
//             margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
//             shape: const RoundedRectangleBorder(
//               side: BorderSide(color: Color(0xff8D8D8D), width: 1),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(
//                   height: 6,
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 9.2, //height of button
//                   width: MediaQuery.of(context).size.width / 4.9,
//
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height / 19, //height of button
//                         width: MediaQuery.of(context).size.width / 4.9,
//                         child: DottedBorder(
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {},
//                                     icon: SvgPicture.asset('assets/svg/car.svg'),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text(
//                                           'Order ${carOrderLists.length - carIndex}',
//
//
//                                           style: customisedStyle(context, Color(0xff000000), FontWeight.w700, 11.0)),
//                                       Text(carOrderLists[carIndex].custName,
//                                           style: customisedStyle(context, Color(0xff2B2B2B), FontWeight.w400, 10.0)),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Text(currency + "." + roundStringWith(carOrderLists[carIndex].salesOrderGrandTotal),
//
//                                   //'Rs.23455',
//                                   style: customisedStyle(context, Color(0xff005B37), FontWeight.w600, 12.0)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         //   padding: EdgeInsets.all(2),
//                         //alignment: Alignment.center,
//                         height: MediaQuery.of(context).size.height / 35, //height of button
//                         width: MediaQuery.of(context).size.width / 5,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Token',
//                               style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 12.0),
//                             ),
//                             Text(
//                               carOrderLists[carIndex].tokenNo,
//                               style: customisedStyle(context, Color(0xff4E4E4E), FontWeight.w500, 13.0),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         alignment: Alignment.centerRight,
//                         height: MediaQuery.of(context).size.height / 37, //height of button
//                         width: MediaQuery.of(context).size.width / 5,
//                         child: Text(
//                           //carOrderLists[ind].orderTime,
//                           returnOrderTime(carOrderLists[carIndex].orderTime, carOrderLists[carIndex].status),
//
//                           //'23 Minutes Ago',
//
//                           style: customisedStyle(context, Color(0xff929292), FontWeight.w500, 12.0),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 4,
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 18, //height of button
//                   width: MediaQuery.of(context).size.width / 4.8,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                        backgroundColor: carButton(carOrderLists[carIndex].status),
//                       textStyle: const TextStyle(fontSize: 20),
//                     ),
//                     onPressed: () {},
//                     child: Text(
//                       carOrderLists[carIndex].status,
//                       style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 // ListTile(),
//               ],
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   returnOrderTime(String data, String status) {
//     print('1');
//     if (data == null) {
//       print("none");
//       return "";
//     }
//     print('1');
//     if (data == "") {
//       print("none");
//       return "";
//     }
//     if (status == "Vacant") {
//       return "";
//     }
//     print('1');
//     var t = data;
//     var yy = int.parse(t.substring(0, 4));
//     var month = int.parse(t.substring(5, 7));
//     var da = int.parse(t.substring(8, 10));
//     var hou = int.parse(t.substring(11, 13));
//     print('1');
//     print(hou);
//     var mnt = int.parse(t.substring(14, 16));
//     print(mnt);
//     var sec = int.parse(t.substring(17, 19));
//     print('1');
//     var startTime = DateTime(yy, month, da, hou, mnt, sec);
//     print(startTime);
//     var currentTimeN = DateTime.now();
//     final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
//     var st = formatter.format(currentTimeN);
//     var currentTime = DateTime.parse(st);
//     print('1');
//     print(currentTime);
//     var dMnt = currentTime.difference(startTime).inMinutes;
//     print(dMnt);
//     var dH = currentTime.difference(startTime).inHours;
//     print(dH);
//     String value = "$dMnt" + " " + "" + "Minutes";
//     return value;
//   }
//
//   /// payment section
//
//   addCashReceived(val) {
//     var cash = 0.00;
//     if (cashReceivedController.text == "") {
//     } else {
//       cash = double.parse(cashReceivedController.text);
//     }
//     var amount = double.parse(val) + cash;
//     cashReceivedController.text = "$amount";
//     calculationOnPayment();
//   }
//
//   Widget paymentMethod() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//
//         Container(
//           height: MediaQuery.of(context).size.height / 1.1,
//           //height of button
//           width: MediaQuery.of(context).size.width / 1.7,
//           decoration: BoxDecoration(color: Color(0xffF8F8F8), border: Border.all(color: Colors.grey, width: .2)),
//           child: ListView(
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height / 15,
//                 width: MediaQuery.of(context).size.width / 1.7,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//
//                     IconButton(
//                       icon: Icon(Icons.arrow_back),
//                       onPressed: () async {
//                         setState(() {
//                           cashReceivedController.text = '0.00';
//                           bankReceivedController.text = '0.00';
//                           discountAmountController.text = '0.00';
//                           discountPerController.text = '0.00';
//
//                           color1 = Colors.white;
//                           color2 = const Color(0xffF8F8F8);
//                           color3 = const Color(0xffF8F8F8);
//                           color4 = const Color(0xffF8F8F8);
//                           borderColor1 = Colors.black;
//                           borderColor2 = Colors.transparent;
//                           borderColor3 = Colors.transparent;
//                           borderColor4 = Colors.transparent;
//                           mainPageIndex = 1;
//                         });
//                       },
//                     ),
//
//
//
//                     Padding(
//                       padding: const EdgeInsets.only(left: 10),
//                       child: Text(
//                         'Payment',
//                         style: customisedStyle(context, Colors.black, FontWeight.w700, 20.00),
//                       ),
//                     ),
//                     /// select delivery man option commented
//
//
//                     Container(
//                       width: MediaQuery.of(context).size.width / 5,
//                       height: MediaQuery.of(context).size.height / 20,
//                       child: TextField(
//                         style: TextStyle(fontSize: 12),
//                         readOnly: true,
//                         onTap: () async {
//                           var result = await Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => SelectPaymentDeliveryMan()),
//                           );
//
//                           if (result != null) {
//                             deliveryManID = result[1];
//                             deliveryManSelection.text =  result[0];
//                           }
//                         },
//                         controller: deliveryManSelection,
//                         focusNode: customerFcNode,
//                         onEditingComplete: () {},
//                         keyboardType: TextInputType.text,
//                         textCapitalization: TextCapitalization.words,
//                         decoration: InputDecoration(
//                             suffixIcon: Icon(
//                               Icons.keyboard_arrow_down,
//                               color: Colors.black,
//                             ),
//                             enabledBorder: const OutlineInputBorder(
//                                 borderSide: const BorderSide(color: Color(0xffEEEEEE))),
//                             focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(color: Color(0xffEEEEEE))),
//                             disabledBorder: const OutlineInputBorder(
//                                 borderSide: const BorderSide(color: Color(0xffEEEEEE))),
//                             contentPadding:
//                             const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//                             filled: true,
//                             hintStyle: const TextStyle(color: Color(0xff858585),fontSize: 14),
//                             hintText: "Select Delivery man",
//                             fillColor: const Color(0xffEEEEEE)),
//                         // decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: 'Select Delivery man',),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             displayLoyaltyListBox(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child: SizedBox(
//                               height: MediaQuery.of(context).size.height / 16, //height of button
//                               width: MediaQuery.of(context).size.width / 6,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   primary: const Color(0xffFFFFFF),
//                                   backgroundColor: const Color(0xff172026), // Background Color
//                                 ),
//                                 onPressed: () {
//                                   displayLoyaltyListBox(context);
//                                 },
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     IconButton(
//                                       icon: SvgPicture.asset('assets/svg/person.svg'),
//                                       iconSize: 40,
//                                       onPressed: () {
//                                         displayLoyaltyListBox(context);
//                                       },
//                                     ),
//                                     Text(
//                                       'Add Customer',
//                                       style: customisedStyle(context, Colors.white, FontWeight.w400, 12.00),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             displayLoyalityAlertBox(context);
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
//                             child: SizedBox(
//                               height: MediaQuery.of(context).size.height / 16, //height of button
//                               width: MediaQuery.of(context).size.width / 26,
//                               child: TextButton(
//                                 style: TextButton.styleFrom(
//                                   primary: const Color(0xffFFFFFF),
//                                   backgroundColor: const Color(0xff172026), // Background Color
//                                 ),
//                                 onPressed: () {
//                                   displayLoyalityAlertBox(context);
//                                 },
//                                 child: Icon(Icons.add),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 14,
//                   //height of button
//                   width: MediaQuery.of(context).size.width / 1.8,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.all(Radius.circular(4.0)),
//
//                       // color: const Color(0xffFFFFFF),
//                       border: Border.all(color: Colors.grey, width: .2)),
//
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 50),
//                               child: Text(
//                                 'Select Customer',
//                                 style: customisedStyle(context, Colors.black, FontWeight.bold, 15.00),
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width / 7,
//                               height: MediaQuery.of(context).size.height / 20,
//                               child: TextField(
//                                 style: TextStyle(fontSize: 12),
//                                 readOnly: true,
//                                 onTap: () async {
//                                   var result = await Navigator.push(
//                                     context,
//                                     MaterialPageRoute(builder: (context) => SelectPaymentCustomer()),
//                                   );
//
//                                   print(result);
//
//                                   if (result != null) {
//                                     paymentCustomerSelection.text = result;
//                                   }
//                                 },
//                                 controller: paymentCustomerSelection,
//                                 focusNode: customerFcNode,
//                                 onEditingComplete: () {},
//                                 keyboardType: TextInputType.text,
//                                 textCapitalization: TextCapitalization.words,
//                                 decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: ''),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(left: 8.0, right: 8),
//                                 child: Text(
//                                   "Balance: ",
//                                   style: customisedStyle(context, Color(0xff808080), FontWeight.bold, 15.00),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 4),
//                                 child: Text(
//                                   currency + " . " + roundStringWith(balance.toString()),
//                                   style: customisedStyle(context, Color(0xff808080), FontWeight.bold, 15.00),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height / 5.5,
//                   //height of button
//                   width: MediaQuery.of(context).size.width / 1.8,
//                   decoration: BoxDecoration(
//                       color: Color(0xffEFEFEF),
//                       borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                       border: Border.all(color: Color(0xffefefef), width: .2)),
//
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 100),
//                               child: Text(
//                                 'To be paid',
//                                 style: customisedStyle(context, Colors.black, FontWeight.w700, 15.00),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 4),
//                               child: Text(
//                                 currency + " . " + roundStringWith(grandTotalAmount),
//                                 style: customisedStyle(context, Color(0xff000000), FontWeight.bold, 16.00),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total tax',
//                               style: customisedStyle(context, Color(0xff000000), FontWeight.bold, 13.00),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(
//                                 roundStringWith(totalTaxP),
//                                 style: customisedStyle(context, Color(0xff000000), FontWeight.bold, 13.00),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Net total",
//                               style: customisedStyle(context, Color(0xff000000), FontWeight.bold, 13.00),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(
//                                 roundStringWith(netTotal),
//                                 style: customisedStyle(context, Color(0xff000000), FontWeight.bold, 13.00),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Grand total",
//                               style: customisedStyle(context, Color(0xff0A9800), FontWeight.bold, 15.00),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 8),
//                               child: Text(
//                                 roundStringWith(grandTotalAmount),
//                                 style: customisedStyle(context, Color(0xff0A9800), FontWeight.bold, 15.00),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               ///total tax commented white bg color
//               // Container(
//               //   padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
//               //
//               //   height: MediaQuery.of(context).size.height / 6,
//               //   //height of button
//               //   width: MediaQuery.of(context).size.width / 1.8,
//               //
//               //   child: Column(
//               //     mainAxisAlignment: MainAxisAlignment.start,
//               //     children: [
//               //       Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           const Text(
//               //             'Total tax',
//               //             style: TextStyle(
//               //                 color: Colors.black,
//               //                 fontWeight: FontWeight.bold,
//               //                 fontSize: 15),
//               //           ),
//               //           Padding(
//               //             padding: const EdgeInsets.only(top: 8),
//               //             child: Text(
//               //               roundStringWith(totalTaxP),
//               //               style: const TextStyle(
//               //                   color: Colors.black,
//               //                   fontWeight: FontWeight.bold,
//               //                   fontSize: 15),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //       Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           const Text(
//               //             "Net total",
//               //             style: TextStyle(
//               //                 color: Colors.black,
//               //                 fontWeight: FontWeight.bold,
//               //                 fontSize: 15),
//               //           ),
//               //           Padding(
//               //             padding: const EdgeInsets.only(top: 8),
//               //             child: Text(
//               //               roundStringWith(netTotal),
//               //               style: const TextStyle(
//               //                   color: Colors.black,
//               //                   fontWeight: FontWeight.bold,
//               //                   fontSize: 15),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //       Row(
//               //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //         children: [
//               //           const Text(
//               //             "Grand total",
//               //             style: TextStyle(
//               //                 color: Color(0xff0A9800),
//               //                 fontWeight: FontWeight.bold,
//               //                 fontSize: 17),
//               //           ),
//               //           Padding(
//               //             padding: const EdgeInsets.only(top: 8),
//               //             child: Text(
//               //               roundStringWith(grandTotalAmount),
//               //               style: const TextStyle(
//               //                   color: Color(0xff0A9800),
//               //                   fontWeight: FontWeight.bold,
//               //                   fontSize: 17),
//               //             ),
//               //           ),
//               //         ],
//               //       ),
//               //
//               //       /// balance commented
//               //       // Padding(
//               //       //   padding: const EdgeInsets.only(top: 10),
//               //       //   child: Row(
//               //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //       //     children: [
//               //       //       const Text(
//               //       //         "Balance",
//               //       //         style: TextStyle(
//               //       //             color: Colors.black,
//               //       //             fontWeight: FontWeight.w500,
//               //       //             fontSize: 15),
//               //       //       ),
//               //       //       Padding(
//               //       //         padding: const EdgeInsets.only(top: 8),
//               //       //         child: Text(
//               //       //           roundStringWith(balance.toString()),
//               //       //           style: const TextStyle(
//               //       //               color: Colors.black,
//               //       //               fontWeight: FontWeight.w500,
//               //       //               fontSize: 15),
//               //       //         ),
//               //       //       ),
//               //       //     ],
//               //       //   ),
//               //       // ),
//               //     ],
//               //   ),
//               //   decoration: BoxDecoration(
//               //
//               //      color: const Color(0xffFFFFFF),
//               //       border: Border.all(color: Colors.grey, width: .2)),
//               // ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 19, right: 19, bottom: 10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.5, //height of button
//                       width: MediaQuery.of(context).size.width / 3.6,
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width / 3.6,
//                             height: MediaQuery.of(context).size.height / 15,
//                             child: Text(
//                               'Cash',
//                               style: customisedStyle(context, Colors.black, FontWeight.w500, 19.00),
//                               textAlign: TextAlign.center,
//                             ),
//                             // color: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width / 3.6,
//                             height: MediaQuery.of(context).size.height / 18,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('5');
//                                       },
//                                       child: const Text('5')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('10.00');
//                                       },
//                                       child: const Text('10')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('100.00');
//                                       },
//                                       child: const Text('100')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('200.00');
//                                       },
//                                       child: const Text('200')),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             //color: Colors.yellow,
//                             width: MediaQuery.of(context).size.width / 3.6,
//                             height: MediaQuery.of(context).size.height / 18,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('20.00');
//                                         // cashReceivedController.text = "20.00";
//                                       },
//                                       child: const Text('20')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('50.00');
//                                         // cashReceivedController.text = "50.00";
//                                       },
//                                       child: const Text('50')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('500.00');
//                                         // cashReceivedController.text = "500.00";
//                                       },
//                                       child: const Text('500')),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 15,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff262626),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
//                                       ),
//                                       onPressed: () {
//                                         addCashReceived('1000.00');
//                                         //   cashReceivedController.text = "1000.00";
//                                       },
//                                       child: const Text('1000')),
//                                 )
//                               ],
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 7,
//                           ),
//                           SizedBox(
//                               width: MediaQuery.of(context).size.width / 3.6,
//                               height: MediaQuery.of(context).size.height / 18,
//                               //   color: Colors.red,
//                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(10),
//                                   width: MediaQuery.of(context).size.width / 10,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: Text(
//                                     'Total Cash:',
//                                     style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                                   ),
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: MediaQuery.of(context).size.width / 11,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextField(
//                                     focusNode: cashReceivedFcNode,
//                                     controller: cashReceivedController,
//                                     style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
//                                     ],
//                                     onTap: () => cashReceivedController.selection =
//                                         TextSelection(baseOffset: 0, extentOffset: cashReceivedController.value.text.length),
//                                     onChanged: (val) {
//                                       if (val.isEmpty) {
//                                         val = "0";
//                                       } else {
//                                         calculationOnPayment();
//                                       }
//                                     },
//                                     decoration: const InputDecoration(
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.all(10),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.all(5.0),
//                                   width: MediaQuery.of(context).size.width / 12,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//                                         //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
//                                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
//
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff10C103),
//                                         textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
//                                       ),
//                                       onPressed: () {
//                                         bankReceivedController.text = '0.00';
//                                         cashReceivedController.text = grandTotalAmount;
//                                         calculationOnPayment();
//                                       },
//                                       child: Text(
//                                         'Full in cash',
//                                         style: customisedStyle(context, Colors.white, FontWeight.w500, 11.00),
//                                       )),
//                                 )
//                               ])
//                               // color: Colors.grey,
//                               ),
//                         ],
//                       ),
//                       //color: Colors.grey,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height / 2.5, //height of button
//                       width: MediaQuery.of(context).size.width / 3.7,
//                       //bank
//                       child: Column(
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width / 3.6,
//                             height: MediaQuery.of(context).size.height / 15,
//                             child: Text(
//                               'Bank',
//                               style: customisedStyle(context, Colors.black, FontWeight.w500, 19.00),
//                               textAlign: TextAlign.center,
//                             ),
//                             // color: Colors.grey,
//                           ),
//                           Container(
//                             width: MediaQuery.of(context).size.width / 4,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Amount:',
//                                   style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                                 ),
//                                 SizedBox(
//                                   width: MediaQuery.of(context).size.width / 8,
//                                   height: MediaQuery.of(context).size.height / 18,
//                                   child: TextField(
//                                     focusNode: amountFcNode,
//                                     controller: bankReceivedController,
//                                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
//                                     ],
//                                     style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                                     onTap: () => bankReceivedController.selection =
//                                         TextSelection(baseOffset: 0, extentOffset: bankReceivedController.value.text.length),
//                                     onChanged: (val) {
//                                       if (val.isEmpty) {
//                                       } else {
//                                         if (checkBank(val)) {
//                                           calculationOnPayment();
//
//
//                                         } else {
//
//                                         }
//                                       }
//                                     },
//                                     onEditingComplete: () {
//                                       FocusScope.of(context).requestFocus(cardType);
//                                     },
//                                     decoration: const InputDecoration(
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.all(10),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBFBFBF), width: .1)),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   width: MediaQuery.of(context).size.width / 14,
//                                   height: MediaQuery.of(context).size.height / 21,
//                                   child: TextButton(
//                                       style: TextButton.styleFrom(
//
//                                         //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
//                                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2))),
//                                         primary: Colors.white,
//                                         backgroundColor: const Color(0xff10C103),
//                                         textStyle: customisedStyle(context, Colors.black, FontWeight.w500, 10.00),
//                                       ),
//                                       onPressed: () {
//                                         cashReceivedController.text = '0.00';
//                                         bankReceivedController.text = grandTotalAmount;
//                                         calculationOnPayment();
//                                       },
//                                       child: Text(
//                                         'Pay Full',
//                                         style: customisedStyle(context, Colors.white, FontWeight.w500, 11.00),
//                                       )),
//                                 )
//                               ],
//                             ),
//                           ),
//                           SizedBox(height: 15),
//                           Container(
//                             width: MediaQuery.of(context).size.width / 4,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Discount:',
//                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: MediaQuery.of(context).size.width / 12,
//                                   height: MediaQuery.of(context).size.height / 21,
//                                   child: TextField(
//                                     focusNode: discountFcNode,
//                                     controller: discountAmountController,
//                                     style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
//                                     //   focusNode: netTotalFocusNode,
//                                     keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
//
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.deny(RegExp('[-, ]')),
//                                     ],
//                                     onChanged: (text) async {
//                                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                                       var country = prefs.getString("CountryName") ?? "";
//                                       print("-country--$country");
//
//                                       if (text.isEmpty) {
//                                         // discountAmountController.text = '0.00';
//                                         discountCalc(2, '0.00');
//                                       } else {
//                                         /// discount
//                                         discountCalc(2, text);
//
//                                         // if (country == "Saudi Arabia") {
//                                         //   getVatChangedDetails(2, text);
//                                         //
//                                         // } else {
//                                         //
//                                         //   discountCalc(2, text);
//                                         // }
//                                       }
//                                     },
//                                     onTap: () => discountAmountController.selection =
//                                         TextSelection(baseOffset: 0, extentOffset: discountAmountController.value.text.length),
//                                     decoration: const InputDecoration(
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.all(10),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   alignment: Alignment.center,
//                                   width: MediaQuery.of(context).size.width / 12,
//                                   height: MediaQuery.of(context).size.height / 21,
//                                   child: TextField(
//                                     controller: discountPerController,
//                                     keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
//                                     inputFormatters: [
//                                       FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
//                                     ],
//                                     style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
//                                     onTap: () => discountPerController.selection =
//                                         TextSelection(baseOffset: 0, extentOffset: discountPerController.value.text.length),
//                                     onChanged: (text) async {
//                                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                                       var country = prefs.getString("CountryName") ?? "";
//
//                                       if (text.isEmpty) {
//                                       } else {
//                                         discountCalc(1, text);
//
//                                         /// discount
//                                         // if (country == "Saudi Arabia") {
//                                         //   getVatChangedDetails(1, text);
//                                         //
//                                         // } else {
//                                         //   discountCalc(1, text);
//                                         // }
//                                       }
//                                     },
//                                     decoration: const InputDecoration(
//                                       suffixIcon: Icon(
//                                         Icons.percent,
//                                         color: Colors.black,
//                                       ),
//                                       isDense: true,
//                                       contentPadding: EdgeInsets.all(10),
//                                       filled: true,
//                                       fillColor: Colors.white,
//                                       border: OutlineInputBorder(),
//                                     ),
//                                   ),
//                                 ),
//
//                                 /// to items
//                                 // Container(
//                                 //   width: MediaQuery.of(context).size.width / 14,
//                                 //   height: MediaQuery.of(context).size.height / 21,
//                                 //   child: TextButton(
//                                 //       style: TextButton.styleFrom(
//                                 //         //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
//                                 //         shape: const RoundedRectangleBorder(
//                                 //             borderRadius: BorderRadius.all(
//                                 //                 Radius.circular(4))),
//                                 //
//                                 //         primary: Colors.white,
//                                 //         backgroundColor: const Color(0xffF38811),
//                                 //         textStyle: const TextStyle(
//                                 //             fontSize: 10,
//                                 //             fontWeight: FontWeight.w400),
//                                 //       ),
//                                 //       onPressed: () {},
//                                 //       child: const Text('To Items')),
//                                 // )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height / 12, //height of button
//                 width: MediaQuery.of(context).size.width / 1.7,
//                 color: Colors.white,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 16, //height of button
//                       width: MediaQuery.of(context).size.width / 10,
//                       child: TextButton(
//                           style: TextButton.styleFrom(
//                             padding: const EdgeInsets.all(15.0),
//                             backgroundColor: const Color(0xffFF0000),
//                             textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//                           ),
//                           onPressed: () {
//                             backToDining();
//                           },
//                           child: Text(
//                             'Cancel',
//                             style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00),
//                           )),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 16, //height of button
//                       width: MediaQuery.of(context).size.width / 10,
//                       child: TextButton(
//                           style: TextButton.styleFrom(
//                             padding: EdgeInsets.all(15.0),
//                             primary: Colors.white,
//                             backgroundColor: const Color(0xff1155F3),
//                             textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                           ),
//                           onPressed: () {
//
//
//                             if((cashReceived+bankReceived)>= double.parse(grandTotalAmount)){
//                               createSaleInvoice(true);
//                             }
//                             else{
//                               dialogBox(context, "You cant make credit sale");
//
//                             }
//
//                           },
//                           child: Text('Print&Save', style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00))),
//                     ),
//                     const SizedBox(
//                       width: 4,
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 16, //height of button
//                       width: MediaQuery.of(context).size.width / 10,
//                       child: TextButton(
//                           style: TextButton.styleFrom(
//                             padding: const EdgeInsets.all(15.0),
//                             primary: Colors.white,
//                             backgroundColor: const Color(0xff0A9800),
//                             textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//                           ),
//                           onPressed: () {
//                             if((cashReceived+bankReceived)>= double.parse(grandTotalAmount)){
//                               createSaleInvoice(false);
//                             }
//                             else{
//                               dialogBox(context, "You cant make credit sale");
//                             }
//
//                           },
//                           child: Text('Save', style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00))),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           //color: Colors.grey,
//         ),
//         Padding(
//             padding: EdgeInsets.only(top: 20),
//             child: Container(
//               height: MediaQuery.of(context).size.height / 1, //height of button
//               width: MediaQuery.of(context).size.width / 3.3,
//               child: Padding(
//                   padding: const EdgeInsets.all(1),
//                   child: ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: itemListPayment.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Card(
//                           child: Container(
//                             height: MediaQuery.of(context).size.height / 9,
//                             // width: MediaQuery.of(context).size.width / 2.5,
//                             child: Padding(
//                               padding: const EdgeInsets.only(top: 0),
//                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                                 GestureDetector(
//                                   onTap: () async {
//                                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                                     setState(() {});
//                                   },
//                                   child: Container(
//                                     padding: const EdgeInsets.all(3),
//                                     // height: MediaQuery.of(context).size.height / 9,
//                                     width: MediaQuery.of(context).size.width / 7,
//                                     child: ListView(
//                                       // mainAxisAlignment: MainAxisAlignment.start,
//                                       // crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 itemListPayment[index].productName,
//                                                 style: customisedStyle(context, Colors.black, FontWeight.bold, 12.00),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//                                           itemListPayment[index].description,
//                                           style: const TextStyle(fontSize: 11),
//                                         ),
//                                         Text(
//                                           "Spicy",
//                                           style: customisedStyle(context, Colors.black, FontWeight.bold, 10.00),
//                                         )
//                                       ],
//                                     ),
//                                     // decoration: BoxDecoration(
//                                     //     border: Border.all(
//                                     //         color: Colors.grey, width: .2))
//                                   ),
//                                 ),
//                                 Container(
//                                   // color:Colors.red,
//                                   padding: const EdgeInsets.all(3),
//                                   // height: MediaQuery.of(context).size.height / 9,
//                                   width: MediaQuery.of(context).size.width / 7.5,
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 //' ',
//                                                 "Rate",
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 "Qty",
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 "Tax:",
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 "Net:",
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             crossAxisAlignment: CrossAxisAlignment.end,
//                                             children: [
//                                               Text(
//                                                 //' ',
//                                                 roundStringWith(itemListPayment[index].unitPrice),
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 roundStringWith(itemListPayment[index].quantity),
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 roundStringWith(itemListPayment[index].totalTaxRounded),
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
//                                               ),
//                                               Text(
//                                                 roundStringWith(itemListPayment[index].netAmount),
//                                                 style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   // decoration: BoxDecoration(
//                                   //   //color: Colors.red,
//                                   //   border: Border.all(color: Colors.grey, width: .2),
//                                   // )
//                                 ),
//                               ]),
//                             ),
//                           ),
//                         );
//                       })),
//             ))
//       ],
//     );
//   }
//
//   /// pos section
//   Widget posDetailScreen() {
//     return ListView(
//       children: [
//         tableNameHeader(),
//         Row(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   //   color: Colors.red,
//                   border: Border(
//                 right: BorderSide(
//                   //                   <--- left side
//                   color: borderColor,
//                   width: .5,
//                 ),
//                 bottom: BorderSide(
//                   //                   <--- left side
//                   color: borderColor,
//                   width: .5,
//                 ),
//                 left: BorderSide(
//                   //                   <--- left side
//                   color: borderColor,
//                   width: .5,
//                 ),
//               )),
//               height: MediaQuery.of(context).size.height / 1.14, //height of button
//               width: MediaQuery.of(context).size.width / 1.8,
//               //  padding: const EdgeInsets.all(5),
//               child: ListView(
//                 children: [
//                   addItemDetail(),
//                   displayCategoryNames(),
//                   displayProductDetails(),
//
//                   /// commented bottom bar
//                   // bottomNextPageList(),
//                 ],
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(border: Border.all(color: borderColor, width: .5)),
//               child: ordersList(order),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget tableNameHeader() {
//     return SafeArea(
//       child: Container(
//           padding: EdgeInsets.only(left: 8, right: 8),
//           decoration: BoxDecoration(
//               border: Border(
//             bottom: BorderSide(
//               //                   <--- left side
//               color: borderColor,
//               width: .5,
//             ),
//           )),
//           height: MediaQuery.of(context).size.height / 13,
//           //height of button
//           width: MediaQuery.of(context).size.width / 1,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 alignment: Alignment.bottomLeft,
//                 height: MediaQuery.of(context).size.height / 9, //height of button
//                 width: MediaQuery.of(context).size.width / 11,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ///table name
//                     ///
//                     Text(
//                       tableHeader,
//                       style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff717171), fontSize: 12.0),
//                     ),
//                     Text(
//                       'Choose Items',
//                       style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 11.0),
//                     )
//                   ],
//                 ),
//               ),
//               Row(
//                 children: [
//                   ///add customer button
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       displayLoyaltyListBox(context);
//                   //     });
//                   //   },
//                   //   child: SizedBox(
//                   //     height: MediaQuery.of(context).size.height /
//                   //         18, //height of button
//                   //     width: MediaQuery.of(context).size.width / 7,
//                   //     child: TextButton(
//                   //       style: TextButton.styleFrom(
//                   //         primary: const Color(0xffFFFFFF),
//                   //         backgroundColor:
//                   //             const Color(0xff172026), // Background Color
//                   //       ),
//                   //       onPressed: () {
//                   //         displayLoyaltyListBox(context);
//                   //       },
//                   //       child: Row(
//                   //         mainAxisAlignment: MainAxisAlignment.center,
//                   //         children: [
//                   //           IconButton(
//                   //             icon: SvgPicture.asset('assets/svg/person.svg'),
//                   //             iconSize: 40,
//                   //             onPressed: () {
//                   //               displayLoyaltyListBox(context);
//                   //             },
//                   //           ),
//                   //           const Text(
//                   //             'Add Customer',
//                   //             style: TextStyle(fontSize: 12),
//                   //           )
//                   //         ],
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 6),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 7,
//                       child: TextField(
//                         style: TextStyle(fontSize: 12),
//                         keyboardType: TextInputType.text,
//                         textCapitalization: TextCapitalization.words,
//                         focusNode: custNameHeaderFcNode,
//                         onEditingComplete: () {
//                           FocusScope.of(context).requestFocus(phoneNoHeaderFcNode);
//                         },
//                         onTap: () =>
//                             customerNameController.selection = TextSelection(baseOffset: 0, extentOffset: customerNameController.value.text.length),
//                         controller: customerNameController,
//                         decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'Customer name'),
//                       ),
//                     ),
//                   ),
//
//
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 6,left: 5),
//                     child: Container(
//                       width: MediaQuery.of(context).size.width / 7,
//                       child: TextField(
//                         style: TextStyle(fontSize: 12),
//                         keyboardType: TextInputType.number,
//                         textCapitalization: TextCapitalization.words,
//                         focusNode: phoneNoHeaderFcNode,
//                         onEditingComplete: () {
//                           FocusScope.of(context).requestFocus(saveFcNode);
//                         },
//                         controller: phoneNumberController,
//                         decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'Phone No'),
//                       ),
//                     ),
//                   ),
//
//                   ///loyalty customer add
//                   // GestureDetector(
//                   //   onTap: () {
//                   //     setState(() {
//                   //       displayLoyalityAlertBox(context);
//                   //     });
//                   //   },
//                   //   child: SizedBox(
//                   //     height: MediaQuery.of(context).size.height /
//                   //         17, //height of button
//                   //     width: MediaQuery.of(context).size.width / 26,
//                   //     child: TextButton(
//                   //       style: TextButton.styleFrom(
//                   //         primary: const Color(0xffFFFFFF),
//                   //         backgroundColor:
//                   //             const Color(0xff172026), // Background Color
//                   //       ),
//                   //       onPressed: () {
//                   //         displayLoyalityAlertBox(context);
//                   //       },
//                   //       child: Icon(Icons.add),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//               UserDetailsAppBar(user_name: user_name),
//             ],
//           )),
//     );
//   }
//
// // bool isProductCode = false;
// // bool isProductName = true;
// // bool isProductDescription = false;
//   late ValueNotifier<int> productSearchNotifier;
//
//   Widget addItemDetail() {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border(
//         bottom: BorderSide(
//           //                   <--- left side
//           color: borderColor,
//           width: 1,
//         ),
//       )),
//       height: MediaQuery.of(context).size.height / 14,
//       width: MediaQuery.of(context).size.width / 1.6,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           ValueListenableBuilder(
//               valueListenable: productSearchNotifier,
//               builder: (BuildContext context, int newIndex, _) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width / 14,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: productSearchNotifier.value == 1 ? Color(0xffF25F29) : Colors.white),
//                           onPressed: () {
//                             productSearchNotifier.value = 1;
//                             print(productSearchNotifier.value);
//                           },
//                           child: Text(
//                             'Code',
//                             style: customisedStyle(context, productSearchNotifier.value == 1 ? Colors.white : Colors.black, FontWeight.w600, 9.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width / 14,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: productSearchNotifier.value == 2 ? Color(0xffF25F29) : Colors.white),
//                           onPressed: () {
//                             productSearchNotifier.value = 2;
//                             print(productSearchNotifier.value);
//                           },
//                           child: Text(
//                             'Name',
//                             style: customisedStyle(context, productSearchNotifier.value == 2 ? Colors.white : Colors.black, FontWeight.w600, 9.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0),
//                       child: SizedBox(
//                         width: MediaQuery.of(context).size.width / 14,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(backgroundColor: productSearchNotifier.value == 3 ? Color(0xffF25F29) : Colors.white),
//                           onPressed: () {
//                             productSearchNotifier.value = 3;
//                             print(productSearchNotifier.value);
//                           },
//                           child: Text(
//                             'Description',
//                             style: customisedStyle(context, productSearchNotifier.value == 3 ? Colors.white : Colors.black, FontWeight.w600, 9.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(7.0),
//                       child: Container(
//                         height: MediaQuery.of(context).size.height / 13,
//                         width: MediaQuery.of(context).size.width / 5,
//                         child: TextField(
//                           controller: searchController,
//                           textAlign: TextAlign.center,
//                           onChanged: (text) {
//                             setState(() {
//                               _selectedIndex = 1000;
//                               _searchData(text);
//                             });
//                           },
//                           decoration: InputDecoration(
//                               hintText: 'Add item',
//                               hintStyle: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
//                               isDense: true,
//                               fillColor: Color(0xffFFFFFF),
//                               border: OutlineInputBorder(),
//                               contentPadding: EdgeInsets.all(11)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//           Container(
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Veg Only',
//                   style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0, left: 05),
//                   child: FlutterSwitch(
//                     width: 40.0,
//                     height: 20.0,
//                     valueFontSize: 30.0,
//                     toggleSize: 15.0,
//                     value: veg,
//                     borderRadius: 20.0,
//                     padding: 1.0,
//                     activeColor: Colors.green,
//                     activeTextColor: Colors.green,
//                     inactiveTextColor: Colors.white,
//                     inactiveColor: Colors.grey,
//                     onToggle: (val) {
//                       setState(() {
//                         productList.clear();
//                         _selectedIndex = 1000;
//                         veg = val;
//                       });
//                     },
//                   ),
//                 ),
//                 // Container(
//                 //   alignment: Alignment.center,
//                 //   height: MediaQuery.of(context).size.height / 13,
//                 //   width: MediaQuery.of(context).size.width / 18,
//                 //   child: Text(
//                 //     'Veg Only',
//                 //     style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
//                 //   ),
//                 // ),
//                 // SizedBox(
//                 //   height: MediaQuery.of(context).size.height / 13,
//                 //   width: MediaQuery.of(context).size.width / 17,
//                 //   child: FlutterSwitch(
//                 //     width: 40.0,
//                 //     height: 20.0,
//                 //     valueFontSize: 30.0,
//                 //     toggleSize: 15.0,
//                 //     value: veg,
//                 //     borderRadius: 20.0,
//                 //     padding: 1.0,
//                 //     activeColor: Colors.green,
//                 //     activeTextColor: Colors.green,
//                 //     inactiveTextColor: Colors.white,
//                 //     inactiveColor: Colors.grey,
//                 //     onToggle: (val) {
//                 //       setState(() {
//                 //         productList.clear();
//                 //         _selectedIndex = 1000;
//                 //         veg = val;
//                 //       });
//                 //     },
//                 //   ),
//                 // )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ///
//
//   var a = 1;
//
//   Widget displayCategoryNames() {
//     return Container(
//       padding: const EdgeInsets.only(left: 2, right: 2),
//
//       height: MediaQuery.of(context).size.height / 6, //height of button
//       width: MediaQuery.of(context).size.width / 1.6,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(0),
//             height: MediaQuery.of(context).size.height / 9,
//             //height of button
//             width: MediaQuery.of(context).size.width / 25,
//             decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(5))),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   ///if condition
//                   if (a != 0) {
//                     a = a - 1;
//                     _animateToIndex(a);
//                   } else {}
//                 });
//               },
//               icon: SvgPicture.asset(
//                 'assets/svg/arrowback.svg',
//               ),
//             ),
//           ),
//
//           ///here
//
//           Container(
//             height: MediaQuery.of(context).size.height / 8, //height of button
//             width: _width,
//             //   width: MediaQuery.of(context).size.width / 2.2,
//
//             child: GridView.builder(
//                 controller: categoryController,
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: .3,
//                   crossAxisSpacing: 1,
//                 ),
//                 itemCount: categoryList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ListTile(
//                     hoverColor: Colors.transparent,
//                     selected: index == _selectedIndex,
//                     onTap: () {
//                       searchController.clear();
//                       FocusScope.of(context).requestFocus(submitFocusButton);
//
//                       setState(() {
//                         _selectedIndex = index;
//                         productList.clear();
//                       });
//                       getProductListDetails(categoryList[index].categoryGroupId);
//                     },
//                     title: TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: _selectedIndex == index ? const Color(0xff172026) : Colors.white,
//                           side: const BorderSide(color: Color(0xffB8B8B8), width: .2),
//                           textStyle: const TextStyle(fontSize: 11),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _selectedIndex = index;
//                             productList.clear();
//                           });
//                           getProductListDetails(categoryList[index].categoryGroupId);
//                         },
//                         child: Text(categoryList[index].categoryName,
//                             style: customisedStyle(context, _selectedIndex == index ? Colors.white : const Color(0xff172026), FontWeight.w400, 12.0)
//                             //    style: TextStyle(color:_selectedIndex == index ? Colors.white :const Color(0xff172026),),
//                             )),
//                   );
//                 }),
//           ),
//
//           Container(
//             decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(5))),
//             padding: const EdgeInsets.all(0),
//             height: MediaQuery.of(context).size.height / 9,
//             //height of button
//             width: MediaQuery.of(context).size.width / 25,
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   totalCategory = categoryList.length;
//
//                   a = a + 1;
//                   _animateToIndex(a);
//                 });
//               },
//               // onPressed: () => ,
//               icon: SvgPicture.asset('assets/svg/arrowforward.svg'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   returnVegOrNonVeg(type) {
//     if (type == "veg") {
//       return "assets/svg/product_veg.svg";
//     } else {
//       return "assets/svg/product_non_veg.svg";
//     }
//   }
//
//   returnProductName(String val) {
//     var out = val;
//     if (val.length > 30) {
//       out = val.substring(0, 28);
//     }
//     return out;
//   }
//
//   Widget displayProductDetails() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8, right: 8),
//       child: Container(
//           height: MediaQuery.of(context).size.height / 1.5, //height of button
//           width: MediaQuery.of(context).size.width / 1.6,
//           child: GridView.builder(
//               padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),
//               controller: productController,
//               shrinkWrap: true,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 childAspectRatio: 2.3, //2.4 will workk
//                 crossAxisSpacing: 5,
//                 mainAxisSpacing: 5,
//               ),
//               itemCount: productList.length,
//               itemBuilder: (BuildContext context, int i) {
//                 return GestureDetector(
//                   onTap: () async {
//                     searchController.clear();
//                     FocusScope.of(context).requestFocus(submitFocusButton);
//                     SharedPreferences prefs = await SharedPreferences.getInstance();
//                     setState(() {
//                       order = 1;
//                       var checkVat = prefs.getBool("checkVat") ?? false;
//                       var checkGst = prefs.getBool("check_GST") ?? false;
//
//                       /// settings
//                       var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;
//                       // var selectedPrinter = prefs.getString('printer') ?? '';
//                       // var kot = prefs.getBool('KOT') ?? false;
//
//                       unitPriceAmountWR = productList[i].defaultSalesPrice;
//                       inclusiveUnitPriceAmountWR = productList[i].defaultSalesPrice;
//                       vatPer = double.parse(productList[i].vatsSalesTax);
//                       gstPer = double.parse(productList[i].gSTSalesTax);
//
//                       priceListID = productList[i].defaultUnitID;
//                       productName = productList[i].productName;
//                       item_status = "pending";
//                       unitName = productList[i].defaultUnitName;
//
//                       if (checkVat == true) {
//                         productTaxName = productList[i].vATTaxName;
//                         productTaxID = productList[i].vatID;
//                       } else if (checkGst == true) {
//                         productTaxName = productList[i].gSTTaxName;
//                         productTaxID = productList[i].gstID;
//                       } else {
//                         productTaxName = "None";
//                         productTaxID = 1;
//                       }
//
//                       detailID = 1;
//                       salesPrice = productList[i].defaultSalesPrice;
//                       descriptionD = productList[i].description;
//                       purchasePrice = productList[i].defaultPurchasePrice;
//                       productID = productList[i].productID;
//                       isInclusive = productList[i].isInclusive;
//
//                       editProductItem = false;
//                       detailIdEdit = 0;
//                       flavourID = "";
//                       flavourName = "";
//
//                       print("--------Des$descriptionD");
//
//                       /// qty increment
//                       if (qtyIncrement == true) {
//                         print("true in settings");
//
//                         if (checking(priceListID)) {
//                           print("true in function");
//                           unique_id = orderDetTable[tableIndex].uniqueId;
//                           updateQty(1, tableIndex);
//                           tableIndex = 0;
//                         } else {
//                           unique_id = "0";
//                           calculation();
//                         }
//                       } else {
//                         unique_id = "0";
//                         calculation();
//                       }
//                     });
//                   },
//                   child: Container(
//                     height: MediaQuery.of(context).size.height / 8, //height of button
//                     width: MediaQuery.of(context).size.width / 6,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                           width: 1,
//                           color: const Color(0xffC9C9C9),
//                         ),
//                         borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
//                             )),
//                     child: Row(
//                       children: [
//                         productList[i].productImage == ''
//                             ? Container(
//                                 height: MediaQuery.of(context).size.height / 8, //height of button
//                                 width: MediaQuery.of(context).size.width / 17,
//                                 decoration: BoxDecoration(
//                                     border: Border.all(
//                                       width: .1,
//                                       color: const Color(0xffC9C9C9),
//                                     ),
//                                     borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
//                                         )),
//
//                                 child: SvgPicture.asset("assets/svg/Logo.svg"),
//                               )
//                             : Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   height: MediaQuery.of(context).size.height / 8, //height of button
//                                   width: MediaQuery.of(context).size.width / 17,
//
//                                   decoration: BoxDecoration(
//                                       image: DecorationImage(image: NetworkImage(productList[i].productImage), fit: BoxFit.cover),
//                                       border: Border.all(
//                                         width: .1,
//                                         color: const Color(0xffC9C9C9),
//                                       ),
//                                       borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
//                                           )),
//                                 ),
//                               ),
//
//                         // CircleAvatar(
//                         //   radius: 15,
//                         //   backgroundColor: Colors.grey[300],
//                         //   backgroundImage: productList[i]. == '' ?
//                         //   Container(
//                         //     height: MediaQuery.of(context).size.height /
//                         //         8, //height of button
//                         //     width: MediaQuery.of(context).size.width / 17,
//                         //
//                         //     decoration: BoxDecoration(
//                         //         border: Border.all(
//                         //           width: .1,
//                         //           color: const Color(0xffC9C9C9),
//                         //         ),
//                         //         borderRadius: const BorderRadius.all(
//                         //             Radius.circular(
//                         //                 5.0) //                 <--- border radius here
//                         //         )),
//                         //
//                         //     child: SvgPicture.asset("assets/svg/Logo.svg"),
//                         //   ): NetworkImage(BaseUrl.imageURL+companyList[index].image),
//                         // ),
//
//                         // Container(
//                         //   height: MediaQuery.of(context).size.height /
//                         //       8, //height of button
//                         //   width: MediaQuery.of(context).size.width / 17,
//                         //
//                         //   decoration: BoxDecoration(
//                         //       border: Border.all(
//                         //         width: .1,
//                         //         color: const Color(0xffC9C9C9),
//                         //       ),
//                         //       borderRadius: const BorderRadius.all(
//                         //           Radius.circular(
//                         //               5.0) //                 <--- border radius here
//                         //           )),
//                         //
//                         //   child: SvgPicture.asset("assets/svg/Logo.svg"),
//                         // ),
//                         Container(
//                           // height: MediaQuery.of(context).size.height / 8.5, //height of button
//                           width: MediaQuery.of(context).size.width / 10,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SizedBox(
//                                   // height: MediaQuery.of(context).size.height /                                    17, //height of button
//                                   //  width: MediaQuery.of(context).size.width / 11,
//                                   child: Text(returnProductName(productList[i].productName),
//                                       style: customisedStyle(context, Colors.black, FontWeight.w700, 11.0)),
//                                 ),
//                               ),
//
//                               // Padding(
//                               //   padding: const EdgeInsets.all(8.0),
//                               //   child: SizedBox(
//                               //     // height: MediaQuery.of(context).size.height /                                    17, //height of button
//                               //     //  width: MediaQuery.of(context).size.width / 11,
//                               //     child: Text(productList[i].defaultUnitName, style: const TextStyle(fontSize: 11),),
//                               //   ),
//                               // ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: SizedBox(
//                                   //  height: MediaQuery.of(context).size.height /                                   24, //height of button
//                                   // width: MediaQuery.of(context).size.width / 11,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     // crossAxisAlignment: CrossAxisAlignment.center,
//                                     children: [
//                                       Text("SR ${roundStringWith(productList[i].defaultSalesPrice)}",
//                                           //'Rs.95 ',
//                                           style: customisedStyle(context, Colors.black, FontWeight.w700, 11.0)),
//                                       Container(
//                                         height: MediaQuery.of(context).size.height / 42,
//                                         child: SvgPicture.asset(returnVegOrNonVeg(productList[i].vegOrNonVeg)),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           // color: Colors.orange,
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               })),
//     );
//   }
//
// //15772100027983
//   /// display order items
//   ordersList(int order) {
//     if (order == 1) {
//       return displayOrderedList();
//     } else if (order == 2) {
//       return chooseFlavour();
//     } else {}
//   }
//
//   createFlavourApi() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//       dialogBox(context, "Check your internet connection");
//     } else {
//       try {
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? "0";
//         var userID = prefs.getInt('user_id') ?? 0;
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/flavours/create-flavour/';
//         var suffix = "";
//
//         //    {"CompanyID": "d4ca8637-696b-4ff0-8b88-991774b9547c", "BranchID": 1, "FlavourName": "new fla", "BgColor": "","IsActive":true,"CreatedUserID":62}
//
//         print(url);
//         Map data = {
//           "CompanyID": companyID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "FlavourName": flavourNameController.text,
//           "IsActive": true,
//           "BgColor": "",
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         print(status);
//         if (status == 6000) {
//           flavourNameController.clear();
//
//           flavourList.clear();
//           getAllFlavours();
//           dialogBox(context, "Flavour created");
//           stop();
//         } else if (status == 6001) {
//           stop();
//           var msg = n["error"];
//           // dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   List selectedItemsDelivery = [];
//   bool lngPress = false;
//
//   selectAll() {
//     setState(() {
//       selectedItemsDelivery.clear();
//       for (var i = 0; i < orderDetTable.length; i++) {
//         print("_______________________________________");
//         selectedItemsDelivery.add(i);
//       }
//       print(selectedItemsDelivery);
//     });
//   }
//
//   changeStatusToDelivered(type) {
//     for (var i = 0; i < selectedItemsDelivery.length; i++) {
//       parsingJson[selectedItemsDelivery[i]]["Status"] = type;
//     }
//
//     setState(() {
//       orderDetTable.clear();
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//       selectedItemsDelivery.clear();
//       lngPress = false;
//     });
//   }
//
//   returnStatusSelected(index) {
//     setState(() {
//       selectedItemsDelivery.clear();
//       for (var i = 0; i < orderDetTable.length; i++) {
//         print("_______________________________________");
//         selectedItemsDelivery.add(i);
//       }
//       print(selectedItemsDelivery);
//     });
//   }
//
//   bool newCheckValue = false;
//
//   returnColorListItem(status) {
//     if (status == "pending") {
//       return Colors.green;
//     } else if (status == "delivered") {
//       return Colors.black12;
//     } else {
//       return Colors.blueAccent;
//     }
//   }
//
//   returnHead(val1, val2) {
//     if (lngPress) {
//       return val1;
//     } else {
//       return val2;
//     }
//   }
//
//   returnListHeight() {
//     var a = lngPress ? 0.5 : 0.6;
//     return MediaQuery.of(context).size.height * a;
//   }
//
//   Widget displayOrderedList() {
//     return Container(
//       height: MediaQuery.of(context).size.height / 1.15, //height of button
//       width: MediaQuery.of(context).size.width / 2.9,
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0, right: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width / 9,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xff0347A1)),
//                       onPressed: () {
//                         changeStatusToDelivered("take_away");
//                       },
//                       child: Text(
//                         'Take Away',
//                         style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width / 9,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xff000000)),
//                       onPressed: () {
//                         changeStatusToDelivered("delivered");
//                       },
//                       child: Text(
//                         'Delivered',
//                         style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: SizedBox(
//                     width: MediaQuery.of(context).size.width / 13,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xffF25F29)),
//                       onPressed: () {},
//                       child: Text(
//                         'Convert to >',
//                         style: customisedStyle(context, Colors.white, FontWeight.w500, 10.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           lngPress
//               ? Padding(
//                   padding: const EdgeInsets.only(top: 8.0, bottom: 10.00),
//                   child: Container(
//                     // height: mHeight * .12,
//                     color: Colors.white,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Checkbox(
//                               checkColor: Colors.white,
//                               activeColor: const Color(0xff08A103),
//                               value: newCheckValue,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               onChanged: (value) {
//                                 newCheckValue = !newCheckValue;
//                                 print(newCheckValue);
//                                 if (newCheckValue) {
//                                   selectAll();
//                                 } else {
//                                   setState(() {
//                                     selectedItemsDelivery.clear();
//                                     lngPress = false;
//                                   });
//                                 }
//                               },
//                             ),
//                             Text(
//                               "Select all",
//                               style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Container(),
//           Padding(
//             padding: const EdgeInsets.only(top: 15.0),
//             child: Container(
//               height: returnListHeight(),
//               child: ListView.separated(
//                 shrinkWrap: true,
//                 itemCount: orderDetTable.length,
//                 separatorBuilder: (BuildContext context, int index) => const Divider(),
//                 itemBuilder: (BuildContext context, int index) {
//                   final item = orderDetTable[index];
//                   print("_+______________item $item");
//                   final isSelected = selectedItemsDelivery.contains(index);
//                   print(isSelected);
//                   return SizedBox(
//                     height: MediaQuery.of(context).size.height / 9,
//                     // width: MediaQuery.of(context).size.width / 2.5,
//                     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                       lngPress == true
//                           ? Checkbox(
//                               checkColor: Colors.white,
//                               activeColor: const Color(0xff08A103),
//                               value: isSelected,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                               onChanged: (value) {
//                                 setState(() {
//                                   if (isSelected) {
//                                     selectedItemsDelivery.remove(index);
//                                   } else {
//                                     selectedItemsDelivery.add(index);
//                                   }
//                                 });
//                               },
//                             )
//                           : Container(),
//                       Container(
//                         //   width: MediaQuery.of(context).size.width / 4.2,
//                         decoration: BoxDecoration(
//                             color: isSelected ? Color(0xff82acd9) : Color(0xffFffff),
//                             //  color: isSelected ? Color(0xff82acd9) : returnColorListItem(orderDetTable[index].item_status),
//                             border: Border.all(color: Colors.grey)),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 height: MediaQuery.of(context).size.height / 9,
//                                 width: 20,
//                                 child: SvgPicture.asset(returnIconStatus(orderDetTable[index].status)),
//                               ),
//                             ),
//
//                             GestureDetector(
//                               child: AbsorbPointer(
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                       padding: const EdgeInsets.all(3),
//
//                                          // color:Colors.red,
//                                       // height: MediaQuery.of(context).size.height / 9,
//                                       width: MediaQuery.of(context).size.width / returnHead(7.5, 6.5),
//                                       child: ListView(
//                                         // mainAxisAlignment: MainAxisAlignment.start,
//                                         // crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: Text(
//                                                   orderDetTable[index].productName,
//                                                   style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//                                                   // style: customisedStyle(context, returnColorITem(orderDetTable[index].item_status), FontWeight.w600, 12.0),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                           Text(
//                                             orderDetTable[index].description,
//                                             style: customisedStyle(context, Colors.black, FontWeight.w600, 11.0),
//                                           ),
//                                           Text(
//                                             orderDetTable[index].flavourName,
//                                             style: customisedStyle(context, Colors.black, FontWeight.w600, 10.0),
//                                           )
//                                         ],
//                                       ),
//                                       // decoration: BoxDecoration(
//                                       //     border: Border.all(
//                                       //         color: Colors.grey, width: .2))
//                                     ),
//                                     Container(
//                                       ///    color:Colors.yellow,
//                                       padding: const EdgeInsets.all(3),
//                                       // height: MediaQuery.of(context).size.height / 9,
//                                       width: MediaQuery.of(context).size.width / returnHead(10, 8),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: <Widget>[
//                                           Row(
//                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text("Rate", style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text("Qty", style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text("Tax:", style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text("Net:", style: customisedStyle(context, Colors.black, FontWeight.bold, 11.0)),
//                                                 ],
//                                               ),
//                                               Column(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                                 children: [
//                                                   Text(
//                                                       //' ',
//                                                       roundStringWith(orderDetTable[index].unitPrice),
//                                                       style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text(roundStringWith(orderDetTable[index].quantity),
//                                                       style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text(roundStringWith(orderDetTable[index].totalTaxRounded),
//                                                       style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
//                                                   Text(roundStringWith(orderDetTable[index].netAmount),
//                                                       style: customisedStyle(context, Colors.black, FontWeight.bold, 12.0)),
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       // decoration: BoxDecoration(
//                                       //   //color: Colors.red,
//                                       //   border: Border.all(color: Colors.grey, width: .2),
//                                       // )
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               onLongPress: () {
//                                 setState(() {
//                                   selectedItemsDelivery.clear();
//                                   lngPress = !lngPress;
//                                   selectedItemsDelivery.add(index);
//                                 });
//                               },
//                               onTap: () async {
//                                 if (lngPress) {
//                                   setState(() {
//                                     if (isSelected) {
//                                       selectedItemsDelivery.remove(index);
//                                     } else {
//                                       selectedItemsDelivery.add(index);
//                                     }
//                                   });
//                                 } else {
//                                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   setState(() {
//                                     editProductItem = true;
//                                     detailIdEdit = index;
//                                     var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//                                     var checkVat = prefs.getBool("checkVat") ?? false;
//                                     var checkGst = prefs.getBool("check_GST") ?? false;
//
//                                     unitPriceDetailController.text = orderDetTable[index].unitPrice;
//                                     inclusiveUnitPriceAmountWR = orderDetTable[index].inclusivePrice;
//                                     qtyDetailController.text = orderDetTable[index].quantity;
//                                     quantity = double.parse(orderDetTable[index].quantity);
//                                     vatPer = double.parse(orderDetTable[index].vatPer);
//                                     gstPer = double.parse(orderDetTable[index].gstPer);
//                                     priceListID = orderDetTable[index].priceListId;
//                                     productName = orderDetTable[index].productName;
//                                     item_status = orderDetTable[index].status;
//                                     unitName = orderDetTable[index].unitPriceName;
//                                     flavourID = orderDetTable[index].flavourID;
//                                     flavourName = orderDetTable[index].flavourName;
//                                     unique_id = orderDetTable[index].uniqueId;
//                                     netAmount = double.parse(orderDetTable[index].netAmount);
//
//                                     if (checkVat == true) {
//                                       productTaxName = orderDetTable[index].productTaxName;
//                                       productTaxID = orderDetTable[index].productTaxID;
//                                     } else if (checkGst == true) {
//                                       productTaxName = orderDetTable[index].productTaxName;
//                                       productTaxID = orderDetTable[index].productTaxID;
//                                     } else {
//                                       productTaxName = "None";
//                                       productTaxID = 1;
//                                     }
//
//                                     detailID = orderDetTable[index].detailID;
//                                     salesPrice = orderDetTable[index].salesPrice;
//                                     descriptionD = orderDetTable[index].description;
//                                     purchasePrice = orderDetTable[index].costPerPrice;
//                                     productID = orderDetTable[index].productId;
//                                     isInclusive = orderDetTable[index].productInc;
//
//                                     actualProductTaxName = orderDetTable[index].actualProductTaxName;
//                                     actualProductTaxID = orderDetTable[index].actualProductTaxID;
//                                     unitPriceAmountWR = orderDetTable[index].unitPrice;
//                                     rateWithTax = double.parse(orderDetTable[index].rateWithTax);
//                                     costPerPrice = orderDetTable[index].costPerPrice;
//                                     discountPer = orderDetTable[index].discountPercentage;
//                                     discountAmount = double.parse(orderDetTable[index].discountAmount);
//                                     grossAmountWR = orderDetTable[index].grossAmount;
//                                     vatAmount = double.parse(orderDetTable[index].vatAmount);
//                                     sGSTPer = double.parse(orderDetTable[index].sgsPer);
//                                     sGSTAmount = double.parse(orderDetTable[index].sgsAmount);
//                                     cGSTPer = double.parse(orderDetTable[index].cgsPer);
//                                     cGSTAmount = double.parse(orderDetTable[index].cgsAmount);
//                                     iGSTPer = double.parse(orderDetTable[index].igsPer);
//                                     iGSTAmount = double.parse(orderDetTable[index].igsAmount);
//                                     createdUserID = orderDetTable[index].createUserId;
//                                     dataBase = "";
//                                     taxableAmountPost = double.parse(orderDetTable[index].taxableAmount);
//                                     gstPer = double.parse(orderDetTable[index].gstPer);
//                                     unitPriceRounded = roundDouble(double.parse(orderDetTable[index].unitPrice), qtyDecimal);
//                                     quantityRounded = roundDouble(double.parse(orderDetTable[index].quantity), qtyDecimal);
//                                     netAmountRounded = roundDouble(double.parse(orderDetTable[index].netAmount), qtyDecimal);
//                                     totalTax = double.parse(orderDetTable[index].totalTaxRounded);
//
//                                     order = 2;
//                                     if (flavourList.isEmpty) {
//                                       print(
//                                           'its empty-*------------------------------------its empty-*------------------------------------its empty-*------------------------------------its empty-*------------------------------------');
//                                       getAllFlavours();
//                                     } else {
//                                       print(
//                                           'its already-*------------------------------------its already-*------------------------------------its already-*------------------------------------its already-*------------------------------------');
//                                     }
//                                   });
//                                 }
//                               }, //
//                             ),
//                             Container(
//                               height: MediaQuery.of(context).size.height / 8,
//                               width: 30,
//                               color: Colors.red,
//                               child: IconButton(
//                                 iconSize: 10,
//                                 onPressed: () async {
//                                   setState(() {
//                                     var dictionary = {
//                                       "unq_id": orderDetTable[index].uniqueId,
//                                     };
//                                     if (orderDetTable[index].detailID == 1) {
//                                     } else {
//                                       selectedItemsDelivery.remove(index);
//                                       deletedList.add(dictionary);
//                                     }
//                                     orderDetTable.removeAt(index);
//                                     orderDetTable.clear();
//                                     parsingJson.removeAt(index);
//                                   });
//
//                                   await deleteItem();
//                                 },
//                                 icon: SvgPicture.asset('assets/svg/clear.svg'),
//                               ),
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ]),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(4),
//             height: MediaQuery.of(context).size.height / 7,
//             width: MediaQuery.of(context).size.width / 2.5,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 30,
//                   width: MediaQuery.of(context).size.width / 2.5,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Tax',
//                         style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//                       ),
//                       Text(currency + " " + "${roundStringWith(totalTaxMP.toString())}",
//                           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0))
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 27,
//                   width: MediaQuery.of(context).size.width / 2.5,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'To be Paid',
//                         style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),
//                       ),
//                       Text(
//                         currency + " " + "${roundStringWith(totalNetP.toString())}",
//                         style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 20,
//                   width: MediaQuery.of(context).size.width / 2.5,
//                   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 20,
//                       width: MediaQuery.of(context).size.width / 6.6,
//                       child: TextButton(
//                         style: TextButton.styleFrom(
//                           primary: const Color(0xffFFFFFF),
//                           backgroundColor: const Color(0xffFF0000), // Background Color
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             orderDetTable.clear();
//                             itemListPayment.clear();
//                             productList.clear();
//                             totalNetP = 00.0;
//                             totalTaxMP = 00.0;
//                             totalGrossP = 00.0;
//                             vatAmountTotalP = 00.0;
//                             cGstAmountTotalP = 00.0;
//                             sGstAmountTotalP = 00.0;
//                             iGstAmountTotalP = 00.0;
//                             if (orderType == 1) {
//                               mainPageIndex = 1;
//                             } else if (orderType == 2) {
//                               mainPageIndex = 2;
//                             } else if (orderType == 3) {
//                               mainPageIndex = 3;
//                             } else if (orderType == 4) {
//                               mainPageIndex = 4;
//                             } else {}
//                           });
//                         },
//                         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//                           IconButton(
//                             icon: SvgPicture.asset('assets/svg/clear.svg'),
//                             onPressed: () {},
//                           ),
//                           Text(
//                             'Cancel',
//                             style: customisedStyle(context, Colors.white, FontWeight.w600, 12.0),
//                           ),
//                         ]),
//                       ),
//                     ),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 20,
//                       width: MediaQuery.of(context).size.width / 6.6,
//                       child: TextButton(
//                         style: TextButton.styleFrom(
//                           backgroundColor: const Color(0xff10C103), // Background Color
//                         ),
//                         onPressed: () async {
//                           if (orderDetTable.isEmpty) {
//                             dialogBox(context, "At least one product");
//                           } else {
//                             bool val = await checkNonRatableItem();
//                             if (val) {
//                               postingData();
//                             } else {
//                               dialogBox(context, "Price must be greater than 0");
//                             }
//
//                             //  postingData();
//                           }
//                         },
//                         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                           // Icon(
//                           //   color: SvgPicture.asset('assets/svg/check.svg'),
//                           // ),
//                           // Icon(
//                           //   icon: SvgPicture.asset(
//                           //       'assets/svg/check.svg'),
//                           //   iconSize: 40,
//                           //   // onPressed: () {
//                           //   //   print("11");
//                           //   //  // postingData();
//                           //   // },
//                           // ),
//
//                           Text(
//                             'Save',
//                             style: customisedStyle(context, Colors.white, FontWeight.w600, 12.0),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ]),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   returnIconStatus(status) {
//     if (status == "pending") {
//       return "assets/svg/pending.svg";
//     } else if (status == "delivered") {
//       return "assets/svg/delivered.svg";
//     } else {
//       return "assets/svg/take_away.svg";
//     }
//   }
//
//   returnColorITem(status) {
//     print(status);
//     if (status == "pending") {
//       return Colors.green;
//     } else if (status == "delivered") {
//       return Colors.black;
//     } else {
//       return Color(0xff0347A1);
//     }
//   }
//
//   checkNonRatableItem() {
//     bool returnVal = true;
//     for (var i = 0; i < orderDetTable.length; i++) {
//       if (double.parse(orderDetTable[i].unitPrice) > 0.0) {
//         returnVal = true;
//       } else {
//         print("its not");
//         return false;
//       }
//     }
//
//     return returnVal;
//   }
//
//   deleteItem() {
//     setState(() {
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//       totalAmount();
//     });
//   }
//
//   returnRadio(selectedInd, index) {
//     return true;
//   }
//
//   Widget chooseFlavour() {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 1.15, //height of button
//       width: MediaQuery.of(context).size.width / 3,
//
//       child: Column(
//         children: [
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             height: MediaQuery.of(context).size.height / 15, //height of button
//             width: MediaQuery.of(context).size.width / 2.8,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   //alignment: Alignment.l,
//                   height: MediaQuery.of(context).size.height / 14, //height of button
//                   width: MediaQuery.of(context).size.width / 9,
//                   child: Text(
//                     productName,
//                     style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 15.00),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 13, //height of button
//                   width: MediaQuery.of(context).size.width / 7,
//                   child: Row(
//                     children: [
//                       Container(
//                         // alignment: Alignment.center,
//
//                         height: MediaQuery.of(context).size.height / 20,
//                         //height of button
//                         width: MediaQuery.of(context).size.width / 29,
//                         decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(3))),
//
//                         child: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 if (quantity <= 0) {
//                                 } else {
//                                   quantity = quantity - 1;
//
//                                   calculationOnEditing();
//                                 }
//                               });
//                             },
//                             icon: SvgPicture.asset('assets/svg/increment_qty.svg')),
//                       ),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//                         height: MediaQuery.of(context).size.height / 17, //height of button
//                         width: MediaQuery.of(context).size.width / 17,
//                         child: TextField(
//                           controller: qtyDetailController,
//                           style: customisedStyle(context, Color(0xff000000), FontWeight.w500, 14.00),
//                           onChanged: (text) {
//                             if (text.isNotEmpty) {
//                               quantity = double.parse(text);
//                               calculationOnEditing();
//                             } else {}
//                           },
//                           decoration: const InputDecoration(
//                             isDense: true,
//                             contentPadding: EdgeInsets.all(12),
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 4,
//                       ),
//                       Container(
//                         alignment: Alignment.center,
//
//                         height: MediaQuery.of(context).size.height / 20,
//                         //height of button
//                         width: MediaQuery.of(context).size.width / 29,
//                         decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(3))),
//
//                         child: IconButton(
//                             onPressed: () {
//                               setState(() {
//                                 quantity = quantity + 1;
//                                 calculationOnEditing();
//                               });
//
//                               // - assets/svg/increment_qty.svg
//                               //     - assets/svg/decrease_item.svg
//                             },
//                             icon: SvgPicture.asset('assets/svg/decrease_item.svg')),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(4),
//             // height: MediaQuery.of(context).size.height / 30, //height of button
//             width: MediaQuery.of(context).size.width / 2.8,
//             child: Text(
//               descriptionD,
//               style: customisedStyle(context, Color(0xff717171), FontWeight.w400, 12.00),
//             ),
//           ),
//
//           ///   total tax and net amount commented
//           // Container(
//           //   padding: const EdgeInsets.all(4),
//           //   height: MediaQuery.of(context).size.height / 7,
//           //   width: MediaQuery.of(context).size.width / 2.5,
//           //   child: Column(
//           //     children: [
//           //       SizedBox(
//           //         height: MediaQuery.of(context).size.height / 30,
//           //         width: MediaQuery.of(context).size.width / 2.5,
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Text(
//           //               'Tax',
//           //               //  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//           //               style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//           //             ),
//           //             Text(
//           //               currency + " " + "$totalTax",
//           //               //   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//           //
//           //               style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//           //             )
//           //           ],
//           //         ),
//           //       ),
//           //       SizedBox(
//           //         height: MediaQuery.of(context).size.height / 27,
//           //         width: MediaQuery.of(context).size.width / 2.5,
//           //         child: Row(
//           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //           children: [
//           //             Text(
//           //               'To be Paid',
//           //               style: customisedStyle(context, Colors.black, FontWeight.w600, 14.00),
//           //             ),
//           //             Text(
//           //               currency + " " + "$netAmount",
//           //               style: customisedStyle(context, Colors.black, FontWeight.w600, 14.00),
//           //             )
//           //           ],
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           Container(
//             padding: const EdgeInsets.all(4),
//             height: MediaQuery.of(context).size.height / 17, //height of button
//             width: MediaQuery.of(context).size.width / 2.8,
//             child: Row(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 17, //height of button
//                   width: MediaQuery.of(context).size.width / 7,
//                 ),
//                 Container(
//                   alignment: Alignment.center,
//                   height: MediaQuery.of(context).size.height / 17, //height of button
//                   width: MediaQuery.of(context).size.width / 13,
//                   child: Text(
//                     'Rate:',
//                     style: customisedStyle(context, Color(0xffF25F29), FontWeight.w600, 12.00),
//                   ),
//                 ),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height / 17, //height of button
//                   width: MediaQuery.of(context).size.width / 10,
//                   child: TextField(
//                     controller: unitPriceDetailController,
//                     style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
//                     keyboardType: TextInputType.numberWithOptions(decimal: true),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
//                     ],
//                     onChanged: (text) {
//                       if (text.isNotEmpty) {
//                         calculationOnEditing();
//                       } else {}
//                     },
//                     decoration: const InputDecoration(
//                       isDense: true,
//                       contentPadding: EdgeInsets.all(12),
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           /// flavour cratin commented
//
//           Expanded(
//             child: SizedBox(
//               //  height: MediaQuery.of(context).size.height / 8, //height of button
//               width: MediaQuery.of(context).size.width / 2.2,
//
//               child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: flavourList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Card(
//                         child: ListTile(
//                       tileColor: selectedIndexFlavour == index ? Colors.redAccent : Color(0xffEEEEEE),
//                       title: Text(
//                         flavourList[index].flavourName,
//                         style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
//                       ),
//                       onTap: () async {
//                         setState(() {
//                           flavourID = flavourList[index].id;
//                           flavourName = flavourList[index].flavourName;
//                           selectedIndexFlavour = index;
//                         });
//                       },
//                     ));
//                   }),
//             ),
//           ),
//
//           Container(
//             alignment: Alignment.bottomCenter,
//             height: MediaQuery.of(context).size.height / 14, //height of button
//             width: MediaQuery.of(context).size.width / 2.8,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 SizedBox(
//                   //  height: MediaQuery.of(context).size.height / 22, //,height of button
//                   width: MediaQuery.of(context).size.width / 6.5,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.all(16.0),
//                       primary: Colors.white,
//                       backgroundColor: const Color(0xffFF0000),
//                       textStyle: const TextStyle(fontSize: 18),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         order = 1;
//                       });
//                     },
//                     child: Text(
//                       'Cancel',
//                       style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   // height: MediaQuery.of(context).size.height / 22, //height of button
//                   width: MediaQuery.of(context).size.width / 6.5,
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.all(16.0),
//                       primary: Colors.white,
//                       backgroundColor: const Color(0xff309E10),
//                       textStyle: const TextStyle(fontSize: 18),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         order = 1;
//                         addData();
//                       });
//                     },
//                     child: Text(
//                       'Save',
//                       style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   buttonColor(String status) {
//     if (status == "Vacant") {
//       return const Color(0xffE5E5E5);
//     } else if (status == "Ordered") {
//       return const Color(0xff03C1C1);
//     } else if (status == "Billed") {
//       return const Color(0xff034FC1);
//     } else if (status == "Paid") {
//       return const Color(0xff10C103);
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   takeAwayButton(String takeAway) {
//     if (takeAway == "Vacant") {
//       return const Color(0xffE5E5E5);
//     } else if (takeAway == "Ordered") {
//       return const Color(0xff03C1C1);
//     } else if (takeAway == "Billed") {
//       return const Color(0xff034FC1);
//     } else if (takeAway == "Paid") {
//       return const Color(0xff10C103);
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   onlineButton(String online) {
//     if (online == "Vacant") {
//       return const Color(0xffE5E5E5);
//     } else if (online == "Ordered") {
//       return const Color(0xff03C1C1);
//     } else if (online == "Billed") {
//       return const Color(0xff034FC1);
//     } else if (online == "Paid") {
//       return const Color(0xff10C103);
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   carButton(String car) {
//     if (car == "Vacant") {
//       return const Color(0xffE5E5E5);
//     } else if (car == "Ordered") {
//       return const Color(0xff03C1C1);
//     } else if (car == "Billed") {
//       return const Color(0xff034FC1);
//     } else if (car == "Paid") {
//       return const Color(0xff10C103);
//     } else {
//       return Colors.grey;
//     }
//   }
//
//   double roundDouble(double value, String places) {
//     var pl = int.parse(places);
//     num mod = pow(10.0, pl);
//     return ((value * mod).round().toDouble() / mod);
//   }
//
//   calculationOnEditing() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       print('----1');
//       var grossAmount;
//       var unit;
//       taxType = "None";
//       taxID = 32;
//
//       var discount;
//       var inclusivePer = 0.0;
//       var exclusivePer = 0.0;
//
//       var checkVat = prefs.getBool("checkVat") ?? false;
//       var checkGst = prefs.getBool("check_GST") ?? false;
//       var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
//       var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//       print('----1');
//       if (checkVat == true) {
//         taxType = "VAT";
//         taxID = 32;
//         if (isInclusive == true) {
//           inclusivePer = inclusivePer + vatPer;
//         } else {
//           exclusivePer = exclusivePer + vatPer;
//         }
//       }
//       if (checkGst == true) {
//         taxType = "GST Intra-state B2C";
//         taxID = 22;
//         if (isInclusive == true) {
//           inclusivePer = inclusivePer + gstPer;
//         } else {
//           exclusivePer = exclusivePer + gstPer;
//         }
//       }
//       print('----1');
//       unit = double.parse(unitPriceDetailController.text);
//       if (inclusivePer == 0.0) {
//         unitPriceAmountWR = (unit).toString();
//
//         var taxAmount = (unit * exclusivePer) / 100;
//         inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
//         unit = unit;
//       } else {
//         var taxAmount = (unit * inclusivePer) / (100 + inclusivePer);
//         print(taxAmount);
//         unit = unit - taxAmount;
//         inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
//         unitPriceAmountWR = (unit).toString();
//         print(unit);
//       }
//       print('----1');
//       discount = 0.0;
//       percentageDiscount = 0;
//       discountAmount = 0;
//
//       grossAmount = quantity * unit;
//       grossAmountWR = "$grossAmount";
//       taxableAmountPost = grossAmount - discount;
//       vatAmount = (taxableAmountPost * vatPer / 100);
//       gstAmount = (taxableAmountPost * gstPer / 100);
//       print('----1');
//       var ga = roundDouble(gstAmount, priceDecimal);
//       var va = roundDouble(vatAmount, priceDecimal);
//
//       if (checkVat == false) {
//         vatAmount = 0.0;
//         print(vatAmount);
//       }
//       if (checkGst == false) {
//         gstAmount = 0.0;
//       }
//
//       cGSTAmount = gstAmount / 2;
//       sGSTAmount = gstAmount / 2;
//       iGSTAmount = gstAmount;
//       cGSTPer = gstPer / 2;
//       iGSTPer = gstPer;
//       sGSTPer = gstPer / 2;
//
//       if (taxType == "Export") {
//         cGSTAmount = 0.0;
//         sGSTAmount = 0.0;
//         iGSTAmount = 0.0;
//         vatAmount = 0.0;
//         totalTax = 0.0;
//       } else if (taxType == "Import") {
//         cGSTAmount = 0.0;
//         sGSTAmount = 0.0;
//         iGSTAmount = 0.0;
//         vatAmount = 0.0;
//         totalTax = 0.0;
//         print('import');
//       } else if (taxType == "GST Inter-state B2C") {
//         cGSTAmount = 0.0;
//         sGSTAmount = 0.0;
//         totalTax = iGSTAmount;
//       } else if (taxType == "GST Inter-state B2B") {
//         cGSTAmount = 0.0;
//         sGSTAmount = 0.0;
//         totalTax = iGSTAmount;
//       } else if (taxType == "GST Intra-state B2C") {
//         iGSTAmount = 0.0;
//         totalTax = cGSTAmount + cGSTAmount;
//       } else if (taxType == "GST Intra-state B2B") {
//         iGSTAmount = 0.0;
//         totalTax = cGSTAmount + sGSTAmount;
//       } else if (taxType == "None") {
//         cGSTAmount = 0.0;
//         sGSTAmount = 0.0;
//         iGSTAmount = 0.0;
//         vatAmount = 0.0;
//         totalTax = 0.0;
//         print(totalTax);
//       } else if (taxType == "VAT") {
//         totalTax = vatAmount;
//       }
//       print('----1');
//       netAmount = taxableAmountPost + totalTax;
//       var singleTax = totalTax / quantity;
//       rateWithTax = unit + singleTax;
//       costPerPrice = purchasePrice;
//       percentageDiscount = (discount * 100 / netAmount);
//       discountAmount = discount;
//
//       qtyDetailController.text = "$quantity";
//       quantityRounded = roundDouble(quantity, qtyDecimal);
//       netAmountRounded = roundDouble(netAmount, qtyDecimal);
//       unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);
//     });
//   }
//
//   addData() {
//     Map data = {
//       "ProductName": productName,
//       "Status": item_status,
//       "UnitName": unitName,
//       "Qty": "$quantity",
//       "ProductTaxName": productTaxName,
//       "ProductTaxID": productTaxID,
//       "SalesPrice": salesPrice,
//       "ProductID": productID,
//       "ActualProductTaxName": actualProductTaxName,
//       "ActualProductTaxID": actualProductTaxID,
//       "BranchID": 1,
//       "SalesDetailsID": 1,
//       "id": unique_id,
//       "FreeQty": "0",
//       "UnitPrice": unitPriceAmountWR,
//       "RateWithTax": "$rateWithTax",
//       "CostPerPrice": costPerPrice,
//       "PriceListID": priceListID,
//       "DiscountPerc": discountPer,
//       "DiscountAmount": "$discountAmount",
//       "GrossAmount": grossAmountWR,
//       "VATPerc": "$vatPer",
//       "VATAmount": "$vatAmount",
//       "NetAmount": "$netAmount",
//       "detailID": detailID,
//       "SGSTPerc": "$sGSTPer",
//       "SGSTAmount": "$sGSTAmount",
//       "CGSTPerc": "$cGSTPer",
//       "CGSTAmount": "$cGSTAmount",
//       "IGSTPerc": "$iGSTPer",
//       "IGSTAmount": "$iGSTAmount",
//       "CreatedUserID": createdUserID,
//       "DataBase": dataBase,
//       "flavour": flavourID,
//       "Flavour_Name": flavourName,
//       "TaxableAmount": "$taxableAmountPost",
//       "AddlDiscPerc": "0",
//       "AddlDiscAmt": "0",
//       "gstPer": "$gstPer",
//       "is_inclusive": isInclusive,
//       "unitPriceRounded": "$unitPriceRounded",
//       "quantityRounded": "$quantityRounded",
//       "netAmountRounded": "$netAmountRounded",
//       "InclusivePrice": inclusiveUnitPriceAmountWR,
//       "TotalTaxRounded": "$totalTax",
//       "Description": descriptionD,
//     };
//     print(data);
//     parsingJson[detailIdEdit] = data;
//     setState(() {
//       orderDetTable.clear();
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//     });
//
//     totalAmount();
//   }
//
//   checking(int proID) {
//     for (var i = 0; i < orderDetTable.length; i++) {
//       if (orderDetTable[i].priceListId == proID) {
//         setState(() {
//           tableIndex = i;
//         });
//
//         return true;
//       }
//     }
//     return false;
//   }
//
//   var tableIndex = 0;
//   var currencySymbol = "";
//
//   updateQty(int val, int i) async {
//     int indexChanging = i;
//     quantity = double.parse(orderDetTable[indexChanging].quantity);
//     if (val == 1) {
//       quantity = quantity + 1.0;
//     } else {
//       quantity = quantity - 1.0;
//     }
//
//     detailID = orderDetTable[indexChanging].detailID;
//     unitPriceAmountWR = orderDetTable[indexChanging].unitPrice;
//     inclusiveUnitPriceAmountWR = orderDetTable[indexChanging].inclusivePrice;
//     vatPer = double.parse(orderDetTable[indexChanging].vatPer);
//     gstPer = double.parse(orderDetTable[indexChanging].gstPer);
//
//     var uuid = orderDetTable[indexChanging].uniqueId;
//     print("=========================================");
//     print(uuid);
//     print("===========================================");
//
//     productName = orderDetTable[indexChanging].productName;
//     item_status = orderDetTable[indexChanging].status;
//     unitName = orderDetTable[indexChanging].unitPriceName;
//     descriptionD = orderDetTable[indexChanging].description;
//
//     salesPrice = orderDetTable[indexChanging].salesPrice;
//     purchasePrice = orderDetTable[indexChanging].costPerPrice;
//     productID = orderDetTable[indexChanging].productId;
//     isInclusive = orderDetTable[indexChanging].productInc;
//     actualProductTaxName = orderDetTable[indexChanging].actualProductTaxName;
//     actualProductTaxID = orderDetTable[indexChanging].actualProductTaxID;
//     priceListID = orderDetTable[indexChanging].priceListId;
//
//     var grossAmount;
//     var unit;
//     taxType = "None";
//     taxID = 32;
//
//     var discount;
//     var inclusivePer = 0.0;
//     var exclusivePer = 0.0;
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var checkVat = prefs.getBool("checkVat") ?? false;
//     var checkGst = prefs.getBool("check_GST") ?? false;
//     var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
//     var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//
//     if (checkVat == true) {
//       taxType = "VAT";
//       taxID = 32;
//
//       if (isInclusive == true) {
//         inclusivePer = inclusivePer + vatPer;
//       } else {
//         exclusivePer = exclusivePer + vatPer;
//       }
//     }
//     if (checkGst == true) {
//       taxType = "GST Intra-state B2C";
//       taxID = 22;
//
//       if (isInclusive == true) {
//         inclusivePer = inclusivePer + gstPer;
//       } else {
//         exclusivePer = exclusivePer + gstPer;
//       }
//     }
//
//     unit = double.parse(unitPriceAmountWR);
//
//     discount = 0.0;
//     percentageDiscount = 0;
//     discountAmount = 0;
//
//     grossAmount = quantity * unit;
//     grossAmountWR = "$grossAmount";
//     var gross = roundDouble(grossAmount, priceDecimal);
//
//     taxableAmountPost = grossAmount - discount;
//
//     vatAmount = (taxableAmountPost * vatPer / 100);
//     gstAmount = (taxableAmountPost * gstPer / 100);
//
//     var ga = roundDouble(gstAmount, priceDecimal);
//     var va = roundDouble(vatAmount, priceDecimal);
//
//     if (checkVat == false) {
//       vatAmount = 0.0;
//       print(vatAmount);
//     }
//     if (checkGst == false) {
//       gstAmount = 0.0;
//     }
//
//     cGSTAmount = gstAmount / 2;
//     sGSTAmount = gstAmount / 2;
//     iGSTAmount = gstAmount;
//     cGSTPer = gstPer / 2;
//     iGSTPer = gstPer;
//     sGSTPer = gstPer / 2;
//
//     if (taxType == "Export") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//     } else if (taxType == "Import") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//       print('import');
//     } else if (taxType == "GST Inter-state B2C") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       totalTax = iGSTAmount;
//     } else if (taxType == "GST Inter-state B2B") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       totalTax = iGSTAmount;
//     } else if (taxType == "GST Intra-state B2C") {
//       iGSTAmount = 0.0;
//       totalTax = cGSTAmount + cGSTAmount;
//     } else if (taxType == "GST Intra-state B2B") {
//       iGSTAmount = 0.0;
//       totalTax = cGSTAmount + sGSTAmount;
//     } else if (taxType == "None") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//       print(totalTax);
//     } else if (taxType == "VAT") {
//       totalTax = vatAmount;
//     }
//
//     netAmount = taxableAmountPost + totalTax;
//     var singleTax = totalTax / quantity;
//     rateWithTax = unit + singleTax;
//     costPerPrice = purchasePrice;
//     percentageDiscount = (discount * 100 / netAmount);
//     discountAmount = discount;
//
//     var tt = roundDouble(totalTax, priceDecimal);
//     quantityRounded = roundDouble(quantity, qtyDecimal);
//     netAmountRounded = roundDouble(netAmount, qtyDecimal);
//     unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);
//
//     Map data = {
//       "ProductName": productName,
//       "Status": item_status,
//       "UnitName": unitName,
//       "Qty": "$quantity",
//       "ProductTaxName": productTaxName,
//       "ProductTaxID": productTaxID,
//       "SalesPrice": salesPrice,
//       "ProductID": productID,
//       "ActualProductTaxName": actualProductTaxName,
//       "ActualProductTaxID": actualProductTaxID,
//       "BranchID": 1,
//       "SalesDetailsID": 1,
//       "id": uuid,
//       "FreeQty": "0",
//       "UnitPrice": unitPriceAmountWR,
//       "RateWithTax": "$rateWithTax",
//       "CostPerPrice": costPerPrice,
//       "PriceListID": priceListID,
//       "DiscountPerc": discountPer,
//       "DiscountAmount": "$discountAmount",
//       "GrossAmount": "$grossAmount",
//       "VATPerc": "$vatPer",
//       "VATAmount": "$vatAmount",
//       "NetAmount": "$netAmount",
//       "detailID": detailID,
//       "SGSTPerc": "$sGSTPer",
//       "SGSTAmount": "$sGSTAmount",
//       "CGSTPerc": "$cGSTPer",
//       "CGSTAmount": "$cGSTAmount",
//       "IGSTPerc": "$iGSTPer",
//       "IGSTAmount": "$iGSTAmount",
//       "CreatedUserID": createdUserID,
//       "DataBase": dataBase,
//       "flavour": flavourID,
//       "Flavour_Name": flavourName,
//       "TaxableAmount": "$taxableAmountPost",
//       "AddlDiscPerc": "0",
//       "AddlDiscAmt": "0",
//       "gstPer": "$gstPer",
//       "is_inclusive": isInclusive,
//       "unitPriceRounded": "$unitPriceRounded",
//       "quantityRounded": "$quantityRounded",
//       "netAmountRounded": "$netAmountRounded",
//       "InclusivePrice": inclusiveUnitPriceAmountWR,
//       "TotalTaxRounded": "$tt",
//       "Description": descriptionD,
//     };
//     print(data);
//     parsingJson[indexChanging] = data;
//
//     setState(() {
//       orderDetTable.clear();
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//     });
//     totalAmount();
//   }
//
//   calculation() async {
//     var grossAmount;
//     var unit;
//     taxType = "None";
//     taxID = 32;
//
//     var discount;
//     var inclusivePer = 0.0;
//     var exclusivePer = 0.0;
//     quantity = 1.0;
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var checkVat = prefs.getBool("checkVat") ?? false;
//     var checkGst = prefs.getBool("check_GST") ?? false;
//     var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
//     var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//
//     if (checkVat == true) {
//       taxType = "VAT";
//       taxID = 32;
//       if (isInclusive == true) {
//         inclusivePer = inclusivePer + vatPer;
//       } else {
//         exclusivePer = exclusivePer + vatPer;
//       }
//     }
//     if (checkGst == true) {
//       taxType = "GST Intra-state B2C";
//       taxID = 22;
//       if (isInclusive == true) {
//         inclusivePer = inclusivePer + gstPer;
//       } else {
//         exclusivePer = exclusivePer + gstPer;
//       }
//     }
//
//     unit = double.parse(unitPriceAmountWR);
//     if (inclusivePer == 0.0) {
//       unitPriceAmountWR = (unit).toString();
//
//       var taxAmount = (unit * exclusivePer) / 100;
//       inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
//       unit = unit;
//     } else {
//       var taxAmount = (unit * inclusivePer) / (100 + inclusivePer);
//       print(taxAmount);
//       unit = unit - taxAmount;
//       inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
//       unitPriceAmountWR = (unit).toString();
//       print(unit);
//     }
//
//     discount = 0.0;
//     percentageDiscount = 0;
//     discountAmount = 0;
//
//     grossAmount = quantity * unit;
//     grossAmountWR = "$grossAmount";
//     var gross = roundDouble(grossAmount, priceDecimal);
//     taxableAmountPost = grossAmount - discount;
//     vatAmount = (taxableAmountPost * vatPer / 100);
//     gstAmount = (taxableAmountPost * gstPer / 100);
//
//     var ga = roundDouble(gstAmount, priceDecimal);
//     var va = roundDouble(vatAmount, priceDecimal);
//
//     if (checkVat == false) {
//       vatAmount = 0.0;
//       print(vatAmount);
//     }
//     if (checkGst == false) {
//       gstAmount = 0.0;
//     }
//
//     cGSTAmount = gstAmount / 2;
//     sGSTAmount = gstAmount / 2;
//     iGSTAmount = gstAmount;
//     cGSTPer = gstPer / 2;
//     iGSTPer = gstPer;
//     sGSTPer = gstPer / 2;
//
//     if (taxType == "Export") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//     } else if (taxType == "Import") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//       print('import');
//     } else if (taxType == "GST Inter-state B2C") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       totalTax = iGSTAmount;
//     } else if (taxType == "GST Inter-state B2B") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       totalTax = iGSTAmount;
//     } else if (taxType == "GST Intra-state B2C") {
//       iGSTAmount = 0.0;
//       totalTax = cGSTAmount + cGSTAmount;
//     } else if (taxType == "GST Intra-state B2B") {
//       iGSTAmount = 0.0;
//       totalTax = cGSTAmount + sGSTAmount;
//     } else if (taxType == "None") {
//       cGSTAmount = 0.0;
//       sGSTAmount = 0.0;
//       iGSTAmount = 0.0;
//       vatAmount = 0.0;
//       totalTax = 0.0;
//       print(totalTax);
//     } else if (taxType == "VAT") {
//       totalTax = vatAmount;
//     }
//
//     netAmount = taxableAmountPost + totalTax;
//     var singleTax = totalTax / quantity;
//     rateWithTax = unit + singleTax;
//     costPerPrice = purchasePrice;
//     percentageDiscount = (discount * 100 / netAmount);
//     discountAmount = discount;
//
//     var tt = roundDouble(totalTax, priceDecimal);
//     quantityRounded = roundDouble(quantity, qtyDecimal);
//     netAmountRounded = roundDouble(netAmount, qtyDecimal);
//     unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);
//
//     Map data = {
//       "ProductName": productName,
//       "Status": item_status,
//       "UnitName": unitName,
//       "Qty": "$quantity",
//       "ProductTaxName": productTaxName,
//       "ProductTaxID": productTaxID,
//       "SalesPrice": salesPrice,
//       "ProductID": productID,
//       "ActualProductTaxName": actualProductTaxName,
//       "ActualProductTaxID": actualProductTaxID,
//       "BranchID": 1,
//       "SalesDetailsID": 1,
//       "id": unique_id,
//       "FreeQty": "0",
//       "UnitPrice": unitPriceAmountWR,
//       "RateWithTax": "$rateWithTax",
//       "CostPerPrice": costPerPrice,
//       "PriceListID": priceListID,
//       "DiscountPerc": discountPer,
//       "DiscountAmount": "$discountAmount",
//       "GrossAmount": "$grossAmount",
//       "VATPerc": "$vatPer",
//       "VATAmount": "$vatAmount",
//       "NetAmount": "$netAmount",
//       "detailID": detailID,
//       "SGSTPerc": "$sGSTPer",
//       "SGSTAmount": "$sGSTAmount",
//       "CGSTPerc": "$cGSTPer",
//       "CGSTAmount": "$cGSTAmount",
//       "IGSTPerc": "$iGSTPer",
//       "IGSTAmount": "$iGSTAmount",
//       "CreatedUserID": createdUserID,
//       "DataBase": dataBase,
//       "flavour": flavourID,
//       "Flavour_Name": flavourName,
//       "TaxableAmount": "$taxableAmountPost",
//       "AddlDiscPerc": "0",
//       "AddlDiscAmt": "0",
//       "gstPer": "$gstPer",
//       "is_inclusive": isInclusive,
//       "unitPriceRounded": "$unitPriceRounded",
//       "quantityRounded": "$quantityRounded",
//       "netAmountRounded": "$netAmountRounded",
//       "InclusivePrice": inclusiveUnitPriceAmountWR,
//       "TotalTaxRounded": "$tt",
//       "Description": descriptionD,
//     };
//     print(data);
//     orderDetTable.clear();
//     parsingJson.add(data);
//     setState(() {
//       for (Map user in parsingJson) {
//         orderDetTable.add(PassingDetails.fromJson(user));
//       }
//     });
//
//     totalAmount();
//   }
//
//   double totalNetP = 0;
//   double totalTaxMP = 0;
//   double totalGrossP = 0;
//   double vatAmountTotalP = 0;
//   double cGstAmountTotalP = 0;
//   double sGstAmountTotalP = 0;
//   double iGstAmountTotalP = 0;
//
//   totalAmount() {
//     double totalNet = 0;
//     double totalTaxM = 0;
//     double totalDiscount = 0;
//     double totalGross = 0;
//     double vatAmountTotal = 0;
//     double cGstAmountTotal = 0;
//     double sGstAmountTotal = 0;
//     double iGstAmountTotal = 0;
//     double tax1AmountTotal = 0;
//     double tax2AmountTotal = 0;
//     double tax3AmountTotal = 0;
//     for (var i = 0; i < orderDetTable.length; i++) {
//       totalNet += double.parse(orderDetTable[i].netAmount);
//       totalTaxM += double.parse(orderDetTable[i].totalTaxRounded);
//       vatAmountTotal += double.parse(orderDetTable[i].vatAmount);
//       cGstAmountTotal += double.parse(orderDetTable[i].cgsAmount);
//       sGstAmountTotal += double.parse(orderDetTable[i].sgsAmount);
//       iGstAmountTotal += double.parse(orderDetTable[i].igsAmount);
//       totalGross += double.parse(orderDetTable[i].grossAmount);
//     }
//     setState(() {
//       totalNetP = totalNet;
//       totalTaxMP = totalTaxM;
//       totalGrossP = totalGross;
//       vatAmountTotalP = vatAmountTotal;
//       cGstAmountTotalP = cGstAmountTotal;
//       sGstAmountTotalP = sGstAmountTotal;
//       iGstAmountTotalP = iGstAmountTotal;
//     });
//   }
//
//   postingData() {
//     var detailsList = [];
//
//     print("=====================================================");
//     print(orderDetTable.length);
//
//     for (var i = 0; i < orderDetTable.length; i++) {
//       var dictionary = {
//         "detailID": orderDetTable[i].detailID,
//         "Status": orderDetTable[i].status,
//         "Qty": orderDetTable[i].quantity,
//         "ProductID": orderDetTable[i].productId,
//         "UnitPrice": orderDetTable[i].unitPrice,
//         "RateWithTax": orderDetTable[i].rateWithTax,
//         "PriceListID": orderDetTable[i].priceListId,
//         "GrossAmount": orderDetTable[i].grossAmount,
//         "TaxableAmount": orderDetTable[i].taxableAmount,
//         "VATPerc": orderDetTable[i].vatPer,
//         "VATAmount": orderDetTable[i].vatAmount,
//         "SGSTPerc": orderDetTable[i].sgsPer,
//         "SGSTAmount": orderDetTable[i].sgsAmount,
//         "CGSTPerc": orderDetTable[i].cgsPer,
//         "CGSTAmount": orderDetTable[i].cgsAmount,
//         "IGSTPerc": orderDetTable[i].igsPer,
//         "IGSTAmount": orderDetTable[i].igsAmount,
//         "NetAmount": orderDetTable[i].netAmount,
//         "InclusivePrice": orderDetTable[i].inclusivePrice,
//         "Description": orderDetTable[i].description,
//         "ProductTaxID": orderDetTable[i].productTaxID,
//         "unq_id": orderDetTable[i].uniqueId,
//         "Flavour": orderDetTable[i].flavourID,
//         "FreeQty": "0",
//         "DiscountPerc": "0",
//         "DiscountAmount": "0",
//         "TAX1Perc": "0",
//         "TAX1Amount": "0",
//         "TAX2Perc": "0",
//         "TAX2Amount": "0",
//         "TAX3Perc": "0",
//         "TAX3Amount": "0",
//         "KFCAmount": "0",
//         "BatchCode": "0",
//         "SerialNos": [],
//       };
//
//       print("=================================================================");
//       print(i);
//       print(dictionary);
//       detailsList.add(dictionary);
//     }
//
//     if (orderEdit == true) {
//       updateSalesOrderRequest(detailsList);
//     } else {
//       print("---detail length----${detailsList.length}--");
//       createSalesOrderRequest(detailsList);
//     }
//   }
//
//   int? selectedDiningIndex = 1000;
//   var tokenNumber = "";
//   var tableID = "";
//   var orderType = 0;
//   var orderID = "";
//   var orderEdit = false;
//
//
//   bool resetToken = false;
//
//   /// create order
//   Future<Null> createSalesOrderRequest(var detailsList) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//       });
//     } else {
//       try {
//         for (var i = 0; i < detailsList.length; i++) {
//           print("--------------");
//           print(i);
//           print(detailsList[i]);
//         }
//
//         print("--detail length------");
//         print(detailsList.length);
//         print("--detail length------");
//
//         if (tokenNumber == "") {
//           tokenNumber = "01";
//         }
//
//         HttpOverrides.global = MyHttpOverrides();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         String baseUrl = BaseUrl.baseUrl;
//
//         var checkVat = prefs.getBool("checkVat") ?? false;
//         var checkGst = prefs.getBool("check_GST") ?? false;
//         var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
//         var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//         var taxTypeID = 31;
//         if (checkVat == true) {
//           taxTypeID = 32;
//           taxType = "VAT";
//         } else if (checkGst == true) {
//           taxTypeID = 22;
//           taxType = "GST Intra-state B2C";
//         } else {
//           taxTypeID = 31;
//           taxType = "None";
//         }
//
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var countryID = prefs.getString('Country') ?? 1;
//         var stateID = prefs.getString('State') ?? 1;
//
//         DateTime selectedDateAndTime = DateTime.now();
//         String convertedDate = "$selectedDateAndTime";
//         dateOnly = convertedDate.substring(0, 10);
//         var orderTime = "$selectedDateAndTime";
//
//         var type = "Dining";
//         var customerName = "walk in customer";
//         var phoneNumber = "";
//         var time = "";
//
//         if (orderType == 1) {
//           type = "Dining";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//           time = "";
//         } else if (orderType == 2) {
//           type = "TakeAway";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//
//           time = "";
//         }
//         // ignore: unrelated_type_equality_checks
//         else if (orderType == 3) {
//           type = "Online";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//
//           time = "";
//         } else if (orderType == 4) {
//           type = "Car";
//           // customerName = "test cust";
//           // phoneNumber = "8714152075";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//           time = "";
//         } else {}
//
//         final String url = '$baseUrl/posholds/create-pos/salesOrder/';
//         print(url);
//         Map data = {
//           "Table": tableID,
//           "CompanyID": companyID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "OrderTime": orderTime,
//           "Date": dateOnly,
//           "DeliveryDate": dateOnly,
//           "TotalTax": "$totalTaxMP",
//           "NetTotal": "$totalNetP",
//           "GrandTotal": "$totalNetP",
//           "TotalGrossAmt": "$totalGrossP",
//           "TaxType": taxType,
//           "TaxID": taxTypeID,
//           "VATAmount": "$vatAmountTotalP",
//           "SGSTAmount": "$sGstAmountTotalP",
//           "CGSTAmount": "$cGstAmountTotalP",
//           "IGSTAmount": "$iGstAmountTotalP",
//           "Type": type,
//           "LedgerID": PaymentData.ledgerID,
//           "CustomerName": customerName,
//           "Country_of_Supply": countryID,
//           "State_of_Supply": stateID,
//           "TokenNumber": "038",
//           "Phone": phoneNumber,
//           "saleOrdersDetails": detailsList,
//           "VoucherNo": "",
//           "BillDiscAmt": "0",
//           "BillDiscPercent": "0",
//           "DeliveryTime": "",
//           "GST_Treatment": "",
//           "Address1": "",
//           "Address2": "",
//           "Notes": "",
//           "PriceCategoryID": 1,
//           "FinacialYearID": 1,
//           "TAX1Amount": "0",
//           "TAX2Amount": "0",
//           "TAX3Amount": "0",
//           "ShippingCharge": "0",
//           "shipping_tax_amount": "0",
//           "TaxTypeID": "",
//           "SAC": "",
//           "SalesTax": "0",
//           "RoundOff": "0",
//           "IsActive": true,
//           "IsInvoiced": "N",
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         print(responseJson);
//         if (status == 6000) {
//           setState(() {
//             phoneNumberController.text = "";
//             customerNameController.text = "walk in customer";
//             PaymentData.ledgerID = 1;
//             _selectedIndex = 1000;
//             orderDetTable.clear();
//             parsingJson.clear();
//             order = 1;
//             productList.clear();
//             getCategoryListDetail();
//             getTableOrderList();
//             //  netWorkProblem = true;
//             stop();
//             dialogBox(context, 'Order created successfully !!!');
//             totalAmount();
//
//             Future.delayed(const Duration(seconds: 1), () async {
//               backToDining();
//               var id = n["OrderID"];
//
//
//
//               /// kot section
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//
//               var kot = prefs.getBool("KOT") ?? false;
//
//               if (kot == true) {
//                 PrintDataDetails.type = "SO";
//                 PrintDataDetails.id = id;
//
//                 printKOT(id);
//
//                 print("-------kot-------");
//                 print(kot);
//               } else {
//                 print("------kot--------");
//                 print(kot);
//               }
//             });
//           });
//         } else if (status == 6001) {
//           stop();
//           var errorMessage = n["message"];
//           dialogBox(context, errorMessage);
//         }
//
//         //DB Error
//         else {
//           dialogBox(context, "Please try again later");
//           stop();
//         }
//       } catch (e) {
//         dialogBox(context, e.toString());
//         setState(() {
//           stop();
//         });
//       }
//     }
//   }
//
//   backToDining() {
//     setState(() {
//       if (orderType == 1) {
//         selectedDiningIndex = 1000;
//         color1 = Colors.white;
//         color2 = const Color(0xffF8F8F8);
//         color3 = const Color(0xffF8F8F8);
//         color4 = const Color(0xffF8F8F8);
//         borderColor1 = Colors.black;
//         borderColor2 = Colors.transparent;
//         borderColor3 = Colors.transparent;
//         borderColor4 = Colors.transparent;
//         mainPageIndex = 1;
//       } else if (orderType == 2) {
//         color1 = const Color(0xffF8F8F8);
//         color2 = Colors.white;
//         color3 = const Color(0xffF8F8F8);
//         color4 = const Color(0xffF8F8F8);
//         borderColor2 = Colors.black;
//         borderColor1 = Colors.transparent;
//         borderColor3 = Colors.transparent;
//         borderColor4 = Colors.transparent;
//         mainPageIndex = 2;
//       }
//       // ignore: unrelated_type_equality_checks
//       else if (orderType == 3) {
//         color1 = const Color(0xffF8F8F8);
//         color2 = const Color(0xffF8F8F8);
//         color3 = Colors.white;
//         color4 = const Color(0xffF8F8F8);
//         borderColor2 = Colors.transparent;
//         borderColor1 = Colors.transparent;
//         borderColor3 = Colors.black;
//         borderColor4 = Colors.transparent;
//         mainPageIndex = 3;
//       } else if (orderType == 4) {
//         color1 = const Color(0xffF8F8F8);
//         color2 = const Color(0xffF8F8F8);
//         color4 = Colors.white;
//         color3 = const Color(0xffF8F8F8);
//         borderColor2 = Colors.transparent;
//         borderColor1 = Colors.transparent;
//         borderColor3 = Colors.transparent;
//         borderColor4 = Colors.black;
//         mainPageIndex = 4;
//       } else {}
//     });
//   }
//
//   /// update order
//   Future<Null> updateSalesOrderRequest(detailsList) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//       });
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         //var tableID = tableID;
//         String baseUrl = BaseUrl.baseUrl;
//
//         var checkVat = prefs.getBool("checkVat") ?? false;
//         var checkGst = prefs.getBool("check_GST") ?? false;
//         var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
//         var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
//         var taxTypeID;
//         if (checkVat == true) {
//           taxTypeID = 32;
//           taxType = "VAT";
//         } else if (checkGst == true) {
//           taxTypeID = 22;
//           taxType = "GST Intra-state B2C";
//         } else {
//           taxTypeID = 31;
//           taxType = "None";
//         }
//
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var countryID = prefs.getString('Country') ?? 1;
//         var stateID = prefs.getString('State') ?? 1;
//
//         DateTime selectedDateAndTime = DateTime.now();
//         String convertedDate = "$selectedDateAndTime";
//         dateOnly = convertedDate.substring(0, 10);
//         var customerName = "walk in customer";
//         var phoneNumber = "";
//         var time = "";
//         var type = "Dining";
//         if (orderType == 1) {
//           type = "Dining";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//           time = "";
//         } else if (orderType == 2) {
//           type = "TakeAway";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//           //
//           // customerName = "test cust";
//           // phoneNumber = "8714152075";
//           time = "";
//         }
//         // ignore: unrelated_type_equality_checks
//         else if (orderType == 3) {
//           type = "Online";
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//
//           time = "";
//         } else if (orderType == 4) {
//           type = "Car";
//
//           customerName = customerNameController.text;
//           phoneNumber = phoneNumberController.text;
//           time = "";
//         } else {}
//         var pk = orderID;
//         final String url = '$baseUrl/posholds/edit/pos-sales-order/$pk/';
//         print(url);
//         Map data = {
//           "LedgerID": PaymentData.ledgerID,
//           "deleted_data": deletedList,
//           "Table": tableID,
//           "CompanyID": companyID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "Date": dateOnly,
//           "DeliveryDate": dateOnly,
//           "TotalGrossAmt": totalGrossP,
//           "TotalTax": "$totalTaxMP",
//           "NetTotal": "$totalNetP",
//           "GrandTotal": "$totalNetP",
//           "TaxID": taxTypeID,
//           "TaxType": taxType,
//           "VATAmount": "$vatAmountTotalP",
//           "SGSTAmount": "$sGstAmountTotalP",
//           "CGSTAmount": "$cGstAmountTotalP",
//           "IGSTAmount": "$iGstAmountTotalP",
//           "saleOrdersDetails": detailsList,
//           "Country_of_Supply": countryID,
//           "State_of_Supply": stateID,
//           "CustomerName": customerName,
//           "Phone": phoneNumber,
//           "VoucherNo": "",
//           "BillDiscAmt": "0",
//           "BillDiscPercent": "0",
//           "RoundOff": "0",
//           "IsActive": true,
//           "IsInvoiced": "N",
//           "PriceCategoryID": 1,
//           "FinacialYearID": 1,
//           "TAX1Amount": "0",
//           "TAX2Amount": "0",
//           "TAX3Amount": "0",
//           "ShippingCharge": "0",
//           "shipping_tax_amount": "0",
//           "TaxTypeID": "",
//           "SAC": "",
//           "SalesTax": "0",
//           "Address1": "",
//           "Address2": "",
//           "Notes": "",
//           "GST_Treatment": "",
//           "DeliveryTime": "",
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         print(responseJson);
//
//         // if (status == 6000) {
//         //   setState(() {
//         //
//         //
//         //     orderEdit = false;
//         //     phoneNumberController.text = "";
//         //     customerNameController.text = "walk in customer";
//         //     _selectedIndex = 1000;
//         //     orderDetTable.clear();
//         //     order = 1;
//         //     productList.clear();
//         //     getCategoryListDetail();
//         //     getTableOrderList();
//         //     stop();
//         //     dialogBox(context, "Sale orders updated successfully!!!");
//         //     mainPageIndex = 1;
//         //
//         //     backToDining();
//         //
//         //     Future.delayed(Duration(seconds: 1), () async {
//         //       var id = n["OrderID"];
//         //       //
//         //
//         //       // SharedPreferences prefs = await SharedPreferences.getInstance();
//         //       // var selectedPrinter = prefs.getString('printer') ?? '';
//         //       // //   var ip = prefs.get("defaultIP") ??"";
//         //       // var kot = prefs.getBool("KOT") ?? false;
//         //
//         //       // if (kot == true) {
//         //       //   if (selectedPrinter == 'WT') {
//         //       //     await printOrder(id);
//         //       //     Navigator.pop(context, true);
//         //       //   }
//         //       //
//         //       //   else if (selectedPrinter == 'BT') {
//         //       //
//         //       //     BluetoothKOT.id = id;
//         //       //     Navigator.of(context).pushReplacement(
//         //       //         new MaterialPageRoute(builder: (BuildContext context) {
//         //       //           return KotPrintScreen();
//         //       //         }));
//         //       //   }
//         //       //
//         //       //   else {
//         //       //     print("------kot--------");
//         //       //     print(kot);
//         //       //     Navigator.pop(context, true);
//         //       //   }
//         //       // }
//         //
//         //       // else {
//         //       //   print("------kot--------");
//         //       //   print(kot);
//         //       //   Navigator.pop(context, true);
//         //       // }
//         //     });
//         //   });
//         // }
//
//         if (status == 6000) {
//           setState(() {
//             phoneNumberController.text = "";
//             customerNameController.text = "walk in customer";
//             _selectedIndex = 1000;
//             orderDetTable.clear();
//             parsingJson.clear();
//             order = 1;
//             productList.clear();
//             getCategoryListDetail();
//             getTableOrderList();
//             //  netWorkProblem = true;
//             stop();
//             dialogBox(context, 'Order updated successfully !!!');
//             totalAmount();
//
//             Future.delayed(const Duration(seconds: 1), () async {
//               backToDining();
//               var id = n["OrderID"];
//
//               print("-------id-------");
//               print(id);
//               print("-------id-------");
//
//               /// kot section
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               // var ip = prefs.get("defaultIP") ??"";
//               var kot = prefs.getBool("KOT") ?? false;
//
//               if (kot == true) {
//                 PrintDataDetails.type = "SO";
//                 PrintDataDetails.id = id;
//                 printKOT(id);
//
//                 //await printOrder(id);
//                 //  Navigator.pop(context, true);
//                 print("-------kot-------");
//                 print(kot);
//               } else {
//                 print("------kot--------");
//                 print(kot);
//               }
//             });
//           });
//         } else if (status == 6001) {
//           stop();
//           // netWorkProblem = true;
//           var errorMessage = n["message"];
//           dialogBox(context, errorMessage);
//         }
//
//         //DB Error
//         else {
//           dialogBox(context, "Some network error");
//
//           stop();
//         }
//       } catch (e) {
//         setState(() {
//           dialogBox(context, "Some network error");
//           stop();
//         });
//       }
//     }
//   }
//
//   Widget bottomNextPageList() {
//     return Container(
//       height: MediaQuery.of(context).size.height / 9, //height of button
//       width: MediaQuery.of(context).size.width / 1.7,
//       child: Padding(
//         padding: const EdgeInsets.only(left: 10, right: 10),
//         child: Row(
//           children: [
//             Container(
//               decoration: const BoxDecoration(color: Color(0xff172026), borderRadius: BorderRadius.all(Radius.circular(5))),
//               padding: const EdgeInsets.all(10),
//               height: MediaQuery.of(context).size.height / 11,
//               //height of button
//               width: MediaQuery.of(context).size.width / 25,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: SvgPicture.asset('assets/svg/arrowback.svg'),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(6),
//               height: MediaQuery.of(context).size.height / 1.5, //height of button
//               width: MediaQuery.of(context).size.width / 2.19,
//
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: pageButton1),
//                       child: Text(
//                         '1',
//                         style: TextStyle(fontSize: 12, color: buttonText1),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           pageButton1 = Colors.black;
//                           pageButton2 = Colors.white;
//                           pageButton3 = Colors.white;
//                           pageButton4 = Colors.white;
//                           buttonText1 = Colors.white;
//                           buttonText2 = Colors.black;
//                           buttonText3 = Colors.black;
//                           buttonText4 = Colors.black;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: pageButton2),
//                       child: Text(
//                         '2',
//                         style: TextStyle(fontSize: 12, color: buttonText2),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           pageButton1 = Colors.white;
//                           pageButton2 = Colors.black;
//                           pageButton3 = Colors.white;
//                           pageButton4 = Colors.white;
//                           buttonText1 = Colors.black;
//                           buttonText2 = Colors.white;
//                           buttonText3 = Colors.black;
//                           buttonText4 = Colors.black;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: pageButton3),
//                       child: Text(
//                         '3',
//                         style: TextStyle(fontSize: 12, color: buttonText3),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           pageButton1 = Colors.white;
//                           pageButton2 = Colors.white;
//                           pageButton3 = Colors.black;
//                           pageButton4 = Colors.white;
//                           buttonText1 = Colors.black;
//                           buttonText2 = Colors.black;
//                           buttonText3 = Colors.white;
//                           buttonText4 = Colors.black;
//                         });
//                       },
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height / 20, //height of button
//                     width: MediaQuery.of(context).size.width / 20,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(shape: const CircleBorder(), primary: pageButton4),
//                       child: Text(
//                         '4',
//                         style: TextStyle(fontSize: 12, color: buttonText4),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           pageButton1 = Colors.white;
//                           pageButton2 = Colors.white;
//                           pageButton3 = Colors.white;
//                           pageButton4 = Colors.black;
//                           buttonText1 = Colors.black;
//                           buttonText2 = Colors.black;
//                           buttonText3 = Colors.black;
//                           buttonText4 = Colors.white;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               decoration: const BoxDecoration(color: Color(0xff172026), borderRadius: BorderRadius.all(Radius.circular(5))),
//               padding: const EdgeInsets.all(10),
//               height: MediaQuery.of(context).size.height / 11,
//               //height of button
//               width: MediaQuery.of(context).size.width / 25,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: SvgPicture.asset('assets/svg/arrowforward.svg'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget orderTypeDetailScreen() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: borderColor1,
//               width: 1,
//             ),
//             borderRadius: const BorderRadius.all(
//               Radius.circular(10),
//             ),
//             color: color1,
//           ),
//           child: IconButton(
//             onPressed: () {
//               setState(() {
//                 cashReceivedController.text = '0.00';
//                 bankReceivedController.text = '0.00';
//                 discountAmountController.text = '0.00';
//                 discountPerController.text = '0.00';
//
//                 color1 = Colors.white;
//                 color2 = const Color(0xffF8F8F8);
//                 color3 = const Color(0xffF8F8F8);
//                 color4 = const Color(0xffF8F8F8);
//                 borderColor1 = Colors.black;
//                 borderColor2 = Colors.transparent;
//                 borderColor3 = Colors.transparent;
//                 borderColor4 = Colors.transparent;
//                 mainPageIndex = 1;
//               });
//             },
//             icon: SvgPicture.asset(
//               'assets/svg/dining.svg',
//             ),
//           ),
//         ),
//         const SizedBox(height: 3),
//         Text(
//           'Dining',
//           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//         ),
//         const SizedBox(
//           height: 6,
//         ),
//         Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: borderColor2,
//                 width: 1,
//               ),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               color: color2,
//             ),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   cashReceivedController.text = '0.00';
//                   bankReceivedController.text = '0.00';
//                   discountAmountController.text = '0.00';
//                   discountPerController.text = '0.00';
//                   color1 = const Color(0xffF8F8F8);
//                   color2 = Colors.white;
//                   color3 = const Color(0xffF8F8F8);
//                   color4 = const Color(0xffF8F8F8);
//                   borderColor2 = Colors.black;
//                   borderColor1 = Colors.transparent;
//                   borderColor3 = Colors.transparent;
//                   borderColor4 = Colors.transparent;
//                   mainPageIndex = 2;
//                 });
//               },
//               icon: SvgPicture.asset('assets/svg/takeaway.svg'),
//             )),
//         const SizedBox(height: 3),
//         Text(
//           'Take Away',
//           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//         ),
//         const SizedBox(
//           height: 6,
//         ),
//         Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: borderColor3,
//                 width: 1,
//               ),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               color: color3,
//             ),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   cashReceivedController.text = '0.00';
//                   discountAmountController.text = '0.00';
//                   discountPerController.text = '0.00';
//                   bankReceivedController.text = '0.00';
//                   color1 = const Color(0xffF8F8F8);
//                   color2 = const Color(0xffF8F8F8);
//                   color3 = Colors.white;
//                   color4 = const Color(0xffF8F8F8);
//                   borderColor2 = Colors.transparent;
//                   borderColor1 = Colors.transparent;
//                   borderColor3 = Colors.black;
//                   borderColor4 = Colors.transparent;
//                   mainPageIndex = 3;
//                 });
//               },
//               icon: SvgPicture.asset('assets/svg/online.svg'),
//             )),
//         const SizedBox(height: 3),
//         Text(
//           'Online',
//           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//         ),
//         const SizedBox(
//           height: 6,
//         ),
//         Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: borderColor4,
//                 width: 1,
//               ),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(10),
//               ),
//               color: color4,
//             ),
//             child: IconButton(
//               onPressed: () {
//                 setState(() {
//                   cashReceivedController.text = '0.00';
//                   discountAmountController.text = '0.00';
//                   discountPerController.text = '0.00';
//                   bankReceivedController.text = '0.00';
//
//                   color1 = const Color(0xffF8F8F8);
//                   color2 = const Color(0xffF8F8F8);
//                   color4 = Colors.white;
//                   color3 = const Color(0xffF8F8F8);
//                   borderColor2 = Colors.transparent;
//                   borderColor1 = Colors.transparent;
//                   borderColor3 = Colors.transparent;
//                   borderColor4 = Colors.black;
//                   mainPageIndex = 4;
//                 });
//               },
//               icon: SvgPicture.asset('assets/svg/car.svg'),
//             )),
//         const SizedBox(height: 3),
//         Text(
//           'Car',
//           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
//         ),
//       ],
//     );
//   }
//
//   showAlert() {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return Expanded(
//           child: AlertDialog(
//             actions: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Name'),
//                   const SizedBox(
//                     height: 4,
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(12),
//                       isDense: true,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   const Text('Phone'),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   const TextField(
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.all(12),
//                       isDense: true,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//
//                   // const Text('Location'),
//                   // const SizedBox(
//                   //   height: 5,
//                   // ),
//                   // const TextField(
//                   //   decoration: InputDecoration(
//                   //     contentPadding: EdgeInsets.all(12),
//                   //     isDense: true,
//                   //     border: OutlineInputBorder(),
//                   //   ),
//                   // ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       //   SizedBox(
//                       //     height: MediaQuery.of(context).size.height /
//                       //         20, //height of button
//                       // //    width: MediaQuery.of(context).size.width / 8,
//                       //     child: TextButton(
//                       //         style: TextButton.styleFrom(
//                       //           padding: const EdgeInsets.all(15.0),
//                       //           primary: Colors.white,
//                       //           backgroundColor: const Color(0xffFF0000),
//                       //           textStyle: const TextStyle(
//                       //               fontSize: 12, fontWeight: FontWeight.w500),
//                       //         ),
//                       //         onPressed: () {},
//                       //         child: const Text('Cancel')),
//                       //   ),
//
//                       SizedBox(
//                         // height: MediaQuery.of(context).size.height / 20, //height of button
//                         // width: MediaQuery.of(context).size.width / 8,
//                         child: TextButton(
//                             style: TextButton.styleFrom(
//                               padding: const EdgeInsets.all(15.0),
//                               primary: Colors.white,
//                               backgroundColor: const Color(0xff12AA07),
//                               textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                             ),
//                             onPressed: () {},
//                             child: const Text('Save')),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Future<void> displayLoyaltyListBox(BuildContext context) async {
//     return showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Color(0xffffffff),
//             content: Container(
//                 width: MediaQuery.of(context).size.width / 3.7,
//                 height: MediaQuery.of(context).size.height / 2.1,
//                 child: ListView(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(3.0),
//                       child: Container(
//                           //    width: MediaQuery.of(context).size.width / 5,
//                           height: MediaQuery.of(context).size.height / 18,
//                           child: Text(
//                             'Loyalty Customer',
//                             style: TextStyle(fontSize: 20),
//                           )),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: MediaQuery.of(context).size.width / 7,
//                           child: const Text(
//                             "Phone",
//                             style: TextStyle(fontSize: 15),
//                           ),
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width / 3.5,
//                           child: Padding(
//                             padding: const EdgeInsets.only(bottom: 10),
//                             child: TextField(
//                               onChanged: (text) {
//                                 setState(() {
//                                   charLength = text.length;
//
//                                   _searchLoyaltyCustomer(text);
//                                 });
//                               },
//                               controller: loyaltyPhoneNumber,
//                               focusNode: loyaltyPhoneFcNode,
//                               keyboardType: TextInputType.text,
//                               textCapitalization: TextCapitalization.words,
//                               decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                     onPressed: () {
//                                       loyaltyPhoneNumber.clear();
//                                       loyaltyCustLists.clear();
//                                       pageNumber = 1;
//                                       firstTime = 1;
//                                       getLoyaltyCustomer();
//                                     },
//                                     icon: Icon(
//                                       Icons.clear,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                                   focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                                   disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//                                   contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//                                   filled: true,
//                                   hintStyle: const TextStyle(color: Color(0xff000000), fontSize: 14),
//                                   hintText: 'Search',
//                                   fillColor: const Color(0xffffffff)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                         // color: Color(0xffF5F5F5),
//
//                         height: MediaQuery.of(context).size.height / 3,
//                         child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: loyaltyCustLists.length,
//                             itemBuilder: (BuildContext context, int index) {
//                               return Card(
//                                 color: Color(0xffF5F5F5),
//                                 child: ListTile(
//                                     onTap: () {
//                                       PaymentData.loyaltyCustomerID = loyaltyCustLists[index].loyaltyCustomerID;
//                                       Navigator.pop(context);
//
//                                       /// 123123      PaymentData.ledgerID=  loyaltyCustLists[index].
//                                     },
//                                     tileColor: Color(0xffF5F5F5),
//                                     trailing: Icon(Icons.circle_rounded, color: Color(0xff008015)),
//                                     title: Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Name',
//                                               style: TextStyle(color: Color(0xff777777), fontSize: 10),
//                                             ),
//                                             Text(
//                                               loyaltyCustLists[index].customerName,
//                                               style: TextStyle(fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 5,
//                                         ),
//                                         Column(
//                                           mainAxisAlignment: MainAxisAlignment.start,
//                                           crossAxisAlignment: CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               'Phone',
//                                               style: TextStyle(color: Color(0xff777777), fontSize: 10),
//                                             ),
//                                             Text(
//                                               loyaltyCustLists[index].phone,
//                                               style: TextStyle(fontSize: 12),
//                                             ),
//                                           ],
//                                         ),
//                                         // Text(taxLists[index].type),
//                                       ],
//                                     )),
//                               );
//                             })),
//
//                     /// hide button cancel and done
//                     Container(
//                       height: MediaQuery.of(context).size.height / 16,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height / 17,
//                             width: MediaQuery.of(context).size.width / 8,
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 primary: const Color(0xffFF0000),
//                               ),
//                               child: const Text(
//                                 'Cancel',
//                                 style: TextStyle(color: Color(0xffFFFFFF)),
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.height / 17,
//                             width: MediaQuery.of(context).size.width / 8,
//                             child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   primary: const Color(0xff12AA07),
//                                 ),
//                                 child: const Text(
//                                   'Done',
//                                   style: TextStyle(color: Color(0xffFFFFFF)),
//                                 ),
//                                 onPressed: () {}),
//                           )
//                         ],
//                       ),
//                     )
//                   ],
//                 )),
//           );
//         });
//   }
//
//   ///list loylty customer
//
//   ///loyalty create alert box
//   Future<void> displayLoyalityAlertBox(BuildContext context) async {
//     return showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               backgroundColor: Color(0xffEAF0F1),
//               content: Container(
//                   width: MediaQuery.of(context).size.width / 3.7,
//                   height: MediaQuery.of(context).size.height / 1.2,
//                   child: ListView(
//                     children: [
//                       loyaltyNameField(),
//
//                       /// commented customer selection (waiting api changes)
//                       // Column(
//                       //   crossAxisAlignment: CrossAxisAlignment.start,
//                       //   children: [
//                       //     Container(
//                       //       width: MediaQuery.of(context).size.width / 7,
//                       //       child: const Text(
//                       //         "Customer:",
//                       //         style: TextStyle(fontSize: 15),
//                       //       ),
//                       //     ),
//                       //     Container(
//                       //       width: MediaQuery.of(context).size.width / 3.5,
//                       //       child: Padding(
//                       //         padding: const EdgeInsets.only(bottom: 10),
//                       //         child: TextField(
//                       //           readOnly: true,
//                       //           onTap: () async {
//                       //
//                       //             var result = await Navigator.push(
//                       //               context,
//                       //               MaterialPageRoute(
//                       //                   builder: (context) => SelectCustomer()),
//                       //             );
//                       //
//                       //             print(result);
//                       //
//                       //             if (result != null) {
//                       //               setState(() {
//                       //                 loyaltyCustomerNameController.text =
//                       //                     result;
//                       //               });
//                       //             } else {}
//                       //           },
//                       //           controller: loyaltyCustomerNameController,
//                       //           //  focusNode: customerFcNode,
//                       //           onEditingComplete: () {
//                       //             FocusScope.of(context)
//                       //                 .requestFocus(phoneFcNode);
//                       //           },
//                       //           keyboardType: TextInputType.text,
//                       //           textCapitalization: TextCapitalization.words,
//                       //           decoration:
//                       //               TextFieldDecoration.rectangleTextField(
//                       //                   hintTextStr: ''),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       loyaltyPhoneNumberField(),
//                       loyaltyLocationField(),
//                       loyaltyCardTypeField(),
//                       loyaltyCardNumberField(),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 15, top: 10),
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 15),
//                               child: Text('Status'),
//                             ),
//                             FlutterSwitch(
//                               width: 40.0,
//
//                               height: 20.0,
//
//                               valueFontSize: 30.0,
//
//                               toggleSize: 15.0,
//
//                               value: loyaltyStatus,
//
//                               borderRadius: 20.0,
//
//                               padding: 1.0,
//
//                               activeColor: const Color(0xff009253),
//
//                               inactiveToggleColor: const Color(0xff606060),
//
//                               inactiveColor: const Color(0xffDEDEDE),
//
//                               // showOnOff: true,
//
//                               onToggle: (val) {
//                                 setState(() {
//                                   loyaltyStatus = val;
//                                 });
//                               },
//                             )
//                           ],
//                         ),
//                       ),
//                       loyaltyCancelAndSaveButton()
//                     ],
//                   )),
//             );
//           });
//         });
//   }
//
//   Widget loyaltyNameField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width / 7,
//           child: const Text(
//             "Name:",
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width / 3.5,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: TextField(
//               controller: nameController,
//               focusNode: nameFcNode,
//               onEditingComplete: () {
//                 FocusScope.of(context).requestFocus(phoneFcNode);
//               },
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.words,
//               decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget loyaltyPhoneNumberField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width / 7,
//           child: const Text(
//             "Phone:",
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width / 3.5,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: TextField(
//               controller: loyaltyPhoneController,
//               focusNode: phoneFcNode,
//               onEditingComplete: () {
//                 FocusScope.of(context).requestFocus(locationFcNode);
//               },
//               keyboardType: TextInputType.number,
//               textCapitalization: TextCapitalization.words,
//               decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget loyaltyLocationField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width / 7,
//           child: const Text(
//             "Location:",
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width / 3.5,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: TextField(
//               controller: loyaltyLocationController,
//               focusNode: locationFcNode,
//               onEditingComplete: () {
//                 FocusScope.of(context).requestFocus(cardTypeFcNode);
//               },
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.words,
//               decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget loyaltyCardTypeField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width / 7,
//           child: const Text(
//             "Card Type:",
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width / 3.5,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: TextField(
//               readOnly: true,
//               onTap: () async {
//                 var result = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SelectCardType()),
//                 );
//
//                 print(result);
//
//                 if (result != null) {
//                   setState(() {
//                     loyltyCardTypeController.text = result;
//                   });
//                 } else {}
//               },
//               controller: loyltyCardTypeController,
//               focusNode: cardTypeFcNode,
//               onEditingComplete: () {
//                 FocusScope.of(context).requestFocus(cardNoFcNode);
//               },
//               keyboardType: TextInputType.text,
//               textCapitalization: TextCapitalization.words,
//               decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget loyaltyCardNumberField() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width / 7,
//           child: const Text(
//             "Card No:",
//             style: TextStyle(fontSize: 15),
//           ),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width / 3.5,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: TextField(
//               controller: loyaltyCardNumberController,
//               focusNode: cardNoFcNode,
//               onEditingComplete: () {
//                 FocusScope.of(context).requestFocus(saveFcNode);
//               },
//               keyboardType: TextInputType.number,
//               textCapitalization: TextCapitalization.words,
//               decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget loyaltyCancelAndSaveButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height / 18,
//           width: MediaQuery.of(context).size.width / 8,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               primary: const Color(0xffFF0000),
//             ),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: Color(0xffFFFFFF)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ),
//         SizedBox(
//           height: MediaQuery.of(context).size.height / 18,
//           width: MediaQuery.of(context).size.width / 8,
//           child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 primary: const Color(0xff12AA07),
//               ),
//               child: const Text(
//                 'Save',
//                 style: TextStyle(color: Color(0xffFFFFFF)),
//               ),
//               onPressed: () {
//                 if (nameController.text == '' || loyaltyPhoneController.text == '') {
//                   dialogBox(context, 'Please fill mandatory field');
//                 } else {
//                   createLoyaltyCustomer();
//                 }
//               }),
//         )
//       ],
//     );
//   }
//
//   ///Api for create loyalty
//   Future<Null> createLoyaltyCustomer() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//       });
//     } else {
//       try {
//         start(context);
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         String baseUrl = BaseUrl.baseUrl;
//
//         final String url = '$baseUrl/posholds/rassassy/create_loyality_customer/';
//         String loyaltyType = "";
//         loyaltyStatus == true ? loyaltyType = "true" : loyaltyType = "false";
//         print(loyaltyType);
//         print('1111111111111111');
//         print(url);
//
//         ///card type,stats,status name
//         Map data = {
//           "CompanyID": companyID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "Phone": loyaltyPhoneController.text,
//           "Name": nameController.text,
//           "Location": loyaltyLocationController.text,
//           "CardTypeName": loyltyCardTypeController.text,
//           "CardNumber": loyaltyCardNumberController.text,
//           "CardTypeID": "",
//           "CardStatusID": "",
//           "CardStatusName": loyaltyType
//         };
//         print(data);
//
//         //encode Map to JSON
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
//           setState(() {
//             getLoyaltyCustomer();
//
//             loyltyCardTypeController.clear();
//             loyaltyCardNumberController.clear();
//             nameController.clear();
//             loyaltyPhoneController.clear();
//             loyaltyLocationController.clear();
//             stop();
//             isAddLoyalty = false;
//
//             Navigator.pop(context);
//             // getLoyaltyCustomer();
//           });
//         } else if (status == 6001) {
//           stop();
//         } else {}
//       } catch (e) {
//         setState(() {
//           dialogBox(context, "Some thing went wrong");
//           stop();
//         });
//       }
//     }
//   }
//
//   ///list loyalty customer
//   Future<Null> getLoyaltyCustomer() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//       });
//     } else {
//       try {
//         String baseUrl = BaseUrl.baseUrl;
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         final String url = '$baseUrl/posholds/rassassy/list_loyality_customer/';
//
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "CreatedUserID": userID,
//         };
//
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         print(response.body);
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         if (status == 6000) {
//           setState(() {
//             loyaltyCustLists.clear();
//
//             stop();
//             for (Map user in responseJson) {
//               loyaltyCustLists.add(LoyaltyCustomerModel.fromJson(user));
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         setState(() {
//           stop();
//         });
//       }
//     }
//   }
//
//   ///search customer
//
//   Future _searchLoyaltyCustomer(string) async {
//     if (string == '') {
//       pageNumber = 1;
//       loyaltyCustLists.clear();
//       firstTime = 1;
//       getLoyaltyCustomer();
//     } else if (string.length > 2) {
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult == ConnectivityResult.none) {
//         dialogBox(context, "Unable to connect. Please Check Internet Connection");
//       } else {
//         try {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           var userID = prefs.getInt('user_id') ?? 0;
//           var accessToken = prefs.getString('access') ?? '';
//           var companyID = prefs.getString('companyID') ?? 0;
//           var branchID = prefs.getInt('branchID') ?? 1;
//
//           Map data = {
//             "SearchVal": loyaltyPhoneNumber.text,
//             "CompanyID": companyID,
//             "BranchID": branchID,
//           };
//           String baseUrl = BaseUrl.baseUrl;
//           final String url = "$baseUrl/posholds/rassassy/search_loyality_customer/";
//           print(data);
//           var body = json.encode(data);
//           var response = await http.post(Uri.parse(url),
//               headers: {
//                 "Content-Type": "application/json",
//                 'Authorization': 'Bearer $accessToken',
//               },
//               body: body);
//           print("${response.statusCode}");
//           print("${response.body}");
//           Map n = json.decode(utf8.decode(response.bodyBytes));
//           var status = n["StatusCode"];
//           var responseJson = n["data"];
//           print(responseJson);
//           if (status == 6000) {
//             loyaltyCustLists.clear();
//
//             setState(() {
//               netWorkProblem = true;
//               loyaltyCustLists.clear();
//               isLoading = false;
//             });
//
//             setState(() {
//               for (Map user in responseJson) {
//                 loyaltyCustLists.add(LoyaltyCustomerModel.fromJson(user));
//               }
//             });
//           } else if (status == 6001) {
//             setState(() {
//               netWorkProblem = true;
//               isLoading = false;
//             });
//
//             dialogBox(context, "");
//           } else {
//             dialogBox(context, "Some Network Error please try again Later");
//           }
//         } catch (e) {
//           setState(() {
//             netWorkProblem = false;
//             isLoading = false;
//           });
//
//           print(e);
//         }
//       }
//
//       /// call function
//       return;
//     } else {}
//   }
//
//   /// commented flavour create option
// //   Future<void> _createFlavour(BuildContext context) async {
// //     return showDialog(
// //         barrierDismissible: true,
// //         context: context,
// //         builder: (context) {
// //           return AlertDialog(
// //             backgroundColor: Color(0xffEAF0F1),
// //             content: Container(
// //               height: MediaQuery.of(context).size.height / 12,
// //               decoration: BoxDecoration(
// //                   color: Color(0xffEAF0F1),
// //                   border: Border.all(
// //                     color: Color(0xffEAF0F1),
// //                   ),
// //                   borderRadius: BorderRadius.all(Radius.circular(1))),
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Padding(
// //                     padding: const EdgeInsets.all(3.0),
// //                     child: Container(
// //                         //    width: MediaQuery.of(context).size.width / 5,
// //                         //  height: MediaQuery.of(context).size.height / 18,
// //                         child: TextField(
// //                       //  textAlignVertical: TextAlignVertical.center,
// //                       controller: flavourNameController,
// //                       focusNode: nameNode,
// //                       onEditingComplete: () {
// //                         FocusScope.of(context).requestFocus(phoneNode);
// //                       },
// //                       style: const TextStyle(
// //                           fontSize: 12, color: Color(0xff000000)),
// //                       decoration: CommonStyleTextField.textFieldStyle(
// //                           labelTextStr: "Flavour name",
// //                           hintTextStr: "Flavour name"),
// //                     )),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             actions: <Widget>[
// //               TextButton(
// //                 focusNode: okAlertButton,
// //                 onPressed: () {
// //                   if (flavourNameController.text == "") {
// //                     Navigator.pop(context);
// //                     dialogBox(context, "Please enter flavour");
// //                   } else {
// //                     createFlavourApi();
// //                     Navigator.pop(context);
// //                   }
// //                 },
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: const [
// //                     Text(
// //                       'Save',
// //                     ),
// //                   ],
// //                 ),
// //                 style: TextButton.styleFrom(
// //                     primary: Colors.white,
// //                     backgroundColor: const Color(0xff10c103),
// //                     textStyle: const TextStyle(
// //                         fontSize: 14, fontWeight: FontWeight.bold)),
// //               )
// //             ],
// //           );
// //         });
// //   }
//
//   Future<Null> getAllFlavours() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         stop();
//       });
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? "0";
//         var userID = prefs.getInt('user_id') ?? 0;
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/flavours/flavours/';
//         print(url);
//         Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID};
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         print(responseJson);
//         print(status);
//         if (status == 6000) {
//           setState(() {
//             flavourList.clear();
//             stop();
//             for (Map user in responseJson) {
//               flavourList.add(FlavourListModel.fromJson(user));
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//           var msg = n["error"];
//           dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         setState(() {
//           stop();
//         });
//       }
//     }
//   }
//
//   Future<Null> getCategoryListDetail() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/pos/product-group/list/';
//         print(accessToken);
//         print(url);
//         Map data = {"CompanyID": companyID, "BranchID": branchID};
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         print(responseJson);
//         print(status);
//         if (status == 6000) {
//           setState(() {
//             categoryList.clear();
//             stop();
//
//             for (Map user in responseJson) {
//               categoryList.add(CategoryListModel.fromJson(user));
//             }
//
//             if (resetToken) {
//               tokenNumber = "001";
//               resetToken = false;
//             } else {
//               tokenNumber = n["TokenNumber"];
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//           var msg = n["error"];
//           dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         print("${e.toString()}");
//         stop();
//       }
//     }
//   }
//
//   Future<Null> getProductListDetails(groupId) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//         stop();
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? '';
//         var branchID = BaseUrl.branchID;
//         var priceRounding = BaseUrl.priceRounding;
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/pos-product-list/';
//         print(url);
//         var type = "";
//         if (veg) {
//           type = "veg";
//         }
//
//         Map data = {"CompanyID": companyID, "BranchID": branchID, "GroupID": groupId, "type": type, "PriceRounding": priceRounding};
//         print(data);
//         var body = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         print(response.body);
//         print(accessToken);
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//         print(status);
//         print(responseJson);
//         if (status == 6000) {
//           setState(() {
//             stop();
//
//             for (Map user in responseJson) {
//               productList.add(ProductListModelDetail.fromJson(user));
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//           var msg = n["message"];
//           dialogBox(context, msg);
//         } else {
//           stop();
//         }
//       } catch (e) {
//         print(e.toString());
//         stop();
//       }
//     }
//   }
//
//   Future _searchData(String string) async {
//     if (string == '') {
//       setState(() {
//         productList.clear();
//       });
//     } else {
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult == ConnectivityResult.none) {
//         dialogBox(context, "Unable To Connect Please Check Internet Connection");
//       } else {
//         try {
//           HttpOverrides.global = new MyHttpOverrides();
//           productList.clear();
//           String baseUrl = BaseUrl.baseUrl;
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           var companyID = prefs.getString('companyID') ?? '';
//           var branchID = BaseUrl.branchID;
//           var priceRounding = BaseUrl.priceRounding;
//           var userID = prefs.getInt('user_id') ?? 0;
//           var accessToken = prefs.getString('access') ?? '';
//           final String url = '$baseUrl/posholds/products-search-pos/';
//           print(url);
//           var type = "";
//           if (veg) {
//             type = "veg";
//           }
//           Map data = {
//             "IsCode": productSearchNotifier.value == 1 ? true : false,
//             "IsDescription": productSearchNotifier.value == 3 ? true : false,
//             "BranchID": branchID,
//             "CompanyID": companyID,
//             "CreatedUserID": userID,
//             "PriceRounding": priceRounding,
//             "product_name": string,
//             "length": string.length,
//             "type": type,
//           };
//           print(url);
//           print(data);
//           var body = json.encode(data);
//           var response = await http.post(Uri.parse(url),
//               headers: {
//                 "Content-Type": "application/json",
//                 'Authorization': 'Bearer $accessToken',
//               },
//               body: body);
//           print("${response.statusCode}");
//           print("${response.body}");
//           Map n = json.decode(utf8.decode(response.bodyBytes));
//           var status = n["StatusCode"];
//           var responseJson = n["data"];
//
//           print(responseJson);
//           if (status == 6000) {
//             productList.clear();
//
//             setState(() {
//               stop();
//
//               for (Map user in responseJson) {
//                 productList.add(ProductListModelDetail.fromJson(user));
//               }
//             });
//           } else if (status == 6001) {
//             stop();
//           } else {}
//         } catch (e) {
//           print(e);
//         }
//       }
//
//       /// call function
//       return;
//     }
//   }
//
//   Future<Null> getTableOrderList() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? 0;
//
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/pos-table-list/';
//         print(accessToken);
//         print(url);
//         Map data = {"CompanyID": companyID, "BranchID": branchID, "type": "user", "paid": true};
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//
//         var status = n["StatusCode"];
//         var statusTable = n["DiningStatusCode"];
//         var statusTakeAway = n["TakeAwayStatusCode"];
//         var onlineStatus = n["OnlineStatusCode"];
//         var carStatus = n["CarStatusCode"];
//         var takeAway = n["TakeAway"];
//         var online = n["Online"];
//         var car = n["Car"];
//         var responseJson = n["data"];
//         var cancelData = n["Reasons"];
//         var takeawayStatus = n["TakeAwayStatusCode"];
//
//         var Online = n["Online"];
//         var TakeAway = n["TakeAway"];
//         var Car = n["Car"];
//
//         if (status == 6000) {
//           ///  check expiry date
//           // var expiryDate = prefs.getString('expDate') ?? '';
//           // print("=============+++++++++++++++============");
//           // var dt = DateTime.parse(expiryDate);
//           // print(dt);
//           // print("=============+++++++++++++++============");
//           //
//           // var now = new DateTime.now();
//           // print("__________________now");
//           // print(now);
//           // print("__________________dt");
//           // print(dt);
//           //
//
//           diningOrderList.clear();
//           takeAwayOrderLists.clear();
//           carOrderLists.clear();
//           onlineOrderLists.clear();
//           cancelReportList.clear();
//
//           setState(() {
//             currency = prefs.getString('CurrencySymbol') ?? "";
//             stop();
//             if (statusTable == 6000) {
//               for (Map user in responseJson) {
//                 diningOrderList.add(DiningListModel.fromJson(user));
//               }
//             }
//             // onlineList
//             if (statusTakeAway == 6000) {
//               for (Map user in takeAway) {
//                 takeAwayOrderLists.add(PosListModel.fromJson(user));
//               }
//             }
//
//             if (onlineStatus == 6000) {
//               for (Map user in online) {
//                 onlineOrderLists.add(PosListModel.fromJson(user));
//               }
//             }
//
//             if (carStatus == 6000) {
//               for (Map user in car) {
//                 carOrderLists.add(PosListModel.fromJson(user));
//               }
//             }
//
//             for (Map user in cancelData) {
//               cancelReportList.add(CancelReportModel.fromJson(user));
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//           var msg = n["message"];
//           dialogBox(context, msg);
//         }
//         //DB Error
//         else {
//           stop();
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   Future<Null> getCancelOrder() async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var companyID = prefs.getString('companyID') ?? '';
//         var branchID = BaseUrl.branchID;
//
//         var accessToken = prefs.getString('access') ?? '';
//         final String url = '$baseUrl/posholds/pos-table-list/';
//         print(url);
//         print(accessToken);
//         Map data = {"CompanyID": companyID, "BranchID": branchID, "type": "user", "paid": true};
//
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
//         var responseJson = n["data"];
//         print(responseJson);
//         if (status == 6000) {
//           setState(() {
//             stop();
//
//             for (Map user in responseJson) {
//               cancelReportList.add(CancelReportModel.fromJson(user));
//             }
//           });
//         } else if (status == 6001) {
//           stop();
//           var msg = n["message"];
//           dialogBox(context, msg);
//         } else {
//           stop();
//         }
//       } catch (e) {
//         stop();
//       }
//     }
//   }
//
//   /// payment
//
//   // double roundDoubleDefaultString(String val) {
//   //   var value = double.parse(val);
//   //   var places = 2;
//   //   num mod = pow(10.0, places);
//   //   return ((value * mod).round().toDouble() / mod);
//   // }
//
//   String roundStringWith(String val) {
//     var decimal = 2;
//     double convertedTodDouble = double.parse(val);
//     var number = convertedTodDouble.toStringAsFixed(decimal);
//     return number;
//   }
//
//   var billDiscPercent = 0.0;
//
//   var salesOrderID;
//   var totalDiscount;
//   var netTotal = "0.00";
//   var grandTotalAmount = "0.00";
//   var totalTaxP = "0.00";
//   var date;
//   var roundOff;
//   var balance = 0.0;
//   var allowCashReceiptMoreSaleAmt = false;
//
//   var disCount = 0.0;
//   var cashReceived = 0.0;
//   var bankReceived = 0.0;
//
//   calculationOnPayment() {
//     var net = double.parse(netTotal);
//     print(net);
//     if (discountAmountController.text == "") {
//       print("1");
//       disCount = 0.0;
//     } else {
//       print("2");
//       disCount = double.parse(discountAmountController.text);
//     }
//     print(disCount);
//     if (cashReceivedController.text == "") {
//       cashReceived = 0.0;
//     } else {
//       cashReceived = double.parse(cashReceivedController.text);
//     }
//
//     if (bankReceivedController.text == "") {
//       bankReceived = 0.0;
//     } else {
//       bankReceived = double.parse(bankReceivedController.text);
//     }
//     setState(() {
//       var gt = (net - disCount).toString();
//       grandTotalAmount = roundStringWith(gt).toString();
//       billDiscPercent = (disCount * 100 / double.parse(grandTotalAmount));
//       balance = (net - disCount) - (cashReceived + bankReceived);
//       //  balanceCalculation();
//     });
//   }
//
//   checkNan(value) {
//     var val = value;
//     if (value.isNaN) {
//       return 0.0;
//     } else {
//       var val2 = val;
//       return val2;
//     }
//   }
//
//   findTaxableAmount() {
//     print("=================Tax Type change Data ================");
//     print(taxType);
//
//     if (itemListPayment.isEmpty) {
//     } else {
//       double totalTaxableAmount = 0.0;
//       double totalNonTaxableAmount = 0.0;
//
//       for (var i = 0; i < itemListPayment.length; i++) {
//         var tax = double.parse(itemListPayment[i].vatAmount);
//         if (tax > 0) {
//           totalTaxableAmount += double.parse(itemListPayment[i].taxableAmount);
//         } else {
//           totalNonTaxableAmount += double.parse(itemListPayment[i].taxableAmount);
//         }
//       }
//
//       var list = [totalTaxableAmount, totalNonTaxableAmount];
//       return list;
//     }
//   }
//
//   findTotalGrossAmount() {
//     if (itemListPayment.isEmpty) {
//     } else {
//       double grossAmount = 0.0;
//
//       for (var i = 0; i < itemListPayment.length; i++) {
//         grossAmount += double.parse(itemListPayment[i].grossAmount);
//       }
//
//       return grossAmount;
//     }
//   }
//
//   getVatChangedDetails(int i, val) async {
//     var net = double.parse(netTotal);
//     //  var totalTax = double.parse(totalTaxP);
//     if (i == 1) {
//       billDiscPercent = double.parse(val);
//       disCount = (net * billDiscPercent / 100);
//       setState(() {
//         var gt = (net - disCount).toString();
//         grandTotalAmount = roundStringWith(gt).toString();
//         discountAmountController.text = roundStringWith(disCount.toString());
//       });
//     }
//
//     if (i == 2) {
//       disCount = double.parse(val);
//       billDiscPercent = (disCount * 100 / net);
//       setState(() {
//         var gt = (net - disCount).toString();
//         grandTotalAmount = roundStringWith(gt).toString();
//         discountPerController.text = roundStringWith(billDiscPercent.toString());
//       });
//     }
//
//     var list = await findTaxableAmount();
//
//     var taxTaxableAmount = (list[0]);
//     var nonTaxTaxableAmount = list[1];
//
//     print("-------------------------------");
//     print(taxTaxableAmount);
//     print(nonTaxTaxableAmount);
//     print(disCount);
//     print("-------------------------------");
//
//     double taxSum = 0.0;
//     if (taxTaxableAmount >= disCount) {
//       var vatTax = (disCount / taxTaxableAmount) * 100;
//
//       vatTax = checkNan(vatTax);
//
//       print("--------------");
//       print(vatTax);
//       print("--------------");
//       for (var i = 0; i < itemListPayment.length; i++) {
//         var txAmt = (double.parse(itemListPayment[i].taxableAmount) * vatTax) / 100;
//         var newTaxable = double.parse(itemListPayment[i].taxableAmount) - txAmt;
//         taxSum += ((newTaxable) * double.parse(itemListPayment[i].vatPer)) / 100;
//       }
//     } else {
//       taxSum = 0.0;
//     }
//
//     double gross = await findTotalGrossAmount();
//     var gt = gross - disCount + taxSum;
//
//     print("+++++++++++++++++++++++++++++++++");
//     print(gross);
//     print("++++++++-++++++++++++++++-++++++++");
//
//     setState(() {
//       totalTaxP = "$taxSum";
//       grandTotalAmount = "$gt";
//       //  balanceCalculation();
//     });
//   }
//
//   // balanceCalculation() {
//   //   var gt = double.parse(grandTotalAmount);
//   //   setState(() {
//   //     balance = gt - cashReceived - bankReceived;
//   //   });
//   // }
//
//   discountCalc(int i, val) {
//     var net = double.parse(netTotal);
//     print(net);
//
//     if (i == 1) {
//       billDiscPercent = double.parse(val);
//       disCount = (net * billDiscPercent / 100);
//       setState(() {
//         var gt = (net - disCount).toString();
//         grandTotalAmount = roundStringWith(gt).toString();
//         discountAmountController.text = roundStringWith(disCount.toString());
//       });
//     }
//
//     if (i == 2) {
//       disCount = double.parse(val);
//       billDiscPercent = (disCount * 100 / net);
//       setState(() {
//         var gt = (net - disCount).toString();
//         grandTotalAmount = roundStringWith(gt).toString();
//         discountPerController.text = roundStringWith(billDiscPercent.toString());
//       });
//     }
//
//     setState(() {
//       balance = (net - disCount) - (cashReceived + bankReceived);
//
//       // balanceCalculation();
//     });
//   }
//
//   checkBank(String value) {
//     print(value);
//     var bankAmount = value;
//     var amount = double.parse(value);
//     var grandT = double.parse(grandTotalAmount);
//
//     if (amount > grandT) {
//       bankReceived = 0.0;
//       bankReceivedController.text = "0";
//       dialogBox(context, "Amount less than grand total");
//       return false;
//     } else {
//       return true;
//     }
//   }
//
//   /// create invoice
//   Future<Null> createSaleInvoice(print_save) async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//         stop();
//     } else {
//       try {
//         start(context);
//         HttpOverrides.global = MyHttpOverrides();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String baseUrl = BaseUrl.baseUrl;
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? "0";
//
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var countryID = prefs.getString('Country') ?? "1";
//         var stateID = prefs.getString('State') ?? "1";
//         var tableVacant = prefs.getBool("tableClearAfterPayment") ?? false;
//
//         DateTime selectedDateAndTime = DateTime.now();
//         String convertedDate = "$selectedDateAndTime";
//         dateOnly = convertedDate.substring(0, 10);
//
//         var loyalty;
//         if (PaymentData.loyaltyCustomerID == 0) {
//           loyalty = null;
//         } else {
//           loyalty = PaymentData.loyaltyCustomerID;
//         }
//
//         // if(orderType == 1){
//         //   tableVacant = prefs.getBool("tableClearAfterPayment") ?? false;
//         // }
//         //
//         // var autoC = prefs.getBool("AutoClear") ?? false;
//         var printAfterPayment = prefs.getBool("printAfterPayment") ?? false;
//
//         var autoC = true;
//
//         var cardNumber = "";
//         if (cardNoController.text == "") {
//           cardNumber = "";
//         } else {
//           cardNumber = cardNoController.text;
//         }
//         final String url = '$baseUrl/posholds/create-pos/salesInvoice/';
//         print(url);
//         Map data = {
//           'LoyaltyCustomerID': loyalty,
//           "table_vacant": tableVacant,
//           "Paid": autoC,
//           "CompanyID": companyID,
//           "Table": tableID,
//           "CreatedUserID": userID,
//           "BranchID": branchID,
//           "LedgerID": PaymentData.ledgerID,
//           "GrandTotal": grandTotalAmount,
//           "BillDiscPercent": "$billDiscPercent",
//           "BidillDiscAmt": "$disCount",
//           "CashReceived": "$cashReceived",
//           "BankAmount": "$bankReceived",
//           "CardTypeID": PaymentData.cardTypeId,
//           "CardNumber": cardNumber,
//           "SalesOrderID": PaymentData.salesOrderID,
//           "TotalDiscount": "$disCount",
//           "Date": dateOnly,
//           "RoundOff": "0.0",
//           "Balance": "$balance",
//           "TotalTax": totalTaxP,
//           "DeliveryManID":deliveryManID,
//           "AllowCashReceiptMoreSaleAmt": false,
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//
//         print(responseJson);
//         if (status == 6000) {
//           stop();
//           cashReceivedController.text = "0.00";
//           bankReceivedController.text = "0.00";
//           discountPerController.text = "0.00";
//           discountAmountController.text = "0.00";
//
//           setState(() {
//
//             if (orderType == 1) {
//               mainPageIndex = 1;
//             } else if (orderType == 2) {
//               mainPageIndex = 2;
//             } else if (orderType == 3) {
//               mainPageIndex = 3;
//             } else if (orderType == 4) {
//               mainPageIndex = 4;
//             }
//
//             getTableOrderList();
//             // netWorkProblem = true;
//             // stop();
//             dialogBox(context, "Sales created successfully!!!");
//
//             Future.delayed(Duration(seconds: 1), () {
//               if (printAfterPayment == true || print_save == true) {
//                 PrintDataDetails.type = "SI";
//                 PrintDataDetails.id = n["invoice_id"];
//                 printDetail();
//               }
//             });
//           });
//         } else if (status == 6001) {
//           stop();
//           // netWorkProblem = true;
//           var errorMessage = n["message"];
//           dialogBox(context,errorMessage);
//           /// alertMessage(errorMessage);
//         }
//         //DB Error
//         else {
//           /// alertMessage("Some Network Error");
//           stop();
//         }
//       } catch (e) {
//
//            dialogBox(context,"Some Network Error");
//           stop();
//
//           /// netWorkProblem = false;
//
//       }
//     }
//   }
//
//   /// card type
//   var cardData = [
//     {
//       "id": "25600c2f-4536-40b1-a44f-fd7d697784c5",
//       "TransactionTypesID": 33,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "None",
//       "Notes": "None",
//       "CreatedDate": "2021-08-14T08:18:27.934595+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true,
//     },
//     {
//       "id": "85c2e2b6-8d0c-441a-90b6-85f5f9db59bb",
//       "TransactionTypesID": 5,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "Discover",
//       "Notes": "Discover",
//       "CreatedDate": "2021-08-14T08:18:27.933462+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true,
//     },
//     {
//       "id": "e2cca64e-89be-4cf8-8840-fe489b0c3a95",
//       "TransactionTypesID": 4,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "American Express",
//       "Notes": "American Express",
//       "CreatedDate": "2021-08-14T08:18:27.932536+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true,
//     },
//     {
//       "id": "b45b8307-e24b-4386-8d01-a95d14378b82",
//       "TransactionTypesID": 3,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "Citibank",
//       "Notes": "Citibank",
//       "CreatedDate": "2021-08-14T08:18:27.931607+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true
//     },
//     {
//       "id": "97d007dc-7f9c-4a6f-83b9-28c19e450e0a",
//       "TransactionTypesID": 2,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "Mastercard",
//       "Notes": "Mastercard",
//       "CreatedDate": "2021-08-14T08:18:27.930380+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true
//     },
//     {
//       "id": "f992d994-852f-45cc-b932-afbe547d628d",
//       "TransactionTypesID": 1,
//       "BranchID": 1,
//       "Action": "A",
//       "MasterTypeID": 1,
//       "MasterTypeName": "Card Network",
//       "Name": "Visa",
//       "Notes": "Visa",
//       "CreatedDate": "2021-08-14T08:18:27.928514+03:00",
//       "UpdatedDate": "2020-06-01T00:00:00+03:00",
//       "CreatedUserID": 1,
//       "IsDefault": true
//     }
//   ];
//
//   Future<Null> loadCard() async {
//     var responseDiningTable = cardData;
//     setState(() {
//       for (Map user in responseDiningTable) {
//         cardList.add(CardDetailsDetails.fromJson(user));
//       }
//     });
//   }
//
//   /// kot section
// }
//
//
//
// class PrintDetails {
//   var items, kitchenName, ip, totalQty;
//
//   PrintDetails({
//     this.kitchenName,
//     this.items,
//     this.ip,
//     this.totalQty,
//   });
//
//   factory PrintDetails.fromJson(Map<dynamic, dynamic> json) {
//     return PrintDetails(
//       items: json['Items'],
//       kitchenName: json['kitchen_name'],
//       ip: json['IPAddress'],
//       totalQty: json['TotalQty'].toString(),
//     );
//   }
// }
// class ItemsDetails {
//   var productName, productDescription, qty, tableName, orderTypeI, tokenNumber, flavour, voucherNo;
//
//   ItemsDetails(
//       {this.productName, this.productDescription, this.qty, this.tableName, this.orderTypeI, this.tokenNumber, this.flavour, this.voucherNo});
//
//   factory ItemsDetails.fromJson(Map<dynamic, dynamic> json) {
//     return ItemsDetails(
//       productName: json['ProductName'],
//       productDescription: json['ProductDescription'],
//       qty: json['Qty'].toString(),
//       tableName: json['TableName'],
//       orderTypeI: json['OrderType'],
//       tokenNumber: json['TokenNumber'],
//       voucherNo: json['VoucherNo'],
//       flavour: json['flavour'] ?? '',
//     );
//   }
// }
// class CardDetailsDetails {
//   final int paymentID;
//   final String paymentNetworkName;
//
//   CardDetailsDetails({required this.paymentID, required this.paymentNetworkName});
//
//   factory CardDetailsDetails.fromJson(Map<dynamic, dynamic> json) {
//     return CardDetailsDetails(
//       paymentID: json['TransactionTypesID'],
//       paymentNetworkName: json['Name'],
//     );
//   }
// }
// class CategoryListModel {
//   final String categoryId, categoryName;
//   final int categoryGroupId;
//
//   CategoryListModel({required this.categoryName, required this.categoryGroupId, required this.categoryId});
//
//   factory CategoryListModel.fromJson(Map<dynamic, dynamic> json) {
//     return CategoryListModel(categoryName: json['GroupName'], categoryGroupId: json['ProductGroupID'], categoryId: json['id']);
//   }
// }
// class FlavourListModel {
//   final String id, flavourName, bgColor;
//   final int flavourID;
//   final bool isActive;
//
//   FlavourListModel({
//     required this.id,
//     required this.flavourID,
//     required this.flavourName,
//     required this.bgColor,
//     required this.isActive,
//   });
//
//   factory FlavourListModel.fromJson(Map<dynamic, dynamic> json) {
//     return FlavourListModel(
//       id: json['id'],
//       flavourID: json['FlavourID'],
//       flavourName: json['FlavourName'],
//       bgColor: json['BgColor'],
//       isActive: json['IsActive'],
//     );
//   }
// }
// class ProductListModelDetail {
//   String productName,
//       defaultUnitName,
//       defaultSalesPrice,
//       defaultPurchasePrice,
//       gSTSalesTax,
//       vatsSalesTax,
//       gSTTaxName,
//       description,
//       vegOrNonVeg,
//       productImage,
//       vATTaxName;
//
//   int productID, defaultUnitID, gstID, vatID;
//   bool isInclusive;
//
//   ProductListModelDetail(
//       {required this.productID,
//       required this.defaultUnitID,
//       required this.gstID,
//       required this.vatID,
//       required this.productName,
//       required this.defaultUnitName,
//       required this.defaultSalesPrice,
//       required this.defaultPurchasePrice,
//       required this.gSTSalesTax,
//       required this.vatsSalesTax,
//       required this.vegOrNonVeg,
//       required this.gSTTaxName,
//       required this.vATTaxName,
//       required this.description,
//       required this.productImage,
//       required this.isInclusive});
//
//   factory ProductListModelDetail.fromJson(Map<dynamic, dynamic> json) {
//     return ProductListModelDetail(
//       productID: json['ProductID'] ?? 0,
//       defaultUnitID: json['DefaultUnitID'] ?? '',
//       gstID: json['GST_ID'] ?? 0,
//       vatID: json['VatID'] ?? 0,
//       productName: json['ProductName'] ?? '',
//       defaultUnitName: json['DefaultUnitName'] ?? '',
//       defaultSalesPrice: json['DefaultSalesPrice'].toString(),
//       defaultPurchasePrice: json['DefaultPurchasePrice'].toString(),
//       gSTSalesTax: json['GST_SalesTax'] ?? '',
//       vatsSalesTax: json['SalesTax'] ?? '',
//       gSTTaxName: json['GST_TaxName'] ?? "",
//       vATTaxName: json['VAT_TaxName'] ?? '',
//       isInclusive: json['is_inclusive'] ?? false,
//       description: json['Description'] ?? '',
//       vegOrNonVeg: json['VegOrNonVeg'] ?? '',
//       productImage: json['ProductImage'] ?? '',
//     );
//   }
// }
// class PassingDetails {
//   int productId, priceListId, createUserId, salesDetailsID, detailID, actualProductTaxID, productTaxID;
//   String productName,
//       quantity,
//       unitPrice,
//       netAmount,
//       uniqueId,
//       flavourID,
//       flavourName,
//       discountAmount,
//       grossAmount,
//       rateWithTax,
//       status,
//       costPerPrice,
//       discountPercentage,
//       taxableAmount,
//       vatPer,
//       vatAmount,
//       sgsPer,
//       sgsAmount,
//       cgsPer,
//       cgsAmount,
//       roundedUnitPrice,
//       netAmountRounded,
//       igsPer,
//       igsAmount,
//       roundedQuantity,
//       inclusivePrice,
//       unitPriceName,
//       additionalDiscount,
//       gstPer,
//       actualProductTaxName,
//       salesPrice,
//       totalTaxRounded,
//       description,
//       productTaxName;
//   bool productInc;
//
//   PassingDetails({
//     required this.uniqueId,
//     required this.productName,
//     required this.grossAmount,
//     required this.unitPrice,
//     required this.netAmount,
//     required this.salesDetailsID,
//     required this.quantity,
//     required this.discountAmount,
//     required this.productId,
//     required this.rateWithTax,
//     required this.costPerPrice,
//     required this.priceListId,
//     required this.additionalDiscount,
//     required this.discountPercentage,
//     required this.taxableAmount,
//     required this.vatPer,
//     required this.vatAmount,
//     required this.sgsPer,
//     required this.cgsAmount,
//     required this.cgsPer,
//     required this.createUserId,
//     required this.flavourID,
//     required this.flavourName,
//     required this.igsAmount,
//     required this.igsPer,
//     required this.sgsAmount,
//     required this.netAmountRounded,
//     required this.detailID,
//     required this.status,
//     required this.inclusivePrice,
//     required this.roundedUnitPrice,
//     required this.roundedQuantity,
//     required this.gstPer,
//     required this.unitPriceName,
//     required this.productTaxID,
//     required this.productTaxName,
//     required this.actualProductTaxName,
//     required this.actualProductTaxID,
//     required this.salesPrice,
//     required this.productInc,
//     required this.totalTaxRounded,
//     required this.description,
//   });
//
//   factory PassingDetails.fromJson(Map<dynamic, dynamic> json) {
//     return PassingDetails(
//       uniqueId: json['id'],
//       productId: json['ProductID'],
//       productName: json['ProductName'],
//       quantity: json['Qty'].toString(),
//       unitPrice: json['UnitPrice'].toString(),
//       description: json['Description'] ?? "",
//       rateWithTax: json['RateWithTax'].toString(),
//       costPerPrice: json['CostPerPrice'].toString(),
//       grossAmount: json['GrossAmount'].toString(),
//       netAmount: json['NetAmount'].toString(),
//       priceListId: json['PriceListID'],
//       discountPercentage: json['DiscountPerc'].toString(),
//       discountAmount: json['DiscountAmount'].toString(),
//       taxableAmount: json['TaxableAmount'].toString(),
//       vatPer: json['VATPerc'].toString(),
//       vatAmount: json['VATAmount'].toString(),
//       salesDetailsID: json['SalesDetailsID'],
//       sgsPer: json['SGSTPerc'].toString(),
//       sgsAmount: json['SGSTAmount'].toString(),
//       cgsPer: json['CGSTPerc'].toString(),
//       cgsAmount: json['CGSTAmount'].toString(),
//       igsPer: json['IGSTPerc'].toString(),
//       igsAmount: json['IGSTAmount'].toString(),
//       additionalDiscount: json['AddlDiscAmt'].toString(),
//       createUserId: json['CreatedUserID'],
//       detailID: json['detailID'],
//       productInc: json['is_inclusive'],
//       roundedUnitPrice: json['unitPriceRounded'].toString(),
//       roundedQuantity: json['quantityRounded'].toString(),
//       inclusivePrice: json['InclusivePrice'].toString(),
//       netAmountRounded: json['netAmountRounded'].toString(),
//       unitPriceName: json['UnitName'],
//       gstPer: json['gstPer'].toString(),
//       productTaxName: json['ProductTaxName'],
//       flavourID: json['flavour'] ?? "",
//       flavourName: json['Flavour_Name'] ?? "",
//       productTaxID: json['ProductTaxID'],
//       status: json['Status'],
//       actualProductTaxName: json['ActualProductTaxName'],
//       actualProductTaxID: json['ActualProductTaxID'],
//       salesPrice: json['SalesPrice'].toString(),
//       totalTaxRounded: json['TotalTaxRounded'].toString(),
//     );
//   }
// }
// class PosListModel {
//   final String salesOrderId, salesId, custName, tokenNo, phone, status, salesOrderGrandTotal, salesGrandTotal, orderTime;
//
//   PosListModel(
//       {required this.salesOrderId,
//         required this.salesId,
//         required this.custName,
//         required this.tokenNo,
//         required this.phone,
//         required this.status,
//         required this.salesOrderGrandTotal,
//         required this.salesGrandTotal,
//         required this.orderTime});
//
//   factory PosListModel.fromJson(Map<dynamic, dynamic> json) {
//     return PosListModel(
//         salesOrderId: json['SalesOrderID'],
//         salesId: json['SalesID'],
//         custName: json['CustomerName'],
//         tokenNo: json['TokenNumber'],
//         phone: json['Phone'],
//         status: json['Status'],
//         salesOrderGrandTotal: json['SalesOrderGrandTotal'],
//         salesGrandTotal: json['SalesGrandTotal'],
//         orderTime: json['OrderTime']);
//   }
// }
// class DiningListModel {
//   final String tableId, title, description, status, salesGrandTotal, salesOrderID, salesMasterID, orderTime, salesOrderGrandTotal;
//   var reserved;
//   final bool isReserved;
//
//   DiningListModel(
//       {required this.title,
//         required this.tableId,
//         required this.description,
//         required this.status,
//         required this.salesOrderID,
//         required this.salesGrandTotal,
//         required this.salesMasterID,
//         required this.isReserved,
//         required this.reserved,
//         required this.orderTime,
//         required this.salesOrderGrandTotal});
//
//   factory DiningListModel.fromJson(Map<dynamic, dynamic> json) {
//     return DiningListModel(
//       tableId: json['id'],
//       title: json['title'],
//       description: json['description'],
//       status: json['Status'],
//       salesOrderID: json['SalesOrderID'],
//       salesMasterID: json['SalesMasterID'],
//       orderTime: json['OrderTime'],
//       isReserved: json['IsReserved'],
//       reserved: json['reserved'] ?? [],
//       salesOrderGrandTotal: json['SalesOrderGrandTotal'].toString(),
//       salesGrandTotal: json['SalesGrandTotal'].toString(),
//     );
//   }
// }
// class CancelReportModel {
//   final String id, reason;
//   final int branchID;
//
//   CancelReportModel({required this.id, required this.reason, required this.branchID});
//
//   factory CancelReportModel.fromJson(Map<dynamic, dynamic> json) {
//     return CancelReportModel(id: json['id'], branchID: json['BranchID'], reason: json['Reason']);
//   }
// }
// class LoyaltyCustomerModel {
//   int loyaltyCustomerID;
//   String customerName, id, phone;
//
//   LoyaltyCustomerModel({required this.customerName, required this.id, required this.loyaltyCustomerID, required this.phone});
//
//   factory LoyaltyCustomerModel.fromJson(Map<dynamic, dynamic> json) {
//     return LoyaltyCustomerModel(
//       customerName: json['FirstName'],
//       loyaltyCustomerID: json['LoyaltyCustomerID'],
//       id: json['id'],
//       phone: json['MobileNo'],
//     );
//   }
// }
// class PaymentData {
//   static int cardTypeId = 0;
//   static int ledgerID = 0;
//   static String deliveryManID = "0";
//   static int loyaltyCustomerID = 0;
//   static String salesOrderID = "";
// }
//
//
//
// List<PrintDetails> printListData = [];
// List<ItemsDetails> dataPrint = [];
// List<CardDetailsDetails> cardList = [];
// List<CategoryListModel> categoryList = [];
// List<FlavourListModel> flavourList = [];
// List<ProductListModelDetail> productList = [];
// List<PosListModel> onlineOrderLists = [];
// List<PosListModel> takeAwayOrderLists = [];
// List<PosListModel> carOrderLists = [];
// List<DiningListModel> diningOrderList = [];
// List<CancelReportModel> cancelReportList = [];
// List<LoyaltyCustomerModel> loyaltyCustLists = [];
//
//
//
//
//
//
// class Button extends StatelessWidget {
//   const Button({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 80,
//       height: 40,
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.all(Radius.circular(5)),
//         boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//       ),
//       child: GestureDetector(
//         child: Center(child: Text('Click Me')),
//         onTap: () {},
//       ),
//     );
//     ;
//   }
// }
//
// class UserDetailsAppBar extends StatelessWidget {
//   UserDetailsAppBar({
//     Key? key,
//     required this.user_name,
//     // required this.masterID,
//   }) : super(key: key);
//
//   String user_name;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//
//         alignment: Alignment.centerRight,
//         height: MediaQuery.of(context).size.height / 11, //height of button
//         width: MediaQuery.of(context).size.width / 2.3,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Text(
//               user_name,
//               style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),
//             ),
//             IconButton(
//               icon: Icon(Icons.login_outlined),
//               onPressed: () async {
//                 showDialog(
//                     context: context,
//                     barrierDismissible: true,
//                     builder: (BuildContext context) {
//                       return Padding(
//                         padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                         child: AlertDialog(
//                           title: Padding(
//                             padding: EdgeInsets.all(0.5),
//                             child: Text(
//                               "Alert!",
//                               style: customisedStyle(context, Colors.black, FontWeight.w600, 15.00),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                           content: Text("Log out from POS", style: customisedStyle(context, Colors.black, FontWeight.w600, 15.0)),
//                           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
//                           actions: <Widget>[
//                             TextButton(
//                                 onPressed: () async {
//                                   SharedPreferences prefs = await SharedPreferences.getInstance();
//                                   prefs.setBool('IsSelectPos', false);
//                                   Navigator.pop(context);
//                                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EnterPinNumber()));
//                                 },
//                                 child: Text(
//                                   'Ok',
//                                   style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                                 )),
//                             TextButton(
//                                 onPressed: () => {
//                                       Navigator.pop(context),
//                                     },
//                                 child: Text(
//                                   'Cancel',
//                                   style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
//                                 )),
//                           ],
//                         ),
//                       );
//                     });
//               },
//             ),
//           ],
//         ));
//   }
// }
//
//
//
//
//
//
// class BackButtonAppBar extends StatelessWidget {
//   BackButtonAppBar({
//     Key? key,
//     // required this.masterID,
//   }) : super(key: key);
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         alignment: Alignment.centerRight,
//         height: MediaQuery.of(context).size.height / 11, //height of button
//        // width: MediaQuery.of(context).size.width / 3,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_back),
//               onPressed: () async {
//
//                 SharedPreferences prefs = await SharedPreferences.getInstance();
//                 var selectPos = prefs.getBool('IsSelectPos')??false;
//                 if(selectPos){
//                 }
//                 else{
//                  Navigator.pop(context);
//                 }
//               },
//             ),
//
//           ],
//         ));
//   }
// }
//
