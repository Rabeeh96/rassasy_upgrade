import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/main.dart';
import 'model.dart';

class RAddTaxControllerPage extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController generalTaxController = TextEditingController();
  TextEditingController breakingPointController = TextEditingController();
  TextEditingController taxBeforeController = TextEditingController();
  TextEditingController taxAfterController = TextEditingController();
  RxInt TaxTypeID = 0.obs;
  var Tax = "".obs;
  var isLoading = true.obs;
  var isDataLoading = false.obs;
  var isError = false.obs;
  var taxCategoryList = <Data>[].obs;
  RxBool IsAmountTaxBefore = false.obs;
  RxBool IsAmountTaxAfter = false.obs;
  RxList itemList = [].obs;
late var namecontroller= nameController.text.obs;

  var selectPercentageorAmount = 0.obs;
  var selectPercentageorAmount1 = 0.obs;
  void loadData() async {
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
  }
  RxString  uID="".obs;
  @override
  void onInit() {
    super.onInit();
    update();
  }
  ///Function to add to the list
  void addItemInTaxCategoryList(newTaxCategoryItem) {
    itemList.insert(0, newTaxCategoryItem);
  }
  void clear () {
    nameController.clear();
    generalTaxController.clear();
    breakingPointController.clear();
    taxAfterController.clear();
    taxBeforeController.clear();

}
  Future<void> taxItemCreateFunction(String type,String? id) async {


    print(breakingPointController.text);
    if (generalTaxController.text == "") {
      generalTaxController.text = "0";
    }
    if (breakingPointController.text == "") {
      breakingPointController.text = "0";
    }
    if (taxBeforeController.text == "" || taxAfterController.text == "") {
      taxBeforeController.text = "0";
      taxAfterController.text = "0";
    }
    print(breakingPointController.text);


    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrlV11;
    var priceRounding = BaseUrl.priceRounding;

    final String url = '$baseUrl/taxCategories/taxCategories/';
    Map data = {
      "pk":id,
      "Inclusive": false,
      "Tax": generalTaxController.text ?? "0",
      "TaxName": nameController.text,
      "TaxType": TaxTypeID.value,
      "CreatedUserID": userID,
      "BranchID": 1,
      "CompanyID": companyID,
      "BPValue": breakingPointController.text ?? "0",
      // "BPValue":"0.0",
      "TaxBefore": taxBeforeController.text ?? "0",
      "TaxAfter": taxAfterController.text ?? "0",
      "IsAmountTaxBefore": IsAmountTaxBefore.value,
      "IsAmountTaxAfter": IsAmountTaxAfter.value
    };
    log('helooo $data');
    var body = json.encode(data);

    var apiUrl = baseUrl;
    if(type =="CREATE"){
      apiUrl = "$baseUrl/taxCategories/create-taxCategory/";
      print(1);
    }else if(type == "EDIT"){
      apiUrl = "$baseUrl/taxCategories/edit-taxCategory/";
      print(2);

    }    log(apiUrl);
    try {
      // isDataLoading.value = true;


      var response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      // print('API Response: ${response.body}');
      log('Marwan${response.body}');
      log('${response.statusCode}');
      if (response.statusCode == 200) {

        final responseData = json.decode(response.body);
        print(responseData['StatusCode']);
        if (responseData['StatusCode'] == 6000) {

          clear();
          getTaxCategoryFullList();
          // Get.snackbar(
          //   'Successfully ',
          //   'Created : ${responseData['message']}',
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          // );

          update();
        }else if (responseData['StatusCode'] == 6001) {
          Get.snackbar(
            'Error',
            'Error Message: ${responseData['message']}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        final responseData = json.decode(response.body);
        Get.snackbar(
          'Error',
          'Creation failed: ${responseData['message']}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      // print('Stack Trace: $stackTrace');
    }
  }

  Future<dynamic>getViewData({context, required  String? id}) async {
    try {
      print('getViewData function started');

      HttpOverrides.global = MyHttpOverrides();
      String baseUrl = BaseUrl.baseUrlV11;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
       var branchID = prefs.getInt('branchID') ?? 1;
      var apiUrl = "$baseUrl/taxCategories/view-taxCategory/";
      var accessToken = prefs.getString('access') ?? '';
      var body = json.encode({
        "CreatedUserID": userID,
        "BranchID": branchID,
        "CompanyID": companyID,
        "PriceRounding": 2,
        "pk": "$id"
      });
      var response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      print('API call made');

      print('API Response: ${response.statusCode}');
      print('API Response: ${response.body}');

      print("3");
      if(response.statusCode == 200) {
        print(response.statusCode);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["status"];
        var responseJson = n["data"];
        return [status, responseJson];
      }else{
        print('API error: ${response.statusCode}');
        return [false, "Error: ${response.statusCode}"];
      }
    } catch (e) {
      print('Error occurred: $e');
      return [false, "Error"];
    }
  }

  Future<void> deleteTaxCategory(String? id) async {


    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrl;
    var priceRounding = BaseUrl.priceRounding;

    final apiUrl = '$baseUrl/taxCategories/delete/taxCategory/$id/';

    print(apiUrl);
    // Replace with your API URL and tax category ID



    var requestBody =  {"CreatedUserID":userID,"BranchID":1,"CompanyID":companyID};
     var response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode(requestBody),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    if (response.statusCode == 200) {
      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      if(status==6000){
        await getTaxCategoryFullList();
        clear();
        update();
      }
      else{
        var responseJson = n["message"];
        Get.snackbar(
          'Error',
          'Creation failed:$responseJson',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

    } else {
      // Handle the error case
      throw Exception('Failed to delete tax category. Status code: ${response.statusCode}');
    }
  }

  Future<void> getTaxCategoryFullList() async {
    try {
      taxCategoryList.clear();
      isDataLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrlV11;
       var apiUrl = '$baseUrl/taxCategories/list-taxCategory/';
      var requestBody = {
        "CreatedUserID": userID,
        "BranchID": branchID,
        "CompanyID": companyID,
        "page_no": 1,
        "items_per_page": 20,
        "PriceRounding": 4
      };
      var response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(requestBody),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
      );
      print('API Response: ${response.body}');
      update();
      if (response.statusCode == 200){
        isDataLoading.value = false;
        print("Succefully fetched Tax Category list");
        var taxCategoryListViewModel = TaxCategoryListViewModelPage.fromJson(json.decode(response.body));
        if (taxCategoryListViewModel.data!.isEmpty){
          print("No More Data Available");
        }else{
          taxCategoryList.addAll(taxCategoryListViewModel.data!);

        }
      }else {
        print('Error:${response.statusCode}');
        print('Response Body: ${response.body}');
        isError(true);
      }
    } catch (e) {
      print('Error: $e');
      // print('Stack Trace: $stackTrace');
    }
  }
}
