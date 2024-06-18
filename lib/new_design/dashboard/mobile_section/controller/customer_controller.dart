import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/customer_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/view/customer/customer_list_mobile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomerController extends GetxController{

  var isLoading =false.obs;

  TextEditingController searchController =TextEditingController();
  RxList<CustomerModelClass> customerModelClass =
      <CustomerModelClass>[].obs;
  Future<void> getCustomerListDetails() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0';
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      var userID = prefs.getInt('user_id') ?? 0;
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/customer-list/';
      print(url);



      Map data = {"CompanyID": companyID, "BranchID": branchID,
        "CreatedUserID": userID,};
      var body = json.encode(data);
      print(data);
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
        print(status);
        isLoading.value = false;
        customerModelClass.clear();
        for (Map user in responseJson) {
          customerModelClass.add(CustomerModelClass.fromJson(user));
        }

      } else if (status == 6001) {
        print("ghfjsdgfdhs");
        isLoading.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      } else if (status == 6002) {
        print("ghfjsdgfdhs");
        isLoading.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> searchData(String searchVal) async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('user_id') ?? 0;
    final accessToken = prefs.getString('access') ?? '';
    final companyID = prefs.getString('companyID') ??"";
    final branchID = prefs.getInt('branchID') ?? 1;

    try {
      final data = {
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "PriceRounding": 2,
        "product_name": searchVal,
        "length": searchVal.length,
        "PartyType": "customer"
      };
      final baseUrl = BaseUrl.baseUrl;
      final url = "$baseUrl/parties/search/party-list/";
      print(data);
      print(url);
      final body = json.encode(data);
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      print("${response.statusCode}");
      print("${response.body}");
      final n = json.decode(utf8.decode(response.bodyBytes));
      final status = n["StatusCode"];
      final responseJson = n["data"];
      final message = n["message"];
      print(responseJson);
      if (status == 6000) {
        customerModelClass.clear();


        isLoading.value = false;

        // Add data to customersLists using GetX reactive state management
        for (final user in responseJson) {
          customerModelClass.add(CustomerModelClass.fromJson(user));
        }
      } else if (status == 6001) {
        // Update state using GetX reactive state management
        isLoading.value = false;

        dialogBox(Get.context!, message);
      }else if (status == 6002) {
       var message = n["error"]??n["message"];
       isLoading.value = false;

        dialogBox(Get.context!, message);
      } else {
        dialogBox(Get.context!, "Some Network Error please try again Later");
      }
    } catch (e) {
      // Update state using GetX reactive state management
      isLoading.value = false;

      print(e);
    }
  }

}