import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/tax_list_model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/flavour_model_class.dart';

class TaxController extends GetxController {
  var isLoading = false.obs;
  var isCreateLoading = false.obs;
  var isDeleteLoading = false.obs;
  var isEdit = false.obs;
  var taxUid = "0".obs;
  var flavourID = 0.obs;
  var taxLists = <TaxListModelClass>[].obs;
  var searchTaxList = <TaxListModelClass>[].obs;
  TextEditingController searchController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController salesPercentageController = TextEditingController();
  TextEditingController purchasePercentageController = TextEditingController();

  Future<void> fetchTax() async {
    try {
      isLoading(true);

      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/taxCategories/taxCategories/';

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": userID,
        "PriceRounding": BaseUrl.priceRounding

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

      if (response.statusCode == 200) {
        var n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        if (status == 6000) {
          taxLists.clear();
          for (Map<String, dynamic> user in responseJson) {
            taxLists.add(TaxListModelClass.fromJson(user));
          }
          searchTaxList.addAll(taxLists);
        } else if (status == 6001) {
          dialogBox(Get.context!, n["message"]);
        } else if (status == 6002) {
          var message = n["error"] ?? n["message"];
          dialogBox(Get.context!, message);
        } else {
          // Handle other status codes
        }
      } else {
        // Handle HTTP error
      }
    } catch (e) {
      dialogBox(Get.context!, e.toString());
    } finally {
      isLoading(false);
    }
  }



  onSearchTextChanged(String text) async {
    searchTaxList.clear();
    if (text.isEmpty) {

      return;
    }
    taxLists.forEach((userDetail) {
      if (userDetail.taxName.toLowerCase().contains(text.toLowerCase())) searchTaxList.add(userDetail);
    });


  }

  Future<void> createTax() async {
      try {
        isCreateLoading(true); // Assume start and stop are methods for showing and hiding loaders

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;

        var taxType = 6;
        var checkVat = prefs.getBool('checkVat') ?? false;
        var checkGst = prefs.getBool('check_GST') ?? false;

        if (checkVat == true) {
          taxType = 1;
        } else if (checkGst == true) {
          taxType = 2;
        } else {
          taxType = 6;
        }

        final String url = '$baseUrl/taxCategories/create-taxCategory/';
        Map<String, dynamic> data = {
          'CompanyID': companyID,
          'BranchID': branchID,
          'CreatedUserID': userID,
          'TaxName': taxNameController.text,
          'SalesTax': salesPercentageController.text,
          'PurchaseTax': purchasePercentageController.text,
          'TaxType': taxType,
          'Inclusive': false,
        };

        var body = json.encode(data);
        var response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
          body: body,
        );

        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        var status = jsonResponse['StatusCode'];

        if (status == 6000) {
          isCreateLoading(false);
          // Success case

          Get.snackbar('Success', 'Tax category created successfully');
        await fetchTax();
          clearFields();
          Get.back();
        } else if (status == 6001) {
          isCreateLoading(false);
          var msg = jsonResponse['message'] ;
          Get.snackbar("Error", msg);
        } else if (status == 6002) {
          isCreateLoading(false);
          var msg =jsonResponse['error']?? jsonResponse['message'] ;
          Get.snackbar("Error", msg);

        }else {
          // Handle other cases if needed
        }

      } catch (e) {
        // Handle generic error case
        Get.snackbar('Error', e.toString());
      } finally {
        isCreateLoading(false);// Method to hide loaders
      }

  }
  clearFields(){
    taxNameController.clear();
    salesPercentageController.clear();
    purchasePercentageController.clear();
  }

  Future<void> deleteTax(String id) async {
    try {
      isDeleteLoading(true); // Implement your start() function


      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      String url = '$baseUrl/taxCategories/delete/taxCategory/$id/';

      Map<String, dynamic> data = {
        "CreatedUserID": userID, "CompanyID": companyID, "BranchID": branchID

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

      Map<String, dynamic> n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];

      if (status == 6000) {
        isDeleteLoading(false); // Implement your stop() function
        taxLists.clear();
        dialogBox(Get.context!, "Delete Successfully");
        Get.back(); // Implement your dialogBox function
        fetchTax(); // Implement your getAllFlavours() function
      } else if (status == 6001) {
        isDeleteLoading(false); // Implement your stop() function
        var msg = n["message"] ;
        Get.snackbar("Error", msg); // Implement your dialogBox function
      }  else if (status == 6002) {
        isDeleteLoading(false); // Implement your stop() function
        var msg = n["error"]??n["message"] ;
        Get.snackbar("Error", msg);
      }else {
        isDeleteLoading(false); // Implement your stop() function
      }
    } catch (e) {
      print(e.toString());
      isDeleteLoading(false);
      Get.snackbar("Error", e.toString());// Implement your stop() function
    } finally {
      isDeleteLoading(false); // Ensure loading state is always set to false
    }
  }
  Future<void> editTax(String id) async {
    try {
      isCreateLoading(true); // Assume start and stop are methods for showing and hiding loaders

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      String baseUrl = BaseUrl.baseUrl;




      final String url = '$baseUrl/taxCategories/edit/taxCategory/$id/';
      Map<String, dynamic> data = {
        'CompanyID': companyID,
        'BranchID': branchID,
        'CreatedUserID': userID,
        'TaxName': taxNameController.text,
        'SalesTax': salesPercentageController.text,
        'PurchaseTax': purchasePercentageController.text,
        'TaxType': 2,
        'Inclusive': false,
      };

      var body = json.encode(data);
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse['StatusCode'];

      if (status == 6000) {
        isCreateLoading(false);
        // Success case
        taxLists.clear();
       Get.snackbar('Success', 'Tax category created successfully');
        await fetchTax();
        isEdit.value=false;
        clearFields();
        Get.back();
      } else if (status == 6001) {
        isCreateLoading(false);
        var msg = jsonResponse['message'] ;
        Get.snackbar("Error", msg);
      } else if (status == 6002) {
        isCreateLoading(false);
        var msg =jsonResponse['error']?? jsonResponse['message'] ;
        Get.snackbar("Error", msg);

      }else {
        // Handle other cases if needed
      }

    } catch (e) {
      // Handle generic error case
      Get.snackbar('Error', e.toString());
    } finally {
      isCreateLoading(false);// Method to hide loaders
    }

  }

}
