import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintSettingController extends GetxController {
  TextEditingController salesInvoiceController = TextEditingController();
  TextEditingController salesOrderController = TextEditingController();
  TextEditingController selectCapabilitiesController = TextEditingController();
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
  TextEditingController code_page_controller = TextEditingController();
  ValueNotifier<bool> isHighlightedToken = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPaymentDetail = ValueNotifier<bool>(false);
  ValueNotifier<bool> isCompanyDetail = ValueNotifier<bool>(false);

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isHighlightedToken.value = prefs.getBool("hilightTokenNumber") ?? false;
    isPaymentDetail.value = prefs.getBool("paymentDetailsInPrint") ?? false;
    isCompanyDetail.value = prefs.getBool("headerAlignment") ?? false;
    termsAndConditionController.text =
        prefs.getString('printTermsAndCondition') ?? "";
    salesInvoiceController.text = prefs.getString('defaultIP') ?? "";
    salesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
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
