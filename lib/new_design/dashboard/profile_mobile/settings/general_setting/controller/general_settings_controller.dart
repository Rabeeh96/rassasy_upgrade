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
  ValueNotifier<bool> directOrderOption = ValueNotifier<bool>(false);
  ValueNotifier<bool> synMethod = ValueNotifier<bool>(false);
  ValueNotifier<bool> isQuantityIncrement = ValueNotifier<bool>(false);
  ValueNotifier<bool> isShowInvoice = ValueNotifier<bool>(false);
  ValueNotifier<bool> tableClearAfterPayment = ValueNotifier<bool>(false);


  TextEditingController tokenController = TextEditingController();
  TextEditingController compensationController = TextEditingController();
  FocusNode initialTokenNode=FocusNode();
  String compensationHour = '1';
  List<String> dropdownValues = ['1','2','3','4','5','6','7'];

  ValueNotifier<String> compensationHourNotifier = ValueNotifier<String>('1');

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isArabic.value = prefs.getBool("isArabic") ?? false;
    isAutoFocus.value = prefs.getBool("autoFocusField") ?? false;
    isDrawerOpenNotifier.value = prefs.getBool("OpenDrawer") ?? false;
    compensationHour = prefs.getString('CompensationHour') ?? "1";
    isQuantityIncrement.value = prefs.getBool("qtyIncrement") ?? true;
    isShowInvoice.value = prefs.getBool("AutoClear") ?? false;
    tableClearAfterPayment.value = prefs.getBool("tableClearAfterPayment") ?? false;
    directOrderOption.value =prefs.getBool("directOrderOption") ?? false;
    synMethod.value =prefs.getBool("synMethod") ?? false;







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

        tableClearAfterPayment.value = responseJson["IsClearTableAfterPayment"];
        prefs.setBool("tableClearAfterPayment", tableClearAfterPayment.value);







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