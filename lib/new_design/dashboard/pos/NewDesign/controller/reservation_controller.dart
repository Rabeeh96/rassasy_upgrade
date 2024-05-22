import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rassasy_new/global/global.dart';
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
}
