import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/flavour.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class OrderController extends GetxController{
  ValueNotifier<bool> isVegNotifier = ValueNotifier<bool>(false); // Initialize with initial value
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);
  String currency = "SR";
  final ValueNotifier<bool> isAddItem = ValueNotifier<bool>(false);
  ValueNotifier<bool> isOrderCreate = ValueNotifier<bool>(false); // Initialize with initial value
var isLoading=false.obs;
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllFlavours();
  }

  var flavourList = <FlavourListModelClass>[].obs;

  Future<void> getAllFlavours() async {
    try {


      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      var accessToken = prefs.getString('access') ?? '';
      final String url = '$baseUrl/flavours/flavours/';
      print(url);
      Map data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID
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

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      print(responseJson);
      print(status);
      if (status == 6000) {
        // Clear existing list
        flavourList.clear();

        // Add fetched items to the list
        for (Map user in responseJson) {
          flavourList.add(FlavourListModelClass.fromJson(user));
        }
      } else if (status == 6001) {
        // Show error message
        var msg = n["error"] ?? "";
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        // Handle DB Error
      }
    } catch (e) {
      // Handle error
    }
  }

}