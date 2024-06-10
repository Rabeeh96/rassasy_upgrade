import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GeneralController extends GetxController{
  var isLoading=false.obs;
  ValueNotifier<bool> isDrawerOpenNotifier = ValueNotifier<bool>(false);
  ValueNotifier<bool> isAutoFocus = ValueNotifier<bool>(false);
  ValueNotifier<bool> isArabic = ValueNotifier<bool>(false);
  ValueNotifier<bool> isKOTPrint = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPrintAfterPayment = ValueNotifier<bool>(false);
  ValueNotifier<bool> isPrintAfterOrder = ValueNotifier<bool>(false);
  ValueNotifier<bool> isQuantityIncrement = ValueNotifier<bool>(false);
  ValueNotifier<bool> isShowInvoice = ValueNotifier<bool>(false);
  ValueNotifier<bool> isClear = ValueNotifier<bool>(false);

  TextEditingController tokenController = TextEditingController();
  TextEditingController compensationController = TextEditingController();
  FocusNode initialTokenNode=FocusNode();
  String compensationHour = '1';
  List<String> dropdownValues = ['1','2','3','4','5','6','7'];

  ValueNotifier<String> compensationHourNotifier = ValueNotifier<String>('1');

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();



      ///

      // defaultIp = prefs.getString('defaultIP') ?? '';
    isKOTPrint.value = prefs.getBool("KOT") ?? false;
       isArabic.value = prefs.getBool("isArabic") ?? false;
    isAutoFocus.value = prefs.getBool("autoFocusField") ?? false;
    isDrawerOpenNotifier.value = prefs.getBool("OpenDrawer") ?? false;
      compensationHour = prefs.getString('CompensationHour') ?? "1";
    isQuantityIncrement.value = prefs.getBool("qtyIncrement") ?? true;
      // userType = prefs.getInt("user_type") ?? 1;
    isShowInvoice.value = prefs.getBool("AutoClear") ?? false;
    isClear.value = prefs.getBool("tableClearAfterPayment") ?? false;
    isPrintAfterPayment.value = prefs.getBool("printAfterPayment") ?? false;

    isPrintAfterOrder.value = prefs.getBool("print_after_order") ?? false;
      // printPreview = prefs.getBool('print_preview') ?? false;
      // // payment_method = prefs.getBool('payment_method') ?? false;
      // time_in_invoice = prefs.getBool('time_in_invoice') ?? false;
      // printType = prefs.getString('PrintType') ?? "Wifi";
      //


      // hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
      // paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
      // headerAlignment = prefs.getBool("headerAlignment") ?? false;
      // termsAndConditionController.text =prefs.getString('printTermsAndCondition') ?? "";

      // if(printType =="Wifi"){
      //   print_type_value = true;
      // }
      // else{
      //   print_type_value = false;
      // }
      // capabilitiesController.text = prefs.getString('default_capabilities') ?? "default";
      // defaultSalesInvoiceController.text = prefs.getString('defaultIP') ?? "";
      // defaultSalesOrderController.text = prefs.getString('defaultOrderIP') ?? "";
      //
      // ///newly added values here
      // kotDetail = prefs.getString("item_section_KOT") ?? "Product Name";
      // saleDetail = prefs.getString("item_section_sale_order") ?? "Product Name";
      // saleInvoiceDetail = prefs.getString("item_section_sale_invoice") ?? "Product Name";
      // isComplimentaryBill = prefs.getBool("complimentary_bill") ?? false;
      //
      // show_date_time_kot = prefs.getBool("show_date_time_kot")??false;
      // show_username_kot = prefs.getBool("show_username_kot")??false;
      // hideTaxDetails = prefs.getBool("hideTaxDetails")??false;
      //
      //
      // print("------show_date_time_kot---$show_date_time_kot--------show_username_kot-$show_username_kot-------------------------");


  }

  Future<void> updateList({required String apiKeyValue,var apiData,required String sharedPreferenceKey}) async {
    try {
      isLoading.value=true;
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
          //dialogBox("Updated successfully");
        }
        if (apiKeyValue == "InitialTokenNo") {
         // initialTokenNoController.text = apiVal;
        }
        isLoading.value=false;
        update(); // Update the UI
        if (apiKeyValue == "TokenResetTime" || apiKeyValue == "InitialTokenNo" || apiKeyValue == "CompensationHour") {
          // Do something if needed
        } else {
          switchStatus(sharedPreferenceKey, apiData);
        }
      } else if (status == 6001) {
        isLoading.value=false;


      } else {
        isLoading.value=false;
      }
    } catch (e) {
     // dialogBox("Something went wrong");
    isLoading.value=false;
    }
  }

  Future<void> fetchSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/pos-hold-settings/';

      Map data = {"CompanyID": companyID, "action": 0, "key": "", "value": "", "BranchID": branchID};

      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];
      if (status == 6000) {
        var responseJson = responseData["data"];

        isQuantityIncrement.value = responseJson["IsQuantityIncrement"];
        prefs.setBool("qtyIncrement", isQuantityIncrement.value);

        isShowInvoice.value = responseJson["IsShowInvoice"];
        prefs.setBool("AutoClear", isShowInvoice.value);

        isClear.value = responseJson["IsClearTableAfterPayment"];
        prefs.setBool("tableClearAfterPayment", isClear.value);

        isPrintAfterPayment.value = responseJson["IsPrintAfterPayment"];
        prefs.setBool("printAfterPayment", isPrintAfterPayment.value);




        tokenController.text = responseJson["InitialTokenNo"].toString();
        compensationHour = responseJson["CompensationHour"].toString();
      } else if (status == 6001) {
        print("Status 6001");
      } else {
        print("Other status");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  getItemsectionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("item_section_KOT");
  }

  void switchStatus(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

}