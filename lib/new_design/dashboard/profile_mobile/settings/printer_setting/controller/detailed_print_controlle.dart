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

  List<PrinterListModel> printDetailList = [];

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
      print(data);
      print(accessToken);

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
  List<String> codepage = [
    "ISO_8859-6",
    "CP864",
    "ISO-8859-6",
    "PC850",
    "PC860",
    "PC858",
    "PC863",
    "CP1251",
    "PC863",
    "",

  ];
  ValueNotifier<bool> isEnableWifiPrinter = ValueNotifier<bool>(false);
  TextEditingController code_page_controller = TextEditingController();
  ValueNotifier<bool> isHighlightedToken = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPaymentDetail = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCompanyDetail = ValueNotifier<bool>(false);
  String printType = "Wifi";
  bool  print_type_value = true;
  loadData() async {
    print("--------------------------------------4");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("--------------------------------------4");
    isHighlightedToken.value = prefs.getBool("hilightTokenNumber") ?? false;
    isPaymentDetail.value = prefs.getBool("paymentDetailsInPrint") ?? false;
    isCompanyDetail.value = prefs.getBool("headerAlignment") ?? false;
    termsAndConditionController.text = prefs.getString('printTermsAndCondition') ?? "";
    salesInvoiceController.text = prefs.getString('defaultIP') ?? "";
    salesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
    selectCapabilitiesController.text = prefs.getString('default_capabilities') ?? "default";
    selectCodepageController.text = prefs.getString('default_code_page') ?? "CP864";
    var template = prefs.getString("template") ?? "template3";
    var printType =  prefs.getString('PrintType') ?? "Wifi";
    print("--------------------------------------4");
    if(template =="template3"){
      setTemplate(3);
    }
    else{
      setTemplate(4);
    }
    if(printType =="Wifi"){
      isEnableWifiPrinter.value = true;
    }
    else{
      isEnableWifiPrinter.value = false;
    }

    print("printType  $printType");
    print("isEnableWifiPrinter  ${isEnableWifiPrinter.value}");
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
