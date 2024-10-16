import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchOrderController extends GetxController {
  TextEditingController searchController = TextEditingController();

  String dropdownvalue = 'Code';
  var items = [
    'Code',
    'Name',
    'Description',
  ];

  var products = [].obs;
  var isLoading = false.obs;
  void searchItems({required String productName,required bool isCode,required bool isDescription}) async {
    isLoading.value=true;
    String baseUrl = BaseUrl.baseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyID = prefs.getString('companyID') ;
    var userID = prefs.getInt('user_id') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    print("2");
    var accessToken = prefs.getString('access') ?? '';
    var url = '$baseUrl/posholds/products-search-pos/';
    print("3");

    var payload = {
      "IsCode": isCode,
      "IsDescription": isDescription,
      "BranchID": branchID,
      "CompanyID":companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "product_name": productName,
      "length":  productName.length,
      "type": ""
    };

    try {
      print("payload   $payload");
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to headers
        },
      );

      if (response.statusCode == 200) {
        isLoading.value=false;
        print("3d");
        var data = jsonDecode(response.body);
        products.assignAll(data['data']);
        print("7");
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      isLoading.value=false;
      print('Exception occurred: $e');
    }
  }



}
