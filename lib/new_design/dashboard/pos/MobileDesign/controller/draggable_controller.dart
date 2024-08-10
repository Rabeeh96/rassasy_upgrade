import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/global.dart';

class TableListController extends GetxController {
  var tableList = <Map<String, dynamic>>[].obs;
  var isLoading=true.obs;
  var selectedValue = 5.obs;
  var draggableList= <Map<String, dynamic>>[].obs;
  Future<void> fetchTables() async {
    print("fetch list");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedValue.value=prefs.getInt('count_of_row') ?? 5;
    var branchID = prefs.getInt('branchID') ?? 0;
    var companyID = prefs.getString('companyID') ?? '';
    var accessToken = prefs.getString('access') ?? '';
    String baseUrl1 = BaseUrl.baseUrl;
    final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
    print(baseUrl);

    final payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "POSTableList": [],  // Assuming this is needed for the request
      "Type": "List"
    };
    print(payload);
    log("$payload");

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token here if needed
        },
        body: jsonEncode(payload),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure StatusCode is what you expect
        if (data['StatusCode'] == 6000) {
          final List<dynamic> tableListData = data['data'];
          tableList.value = List<Map<String, dynamic>>.from(tableListData);
          print("StatusCode");
          print("${response.statusCode}");


        } else {
          print('Unexpected StatusCode: ${data['StatusCode']}');
        }
      } else {
        print('Failed to fetch tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> updateTables({required String type,required List reOrderList}) async {
    print("fetch list");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedValue.value=prefs.getInt('count_of_row') ?? 5;
    var branchID = prefs.getInt('branchID') ?? 0;
    var companyID = prefs.getString('companyID') ?? '';
    var accessToken = prefs.getString('access') ?? '';
    String baseUrl1 = BaseUrl.baseUrl;
    final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
    print(baseUrl);

    final payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "POSTableList": reOrderList,  // Assuming this is needed for the request
      "Type": type
    };
    print(payload);
    log("$payload");

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token here if needed
        },
        body: jsonEncode(payload),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure StatusCode is what you expect
        if (data['StatusCode'] == 6000) {

          Get.snackbar("", "Updated Successfully");
          fetchTables();

        } else {
          print('Unexpected StatusCode: ${data['StatusCode']}');
        }
      } else {
        print('Failed to fetch tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }




  void removeTable(String id) {
    tableList.removeWhere((table) => table['id'] == id);
  }
}



