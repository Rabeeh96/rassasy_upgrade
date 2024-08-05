import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/test_page/test_file.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/dashboard/Reservation/reservation_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../global/textfield_decoration.dart';
import '../../../../main.dart';
import 'model/model_class.dart';
import 'new_pos_order_section.dart';

class POSListItemsSection extends StatefulWidget {
  const POSListItemsSection({Key? key}) : super(key: key);

  @override
  State<POSListItemsSection> createState() => _POSListItemsSectionState();
}

class _POSListItemsSectionState extends State<POSListItemsSection> {
  Color borderColor = const Color(0xffB8B8B8);

  TextEditingController tableNameController = TextEditingController();
  TextEditingController reservationCustomerNameController =
  TextEditingController();

  bool networkConnection = true;
  bool hide_payment = false;
  int detailIdEdit = 0;

  // Color color1 = Colors.white;
  // Color color2 = const Color(0xffF8F8F8);
  // Color color3 = const Color(0xffF8F8F8);
  // Color color4 = const Color(0xffF8F8F8);

  Color pageButton1 = Colors.black;
  Color pageButton2 = Colors.white;
  Color pageButton3 = Colors.white;
  Color pageButton4 = Colors.white;
  Color buttonText1 = Colors.white;
  Color buttonText2 = Colors.black;
  Color buttonText3 = Colors.black;
  Color buttonText4 = Colors.black;

  Color pageButtonColor1 = Colors.black;
  Color pageButtonColor2 = Colors.white;
  Color pageButtonTextColor1 = Colors.black;
  Color pageButtonTextColor2 = Colors.white;
  var page = 1;
  bool buttonStyle = true;

  var mainPageIndex = 1;

  String currency = "SR";

  /// onchange

  String userName = "";
  bool dining_view_perm = false;
  bool reservation_view_perm = false;
  bool directOrderOption = false;
  bool take_away_view_perm = false;
  bool car_view_perm = false;

  bool dining_create_perm = false;
  bool take_away_create_perm = false;
  bool car_create_perm = false;

  bool dining_edit_perm = false;
  bool take_away_edit_perm = false;
  bool car_edit_perm = false;

  bool dining_delete_perm = false;
  bool take_away_delete_perm = false;
  bool car_delete_perm = false;

