// lib/controllers/platform_controller.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/model/platform.dart';
import '../../../../../global/customclass.dart';
import '../../../../../global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformController extends GetxController {
  var platforms = <PlatformModel>[].obs;
  var isLoading = true.obs;
  TextEditingController platformNameController =TextEditingController();
  RxString platformID = "".obs;
  var isEdit=false.obs;
  @override
  void onInit() {
    platforms.clear();
    fetchPlatforms();
    super.onInit();
  }

  void fetchPlatforms() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
         isLoading(true);



      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      final String apiUrl = '${BaseUrl.baseUrlV11}/posholds/pos-online-platforms/?CompanyID=$companyID&BranchID=$branchID&page_no=1&items_per_page=10';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken', // Pass the token in the Authorization header
          'Content-Type': 'application/json', // Set the content type if needed
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> platformsJson = data['data'];
        platforms.assignAll(platformsJson.map((json) => PlatformModel.fromJson(json)).toList());
      } else {
        throw Exception('Failed to load platforms');
      }
    } finally {
      isLoading(false);
    }
  }

   createPlatform(String name) async {
    print("sgdhssfh");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrl = '${BaseUrl.baseUrlV11}/posholds/pos-online-platforms/';

    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    var userID = prefs.getInt('user_id') ?? 0;
    print("s$apiUrl h");
    var payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "Name": name,
      "CreatedUserID":userID
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
    print("s$payload h");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var responseData = jsonDecode(response.body);
      if (responseData['StatusCode'] == 6000) {
        Get.back();
       // popAlert(head: "Success", message: "Successfully Create platform", position: SnackPosition.TOP);
        fetchPlatforms();
        platformNameController.clear();

        print("----------------------------");
        update();
      } else {
        throw Exception(responseData['message']);
      }
       // Check for success status code
    } else {
      throw Exception('Failed to create platform');
    }
  }
    editPlatform(String name,String id) async {
    print("sgdhssfh");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String apiUrl = '${BaseUrl.baseUrlV11}/posholds/pos-online-platforms/';

    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    var userID = prefs.getInt('user_id') ?? 0;
    print(apiUrl);
    var payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "Name": name,
      "CreatedUserID":userID,
      "uniq_id":id,

    };
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
    print("s$payload ");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      var responseData = jsonDecode(response.body);
      if (responseData['StatusCode'] == 6000) {
        Get.back();
      //  popAlert(head: "Success", message: "Successfully Edit platform", position: SnackPosition.TOP);
        platforms.clear();
        fetchPlatforms();
        platformNameController.clear();

        print("----------------------------");
        update();
      } else {
        throw Exception(responseData['message']);
      }
      // Check for success status code
    } else {
      throw Exception('Failed to create platform');
    }
  }
   deletePlatform(String uniqId) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     final String apiUrl = '${BaseUrl.baseUrlV11}/posholds/pos-online-platforms/';

     var accessToken = prefs.getString('access') ?? '';
     var payload = {

       "uniq_id":uniqId,

     };
    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode(payload),
    );
print(apiUrl);
     print("------------------s----------");

    if (response.statusCode == 200) {
      print("-------------s-----s----------");

      json.decode(response.body);
      print("-------s------s-----s----------");

      var responseData = jsonDecode(response.body);
      if (responseData['StatusCode'] == 6000) {
        print("------------------ssssssssssssssss----------");

        Get.back();
        popAlert(head: "Success", message: "Successfully Deleted", position: SnackPosition.TOP);
        fetchPlatforms();


        print("----------------------------");
        update();
      } else {
        throw Exception(responseData['message']);
      }


      // Check for success status code
    } else {
      throw Exception('Failed to delete platform');
    }
  }
}
