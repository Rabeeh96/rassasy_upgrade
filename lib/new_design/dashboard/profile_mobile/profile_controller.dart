import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../global/global.dart';


class ProfileController extends GetxController {
var isLoad=false.obs;
final  companyName = ''.obs;
final companyEdition = ''.obs;
final userName = ''.obs;
final mail = ''.obs;
final photo = ''.obs;
final companyLogo =''.obs;
  Future<void> getProfileData() async {
    try {
      isLoad.value=true;

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      String baseUrl = BaseUrl.baseUrl;
baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
      final url = '$baseUrl/users/user-view/$userID/';
      print(url);

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      print(response.body);

      Map n = json.decode(response.body);
      var status = n["StatusCode"];

      var responseJson = n["data"];

      var customerData = n["customer_data"];

      if (status == 6000) {
        stop();

        userName.value = responseJson['username'] ?? '';
        mail.value = responseJson['email'] ?? '';
        companyName.value = prefs.getString('companyName') ?? '';
        photo.value = customerData['photo'] ?? '';
      } else if (status == 6001) {
        print("Error occurred");
        stop();
      }
      //DB Error
      else {
        print("DB Error");
      }
    } catch (e) {
      print("Exception occurred: $e");
      stop();
    }
  }
}
