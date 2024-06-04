import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/new_design/waiter_list/waiter_select_from_dash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'Default/select_printer.dart';
import 'select/code_page.dart';
import 'select/select_capabilities.dart';
import 'user_detail/select_role.dart';
import 'user_detail/select_user_name.dart';
// import 'package:flutter_web_browser/flutter_web_browser.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  start(BuildContext context) {
    Loader.show(context,
        progressIndicator: const CircularProgressIndicator(),
        themeData: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff02BAB7))),
        overlayColor: const Color(0x99E8EAF6));
  }

  stop() {
    Future.delayed(const Duration(seconds: 0), () {
      Loader.hide();
    });
  }

  String india = "+91 9577500400";
  String ksa = " +966 54 598 2976";
  String ksa1 = "  +966 55 912 4428";

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: india));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copyPhone() async {
    await Clipboard.setData(ClipboardData(text: ksa));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  TextEditingController initialTokenNoController = TextEditingController()..text = "";
  DateFormat apiTimeFormate = DateFormat('HH:mm');
  FocusNode initialTokenNode = FocusNode();
  int templateIndex = 1;
  Color template1Color = const Color(0xff009253);
  Color template2Color = const Color(0xffFFFFFF);
  Color template3Color = const Color(0xffFFFFFF);
  Color template4Color = const Color(0xffFFFFFF);
  Color template1Text = const Color(0xffffffff);
  Color template2Text = const Color(0xffC8C8C8);
  Color template3Text = const Color(0xffC8C8C8);
  Color template4Text = const Color(0xffC8C8C8);

  bool edit = false;
  bool kitchenEdit = false;
  bool switchControl = false;
  bool switchControl1 = false;
  bool status = false;
  bool quantityIncrement = false;
  bool kotShow = false;
  bool kotPrint = false;
  bool isArabic = false;
  bool autoFocusField = false;
  bool OpenDrawer = false;
  bool diningSwitch = false;
  bool kitchenSwitch = false;
  bool takeSwitch = false;
  bool carSwitch = false;
  bool onlineSwitch = false;
  bool showInvoice = false;
  bool clearTable = false;
  bool printAfterPayment = false;
  bool hilightTokenNumber = false;
  bool paymentDetailsInPrint = false;
  bool headerAlignment = false;
  bool show_date_time_kot = false;
  bool show_username_kot = false;
  bool hideTaxDetails = false;
  bool extraDetailsInKOT = false;

  bool time_in_invoice = false;
  bool printForCancellOrder = false;

  bool printAfterOrder = false;
  bool isComplimentaryBill = false;
  bool printPreview = false;
  String printType = "Wifi";
  bool waiterPay = false;
  var printerSection = 1;
  var userType = 1;
  var kitchen = 1;
  var index = 0;
  var user = 1;
  var organization = 1;

  bool addPrinter = false;
  bool printKitchen = true;

  bool roleList = false;
  Color colors1 = Colors.white;
  Color colors2 = Colors.green;
  Color c2 = Colors.green;
  Color c1 = Colors.white;
  Color c3 = Colors.white;
  Color setting1 = Colors.white;
  Color setting2 = const Color(0xffF3F3F3);
  Color setting3 = const Color(0xffF3F3F3);
  Color setting4 = const Color(0xffF3F3F3);
  Color setting5 = const Color(0xffF3F3F3);
  Color setting6 = const Color(0xffF3F3F3);
  Color setting7 = const Color(0xffF3F3F3);
  Color setting8 = const Color(0xffF3F3F3);
  Color setting9 = const Color(0xffF3F3F3);
  Color setting10 = const Color(0xffF3F3F3);
  Color setting11 = const Color(0xffF3F3F3);
  Color setting12 = const Color(0xffF3F3F3);
  Color setting13 = const Color(0xffF3F3F3);
  Color setting14 = const Color(0xffF3F3F3);
  Color setting15 = const Color(0xffF3F3F3);
  Color setting16 = const Color(0xffF3F3F3);
  Color borderColor1 = Colors.transparent;
  Color borderColor2 = Colors.orange;

  final fieldText = TextEditingController();

  void clearText() {
    fieldText.clear();
  }

  final _formKey = GlobalKey<FormState>();
  late FocusNode ipAddress1 = FocusNode();
  late FocusNode bluetoothAddress1 = FocusNode();
  late FocusNode ipAddress2 = FocusNode();
  late FocusNode ipAddress3 = FocusNode();
  late FocusNode ipAddress4 = FocusNode();
  late FocusNode printerName = FocusNode();
  late FocusNode saveIcon = FocusNode();
  late FocusNode usersName = FocusNode();
  late FocusNode kitchenNameFocusNode = FocusNode();
  late FocusNode kitchenDescriptionFocusNode = FocusNode();
  late FocusNode kitchenSaveFocusNode = FocusNode();

  late FocusNode organizationName = FocusNode();
  late FocusNode organizationRegNo = FocusNode();
  late FocusNode financialYear1 = FocusNode();
  late FocusNode financialYear2 = FocusNode();
  late FocusNode organizationEmail = FocusNode();
  late FocusNode organizationPhone = FocusNode();
  late FocusNode organizationPAN = FocusNode();
  late FocusNode organizationGST = FocusNode();
  late FocusNode organizationTDS = FocusNode();
  late FocusNode organizationBuildingNo = FocusNode();
  late FocusNode organizationLandMark = FocusNode();
  late FocusNode organizationCountry = FocusNode();
  late FocusNode organizationCity = FocusNode();
  late FocusNode organizationState = FocusNode();
  late FocusNode organizationPIN = FocusNode();
  late FocusNode saveData = FocusNode();

  TextEditingController printerNameController = TextEditingController();
  TextEditingController bluetoothAddressController = TextEditingController();
  TextEditingController ipAddressController1 = TextEditingController();
  TextEditingController ipAddressController2 = TextEditingController();
  TextEditingController ipAddressController3 = TextEditingController();
  TextEditingController ipAddressController4 = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController organizationNameController = TextEditingController();
  TextEditingController organizationRegNoController = TextEditingController();
  TextEditingController financialYear1Controller = TextEditingController();
  TextEditingController financialYear2Controller = TextEditingController();
  TextEditingController organizationEmailController = TextEditingController();
  TextEditingController organizationPhoneController = TextEditingController();
  TextEditingController organizationPANController = TextEditingController();
  TextEditingController organizationGSTController = TextEditingController();
  TextEditingController organizationTDSController = TextEditingController();
  TextEditingController organizationBuildingNoController = TextEditingController();
  TextEditingController organizationLandMarkController = TextEditingController();
  TextEditingController organizationCountryController = TextEditingController();
  TextEditingController organizationAddress1Controller = TextEditingController();
  TextEditingController organizationAddress2Controller = TextEditingController();
  TextEditingController organizationCityController = TextEditingController();
  TextEditingController defaultSalesOrderController = TextEditingController();
  TextEditingController capabilitiesController = TextEditingController();
  TextEditingController codePageController = TextEditingController();
  TextEditingController termsAndConditionController = TextEditingController();
  TextEditingController defaultSalesInvoiceController = TextEditingController();
  TextEditingController kitchenNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController userPinController = TextEditingController();
  TextEditingController userRoleController = TextEditingController();
  TextEditingController pinGenerateController = TextEditingController();
  TextEditingController roleNameController = TextEditingController();
  TextEditingController staffNameController = TextEditingController();
  ScrollController companyListController = ScrollController();
  ScrollController kitchenListController = ScrollController();

  var selectedCountry = "India";
  var taxType = "GST";
  String orgCountryId = "";
  String _date = "2033/01/01";

  String fromDate = "2022/01/01";
  String toDate = "2022/01/01";
  String pinNo = "235534";
  String userId = "235534";
  String roleId = "235534";




  /// default print
  funcDefaultPrint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var templateBT = prefs.getString("template") ?? "template3";
    setState(() {
      if (templateBT == "template1") {
        templateIndex = 1;
      } else if (templateBT == "template2") {
        templateIndex = 2;
      } else if (templateBT == "template3") {
        templateIndex = 3;
      } else {
        templateIndex = 4;
      }

      templateViewColor(templateIndex);
    });
  }

  var kotFromDate = "DD-MM-YYYY";
  var kotTODate = "DD-MM-YYYY";

  @override
  void initState() {
    super.initState();

    loadData();
    viewList();

    token_time_notifier = ValueNotifier(DateTime.now());
    DateTime dt = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(dt);
    _date = formatted;
    kotFromDate = formatted;
    kotTODate = '$formatted';
  }

  getItemsectionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("item_section_KOT");
  }

  void switchStatus(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
  void switchStatusString(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      printDetailList.clear();

      ///

      defaultIp = prefs.getString('defaultIP') ?? '';
      kotPrint = prefs.getBool("KOT") ?? false;
      isArabic = prefs.getBool("isArabic") ?? false;
      autoFocusField = prefs.getBool("autoFocusField") ?? false;
      OpenDrawer = prefs.getBool("OpenDrawer") ?? false;
      compensationHour = prefs.getString('CompensationHour') ?? "1";
      quantityIncrement = prefs.getBool("qtyIncrement") ?? true;
      userType = prefs.getInt("user_type") ?? 1;
      showInvoice = prefs.getBool("AutoClear") ?? false;
      clearTable = prefs.getBool("tableClearAfterPayment") ?? false;
      printAfterPayment = prefs.getBool("printAfterPayment") ?? false;

      printAfterOrder = prefs.getBool("print_after_order") ?? false;
      printPreview = prefs.getBool('print_preview') ?? false;
      // payment_method = prefs.getBool('payment_method') ?? false;
      time_in_invoice = prefs.getBool('time_in_invoice') ?? false;
      printForCancellOrder = prefs.getBool('print_for_cancel_order') ?? false;
      printType = prefs.getString('PrintType') ?? "Wifi";



      hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
      paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
      headerAlignment = prefs.getBool("headerAlignment") ?? false;
      termsAndConditionController.text =prefs.getString('printTermsAndCondition') ?? "";

      if(printType =="Wifi"){
        print_type_value = true;
      }
      else{
        print_type_value = false;
      }
      capabilitiesController.text = prefs.getString('default_capabilities') ?? "default";
      codePageController.text = prefs.getString('default_code_page') ?? "CP864";
      defaultSalesInvoiceController.text = prefs.getString('defaultIP') ?? "";
      defaultSalesOrderController.text = prefs.getString('defaultOrderIP') ?? "";

      ///newly added values here
      kotDetail = prefs.getString("item_section_KOT") ?? "Product Name";
      saleDetail = prefs.getString("item_section_sale_order") ?? "Product Name";
      saleInvoiceDetail = prefs.getString("item_section_sale_invoice") ?? "Product Name";
      isComplimentaryBill = prefs.getBool("complimentary_bill") ?? false;

      show_date_time_kot = prefs.getBool("show_date_time_kot")??false;
      show_username_kot = prefs.getBool("show_username_kot")??false;
      hideTaxDetails = prefs.getBool("hideTaxDetails")??false;
      extraDetailsInKOT = prefs.getBool("extraDetailsInKOT")??false;




    });
  }
  ////

  Future<Null> updateList(String apiKeyValue, apiData, sharedPreferenceKey) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/pos-hold-settings/';
        print("$url");

        Map data = {"CompanyID": companyID, "key": apiKeyValue, "value": apiData, "action": 1,"BranchID":branchID};
        print(data);

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {

          if (apiKeyValue != "InitialTokenNo") {
            dialogBox(context, "Updated successfully");
          }
          if (apiKeyValue == "InitialTokenNo") {
            initialTokenNoController.text =apiData;
          }

          stop();
          setState(() {});
          if (apiKeyValue == "TokenResetTime"||apiKeyValue == "InitialTokenNo"||apiKeyValue == "CompensationHour") {
            if(apiKeyValue == "CompensationHour"){
              switchStatusString("CompensationHour",apiData.toString());
            }
          }
          else {
            switchStatus(sharedPreferenceKey, apiData);
          }

        }
        else if (status == 6001) {
          stop();
          dialogBox(context, "Something went wrong");
        } else {
          stop();
        }
      } catch (e) {
        dialogBox(context, "Something went wrong");
        stop();
      }
    }
  }

  Future<Null> viewList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/pos-hold-settings/';
        print("$url");

        Map data = {"CompanyID": companyID, "action": 0, "key": "", "value": "","BranchID":branchID};

        ///date not
        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        print(status);
        var responseJson = n["data"];
        print(responseJson);
        print(status);
        if (status == 6000) {
          setState(() {
            // paymentMethod = responseJson["IsPayAfterSave"];
            quantityIncrement = responseJson["IsQuantityIncrement"];
            prefs.setBool("qtyIncrement", quantityIncrement);

            showInvoice = responseJson["IsShowInvoice"];
            prefs.setBool("AutoClear", showInvoice);

            clearTable = responseJson["IsClearTableAfterPayment"];
            prefs.setBool("tableClearAfterPayment", clearTable);

            printAfterPayment = responseJson["IsPrintAfterPayment"];
            prefs.setBool("printAfterPayment", printAfterPayment);

            DateTime parsedTime = DateFormat('hh:mm').parse(responseJson["TokenResetTime"]);
            token_time_notifier = ValueNotifier(parsedTime);

            initialTokenNoController.text = responseJson["InitialTokenNo"].toString();
            compensationHour = responseJson["CompensationHour"].toString();
            // printAfterPayment = responseJson["IsPrintAfterPayment"];
            // prefs.setBool("printAfterPayment", printAfterPayment);
            //
            //
            //
            // printAfterPayment = responseJson["IsPrintAfterPayment"];
            // prefs.setBool("printAfterPayment", printAfterPayment);

            //  waiterPay = responseJson["IsWaiterCanPay"];

            // quantityIncrement = prefs.getBool("qtyIncrement") ?? false;
            // showInvoice = prefs.getBool("AutoClear") ?? false;
            // clearTable = prefs.getBool("tableClearAfterPayment") ?? false;
            // printAfterPayment = prefs.getBool("printAfterPayment") ?? false;
            // payAfterSave = prefs.getBool("pay_after_save") ?? false;
            // printPreview = prefs.getBool('print_preview') ?? false;
          });
        } else if (status == 6001) {
          print("12");
        } else {
          print("13");
        }
      } catch (e) {
        print("Error");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  bool createWaiterBool = false;
  bool isEditWaiter = false;
  String waiterID = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title:   Text(
                  'Settings'.tr,
                    style: customisedStyle(context, Colors.black, FontWeight.w600, 22.0)
                ),
                backgroundColor: Colors.grey[300],
                actions: <Widget>[
                  // IconButton(
                  //     icon: SvgPicture.asset('assets/svg/sidemenu.svg'),
                  //     onPressed: () {}),
                ]),
            body: Row(children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: <Widget>[settingsDetailScreens(index)],
                    )),
              ),
              Expanded(flex: 2, child: Padding(padding: const EdgeInsets.all(8.0), child: selectSettingsList()))
            ])));
  }

  settingsDetailScreens(int index) {
    print("-----------------------------------$index");
    if (index == 1) {
      return generalSettingScreen();
    } else if (index == 2) {
      return printerSettingScreen();
    } else if (index == 3) {
      return kitchenSettingScreen();
    } else if (index == 4) {
      return printerDefault();
    } else if (index == 5) {
      return usersSettingScreen();
    } else if (index == 6) {
      return contactUSScreen();
    } else if (index == 7) {
      return privacyPoliciesScreen();
    } else if (index == 8) {
      return termsAndConditionScreen();
    } else if (index == 9) {
      return versionDetailScreen();
    } else if (index == 10) {
      return languagesScreen();
    } else if (index == 12 || index == 13) {
      return waiterScreen();
    }
    // else if (index == 13) {
    //   return deliveryScreen();
    // }
    else if (index == 14) {
      return printerScreen();
    } else if (index == 15) {
      return userRoleScreen();
    } else if (index == 16) {
      return kotLogScreen();
    } else {
      return generalSettingScreen();
    }
  }

  Widget kotLogScreen() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                Text('KOT_log'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20,
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 13.0, right: 8, top: 8, bottom: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _selectDate(context, 1);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xffCBCBCB))),
                        height: MediaQuery.of(context).size.height / 16,
                        width: MediaQuery.of(context).size.width / 7,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('from'.tr, style: const TextStyle(fontSize: 10, color: Color(0xff888580))),
                                Text(
                                  kotFromDate,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context, 2);
                      },
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xffCBCBCB))),
                        height: MediaQuery.of(context).size.height / 16,
                        width: MediaQuery.of(context).size.width / 7,
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('to'.tr, style: const TextStyle(fontSize: 10, color: Color(0xff888580))),
                                Text(
                                  kotTODate,
                                  style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.40, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: ListView.builder(
              // the number of items in the list
              itemCount: 3,

              // display each item of the product list
              itemBuilder: (context, index) {
                return Card(
                  elevation: 0,
                  color: const Color(0xffFfffff),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              "03/05/2023, 9:39 AM",
                              style: TextStyle(color: Color(0xff3B3B3B), fontSize: 12),
                            ),
                            Text(
                              "Wednessday",
                              style: TextStyle(color: Color(0xffF25F29), fontSize: 11),
                            )
                          ],
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              "Order No",
                              style: TextStyle(color: Color(0xff9A9A9A), fontSize: 12),
                            ),
                            Text(
                              "IN-V",
                              style: TextStyle(color: Color(0xff000000), fontSize: 11),
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'token_no'.tr,
                              style: const TextStyle(color: Color(0xff9A9A9A), fontSize: 12),
                            ),
                            const Text(
                              "011",
                              style: TextStyle(color: Color(0xff000000), fontSize: 11),
                            )
                          ],
                        ),
                        const Column()
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  bool isUserRole = false;

  Widget userRoleScreen() {
    return ListView(
      shrinkWrap: true,
      //mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child:   Text('user_role'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              )),
        ),
        isUserRole == true
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.40, //height of button
                width: MediaQuery.of(context).size.width / 1.1,
                child: ListView(children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2.3,
                    width: MediaQuery.of(context).size.width / 3,
                    child: ListView(
                      children: [
                          Text(
                         'name'.tr,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            controller: roleNameController,
                            decoration:   InputDecoration(
                              contentPadding: const EdgeInsets.all(13),
                              hintText: 'role_name'.tr,
                              hintStyle: const TextStyle(color: Colors.grey),
                              focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                              isDense: true,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                          Text(
                          'Role'.tr,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Text(
                                'Dining'.tr,
                                style: const TextStyle(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                  child: FlutterSwitch(
                                width: 40.0,
                                height: 20.0,
                                valueFontSize: 30.0,
                                toggleSize: 15.0,
                                value: diningSwitch,
                                borderRadius: 20.0,
                                padding: 1.0,
                                activeColor: Colors.green,
                                activeTextColor: Colors.green,
                                inactiveTextColor: Colors.white,
                                inactiveColor: Colors.grey,
                                onToggle: (val) {
                                  setState(() {
                                    diningSwitch = val;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Take_awy'.tr, style: const TextStyle(fontWeight: FontWeight.w400)),
                              SizedBox(
                                  child: FlutterSwitch(
                                width: 40.0,
                                height: 20.0,
                                valueFontSize: 30.0,
                                toggleSize: 15.0,
                                value: takeSwitch,
                                borderRadius: 20.0,
                                padding: 1.0,
                                activeColor: Colors.green,
                                activeTextColor: Colors.green,
                                inactiveTextColor: Colors.white,
                                inactiveColor: Colors.grey,
                                onToggle: (val) {
                                  setState(() {
                                    takeSwitch = val;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Online'.tr, style: const TextStyle(fontWeight: FontWeight.w400)),
                              SizedBox(
                                  child: FlutterSwitch(
                                width: 40.0,
                                height: 20.0,
                                valueFontSize: 30.0,
                                toggleSize: 15.0,
                                value: onlineSwitch,
                                borderRadius: 20.0,
                                padding: 1.0,
                                activeColor: Colors.green,
                                activeTextColor: Colors.green,
                                inactiveTextColor: Colors.white,
                                inactiveColor: Colors.grey,
                                onToggle: (val) {
                                  setState(() {
                                    onlineSwitch = val;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Text('Car'.tr, style: const TextStyle(fontWeight: FontWeight.w400)),
                              SizedBox(
                                  child: FlutterSwitch(
                                width: 40.0,
                                height: 20.0,
                                valueFontSize: 30.0,
                                toggleSize: 15.0,
                                value: carSwitch,
                                borderRadius: 20.0,
                                padding: 1.0,
                                activeColor: Colors.green,
                                activeTextColor: Colors.green,
                                inactiveTextColor: Colors.white,
                                inactiveColor: Colors.grey,
                                onToggle: (val) {
                                  setState(() {
                                    carSwitch = val;
                                  });
                                },
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height / 1.40, //height of button
                width: MediaQuery.of(context).size.width / 1.1,
                //  color: Colors.red[100],
                child: ListView.builder(
                    // the number of items in the list
                    itemCount: 3,

                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3), side: const BorderSide(width: 1, color: Color(0xffDFDFDF))),
                        color: const Color(0xffF3F3F3),
                        child: ListTile(
                          title: Text(
                            "User roles $index",
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }),
              ),
        isUserRole == true
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 11, //height of button
                width: MediaQuery.of(context).size.width / 1,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 11, //height of button

                    width: MediaQuery.of(context).size.width / 16,

                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset('assets/svg/delete.svg'),
                      iconSize: 40,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 11, //height of button

                    width: MediaQuery.of(context).size.width / 16,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isUserRole = false;
                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/svg/add.svg',
                        ),
                        iconSize: 40),
                  ),
                ]),
              )
            : Container(
                height: MediaQuery.of(context).size.height / 11, //height of button
                width: MediaQuery.of(context).size.width / 7,

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isUserRole = true;
                        });
                      },
                      icon: SvgPicture.asset('assets/svg/addmore.svg'),
                      iconSize: 50,
                    ),
                  ],
                ),
              )
      ],
    );
  }
 bool  print_type_value = true;
  Widget defaultPrinterNew() {
    return Container(
      // height: MediaQuery.of(context).size.height / 12,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color:Colors.transparent),
        ),
        child: Padding(
          padding:
          const EdgeInsets.only(left: 13, bottom: 0, top: 0, right: 13),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(print_type_value?'wifi_printer'.tr:'usbPrinter'.tr,style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),),
                  FlutterSwitch(
                    width: 50.0,
                    height: 25.0,
                    valueFontSize: 30.0,
                    toggleSize: 18.0,
                    value: print_type_value,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: const Color(0xff009253),
                    inactiveToggleColor: const Color(0xff009253),
                    inactiveColor: const Color(0xffDEDEDE),
                    onToggle: (val) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      setState(() {
                          print_type_value = val;
                          if (val == true) {
                          prefs.setString("PrintType", "Wifi");
                        } else {
                          defaultSalesInvoiceController.clear();
                          defaultSalesOrderController.clear();
                          prefs.setString("PrintType", "USB");
/// bluetooth commented
                          // prefs.setString("PrintType", "BT");
                        }
                      });
                    },
                  ),
                ],
              ),

            ],
          ),
        )
    );
  }
  Widget printerScreen() {
    return Container(
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom: 15),
            child: defaultPrinterNew(),
          ),

          /// commented template selection
        //  print_type_value ==true  ?

          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),
            color: Colors.grey[100],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                //  color: const Color(0xffEEEEEE),
              ),
              padding: const EdgeInsets.all(6),
              //height: MediaQuery.of(context).size.height / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'select_temp'.tr,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// template 1 and  2 commented
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       templateIndex = 1;
                      //       templateViewColor(templateIndex);
                      //       setTemplate(1);
                      //     });
                      //   },
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height / 12,
                      //     width: MediaQuery.of(context).size.width / 18,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6),
                      //       color: template1Color,
                      //     ),
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       "1",
                      //       style: customisedStyle(context, template1Text, FontWeight.w700, 22.0),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       templateIndex = 2;
                      //       templateViewColor(templateIndex);
                      //       setTemplate(2);
                      //
                      //     });
                      //   },
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height / 12,
                      //     width: MediaQuery.of(context).size.width / 18,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(6),
                      //       color: template2Color,
                      //     ),
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       "2",
                      //       style: customisedStyle(context, template2Text, FontWeight.w700, 22.0),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   width: 20,
                      // ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            templateIndex = 3;
                            templateViewColor(templateIndex);
                            setTemplate(3);
                            //templateViewColor=
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: template3Color,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "1",
                            style: customisedStyle(context, template3Text, FontWeight.w700, 22.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            templateIndex = 4;
                            templateViewColor(templateIndex);
                            setTemplate(4);
                            //templateViewColor=
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          width: MediaQuery.of(context).size.width / 18,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: template4Color,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "2",
                            style: customisedStyle(context, template4Text, FontWeight.w700, 22.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
         //     :Container(),
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                //  color: const Color(0xffEEEEEE),
              ),
              padding: const EdgeInsets.all(6),
              // height: MediaQuery.of(context).size.height / 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: TextField(
                      readOnly: true,
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                      onTap: () {
                        SettingsData.defaultPrinterType = "1";
                        navigateToPrinter();
                      },
                      controller: defaultSalesInvoiceController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.all(13),
                        hintText:'sales_invoice'.tr,
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        labelText: "Sales  invoice",
                        labelStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        focusedBorder:
                            const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: TextField(
                      readOnly: true,
                      onTap: () {
                        SettingsData.defaultPrinterType = "2";
                        navigateToPrinter();
                      },
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                      controller: defaultSalesOrderController,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.all(13),
                        hintText: 'sale_order'.tr,
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        labelText: 'sale_order'.tr,
                        labelStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        focusedBorder:
                            const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color
                      ),
                      onPressed: () {
                        SettingsData.defaultPrinterType = "3";
                        navigateToPrinter();
                      },
                      child: Text(
                        'set_def'.tr,
                        style: customisedStyle(context, Colors.white, FontWeight.w400, 12.0),
                      ))
                ],
              ),
            ),
          ),
          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),

              ),
              padding: const EdgeInsets.all(6),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('select_capability'.tr,style:  customisedStyle(context, Colors.black, FontWeight.w400, 14.0),),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: TextField(
                      readOnly: true,
                      onTap: () async{
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectCapabilities()),
                        );
                        if (result != null) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('default_capabilities',result) ?? '';
                          capabilitiesController.text = result;
                        }
                      },
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                      controller: capabilitiesController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(13),
                        hintText: 'select_capability'.tr,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        labelText: 'select_capability'.tr,
                        labelStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        focusedBorder:
                        const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          Card(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),

              ),
              padding: const EdgeInsets.all(6),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text('select_code_page'.tr,style:  customisedStyle(context, Colors.black, FontWeight.w400, 14.0),),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5,
                    child: TextField(
                      readOnly: true,
                      onTap: () async{
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SelectCodePage()),
                        );
                        if (result != null) {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('default_code_page',result) ?? '';
                          codePageController.text = result;
                        }
                      },
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                      controller: codePageController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(13),
                        hintText: 'select_code_page'.tr,
                        suffixIcon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        labelText: 'select_code_page'.tr,
                        labelStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                        focusedBorder:
                        const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'highlight_tkn_no'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: hilightTokenNumber,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        hilightTokenNumber = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('hilightTokenNumber', val);



                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'payment_detail'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: paymentDetailsInPrint,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        paymentDetailsInPrint = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('paymentDetailsInPrint', val);

                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
               'com_detail_align'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: headerAlignment,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        headerAlignment = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('headerAlignment', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          // Card(
          //   shape: RoundedRectangleBorder(
          //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          //
          //   child: ListTile(
          //     title: Text(
          //       'payment_method'.tr,
          //       style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
          //     ),
          //     trailing: SizedBox(
          //       width: 100,
          //       child: Center(
          //         child: FlutterSwitch(
          //           width: 40.0,
          //           height: 20.0,
          //           valueFontSize: 30.0,
          //           toggleSize: 15.0,
          //           value: payment_method,
          //           borderRadius: 20.0,
          //           padding: 1.0,
          //           activeColor: Colors.green,
          //           activeTextColor: Colors.green,
          //           inactiveTextColor: Colors.white,
          //           inactiveColor: Colors.grey,
          //           // showOnOff: true,
          //           onToggle: (val)async {
          //             setState(() {
          //               payment_method = val;
          //             });
          //
          //             SharedPreferences prefs = await SharedPreferences.getInstance();
          //             prefs.setBool('payment_method', val);
          //
          //
          //             // setState(() {
          //             //   printAfterPayment = val;
          //             //   switchStatus("printAfterPayment", printAfterPayment);
          //             // });
          //           },
          //         ),
          //       ),
          //     ),
          //     onTap: () {},
          //   ),
          // ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'time_in_invoice'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: time_in_invoice,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        time_in_invoice = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('time_in_invoice', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),

          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'show_date_kot'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: show_date_time_kot,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        show_date_time_kot = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('show_date_time_kot', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'show_user_kot'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: show_username_kot,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        show_username_kot = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('show_username_kot', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'hide_tax_details'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: hideTaxDetails,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        hideTaxDetails = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('hideTaxDetails', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'extraDetailsInKOT'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: extraDetailsInKOT,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        extraDetailsInKOT = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('extraDetailsInKOT', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: ListTile(
              title: Text(
                'Print For Cancelled Order'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
              ),
              trailing: SizedBox(
                width: 50,
                child: Center(
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: printForCancellOrder,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    // showOnOff: true,
                    onToggle: (val)async {
                      setState(() {
                        printForCancellOrder = val;
                      });

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('print_for_cancel_order', val);


                      // setState(() {
                      //   printAfterPayment = val;
                      //   switchStatus("printAfterPayment", printAfterPayment);
                      // });
                    },
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
              borderRadius: BorderRadius.circular(2),
            ),

            child: SizedBox(
              //    width: MediaQuery.of(context).size.width / 5,
              child: TextField(
                onChanged: (text)async{

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('printTermsAndCondition', text);

                },
                style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                controller: termsAndConditionController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(13),
                  hintText: 'terms_condition'.tr,

                  hintStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                  labelText: 'terms_condition'.tr,
                  labelStyle: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                  focusedBorder:
                  const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50,)
        ],
      ),
    );
  }

  Widget selectSettingsList() {
    return ListView(children: <Widget>[
      Card(
        color: setting1,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 1;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/genrlsetting.svg')),
          title: Text(
            'gen_setting'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),
      Card(
        color: setting14,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            funcDefaultPrint();
            setState(() {
              createWaiterBool = false;
              index = 14;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/printseting.svg')),
          title: Text(
            'printer_set'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),
      Card(
        color: setting2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 2;
              test(index);

              Future.delayed(Duration.zero, () {
                listAllPrinter();
              });
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/printseting.svg')),
          title: Text(
            'add_print'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),

      // Card(
      //   color: setting4,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         index = 4;
      //         test(index);
      //         printerDefault();
      //
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {},
      //         icon: SvgPicture.asset('assets/svg/printseting.svg')),
      //     title: const Text('Default',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      //   ),
      // ),

      /// template selection is commented
      // Card(
      //   color: setting4,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         index = 4;
      //         test(index);
      //         printerTemplate();
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {},
      //         icon: SvgPicture.asset('assets/svg/printseting.svg')),
      //     title: const Text('Printer Template',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      //   ),
      // ),

      Card(
        color: setting3,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 3;
              test(index);
              Future.delayed(Duration.zero, () {
                getKitchenListApi();
                listAllPrinter();
              });
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/kitchenseting.svg')),
          title: Text(
            'kit_set'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),

      ///commented organisation
      // Card(
      //   color: setting4,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         index = 4;
      //         test(index);
      //         Future.delayed(Duration.zero, () {
      //           getCompanyListDetails();
      //         });
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {},
      //         icon: SvgPicture.asset('assets/svg/organisation.svg')),
      //     title: const Text('Organizations',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      //   ),
      // ),
/// user section commented
      // userType == 1
      //     ? Card(
      //         color: setting5,
      //         shape: RoundedRectangleBorder(
      //           side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //           borderRadius: BorderRadius.circular(2),
      //         ),
      //         child: ListTile(
      //           onTap: () {
      //             setState(() {
      //               createWaiterBool = false;
      //               index = 5;
      //               test(index);
      //               Future.delayed(Duration.zero, () {
      //                 getAllUsersList();
      //               });
      //             });
      //           },
      //           leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/users.svg')),
      //           title: Text(
      //             'Users',
      //             style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
      //           ),
      //         ),
      //       )
      //     : Container(),

      // Card(
      //   color: setting15,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         createWaiterBool = false;
      //         index = 15;
      //         test(index);
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {},
      //         icon: SvgPicture.asset('assets/svg/user_role.svg')),
      //     title:   Text('User Roles',
      //       style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),),
      //   ),
      // ),
      /// delivery man and waiter commented
      // Card(
      //   color: setting12,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         waiterLists.clear();
      //         createWaiterBool = false;
      //         index = 12;
      //         test(index);
      //         listWaiterApi("0");
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {},
      //         icon: Icon(
      //           Icons.person,
      //           color: Color(0xffF25F29),
      //           size: 35,
      //         )),
      //     title: Text(
      //       'Waiter',
      //       style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
      //     ),
      //   ),
      // ),
      // Card(
      //   color: setting13,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         waiterLists.clear();
      //         createWaiterBool = false;
      //         index = 13;
      //         test(index);
      //         listWaiterApi("1");
      //       });
      //       // setState(() {
      //       //   index = 13;
      //       //   test(index);
      //       // });
      //     },
      //     leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/delivery_man.svg')),
      //     title: Text(
      //       'Delivery Man',
      //       style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
      //     ),
      //   ),
      // ),
      Card(
        color: setting6,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 6;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/Contactus.svg')),
          title: Text(
            'contact_us'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),

      Card(
        color: setting7,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 7;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/Privacypolicy.svg')),
          title: Text(
            'privacy_policy'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),
      Card(
        color: setting8,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 8;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/Termscontitions.svg')),
          title: Text(
            'terms_condition'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),
      Card(
        color: setting9,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              createWaiterBool = false;
              index = 9;
              test(index);
            });
          },
          leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/Versiondetails.svg')),
          title: Text(
            'vertion_detail'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),

      /// language is commented
      // Card(
      //   color: setting10,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         index = 10;
      //         test(index);
      //       });
      //     },
      //     leading: IconButton(
      //         onPressed: () {
      //           setState(() {});
      //         },
      //         icon: SvgPicture.asset('assets/svg/language.svg')),
      //     title: const Text('Language',
      //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      //   ),
      // ),
/// kot log
      // Card(
      //   color: setting16,
      //   shape: RoundedRectangleBorder(
      //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
      //     borderRadius: BorderRadius.circular(2),
      //   ),
      //   child: ListTile(
      //     onTap: () {
      //       setState(() {
      //         createWaiterBool = false;
      //         index = 16;
      //         test(index);
      //       });
      //     },
      //     leading: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/svg/kotlog.svg')),
      //     title: Text(
      //       'KOT Log',
      //       style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
      //     ),
      //   ),
      // ),

      Card(
        color: setting11,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          onTap: () async {
            final Future<ConfirmAction?> action = await _asyncConfirmDialog(context);
            print("Confirm Action $action");
          },
          leading: IconButton(onPressed: () async {}, icon: SvgPicture.asset('assets/svg/logout.svg')),
          title: Text(
            'log_out'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
          ),
        ),
      ),
    ]);
  }

  test(int ind) {
    setState(() {
      if (ind == 1) {
        setting1 = Colors.white;
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 2) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = Colors.white;
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 3) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = Colors.white;
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 4) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = Colors.white;
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 5) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = Colors.white;
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 6) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = Colors.white;
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 7) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = Colors.white;
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 8) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = Colors.white;
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 9) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = Colors.white;
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 10) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = Colors.white;
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 11) {
        setting11 = Colors.white;
      } else if (ind == 12) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffffffff);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 13) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3f3f3);
        setting13 = const Color(0xffffffff);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 14) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffFfffff);
        setting15 = const Color(0xffF3F3F3);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 15) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffFfffff);
        setting16 = const Color(0xffF3F3F3);
      } else if (ind == 16) {
        setting1 = const Color(0xffF3F3F3);
        setting2 = const Color(0xffF3F3F3);
        setting3 = const Color(0xffF3F3F3);
        setting4 = const Color(0xffF3F3F3);
        setting5 = const Color(0xffF3F3F3);
        setting6 = const Color(0xffF3F3F3);
        setting7 = const Color(0xffF3F3F3);
        setting8 = const Color(0xffF3F3F3);
        setting9 = const Color(0xffF3F3F3);
        setting10 = const Color(0xffF3F3F3);
        setting12 = const Color(0xffF3F3F3);
        setting13 = const Color(0xffF3F3F3);
        setting14 = const Color(0xffF3F3F3);
        setting15 = const Color(0xffF3f3f3);
        setting16 = const Color(0xffFfffff);
      }
    });
  }

  Widget generalSettingScreen() {
    return ListView(
      shrinkWrap: true,
      //mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Text('gen_setting'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.2, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: ListView(children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'autoFocusField'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50 ,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: autoFocusField,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onToggle: (val) async{

                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        if(val){
                          prefs.setBool('autoFocusField', true);
                        }
                        else{
                          prefs.setBool('autoFocusField', false);

                        }

                        setState(() {
                          autoFocusField = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'is_Arabic'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: isArabic,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onToggle: (val) async{

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        Locale? currentLocale = Get.locale;
                        if(currentLocale.toString() =="ar"){
                          prefs.setBool('isArabic', false);
                          Get.updateLocale(const Locale('en', 'US'));
                        }
                        else{
                          prefs.setBool('isArabic', true);
                          Get.updateLocale(const Locale('ar'));
                        }

                        setState(() {
                          isArabic = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'Open_drawer'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value:OpenDrawer ,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onToggle: (val) async{
                        setState(() {
                          OpenDrawer = val;
                          switchStatus("OpenDrawer", OpenDrawer);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'KOT_print'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: kotPrint,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onToggle: (val) {
                        setState(() {
                          kotPrint = val;
                          switchStatus("KOT", kotPrint);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'qty_inc'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: quantityIncrement,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      onToggle: (val) {
                        quantityIncrement = val;
                        updateList("IsQuantityIncrement", val, "qtyIncrement");

                        // setState(() {
                        //   quantityIncrement = val;
                        //   switchStatus("qtyIncrement", quantityIncrement);
                        // });
                      },
                    ),
                  ),
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                  onTap: null,
                  title: Text(
                   'show_inv'.tr,
                    style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                  ),
                  trailing: SizedBox(
                    width: 50,
                    child: Center(
                      child: FlutterSwitch(
                        width: 40.0,
                        height: 20.0,
                        valueFontSize: 30.0,
                        toggleSize: 15.0,
                        value: showInvoice,
                        borderRadius: 20.0,
                        padding: 1.0,
                        activeColor: Colors.green,
                        activeTextColor: Colors.green,
                        inactiveTextColor: Colors.white,
                        inactiveColor: Colors.grey,

                        // showOnOff: true,
                        onToggle: (val) {
                          showInvoice = val;
                          updateList("IsShowInvoice", val, "AutoClear");

                          // setState(() {
                          //   showInvoice = val;
                          //   switchStatus("AutoClear", showInvoice);
                          // });
                        },
                      ),
                    ),
                  ),

                  ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                  title: Text(
                    'clear_table'.tr,
                    style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                  ),
                  trailing: SizedBox(
                    width: 50,
                    child: Center(
                      child: FlutterSwitch(
                        width: 40.0,
                        height: 20.0,
                        valueFontSize: 30.0,
                        toggleSize: 15.0,
                        value: clearTable,
                        borderRadius: 20.0,
                        padding: 1.0,
                        activeColor: Colors.green,
                        activeTextColor: Colors.green,
                        inactiveTextColor: Colors.white,
                        inactiveColor: Colors.grey,
                        onToggle: (val) {
                          clearTable = val;
                          updateList("IsClearTableAfterPayment", val, "tableClearAfterPayment");

                          // setState(() {
                          //   clearTable = val;
                          //   switchStatus("tableClearAfterPayment", clearTable);
                          // });
                        },
                      ),
                    ),
                  ),
                onTap: null,
              ),
            ),

            ///default payment method
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text('Default Payment Method'),
            //     trailing: IconButton(
            //       onPressed: () {},
            //       icon: SvgPicture.asset('assets/svg/arrow.svg'),
            //     ),
            //     onTap: () {
            //       setState(() {
            //         paymentMethod = true;
            //       });
            //     },
            //   ),
            // ),
            // paymentMethod == true
            //     ? Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           SizedBox(
            //             height: MediaQuery.of(context).size.height /
            //                 16, //height of button
            //             width: MediaQuery.of(context).size.width / 1,
            //             // color: Colors.green[100],
            //             child: const Text('Payment Method',
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.w600,
            //                   color: Colors.black,
            //                   fontSize: 20,
            //                 )),
            //           ),
            //           SizedBox(
            //             //height of button
            //             width: MediaQuery.of(context).size.width / 1.1,
            //             height: MediaQuery.of(context).size.height / 6,
            //
            //             child: ListView(children: <Widget>[
            //               Card(
            //                 shape: RoundedRectangleBorder(
            //                   side: const BorderSide(
            //                       color: Color(0xffDFDFDF), width: 1),
            //                   borderRadius: BorderRadius.circular(2),
            //                 ),
            //                 color: Colors.grey[100],
            //                 child: ListTile(
            //                   title: const Text('Cash'),
            //                   trailing: GestureDetector(
            //                     child: Container(
            //                       width: 20,
            //                       height: 20,
            //                       child: const Icon(
            //                         Icons.check,
            //                         size: 16,
            //                         color: Colors.white,
            //                       ),
            //                       decoration: BoxDecoration(
            //                           shape: BoxShape.circle,
            //                           color: colors1,
            //                           border: Border.all(color: Colors.grey)),
            //                     ),
            //                     onTap: () {
            //                       setState(() {
            //                         colors1 = Colors.green;
            //                         colors2 = Colors.white;
            //                       });
            //                     },
            //                   ),
            //                 ),
            //               ),
            //               Card(
            //                 shape: RoundedRectangleBorder(
            //                   side: const BorderSide(
            //                       color: Color(0xffDFDFDF), width: 1),
            //                   borderRadius: BorderRadius.circular(2),
            //                 ),
            //                 color: Colors.grey[100],
            //                 child: ListTile(
            //                   title: const Text('Bank'),
            //                   trailing: GestureDetector(
            //                     child: Container(
            //                       width: 20,
            //                       height: 20,
            //                       child: const Icon(
            //                         Icons.check,
            //                         size: 16,
            //                         color: Colors.white,
            //                       ),
            //                       decoration: BoxDecoration(
            //                           shape: BoxShape.circle,
            //                           color: colors2,
            //                           border: Border.all(color: Colors.grey)),
            //                     ),
            //                     onTap: () {
            //                       setState(() {
            //                         colors2 = Colors.green;
            //                         colors1 = Colors.white;
            //                       });
            //                     },
            //                   ),
            //                 ),
            //               )
            //             ]),
            //           )
            //         ],
            //       )
            //     : Container(),

            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'print_after_payment'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: printAfterPayment,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      // showOnOff: true,
                      onToggle: (val) {
                        printAfterPayment = val;
                        updateList("IsPrintAfterPayment", val, "printAfterPayment");

                        // setState(() {
                        //   printAfterPayment = val;
                        //   switchStatus("printAfterPayment", printAfterPayment);
                        // });
                      },
                    ),
                  ),
                ),

              ),
            ),

            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'print_after_order'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: printAfterOrder,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      // showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          printAfterOrder = val;
                          switchStatus("print_after_order", printAfterOrder);
                        });

                        // setState(() {
                        //   printAfterPayment = val;
                        //   switchStatus("printAfterPayment", printAfterPayment);
                        // });
                      },
                    ),
                  ),
                ),

              ),
            ),

            /// print after save
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text(
            //       'Print after save',
            //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            //     ),
            //     trailing: SizedBox(
            //       width: 100,
            //       child: Center(
            //         child: FlutterSwitch(
            //           width: 40.0,
            //           height: 20.0,
            //           valueFontSize: 30.0,
            //           toggleSize: 15.0,
            //           value: payAfterSave,
            //           borderRadius: 20.0,
            //           padding: 1.0,
            //           activeColor: Colors.green,
            //           activeTextColor: Colors.green,
            //           inactiveTextColor: Colors.white,
            //           inactiveColor: Colors.grey,
            //
            //           // showOnOff: true,
            //           onToggle: (val) {
            //             setState(() {
            //               payAfterSave = val;
            //               switchStatus("pay_after_save", payAfterSave);
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //     onTap: () {
            //       setState(() {
            //         paymentMethod = false;
            //       });
            //     },
            //   ),
            // ),
            /// print preview
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text('Print preview',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),
            //
            //     // title: const Text('Print Preview'),
            //     trailing: SizedBox(
            //       width: 100,
            //       child: Center(
            //         child: FlutterSwitch(
            //           width: 40.0,
            //           height: 20.0,
            //           valueFontSize: 30.0,
            //           toggleSize: 15.0,
            //           value: printPreview,
            //           borderRadius: 20.0,
            //           padding: 1.0,
            //           activeColor: Colors.green,
            //           activeTextColor: Colors.green,
            //           inactiveTextColor: Colors.white,
            //           inactiveColor: Colors.grey,
            //           // showOnOff: true,
            //           onToggle: (val) {
            //             setState(() {
            //               printPreview = val;
            //               switchStatus("print_preview", printPreview);
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text('Customize Print'),
            //     trailing: IconButton(
            //       onPressed: () {},
            //       icon: SvgPicture.asset('assets/svg/arrow.svg'),
            //     ),
            //   ),
            // ),
            // Card(
            //              shape: RoundedRectangleBorder(
            //                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //                borderRadius: BorderRadius.circular(2),
            //              ),
            //              color: Colors.grey[100],
            //              child: Container(
            //                decoration: BoxDecoration(
            //                  borderRadius: BorderRadius.circular(6),
            //                  //  color: const Color(0xffEEEEEE),
            //                ),
            //                padding: const EdgeInsets.all(6),
            //                //height: MediaQuery.of(context).size.height / 3,
            //                child: Row(
            //                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                  children: [
            //                    Padding(
            //                      padding: const EdgeInsets.all(10.0),
            //                      child: Text(
            //                        "Select Template:",
            //                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            //                      ),
            //                    ),
            //
            //                    Row(
            //                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                      children: [
            //                        GestureDetector(
            //                          onTap: () {
            //                            setState(() {
            //                              templateIndex = 1;
            //                              templateViewColor(templateIndex);
            //                              setTemplate(1);
            //                            });
            //                          },
            //                          child: Container(
            //                            height: MediaQuery.of(context).size.height / 12,
            //                            width: MediaQuery.of(context).size.width / 18,
            //                            decoration: BoxDecoration(
            //                              borderRadius: BorderRadius.circular(6),
            //                              color: template1Color,
            //                            ),
            //                            alignment: Alignment.center,
            //                            child: Text(
            //                              "1",
            //                              style: TextStyle(
            //                                  color: template1Text,
            //                                  fontSize: 22,
            //                                  fontWeight: FontWeight.bold),
            //                            ),
            //                          ),
            //                        ),
            //                        const SizedBox(
            //                          width: 20,
            //                        ),
            //                        GestureDetector(
            //                          onTap: () {
            //                            setState(() {
            //                              templateIndex = 2;
            //                              templateViewColor(templateIndex);
            //                              setTemplate(2);
            //
            //                              //templateViewColor=
            //                            });
            //                          },
            //                          child: Container(
            //                            height: MediaQuery.of(context).size.height / 12,
            //                            width: MediaQuery.of(context).size.width / 18,
            //                            decoration: BoxDecoration(
            //                              borderRadius: BorderRadius.circular(6),
            //                              color: template2Color,
            //                            ),
            //                            alignment: Alignment.center,
            //                            child: Text(
            //                              "2",
            //                              style: TextStyle(
            //                                  color: template2Text,
            //                                  fontSize: 22,
            //                                  fontWeight: FontWeight.bold),
            //                            ),
            //                          ),
            //                        ),
            //                        const SizedBox(
            //                          width: 20,
            //                        ),
            //                        GestureDetector(
            //                          onTap: () {
            //                            setState(() {
            //                              templateIndex = 3;
            //                              templateViewColor(templateIndex);
            //                              setTemplate(3);
            //                              //templateViewColor=
            //                            });
            //                          },
            //                          child: Container(
            //                            height: MediaQuery.of(context).size.height / 12,
            //                            width: MediaQuery.of(context).size.width / 18,
            //                            decoration: BoxDecoration(
            //                              borderRadius: BorderRadius.circular(6),
            //                              color: template3Color,
            //                            ),
            //                            alignment: Alignment.center,
            //                            child: Text(
            //                              "3",
            //                              style: TextStyle(
            //                                  color: template3Text,
            //                                  fontSize: 22,
            //                                  fontWeight: FontWeight.bold),
            //                            ),
            //                          ),
            //                        ),
            //                        const SizedBox(
            //                          width: 20,
            //                        ),
            //                        GestureDetector(
            //                          onTap: () {
            //                            setState(() {
            //                              templateIndex = 4;
            //                              templateViewColor(templateIndex);
            //                              setTemplate(4);
            //                              //templateViewColor=
            //                            });
            //                          },
            //                          child: Container(
            //                            height: MediaQuery.of(context).size.height / 12,
            //                            width: MediaQuery.of(context).size.width / 18,
            //                            decoration: BoxDecoration(
            //                              borderRadius: BorderRadius.circular(6),
            //                              color: template4Color,
            //                            ),
            //                            alignment: Alignment.center,
            //                            child: Text(
            //                              "4",
            //                              style: TextStyle(
            //                                  color: template4Text,
            //                                  fontSize: 22,
            //                                  fontWeight: FontWeight.bold),
            //                            ),
            //                          ),
            //                        ),
            //                        const SizedBox(
            //                          width: 20,
            //                        ),
            //
            //                      ],
            //                    )
            //
            //                  ],
            //                ),
            //              ) ,
            //            ),
            //
            //            Card(
            //              child: Container(
            //                decoration: BoxDecoration(
            //                  borderRadius: BorderRadius.circular(6),
            //                  //  color: const Color(0xffEEEEEE),
            //                ),
            //                padding: const EdgeInsets.all(6),
            //               // height: MediaQuery.of(context).size.height / 3,
            //                child: Row(
            //                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                  children: [
            //                    SizedBox(
            //                      width: MediaQuery.of(context).size.width / 5,
            //                      child: TextField(
            //                        readOnly: true,
            //                        onTap: (){
            //                           SettingsData.defaultPrinterType ="1";
            //                           navigateToPrinter();
            //                        },
            //                         controller: defaultSalesInvoiceController,
            //                        decoration: const InputDecoration(
            //                          contentPadding: EdgeInsets.all(13),
            //                          hintText:'sales_invoice'.tr,
            //                          hintStyle: TextStyle(color: Colors.grey),
            //                          labelText: "Sales  invoice",
            //                          labelStyle: TextStyle(color: Colors.grey),
            //                          focusedBorder: OutlineInputBorder(
            //                              borderRadius:
            //                              BorderRadius.all(Radius.circular(5.0)),
            //                              borderSide: BorderSide(color: Colors.grey)),
            //                          isDense: true,
            //                          border: OutlineInputBorder(),
            //                        ),
            //                      ),
            //                    ),
            //                    SizedBox(width: 25,),
            //                    SizedBox(
            //                      width: MediaQuery.of(context).size.width / 5,
            //                      child: TextField(
            //                        readOnly: true,
            //                        onTap: (){
            //                          SettingsData.defaultPrinterType = "2";
            //                          navigateToPrinter();
            //                        },
            //                        controller: defaultSalesOrderController,
            //                        decoration: const InputDecoration(
            //                          contentPadding: EdgeInsets.all(13),
            //                          hintText: 'sale_order'.tr,
            //                          hintStyle: TextStyle(color: Colors.grey),
            //                          labelText: "Sales  order",
            //                          labelStyle: TextStyle(color: Colors.grey),
            //                          focusedBorder: OutlineInputBorder(
            //                              borderRadius:
            //                              BorderRadius.all(Radius.circular(5.0)),
            //                              borderSide: BorderSide(color: Colors.grey)),
            //                          isDense: true,
            //                          border: OutlineInputBorder(),
            //                        ),
            //                      ),
            //                    ),
            //                    SizedBox(width: 25,),
            //                    ElevatedButton(
            //
            //                        style: ElevatedButton.styleFrom(
            //                          primary: Colors.black, // Background color
            //                        ),
            //                        onPressed: (){
            //
            //                      SettingsData.defaultPrinterType ="3";
            //                      navigateToPrinter();
            //                    }, child: Text("Set default"))
            //
            //                  ],
            //                ),
            //              ),
            //            )
            ///Customize Print
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text(
            //       'Customize Print',
            //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            //     ),
            //     trailing: Padding(
            //       padding: const EdgeInsets.only(right: 30.0),
            //       child: Icon(
            //         Icons.arrow_forward_ios_outlined,
            //         color: Colors.black,
            //       ),
            //     ),
            //     onTap: () {
            //       setState(() {});
            //     },
            //   ),
            // ),
            ///Token Reset Time commented
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: Text(
            //       'Token Reset Time',
            //       style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
            //     ),
            //     trailing: Padding(
            //       padding: const EdgeInsets.only(right: 30.0),
            //       child: ValueListenableBuilder(
            //           valueListenable: token_time_notifier,
            //           builder: (BuildContext ctx, timeNewValue, _) {
            //             return Container(
            //               //       color: Colors.black,
            //               //width: MediaQuery.of(context).size.width * .2,
            //               child: GestureDetector(
            //                 onTap: () async {
            //                   TimeOfDay? pickedTime = await showTimePicker(
            //                     initialTime: TimeOfDay.now(),
            //                     context: context,
            //                   );
            //                   if (pickedTime != null) {
            //                     token_time_notifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
            //                     updateList("TokenResetTime", apiTimeFormate.format(token_time_notifier.value), "");
            //                   }
            //                 },
            //                 child: Text(
            //                   timeFormat.format(token_time_notifier.value) + "  Everyday",
            //                   style: customisedStyle(context, Color(0xffF25F29), FontWeight.normal, 15.0),
            //                 ),
            //               ),
            //             );
            //           }),
            //     ),
            //     onTap: () {},
            //   ),
            // ),






            ///Initial Token No
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                title: Text(
                  'intial_tkn'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.normal, 15.0),
                ),
                trailing: Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: 100,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                        // Only allow digits (numbers)
                      ],
                      // onTap: () => initialTokenNoController.selection = TextSelection(
                      //     baseOffset: 0,
                      //     extentOffset: initialTokenNoController.value.text.length),
                      // keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(
                      //       RegExp(r'^\d+\.?\d{0,8}')),
                      // ],
                      textAlign: TextAlign.right,
                      controller: initialTokenNoController,
                      // onChanged: (text){
                      //
                      //   if(text ==""){
                      //     text = "1";
                      //   }
                      //
                      //
                      // },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(initialTokenNode);
                        var val = "0";
                        if (initialTokenNoController.text != "") {
                          val = initialTokenNoController.text;
                        }

                        updateList("InitialTokenNo", val, "");
                      },
                      style: customisedStyle(context, const Color(0xffF25F29),
                          FontWeight.normal, 15.0),
                      // style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(6),
                        hintText: '',
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    )),
                onTap: () {
                  setState(() {});
                },
              ),
            ),

            /// Compensation Hour
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                title: Text(
                  'com_hr'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.normal, 15.0),
                ),
                trailing: DropdownButton<String>(
                  value: compensationHour,
                  underline: Container(),
                  items: dropdownValues.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value + " Hour ",
                        style: customisedStyle(context, const Color(0xffF25F29),
                            FontWeight.normal, 15.0),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    compensationHour = newValue!;
                    print("object   $newValue");
              updateList("CompensationHour", newValue, "");
                  },
                ),
                onTap: () {

                },
              ),
            ),

            /// Compensation Hour
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: const Text(
            //       'Waiter Can Pay',
            //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            //     ),
            //     trailing: SizedBox(
            //       width: 100,
            //       child: Center(
            //         child: FlutterSwitch(
            //           width: 40.0,
            //           height: 20.0,
            //           valueFontSize: 30.0,
            //           toggleSize: 15.0,
            //           value: waiterPay,
            //           borderRadius: 20.0,
            //           padding: 1.0,
            //           activeColor: Colors.green,
            //           activeTextColor: Colors.green,
            //           inactiveTextColor: Colors.white,
            //           inactiveColor: Colors.grey,
            //
            //           // showOnOff: true,
            //           onToggle: (val) {
            //             setState(() {
            //               waiterPay = val;
            //               switchStatus("waiterCanPay", waiterPay);
            //             });
            //           },
            //         ),
            //       ),
            //     ),
            //     onTap: () {
            //       setState(() {});
            //     },
            //   ),
            // ),
            Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              color: Colors.grey[100],
              child: ListTile(
                onTap: null,
                title: Text(
                  'complimentary_bill'.tr,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w400, 15.0),
                ),
                trailing: SizedBox(
                  width: 50,
                  child: Center(
                    child: FlutterSwitch(
                      width: 40.0,
                      height: 20.0,
                      valueFontSize: 30.0,
                      toggleSize: 15.0,
                      value: isComplimentaryBill,
                      borderRadius: 20.0,
                      padding: 1.0,
                      activeColor: Colors.green,
                      activeTextColor: Colors.green,
                      inactiveTextColor: Colors.white,
                      inactiveColor: Colors.grey,
                      // showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          isComplimentaryBill = val;
                          switchStatus(
                              "complimentary_bill", isComplimentaryBill);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

            /// commented
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 10.0, top: 10),
            //   child: Text(
            //     'item_section'.tr,
            //     style: customisedStyle(
            //         context, Colors.black, FontWeight.w500, 19.0),
            //   ),
            // ),
            //
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: Text(
            //       'KOT',
            //       style: customisedStyle(
            //           context, Colors.black, FontWeight.normal, 15.0),
            //     ),
            //     trailing: DropdownButton<String>(
            //       value: kotDetail,
            //       underline: Container(),
            //       items: kotDetailsValues.map((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: customisedStyle(context, const Color(0xff000000),
            //                 FontWeight.normal, 15.0),
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: (newValue) async {
            //         SharedPreferences prefs =
            //             await SharedPreferences.getInstance();
            //
            //         setState(() {
            //           kotDetail = newValue!;
            //
            //           prefs.setString("item_section_KOT", kotDetail);
            //         });
            //         // updateList("kotDetail",newValue, "");
            //       },
            //     ),
            //     onTap: () {},
            //   ),
            // ),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: Text(
            //       'sale_order'.tr,
            //       style: customisedStyle(
            //           context, Colors.black, FontWeight.normal, 15.0),
            //     ),
            //     trailing: DropdownButton<String>(
            //       value: saleDetail,
            //       underline: Container(),
            //       items: saleDetailsValues.map((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: customisedStyle(context, const Color(0xff000000),
            //                 FontWeight.normal, 15.0),
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: (newValue) async {
            //         SharedPreferences prefs =
            //             await SharedPreferences.getInstance();
            //
            //         setState(() {
            //           saleDetail = newValue!;
            //           prefs.setString("item_section_sale_order", saleDetail);
            //         });
            //         // updateList("kotDetail",newValue, "");
            //       },
            //     ),
            //     onTap: () {},
            //   ),
            // ),
            // Card(
            //   shape: RoundedRectangleBorder(
            //     side: const BorderSide(color: Color(0xffDFDFDF), width: 1),
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            //   color: Colors.grey[100],
            //   child: ListTile(
            //     title: Text(
            //       'sale_invoice'.tr,
            //       style: customisedStyle(
            //           context, Colors.black, FontWeight.normal, 15.0),
            //     ),
            //     trailing: DropdownButton<String>(
            //       value: saleInvoiceDetail,
            //       underline: Container(),
            //       items: saleInvoiceDetailsValues.map((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: customisedStyle(context, const Color(0xff000000),
            //                 FontWeight.normal, 15.0),
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: (newValue) async {
            //         SharedPreferences prefs =
            //             await SharedPreferences.getInstance();
            //
            //         setState(() {
            //           saleInvoiceDetail = newValue!;
            //           prefs.setString(
            //               "item_section_sale_invoice", saleInvoiceDetail);
            //         });
            //         // updateList("kotDetail",newValue, "");
            //       },
            //     ),
            //     onTap: () {},
            //   ),
            // ),

            const SizedBox(
              height: 50,
            )
          ]),
        )
      ],
    );
  }

  String compensationHour = '1';
  List<String> dropdownValues = ['1','2','3','4','5','6','7'];
  String kotDetail = 'Product Name';
  List<String> kotDetailsValues = [
    'Product Name',
    'Product Description',
    'Description'
  ];
  String saleDetail = 'Product Name';
  List<String> saleDetailsValues = [
    'Product Name',
    'Product Description',
    'Description'
  ];
  String saleInvoiceDetail = 'Product Name';
  List<String> saleInvoiceDetailsValues = [
    'Product Name',
    'Product Description',
    'Description'
  ];

  navigateToPrinter() async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectPrinter()),
    );
    print(result);

    if (result != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if (SettingsData.defaultPrinterType == "1") {
        defaultSalesInvoiceController.text = prefs.getString('defaultIP') ?? "";
      } else if (SettingsData.defaultPrinterType == "2") {
        defaultSalesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
      } else {
        defaultSalesInvoiceController.text = prefs.getString('defaultIP') ?? "";
        defaultSalesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
      }
    } else {}
  }

  Widget printerSettingScreen() {
    return Container(child: selectPrintScreen(printerSection));
  }

  selectPrintScreen(print) {
    if (print == 1) {
      return printerListScreen();
    } else if (print == 2) {
      return addPrinterScreen();
    }
  }

  /// printer list
  Widget printerListScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            'Printers'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
            //  TextStyle(
            //
            //   fontWeight: FontWeight.w600,
            //   color: Colors.black,
            //   fontSize: 20,
            // )
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.40, //height of button
          width: MediaQuery.of(context).size.width / 1.1,

          child: printDetailList.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: printDetailList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        // color: returnPrinterDefault(printDetailList[index].iPAddress),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey, width: .5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: ListTile(
                          onLongPress: () async {
                            deleteAlert(printDetailList[index].id, "", 2, "");
                          },
                          onTap: () async {
                            // SharedPreferences prefs =
                            //     await SharedPreferences.getInstance();
                            // defaultIp = printDetailList[index].iPAddress;
                            //
                            // prefs.setString(
                            //     "defaultIP", printDetailList[index].iPAddress);
                            // await listAllPrinter();
                            // dialogBox(context, "Printer set as default");
                          },
                          leading: IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(returnPrinterListIcon(printDetailList[index].type)),
                          ),

                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                printDetailList[index].printerName,
                                style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                              ),
                              Text(
                                printDetailList[index].iPAddress,
                                style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
                              ),
                            ],
                          ),
                          // title: Text(printDetailList[index].printerName +
                          //     "   " +
                          //     "(${printDetailList[index].iPAddress})"),
                        ));
                  }),
        ),
        Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 11, //height of button
                  width: MediaQuery.of(context).size.width / 15,

                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        printerSection = 2;
                      });
                    },
                    icon: SvgPicture.asset('assets/svg/addmore.svg'),
                    iconSize: 50,
                  ),
                )
              ],
            )),
      ],
    );
  }

  returnPrinterListIcon(type) {
    if (type == "WF") {
      return "assets/svg/wifi.svg";
    } else if (type == "BT") {
      return "assets/svg/bluetooth.svg";
    } else {
      return "assets/svg/usb.svg";
    }
  }

  var defaultIp = "";

  returnPrinterDefault(ip) {
    // prefs.setString(
    //     "defaultIP", printDetailList[index].iPAddress);

    print("selected ip $ip");
    print("selected defaultIP $defaultIp");
    print(ip);
    if (defaultIp == ip) {
      return Colors.blueGrey;
    } else {
      return Colors.white;
    }
  }

  Widget addPrinterScreen() {
    return ListView(shrinkWrap: true, children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 16, //height of button
        width: MediaQuery.of(context).size.width / 1,
        child:   Text('add_print'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
            // style: TextStyle(
            //   fontWeight: FontWeight.w600,
            //   color: Colors.black,
            //   fontSize: 20,
            // )
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 1.40, //height of button
        width: MediaQuery.of(context).size.width / 1.1,

        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child:   Text(
                  'print_name'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),

                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  focusNode: printerName,
                  controller: printerNameController,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(ipAddress1);
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(13),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  Text(
                    printType == "Wifi"? 'Ip Address':'Printer address',
                    style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
             printType == "Wifi" ?
             Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      textCapitalization: TextCapitalization.words,
                      focusNode: ipAddress1,
                      controller: ipAddressController1,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(ipAddress2);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(13),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 28,
                    height: MediaQuery.of(context).size.height / 16,
                    alignment: Alignment.center,
                    child: const Text(
                      '.',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: ipAddress2,
                      controller: ipAddressController2,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(ipAddress3);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(13),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 28,
                    height: MediaQuery.of(context).size.height / 16,
                    child: const Text(
                      '.',
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 8,
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.words,
                      focusNode: ipAddress3,
                      controller: ipAddressController3,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(ipAddress4);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(13),
                        focusedBorder:
                            OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 28,
                    height: MediaQuery.of(context).size.height / 16,
                    child: const Text(
                      '.',
                      style: TextStyle(
                        fontSize: 40,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 8,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                        focusNode: ipAddress4,
                        controller: ipAddressController4,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(saveIcon);
                        },
                        decoration: const InputDecoration(
                          focusedBorder:
                              OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                          contentPadding: EdgeInsets.all(13),
                          border: OutlineInputBorder(),
                        ),
                      ))
                ],
              ):
             SizedBox(
               width: MediaQuery.of(context).size.width / 8,
               child: TextFormField(
                 textAlign: TextAlign.center,
               //  keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                 textCapitalization: TextCapitalization.words,
                 focusNode: bluetoothAddress1,
                 controller: bluetoothAddressController,
                 onEditingComplete: () {
                   FocusScope.of(context).requestFocus(ipAddress2);
                 },
                 decoration: const InputDecoration(
                   contentPadding: EdgeInsets.all(13),
                   focusedBorder:
                   OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                   border: OutlineInputBorder(),
                 ),
               ),
             ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 10, //height of button
        width: MediaQuery.of(context).size.width / 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 16,

            child: IconButton(
              onPressed: () {
                setState(() {
                  printerSection = 1;
                  ipAddressController1.clear();
                  ipAddressController2.clear();
                  ipAddressController3.clear();
                  ipAddressController4.clear();
                  printerNameController.clear();
                });
              },
              icon: SvgPicture.asset('assets/svg/delete.svg'),
              iconSize: 40,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 16,

            child: IconButton(
              onPressed: () {

                if(printType =="Wifi"){
                  if (printerNameController.text.trim() == '' ||
                      ipAddressController1.text == '' ||
                      ipAddressController2.text == '' ||
                      ipAddressController3.text == '' ||
                      ipAddressController4.text == '') {
                    dialogBox(context, "Please fill mandatory field");
                  } else {
                     createPrinterApi("Wifi");
                  }
                }



                else if(printType =="BT"){
                  if (printerNameController.text.trim() == '' || bluetoothAddressController.text == '') {
                     dialogBox(context,"Please fill mandatory field");
                  } else {
                    createPrinterApi("BT");
                  }
                }
                else{
                  if (printerNameController.text.trim() == '' || bluetoothAddressController.text == '') {
                    dialogBox(context,"Please fill mandatory field");
                  } else {
                    createPrinterApi("USB");
                  }
                }

              },
              icon: SvgPicture.asset(
                'assets/svg/add.svg',
              ),
              iconSize: 40,
              focusNode: saveIcon,
            ),
          ),
        ]),
      )
    ]);
  }

  Widget kitchenSettingScreen() {
    return Container(
      child: selectKitchenSetting(kitchen),
    );
  }

  selectKitchenSetting(int kitchen) {
    if (kitchen == 1) {
      return kitchenListDisplay();
    } else if (kitchen == 2) {
      return addKitchenScreen();
    }
  }

  Widget kitchenListDisplay() {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Text('kit_set'.tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0)),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 1.4, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            child: kitchenList.isEmpty
                ? Container()
                : ListView.builder(
                    controller: kitchenListController,
                    shrinkWrap: true,
                    itemCount: kitchenList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey, width: .5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              deleteAlert(kitchenList[index].kitchenUid, "", 1, "");
                            },
                            onTap: () {
                              setState(() {
                                kitchenEdit = true;
                                _selectedIndex = 1000;
                                kitchenNameController.clear();
                                descriptionController.clear();
                                ipAddress = '';
                                kotShow = false;
                                getKitchenSingleView(kitchenList[index].kitchenUid);
                                kitchen = 2;
                              });
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  kitchenList[index].kitchenName,
                                  style: customisedStyle(context, Colors.black, FontWeight.w300, 14.0),
                                ),
                                Text(
                                  kitchenList[index].ip,
                                  style: customisedStyle(context, Colors.grey, FontWeight.w400, 13.0),
                                ),
                              ],
                            ),
                          ));
                    })),
        SizedBox(
          height: MediaQuery.of(context).size.height / 11, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    kitchen = 2;
                  });
                },
                icon: SvgPicture.asset('assets/svg/addmore.svg'),
                iconSize: 50,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget addKitchenScreen() {
    return ListView(shrinkWrap: true, children: [
      SizedBox(
        height: MediaQuery.of(context).size.height / 16, //height of button
        width: MediaQuery.of(context).size.width / 1,
        child:   Text('Add Kitchen',
            style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 1.40, //height of button
        width: MediaQuery.of(context).size.width / 1.1,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.40, //height of button
              width: MediaQuery.of(context).size.width / 1.1,
              child: ListView(
                children: [
                    Text(
                   'name'.tr,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: TextField(
                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                      controller: kitchenNameController,
                      textCapitalization: TextCapitalization.words,
                      focusNode: kitchenNameFocusNode,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(kitchenDescriptionFocusNode);
                      },
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'kit_name'.tr,
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w500, 14.0),
                        //  errorText: _errorText,
                        contentPadding: const EdgeInsets.all(13),
                        isDense: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                   Text(
                   'description'.tr,
                     style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                     textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    child: TextField(
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      focusNode: kitchenDescriptionFocusNode,
                      controller: descriptionController,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(kitchenSaveFocusNode);
                      },

                      textCapitalization: TextCapitalization.words,
                      //   keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(13),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  ///kitchen print
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        //height: MediaQuery.of(context).size.height / 25,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'kit_print'.tr,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                      //  height: MediaQuery.of(context).size.height / 25,
                        width: 100,
                        child: FlutterSwitch(
                          width: 40.0,
                          height: 20.0,
                          valueFontSize: 30.0,
                          toggleSize: 15.0,
                          value: kotShow,
                          borderRadius: 20.0,
                          padding: 1.0,
                          activeColor: Colors.green,
                          activeTextColor: Colors.green,
                          inactiveTextColor: Colors.white,
                          inactiveColor: Colors.grey,
                          onToggle: (val) {
                            setState(() {
                              ipAddress = "";
                              kotShow = val;
                              _selectedIndex = 1000;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  kotShow == true
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 2, //height of button
                              width: MediaQuery.of(context).size.width / 1.1,

                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: printDetailList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Card(
                                      color: _selectedIndex == index ? Colors.blueGrey : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(color: Colors.grey, width: .5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: ListTile(
                                        selected: index == _selectedIndex,
                                        leading: IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset('assets/svg/wifi.svg'),
                                        ),
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              printDetailList[index].printerName,
                                              style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                            ),
                                            Text(
                                              printDetailList[index].iPAddress,
                                              style: customisedStyle(context, Colors.grey, FontWeight.w300, 13.0),
                                            ),
                                          ],
                                        ),
                                        // subtitle: Text(
                                        //   printDetailList[index].iPAddress,
                                        //   style: customisedStyle(context, Colors.black, FontWeight.w300, 13.0),
                                        // ),
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex = index;
                                            ipAddress = printDetailList[index].iPAddress;
                                          });
                                        },
                                        // trailing: GestureDetector(
                                        //   child: Container(
                                        //     width: 20,
                                        //     height: 20,
                                        //     child: const Icon(
                                        //       Icons.check,
                                        //       size: 16,
                                        //       color: Colors.white,
                                        //     ),
                                        //     decoration: BoxDecoration(
                                        //         shape: BoxShape.circle,
                                        //         color: c2,
                                        //         border:
                                        //         Border.all(color: Colors.grey)),

                                        // onTap: () {
                                        //   setState(() {
                                        //     c1 = Colors.white;
                                        //     c2 = Colors.green;
                                        //     c3 = Colors.white;
                                        //   });
                                        // },
                                        //  ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height / 11, //height of button
        width: MediaQuery.of(context).size.width / 1,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 16,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 1000;
                  ipAddress = "";
                  kitchen = 1;
                  kitchenEdit = false;
                  kotShow = false;
                  kitchenNameController.clear();
                  descriptionController.clear();
                });
              },
              icon: SvgPicture.asset('assets/svg/delete.svg'),
              iconSize: 40,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 16,
            child: IconButton(
                focusNode: kitchenSaveFocusNode,
                onPressed: () async {
                  if (kitchenNameController.text == '') {
                    dialogBox(context, "Please enter kitchen name");
                  } else {
                    start(context);

                    kitchenEdit == true ? editKitchenDetail() : createKitchenApi();
                  }
                },
                icon: SvgPicture.asset(
                  'assets/svg/add.svg',
                ),
                iconSize: 40),
          ),
        ]),
      )
    ]);
  }

  int _selectedIndex = 0;

  String? get _errorText {
    final text = kitchenNameController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  String? get validator {
    final text = organizationNameController.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  ///printer Template
  Widget printerTemplate() {
    return Container(
      child: templateViewt(),
    );
  }

  ///printer Template
  Widget printerDefault() {
    return Container(
      child: templateView(),
    );
  }

  Widget templateView() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        //  color: const Color(0xffEEEEEE),
      ),
      padding: const EdgeInsets.all(6),
      height: MediaQuery.of(context).size.height / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: TextField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              // controller: roleNameController,
              decoration:   InputDecoration(
                contentPadding: const EdgeInsets.all(13),
                hintText:'sales_invoice'.tr,
                hintStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
            child: TextField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              // controller: roleNameController,
              decoration:   InputDecoration(
                contentPadding: const EdgeInsets.all(13),
                hintText: 'sale_order'.tr,
                hintStyle: const TextStyle(color: Colors.grey),
                focusedBorder: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          ElevatedButton(onPressed: () {}, child: Text('set_both'.tr))
        ],
      ),
    );
  }

  Widget templateViewt() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        //  color: const Color(0xffEEEEEE),
      ),
      padding: const EdgeInsets.all(6),
      height: MediaQuery.of(context).size.height / 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'select_print'.tr,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                templateIndex = 1;
                templateViewColor(templateIndex);
                setTemplate(1);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: template1Color,
              ),
              alignment: Alignment.center,
              child: Text(
                "1",
                style: TextStyle(color: template1Text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                templateIndex = 2;
                templateViewColor(templateIndex);
                setTemplate(2);

                //templateViewColor=
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: template2Color,
              ),
              alignment: Alignment.center,
              child: Text(
                "2",
                style: TextStyle(color: template2Text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                templateIndex = 3;
                templateViewColor(templateIndex);
                setTemplate(3);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: template3Color,
              ),
              alignment: Alignment.center,
              child: Text(
                "3",
                style: TextStyle(color: template3Text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                templateIndex = 4;
                templateViewColor(templateIndex);
                setTemplate(4);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: template4Color,
              ),
              alignment: Alignment.center,
              child: Text(
                "4",
                style: TextStyle(color: template4Text, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget templateView() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(6),
  //       //  color: const Color(0xffEEEEEE),
  //     ),
  //     padding: const EdgeInsets.all(6),
  //     height: MediaQuery.of(context).size.height / 3,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Text(
  //             "Select printer:",
  //             style: TextStyle(fontSize: 20),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               templateIndex = 1;
  //               templateViewColor(templateIndex);
  //               setTemplate(1);
  //             });
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 6,
  //             width: MediaQuery.of(context).size.width / 8,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6),
  //               color: template1Color,
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "1",
  //               style: TextStyle(
  //                   color: template1Text,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 20,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               templateIndex = 2;
  //               templateViewColor(templateIndex);
  //               setTemplate(2);
  //
  //               //templateViewColor=
  //             });
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 6,
  //             width: MediaQuery.of(context).size.width / 8,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6),
  //               color: template2Color,
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "2",
  //               style: TextStyle(
  //                   color: template2Text,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 20,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               templateIndex = 3;
  //               templateViewColor(templateIndex);
  //               setTemplate(3);
  //               //templateViewColor=
  //             });
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 6,
  //             width: MediaQuery.of(context).size.width / 8,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6),
  //               color: template3Color,
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "3",
  //               style: TextStyle(
  //                   color: template3Text,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 20,
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             setState(() {
  //               templateIndex = 4;
  //               templateViewColor(templateIndex);
  //               setTemplate(4);
  //               //templateViewColor=
  //             });
  //           },
  //           child: Container(
  //             height: MediaQuery.of(context).size.height / 6,
  //             width: MediaQuery.of(context).size.width / 8,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6),
  //               color: template4Color,
  //             ),
  //             alignment: Alignment.center,
  //             child: Text(
  //               "4",
  //               style: TextStyle(
  //                   color: template4Text,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  templateViewColor(int templateIndex) async {
    if (templateIndex == 1) {
      template1Color = const Color(0xff009253);
      template2Color = const Color(0xffFFFFFF);
      template3Color = const Color(0xffFFFFFF);
      template4Color = const Color(0xffFFFFFF);

      template4Text = const Color(0xffC8C8C8);
      template1Text = const Color(0xffffffff);
      template2Text = const Color(0xffC8C8C8);
      template3Text = const Color(0xffC8C8C8);
    } else if (templateIndex == 2) {
      template1Color = const Color(0xffFFFFFF);
      template2Color = const Color(0xff009253);
      template3Color = const Color(0xffffffff);
      template4Color = const Color(0xffFFFFFF);

      template4Text = const Color(0xffC8C8C8);
      template1Text = const Color(0xffC8C8C8);
      template2Text = const Color(0xffffffff);
      template3Text = const Color(0xffC8C8C8);
    } else if (templateIndex == 3) {
      template1Color = const Color(0xffFFFFFF);
      template2Color = const Color(0xffFFFFFF);
      template3Color = const Color(0xff009253);
      template4Color = const Color(0xffFFFFFF);

      template4Text = const Color(0xffC8C8C8);

      template1Text = const Color(0xffC8C8C8);
      template2Text = const Color(0xffC8C8C8);
      template3Text = const Color(0xffffffff);
    } else {
      template1Color = const Color(0xffFFFFFF);
      template2Color = const Color(0xffFFFFFF);
      template3Color = const Color(0xffFFFFFF);
      template4Color = const Color(0xff009253);

      template1Text = const Color(0xffC8C8C8);
      template2Text = const Color(0xffC8C8C8);
      template3Text = const Color(0xffC8C8C8);
      template4Text = const Color(0xffffffff);
    }
  }

  setTemplate(id) async {
    print("template$id");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("template", "template$id");
  }

  ///users list
  Widget usersSettingScreen() {
    return Container(
      child: selectUsersScreen(user),
    );
  }

  selectUsersScreen(int user) {
    if (user == 1) {
      return usersListScreen();
    } else if (user == 2) {
      return createUserScreen();
    }
  }

  Widget usersListScreen() {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 16, //height of button
            width: MediaQuery.of(context).size.width / 1,

            child:   Text('Users'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.40, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            //  color: Colors.red[100],
            child: usersList.isEmpty
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: usersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.grey, width: .5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: ListTile(
                            onLongPress: () {
                              _showAlertDialog(usersList[index].uuid, "");
                            },
                            onTap: () {
                              setState(() {
                                edit = true;
                                getUserSingleView(usersList[index].uuid);
                                user = 2;
                              });

                              //  UserDetails.user_id=usersList[index].id;
                            },
                            leading: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/user.svg'),
                            ),
                            title: Text(usersList[index].userName, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/arrow.svg'),
                            ),
                          ));
                    }),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 7,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      user = 2;
                    });
                  },
                  icon: SvgPicture.asset('assets/svg/addmore.svg'),
                  iconSize: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget createUserScreen() {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,

          child:   Text('Users'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              )),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
               'name'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                child: TextFormField(
                  readOnly: true,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),

                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectUser()),
                    );

                    print(result);

                    if (result != null) {

                        userNameController.text = result;

                    }
                  },

                  focusNode: usersName,
                  controller: userNameController,
                  decoration:  InputDecoration(
                    hintText: 'select_employee'.tr,
                    hintStyle: customisedStyle(context, Colors.grey, FontWeight.w500, 14.0),
                    contentPadding: const EdgeInsets.all(13),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    focusedBorder:
                        const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                      //allow upper and lower case alphabets and space
                      return "Enter Correct Name";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.6,
                      child:   Text(
                        'PIN',
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.6,
                      child:   Text(
                        'Role'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12, //height of button
                    width: MediaQuery.of(context).size.width / 3.5,
                    // color:Colors.red,
                    child: Row(
                      //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          child: TextField(
                            readOnly: true,
                            controller: pinGenerateController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(13),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 16,
                          width: MediaQuery.of(context).size.width / 8,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(10.0),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              if (userNameController.text == '') {
                                dialogBox(context, "Please select a employee");
                              } else {
                                generatePinNumber();
                              }
                            },
                            child:   Text('Generate'.tr,style: customisedStyle(context, Colors.white, FontWeight.w500, 14.0),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12, //height of button
                    width: MediaQuery.of(context).size.width / 3.5,
                    // color:Colors.red,
                    child: Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 7,
                          child: TextField(
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SelectRoles()),
                              );

                              print(result);

                              if (result != null) {

                                  userRoleController.text = result;

                              }
                            },
                            readOnly: true,
                            controller: userRoleController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(13),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              isDense: true,
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 16,
                          width: MediaQuery.of(context).size.width / 8,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(10.0),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                roleList = true;
                              });
                            },
                            child:   Text('New'.tr,style: customisedStyle(context, Colors.white, FontWeight.w500, 14.0),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              ///admin access
              // SizedBox(
              //   height:
              //       MediaQuery.of(context).size.height / 1.9, //height of button
              //   width: MediaQuery.of(context).size.width / 3,
              //   // color: Colors.red,
              //   child: Column(
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.all(8),
              //         // color:Colors.red,
              //         height: MediaQuery.of(context).size.height /
              //             12, //height of button
              //         width: MediaQuery.of(context).size.width / 3,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             const Text('Admin Access',
              //                 style: TextStyle(fontWeight: FontWeight.w300)),
              //             SizedBox(
              //               //width: 100,
              //                 child: FlutterSwitch(
              //                   width: 40.0,
              //                   height: 20.0,
              //                   valueFontSize: 30.0,
              //                   toggleSize: 15.0,
              //                   value: quantityIncrement,
              //                   borderRadius: 20.0,
              //                   padding: 1.0,
              //                   activeColor: Colors.green,
              //                   activeTextColor: Colors.green,
              //                   inactiveTextColor: Colors.white,
              //                   inactiveColor: Colors.grey,
              //                   onToggle: (val) {
              //                     setState(() {
              //                       quantityIncrement = val;
              //                       // printKitchen == true;
              //                     });
              //                   },
              //                 ))
              //           ],
              //         ),
              //       ),
              //
              //
              //
              //     ],
              //   ),
              // ),

              roleList == true
                  ? Container(
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: ListView(
                        children: [
                            Text(
                            'Role'.tr,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: TextField(
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              controller: roleNameController,
                              decoration:   InputDecoration(
                                contentPadding: const EdgeInsets.all(13),
                                hintText: 'role_name'.tr,
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                                isDense: true,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(
                                  'Dining'.tr,
                                  style: const TextStyle(fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                    child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  valueFontSize: 30.0,
                                  toggleSize: 15.0,
                                  value: diningSwitch,
                                  borderRadius: 20.0,
                                  padding: 1.0,
                                  activeColor: Colors.green,
                                  activeTextColor: Colors.green,
                                  inactiveTextColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onToggle: (val) {
                                    setState(() {
                                      diningSwitch = val;
                                    });
                                  },
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text('Take_awy'.tr, style: const TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                    child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  valueFontSize: 30.0,
                                  toggleSize: 15.0,
                                  value: takeSwitch,
                                  borderRadius: 20.0,
                                  padding: 1.0,
                                  activeColor: Colors.green,
                                  activeTextColor: Colors.green,
                                  inactiveTextColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onToggle: (val) {
                                    setState(() {
                                      takeSwitch = val;
                                    });
                                  },
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text('Online'.tr, style: const TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                    child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  valueFontSize: 30.0,
                                  toggleSize: 15.0,
                                  value: onlineSwitch,
                                  borderRadius: 20.0,
                                  padding: 1.0,
                                  activeColor: Colors.green,
                                  activeTextColor: Colors.green,
                                  inactiveTextColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onToggle: (val) {
                                    setState(() {
                                      onlineSwitch = val;
                                    });
                                  },
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text('Car'.tr, style: const TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                    child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  valueFontSize: 30.0,
                                  toggleSize: 15.0,
                                  value: carSwitch,
                                  borderRadius: 20.0,
                                  padding: 1.0,
                                  activeColor: Colors.green,
                                  activeTextColor: Colors.green,
                                  inactiveTextColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onToggle: (val) {
                                    setState(() {
                                      carSwitch = val;
                                    });
                                  },
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Text('Kitchen'.tr, style: const TextStyle(fontWeight: FontWeight.w300)),
                                SizedBox(
                                    child: FlutterSwitch(
                                  width: 40.0,
                                  height: 20.0,
                                  valueFontSize: 30.0,
                                  toggleSize: 15.0,
                                  value: kitchenSwitch,
                                  borderRadius: 20.0,
                                  padding: 1.0,
                                  activeColor: Colors.green,
                                  activeTextColor: Colors.green,
                                  inactiveTextColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  onToggle: (val) {
                                    setState(() {
                                      kitchenSwitch = val;
                                    });
                                  },
                                ))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(10.0),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green,
                                    textStyle: const TextStyle(fontSize: 13),
                                  ),
                                  onPressed: () {
                                    if (roleNameController.text == '') {
                                      dialogBox(context, "Please enter a role name ");
                                    } else {
                                      createNewRoleApi();
                                      setState(() {
                                        roleList = false;
                                      });
                                    }
                                  },
                                  child:   Text('Add'.tr),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 11, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              height: MediaQuery.of(context).size.height / 11, //height of button

              width: MediaQuery.of(context).size.width / 16,

              child: IconButton(
                onPressed: () {
                  setState(() {
                    userNameController.clear();
                    userRoleController.clear();
                    pinGenerateController.clear();
                    user = 1;
                  });
                },
                icon: SvgPicture.asset('assets/svg/delete.svg'),
                iconSize: 40,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 11, //height of button

              width: MediaQuery.of(context).size.width / 16,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      if (userNameController.text == '' || pinGenerateController.text == '' || userRoleController.text == '') {
                        dialogBox(context, "Please enter mandatory fields");

                        //
                      } else {
                        edit == true ? editUserDetail(posUserId) : createNewUser();
                      }
                    });
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/add.svg',
                  ),
                  iconSize: 40),
            ),
          ]),
        )
      ],
    );
  }

  bool isDelivery = false;

  Widget deliveryScreen() {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 16, //height of button
            width: MediaQuery.of(context).size.width / 1,

            child:   Text('delivery_man'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20,
                )),
          ),
          isDelivery == true
              ? Container(
                  height: MediaQuery.of(context).size.height / 1.40, //height of button
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('name'.tr),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 20,
                          width: MediaQuery.of(context).size.width / 2,
                          decoration: const BoxDecoration(
                              //  border:Border.all(color:Color(0xff858585),width: .5)
                              ),
                          child: TextField(
                            onTap: () {},
                            controller: staffNameController,
                            decoration:   InputDecoration(
                              contentPadding: const EdgeInsets.all(6),
                              focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff858585), width: .5)),
                              enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xff858585), width: .5)),
                              hintText: 'name'.tr,
                              hintStyle: const TextStyle(color: Color(0xffAFAFAF)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height / 1.40, //height of button
                  width: MediaQuery.of(context).size.width / 1.1,
                  //  color: Colors.red[100],
                  child: ListView.builder(
                      // the number of items in the list
                      itemCount: 3,

                      // display each item of the product list
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3), side: const BorderSide(width: 1, color: Color(0xffDFDFDF))),
                          color: const Color(0xffF3F3F3),
                          child: ListTile(
                            title: Text(
                              'delivery_man'.tr,
                              style: const TextStyle(color: Colors.black),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }),
                ),
          isDelivery == true
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 11, //height of button
                  width: MediaQuery.of(context).size.width / 1,
                  child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 11, //height of button

                      width: MediaQuery.of(context).size.width / 16,

                      child: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/svg/delete.svg'),
                        iconSize: 40,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 11, //height of button

                      width: MediaQuery.of(context).size.width / 16,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              isDelivery = false;
                            });
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/add.svg',
                          ),
                          iconSize: 40),
                    ),
                  ]),
                )
              : Container(
                  height: MediaQuery.of(context).size.height / 11, //height of button
                  width: MediaQuery.of(context).size.width / 7,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isDelivery = true;
                          });
                        },
                        icon: SvgPicture.asset('assets/svg/addmore.svg'),
                        iconSize: 50,
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  /// token reset time

  late ValueNotifier<DateTime> token_time_notifier = ValueNotifier(DateTime.now());
  DateFormat timeFormat = DateFormat.jm();

  /// create waiter
  List<WaitersModel> waiterLists = [];

  deleteWaiterApi(id, type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String baseUrl = BaseUrl.baseUrl;
        final String url = "$baseUrl/posholds/delete-pos-hold-staff/";

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        Map data = {
          "id": id,
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "staff_type": type,
        };
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        print(response.body);
        print(status);
        if (status == 6000) {
          waiterLists.clear();
          stop();
          dialogBox(context, "Deleted Successfully");
          listWaiterApi(index == 12 ? '0' : '1');
        } else if (status == 6001) {
          stop();
          var msg = n["message"] ?? '';
          dialogBox(context, msg);
        } else {
          stop();
        }
      } catch (e) {
        dialogBox(context, "Something went wrong");
        stop();
      }
    }
  }

  Future<Null> listWaiterApi(type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        start(context);
        String baseUrl = BaseUrl.baseUrl;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        String url = "$baseUrl/posholds/list-pos-hold-staff/";
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "type": type,
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
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          stop();
          setState(() {
            waiterLists.clear();
            for (Map user in responseJson) {
              waiterLists.add(WaitersModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"] ?? '';
          dialogBox(context, msg);
        } else {
          stop();
        }
      } catch (e) {
        print(e.toString());
        stop();
      }
    }
  }

  createWaiter(type) async {
    try {
      start(context);
      var res = await createWaiterPOS(context: context, waiterName: staffNameController.text, waiterId: waiterID, staffType: type);

      if (res[0] == 6000) {
        staffNameController.clear();
        stop();
        dialogBox(context, res[1]);
        listWaiterApi(type);
        setState(() {
          waiterID = "";
          createWaiterBool = false;
        });
      } else {
        stop();
      }
    } catch (e) {
      stop();
    }
  }

  Widget waiterListScreen() {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 16, //height of button
            width: MediaQuery.of(context).size.width / 1,

            child: Text(index == 12 ? 'Waiter' : 'Delivery man',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20,
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.40, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            //  color: Colors.red[100],
            child: waiterLists.isNotEmpty
                ? ListView.builder(
                    // the number of items in the list
                    itemCount: waiterLists.length,
                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3), side: const BorderSide(width: 1, color: Color(0xffDFDFDF))),
                        color: const Color(0xffF3F3F3),
                        child: ListTile(
                          onLongPress: () async {
                            deleteAlert(waiterLists[index].waiterUID, "", 3, "");
                          },
                          onTap: () {
                            setState(() {
                              createWaiterBool = true;
                              isEditWaiter = true;
                              waiterID = waiterLists[index].waiterUID;
                              staffNameController.text = waiterLists[index].waiterName;
                            });
                          },
                          title: Text(
                            waiterLists[index].waiterName,
                            style: const TextStyle(color: Colors.black),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: Colors.black,
                          ),
                        ),
                      );
                    })
                : const Center(
                    child: Text("No data"),
                  ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 7,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      createWaiterBool = true;
                    });
                  },
                  icon: SvgPicture.asset('assets/svg/addmore.svg'),
                  iconSize: 50,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget createWaiterScreen() {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,

          child: Text(index == 12 ? 'Waiter' : 'Delivery man',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              )),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
               'name'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 3,
              ),
              SizedBox(
                child: TextFormField(
                  controller: staffNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(13),
                    focusedBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)), borderSide: BorderSide(color: Colors.grey)),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 11, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              height: MediaQuery.of(context).size.height / 11, //height of button

              width: MediaQuery.of(context).size.width / 16,

              child: IconButton(
                onPressed: () {
                  setState(() {
                    createWaiterBool = false;
                    staffNameController.clear();
                    isEditWaiter = false;
                    waiterID = "";
                  });
                },
                icon: SvgPicture.asset('assets/svg/delete.svg'),
                iconSize: 40,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 11, //height of button

              width: MediaQuery.of(context).size.width / 16,
              child: IconButton(
                  onPressed: () {
                    if (staffNameController.text == "") {
                      dialogBox(context, "Enter waiter name");
                    } else {
                      createWaiter(index == 12 ? '0' : '1');
                    }
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/add.svg',
                  ),
                  iconSize: 40),
            ),
          ]),
        )
      ],
    );
  }

  Widget waiterScreen() {
    return Container(child: createWaiterBool == false ? waiterListScreen() : createWaiterScreen());
  }

  /// delivery man

  Widget contactUSScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,

          child:   Text('contact_us'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0)),
        ),
        Container(
            height: MediaQuery.of(context).size.height / 1.40, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height / 3, //height of button
                  width: MediaQuery.of(context).size.width / 2,

                  child: SvgPicture.asset(
                    'assets/svg/Logo.svg',
                    height: 200,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _copyToClipboard();
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 32, //height of button
                    width: MediaQuery.of(context).size.width / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'INDIA',style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)
                        ),
                        Text(
                          india,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0)
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    copyPhone();
                  },
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 32, //height of button
                    width: MediaQuery.of(context).size.width / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'KSA ',style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ksa,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0)
                            ),
                            Text(
                              ksa1,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 32, //height of button
                  width: MediaQuery.of(context).size.width / 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Email'.tr,style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)
                      ),
                      Text(
                        'info@vikncodes.com',style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0)
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height / 30, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    'www.viknbooks.com',style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0)
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.center,
                  //  height: MediaQuery.of(context).size.height / 24, //height of button
                    //width: MediaQuery.of(context).size.width / 1.3,
                    child: TextButton(
                      onPressed: () {
                        // _copyToClipboard();
                        //  print(num);
                      },
                      child: Text(
                        'Tap Here For Copy',
                          style: customisedStyle(context, Colors.white, FontWeight.w600, 15.0)
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffF25F29)),
                      ),
                    )),
              ],
            ))
      ],
    );
  }

  Widget privacyPoliciesScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child:   Text('Privacy Policies',
            style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 1.40, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            child: ListView(children: <Widget>[
              SelectableText(
                """The privacy policy will help you understand how we uses and protects the data you provide to us when you visit and use (“Application “,”service”).\n\nWe reserve the right to change this policy at any given time, of which you will be promptly updated. If you want to make sure that you are up to date with the latest changes, we advise you to frequently visit this page
           
""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "What user data we collect\n",
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 5.0,
                ),
              ),

              SelectableText(
                """When you visit the Application, you may collect the following data  \n \u2022 Your IP addresses \n \u2022 Your contact information and email address \n \u2022 Other information such as interests and preference \n \u2022 Data profile_mobile regarding your online behavior on our Application.
   
""",
                textAlign: TextAlign.justify,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),

              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Why we collect your data\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              SelectableText(
                """
We are collecting your data for several reasons\n \u2022 To better understand your needs \n \u2022 To improve our services and products.\n \u2022 To send your promotional emails containing the information we think you will find interesting\n \u2022 To contact you to fulfill out surveys and participate in other types of market research.\n \u2022 To customize our application according to your online behavior and personal performance.
   
""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Safeguarding and securing the data\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SelectableText(
                """
Our application is committed to securing your data and keeping it confidential The application has done all in its power to prevent data theft,unauthorized access and disclosure by implementing the latest technologies and software, which help us safeguard all the information we collect online.
   
""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Third party sites\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SelectableText(
                """Some pages of our application may contain links to Application that are not linked to this Privacy Policy. If you submit your personal information to any of these third-party sites, your personal information is governed by their privacy policies.\n As a safety measure, we recommend that you not share any personal information with these third parties unless you've checked their privacy policies and assured yourself of their privacy practices.   
""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),

              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Link to other Application\n ",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              SelectableText(
                """
Our application contains links that lead to other applications. If you click on these links(name) is not held responsible for your data and privacy protection. Visiting those applications is not governed by this privacy policy agreement. Make sure to read the privacy policy documentation of the application you go to from our application.\n""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),

              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "Restricting the collection of your personal data\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),

              ///Restricting the collection of your personal data page 2
              SelectableText(
                """
At some point, you might wish to restrict the use and collection of your personal data. You can achieve this by doing the following:\n \u2022 When you are filling the forms on the Application, make sure to check if there is a box which you can leave unchecked, if you don’t want to disclose your personal information. \n \u2022 If you have already agreed to share your information with us, feel free to contact us via email and we will be more than happy to change this for you.\n\n[name] will not lease, sell or distribute your personal information to any third parties, unless we have your permission. We might do so if the law forces us. Your personal information will be used when we need to send your promotional materials if you agree to this privacy policy.  """,
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nDATA RETENTION\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              SelectableText(
                """When you place an order through the Site, we will maintain your Order Information for our records unless and until you ask us to delete this information. """,
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nCHANGES TO THIS PRIVACY POLICY\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              SelectableText(
                """We may update this privacy policy from time to time in order to reflect, for example, changes to our practices or for other operational, legal or regulatory reasons. All updates to our privacy policy will be posted on this application. """,
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nJURISDICTION\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              SelectableText(
                """If you choose to visit the application or use our services, your visit and any dispute over privacy is subject to this policy and services terms of use.in addition to the forgoing, any disputes arising under this policy shall be governed by the laws of India. """,
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nCONTACT US\n",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),

              SelectableText(
                """If you have questions about this Privacy Policy, the practices of this application, or your dealings with this application, to request access to, or correction of your Personal Information, please send an email to""",
                textAlign: TextAlign.justify,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),
              GestureDetector(
                onTap: () {
                  // FlutterWebBrowser.openWebPage(
                  //   url: "https://vikncodes.com/",
                  //   customTabsOptions: CustomTabsOptions(
                  //     colorScheme: CustomTabsColorScheme.dark,
                  //     darkColorSchemeParams: CustomTabsColorSchemeParams(
                  //       toolbarColor: Colors.deepPurple,
                  //       secondaryToolbarColor: Colors.green,
                  //       navigationBarColor: Colors.amber,
                  //       navigationBarDividerColor: Colors.cyan,
                  //     ),
                  //     shareState: CustomTabsShareState.on,
                  //     instantAppsEnabled: true,
                  //     showTitle: true,
                  //     urlBarHidingEnabled: true,
                  //   ),
                  // );
                },
                child: Text(
                  'info@vikncodes.com',
                  style: customisedStyle(context, Colors.blueAccent, FontWeight.w500, 15.0),
                ),
              ),
              SelectableText(
                "with the mention “Legal/Privacy” in its subject line, or write to us at:",
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                textAlign: TextAlign.justify,
              ),

              Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: "\nVikn Codes LLP ",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                    )
                  ],
                ),
                //  textAlign: TextAlign.center,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              SelectableText(
                """\nOffice Unit No. 11\nUpper Basement Sahya IT SEZ Building\nCyberpark, Calicut
 """,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
              ),

              ///
            ]))
      ],
    );
  }

  Widget termsAndConditionScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          child:   Text('Terms And Conditions',
            style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.40, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: ListView(children: <Widget>[
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Last updated: (Date)",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
            SelectableText(
              """\nPlease read these terms and conditions carefully before using the Application. Your access to and use of the service is conditioned on your acceptance of and compliance with these terms. \n\nThese terms apply to all visitors, users and others who access or use the service.These terms will be applied fully and affect to your use of this application. By using this application, you agreed to accept all terms and conditions written in here. You must not use this application if you disagree with any of these application standard terms and conditions.     
""",
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Intellectual Property Rights\n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 21.0,
              ),
            ),

            SelectableText(
              """Other than the content you own, under these terms, Vikn Codes and/or its licensors own all the intellectual property rights and materials contained on this application. """,
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),

            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "\nRestrictions\n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SelectableText(
              """You are specifically restricted from all of the following:\n \u2022Publishing any application material in any other media. \n \u2022Publicly performing and/or showing any application material.\n \u2022Using the application in any way that impacts user access to this application\n \u2022Engaging in any data mining, data harvesting, data extracting or any other similar activity in relation to this application.\n \u2022 Using this application to engage in any advertising or marketing.\nCertain areas of this application are restricted from being access by you and Vikn Codes may further restrict access by you to any areas of this application, at any time, in absolute discretion. Any user ID and password you may have for this application are confidential and you maintain confidentiality as well.\n""",
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "Your Content \n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SelectableText(
              """Your content must be own and must not invading any third party’s rights. Vikn Codes reserves the right to remove any of your content from this application at any time without notice. """,
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "\nIndemnification\n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SelectableText(
              """You hereby indemnify to the fullest extent Vikn Codes from and against any and or/ all liabilities, costs, demands, causes of action, damages and expenses arising in any way related to your breach of any of the provisions of these terms.""",
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),

            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "\nVariation Of Terms \n ",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SelectableText(
              """Vikn Codes is permitted to revise these terms at any time as it sees fit,and by using this application you are expected to review these terms on a regular basis.""",
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),

            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "\nEntire Agreement                \n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),

            ///Restricting the collection of your personal data page 2
            SelectableText(
              """These terms constitute the entire agreement between Vikn Codes and you in relation to your use of this application, and supersede all prior agreements and understandings.""",
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
            Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "\nGoverning Law and Jurisdiction    \n",
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                  )
                ],
              ),
              //  textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            SelectableText(
              """These terms will be governed by and interpreted in accordance with the laws of the state of country, and you submit to the non- exclusive jurisdiction of the state and federal courts located in country for the resolution of any disputes.\n """,
              textAlign: TextAlign.justify,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
            ),
          ]),
        )
      ],
    );
  }

  Widget versionDetailScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[

        Container(
            height: MediaQuery.of(context).size.height / 1.40, //height of button
            width: MediaQuery.of(context).size.width / 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height / 3, //height of button
                  width: MediaQuery.of(context).size.width / 2,

                  child: SvgPicture.asset(
                    'assets/svg/Logo.svg',
                    height: 200,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 32, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'INDIA:',
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                      Text('+91 905775 00400',style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),),
                    ],
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 32, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'KSA:',
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                      Text('+966 533133 4959', style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 32, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Email:',
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                      Text('info@vikncodes.com', style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height / 30, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Text(
                    'www.viknbooks.com',
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 32, //height of button
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Current App Version:',
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                      Text(appVersion, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),)
                    ],
                  ),
                ),
                // c
              ],
            ))
      ],
    );
  }

  Widget languagesScreen() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 16, //height of button
          width: MediaQuery.of(context).size.width / 1,
          //  color: Colors.red[100],
          child: const Text('Language',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 20,
              )),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.40, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          // color: Colors.red[100],
          child: ListView(children: <Widget>[
            Card(
              color: Colors.grey[100],
              child: ListTile(
                title: const Text('English'),
                trailing: GestureDetector(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: c1, border: Border.all(color: Colors.grey)),
                  ),
                  onTap: () {
                    setState(() {
                      c1 = Colors.green;
                      c2 = Colors.white;
                      c3 = Colors.white;
                    });
                  },
                ),
              ),
            ),
            Card(
              color: Colors.grey[100],
              child: ListTile(
                  title: const Text('Arabic'),
                  trailing: GestureDetector(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: c2, border: Border.all(color: Colors.grey)),
                    ),
                    onTap: () {
                      setState(() {
                        c1 = Colors.white;
                        c2 = Colors.green;
                        c3 = Colors.white;
                      });
                    },
                  )),
            ),
          ]),
        )
      ],
    );
  }

  ///kitchen list
  Future<Null> getKitchenListApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';

        final String url = '$baseUrl/posholds/list/pos-kitchen/';
        Map data = {"CompanyID": companyID, "BranchID": branchID};

        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        if (status == 6000) {
          setState(() {
            kitchenList.clear();
            stop();
            for (Map user in responseJson) {
              kitchenList.add(KitchenListModel.fromJson(user));
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
        setState(() {
          stop();
        });
      }
    }
  }

  var ipAddress = "";

  ///create kitchen
  Future<Null> createKitchenApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        stop();

    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var categoryID = 1;
        var accessToken = prefs.getString('access') ?? '';

        final String url = "$baseUrl/posholds/pos-kitchen/";
        print(url);

        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "CategoryID": categoryID,
          "IsActive": true,
          "KitchenName": kitchenNameController.text,
          "IPAddress": ipAddress,
          "Notes": descriptionController.text,
          "Type": "create",
          "unqid": "",
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


        if (status == 6000) {
          setState(() {
            _selectedIndex = 1000;
            ipAddress = "";
            kitchen = 1;
            kitchenNameController.clear();
            descriptionController.clear();

            kitchenEdit = false;
            kotShow = false;
            kitchenNameController.clear();
            descriptionController.clear();
            stop();

            getKitchenListApi();
          });
        } else if (status == 6001) {
          stop();
          var message = n["message"]??'';
          dialogBox(context, message);
        } else {
          stop();
          var message = n["message"]??'';
          dialogBox(context, message);

        }
      } catch (e) {

          dialogBox(context, "Some thing went wrong");
          stop();

      }
    }
  }

  ///single view kitchen
  Future<Null> getKitchenSingleView(String id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';

        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;
        var branchID = prefs.getInt('branchID') ?? 1;
        final url = '$baseUrl/posholds/view/pos-kitchen/$id/';
        print(accessToken);
        print(url);
        Map data = {"CompanyID": companyID, "BranchID": branchID};

        print(data);
        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.statusCode);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        if (status == 6000) {
          setState(() {
            stop();
            SettingsData.kitchenUid = responseJson['id'];
            kitchenNameController.text = responseJson['KitchenName'];
            descriptionController.text = responseJson['Notes'];
            ipAddress = responseJson['IPAddress'];

            for (var i = 0; i < printDetailList.length; i++) {
              print("foor loop");
              print(printDetailList[i].iPAddress);
              print(i);
              if (printDetailList[i].iPAddress == ipAddress) {
                _selectedIndex = i;
                kotShow = true;
                break;
              }
            }

            // printDetailList.forEach((userDetai,index) {
            //   if (userDetail.iPAddress.toLowerCase().contains(ipAddress.toLowerCase())) print(userDetail.iPAddress);
            // });
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  ///edit kitchen
  Future<Null> editKitchenDetail() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var categoryID = 1;
        var accessToken = prefs.getString('access') ?? '';

        final String url = "$baseUrl/posholds/pos-kitchen/";
        print(url);

        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "CategoryID": categoryID,
          "IsActive": true,
          "KitchenName": kitchenNameController.text,
          "IPAddress": ipAddress,
          "Notes": descriptionController.text,
          "Type": "update",
          "unqid": SettingsData.kitchenUid,
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

        if (status == 6000) {
          setState(() {
            _selectedIndex = 1000;
            ipAddress = "";
            var msg = n["message"];
            dialogBox(context, msg);
            stop();
            kitchen = 1;
            getKitchenListApi();
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  void deleteAlert(id, content, type, typ) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding:   const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AlertDialog(
              title:   Padding(
                padding: const EdgeInsets.all(0.5),
                child: Text(
                  'msg4'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Text(content),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          if (type == 1)
                            {
                              deleteKitchen(id, context),
                            }
                          else if (type == 2)
                            {
                              deletePrinter(id, context),
                            }
                          else
                            {
                              deleteWaiterApi(id, typ),
                            }
                        },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                        },
                    child:  Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.black),
                    )),
              ],
            ),
          );
        });
  }

  ///delete kitchen
  deleteKitchen(id, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
        var kitchenID = id;

         var branchID = prefs.getInt('branchID') ?? 1;
        var categoryID = 1;
        String baseUrl = BaseUrl.baseUrl;
        final String url = "$baseUrl/posholds/pos-kitchen/";
        print(url);

        /// data

        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "CategoryID": categoryID,
          "IsActive": true,
          "KitchenName": kitchenNameController.text,
          "IPAddress": "",
          "Notes": descriptionController.text,
          "Type": "delete",
          "unqid": kitchenID,
        };
        print(data);

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        print(response.body);
        print(status);
        if (status == 6000) {
          setState(() {
            kitchenList.clear();
            stop();
            getKitchenListApi();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  deletePrinter(id, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';

        String baseUrl = BaseUrl.baseUrl;
        final String url = "$baseUrl/posholds/delete/printer/$id/";
        print(url);
        print(accessToken);

        var response = await http.post(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
        );
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        print(response.body);
        print(status);
        if (status == 6000) {
          listAllPrinter();
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Something went wrong");
          stop();
        });
      }
    }
  }

  /// print list api
  Future<Null> listAllPrinter() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';

        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/printer-list/';

        print(url);

        Map data = {"BranchID": branchID, "CreatedUserID": userID, "CompanyID": companyID, "Type": "WF"};
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
        print(response.body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        if (status == 6000) {
          setState(() {
            printDetailList.clear();
            for (Map user in responseJson) {
              printDetailList.add(PrinterListModel.fromJson(user));
            }

            stop();
          });
        } else if (status == 6001) {
          setState(() {
            printDetailList.clear();
          });

          var msg = n["message"];
          dialogBox(context, msg);

          stop();
        } else {}
      } catch (e) {

          dialogBox(context, "Some thing went wrong");
          stop();

      }
    }
  }

  ///create printer
  Future<Null> createPrinterApi(type,) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        stop();

    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var ipAddress = "";
        if(type =="Wifi"){
           ipAddress = ipAddressController1.text + '.' + ipAddressController2.text + '.' + ipAddressController3.text + '.' + ipAddressController4.text;

        }
        else{
          ipAddress = bluetoothAddressController.text;
        }
        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/printer-create/';
        //   const String url =   "http://103.177.224.30:8080/api/v9/posholds/printer-create/";
        print(url);

        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "IPAddress": ipAddress,
          "PrinterName": printerNameController.text,
          "Type": type
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
          setState(() {
            var msg = n["message"];
            dialogBox(context, msg);

            listAllPrinter();
            printDetailList.clear();
            ipAddressController1.clear();
            ipAddressController2.clear();
            ipAddressController3.clear();
            ipAddressController4.clear();
            printerNameController.clear();
            printerSection = 1;

            stop();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);

          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///to create new role for user
  Future<Null> createNewRoleApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/create-pos-role/';
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,
          "RoleName": roleNameController.text,
          "show_car": carSwitch,
          "show_dining": diningSwitch,
          "show_kitchen": kitchenSwitch,
          "show_online": onlineSwitch,
          "show_take_away": takeSwitch
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {
          setState(() {
            roleNameController.clear();
            stop();
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///generate pin for user
  Future<Null> generatePinNumber() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;

        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/generate-pos-pin/';

        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
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
        print(response.statusCode);
        print(response.body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var statusCode = n["StatusCode"];

        if (statusCode == 6000) {
          setState(() {
            pinGenerateController.text = n["PinNo"].toString();
            stop();
          });
        } else if (statusCode == 6001) {
          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///create new user
  Future<Null> createNewUser() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var user_id = SettingsData.employeeID;
        var roleId = SettingsData.role_id;
        var pinNum = pinGenerateController.text;

        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/create-pos-user/';

        // String url="http://103.177.224.30:8080/api/v9/posholds/create-pos-user/";
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,
          "PinNo": pinNum,
          "Role": roleId,
          "User": user_id
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {
          setState(() {
            userNameController.clear();
            userRoleController.clear();
            pinGenerateController.clear();
            user = 1;
            stop();
            getAllUsersList();
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///list user
  Future<Null> getAllUsersList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
         var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/list/pos-users/';

        var accessToken = prefs.getString('access') ?? '';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
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

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);
        print(status);
        if (status == 6000) {
          setState(() {
            usersList.clear();
            stop();
            for (Map user in responseJson) {
              usersList.add(UserListModel.fromJson(user));
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
        setState(() {
          stop();
        });
      }
    }
  }

  ///alert confirmation for delete
  void _showAlertDialog(id, content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AlertDialog(
              title:   Padding(
                padding: const EdgeInsets.all(0.5),
                child: Text(
                  'msg4'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Text(content),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                          deleteUser(id, context),
                        },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () => {
                          Navigator.of(context).pop(),
                        },
                    child:  Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.black),
                    )),
              ],
            ),
          );
        });
  }

  ///delete user
  deleteUser(id, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
        var userId = id;
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/delete/pos-user/$userId/';
        print(url);

        /// data
        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
        };
        print(data);

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        print(response.body);
        print(status);
        if (status == 6000) {
          setState(() {
            usersList.clear();
            stop();
            getAllUsersList();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///edit user
  Future<Null> editUserDetail(posUserId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
         var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';
        var userUId = SettingsData.employeeID;
        var roleId = SettingsData.role_id;
        var pinNo = pinGenerateController.text;
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/edit/pos-user/$posUserId/';

        print(url);

        Map data = {"CompanyID": companyID, "User": userUId, "Role": roleId, "PinNo": pinNo, "BranchID": branchID};
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
          setState(() {
            var msg = n["message"];
            dialogBox(context, msg);
            stop();
            user = 1;
            getAllUsersList();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);

          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  var posUserId;

  ///user single view
  Future<Null> getUserSingleView(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';

        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/single/pos-user/$id/';
        print(url);
        Map data = {
          "CompanyID": companyID,
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
        print(response.statusCode);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        if (status == 6000) {
          setState(() {
            stop();
            posUserId = id;
            userNameController.text = responseJson['UserName'];
            userRoleController.text = responseJson['RoleName'];
            pinGenerateController.text = responseJson['PinNo'];
            SettingsData.employeeID = responseJson['User'];
            SettingsData.role_id = responseJson['Role'];
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  Future<Null> _selectDate(BuildContext context, count) async {
    // DatePicker.showDatePicker(context,
    //     // theme: const DatePickerTheme(
    //     //   containerHeight: 200.0,
    //     // ),
    //     showTitleActions: true,
    //     minTime: DateTime(2000, 01, 01),
    //     maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
    //   print('confirm $date');
    //   _date = '${date.year} - ${date.month} - ${date.day}';
    //
    //   setState(() {
    //     final DateFormat formatter = DateFormat('dd-MM-yyyy');
    //     final String formatted = formatter.format(date);
    //
    //     final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    //     print(formatted);
    //     _date = '$formatted';
    //     // reloadDate();
    //     if (count == 1) {
    //       fromDate = formatter1.format(date);
    //       kotFromDate = _date;
    //     } else if (count == 2) {
    //       toDate = formatter1.format(date);
    //       kotTODate = _date;
    //     }
    //   });
    // }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}

///confirm action beforelog out
enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'msg6'.tr,
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: const TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => LoginPageNew()),
                (_) => false,
              );
            },
          ),
          TextButton(
            child: const Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}

enum Image { gallery, camera }

Future<Image?> _asyncSimpleDialog(BuildContext context) async {
  return await showDialog<Image>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose a Photo '),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Image.gallery);
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, Image.camera);
              },
              child: const Text('Camera'),
            ),
          ],
        );
      });
}

///kitchen
List<KitchenListModel> kitchenList = [];

class KitchenListModel {
  String kitchenUid, kitchenName, ip, companyID, notes;
  int kitchenID, branchID;

  KitchenListModel(
      {required this.kitchenUid,
      required this.kitchenID,
      required this.branchID,
      required this.kitchenName,
      required this.ip,
      required this.companyID,
      required this.notes});

  factory KitchenListModel.fromJson(Map<dynamic, dynamic> json) {
    return KitchenListModel(
        kitchenUid: json['id'],
        kitchenID: json['KitchenID'],
        branchID: json['BranchID'],
        kitchenName: json['KitchenName'],
        ip: json['IPAddress'],
        companyID: json['CompanyID'],
        notes: json['Notes']);
  }
}

///organisation data
// class OrganisationCountry {
//   static String country_id = "";
//   static String state_id = "";
// }

///organization list
List<CompanyListDataModel> companyList = [];

class CompanyListDataModel {
  final bool isPosUser;
  final String id, companyName, companyType, expiryDate, permission, edition;

  CompanyListDataModel(
      {required this.id,
      required this.companyType,
      required this.companyName,
      required this.isPosUser,
      required this.edition,
      required this.expiryDate,
      required this.permission});

  factory CompanyListDataModel.fromJson(Map<dynamic, dynamic> json) {
    return CompanyListDataModel(
      id: json['id'],
      permission: json['Permission'],
      companyType: json['company_type'],
      edition: json['Edition'],
      expiryDate: json['ExpiryDate'],
      companyName: json['CompanyName'],
      isPosUser: json['IsPosUser'],
    );
  }
}

///users
List<UserListModel> usersList = [];

class UserListModel {
  String uuid, userName, role, roleName, pinNo, user;

  UserListModel({required this.uuid, required this.roleName, required this.pinNo, required this.user, required this.role, required this.userName});

  factory UserListModel.fromJson(Map<dynamic, dynamic> json) {
    return UserListModel(
      uuid: json['id'],
      user: json['User'],
      pinNo: json['PinNo'],
      roleName: json['RoleName'],
      role: json['Role'],
      userName: json['UserName'],
    );
  }
}

///printer
List<PrinterListModel> printDetailList = [];

class PrinterListModel {
  String id, printerName, iPAddress, type;
  int printerID;

  PrinterListModel({required this.id, required this.printerID, required this.printerName, required this.iPAddress, required this.type});

  factory PrinterListModel.fromJson(Map<dynamic, dynamic> json) {
    return PrinterListModel(
      id: json['id'],
      printerID: json['PrinterID'],
      printerName: json['PrinterName'],
      iPAddress: json['IPAddress'],
      type: json['Type'],
    );
  }
}



///users
class SettingsData {
  static String role_id = "";
  static String employeeID = "";
  static String userUid = "";
  static String pinNo = "";
  static String kitchenUid = "";
  static String defaultSalesInvoiceIP = "";
  static String defaultSalesOrderIP = "";
  static String defaultPrinterType = "";
}
