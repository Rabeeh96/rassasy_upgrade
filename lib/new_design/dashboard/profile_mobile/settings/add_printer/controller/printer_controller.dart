import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';

import '../model/printer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class AddPrinterController extends GetxController{
  TextEditingController printerName=TextEditingController();
  TextEditingController ip1=TextEditingController();
  TextEditingController ip2=TextEditingController();
  TextEditingController ip3=TextEditingController();
  TextEditingController ip4=TextEditingController();
  List<PrinterListModel> printDetailList = [];
  var isLoading=false.obs;
  Future<void> listAllPrinter() async {


    try {
      isLoading.value=true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;

      var accessToken = prefs.getString('access') ?? '';

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/printer-list/';

      print(url);

      Map data = {"BranchID": branchID, "CreatedUserID": userID, "CompanyID": companyID, "Type": "WF"};
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
        update();
        isLoading.value=false;
      } else if (status == 6001) {
        printDetailList.clear();
        var msg = n["message"];
        isLoading.value=false;

      } else {
        // Handle other statuses if needed
      }
    } catch (e) {

      isLoading.value=false;
    }
  }

  Future<void> createPrinterApi(type) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;

      var accessToken = prefs.getString('access') ?? '';
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/printer-create/';
      print(url);

      Map data = {
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
        "IPAddress": ip1.text,
        "PrinterName": printerName.text,
        "Type": type
      };
      print(data);

      //encode Map to JSON
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
      print(status);
      if (status == 6000) {
        var msg = n["message"];


        printDetailList.clear();
        ip1.clear();
        printerName.clear();
        update();
        listAllPrinter();
        Get.back();

        isLoading.value=false;
      } else if (status == 6001) {
        var msg = n["message"];

        stop();
      } else {
        // Handle other statuses if needed
      }
    } catch (e) {
      isLoading.value=false;
    }
  }

  void deletePrinter(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getString('access') ?? '';

      String baseUrl = BaseUrl.baseUrl;
      final String url = "$baseUrl/posholds/delete/printer/$id/";
      print(url);
      print(accessToken);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      var status = data["StatusCode"]; // 6000 status or message is here
      print(response.body);
      print(status);
      if (status == 6000) {
        listAllPrinter(); // Assuming listAllPrinter is another function to update the printer list
      } else if (status == 6001) {
       isLoading.value=false;
        var msg = data["message"];

      } else {
        // Handle other statuses if needed
      }
    } catch (e) {

      isLoading.value=false;
    }
  }

}