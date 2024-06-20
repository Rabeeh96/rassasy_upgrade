import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/flavour_model_class.dart';

class FlavourController extends GetxController {
  var isLoading = false.obs;
  var isEdit = false.obs;
  var flavourUID = "0".obs;
  var flavourID = 0.obs;
  var flavourList = <FlavourListModelClass>[].obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController flavourName = TextEditingController();

  Future<void> fetchFlavours() async {
    try {
      isLoading(true);

      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/flavours/flavours/';

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID
      };

      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        var n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        if (status == 6000) {
          flavourList.clear();
          for (Map<String, dynamic> user in responseJson) {
            flavourList.add(FlavourListModelClass.fromJson(user));
          }
        } else if (status == 6001) {
          dialogBox(Get.context!, n["message"]);
        } else if (status == 6002) {
          var message = n["error"] ?? n["message"];
          dialogBox(Get.context!, message);
        } else {
          // Handle other status codes
        }
      } else {
        // Handle HTTP error
      }
    } catch (e) {
      dialogBox(Get.context!, e.toString());
    } finally {
      isLoading(false);
    }
  }

  var isFlavourLoading = false.obs; // Observable boolean to track loading state
  var isFlavourDeleteLoading = false.obs; // Observable boolean to track loading state

  Future<void> createFlavour(String type, String id) async {
    try {
      isFlavourLoading(true);
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      String url = "";

      if (type == "Create") {
        url = '$baseUrl/flavours/create-flavour/';
      } else {
        url = '$baseUrl/flavours/edit/flavour/$id/';
      }

      Map<String, dynamic> data = {
        "FlavourID": id,
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "FlavourName": flavourName.text,
        "IsActive": true,
        "BgColor": "",
      };

      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      Map<String, dynamic> n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var message = n["message"];

      if (status == 6000) {
        isFlavourLoading(false); // Implement your stop() function
        flavourName.clear();
        flavourList.clear();
        Get.back();
        fetchFlavours(); // Implement your getAllFlavours() function
      } else if (status == 6001) {
        isFlavourLoading(false);
        dialogBox(Get.context!, message);
      } else if (status == 6002) {
        isFlavourLoading(false);
        var message = n["error"] ?? n["message"];
        dialogBox(Get.context!, message);
      }
    } catch (e) {
      print(e.toString());
      isFlavourLoading(false);
    } finally {
      isLoading(false); // Ensure loading state is always set to false
    }
  }

  Future<void> deleteFlavourApi(String id) async {
    try {
      isFlavourDeleteLoading(true); // Implement your start() function


      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      String url = '$baseUrl/flavours/delete/flavour/$id/';

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "FlavourName": flavourName.text,
        "IsActive": true,
        "BgColor": "",
      };

      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      Map<String, dynamic> n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];

      if (status == 6000) {
        isFlavourDeleteLoading(false); // Implement your stop() function
        flavourList.clear();
        dialogBox(Get.context!, "Delete Successfully");
        Get.back(); // Implement your dialogBox function
        fetchFlavours(); // Implement your getAllFlavours() function
      } else if (status == 6001) {
        isFlavourDeleteLoading(false); // Implement your stop() function
        var msg = n["message"] ;
        dialogBox(Get.context!, msg); // Implement your dialogBox function
      }  else if (status == 6002) {
        isFlavourDeleteLoading(false); // Implement your stop() function
        var msg = n["error"]??n["message"] ;
        dialogBox(Get.context!, msg); // Implement your dialogBox function
      }else {
        isFlavourDeleteLoading(false); // Implement your stop() function
      }
    } catch (e) {
      print(e.toString());
      isFlavourDeleteLoading(false);
      dialogBox(Get.context!, e.toString());// Implement your stop() function
    } finally {
      isLoading(false); // Ensure loading state is always set to false
    }
  }
}
