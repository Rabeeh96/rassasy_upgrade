import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/category_model_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/kitchen_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/product_group_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductGroupController extends GetxController {
  var isLoadGroups = false.obs;
  var isKitchenLoad = false.obs;
  RxList<ProductGroupListModel> productGroupLists =
      <ProductGroupListModel>[].obs;
  FocusNode productNameFocusNode = FocusNode();
  FocusNode selectKitchenFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode kitchenFocusNode = FocusNode();
  FocusNode catFocusNode = FocusNode();
  FocusNode saveIconFocusNode = FocusNode();
  FocusNode submitFcNode = FocusNode();
  TextEditingController groupNameController = TextEditingController();
  TextEditingController productCategoryController = TextEditingController();
  TextEditingController kitchenController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String kitchenID = "";
  String groupID = "";
  int categoryID = 1;
  var createPermission = false.obs;

  ///list
  Future<void> getProductListDetails() async {
    try {
      isLoadGroups.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0';
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/pos/product-group/list/';
      print(url);

      createPermission.value = prefs.getBool("Groupsave") ?? true;
      kitchenID = "";

      Map data = {"CompanyID": companyID, "BranchID": branchID};
      var body = json.encode(data);
      print(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];

      if (status == 6000) {
        print(status);
        isLoadGroups.value = false;
        productGroupLists.clear();
        for (Map user in responseJson) {
          productGroupLists.add(ProductGroupListModel.fromJson(user));
        }
        print(productGroupLists);
      } else if (status == 6001) {
        print("ghfjsdgfdhs");
        isLoadGroups.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      } else if (status == 6002) {
        print("ghfjsdgfdhs");
        isLoadGroups.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      }
    } catch (e) {
      isLoadGroups.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
///search list
  ///
  Future<void> searchData(String string) async {
    try {
      isLoadGroups.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      Map<String, dynamic> data = {
        "BranchID": branchID,
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "PriceRounding": BaseUrl.priceRounding,
        "product_name": string,
        "length": string.length
      };
      String baseUrl = BaseUrl.baseUrl;
      var token = prefs.getString('access') ?? '';
      final String url = "$baseUrl/productGroups/search-productGroup-list/";
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: json.encode(data));
      Map<String, dynamic> n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      var message = n["message"] ?? "No data";
      if (status == 6000) {
        productGroupLists.assignAll((responseJson as List)
            .map((user) => ProductGroupListModel.fromJson(user))
            .toList());
      } else if(status == 6001) {
        Get.snackbar("Error", message);
      } else if(status == 6002) {
        var message = n["error"]??n["message"] ;
        Get.snackbar("Error", message);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoadGroups.value = false;
    }
  }
  ///dlt
  Future<void> deleteProduct(String id) async {
    try {
      isLoadGroups.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? '';
      var branchID = prefs.getInt('branchID') ?? 1;
      var userID = prefs.getInt("user_id");

      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/productGroups/delete/productGroup/$id/';

      Map data = {
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
      };

      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];

      if (status == 6000) {
        isLoadGroups.value = false;
        productGroupLists.clear();
        // clearData();
        // editProduct = false;
        getProductListDetails();
      } else if (status == 6001) {
        isLoadGroups.value = false;
        var message = n["error"] ?? n["message"];

        Get.snackbar('Error', message);
      } else if (status == 6002) {
        isLoadGroups.value = false;
        var message = n["error"] ?? n["message"];

        Get.snackbar('Error', message);
      }
    } catch (e) {
      isLoadGroups.value = false;

      ///Get.snackbar('Success', 'You Cant Delete this Product Group, this ProductGroupID is being used somewhere');

      // Handle any errors here
    }
  }

  ///kitchen list
  var kitchenList = <KitchenListModelClass>[].obs;

  Future<void> getKitchen() async {
    try {
      isKitchenLoad(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/list/pos-kitchen/';
      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID,
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

      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];

      if (status == 6000) {
        // Category details fetched successfully
        List<dynamic> responseJson = jsonResponse["data"];
        kitchenList.assignAll(responseJson
            .map((category) => KitchenListModelClass.fromJson(category)));
      } else if (status == 6001) {
        var message = jsonResponse["error"] ?? jsonResponse["message"];
        Get.snackbar('Error', message);
      } else if (status == 6002) {
        isKitchenLoad.value = false;
        var message = jsonResponse["error"] ?? jsonResponse["message"];

        Get.snackbar('Error', message);
      }
    } catch (e) {
      // Handle error
    } finally {
      isKitchenLoad(false);
    }
  }

  var isCategoryLoad = false.obs;

  ///cat list
  var categoryList = <ProductCategoryListModel>[].obs;

  Future<void> getCategoryList() async {
    try {
      isCategoryLoad(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/productCategories/productCategories/';
      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID,
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

      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];

      if (status == 6000) {
        isCategoryLoad(false);
        // Category details fetched successfully
        List<dynamic> responseJson = jsonResponse["data"];
        categoryList.assignAll(responseJson
            .map((category) => ProductCategoryListModel.fromJson(category)));
      } else if (status == 6001) {
        isCategoryLoad(false);
        var message = jsonResponse["error"] ?? "An error occurred";
        Get.snackbar('Error', message);
      } else if (status == 6002) {
        isCategoryLoad.value = false;
        var message = jsonResponse["error"] ?? jsonResponse["message"];

        Get.snackbar('Error', message);
      }
    } catch (e) {
      // Handle error
    } finally {
      isCategoryLoad(false);
    }
  }

  ///create
  Future<void> createProductGroup() async {
    try {
      print("22");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      print("4444444");
      String baseUrl = BaseUrl.baseUrl;
      final String url = "$baseUrl/productGroups/create-productGroup/";
      print(url);
      Map data = {
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
        "CategoryID": categoryID,
        "IsActive": true,
        "GroupName": groupNameController.text,
        "Notes": descriptionController.text,
        "kitchen": kitchenID,
      };
      print(data);
      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      print("22");
      Map n = json.decode(utf8.decode(response.bodyBytes));
      print(n);
      print("statuscode");
      var status = n["StatusCode"];
      print(status);
      if (status == 6000) {
        print("6000");
        kitchenID = "";
        clearData();
        Get.back();
        getProductListDetails();
        print("dddddddd");
      } else if (status == 6001) {
        print("445656");
        var message = n["error"] ?? n["message"];
        Get.dialog(message);
      } else if (status == 6002) {
        var message = n["error"] ?? n["message"];

        Get.snackbar('Error', message);
      }
    } catch (e) {
      print("7886");
      Get.snackbar('Error', '${e.toString()}');
    }
  }

  clearData() {
    productCategoryController.clear();
    groupNameController.clear();
    kitchenController.clear();
    descriptionController.clear();
  }

  ///singleview
  Future<void> getProductGroupSingleView(String productId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      String baseUrl = BaseUrl.baseUrl;

      final url = '$baseUrl/productGroups/view/productGroup/$productId/';
      Map data = {
        "CompanyID": companyID,
        "BranchID": 1,
        "CreatedUserID": userID
      };
      print(url);
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
      if (status == 6000) {
        groupNameController.text = responseJson['GroupName'];
        kitchenController.text = responseJson['KitchenName'];
        descriptionController.text = responseJson['Notes'];
        productCategoryController.text = responseJson['ProductCategoryName'];

        kitchenID = responseJson['KitchenID'];
        categoryID = responseJson['CategoryID'];
        groupID = responseJson['id'];
      } else if (status == 6001) {
        Get.dialog(n["error"] ?? n['message']);
      } else if (status == 6002) {
        Get.dialog(n["error"] ?? n['message']);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  ///edit
  Future<void> editProductGroup({required String groupID}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var userID = prefs.getInt("user_id");
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/productGroups/edit/productGroup/$groupID/';
      Map data = {
        "GroupName": groupNameController.text,
        "CategoryID": categoryID,
        "Notes": descriptionController.text,
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
        "kitchen": kitchenID
      };
      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];

      if (status == 6000) {
        kitchenID = "";
        clearData();
        Get.back();
        getProductListDetails();
      } else if (status == 6001) {
        Get.dialog(n["message"] ?? n['error']);
      } else if (status == 6002) {
        Get.dialog(n["error"] ?? n["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
