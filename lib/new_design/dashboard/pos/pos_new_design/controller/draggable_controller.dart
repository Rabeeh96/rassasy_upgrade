import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/groupModel.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/productModel.dart';
import '../../../../../global/global.dart';

class DragAndDropController extends GetxController {
  var tableList = <Map<String, dynamic>>[].obs;
  var isLoading=true.obs;
  var selectedValue = 5.obs;
  var draggableList= <Map<String, dynamic>>[].obs;
  var groupIsLoading = false.obs;
  var productIsLoading = false.obs;
  RxString user_name = "".obs;
  var groupList = <GroupListModelClass>[].obs;
  var productList = <ProductListModel>[].obs;
  ValueNotifier<bool> isVegNotifier = ValueNotifier<bool>(false); // Initialize with initial value
  var selectedIndex = RxInt(0);
  RxInt selectedGroup = 0.obs;
  var dropdownvalue = 'Name'.obs;
  Future<void> fetchTables() async {
    print("fetch list");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedValue.value=prefs.getInt('count_of_row') ?? 5;
    var branchID = prefs.getInt('branchID') ?? 0;
    var companyID = prefs.getString('companyID') ?? '';
    var accessToken = prefs.getString('access') ?? '';
    String baseUrl1 = BaseUrl.baseUrl;
    final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
    print(baseUrl);

    final payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "POSTableList": [],  // Assuming this is needed for the request
      "Type": "List"
    };
    print(payload);
    log("$payload");

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token here if needed
        },
        body: jsonEncode(payload),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure StatusCode is what you expect
        if (data['StatusCode'] == 6000) {
          final List<dynamic> tableListData = data['data'];
          tableList.value = List<Map<String, dynamic>>.from(tableListData);
          print("StatusCode");
          print("${response.statusCode}");


        } else {
          print('Unexpected StatusCode: ${data['StatusCode']}');
        }
      } else {
        print('Failed to fetch tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> updateTables({required String type,required List reOrderList}) async {
    print("fetch list");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedValue.value=prefs.getInt('count_of_row') ?? 5;
    var branchID = prefs.getInt('branchID') ?? 0;
    var companyID = prefs.getString('companyID') ?? '';
    var accessToken = prefs.getString('access') ?? '';
    String baseUrl1 = BaseUrl.baseUrl;
    final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
    print(baseUrl);

    final payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "POSTableList": reOrderList,  // Assuming this is needed for the request
      "Type": type
    };
    print(payload);
    log("$payload");

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token here if needed
        },
        body: jsonEncode(payload),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure StatusCode is what you expect
        if (data['StatusCode'] == 6000) {

          Get.snackbar("", "Updated Successfully");
          fetchTables();

        } else {
          print('Unexpected StatusCode: ${data['StatusCode']}');
        }
      } else {
        print('Failed to fetch tables: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> getCategoryListDetail(sectionType) async {
    try {
      print("2");
      groupIsLoading.value = true;
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      user_name.value = prefs.getString('user_name')!;

      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/posholds/pos/product-group/list/';
      print(url);
      Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "is_used_group": true};
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
        print("1........................................................................11");
        groupList.clear();
        for (Map user in responseJson) {
          groupList.add(GroupListModelClass.fromJson(user));
        }
        print("..........2");


        groupIsLoading.value = false;
        if (groupList.isNotEmpty) {
          getProductListDetail(groupList[0].groupID);
        }
      } else if (status == 6001) {
        // Show error message
        var msg = n["error"] ?? "";
        groupIsLoading.value = false;
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        groupIsLoading.value = false;
        // Handle DB Error
      }
    } catch (e) {
      groupIsLoading.value = false;
      // Handle error
    }
  }
  RxBool showWegOrNoVeg = true.obs;
  RxString currency = "".obs;

  Future<void> getProductListDetail(groupID) async {
    try {
      productIsLoading.value = true;
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      user_name.value = prefs.getString('user_name')!;

      var accessToken = prefs.getString('access') ?? '';
      var priceRounding = BaseUrl.priceRounding;
      final String url = '$baseUrl/posholds/pos-product-list/';
      print(url);
      Map data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "GroupID": groupID,
        "type": isVegNotifier.value ? 'veg' : "",
        "PriceRounding": priceRounding
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
        print("........................");
        productList.clear();
        for (Map user in responseJson) {
          productList.add(ProductListModel.fromJson(user));
        }
        print(".....ddddddddd...................");

        productIsLoading.value = false;
      } else if (status == 6001) {
        productList.clear();
        // Show error message
        var msg = n["error"] ?? "";
        productIsLoading.value = false;
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        productIsLoading.value = false;
        // Handle DB Error
      }
    } catch (e) {
      productIsLoading.value = false;
      // Handle error
    }
  }

  void selectIndex(int index) {
    selectedIndex.value = index;
  }


  void removeTable(String id) {
    tableList.removeWhere((table) => table['id'] == id);
  }
  RxList orderItemList = [].obs;
  checking(int proID) {
    for (var i = 0; i < orderItemList.length; i++) {
      if (orderItemList[i]["ProductID"] == proID) {
        return [true, i];
      }
    }
    return [false, 0];
  }
}



