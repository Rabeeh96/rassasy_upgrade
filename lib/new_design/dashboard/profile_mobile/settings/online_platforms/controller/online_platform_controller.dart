import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/online_platfom_list_model.dart';

class OnlinePlatformController extends GetxController {
  var isLoading = true.obs;
   ValueNotifier<bool> isEdit = ValueNotifier<bool>(false);

  @override
  void onInit() {
    super.onInit();
    fetchData('');
  }
  Future<void> createPlatform(String name) async {
    const url =
        'https://www.api.viknbooks.com/api/v11/posholds/pos-online-platforms/';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      Map data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "Name": name,
        "CreatedUserID": userID
      };

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data), // Convert data to JSON string
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

       /// Get.snackbar('Success', responseData['message']);
        fetchData('');
      } else {
        Get.snackbar('Error', 'Failed to create platform');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  final String baseUrl = 'https://www.api.viknbooks.com/api/v11/';

  OnlinePlatfomListModel onlinePlatfomListModel = OnlinePlatfomListModel();
  RxList<Data> dataList = <Data>[].obs;



  void fetchData(String search) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      final response = await http.get(
        Uri.parse('https://www.api.viknbooks.com/api/v11/posholds/pos-online-platforms?CompanyID=$companyID&BranchID=$branchID&search=$search'),
        headers: {
          'Authorization': 'Bearer $accessToken',

        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<Data> data = (jsonData['data'] as List)
            .map((item) => Data.fromJson(item))
            .toList();
        dataList.assignAll(data);
      } else {
        // Handle error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle error
      print(e);
    }
  }


  Future<void> updateData({required String name,required String id}) async {
    try {
      const String apiUrl = 'https://www.api.viknbooks.com/api/v11/posholds/pos-online-platforms/';

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      final Map<String, dynamic> data = {
        "uniq_id": id,
        "CompanyID": companyID,
        "BranchID": branchID,
        "Name":name,
        "CreatedUserID": userID
      };

      final http.Response response = await http.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',

          'Authorization': accessToken,
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        int statusCode = responseData['StatusCode'];
        String message = responseData['message'];
        print('Status Code: $statusCode');
        print('Message: $message');
      } else {
        // Handle error
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
}}
