import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/organization/model/company_model.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../model/companyListModel.dart';

class CompanyController extends GetxController {
  var companyList = <Company>[].obs;
  var companyListData = <Data>[].obs;
  var isLoading = true.obs;
  String convertDate(String dateString) {
    if(dateString ==""){
      dateString = "2029-03-14";
    }
    DateTime parsedDate = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate;
  }
  Future<void> getCompanyListDetails() async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      final String baseUrl = BaseUrl.baseUrlV11;
      final String url = '$baseUrl/users/companies/';
      print('url $url');
      Map<String, dynamic> data = {"userId": userID, "is_rassasy": true};
      var body = json.encode(data);
      print('data $data');
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print('bod ${response.body}');
      print('bod ${response.statusCode}');
      if (response.statusCode == 200) {
        print('bod ${response.statusCode}');
        isLoading(false);
        print("aa");
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print("bb");
        List<dynamic> responseData = jsonResponse["data"];
        print("ccc");
        companyList.assignAll(responseData.map((data) => Company.fromJson(data)));
        print("ddd");
      } else {
        print('Error: ${response.statusCode}');
      }

      isLoading(false);
    } catch (e) {
      print('Exception occurred: $e');
      isLoading(false);
    }
  }
  Future<void> getCompanyListDataDetails() async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      final String baseUrl = BaseUrl.baseUrlV11;
      final String url = '$baseUrl/users/companies/';
      print('url $url');
      Map<String, dynamic> data = {"userId": userID, "is_rassasy": true};
      var body = json.encode(data);
      print('data $data');
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print('bod ${response.body}');
      print('bod ${response.statusCode}');
      if (response.statusCode == 200) {
        print('bod ${response.statusCode}');
        isLoading(false);
        print("aa");
        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        print("bb");
        List<dynamic> responseData = jsonResponse["data"];
        print("ccc");
        companyListData.assignAll(responseData.map((data) => Data.fromJson(data)));
        print("ddd");
      } else {
        print('Error: ${response.statusCode}');
      }

      isLoading(false);
    } catch (e) {
      print('Exception occurred: $e');
      isLoading(false);
    }
  }


}
