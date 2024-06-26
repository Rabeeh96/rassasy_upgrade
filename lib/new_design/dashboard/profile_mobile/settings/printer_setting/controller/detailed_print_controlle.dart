import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailedPrintSettingController extends GetxController {
  TextEditingController salesInvoiceController = TextEditingController();
  TextEditingController salesOrderController = TextEditingController();
  TextEditingController selectCapabilitiesController = TextEditingController();
  TextEditingController selectCodepageController = TextEditingController();
  TextEditingController termsAndConditionController = TextEditingController();
  var isLoading = false.obs;
  ValueNotifier<bool> isKOTPrint = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPrintAfterPayment = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPrintAfterOrder = ValueNotifier<bool>(false);
  List<PrinterListModel> printDetailList = [];
  void switchStatus(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }
  Future<Null> listAllPrinter() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/printer-list/';

      print(url);

      Map data = {
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
        "Type": "WF"
      };

      // Encode Map to JSON
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
        // Clear the previous list
        printDetailList.clear();
        for (Map user in responseJson) {
          // Add new items to the list
          printDetailList.add(PrinterListModel.fromJson(user));
        }

        isLoading.value = false;
      } else if (status == 6001) {
        isLoading.value = false;
        printDetailList.clear();
        var msg = n["message"];

        stop();
      } else {
        // Handle other statuses if needed
      }
    } catch (e) {
      stop();
    }
  }

  List<String> printerModels = [
    "default",
    "XP-N160I",
    "RP80USE",
    "AF-240",
    "CT-S651",
    "NT-5890K",
    "OCD-100",
    "simple",
    "OCD-300",
    "P822D",
    "POS-5890",
    "RP326",
    "SP2000",
    "ZKP8001",
    "TP806L",
    "Sunmi-V2",
    "TEP-200M",
    "TM-P80",
    "TM-P80-42col",
    "TM-T88II",
    "TM-T88III",
    "TM-T88IV",
    "TM-T88IV-SA",
    "TM-T88V",
    "TM-U220",
    "TSP600",
    "TUP500",
    "ZJ-5870",
  ];

  List<String> codepage=['CP1250','PC858','KU42','PC850','OME851','CP3012','OME852','CP720','RK1048', 'WPC1253', 'CP737', 'ISO_8859-2', 'CP1258', 'CP850', 'CP775', 'ISO_8859-4', 'TCVN-3-1', 'PC2001', 'CP865', 'OME866', 'OME864', 'CP861', 'OME1001', 'CP1001', 'CP857', 'OME1255', 'PC737', 'CP3847', 'WPC1250', 'PC720', 'OME1252', 'ISO_8859-15', 'CP862', 'CP3841', 'CP437', 'OME855', 'ISO8859-7', 'TCVN-3-2', 'CP1257', 'PC3840', 'CP3041', 'CP1256', 'CP3848', 'PC3002', 'PC860', 'ISO_8859-7', 'OEM775', 'CP853', 'CP3002', 'OME772', 'OME774', 'PC3845', 'CP774', 'CP1252', 'CP1255', 'OME858', 'ISO_8859-1', 'PC3844', 'OME850', 'PC437', 'CP856', 'OME874', 'OME865', 'CP3844', 'PC3011', 'CP852', 'OEM720', 'WPC1256', 'CP863', 'CP2001', 'PC3012', 'OME737', 'CP858', 'PC3848', 'CP855', 'CP869', 'ISO_8859-3', 'CP860', 'CP3021', 'OME860', 'PC3841', 'OME869', 'PC863', 'ISO_8859-9', 'CP928', 'OME437', 'ISO_8859-5', 'CP1254', 'CP3846', 'CP1253', 'CP874', 'OME747', 'WPC1258', 'WPC1251', 'OME863', 'CP1098', 'WPC1252', 'PC866', 'PC865', 'CP3001', 'PC3843', 'PC3041', 'PC3846', 'PC1001', 'PC3021', 'CP3840', 'CP864', 'PC864', 'CP866', 'PC857', 'Unknown', 'CP772', 'ISO-8859-6', 'OXHOO-EUROPEAN', 'CP747', 'CP3845', 'PC3847', 'CP3011', 'PC3001', 'OME862', 'OME928', 'CP851', 'OME857', 'ISO_8859-8', 'CP1125', 'CP3843', 'PC852', 'CP1251', 'CP932', 'ISO_8859-6', 'Katakana', 'OME861', 'WPC1254', 'WPC1257'];

  ValueNotifier<bool> isEnableWifiPrinter = ValueNotifier<bool>(false);
  TextEditingController code_page_controller = TextEditingController();
  ValueNotifier<bool> isHighlightedToken = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPaymentDetail = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCompanyDetail = ValueNotifier<bool>(false);
  ValueNotifier<bool> timeInInvoice = ValueNotifier<bool>(false);
  ValueNotifier<bool> dateTimeInKOT = ValueNotifier<bool>(false);
  ValueNotifier<bool> userNameInKOT = ValueNotifier<bool>(false);
  ValueNotifier<bool> printForCancelledOrders = ValueNotifier<bool>(false);
  ValueNotifier<bool> extraDetailsInKOT = ValueNotifier<bool>(false);
  ValueNotifier<bool> flavourDetailsInOrderPrint = ValueNotifier<bool>(false);

  loadData() async {
    print("--------------------------------------4");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("--------------------------------------4");
    isKOTPrint.value = prefs.getBool("KOT") ?? false;
    isPrintAfterPayment.value = prefs.getBool("printAfterPayment") ?? false;
    isPrintAfterOrder.value = prefs.getBool("print_after_order") ?? false;
    isHighlightedToken.value = prefs.getBool("hilightTokenNumber") ?? false;
    isPaymentDetail.value = prefs.getBool("paymentDetailsInPrint") ?? false;
    isCompanyDetail.value = prefs.getBool("headerAlignment") ?? false;
    termsAndConditionController.text = prefs.getString('printTermsAndCondition') ?? "";
    salesInvoiceController.text = prefs.getString('defaultIP') ?? "";
    salesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
    selectCapabilitiesController.text = prefs.getString('default_capabilities') ?? "default";
    selectCodepageController.text = prefs.getString('default_code_page') ?? "CP864";

    print("--------------------------------------4");



    timeInInvoice.value = prefs.getBool("time_in_invoice") ?? false;
    dateTimeInKOT.value = prefs.getBool("show_date_time_kot") ?? false;
    userNameInKOT.value = prefs.getBool("show_username_kot") ?? false;
    printForCancelledOrders.value = prefs.getBool("print_for_cancel_order") ?? false;
    extraDetailsInKOT.value = prefs.getBool("extraDetailsInKOT") ?? false;

    flavourDetailsInOrderPrint.value = prefs.getBool("flavour_in_order_print") ?? false;

    update();
  }
///print template
  RxInt selectedIndex = 0.obs;
  List<String> imagePaths = [
    'assets/png/gst.png',
    'assets/png/vat.png',
  ].obs;
  void setSelectedIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  setTemplate(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("template", "template$id");
  }
}

class PrinterListModel {
  String id, printerName, iPAddress, type;
  int printerID;

  PrinterListModel(
      {required this.id,
      required this.printerID,
      required this.printerName,
      required this.iPAddress,
      required this.type});

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
