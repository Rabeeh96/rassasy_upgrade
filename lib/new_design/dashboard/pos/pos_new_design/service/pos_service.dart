import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TableService {
  Future<Map<String, dynamic>> fetchAllData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrl;
    final response = await http.post(
      Uri.parse('$baseUrl/posholds/pos-table-list/'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },


      body: jsonEncode({
        "CompanyID": companyID,
        "type": "user",
        "BranchID":branchID,
        "paid": "true",
      }),

    );


    pr(response);
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      return parsed;
    } else {
      throw Exception('Failed to load table data');
    }
  }
}