  bool print_perm = false;
  bool cancel_order_perm = false;
  bool pay_perm = false;
  bool reservation_perm = false;
  bool kitchen_print_perm = false;
  bool remove_table_perm = false;
  bool convert_type_perm = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      posFunctions(callFunction: false);
    });
    getDefaultValues();
  }

  getDefaultValues() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // buttonFontSize = prefs.getDouble('ButtonFontSize') ?? 12.0;
    // amountFontSize = prefs.getDouble('AmountFontSize') ?? 12.0;
    // buttonHeight = prefs.getDouble('ButtonHeight') ?? 17.0;
    // rowCountGridView = prefs.getInt('RowCountGridView') ?? 4;
  }

  String waiterNameInitial = "";
  bool IsSelectWaiter = false;
  bool diningStatusPermission = false;
  bool carStatusPermission = false;
  bool onlineStatusPermission = false;
  bool takeawayStatusPermission = false;

  bool permissionToPrint = false;
  bool permissionToCancelOrder = false;
  bool permissionToPayment = false;
  bool permissionToKOT = false;
  bool permissionToReservation = false;

  Future<Null> posFunctions({required bool callFunction}) async {
    reservationDate = ValueNotifier(DateTime.now());
    timeNotifierFromTime = ValueNotifier(DateTime.now());
    timeNotifierToTime = ValueNotifier(DateTime.now());

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
        networkConnection = false;
      });
    } else {
      networkConnection = true;

      await ReloadAllData(callFunction: callFunction);
      await getTableOrderList();
    }
  }

  bool kotLoad = false;

  ReloadAllData({required bool callFunction}) async {
    print("----------------------------------------------------------------1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cancelReportList.clear();
    cardList.clear();
    diningOrderList.clear();
    carOrderLists.clear();
    takeAwayOrderLists.clear();
    onlineOrderLists.clear();
    setState(() {
      userName = prefs.getString('user_name')!;
      dining_view_perm = prefs.getBool('Diningview') ?? true;
      reservation_view_perm = prefs.getBool('View Reservation') ?? true;
      directOrderOption = prefs.getBool('directOrderOption') ?? false;
      take_away_view_perm = prefs.getBool('Take awayview') ?? true;
      car_view_perm = prefs.getBool('Carview') ?? true;

      dining_create_perm = prefs.getBool('Diningsave') ?? true;
      take_away_create_perm = prefs.getBool('Take awaysave') ?? true;
      car_create_perm = prefs.getBool('Carsave') ?? true;

      dining_edit_perm = prefs.getBool('Diningedit') ?? true;
      take_away_edit_perm = prefs.getBool('Take awayedit') ?? true;
      car_edit_perm = prefs.getBool('Caredit') ?? true;

      bool kotPrint = prefs.getBool("KOT") ?? false;

      dining_delete_perm = prefs.getBool('Diningdelete') ?? true;
      take_away_delete_perm = prefs.getBool('Take awaydelete') ?? true;
      car_delete_perm = prefs.getBool('Cardelete') ?? true;

      if (callFunction == false) {
        if (dining_view_perm) {
          mainPageIndex = 1;
        } else if (take_away_view_perm) {
          mainPageIndex = 2;
        } else {
          mainPageIndex = 4;
        }
      }
      print(
          "----------------------------------------------------------------2");
      cancel_order_perm = prefs.getBool('Cancel Order') ?? true;
      pay_perm = prefs.getBool('Payment') ?? true;

      kitchen_print_perm = prefs.getBool('KOT Print') ?? true;

      if (kotPrint == false) {
        kitchen_print_perm = false;
      }

      print_perm = prefs.getBool('Re-Print') ?? true;
      reservation_perm = prefs.getBool('Reserve Table') ?? true;
      remove_table_perm = false;
      convert_type_perm = false;

      /// commented because its not in api
      // remove_table_perm = prefs.getBool('remove_table_perm')??true;
      // convert_type_perm = prefs.getBool('convert_type_perm')??true;

      // IsSelectPos = checkPermissions();
    });
  }

  bool checkPermissions() {
    bool anyPermissionTrue = print_perm ||
        cancel_order_perm ||
        pay_perm ||
        reservation_perm ||
        kitchen_print_perm ||
        remove_table_perm ||
        convert_type_perm;

    if (anyPermissionTrue) {
      return false;
    } else {
      return true;
    }
  }

  var deletedList = [];
  var productName;

  ///

  var item_status;
  var unique_id;
  var detailID;
  var unitName;
  int productId = 0;
  int actualProductTaxID = 0;
  int productID = 0;
  int branchID = 0;
  int salesDetailsID = 0;
  int productTaxID = 0;
  int createdUserID = 0;
  int priceListID = 0;

  var productTaxName = "";
  var flavourID = "";
  var flavourName = "";
  var salesPrice = "";
  var purchasePrice = "";
  var id = "";
  var freeQty = "";
  var rateWithTax = 0.0;
  var costPerPrice = "";
  var discountPer = "";
  var taxType = "";
  var taxID;
  var discountAmount = 0.0;
  var percentageDiscount = 0.0;
  var taxableAmountPost = 0.0;

  var grossAmount = "";
  var vatPer = 0.0;
  var quantity = 1.0;
  var vatAmount = 0.0;
  var netAmount = 0.0;

  var sGSTPer = 0.0;
  var sGSTAmount = 0.0;
  var cGSTPer = 0.0;
  var cGSTAmount = 0.0;
  var iGSTPer = 0.0;
  var iGSTAmount = 0.0;
  var totalTax = 0.0;
  var dataBase = "";
  var taxableAmount = "";
  var addDiscPer = "";
  var addDiscAmt = "";
  var gstPer = 0.0;
  var gstAmount = 0.0;
  bool isInclusive = false;
  var unitPriceRounded = 0.0;
  var quantityRounded = 0.0;
  var netAmountRounded = 0.0;
  var actualProductTaxName = "";
  var descriptionD = "";

  var unitPriceAmountWR = "0.00";
  var inclusiveUnitPriceAmountWR = "0.00";
  var grossAmountWR = "0.00";
  int totalCategory = 0;

  Future<bool> _onWillPop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var selectPos = prefs.getBool('IsSelectPos') ?? false;
    print("object");
    if (selectPos == false) {
      return true;
    } else {
      return (await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to exit?'),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent, // Background color
                ),
                child: Text(
                  'No',
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent, // Background color
                ),
                child: Text(
                  'Yes'.tr,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      )) ??
          false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: networkConnection == true
    //       ? GestureDetector(
    //       child: posDetailPage(),
    //       onTap: () {
    //         setState(() {
    //           selectedDiningIndex = 1000;
    //           selectedTakeAwayIndex = 1000;
    //           selectedOnlineIndex = 1000;
    //           selectedCarIndex = 1000;
    //         });
    //       })
    //       : noNetworkConnectionPage(),
    // );

    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: networkConnection == true
            ? GestureDetector(
            child: posDetailPage(),
            onTap: () {
              setState(() {
                selectedDiningIndex = 1000;
                selectedTakeAwayIndex = 1000;
                selectedOnlineIndex = 1000;
                selectedCarIndex = 1000;
              });
            })
            : noNetworkConnectionPage(),
      ),
    );
  }

  Widget posDetailPage() {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: selectOrderType(mainPageIndex),
        ),
        Container(
          /// color: Colors.red,
          height: MediaQuery.of(context).size.height / 1, //height of button
          //  width: MediaQuery.of(context).size.width / 11,
          child: Center(child: orderTypeDetailScreen()),
        )
      ],
    );
  }

  Widget noNetworkConnectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/warning.svg",
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              posFunctions(callFunction: false);
            },
            child: Text('retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all(const Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }

  /// main Page
  selectOrderType(int index) {
    if (index == 1) {
      return dining_view_perm
          ? diningDetailScreen()
          : Container(
        child: Center(
            child: Text(
              "No permission to dining section",
              style: customisedStyle(
                  context, Colors.black, FontWeight.w500, 14.0),
            )),
      );
    } else if (index == 2) {
      return take_away_view_perm
          ? takeAwayDetailScreen()
          : Container(
        child: Center(
            child: Text(
              "No permission to Take away section",
              style: customisedStyle(
                  context, Colors.black, FontWeight.w500, 14.0),
            )),
      );
    } else if (index == 3) {
      return onlineDeliveryDetailScreen();
    } else if (index == 4) {
      return car_view_perm
          ? carDeliveryDetailScreen()
          : Container(
        child: Center(
            child: Text(
              "No permission to Car section",
              style: customisedStyle(
                  context, Colors.black, FontWeight.w500, 14.0),
            )),
      );
    }
  }

// d
  /// dining section
  bool isSettingOpen = false;
  TextEditingController amountFontSizeController = TextEditingController()
    ..text = '12';
  TextEditingController buttonsFontSizeController = TextEditingController()
    ..text = '12';
  TextEditingController buttonHeightController = TextEditingController()
    ..text = '16';
  TextEditingController buttonWidthController = TextEditingController();

  TextEditingController itemCountRowController = TextEditingController()
    ..text = '4';

  double amountFontSize = 12.0;
  double buttonFontSize = 12.0;
  double buttonHeight = 16.00;
  double buttonWidth = 5.00;
  int rowCountGridView = 4;

  Widget diningDetailScreen() {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xffEE830C),
      child: ListView(
        children: [
          Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 11,
              width: MediaQuery.of(context).size.width / 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButtonAppBar(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: MediaQuery.of(context).size.height /
                            11, //height of button
                        width: MediaQuery.of(context).size.width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dining'.tr,
                              style: customisedStyle(
                                  context,
                                  const Color(0xff717171),
                                  FontWeight.bold,
                                  15.00),
                            ),
                            Text(
                              'choose_table'.tr,
                              style: customisedStyle(
                                  context,
                                  const Color(0xff000000),
                                  FontWeight.w700,
                                  12.00),
                            )
                          ],
                        ),
                      ),
                      // IconButton(
                      //     onPressed: () {
                      //       posFunctions();
                      //
                      //     },
                      //     icon: SvgPicture.asset(
                      //       'assets/svg/Refresh_icon.svg',
                      //     ),
                      //     iconSize: 110
                      // ),

                      UserDetailsAppBar(user_name: userName),

                      Container(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0347A1)),
                          onPressed: () {
                            posFunctions(callFunction: true);
                          },
                          child: Text(
                            'Refresh'.tr,
                            style: customisedStyle(
                                context, Colors.white, FontWeight.w500, 12.0),
                          ),
                        ),
                      ),

                      ///here changed
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isSettingOpen = true;
                            });
                            //   Navigator.push(
                            //     context,
                            //     MaterialPageRoute(builder: (context) => PosSettings()));
                          },
                          child: Text("Settings"))
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: isSettingOpen
                ? MediaQuery.of(context).size.height / 1.5
                : MediaQuery.of(context).size.height / 1.3, //height of button
            width: MediaQuery.of(context).size.width / 1,
            // color: Colors.grey,),
            child: GridView.builder(
              // physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    left: 4, top: 20, right: 0, bottom: 6),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowCountGridView,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: diningOrderList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Opacity(
                    opacity: selectedDiningIndex == index
                        ? 1
                        : selectedDiningIndex == 1000
                        ? 1
                        : 0.30,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff8D8D8D),
                              width: 1.7,
                            )),
                        child: returnDiningListItem(index)),
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD6D6D6), width: 0.5)),
            height: isSettingOpen
                ? MediaQuery.of(context).size.height / 6
                : MediaQuery.of(context).size.height / 14, //height of button
            //width: MediaQuery.of(context).size.width / 1,
            child: isSettingOpen
                ? Container(
                color: Colors.grey.shade50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("Font Style",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Amount Font Size ",
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w600, 12.0),
                            ),
                          ),
                          Container(

                            height: MediaQuery.of(context).size.height /
                                15, //height of button
                            width: MediaQuery.of(context).size.width / 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height /
                                      18, //height of button
                                  width:
                                  MediaQuery.of(context).size.width / 17,
                                  child: TextField(
                                    controller: amountFontSizeController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w500,
                                        14.00),
                                    onChanged: (text) async {
                                      SharedPreferences prefs =
                                      await SharedPreferences
                                          .getInstance();

                                      if (text.isNotEmpty) {
                                        amountFontSize = double.parse(text);
                                        amountFontSizeController.text =
                                        "$amountFontSize";
                                        prefs.setDouble(
                                            'AmountFontSize', amountFontSize);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotatedBox(quarterTurns: 2,child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (amountFontSize <= 0) {
                                            } else {
                                              amountFontSize =
                                                  amountFontSize - 1;
                                              amountFontSizeController.text =
                                              "$amountFontSize";
                                            }
                                          });
                                        },
                                        child: InkWell(
                                          child: Icon(
                                              Icons.arrow_drop_down_circle),
                                        )),),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: Container(
                                        alignment: Alignment.center,

                                        // height: MediaQuery.of(context).size.height / 20,
                                        // //height of button
                                        // width: MediaQuery.of(context).size.width / 29,
                                        // decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(3))),

                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                amountFontSize =
                                                    amountFontSize + 1;
                                                amountFontSizeController
                                                    .text = "$amountFontSize";
                                              });
                                            },
                                            child: InkWell(
                                              child: Icon(Icons
                                                  .arrow_drop_down_circle),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:20.0),
                            child: Text(
                              "Button Font Size",
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w600, 12.0),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height /
                                15, //height of button

                            width: MediaQuery.of(context).size.width / 7,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height /
                                      18, //height of button
                                  width:
                                  MediaQuery.of(context).size.width / 17,
                                  child: TextField(
                                    controller: buttonsFontSizeController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w500,
                                        14.00),
                                    onChanged: (text) async {
                                      SharedPreferences prefs =
                                      await SharedPreferences
                                          .getInstance();

                                      if (text.isNotEmpty) {
                                        buttonFontSize = double.parse(text);
                                        buttonsFontSizeController.text =
                                        "$buttonFontSize";
                                        prefs.setDouble(
                                            'ButtonFontSize', buttonFontSize);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotatedBox(quarterTurns: 2,child:  GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            buttonFontSize =
                                                buttonFontSize + 1;
                                            buttonsFontSizeController.text =
                                            "$buttonFontSize";
                                          });

                                        },
                                        child: InkWell(
                                          child: Icon(
                                              Icons.arrow_drop_down_circle),
                                        )),),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (buttonFontSize <= 0) {
                                              } else {
                                                buttonFontSize =
                                                    buttonFontSize - 1;
                                                buttonsFontSizeController.text =
                                                "$buttonFontSize";
                                              }
                                            });
                                          },
                                          child: InkWell(
                                            child: Icon(
                                                Icons.arrow_drop_down_circle),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(right: 16.0),
                      //       child: Text(
                      //         "Button Width",
                      //         style: customisedStyle(context, Colors.black,
                      //             FontWeight.w600, 12.0),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 7,
                      //     ),
                      //     Container(
                      //       height: MediaQuery.of(context).size.height /
                      //           8.5, //height of button
                      //
                      //       width: MediaQuery.of(context).size.width / 7,
                      //       child: Row(
                      //         children: [
                      //           // Container(
                      //           //   height:
                      //           //       MediaQuery.of(context).size.height / 13,
                      //           //   width:
                      //           //       MediaQuery.of(context).size.width / 29,
                      //           //   decoration: const BoxDecoration(
                      //           //       color: Color(0xffF25F29),
                      //           //       borderRadius: BorderRadius.all(
                      //           //           Radius.circular(3))),
                      //           //   child: IconButton(
                      //           //       onPressed: () {
                      //           //         setState(() {
                      //           //           if (buttonWidth <= 0) {
                      //           //           } else {
                      //           //             buttonWidth = buttonWidth - 1;
                      //           //             buttonWidthController.text =
                      //           //                 "$buttonWidth";
                      //           //           }
                      //           //         });
                      //           //       },
                      //           //       icon: SvgPicture.asset(
                      //           //           'assets/svg/increment_qty.svg')),
                      //           // ),
                      //           // const SizedBox(
                      //           //   width: 4,
                      //           // ),
                      //           Container(
                      //             alignment: Alignment.center,
                      //             height: MediaQuery.of(context).size.height /
                      //                 13, //height of button
                      //             width:
                      //                 MediaQuery.of(context).size.width / 17,
                      //             child: TextField(
                      //               controller: buttonWidthController,
                      //               textAlign: TextAlign.center,
                      //               inputFormatters: [
                      //                 FilteringTextInputFormatter.allow(
                      //                     RegExp(r'[0-9]')),
                      //               ],
                      //               style: customisedStyle(
                      //                   context,
                      //                   const Color(0xff000000),
                      //                   FontWeight.w500,
                      //                   14.00),
                      //               onChanged: (text) async {
                      //                 SharedPreferences prefs =
                      //                     await SharedPreferences
                      //                         .getInstance();
                      //
                      //                 if (text.isNotEmpty) {
                      //                   buttonWidth = double.parse(text);
                      //                   buttonWidthController.text =
                      //                       "$buttonWidth";
                      //                   prefs.setDouble(
                      //                       'ButtonWidth', buttonWidth);
                      //                 } else {}
                      //               },
                      //               decoration: const InputDecoration(
                      //                 isDense: true,
                      //                 contentPadding: EdgeInsets.all(12),
                      //                 border: OutlineInputBorder(),
                      //               ),
                      //             ),
                      //           ),
                      //
                      //           Column(
                      //             children: [
                      //               GestureDetector(
                      //                   onTap: () {
                      //                     setState(() {
                      //                       if (buttonWidth <= 0) {
                      //                       } else {
                      //                         buttonWidth = buttonWidth - 1;
                      //                         buttonWidthController.text =
                      //                             "$buttonWidth";
                      //                       }
                      //                     });
                      //                   },
                      //                   child: InkWell(
                      //                     child: Icon(
                      //                         Icons.arrow_drop_down_circle),
                      //                   )),
                      //               RotatedBox(
                      //                 quarterTurns: 4,
                      //                 child: GestureDetector(
                      //                     onTap: () {
                      //                       setState(() {
                      //                         buttonWidth = buttonWidth + 1;
                      //                         buttonWidthController.text =
                      //                             "$buttonWidth";
                      //                       });
                      //                     },
                      //                     child: InkWell(
                      //                       child: Icon(
                      //                           Icons.arrow_drop_down_circle),
                      //                     )),
                      //               )
                      //             ],
                      //           ),
                      //         ],
                      //       ),
                      //     )
                      //   ],
                      // ),

                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.teal)),
                        child: Text(
                          'OK',
                          style: customisedStyle(
                              context, Colors.white, FontWeight.normal, 13.0),
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                          setState(() {
                            amountFontSize =
                                double.parse(amountFontSizeController.text);
                            buttonFontSize =
                                double.parse(buttonsFontSizeController.text);
                            buttonHeight =
                                double.parse(buttonHeightController.text);
                            buttonWidth =
                                double.parse(buttonWidthController.text);
                            rowCountGridView =
                                int.parse(itemCountRowController.text);

                            prefs.setDouble('ButtonFontSize', buttonFontSize);
                            prefs.setDouble('AmountFontSize', amountFontSize);
                            prefs.setDouble('ButtonHeight', buttonHeight);
                            prefs.setInt(
                                'RowCountGridView', rowCountGridView);
                          });
                          // String value2 = _textFieldController2.text;
                          // bool printSecondCopy = _printSecondCopy;
                          /// await  posFunctions(callFunction: true);

                          /// Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 37),
                            child: Text(
                              "Button Height",
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w600, 12.0),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height /
                                15, //height of button

                            width: MediaQuery.of(context).size.width / 10,
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height /
                                      18, //height of button
                                  width:
                                  MediaQuery.of(context).size.width / 17,
                                  child: TextField(
                                    controller: buttonHeightController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w500,
                                        14.00),
                                    onChanged: (text) async {
                                      SharedPreferences prefs =
                                      await SharedPreferences
                                          .getInstance();

                                      if (text.isNotEmpty) {
                                        buttonHeight = double.parse(text);
                                        buttonHeightController.text =
                                        "$buttonHeight";
                                        prefs.setDouble(
                                            'ButtonHeight', buttonHeight);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotatedBox(quarterTurns: 2,child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            buttonHeight = buttonHeight + 1;
                                            buttonHeightController.text =
                                            "$buttonHeight";
                                          });
                                        },
                                        child: InkWell(
                                          child: Icon(
                                              Icons.arrow_drop_down_circle),
                                        )),),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (buttonHeight <= 0) {
                                              } else {
                                                buttonHeight = buttonHeight - 1;
                                                buttonHeightController.text =
                                                "$buttonHeight";
                                              }
                                            });

                                          },
                                          child: InkWell(
                                            child: Icon(
                                                Icons.arrow_drop_down_circle),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              "Items in a Row",
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w600, 12.0),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height /
                                15, //height of button

                            width: MediaQuery.of(context).size.width / 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  height: MediaQuery.of(context).size.height /
                                      18, //height of button
                                  width:
                                  MediaQuery.of(context).size.width / 17,
                                  child: TextField(
                                    controller: itemCountRowController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w500,
                                        14.00),
                                    onChanged: (text) async {
                                      SharedPreferences prefs =
                                      await SharedPreferences
                                          .getInstance();

                                      if (text.isNotEmpty) {
                                        rowCountGridView = int.parse(text);
                                        itemCountRowController.text =
                                        "$rowCountGridView";
                                        prefs.setInt('RowCountGridView',
                                            rowCountGridView);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(12),
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5,),

                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RotatedBox(quarterTurns: 2,child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            rowCountGridView =
                                                rowCountGridView + 1;
                                            itemCountRowController.text =
                                            "$rowCountGridView";
                                          });

                                        },
                                        child: InkWell(
                                          child: Icon(
                                              Icons.arrow_drop_down_circle),
                                        )),),
                                    RotatedBox(
                                      quarterTurns: 4,
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (rowCountGridView <= 0) {
                                              } else {
                                                rowCountGridView =
                                                    rowCountGridView - 1;
                                                itemCountRowController.text =
                                                "$rowCountGridView";
                                              }
                                            });
                                          },
                                          child: InkWell(
                                            child: Icon(
                                                Icons.arrow_drop_down_circle),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                ],
              ),
            )
                : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height:
                            MediaQuery.of(context).size.height / 12,
                            //height of button
                            // width: MediaQuery.of(context).size.width / 18,
                            child: IconButton(
                                onPressed: () {
                                  createTable(context);
                                },
                                icon: SvgPicture.asset(
                                  'assets/svg/addmore.svg',
                                ),
                                iconSize: 35),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 16, right: 16, bottom: 16),
                            height:
                            MediaQuery.of(context).size.height / 14,
                            //height of button
                            // width: MediaQuery.of(context).size.width / 10,

                            child: Text(
                              'add_table'.tr,
                              style: customisedStyle(context,
                                  Colors.black, FontWeight.w500, 14.00),
                            ),
                          ),
                        ],
                      ),

                      /// remove table commented

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       height: MediaQuery.of(context).size.height / 12, //height of button
                      //       // width: MediaQuery.of(context).size.width / 18,
                      //       child: IconButton(
                      //           onPressed: () {
                      //
                      //           },
                      //           icon: SvgPicture.asset(
                      //             'assets/svg/remove_item.svg',
                      //           ),
                      //           iconSize: 35),
                      //     ),
                      //     Container(
                      //       padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                      //       height: MediaQuery.of(context).size.height / 14, //height of button
                      //       // width: MediaQuery.of(context).size.width / 10,
                      //
                      //       child: Text(
                      //         'Remove table',
                      //         style: customisedStyle(context, Colors.black, FontWeight.w500, 14.00),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),

                  ///icon

                  reservation_view_perm == true
                      ? GestureDetector(
                      onTap: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ReservationList()),
                        );

                        posFunctions(callFunction: false);
                      },
                      child: AbsorbPointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height:
                              MediaQuery.of(context).size.height /
                                  12,
                              //height of button
                              // width: MediaQuery.of(context).size.width / 18,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                    'assets/svg/reserve.svg',
                                  ),
                                  iconSize: 35),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 16, right: 16, bottom: 16),
                              height:
                              MediaQuery.of(context).size.height /
                                  14,
                              //height of button
                              // width: MediaQuery.of(context).size.width / 10,

                              child: Text(
                                'Reservation'.tr,
                                style: customisedStyle(
                                    context,
                                    const Color(0xff00775E),
                                    FontWeight.w500,
                                    14.00),
                              ),
                            ),
                          ],
                        ),
                      ))
                      : Container(),
                ]),
          )
        ],
      ),
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 0),
              () {
            posFunctions(callFunction: false);
          },
        );
      },
    );
  }

  // bool _isSelected = true;
  //
  // Future<void> _showMultipleTextFieldDialog(BuildContext context) async {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return AlertDialog(
  //
  //              content: Column(
  //               mainAxisSize: MainAxisSize.max,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Row(
  //                   children: <Widget>[
  //                     Checkbox(
  //                       value: _isSelected,
  //                       onChanged: ( newValue) {
  //                         setState(() {
  //                           _isSelected = newValue!;
  //                         });
  //                       },
  //                     ),
  //                     Text('Show Image',style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),),
  //                   ],
  //                 ),
  //
  //                 Text("Set Font Size",style: customisedStyle(context, Colors.black, FontWeight.w600, 13.0),),
  //                 Row(
  //                   children: [
  //                     Text("Product",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //                     SizedBox(width: 15,),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/3,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: productFontSizeController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("Description",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //                     SizedBox(width: 15,),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/3,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: descriptionFontSizeController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("Unit Name",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //                     SizedBox(width: 15,),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/3,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: unitNameFontSizeController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("Rate",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //                     SizedBox(width: 15,),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/3,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: rateFontSizeController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   children: [
  //                     Text("Buttons",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //                     SizedBox(width: 15,),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/3,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: buttonsFontSizeController,
  //                         decoration: InputDecoration(hintText: ''),
  //                       ),
  //                     ),
  //
  //                   ],
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text("Product List Box Adjustment",style: customisedStyle(context, Colors.black, FontWeight.w600, 13.0),),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Width",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/6,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: widthController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Height",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/6,
  //                       child: TextField(
  //                         inputFormatters: [
  //                           FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  //                         ],
  //                         controller: heightController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Count of Row",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/6,
  //                       child: TextField(
  //                         controller: enableAddProductController,
  //                         decoration: InputDecoration(hintText: 'Enter value 1'),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Button width",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/6,
  //                       child: TextField(
  //                         controller: numberKeyController,
  //                         decoration: InputDecoration(hintText: ''),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Text("Button height",style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),),
  //
  //                     Container(
  //                       width: MediaQuery.of(context).size.width/6,
  //                       child: TextField(
  //                         controller: buttonHeightController,
  //                         decoration: InputDecoration(hintText: ''),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //
  //               ],
  //             ),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('CANCEL'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //               TextButton(
  //                 child: Text('OK'),
  //                 onPressed: () async {
  //                  setState(() {
  //
  //                      productFontSize = double.parse(productFontSizeController.text);
  //                     // rowCountGridView=int.parse(enableAddProductController.text);
  //                     //  descriptionFontSize= double.parse(descriptionFontSizeController.text);
  //                     //  unitNameFontSize= double.parse(unitNameFontSizeController.text);
  //                     //  rateFontSize= double.parse(rateFontSizeController.text);
  //                     //  buttonsFontSize= double.parse(buttonsFontSizeController.text);
  //                     //  widthOFTable=double.parse(widthController.text);
  //                     //  heightOFTable= double.parse(heightController.text);
  //
  //
  //                  });
  //                  // String value2 = _textFieldController2.text;
  //                  // bool printSecondCopy = _printSecondCopy;
  //                  await  posFunctions(callFunction: true);
  //
  //
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  /// table resrve api call method
  reserveTable(customerName, tableID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/pos-table-reserve/';

        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "Table": tableID,
          "CustomerName": customerName,
          "Date": apiDateFormat.format(reservationDate.value),
          "FromTime": timeFormatApiFormat.format(timeNotifierFromTime.value),
          "ToTime": timeFormatApiFormat.format(timeNotifierToTime.value),
        };

        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        print(status);
        if (status == 6000) {
          reservationCustomerNameController.clear();
          Navigator.pop(context);
          dialogBoxHide(context, "Table reserved successfully");
          getTableOrderList();
          stop();
        } else if (status == 6001) {
          stop();
          var msg = n["message"] ?? n["errors"] ?? '';
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        stop();
      }
    }
  }

  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');

  late ValueNotifier<DateTime> reservationDate;
  late ValueNotifier<DateTime> timeNotifierFromTime;
  late ValueNotifier<DateTime> timeNotifierToTime;

  navigateToOrderSection(
      {required sectionType,
        required tableID,
        required UUID,
        required tableHead}) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => POSOrderSection(
            sectionType: sectionType,
            orderType: mainPageIndex,
            tableID: tableID,
            UUID: UUID,
            tableHead: tableHead,
          )),
    );

    if (result != null) {
      setState(() {
        mainPageIndex = result[0];
      });

      if (result[1]) {
        if (pay_perm) {
          navigateToPaymentFromOrder(
              UUID: result[2], tableID: result[3], tableHead: result[4]);
        } else {
          posFunctions(callFunction: true);
        }
      } else {
        posFunctions(callFunction: true);
      }
    }
  }

  redirectToOrder(sectionType) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => POSOrderSection(
            sectionType: sectionType,
            orderType: mainPageIndex,
            tableID: "",
            UUID: "",
            tableHead: "Take away",
          )),
    );
    posFunctions(callFunction: true);
  }

  navigateToPaymentFromOrder(
      {required tableID, required tableHead, required UUID}) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => POSOrderSection(
            sectionType: "",
            orderType: mainPageIndex,
            tableID: tableID,
            UUID: UUID,
            tableHead: tableHead,
          )),
    );
    if (result != null) {
      print("_________________________________$result");
      setState(() {
        mainPageIndex = result[0];
      });
    }

    if (directOrderOption) {
      redirectToOrder("Create");
    } else {
      posFunctions(callFunction: true);
    }
  }

  returnDiningListItem(dineIndex) {
    return GestureDetector(
        onTap: () {
          
          
          
          bool isInvoice = false;
          bool isConvert = false;
          bool paymentSection = false;
          bool isVacant = false;
          if (diningOrderList[dineIndex].status == "Paid") {
            isInvoice = true;
            isConvert = false;
            isVacant = false;
          }

          if (diningOrderList[dineIndex].status == "Vacant") {
            isInvoice = true;
            paymentSection = true;
            isConvert = false;
            isVacant = true;

            if (dining_create_perm) {
              navigateToOrderSection(
                  tableID: diningOrderList[dineIndex].tableId,
                  sectionType: "Create",
                  UUID: "",
                  tableHead: diningOrderList[dineIndex].title);
            } else {
              dialogBoxPermissionDenied(context);
            }
          } else if (diningOrderList[dineIndex].status == "Ordered") {
            print("-*/*-*/*-*/*-*/*/-*-*/*--#${diningOrderList[dineIndex].tableId}");
            paymentSection = false;
            isConvert = true;
            isVacant = false;
          }

          if (diningOrderList[dineIndex].status != "Vacant") {
            setState(() {
              selectedDiningIndex = dineIndex;
            });

            bottomSheetCustomised(
                context: context,
                tableIndex: dineIndex,
                sectionType: 1,
                status: diningOrderList[dineIndex].status,
                isInvoice: isInvoice,
                paymentSection: paymentSection,
                isReserve: true,
                tableID: diningOrderList[dineIndex].tableId,
                isConvert: isConvert,
                isVacant: isVacant,
                permissionToEdit: dining_edit_perm);
          }
        },
        onLongPress: () {
          var isInvoice = true;
          var paymentSection = true;
          var isConvert = false;
          var isVacant = true;

          if (diningOrderList[dineIndex].status == "Vacant") {
            bottomSheetCustomised(
                context: context,
                tableIndex: dineIndex,
                sectionType: 1,
                status: diningOrderList[dineIndex].status,
                isInvoice: isInvoice,
                paymentSection: paymentSection,
                isReserve: true,
                tableID: diningOrderList[dineIndex].tableId,
                isConvert: isConvert,
                isVacant: isVacant,
                permissionToEdit: dining_edit_perm);
          }

          // if (diningOrderList[dineIndex].status == "Ordered") {
          //
          //
          //   if(dining_edit_perm){
          //     navigateToOrderSection(tableID:diningOrderList[dineIndex].tableId,sectionType: "Edit",UUID:diningOrderList[dineIndex].salesOrderID,tableHead:diningOrderList[dineIndex].title);
          //   }
          //   else{
          //     dialogBoxPermissionDenied(context);
          //   }
          // }
        }, //
        child: AbsorbPointer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height /buttonHeight,
                child: DottedBorder(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/svg/table.svg',
                        height: 20,
                        width: 25,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(diningOrderList[dineIndex].title,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w800)),
                            Text(
                                returnOrderTime(
                                    diningOrderList[dineIndex].orderTime,
                                    diningOrderList[dineIndex].status),
                                //'Table 1',
                                style: const TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(returnText(diningOrderList[dineIndex].status),
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w700, 12.00)),
                    // Row(
                    //   children: [
                    //     Text(currency + ". " +
                    //         roundStringWith(
                    //             diningOrderList[dineIndex].status != "Vacant"?
                    //             diningOrderList[dineIndex].salesOrderGrandTotal:'0'),
                    //         style: customisedStyle(context, Colors.black, FontWeight.bold, 12.00)),
                    //     // Text
                    //   ],
                    // ),

                    Row(
                      children: [
                        Text(
                            currency +
                                ". " +
                                roundStringWith(
                                    diningOrderList[dineIndex].status !=
                                        "Vacant"
                                        ? diningOrderList[dineIndex].status !=
                                        "Paid"
                                        ? diningOrderList[dineIndex]
                                        .salesOrderGrandTotal
                                        : diningOrderList[dineIndex]
                                        .salesGrandTotal
                                        : '0'),
                            style: customisedStyle(context, Colors.black,
                                FontWeight.bold, amountFontSize)),
                        // Text
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / buttonHeight,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width /
                          returnWidth(dineIndex),
                      height: MediaQuery.of(context).size.height / 16,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                          buttonColor(diningOrderList[dineIndex].status),
                          textStyle: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          diningOrderList[dineIndex].status,
                          style: customisedStyle(context, Colors.black,
                              FontWeight.w400, buttonFontSize),
                        ),
                      ),
                    ),
                    diningOrderList[dineIndex].reserved.isNotEmpty
                        ? Container(
                      // color: Colors.grey,
                      width: MediaQuery.of(context).size.width / 9,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reservation'.tr,
                              style: customisedStyle(
                                  context,
                                  const Color(0xff00775E),
                                  FontWeight.w500,
                                  10.0),
                            ),
                            Column(
                              // mainAxisAlignment:MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateConverter(diningOrderList[dineIndex]
                                      .reserved[0]["Date"]),
                                  style: customisedStyle(
                                      context,
                                      const Color(0xff707070),
                                      FontWeight.w500,
                                      10.0),
                                ),
                                Text(
                                  ReturnDate(
                                      diningOrderList[dineIndex]
                                          .reserved[0]["Date"],
                                      diningOrderList[dineIndex]
                                          .reserved[0]["FromTime"],
                                      diningOrderList[dineIndex]
                                          .reserved[0]["ToTime"]),
                                  style: customisedStyle(
                                      context,
                                      const Color(0xff707070),
                                      FontWeight.w500,
                                      9.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  returnWidth(dineIndex) {
    if (diningOrderList[dineIndex].reserved.isNotEmpty) {
      return 12;
    } else {
      return 5;
    }
  }

  dateConverter(String dt) {
    DateTime todayDate = DateTime.parse(dt);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    var asd = formatter.format(todayDate);
    return asd;
  }

  ReturnDate(date, timeString, toTime) {
    DateTime time = DateTime.parse(date + " " + timeString);
    DateTime timeTo = DateTime.parse(date + " " + toTime);
    String formattedTime = DateFormat("hh:mm:ss a").format(time);
    String formattedToTime = DateFormat("hh:mm:ss a").format(timeTo);
    return "${formattedTime}-$formattedToTime";
  }

  void dispose() {
    super.dispose();
    stop();
  }

  returnText(type) {
    if (type == "Vacant") {
      return "";
    } else if (type == "Paid") {
      return "Paid :";
    } else {
      return "To Be Paid :";
    }
  }

  /// edit order

  convertStringToDouble(var amt) {
    var a = "$amt";
    var rtn = double.parse(a);
    return rtn;
  }

  /// create table
  /// printing function
  var printHelperUsb = USBPrintClass();
  var printHelperIP = AppBlocs();
  var bluetoothHelper = AppBlocsBT();
  var printHelperNew = USBPrintClassTest();

  printDetail(isCancelled, id, voucherType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    var temp = prefs.getString("template") ?? "template4";
    if (defaultIp == "") {
      dialogBox(context, "Please select a default printer");
    } else {
      if (printType == 'Wifi') {
        var ret = await printHelperIP.printDetails();
        print("==========ret $ret");
        if (ret == 2) {
          var ip = "";
          if (PrintDataDetails.type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }

          printHelperIP.print_receipt(ip, context, isCancelled);
        } else {
          dialogBox(context, 'Please try again later1');
        }
      } else if (printType == 'USB') {
        if (temp == "template5") {
          printHelperNew.printDetails(
              id: id, type: voucherType, context: context);
        } else {
          var ret = await printHelperUsb.printDetails();
          if (ret == 2) {
            var ip = "";
            if (PrintDataDetails.type == "SO") {
              ip = defaultOrderIP;
            } else {
              ip = defaultIp;
            }
            printHelperUsb.printReceipt(ip, context);
          } else {
            dialogBox(context, 'Please try again later');
          }
        }
      } else {
        var loadData =
        await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
        if (loadData) {
          var printStatus = await bluetoothHelper.scan(isCancelled);
          if (printStatus == 1) {
            dialogBox(context, "Check your bluetooth connection");
          } else if (printStatus == 2) {
            dialogBox(context, "Your default printer configuration problem");
          } else if (printStatus == 3) {
            await bluetoothHelper.scan(isCancelled);
            // alertMessage("Try again");
          } else if (printStatus == 4) {
            //  alertMessage("Printed successfully");
          }
        } else {
          dialogBox(context, "Try again");
        }
      }

      /// bluetooth option commented
    }
  }

  // ReprintKOT(id) async {
  //   printHelper.printKotPrintRe(id);
  // }

  ReprintKOT(orderID, isCancelled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    var temp = prefs.getString("template") ?? "template4";
    if (printType == 'Wifi') {
      var loadData =
      printHelperIP.printKotPrint(orderID, true, [], false, isCancelled);
    } else if (printType == 'BT') {
      bluetoothHelper.bluetoothPrintKOT(orderID, true, [], false, isCancelled);
    } else {
      if (temp == "template5") {
        printHelperNew.printKotPrint(orderID, true, [], isCancelled);
      } else {
        var loadData = printHelperUsb.printKotPrint(orderID, true, [], false);
      }
    }
  }

  returnCancelHead(status) {
    if (status == "Ordered") {
      return "Cancel_order".tr;
    } else {
      return "Clear".tr;
    }
  }

  void bottomSheetCustomised(
      {required BuildContext context,
        required int tableIndex,
        required int sectionType,
        required status,
        required bool isInvoice,
        required bool paymentSection,
        required bool isReserve,
        required String tableID,
        required bool isConvert,
        required bool isVacant,
        required bool permissionToEdit}) {
    showModalBottomSheet<void>(
        context: context,
        isDismissible: true,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      permissionToEdit
                          ? status == "Ordered"
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectedDiningIndex = 1000;
                                    if (sectionType == 1) {
                                      navigateToOrderSection(
                                          tableID: "",
                                          sectionType: "Edit",
                                          UUID: diningOrderList[tableIndex]
                                              .salesOrderID,
                                          tableHead: "Order");
                                    } else if (sectionType == 2) {
                                      navigateToOrderSection(
                                          tableID: "",
                                          sectionType: "Edit",
                                          UUID:
                                          takeAwayOrderLists[tableIndex]
                                              .salesOrderId,
                                          tableHead: "Order");
                                    } else if (sectionType == 3) {
                                      navigateToOrderSection(
                                          tableID: "",
                                          sectionType: "Edit",
                                          UUID: onlineOrderLists[tableIndex]
                                              .salesOrderId,
                                          tableHead: "Order");
                                    } else if (sectionType == 4) {
                                      navigateToOrderSection(
                                          tableID: "",
                                          sectionType: "Edit",
                                          UUID: carOrderLists[tableIndex]
                                              .salesOrderId,
                                          tableHead: "Order");
                                    }
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/svg/Edit_Icon.svg',
                                  ),

                                  // iconSize: 50
                                ),
                                Text(
                                  "edit".tr,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container()
                          : Container(),

                      print_perm
                          ? isVacant == false
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedDiningIndex = 1000;

                                        if (sectionType == 1) {
                                          if (diningOrderList[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SO";
                                            PrintDataDetails.id =
                                                diningOrderList[tableIndex]
                                                    .salesOrderID;
                                            printDetail(
                                                false,
                                                diningOrderList[tableIndex]
                                                    .salesOrderID,
                                                "SO");
                                          }
                                          if (diningOrderList[tableIndex]
                                              .status ==
                                              "Paid") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SI";
                                            PrintDataDetails.id =
                                                diningOrderList[tableIndex]
                                                    .salesMasterID;
                                            printDetail(
                                                false,
                                                diningOrderList[tableIndex]
                                                    .salesMasterID,
                                                "SI");
                                          }
                                        } else if (sectionType == 2) {
                                          if (takeAwayOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SO";
                                            PrintDataDetails.id =
                                                takeAwayOrderLists[
                                                tableIndex]
                                                    .salesOrderId;
                                            printDetail(
                                                false,
                                                takeAwayOrderLists[
                                                tableIndex]
                                                    .salesOrderId,
                                                "SO");
                                          }
                                          if (takeAwayOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SI";
                                            PrintDataDetails.id =
                                                takeAwayOrderLists[
                                                tableIndex]
                                                    .salesId;
                                            printDetail(
                                                false,
                                                takeAwayOrderLists[
                                                tableIndex]
                                                    .salesId,
                                                "SI");
                                          }
                                        } else if (sectionType == 3) {
                                          if (onlineOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SO";
                                            PrintDataDetails.id =
                                                onlineOrderLists[tableIndex]
                                                    .salesOrderId;

                                            printDetail(
                                                false,
                                                onlineOrderLists[tableIndex]
                                                    .salesOrderId,
                                                "SO");
                                          }

                                          if (onlineOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SI";
                                            PrintDataDetails.id =
                                                onlineOrderLists[tableIndex]
                                                    .salesId;

                                            printDetail(
                                                false,
                                                onlineOrderLists[tableIndex]
                                                    .salesId,
                                                "SI");
                                          }
                                        } else if (sectionType == 4) {
                                          if (carOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SO";
                                            PrintDataDetails.id =
                                                carOrderLists[tableIndex]
                                                    .salesOrderId;

                                            printDetail(
                                                false,
                                                carOrderLists[tableIndex]
                                                    .salesOrderId,
                                                "SO");
                                          }
                                          if (carOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            Navigator.pop(context);
                                            PrintDataDetails.type = "SI";
                                            PrintDataDetails.id =
                                                carOrderLists[tableIndex]
                                                    .salesId;

                                            printDetail(
                                                false,
                                                carOrderLists[tableIndex]
                                                    .salesId,
                                                "SI");
                                          }
                                        }
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/print_image.svg',
                                    ),
                                    iconSize: 60),
                                Text(
                                  "print".tr,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container()
                          : Container(),

                      isVacant == false
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedDiningIndex = 1000;
                                        if (sectionType == 1) {
                                          if (diningOrderList[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            if (cancel_order_perm) {
                                              cancelId =
                                                  diningOrderList[tableIndex]
                                                      .tableId;
                                              Navigator.pop(context);
                                              cancelReason(
                                                  context,
                                                  sectionType,
                                                  diningOrderList[tableIndex]
                                                      .salesOrderID);
                                            } else {
                                              Navigator.pop(context);
                                              dialogBoxPermissionDenied(
                                                  context);
                                            }
                                          }
                                          if (diningOrderList[tableIndex]
                                              .status ==
                                              "Paid") {
                                            var deleteId =
                                                diningOrderList[tableIndex]
                                                    .tableId;
                                            var type = "Dining";
                                            Navigator.pop(context);
                                            delete(type, deleteId, "", "");
                                          }
                                        } else if (sectionType == 2) {
                                          if (takeAwayOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            if (cancel_order_perm) {
                                              cancelId =
                                                  takeAwayOrderLists[tableIndex]
                                                      .salesOrderId;
                                              Navigator.pop(context);
                                              cancelReason(
                                                  context,
                                                  sectionType,
                                                  takeAwayOrderLists[tableIndex]
                                                      .salesOrderId);
                                            } else {
                                              Navigator.pop(context);
                                              dialogBoxPermissionDenied(
                                                  context);
                                            }
                                          }
                                          if (takeAwayOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            var deleteId =
                                                takeAwayOrderLists[tableIndex]
                                                    .salesOrderId;
                                            var type = "TakeAway";
                                            Navigator.pop(context);
                                            delete(type, deleteId, "", "");
                                          }
                                        } else if (sectionType == 3) {
                                          if (onlineOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            if (cancel_order_perm) {
                                              cancelId =
                                                  onlineOrderLists[tableIndex]
                                                      .salesOrderId;
                                              Navigator.pop(context);
                                              cancelReason(
                                                  context,
                                                  sectionType,
                                                  onlineOrderLists[tableIndex]
                                                      .salesOrderId);
                                            } else {
                                              Navigator.pop(context);
                                              dialogBoxPermissionDenied(
                                                  context);
                                            }
                                          }

                                          if (onlineOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            var deleteId =
                                                onlineOrderLists[tableIndex]
                                                    .salesOrderId;
                                            var type = "Online";
                                            Navigator.pop(context);
                                            delete(type, deleteId, "", "");
                                            // OnlineCar
                                          }
                                        } else if (sectionType == 4) {
                                          if (carOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            if (cancel_order_perm) {
                                              cancelId =
                                                  carOrderLists[tableIndex]
                                                      .salesOrderId;
                                              Navigator.pop(context);
                                              cancelReason(
                                                  context,
                                                  sectionType,
                                                  carOrderLists[tableIndex]
                                                      .salesOrderId);
                                            } else {
                                              Navigator.pop(context);
                                              dialogBoxPermissionDenied(
                                                  context);
                                            }
                                          }
                                          if (carOrderLists[tableIndex]
                                              .status ==
                                              "Paid") {
                                            var deleteId =
                                                carOrderLists[tableIndex]
                                                    .salesOrderId;
                                            var type = "Car";
                                            Navigator.pop(context);
                                            delete(type, deleteId, "", "");
                                          }
                                        }
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/cancelorder.svg',
                                    ),
                                    iconSize: 60),
                                Text(
                                  returnCancelHead(status),
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container(),

                      pay_perm
                          ? paymentSection == false
                          ? isInvoice == false
                          ? SizedBox(
                          height:
                          MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (sectionType == 1) {
                                        if (diningOrderList[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          tableID = diningOrderList[
                                          tableIndex]
                                              .tableId;
                                          Navigator.pop(context);
                                          navigateToOrderSection(
                                              tableID: tableID,
                                              sectionType: "Payment",
                                              UUID: diningOrderList[
                                              tableIndex]
                                                  .salesOrderID,
                                              tableHead: "");
                                        }
                                      } else if (sectionType == 2) {
                                        if (takeAwayOrderLists[
                                        tableIndex]
                                            .status ==
                                            "Ordered") {
                                          tableID = "";
                                          //   mainPageIndex = 6;
                                          Navigator.pop(context);
                                          //  navigateToOrderSection(tableID:tableID,sectionType: "Payment",UUID:diningOrderList[tableIndex].salesOrderID,tableHead:"Parcel");
                                          navigateToOrderSection(
                                              tableID: "",
                                              sectionType: "Payment",
                                              UUID: takeAwayOrderLists[
                                              tableIndex]
                                                  .salesOrderId,
                                              tableHead: "Parcel ");
                                        }
                                      } else if (sectionType == 3) {
                                        if (onlineOrderLists[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          tableID = "";
                                          //     mainPageIndex = 6;
                                          Navigator.pop(context);
                                          navigateToOrderSection(
                                              tableID: "",
                                              sectionType: "Payment",
                                              UUID: onlineOrderLists[
                                              tableIndex]
                                                  .salesOrderId,
                                              tableHead: "Online ");
                                        }
                                      } else if (sectionType == 4) {
                                        if (carOrderLists[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          tableID = "";
                                          // mainPageIndex = 6;
                                          Navigator.pop(context);
                                          navigateToOrderSection(
                                              tableID: "",
                                              sectionType: "Payment",
                                              UUID: carOrderLists[
                                              tableIndex]
                                                  .salesOrderId,
                                              tableHead: "Online ");
                                        }
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/pay.svg',
                                    ),
                                    iconSize: 60),
                                Text(
                                  "pay".tr,
                                  style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w600,
                                      12.00),
                                )
                              ]))
                          : Container()
                          : Container()
                          : Container(),

                      kitchen_print_perm
                          ? paymentSection == false
                          ? isInvoice == false
                          ? SizedBox(
                          height:
                          MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      print(
                                          "objectobjectobjectobjectobjectobjectobjectobject");
                                      setState(() {
                                        selectedDiningIndex = 1000;

                                        print(
                                            diningOrderList[tableIndex]
                                                .salesOrderID);
                                        if (sectionType == 1) {
                                          if (diningOrderList[
                                          tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            ReprintKOT(
                                                diningOrderList[
                                                tableIndex]
                                                    .salesOrderID,
                                                false);
                                          }
                                        } else if (sectionType == 2) {
                                          if (takeAwayOrderLists[
                                          tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            ReprintKOT(
                                                takeAwayOrderLists[
                                                tableIndex]
                                                    .salesOrderId,
                                                false);
                                          }
                                        } else if (sectionType == 3) {
                                          if (onlineOrderLists[
                                          tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            ReprintKOT(
                                                onlineOrderLists[
                                                tableIndex]
                                                    .salesOrderId,
                                                false);
                                          }
                                        } else if (sectionType == 4) {
                                          if (carOrderLists[tableIndex]
                                              .status ==
                                              "Ordered") {
                                            Navigator.pop(context);
                                            ReprintKOT(
                                                carOrderLists[
                                                tableIndex]
                                                    .salesOrderId,
                                                false);
                                          }
                                        }
                                      });
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/KOT.svg',
                                    ),
                                    iconSize: 60),
                                Text(
                                  "kit_print".tr,
                                  style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w600,
                                      12.00),
                                )
                              ]))
                          : Container()
                          : Container()
                          : Container(),

                      reservation_perm
                          ? isReserve
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    'assets/svg/reserve.svg',
                                  ),
                                  iconSize: 60,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showPopup(
                                        context,
                                        diningOrderList[tableIndex]
                                            .tableId);
                                  },
                                ),
                                Text(
                                  "reserve".tr,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container()
                          : Container(),

                      remove_table_perm
                          ? isReserve
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 12,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/svg/remove_table.svg",
                                  ),
                                  iconSize: 60,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    removeTable(
                                        diningOrderList[tableIndex].status,
                                        diningOrderList[tableIndex].title);

                                    //   showPopup(context,diningOrderList[tableIndex].tableId);
                                  },
                                ),
                                Text(
                                  "Remove_table".tr,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container()
                          : Container(),

                      convert_type_perm
                          ? isConvert == true
                          ? SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      if (sectionType == 1) {
                                        Navigator.pop(context);

                                        convertSalesType(
                                            sectionType: sectionType,
                                            tableID:
                                            diningOrderList[tableIndex]
                                                .tableId,
                                            voucherNumber: "token",
                                            salesOrderID:
                                            diningOrderList[tableIndex]
                                                .salesOrderID);
                                      } else if (sectionType == 2) {
                                        if (takeAwayOrderLists[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          Navigator.pop(context);
                                          convertSalesType(
                                              sectionType: sectionType,
                                              tableID: "",
                                              salesOrderID:
                                              takeAwayOrderLists[
                                              tableIndex]
                                                  .salesOrderId);
                                        }
                                      } else if (sectionType == 3) {
                                        if (onlineOrderLists[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          Navigator.pop(context);
                                          convertSalesType(
                                              sectionType: sectionType,
                                              tableID: "",
                                              salesOrderID:
                                              onlineOrderLists[
                                              tableIndex]
                                                  .salesOrderId);
                                        }
                                      } else if (sectionType == 4) {
                                        if (carOrderLists[tableIndex]
                                            .status ==
                                            "Ordered") {
                                          Navigator.pop(context);
                                          convertSalesType(
                                              sectionType: sectionType,
                                              tableID: "",
                                              salesOrderID:
                                              carOrderLists[tableIndex]
                                                  .salesOrderId);
                                        }
                                      }
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/svg/convert.svg',
                                    ),
                                    iconSize: 60),
                                Text(
                                  "convert".tr,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w600, 12.00),
                                )
                              ]))
                          : Container()
                          : Container()

                      // sectionType ==1? ReserveButton():Container(),
                    ],
                  ),
                );
              });
        }).then((value) {
      setState(() {
        selectedDiningIndex = 1000;
        selectedTakeAwayIndex = 1000;
        selectedOnlineIndex = 1000;
        selectedCarIndex = 1000;
      });
    });
  }

  removeTable(status, tableName) async {
    if (status == "Vacant") {
      var navigateResult = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color(0xff415369),
            title: Text("Are you sure?",
                style: customisedStyle(
                    context, Colors.white, FontWeight.w600, 14.0)),
            content: Text("Want to delete $tableName from list",
                style: customisedStyle(
                    context, Colors.white, FontWeight.normal, 12.0)),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No",
                    style: customisedStyle(
                        context, Colors.white, FontWeight.w600, 14.0)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes",
                    style: customisedStyle(
                        context, Colors.white, FontWeight.w600, 14.0)),
              ),
            ],
          );
        },
      );

      if (navigateResult!) {
        deleteAnItem(tableName);
        //  Navigator.pop(context);
      }
    } else if (status == "Paid") {
      dialogBox(context, "Clear this table before you delete");
    } else {
      dialogBox(context, "Already order placed, cant delete");
    }
  }

  Future<Null> deleteAnItem(tableName) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your network connection");
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;

        final String url = '$baseUrl/posholds/table-delete/';
        print(url);
        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "BranchID": branchID,
          "TableName": tableName
        };

        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        var msgs = n["message"];
        print(msgs);
        print(response.body);

        print(status);
        if (status == 6000) {
          stop();
          dialogBoxHide(context, "Successfully deleted table");
          posFunctions(callFunction: true);
        } else if (status == 6001) {
          stop();
          var msg = n["message"] ?? "";
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        dialogBox(context, "Some thing went wrong");
        stop();
      }
    }
  }

  /// convert sales type

  void diningDesign({required context, section_type, required salesOrderID}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
              title: Text(
                'Select table',
                style: customisedStyle(
                    context, Colors.black, FontWeight.w600, 15.0),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width /
                    1.2, // Set the width of the alert box
                child: GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: 4, top: 20, right: 0, bottom: 6),
                    shrinkWrap: true,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: diningOrderList.length,
                    itemBuilder: (BuildContext context, int dineIndex) {
                      return Opacity(
                          opacity: diningOrderList[dineIndex].status == "Vacant"
                              ? 1
                              : 0.10,
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff8D8D8D),
                                    width: 1.7,
                                  )),
                              child: GestureDetector(
                                  onTap: () async {
                                    if (diningOrderList[dineIndex].status !=
                                        "Vacant") {
                                      // Navigator.pop(context);
                                      // dialogBox(context, "this table is not vacant");
                                    } else {
                                      var response = await convertSalesTypeAPI(
                                          context: context,
                                          type: "Dining",
                                          is_table_vacant: false,
                                          salesOrderID: salesOrderID,
                                          table_id: diningOrderList[dineIndex]
                                              .tableId);
                                      if (response[0] == 6000) {
                                        Navigator.pop(context);
                                        dialogBoxHide(context,
                                            "SaleType Changed Successfully");
                                        posFunctions(callFunction: true);
                                      } else {
                                        Navigator.pop(context);
                                        dialogBox(context, response[1]);
                                      }
                                    }
                                  },
                                  child: AbsorbPointer(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              5,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              18,
                                          child: DottedBorder(
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svg/table.svg',
                                                  height: 20,
                                                  width: 25,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                          diningOrderList[
                                                          dineIndex]
                                                              .title,
                                                          style: const TextStyle(
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800)),
                                                      Text(
                                                          returnOrderTime(
                                                              diningOrderList[
                                                              dineIndex]
                                                                  .orderTime,
                                                              diningOrderList[
                                                              dineIndex]
                                                                  .status),
                                                          //'Table 1',
                                                          style: const TextStyle(
                                                              fontSize: 10.0,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w800)),
                                                    ],
                                                  ),
                                                ),
                                                Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  returnText(
                                                      diningOrderList[dineIndex]
                                                          .status),
                                                  style: customisedStyle(
                                                      context,
                                                      Colors.black,
                                                      FontWeight.w700,
                                                      12.00)),
                                              Row(
                                                children: [
                                                  Text(
                                                      currency +
                                                          ". " +
                                                          roundStringWith(diningOrderList[
                                                          dineIndex]
                                                              .status !=
                                                              "Vacant"
                                                              ? diningOrderList[
                                                          dineIndex]
                                                              .salesOrderGrandTotal
                                                              : '0'),
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.bold,
                                                          12.00)),
                                                  // Text
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              returnWidth(dineIndex),
                                          height: MediaQuery.of(context)
                                              .size
                                              .height /
                                              15,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: buttonColor(
                                                  diningOrderList[dineIndex]
                                                      .status),
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                            onPressed: () {},
                                            child: Text(
                                              diningOrderList[dineIndex].status,
                                              style: customisedStyle(
                                                  context,
                                                  Colors.black,
                                                  FontWeight.w400,
                                                  13.00),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))));
                    }),
              )),
        );
      },
    );
  }

  void convertSalesType(
      {sectionType, voucherNumber, tableID, required salesOrderID}) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: const Color(0xff415369),
            title: Text("Are you sure?",
                style: customisedStyle(
                    context, Colors.white, FontWeight.w600, 14.0)),
            content: Container(
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                children: [
                  Text("Select an type to Convert order",
                      style: customisedStyle(
                          context, Colors.white, FontWeight.normal, 12.0)),
                  sectionType != 1
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor:
                      Colors.transparent, // Background color
                    ),
                    child: Text(
                      'Dining'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      diningDesign(
                          context: context,
                          section_type: sectionType,
                          salesOrderID: salesOrderID);
                      // convertDiningTo(context: context,section_type: sectionType,salesOrderID:salesOrderID);
                      // Dining
                    },
                  )
                      : Container(),
                  sectionType != 2
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor:
                      Colors.transparent, // Background color
                    ),
                    child: Text(
                      'Take_awy'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                    ),
                    onPressed: () async {
                      var response = await convertSalesTypeAPI(
                          context: context,
                          type: "TakeAway",
                          is_table_vacant:
                          sectionType == 1 ? true : false,
                          salesOrderID: salesOrderID,
                          table_id: tableID);
                      if (response[0] == 6000) {
                        Navigator.pop(context);
                        dialogBoxHide(
                            context, "SaleType Changed Successfully");
                        posFunctions(callFunction: true);
                      } else {
                        Navigator.pop(context);
                        dialogBox(context, response[1]);
                      }
                    },
                  )
                      : Container(),
                  sectionType != 4
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor:
                      Colors.transparent, // Background color
                    ),
                    child: Text(
                      'Car'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                    ),
                    onPressed: () async {
                      var response = await convertSalesTypeAPI(
                          context: context,
                          type: "Car",
                          is_table_vacant:
                          sectionType == 1 ? true : false,
                          salesOrderID: salesOrderID,
                          table_id: tableID);
                      if (response[0] == 6000) {
                        Navigator.pop(context);
                        dialogBoxHide(
                            context, "SaleType Changed Successfully");
                        posFunctions(callFunction: true);
                      } else {
                        Navigator.pop(context);
                        dialogBox(context, response[1]);
                      }

                      // Car
                    },
                  )
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.transparent, // Background color
                ),
                child: Text(
                  'cancel'.tr,
                  style: customisedStyle(
                      context, Colors.red, FontWeight.w500, 14.0),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0.0,
              //     backgroundColor: Colors.transparent, // Background color
              //   ),
              //   child: Text(
              //     'Cancel',
              //     style: customisedStyle(context, Colors.red, FontWeight.w500, 14.0),
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
              //
              // sectionType !=1? ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0.0,
              //     backgroundColor: Colors.transparent, // Background color
              //   ),
              //   child: Text(
              //     'To Dining',
              //     style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              //   ),
              //   onPressed: () {
              //
              //
              //   },
              // ):Container(),
              //
              // sectionType !=2?  ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0.0,
              //     backgroundColor: Colors.transparent, // Background color
              //   ),
              //   child: Text(
              //     'To Take away',
              //     style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              //   ),
              //   onPressed: () {
              //
              //   },
              // ):Container(),
              //
              // sectionType !=4?
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     elevation: 0.0,
              //     backgroundColor: Colors.transparent, // Background color
              //   ),
              //   child: Text(
              //     'To Car',
              //     style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              //   ),
              //   onPressed: () {
              //
              //
              //   },
              // ):Container(),
              //
              //
            ]);
      },
    );
  }

  convertSalesTypeAPI(
      {required context,
        required salesOrderID,
        required type,
        required is_table_vacant,
        required table_id}) async {
    final response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = BaseUrl.baseUrl;
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      final url = '$baseUrl/posholds/change-sale_type/';

      print(url);
      print(accessToken);

      Map data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "SalesOrderMasterID": salesOrderID,
        "Type": type,
        "is_table_vacant": is_table_vacant,
        "table_id": table_id
      };
      print(data);

      print(data);

      var body = json.encode(data);
      print(url);
      print(accessToken);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      Map n = json.decode(utf8.decode(response.bodyBytes));
      print(response.body);

      var status = n["StatusCode"];
      var responseJson = n["data"];
      print("_________res from api $responseJson");
      return [status, responseJson];
    } catch (e) {
      print(e.toString());
      return [500, "Error"];
    }
  }

  createTable(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.grey,
            title: const Text("Create Table"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 16,
                    child: TextField(
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w400, 14.0),
                      controller: tableNameController,
                      //  focusNode: nameFcNode,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, right: 10, bottom: 10),
                          filled: true,
                          suffixStyle: const TextStyle(
                            color: Colors.red,
                          ),
                          hintStyle: customisedStyle(context,
                              const Color(0xff858585), FontWeight.w400, 14.0),
                          hintText: "Table name",
                          fillColor: const Color(0xffffffff)),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    decoration: BoxDecoration(
                        color: const Color(0xffF25F29),
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                      onPressed: () {
                        if (tableNameController.text == "") {
                          dialogBox(context, "Please enter table name");
                        } else {
                          createTableApi();
                        }
                      },
                      child: const Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  // Other text fields and buttons
                ],
              ),
            ));
      },
    ).then((value) {
      setState(() {
        selectedDiningIndex = 1000;
      });
    });
  }

  showPopup(BuildContext context, tableID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.grey,
            title: const Text("Reserve For Later"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.height / 20,
                    child: TextField(
                      style: customisedStyle(
                          context, Colors.grey, FontWeight.w400, 14.0),
                      controller: reservationCustomerNameController,
                      //  focusNode: nameFcNode,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, right: 10, bottom: 10),
                          filled: true,
                          suffixStyle: const TextStyle(
                            color: Colors.red,
                          ),
                          hintStyle: customisedStyle(context,
                              const Color(0xff858585), FontWeight.w400, 14.0),
                          hintText: "Customer name",
                          fillColor: const Color(0xffffffff)),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  ValueListenableBuilder(
                      valueListenable: reservationDate,
                      builder: (BuildContext ctx, DateTime dateNewValue, _) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  Date",
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    dateFormat.format(dateNewValue),
                                    style: customisedStyle(context, Colors.grey,
                                        FontWeight.w400, 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            showDatePickerFunction(context, reservationDate);
                          },
                        );
                      }),
                  // timeNotifierFromDate
                  // timeNotifierToDate
                  const SizedBox(
                    height: 8,
                  ),
                  ValueListenableBuilder(
                      valueListenable: timeNotifierFromTime,
                      builder: (BuildContext ctx, DateTime dateNewValue, _) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  From",
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    timeFormat.format(dateNewValue),
                                    style: customisedStyle(context, Colors.grey,
                                        FontWeight.w400, 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              timeNotifierFromTime.value = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());
                            } else {
                              print("Time is not selected");
                            }
                          },
                        );
                      }),
                  const SizedBox(
                    height: 8,
                  ),

                  ValueListenableBuilder(
                      valueListenable: timeNotifierToTime,
                      builder: (BuildContext ctx, DateTime dateNewValue, _) {
                        return GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height / 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "  To",
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    timeFormat.format(dateNewValue),
                                    style: customisedStyle(context, Colors.grey,
                                        FontWeight.w400, 14.0),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              timeNotifierToTime.value = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());
                            } else {
                              print("Time is not selected");
                            }
                          },
                        );
                      }),

                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        color: const Color(0xffF25F29),
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                      onPressed: () {
                        if (reservationCustomerNameController.text == "") {
                          dialogBox(context, "Please enter customer name");
                        } else {
                          reserveTable(
                              reservationCustomerNameController.text, tableID);
                        }
                      },
                      child: const Text(
                        "Reserve",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height / 18,
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(4)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'cancel'.tr,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  // Other text fields and buttons
                ],
              ),
            ));
      },
    ).then((value) {
      setState(() {
        selectedDiningIndex = 1000;
      });
    });
  }

  void cancelReason(BuildContext context, section_type, orderID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AlertDialog(
            title: Text(
              'Select an reason for cancel',
              style:
              customisedStyle(context, Colors.black, FontWeight.w600, 15.0),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width /
                  3, // Set the width of the alert box
              child: ListView.builder(
                itemExtent: MediaQuery.of(context).size.height / 16,
                itemCount: cancelReportList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                cancelReportList[index].reason,
                                style: customisedStyle(context, Colors.black,
                                    FontWeight.w500, 13.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () async {
                        //  cancelReasonId = cancelReportList[index].id;
                        String id = cancelId;
                        String cancelType = "";

                        if (section_type == 1) {
                          cancelType = "Dining&Cancel";
                        } else if (section_type == 2) {
                          cancelType = "Cancel";
                        } else if (section_type == 3) {
                          cancelType = "Cancel";
                        } else if (section_type == 4) {
                          cancelType = "Cancel";
                        }

                        Navigator.pop(context);
                        delete(cancelType, id, cancelReportList[index].id,
                            orderID);
                        // delete()
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  //
  // void cancelReason(BuildContext context, ind, section_type) {
  //   showModalBottomSheet<void>(
  //       context: context,
  //       isDismissible: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext context) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height / 3, // Change as per your requirement
  //           width: MediaQuery.of(context).size.width / 4, // Change as per your requirement
  //           child: ListView.builder(
  //             itemExtent: MediaQuery.of(context).size.height / 16,
  //             itemCount: cancelReportList.length,
  //             itemBuilder: (context, index) {
  //               return Card(
  //                 child: ListTile(
  //                   title: Column(
  //                     children: <Widget>[
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             cancelReportList[index].reason,
  //                             style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   onTap: () async {
  //                     //  cancelReasonId = cancelReportList[index].id;
  //                     String id = cancelId;
  //                     String cancelType = "";
  //
  //                     if (section_type == 1) {
  //                       cancelType = "Dining&Cancel";
  //                     }
  //                     else if (section_type == 2) {
  //                       cancelType = "Cancel";
  //                     }
  //                     else if (section_type == 3) {
  //                       cancelType = "Cancel";
  //                     }
  //                     else if (section_type == 4) {
  //                       cancelType = "Cancel";
  //                     }
  //
  //                     Navigator.pop(context);
  //                     delete(cancelType, id, cancelReportList[index].id);
  //                     // delete()
  //                   },
  //                 ),
  //               );
  //             },
  //           ),
  //         );
  //       });
  // }

  /// cancel order

  String cancelId = "";

  Future<Null> delete(String type, String id, cancelReasonId, orderID) async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
      dialogBox(context, "Check Your Connection");
    } else {
      try {
        if (type == "TakeAway" ||
            type == "Dining" ||
            type == "Online" ||
            type == "Car") {
          cancelReasonId = "";
        }
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        bool printForCancellOrder =
            prefs.getBool('print_for_cancel_order') ?? false;

        print("---------------------------------${id}");
        final String url = '$baseUrl/posholds/reset-status/';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "Type": type,
          "unqid": id,
          "reason_id": cancelReasonId,
        };
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));

        var status = n["StatusCode"];
        if (status == 6000) {
          stop();
          await getTableOrderList();

          if (cancelReasonId != "") {
            if (printForCancellOrder) {
              PrintDataDetails.type = "SO";
              PrintDataDetails.id = orderID;
              await printDetail(true, orderID, "SO");
              if (orderID != "") {
                await ReprintKOT(orderID, true);
              }
            }
          }
        } else if (status == 6001) {
          stop();
        } else {
          stop();
        }
      } catch (e) {
        stop();
        print(e);
        print('Error In Loading');
      }
    }
  }

  /// create table api
  createTableApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;


        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/table-create/';
        var suffix = "";

        var tableName = tableNameController.text;
        var name = suffix + tableName;


        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "TableName": name,
          "IsActive": true,
          "PriceCategoryID": "",
        };
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if(status == 6000) {
          stop();
          Navigator.pop(context);
          getTableOrderList();
          tableNameController.clear();
          dialogBoxHide(context, "Table created");
        }
        else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        stop();
      }
    }
  }

  Future<Null> getTableOrderList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        print(
            "----------------------------------------------------------------3");
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';
        var showInvoice = prefs.getBool('AutoClear') ?? true;
        final String url = '$baseUrl/posholds/pos-table-list/';
        print(
            "----------------------------------------------------------------4");
        print(accessToken);
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "type": "user",
          "paid": showInvoice
        };
        print(data);
        print(accessToken);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));

        log_data(response.body);
        print("a");
        var status = n["StatusCode"];
        var statusTable = n["DiningStatusCode"];
        print("a");
        var statusTakeAway = n["TakeAwayStatusCode"];
        var onlineStatus = n["OnlineStatusCode"];
        var carStatus = n["CarStatusCode"];
        print("a");
        var takeAway = n["TakeAway"];
        var online = n["Online"];
        var car = n["Car"];
        print("a");
        var responseJson = n["data"];
        var cancelData = n["Reasons"];
        // var takeawayStatus = n["TakeAwayStatusCode"];
        //
        print("a");
        // var Online = n["Online"];
        // var TakeAway = n["TakeAway"];
        // var Car = n["Car"];

        if (status == 6000) {
          setState(() {
            print("a");
            print(
                "----------------------------------------------------------------5");

            ///  check expiry date
            // var expiryDate = prefs.getString('expDate') ?? '';
            // print("=============+++++++++++++++============");
            // var dt = DateTime.parse(expiryDate);
            // print(dt);
            // print("=============+++++++++++++++============");
            //
            // var now = new DateTime.now();
            // print("__________________now");
            // print(now);
            // print("__________________dt");
            // print(dt);
            //
            print("u");
            diningOrderList.clear();
            takeAwayOrderLists.clear();
            carOrderLists.clear();
            print("j");
            onlineOrderLists.clear();
            cancelReportList.clear();
            print("w");
            currency = prefs.getString('CurrencySymbol') ?? "";
            stop();
            if (statusTable == 6000) {
              for (Map user in responseJson) {
                diningOrderList.add(DiningListModel.fromJson(user));
              }
            }
            // onlineList
            if (statusTakeAway == 6000) {
              for (Map user in takeAway) {
                takeAwayOrderLists.add(PosListModel.fromJson(user));
              }
            }
            print("h");
            // if (onlineStatus == 6000) {
            //   for (Map user in online) {
            //     onlineOrderLists.add(PosListModel.fromJson(user));
            //   }
            // }

            if (carStatus == 6000) {
              for (Map user in car) {
                carOrderLists.add(PosListModel.fromJson(user));
              }
            }

            print("b");
            for (Map user in cancelData) {
              cancelReportList.add(CancelReportModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        print("object${e.toString()}");
        stop();
      }
    }
  }

  /// take away section
  Widget takeAwayDetailScreen() {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xffEE830C),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 11,
            //height of button
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD6D6D6))),
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonAppBar(),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height /
                      11, //height of button
                  width: MediaQuery.of(context).size.width / 3.3,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take_awy'.tr,
                        //  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
                        style: customisedStyle(context, const Color(0xff717171),
                            FontWeight.bold, 15.00),
                      ),
                      Text('Create a parcel',
                          // style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 11.0),
                          style: customisedStyle(context,
                              const Color(0xff000000), FontWeight.w700, 12.00))
                    ],
                  ),
                ),

                UserDetailsAppBar(user_name: userName),
                // IconButton(
                //     onPressed: () {
                //       posFunctions();
                //
                //     },
                //     icon: SvgPicture.asset(
                //       'assets/svg/Refresh_icon.svg',
                //     ),
                //     iconSize: 110
                // ),
                Container(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0347A1)),
                    onPressed: () {
                      posFunctions(callFunction: true);
                    },
                    child: Text(
                      'Refresh'.tr,
                      style: customisedStyle(
                          context, Colors.white, FontWeight.w500, 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            //   height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: takeAwayOrderLists.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return returnTakeAwayListItem(index);
                }),
          ),
        ],
      ),
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 0),
              () {
            posFunctions(callFunction: true);
          },
        );
      },
    );
  }

  returnTakeAwayListItem(takeIndex) {
    if (takeAwayOrderLists.isEmpty) {
      return GestureDetector(
        child: Card(
            margin:
            const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
            child: DottedBorder(
                color: const Color(0xff8D8D8D),
                strokeWidth: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height / 4.5,
                  //height of button
                  width: MediaQuery.of(context).size.width / 4.5,
                  //   color: Colors.red,
                  child: Center(
                    child: Container(
                      //      color: Colors.red,
                      //  padding: EdgeInsets.all(7),
                      height: MediaQuery.of(context).size.height /
                          13, //height of button
                      width: MediaQuery.of(context).size.width / 18,
                      child: GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          if (take_away_create_perm) {
                            navigateToOrderSection(
                                tableID: "",
                                sectionType: "Create",
                                UUID: "",
                                tableHead: "Parcel");
                          } else {
                            dialogBoxPermissionDenied(context);
                          }
                        },
                      ),
                    ),
                  ),
                ))),
      );
    } else {
      if (takeIndex == takeAwayOrderLists.length) {
        return Card(
            margin:
            const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
            child: DottedBorder(
                color: const Color(0xff8D8D8D),
                strokeWidth: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height / 4.5,
                  width: MediaQuery.of(context).size.width / 4.5,
                  child: Center(
                    child: Container(
                      //   color: Colors.red,
                      //  padding: EdgeInsets.all(7),
                      height: MediaQuery.of(context).size.height /
                          12, //height of button
                      width: MediaQuery.of(context).size.width / 16,

                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (take_away_create_perm) {
                              navigateToOrderSection(
                                  tableID: "",
                                  sectionType: "Create",
                                  UUID: "",
                                  tableHead: "Parcel");
                            } else {
                              dialogBoxPermissionDenied(context);
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
      } else {
        return GestureDetector(
            onTap: () {
              print("-------------------");

              bool isInvoice = false;
              bool paymentSection = false;
              bool isConvert = false;
              if (takeAwayOrderLists[takeIndex].status == "Paid") {
                isInvoice = true;
                isConvert = false;
              }
              if (takeAwayOrderLists[takeIndex].status == "Ordered") {
                paymentSection = false;
                isConvert = true;
              }

              print(
                  "isInvoice _____________________________________________________    $isInvoice     ");
              print(
                  "paymentSection __________________________________________________  $paymentSection");

              setState(() {
                selectedTakeAwayIndex = takeIndex;
              });

              bottomSheetCustomised(
                  context: context,
                  tableIndex: takeIndex,
                  sectionType: 2,
                  status: takeAwayOrderLists[takeIndex].status,
                  isInvoice: isInvoice,
                  paymentSection: paymentSection,
                  isReserve: false,
                  tableID: "",
                  isConvert: isConvert,
                  isVacant: false,
                  permissionToEdit: take_away_edit_perm);

              /// Button();
              ///
              // setState(() {
              //
              //   if (takeAwayOrderLists[takeIndex].status == "Ordered") {
              //     mainPageIndex = 7;
              //
              //   ///  getOrderDetails(takeAwayOrderLists[takeIndex].salesOrderId);
              //   }
              // });
            },
            onLongPress: () {
              if (takeAwayOrderLists[takeIndex].status == "Ordered") {
                if (take_away_edit_perm) {
                  navigateToOrderSection(
                      tableID: "",
                      sectionType: "Edit",
                      UUID: takeAwayOrderLists[takeIndex].salesOrderId,
                      tableHead: "Parcel ");
                } else {
                  dialogBoxPermissionDenied(context);
                }
              }
            },
            child: Opacity(
              opacity: selectedTakeAwayIndex == takeIndex
                  ? 1
                  : selectedTakeAwayIndex == 1000
                  ? 1
                  : 0.30,
              child: Card(
                margin: const EdgeInsets.only(
                    left: 4, top: 20, right: 0, bottom: 6),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff8D8D8D), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          9, //height of button
                      width: MediaQuery.of(context).size.width / 4.9,

                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / buttonHeight, //height of button
                              width: MediaQuery.of(context).size.width / 5.1,
                              child: DottedBorder(
                                strokeWidth: .5,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              'assets/svg/takeaway.svg'),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Parcel ${takeAwayOrderLists.length - takeIndex}',
                                              //   style: TextStyle(fontSize: 11, color: Color(0xff000000), fontWeight: FontWeight.w700),
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff000000),
                                                  FontWeight.w700,
                                                  11.00),
                                            ),
                                            Text(
                                                takeAwayOrderLists[takeIndex]
                                                    .custName,
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xff2B2B2B),
                                                    FontWeight.w400,
                                                    10.00)
                                              // style: TextStyle(
                                              //     fontSize: 10,
                                              //     color: Color(0xff2B2B2B)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                      currency +
                                          ". " +
                                          roundStringWith(
                                              takeAwayOrderLists[takeIndex]
                                                  .salesOrderGrandTotal),
                                      //style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff005B37)),
                                      style: customisedStyle(
                                          context,
                                          const Color(0xff005B37),
                                          FontWeight.w600,
                                          amountFontSize),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 6, top: 6, right: 6, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Token',
                                        //style: TextStyle(fontSize: 12, color: Color(0xff000000), fontWeight: FontWeight.w600),
                                        style: customisedStyle(
                                            context,
                                            const Color(0xff000000),
                                            FontWeight.w600,
                                            12.00),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          takeAwayOrderLists[takeIndex].tokenNo,
                                          //  style: const TextStyle(fontSize: 12, color: Color(0xff4E4E4E), fontWeight: FontWeight.w500),
                                          style: customisedStyle(
                                              context,
                                              const Color(0xff4E4E4E),
                                              FontWeight.w600,
                                              12.00),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    returnOrderTime(
                                        takeAwayOrderLists[takeIndex].orderTime,
                                        takeAwayOrderLists[takeIndex].status),
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff929292),
                                        FontWeight.w400,
                                        11.00),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Container(
                      color:
                      takeAwayButton(takeAwayOrderLists[takeIndex].status),
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 4.8,
                      child: Center(
                        child: Text(
                          takeAwayOrderLists[takeIndex].status,
                          style: customisedStyle(
                              context, Colors.white, FontWeight.w400, buttonFontSize),
                        ),
                      ),
                    ),

                    // Container(
                    //
                    //   // padding: EdgeInsets.all(4),
                    //   height: MediaQuery.of(context).size.height / 18, //height of button
                    //   width: MediaQuery.of(context).size.width / 4.8,
                    //   child: TextButton(
                    //     style: TextButton.styleFrom(
                    //
                    //       backgroundColor: takeAwayButton(takeAwayOrderLists[takeIndex].status),
                    //       textStyle: const TextStyle(fontSize: 20),
                    //     ),
                    //     onPressed: () {
                    //       // bottomSheet(context);
                    //     },
                    //     child: Text(
                    //       takeAwayOrderLists[takeIndex].status,
                    //       //style: const TextStyle(fontSize: 12),
                    //       style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 4,
                    // ), // ListTile(),
                  ],
                ),
              ),
            ));
      }
    }
  }

  /// online section

  Widget onlineDeliveryDetailScreen() {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xffEE830C),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD6D6D6))),
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 11,
            //height of button
            width: MediaQuery.of(context).size.width / 1,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonAppBar(),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height /
                      11, //height of button
                  width: MediaQuery.of(context).size.width / 3,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Online'.tr,
                        //    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
                        style: customisedStyle(context, const Color(0xff717171),
                            FontWeight.w600, 15.0),
                      ),
                      Text(
                        'Create a Order',
                        // style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff000000), fontSize: 11.0),
                        style: customisedStyle(context, const Color(0xff000000),
                            FontWeight.w700, 11.0),
                      )
                    ],
                  ),
                ),
                UserDetailsAppBar(user_name: userName),
                Container(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0347A1)),
                    onPressed: () {
                      posFunctions(callFunction: true);
                    },
                    child: Text(
                      'Refresh'.tr,
                      style: customisedStyle(
                          context, Colors.white, FontWeight.w500, 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            //  height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 1.1,

            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: onlineOrderLists.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return returnOnlineListItem(index);
                }),
          ),
        ],
      ),
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 0),
              () {
            posFunctions(callFunction: false);
          },
        );
      },
    );
  }

  returnOnlineListItem(onlineIndex) {
    if (onlineOrderLists.isEmpty) {
      return Card(
          margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
          child: DottedBorder(
              color: const Color(0xff8D8D8D),
              strokeWidth: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 4.5,
                //height of button
                width: MediaQuery.of(context).size.width / 4.5,
                color: Colors.white,
                child: Center(
                  child: Container(
                    color: Colors.white,
                    //  padding: EdgeInsets.all(7),
                    height: MediaQuery.of(context).size.height /
                        20, //height of button
                    width: MediaQuery.of(context).size.width / 20,

                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          navigateToOrderSection(
                              tableID: "",
                              sectionType: "Create",
                              UUID: "",
                              tableHead: "Order ");
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )));
    } else {
      if (onlineIndex == onlineOrderLists.length) {
        return Card(
            margin:
            const EdgeInsets.only(left: 4, top: 20, right: 0, bottom: 6),
            child: DottedBorder(
                color: const Color(0xff8D8D8D),
                strokeWidth: 1,
                child: Container(
                    padding: const EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height / 4.5,
                    //height of button
                    width: MediaQuery.of(context).size.width / 4.5,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        color: Colors.white,
                        //  padding: EdgeInsets.all(7),
                        height: MediaQuery.of(context).size.height /
                            20, //height of button
                        width: MediaQuery.of(context).size.width / 20,

                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              navigateToOrderSection(
                                  tableID: "",
                                  sectionType: "Create",
                                  UUID: "",
                                  tableHead: "Order");
                            },
                            icon: const Icon(
                              Icons.add,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ))));
      } else {
        return GestureDetector(
            onTap: () {
              bool isInvoice = false;
              bool paymentSection = false;
              bool isConvert = false;

              if (onlineOrderLists[onlineIndex].status == "Paid") {
                isInvoice = true;
                isConvert = false;
              }
              if (onlineOrderLists[onlineIndex].status == "Ordered") {
                paymentSection = false;
                isConvert = true;
              }

              setState(() {
                selectedOnlineIndex = onlineIndex;
              });
              bottomSheetCustomised(
                  context: context,
                  tableIndex: onlineIndex,
                  sectionType: 3,
                  status: onlineOrderLists[onlineIndex].status,
                  isInvoice: isInvoice,
                  paymentSection: paymentSection,
                  isReserve: false,
                  tableID: "",
                  isConvert: isConvert,
                  isVacant: false,
                  permissionToEdit: take_away_edit_perm);
            },
            onLongPress: () {
              if (onlineOrderLists[onlineIndex].status == "Ordered") {
                navigateToOrderSection(
                    tableID: "",
                    sectionType: "Edit",
                    UUID: onlineOrderLists[onlineIndex].salesOrderId,
                    tableHead: "Order");
              }
            },
            child: Opacity(
              opacity: selectedOnlineIndex == onlineIndex
                  ? 1
                  : selectedOnlineIndex == 1000
                  ? 1
                  : 0.30,
              child: Card(
                margin: const EdgeInsets.only(
                    left: 4, top: 20, right: 0, bottom: 6),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff8D8D8D), width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          9, //height of button
                      width: MediaQuery.of(context).size.width / 4.9,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height /
                                19, //height of button
                            width: MediaQuery.of(context).size.width / 4.9,
                            child: DottedBorder(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: SvgPicture.asset(
                                            'assets/svg/online.svg'),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Order ${onlineOrderLists.length - onlineIndex}',
                                            //style: TextStyle(fontSize: 11, color: Color(0xff000000), fontWeight: FontWeight.w700),
                                            style: customisedStyle(
                                                context,
                                                const Color(0xff000000),
                                                FontWeight.w700,
                                                11.0),
                                          ),
                                          Text(
                                            onlineOrderLists[onlineIndex]
                                                .custName,
                                            style: customisedStyle(
                                                context,
                                                const Color(0xff2B2B2B),
                                                FontWeight.w400,
                                                10.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    currency +
                                        ". " +
                                        roundStringWith(
                                            onlineOrderLists[onlineIndex]
                                                .salesOrderGrandTotal),
                                    // 'Rs.23455',
                                    //  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff005B37))
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff005B37),
                                        FontWeight.w600,
                                        amountFontSize),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, top: 2, right: 2, bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Token',
                                  style: customisedStyle(
                                      context,
                                      const Color(0xff000000),
                                      FontWeight.w600,
                                      12.0),
                                ),
                                Text(
                                  onlineOrderLists[onlineIndex].tokenNo,
                                  // 'Order $index',

                                  style: customisedStyle(
                                      context,
                                      const Color(0xff000000),
                                      FontWeight.w600,
                                      12.0),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              returnOrderTime(
                                  onlineOrderLists[onlineIndex].orderTime,
                                  onlineOrderLists[onlineIndex].status),

                              // '23 Minutes Ago',
                              style: customisedStyle(
                                  context,
                                  const Color(0xff929292),
                                  FontWeight.w600,
                                  10.0),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 4.8,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: onlineButton(
                              onlineOrderLists[onlineIndex].status),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () {},
                        child: Text(
                          onlineOrderLists[onlineIndex].status,
                          style: customisedStyle(
                              context, Colors.white, FontWeight.w400, buttonFontSize),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    )
                    // ListTile(),
                  ],
                ),
              ),
            ));
      }
    }
  }

  /// car section
  Widget carDeliveryDetailScreen() {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      color: const Color(0xffEE830C),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffD6D6D6))),
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height / 11,
            //height of button
            width: MediaQuery.of(context).size.width / 1,
            //color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonAppBar(),
                Container(
                  alignment: Alignment.centerLeft,
                  height: MediaQuery.of(context).size.height /
                      11, //height of button
                  width: MediaQuery.of(context).size.width / 3,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Car'.tr,
                          // style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff717171), fontSize: 15),
                          style: customisedStyle(context,
                              const Color(0xff717171), FontWeight.bold, 15.0)),
                      Text('Create a Parcel',
                          style: customisedStyle(context,
                              const Color(0xff000000), FontWeight.w700, 11.0))
                    ],
                  ),
                ),
                UserDetailsAppBar(user_name: userName),
                Container(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff0347A1)),
                    onPressed: () {
                      posFunctions(callFunction: true);
                    },
                    child: Text(
                      'Refresh'.tr,
                      style: customisedStyle(
                          context, Colors.white, FontWeight.w500, 12.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            //  height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 1.1,

            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: carOrderLists.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  return returnCarListItem(index);
                }),
          ),
        ],
      ),
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 0),
              () {
            posFunctions(callFunction: true);
          },
        );
      },
    );
  }

  returnCarListItem(carIndex) {
    if (carOrderLists.isEmpty) {
      return Card(
          margin: const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
          child: DottedBorder(
              color: const Color(0xff8D8D8D),
              strokeWidth: 1,
              child: Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height / 4.5,
                //height of button
                width: MediaQuery.of(context).size.width / 4.5,

                child: Center(
                  child: Container(
                    color: Colors.white,
                    //  padding: EdgeInsets.all(7),
                    height: MediaQuery.of(context).size.height /
                        14, //height of button
                    width: MediaQuery.of(context).size.width / 18,

                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (car_create_perm) {
                            navigateToOrderSection(
                                tableID: "",
                                sectionType: "Create",
                                UUID: "",
                                tableHead: "Order ");
                          } else {
                            dialogBoxPermissionDenied(context);
                          }
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )));
    } else {
      if (carIndex == carOrderLists.length) {
        return Card(
            margin:
            const EdgeInsets.only(left: 4, top: 15, right: 0, bottom: 7),
            child: DottedBorder(
                color: const Color(0xff8D8D8D),
                strokeWidth: 1,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: MediaQuery.of(context).size.height / 4.5,
                  //height of button
                  width: MediaQuery.of(context).size.width / 4.5,
                  color: Colors.white,
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      //  padding: EdgeInsets.all(7),
                      height: MediaQuery.of(context).size.height /
                          14, //height of button
                      width: MediaQuery.of(context).size.width / 18,

                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            if (car_create_perm) {
                              navigateToOrderSection(
                                  tableID: "",
                                  sectionType: "Create",
                                  UUID: "",
                                  tableHead: "Order ");
                            } else {
                              dialogBoxPermissionDenied(context);
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )));
      } else {
        return GestureDetector(
            onTap: () {
              print("-------------------");

              bool isInvoice = false;
              bool paymentSection = false;
              bool isConvert = false;

              if (carOrderLists[carIndex].status == "Paid") {
                isInvoice = true;
                isConvert = false;
              }
              if (carOrderLists[carIndex].status == "Ordered") {
                paymentSection = false;
                isConvert = true;
              }

              setState(() {
                selectedCarIndex = carIndex;
              });

              bottomSheetCustomised(
                  context: context,
                  tableIndex: carIndex,
                  sectionType: 4,
                  status: carOrderLists[carIndex].status,
                  isInvoice: isInvoice,
                  paymentSection: paymentSection,
                  isReserve: false,
                  tableID: "",
                  isConvert: isConvert,
                  isVacant: false,
                  permissionToEdit: car_edit_perm);
            },
            onLongPress: () {
              if (carOrderLists[carIndex].status == "Ordered") {
                if (car_edit_perm) {
                  navigateToOrderSection(
                      tableID: "",
                      sectionType: "Edit",
                      UUID: carOrderLists[carIndex].salesOrderId,
                      tableHead: "Order");
                } else {
                  dialogBoxPermissionDenied(context);
                }
              }
            },
            child: InkWell(
              child: Opacity(
                opacity: selectedCarIndex == carIndex
                    ? 1
                    : selectedCarIndex == 1000
                    ? 1
                    : 0.30,
                child: Card(
                  margin: const EdgeInsets.only(
                      left: 4, top: 15, right: 0, bottom: 7),
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xff8D8D8D), width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height /
                            9.2, //height of button
                        width: MediaQuery.of(context).size.width / 4.9,

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height /
                                  buttonHeight, //height of button
                              width: MediaQuery.of(context).size.width / 4.9,
                              child: DottedBorder(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                              'assets/svg/car.svg'),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                'Order ${carOrderLists.length - carIndex}',
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xff000000),
                                                    FontWeight.w700,
                                                    11.0)),
                                            Text(
                                                carOrderLists[carIndex]
                                                    .custName,
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xff2B2B2B),
                                                    FontWeight.w400,
                                                    10.0)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Text(
                                        currency +
                                            "." +
                                            roundStringWith(
                                                carOrderLists[carIndex]
                                                    .salesOrderGrandTotal),

                                        //'Rs.23455',
                                        style: customisedStyle(
                                            context,
                                            const Color(0xff005B37),
                                            FontWeight.w600,
                                            12.0)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              //   padding: EdgeInsets.all(2),
                              //alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height /
                                  35, //height of button
                              width: MediaQuery.of(context).size.width / 5,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Token',
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w600,
                                        12.0),
                                  ),
                                  Text(
                                    carOrderLists[carIndex].tokenNo,
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff4E4E4E),
                                        FontWeight.w500,
                                        13.0),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              height: MediaQuery.of(context).size.height /
                                  37, //height of button
                              width: MediaQuery.of(context).size.width / 5,
                              child: Text(
                                //carOrderLists[ind].orderTime,
                                returnOrderTime(
                                    carOrderLists[carIndex].orderTime,
                                    carOrderLists[carIndex].status),

                                //'23 Minutes Ago',

                                style: customisedStyle(
                                    context,
                                    const Color(0xff929292),
                                    FontWeight.w500,
                                    12.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),

                      Container(
                        color: carButton(carOrderLists[carIndex].status),
                        height: MediaQuery.of(context).size.height /
                            18, //height of button
                        width: MediaQuery.of(context).size.width / 4.8,
                        child: Center(
                          child: Text(
                            carOrderLists[carIndex].status,
                            style: customisedStyle(
                                context, Colors.white, FontWeight.w400, 13.0),
                          ),
                        ),
                      ),

                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height / 18, //height of button
                      //   width: MediaQuery.of(context).size.width / 4.8,
                      //   child: TextButton(
                      //     style: TextButton.styleFrom(
                      //       backgroundColor: carButton(carOrderLists[carIndex].status),
                      //       textStyle: const TextStyle(fontSize: 20),
                      //     ),
                      //     onPressed: () {},
                      //     child: Text(
                      //       carOrderLists[carIndex].status,
                      //       style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      // ListTile(),
                    ],
                  ),
                ),
              ),
            ));
      }
    }
  }

  returnOrderTime(String data, String status) {
    if (data == "") {
      return "";
    }
    if (status == "Vacant") {
      return "";
    }

    var t = data;
    var yy = int.parse(t.substring(0, 4));
    var month = int.parse(t.substring(5, 7));
    var da = int.parse(t.substring(8, 10));
    var hou = int.parse(t.substring(11, 13));

    var mnt = int.parse(t.substring(14, 16));
    var sec = int.parse(t.substring(17, 19));

    var startTime = DateTime(yy, month, da, hou, mnt, sec);
    var currentTimeN = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    var st = formatter.format(currentTimeN);
    var currentTime = DateTime.parse(st);
    var dMnt = currentTime.difference(startTime).inMinutes;
    var dH = currentTime.difference(startTime).inHours;
    String value = "$dMnt" + " " + "" + "Minutes";

    return value;
  }

  /// payment section

  /// pos section

