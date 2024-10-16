import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableService {
  Future<List<dynamic>> fetchAllData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrl;
    print("$baseUrl/posholds/tables/?CompanyID=$companyID&BranchID=$branchID");
    print("token $token");
    final response = await http.get(
      Uri.parse(
          '$baseUrl/posholds/tables/?CompanyID=$companyID&BranchID=$branchID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return parsed;
    } else {
      throw Exception('Failed to load table data');
    }
  }

  mergeData(List combineDatas) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrl;
    String url = '$baseUrl/posholds/tables/${combineDatas[0]}/merge/';
    print("url$url");

    combineDatas.removeAt(0);
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "CompanyID": companyID,
        "BranchID": branchID,
        "table_ids": combineDatas,
      }),
    );
    pr(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchTOC(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyID = prefs.getString('companyID') ?? '';
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrlV11;
    print("$baseUrl/posholds/pos-order-online-list/");
    final response = await http.post(
      Uri.parse('$baseUrl/posholds/pos-order-online-list/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "CompanyID": companyID,
        "BranchID": branchID,
      }),
    );
    // pr(response.body);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body) as Map<String, dynamic>;
      return parsed;
    } else {
      throw Exception('Failed to load table data: ${response.statusCode}');
    }
  }

  // Future<Map<String, dynamic>> fetchAllData(String token) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var userID = prefs.getInt('user_id') ?? 0;
  //   var accessToken = prefs.getString('access') ?? '';
  //   var companyID = prefs.getString('companyID') ?? 0;
  //   var branchID = prefs.getInt('branchID') ?? 1;
  //   String baseUrl = BaseUrl.baseUrl;
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/posholds/pos-table-list/'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       "CompanyID": companyID,
  //       "type": "user",
  //       "BranchID": branchID,
  //       "paid": "true",
  //     }),
  //   );

  //   pr(response);
  //   if (response.statusCode == 200) {
  //     final parsed = jsonDecode(response.body);
  //     return parsed;
  //   } else {
  //     throw Exception('Failed to load table data');
  //   }
  // }
}
