import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/service/pos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/reservation_model_class.dart';

class ReservationController extends GetxController {
  ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");
  String baseUrl = BaseUrl.baseUrl;
  final String apiUrl ='https://www.api.viknbooks.com/api/v10/posholds/pos-table-reserve-list/';
  var reservations = <Data>[].obs;
  var isLoading = true.obs;


  Future<void> fetchReservations(String fromdate,String todate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoading.value=true;

      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      var payload = {
        "CompanyID":companyID,
        "CreatedUserID": userID,
        "BranchID":branchID,
        "page_number": 1,
        "page_size": 40,
        "FromDate": fromdate,
        "ToDate": todate
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );


      if (response.statusCode == 200) {
        isLoading.value=false;
        var responseData = jsonDecode(response.body);
        if (responseData['StatusCode'] == 6000) {
          var data = responseData['data'] as List;
          reservations.assignAll(data.map((json) => Data.fromJson(json)));
          update();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      isLoading.value=false;
      throw Exception('Error: $e');
    }
  }
  var tableData =  [].obs;


  Future<void> fetchTable() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoading.value=true;


      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      var payload = {
        "CompanyID": companyID,
        "type": "user",
        "BranchID":branchID,
        "paid": "true",
      };
      String baseUrl = BaseUrl.baseUrlV11;
      final response = await http.post(
        Uri.parse('$baseUrl/posholds/pos-table-list/'),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );


      print(payload);

      if (response.statusCode == 200) {
        isLoading.value=false;
        var responseData = jsonDecode(response.body);
        if (responseData['StatusCode'] == 6000) {
          tableData.value= responseData['data'];

          print("-----------------------------${tableData.length}");
          update();
        } else {
          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      isLoading.value=false;
      throw Exception('Error: $e');
    }
  }


  Future<void> createReservation(tableID,customerName,date,fromTime,toTime) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoading.value=true;


      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var userID = prefs.getInt('user_id') ?? 0;
      var payload = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID,
        "Table": tableID,
        "CustomerName": customerName,
        "Date": date,
        "FromTime": fromTime,
        "ToTime": toTime,
      };

      final response = await http.post(
        Uri.parse('${BaseUrl.baseUrl}/posholds/pos-table-reserve/'),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );


      print('${BaseUrl.baseUrl}/posholds/pos-table-reserve/');
      print(payload);
      print(response.body);

      if (response.statusCode == 200) {
        print(response.statusCode);

        isLoading.value=false;
        var responseData = jsonDecode(response.body);
        if (responseData['StatusCode'] == 6000) {
          print("1111");

          Get.back();
          print("222");

          popAlert(head: "Success", message: "Successfully reserved Table", position: SnackPosition.TOP);
          fetchReservations(apiDateFormat.format(fromDateNotifier.value),apiDateFormat.format(toDateNotifier.value));
          print("33333");

          print("----------------------------");
          update();
        } else {
          print("444");

          throw Exception(responseData['message']);
        }
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      print("5555");

      isLoading.value=false;
      throw Exception('Error: $e');
    }
  }

}