// bool isProductCode = false;
// bool isProductName = true;
// bool isProductDescription = false;

  var a = 1;

//15772100027983
  /// display order items

  List selectedItemsDelivery = [];
  bool lngPress = false;

  bool newCheckValue = false;

  returnColorListItem(status) {
    if (status == "pending") {
      return Colors.green;
    } else if (status == "delivered") {
      return Colors.black12;
    } else {
      return Colors.blueAccent;
    }
  }

  returnHead(val1, val2) {
    if (lngPress) {
      return val1;
    } else {
      return val2;
    }
  }

  returnListHeight() {
    var a = lngPress ? 0.5 : 0.6;
    return MediaQuery.of(context).size.height * a;
  }

  returnIconStatus(status) {
    if (status == "pending") {
      return "assets/svg/pending.svg";
    } else if (status == "delivered") {
      return "assets/svg/delivered.svg";
    } else {
      return "assets/svg/take_away.svg";
    }
  }

  returnColorITem(status) {
    print(status);
    if (status == "pending") {
      return Colors.green;
    } else if (status == "delivered") {
      return Colors.black;
    } else {
      return const Color(0xff0347A1);
    }
  }

  returnRadio(selectedInd, index) {
    return true;
  }

  buttonColor(String status) {
    if (status == "Vacant") {
      return const Color(0xffE5E5E5);
    } else if (status == "Ordered") {
      return const Color(0xff03C1C1);
    } else if (status == "Billed") {
      return const Color(0xff034FC1);
    } else if (status == "Paid") {
      return const Color(0xff10C103);
    } else {
      return Colors.grey;
    }
  }

  takeAwayButton(String takeAway) {
    if (takeAway == "Vacant") {
      return const Color(0xffE5E5E5);
    } else if (takeAway == "Ordered") {
      return const Color(0xff03C1C1);
    } else if (takeAway == "Billed") {
      return const Color(0xff034FC1);
    } else if (takeAway == "Paid") {
      return const Color(0xff10C103);
    } else {
      return Colors.grey;
    }
  }

  onlineButton(String online) {
    if (online == "Vacant") {
      return const Color(0xffE5E5E5);
    } else if (online == "Ordered") {
      return const Color(0xff03C1C1);
    } else if (online == "Billed") {
      return const Color(0xff034FC1);
    } else if (online == "Paid") {
      return const Color(0xff10C103);
    } else {
      return Colors.grey;
    }
  }

  carButton(String car) {
    if (car == "Vacant") {
      return const Color(0xffE5E5E5);
    } else if (car == "Ordered") {
      return const Color(0xff03C1C1);
    } else if (car == "Billed") {
      return const Color(0xff034FC1);
    } else if (car == "Paid") {
      return const Color(0xff10C103);
    } else {
      return Colors.grey;
    }
  }

  double roundDouble(double value, String places) {
    var pl = int.parse(places);
    num mod = pow(10.0, pl);
    return ((value * mod).round().toDouble() / mod);
  }

  var tableIndex = 0;
  var currencySymbol = "";

  int? selectedDiningIndex = 1000;
  int? selectedTakeAwayIndex = 1000;
  int? selectedOnlineIndex = 1000;
  int? selectedCarIndex = 1000;
  var tokenNumber = "";

  bool resetToken = false;

  /// update order

  Widget orderTypeDetailScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        dining_view_perm == true
            ? Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color:
              mainPageIndex == 1 ? Colors.black : Colors.transparent,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: mainPageIndex == 1 ? Colors.white : Color(0xffE8E8E8),
            // color: const Color(0xffE8E8E8),
          ),
          child: IconButton(
            onPressed: () {
              setState(() {
                mainPageIndex = 1;
              });
            },
            icon: SvgPicture.asset(
              'assets/svg/dining.svg',
            ),
          ),
        )
            : const SizedBox(),

        dining_view_perm == true
            ? Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 15.0),
          child: Text(
            'Dining'.tr,
            style: customisedStyle(
                context, Colors.black, FontWeight.w500, 11.0),
          ),
        )
            : const SizedBox(),

        take_away_view_perm == true
            ? Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color:
                mainPageIndex == 2 ? Colors.black : Colors.transparent,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: mainPageIndex == 2 ? Colors.white : Color(0xffE8E8E8),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  mainPageIndex = 2;
                });
              },
              icon: SvgPicture.asset('assets/svg/takeaway.svg'),
            ))
            : const SizedBox(),

        take_away_view_perm == true
            ? Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 15.0),
          child: Text(
            'Take_awy'.tr,
            style: customisedStyle(
                context, Colors.black, FontWeight.w500, 11.0),
          ),
        )
            : const SizedBox(),

        /// online commented
        // Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(
        //         color: borderColor3,
        //         width: 1,
        //       ),
        //       borderRadius: const BorderRadius.all(
        //         Radius.circular(10),
        //       ),
        //       color: color3,
        //     ),
        //     child: IconButton(
        //       onPressed: () {
        //         setState(() {
        //
        //           color1 = const Color(0xffF8F8F8);
        //           color2 = const Color(0xffF8F8F8);
        //           color3 = Colors.white;
        //           color4 = const Color(0xffF8F8F8);
        //           borderColor2 = Colors.transparent;
        //           borderColor1 = Colors.transparent;
        //           borderColor3 = Colors.black;
        //           borderColor4 = Colors.transparent;
        //           mainPageIndex = 3;
        //         });
        //       },
        //       icon: SvgPicture.asset('assets/svg/online.svg'),
        //     )),
        // const SizedBox(height: 3),
        // Text(
        //   'Online',
        //   style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
        // ),

        car_view_perm == true
            ? Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color:
                mainPageIndex == 4 ? Colors.black : Colors.transparent,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: mainPageIndex == 4 ? Colors.white : Color(0xffE8E8E8),
            ),
            child: IconButton(
              onPressed: () {
                setState(() {
                  mainPageIndex = 4;
                });
              },
              icon: SvgPicture.asset('assets/svg/car.svg'),
            ))
            : const SizedBox(),
        car_view_perm == true
            ? Padding(
          padding: const EdgeInsets.only(top: 3.0, bottom: 15.0),
          child: Text(
            'Car'.tr,
            style: customisedStyle(
                context, Colors.black, FontWeight.w500, 11.0),
          ),
        )
            : const SizedBox(),
      ],
    );
  }

  String roundStringWith(String val) {
    var decimal = 2;
    double convertedTodDouble = double.parse(val);
    var number = convertedTodDouble.toStringAsFixed(decimal);
    return number;
  }

  var billDiscPercent = 0.0;

  var salesOrderID;
  var totalDiscount;
  var netTotal = "0.00";
  var grandTotalAmount = "0.00";
  var totalTaxP = "0.00";
  var date;
  var roundOff;
  var balance = 0.0;
  var allowCashReceiptMoreSaleAmt = false;

  var disCount = 0.0;
  var cashReceived = 0.0;
  var bankReceived = 0.0;

  checkNan(value) {
    var val = value;
    if (value.isNaN) {
      return 0.0;
    } else {
      var val2 = val;
      return val2;
    }
  }
}

List<CardDetailsDetails> cardList = [];
List<PosListModel> onlineOrderLists = [];
List<PosListModel> takeAwayOrderLists = [];
List<PosListModel> carOrderLists = [];
List<DiningListModel> diningOrderList = [];
List<CancelReportModel> cancelReportList = [];

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {},
      ),
    );
    ;
  }
}

class UserDetailsAppBar extends StatelessWidget {
  UserDetailsAppBar({
    Key? key,
    required this.user_name,
    // required this.masterID,
  }) : super(key: key);

  String user_name;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        height: MediaQuery.of(context).size.height / 11, //height of button
        width: MediaQuery.of(context).size.width / 2.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              user_name,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
            ),
            IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: AlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Text(
                              "Alert!",
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w600, 15.00),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Text("Log out from POS",
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w500, 15.0)),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30))),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                                  prefs.setBool('IsSelectPos', false);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                          const EnterPinNumber()));
                                },
                                child: Text(
                                  'Ok',
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 12.00),
                                )),
                            TextButton(
                                onPressed: () => {
                                  Navigator.pop(context),
                                },
                                child: Text(
                                  'cancel'.tr,
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 12.00),
                                )),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ));
  }
}

class BackButtonAppBar extends StatelessWidget {
  BackButtonAppBar({
    Key? key,
    // required this.masterID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        height: MediaQuery.of(context).size.height / 11, //height of button
        // width: MediaQuery.of(context).size.width / 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var selectPos = prefs.getBool('IsSelectPos') ?? false;
                if (selectPos) {
                  await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text('Are you sure you want to exit?'),
                        actions: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor:
                              Colors.transparent, // Background color
                            ),
                            child: Text(
                              'No',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w500, 14.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              backgroundColor:
                              Colors.transparent, // Background color
                            ),
                            child: Text(
                              'Yes'.tr,
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w500, 14.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print("selectPos else $selectPos");
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ));
  }
}
