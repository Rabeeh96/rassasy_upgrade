import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:rassasy_new/new_design/dashboard/customer/detail/select_tax_new.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/TaxTreatmentModel.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/price_category_model.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/route_model.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/taxModelListClass.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/view/customer/add_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'package:rassasy_new/new_design/dashboard/mobile_section/model/customer_list_model.dart';

import 'package:intl/intl.dart';

class CustomerController extends GetxController{
  final imageSelect = false.obs;
  var isLoading =false.obs;
  var isCategoryLoad =false.obs;
  var isRouteLoad =false.obs;
  var isTaxLoad =false.obs;


  TextEditingController searchController =TextEditingController();
  TextEditingController customerNameController =TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController balanceController = TextEditingController()
    ..text = "0.00";
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController workPhoneController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController creditPeriodController = TextEditingController()
    ..text = "0";
  TextEditingController priceCategoryController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  //TextEditingController vatNumberController = TextEditingController();
  TextEditingController creditLimitController = TextEditingController()
    ..text = "0.00";
  TextEditingController routesController = TextEditingController();
  TextEditingController crNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController ibanIfscController = TextEditingController();
  TextEditingController treatmentController = TextEditingController();
  TextEditingController taxNoController = TextEditingController();

  FocusNode customerNameFcNode = FocusNode();
  FocusNode treatmentNode = FocusNode();
  FocusNode displayFcNode = FocusNode();
  FocusNode balanceFcNode = FocusNode();
  FocusNode dateFcNode = FocusNode();
  FocusNode emailFcNode = FocusNode();
  FocusNode workPhoneFcNode = FocusNode();
  FocusNode webUrlFcNode = FocusNode();
  FocusNode addressFcNode = FocusNode();
  FocusNode creditLimitFcNode = FocusNode();
  FocusNode priceCategoryFcNode = FocusNode();
  FocusNode panNoFcNode = FocusNode();
  FocusNode vatNoFcNode = FocusNode();
  FocusNode creditPeriodFcNode = FocusNode();
  FocusNode routesFcNode = FocusNode();
  FocusNode crNoFcNode = FocusNode();
  FocusNode bankNameNode = FocusNode();
  FocusNode acc_nameFcNode = FocusNode();
  FocusNode acc_NoFcNode = FocusNode();
  FocusNode iban_ifsc_FcNode = FocusNode();
  FocusNode saveNode = FocusNode();
  RxList<CustomerModelClass> customerModelClass =  <CustomerModelClass>[].obs;
  ValueNotifier<DateTime> purchaseDateValue = ValueNotifier(DateTime.now());
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");
  var priceCategoryID=1;
var routeID=1;
var taxID="1";
  File? imgFile;
  final imgPicker = ImagePicker();
  String dropdownvalue = 'DR';
  var items = [
    'DR',
    'CR',
  ];

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    imgFile = File(imgCamera!.path);
    print("imgFile from cam $imgFile");
    imageSelect.value = true;
    update();
    Get.back();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    imgFile = File(imgGallery!.path);
    print("imgFile from gall $imgFile");
    imageSelect.value = true;
    update();
    Get.back();
  }

  Widget displayImage() {
    return GestureDetector(
      onTap: () {
        showOptionsDialog(Get.context!);
      },
      child: Container(
        height: MediaQuery.of(Get.context!).size.height / 12,
        width: MediaQuery.of(Get.context!).size.width / 20,
        child: imgFile == null
            ? Text('msg5'.tr)
            : Image.file(
          imgFile!,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('cam'.tr),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text(
                      'gall'.tr,
                    ),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  loadImage(image) async {
    try {
      final file = await getFileFromNetworkImage(image);

        imageSelect.value = true;
        imgFile = file;
        print("Image file load image");
        print(imgFile);

    } catch (e) {}
  }
  Future<File> getFileFromNetworkImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(p.join(documentDirectory.path, '$fileName.png'));
    file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> getCustomerListDetails() async {
    try {
      isLoading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0';
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      var userID = prefs.getInt('user_id') ?? 0;
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/customer-list/';
      print(url);



      Map data = {"CompanyID": companyID, "BranchID": branchID,
        "CreatedUserID": userID,};
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
        isLoading.value = false;
        customerModelClass.clear();
        for (Map user in responseJson) {
          customerModelClass.add(CustomerModelClass.fromJson(user));
        }

      } else if (status == 6001) {
        print("ghfjsdgfdhs");
        isLoading.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      } else if (status == 6002) {
        print("ghfjsdgfdhs");
        isLoading.value = false;
        var msg = n["error"] ?? n["message"];
        Get.dialog(msg);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
  Future<void> searchData(String searchVal) async {
    final prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('user_id') ?? 0;
    final accessToken = prefs.getString('access') ?? '';
    final companyID = prefs.getString('companyID') ??"";
    final branchID = prefs.getInt('branchID') ?? 1;

    try {
      final data = {
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "PriceRounding": 2,
        "product_name": searchVal,
        "length": searchVal.length,
        "PartyType": "customer"
      };
      final baseUrl = BaseUrl.baseUrl;
      final url = "$baseUrl/parties/search/party-list/";
      print(data);
      print(url);
      final body = json.encode(data);
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      print("${response.statusCode}");
      print("${response.body}");
      final n = json.decode(utf8.decode(response.bodyBytes));
      final status = n["StatusCode"];
      final responseJson = n["data"];
      final message = n["message"];
      print(responseJson);
      if (status == 6000) {
        customerModelClass.clear();


        isLoading.value = false;

        // Add data to customersLists using GetX reactive state management
        for (final user in responseJson) {
          customerModelClass.add(CustomerModelClass.fromJson(user));
        }
      } else if (status == 6001) {
        // Update state using GetX reactive state management
        isLoading.value = false;

        dialogBox(Get.context!, message);
      }else if (status == 6002) {
       var message = n["error"]??n["message"];
       isLoading.value = false;

        dialogBox(Get.context!, message);
      } else {
        dialogBox(Get.context!, "Some Network Error please try again Later");
      }
    } catch (e) {
      // Update state using GetX reactive state management
      isLoading.value = false;

      print(e);
    }
  }

  var categoryList = <PriceCategoryModel>[].obs;


  ///price category
  Future<void> getCategoryList() async {
    try {
      isCategoryLoad(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/priceCategories/priceCategories/';
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
            .map((category) => PriceCategoryModel.fromJson(category)));
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
  var routeList = <RouteModelClass>[].obs;

  Future<void> getRouteList() async {
    try {
      isRouteLoad(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/routes/routes/';
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
        isRouteLoad(false);
        // Category details fetched successfully
        List<dynamic> responseJson = jsonResponse["data"];
        routeList.assignAll(responseJson
            .map((category) => RouteModelClass.fromJson(category)));
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

/// taX
  RxBool taxType = false.obs; // Using RxBool for reactive state
  var taxLists = <TaxTreatmentModelClass>[].obs;

  var vat = [
    { "value": "0", "name": "Business to Business(B2B)"},
    { "value": "1", "name": "Business to Customer(B2C)"},
  ];

  var gst = [
    { "value": "0", "name": "Registered Business - Regular"},
    { "value": "1", "name": "Registered Business - Composition"},
    { "value": "2", "name": "Unregistered Business"},
    { "value": "3", "name": "Consumer"},
    { "value": "4", "name": "Overseas"},
    { "value": "5", "name": "Special Economic Zone"},
    { "value": "6", "name": "Deemed Export"},
  ];
///tax list
  checkTaxType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? gstType = prefs.getBool("check_GST");
    bool? vatType = prefs.getBool("checkVat");
    if (taxType.value == true) {
      vatType == false;

        taxLists.clear();
        for (Map user in gst) {
          taxLists.add(TaxTreatmentModelClass.fromJson(user));
        }

    } else if (taxType.value == false) {
      gstType == false;

        taxLists.clear();
        for (Map user in vat) {
          taxLists.add(TaxTreatmentModelClass.fromJson(user));
        }

      print("gstType");
      print(gstType);
    } else {
      dialogBox(Get.context!, "No Treatment");
    }
  }
  RxBool isCreatingCustomer = false.obs;

  // Future<void> createCustomer({
  //   required String email,
  //   required String address,
  //   required String customerName,
  //   required String displayName,
  //   required String creditLimitText,
  //   required String balanceText,
  //   required String dropdownvalue,
  //   required String as_on_date_api,
  //   required String workPhone,
  //   required String webUrl,
  //   required String creditPeriod,
  //   required int priceCategoryId,
  //   required String panNo,
  //   required String routeId,
  //   required String crNo,
  //   required String bankName,
  //   required String accName,
  //   required String accNo,
  //   required String ibanIfsc,
  //   required String vatNumber,
  //   required String treatmentID,
  //   required bool imageSelect,
  //   String? imgFilePath,
  // }) async {
  //   try {
  //     isCreatingCustomer.value = true;
  //
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var userID = prefs.getInt('user_id') ?? 0;
  //     var accessToken = prefs.getString('access') ?? '';
  //     var companyID = prefs.getString('companyID') ?? '0';
  //     var branchID = prefs.getInt('branchID') ?? 1;
  //
  //     double creditLimit = double.tryParse(creditLimitText) ?? 1;
  //     double openingBalance = double.tryParse(balanceText) ?? 0;
  //
  //     String baseUrl = BaseUrl.baseUrl;
  //     final url = '$baseUrl/posholds/customer-create/';
  //
  //     var headers = {
  //       "Content-Type": "application/json",
  //       'Authorization': 'Bearer $accessToken',
  //     };
  //
  //     var request = http.MultipartRequest('POST', Uri.parse(url));
  //     request.headers.addAll(headers);
  //
  //     request.fields.addAll({
  //       "BranchID": branchID.toString(),
  //       "CreatedUserID": userID.toString(),
  //       "CompanyID": companyID.toString(),
  //       "Email": email,
  //       "Address": address,
  //       "CustomerName": customerName,
  //       "DisplayName": displayName,
  //       "OpeningBalance": openingBalance.toString(),
  //       "CrOrDr": dropdownvalue,
  //       "as_on_date": as_on_date_api,
  //       "WorkPhone": workPhone,
  //       "WebURL": webUrl,
  //       "CreditPeriod": creditPeriod,
  //       "PriceCategoryID": priceCategoryId.toString(),
  //       "PanNumber": panNo,
  //       "CreditLimit": creditLimit.toString(),
  //       "RouteID": routeId,
  //       "CRNo": crNo,
  //       "BankName": bankName,
  //       "AccountName": accName,
  //       "AccountNo": accNo,
  //       "IBANOrIFSCCode1": ibanIfsc,
  //       "VATNumber": vatNumber,
  //       "VAT_Treatment": treatmentID,
  //     });
  //
  //     if (imageSelect && imgFilePath != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath('PartyImage', imgFile!.path),
  //       );
  //     }
  //
  //     final streamResponse = await request.send();
  //     final response = await http.Response.fromStream(streamResponse);
  //
  //
  //     print(response.body);
  //     print(imgFile!.path);
  //     print( "request fields ${request.fields}");
  //
  //     Map<String, dynamic> data = json.decode(utf8.decode(response.bodyBytes));
  //
  //     var status = data["StatusCode"];
  //     print(data);
  //     print(status);
  //
  //     if (status == 6000) {
  //       clearData();
  //       imageSelect = false;
  //       Get.back();
  //       getCustomerListDetails();
  //
  //     } else if (status == 6001) {
  //       var msg = data["message"];
  //       Get.dialog(
  //         AlertDialog(
  //           title: Text("Error"),
  //           content: Text(msg),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Get.back(),
  //               child: Text("OK"),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     Get.dialog(
  //       AlertDialog(
  //         title: Text("Error"),
  //         content: Text(e.toString()),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Get.back(),
  //             child: Text("OK"),
  //           ),
  //         ],
  //       ),
  //     );
  //   } finally {
  //     isCreatingCustomer.value = false;
  //   }
  // }
  Future<void> createCustomer({
    required String email,
    required String address,
    required String customerName,
    required String displayName,
    required String creditLimitText,
    required String balanceText,
    required String dropdownvalue,
    required String as_on_date_api,
    required String workPhone,
    required String webUrl,
    required String creditPeriod,
    required int priceCategoryId,
    required String panNo,
    required String routeId,
    required String crNo,
    required String bankName,
    required String accName,
    required String accNo,
    required String ibanIfsc,
    required String vatNumber,
    required String treatmentID,
    required bool imageSelect,
    String? imgFilePath,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? '0';
      var branchID = prefs.getInt('branchID') ?? 1;

      double creditLimit = double.tryParse(creditLimitText) ?? 1;
      double openingBalance = double.tryParse(balanceText) ?? 0;

      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/posholds/customer-create/';

      var headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      };

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      request.fields.addAll({
        "BranchID": branchID.toString(),
        "CreatedUserID": userID.toString(),
        "CompanyID": companyID.toString(),
        "Email": email,
        "Address": address,
        "CustomerName": customerName,
        "DisplayName": displayName,
        "OpeningBalance": openingBalance.toString(),
        "CrOrDr": dropdownvalue,
        "as_on_date": as_on_date_api,
        "WorkPhone": workPhone,
        "WebURL": webUrl,
        "CreditPeriod": creditPeriod,
        "PriceCategoryID": priceCategoryId.toString(),
        "PanNumber": panNo,
        "CreditLimit": creditLimit.toString(),
        "RouteID": routeId,
        "CRNo": crNo,
        "BankName": bankName,
        "AccountName": accName,
        "AccountNo": accNo,
        "IBANOrIFSCCode1": ibanIfsc,
        "VATNumber": vatNumber,
        "VAT_Treatment": treatmentID,
      });

      // Add image file if imageSelect is true and imgFilePath is provided
      if (imageSelect && imgFilePath != null) {
        // Ensure imgFilePath is a valid path to the image file
        request.files.add(
          await http.MultipartFile.fromPath('PartyImage', imgFilePath),
        );
      }

      // Send the request and get response
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse response data if needed
        Map<String, dynamic> responseData = json.decode(response.body);
        var status = responseData["StatusCode"];

        if (status == 6000) {
          // Handle success case
          clearData();
          Get.back();
          getCustomerListDetails();
        } else if (status == 6001) {
          // Handle error case
          var msg = responseData["message"];
          Get.dialog(
            AlertDialog(
              title: Text("Error"),
              content: Text(msg),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle other status codes if needed
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error creating customer: $e');
      Get.dialog(
        AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }}
  clearData(){

    customerNameController.clear();
    displayNameController.clear();
    balanceController.clear();
    dateController.clear();
    emailController.clear();
    workPhoneController.clear();
    webUrlController.clear();
    addressController.clear();
    creditPeriodController.clear();
    priceCategoryController.clear();
    panNoController.clear();
    creditLimitController.clear();
    routesController.clear();
    crNoController.clear();
    bankNameController.clear();
    accNameController.clear();
    accNoController.clear();
    ibanIfscController.clear();
    treatmentController.clear();
    taxNoController.clear();
  }



  void getSingleView(String id) async {
    try {
      print("1222");
      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? '';
      print("123333");
      String baseUrl = BaseUrl.baseUrl;
      bool? gstType = prefs.getBool("check_GST");
      print("1244");
      bool? vatType = prefs.getBool("checkVat");
      print("1255");
      final url = '$baseUrl/posholds/single/customer/$id/';
      print("1266");
      var data = {
        "CompanyID": companyID,
        "CreatedUserID": userID,
      };
      print("12777");
      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print("12888");
      var n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];

      if (status == 6000) {
        print("12999");
        addressController.text = responseJson['Address1'];
        purchaseDateValue = responseJson['as_on_date'];
        customerNameController.text = responseJson['FirstName'] ?? '';
        webUrlController.text = responseJson['WebURL'] ?? '';       print("131");
        creditPeriodController.text = responseJson['CreditPeriod'].toString();print("132");
        panNoController.text = responseJson['PanNumber'] ?? '';
        bankNameController.text = responseJson['BankName1'] ?? '';print("13223");
        accNameController.text = responseJson['AccountName1'] ?? '';print("13244");
        accNoController.text = responseJson['AccountNo1'] ?? '';
        ibanIfscController.text = responseJson['IBANOrIFSCCode1'];print("dddddd");
        priceCategoryController.text = responseJson['PriceCategoryName'];
        workPhoneController.text = responseJson['PhoneNumber'] ?? '';print("242432");
        emailController.text = responseJson['Email'] ?? '';
        crNoController.text = responseJson['CRNo'] ?? '';
        displayNameController.text = responseJson['DisplayName'] ?? '';
        balanceController.text = roundStringWith(responseJson['OpeningBalance']) ?? '';
        routesController.text = responseJson['RouteName'] ?? '';
        creditLimitController.text = roundStringWith(responseJson['CreditLimit']) ?? '';
        priceCategoryID = responseJson['PriceCategoryID'];
        routeID = responseJson['RouteID'];

        if (gstType!) {
          treatmentController.text = findGstTreatment(responseJson['GST_Treatment']);
        }

        if (vatType!) {
          treatmentController.text = findVatTreatment(responseJson['VAT_Treatment']);
        }

        var partyImage = responseJson["PartyImage"] ?? '';

        if (partyImage.isNotEmpty) {
          var imgData = BaseUrl.imageURL + partyImage;
          print('---imageData-----$imgData');
          loadImage(imgData);
        }

        isLoading.value = false;
      } else if (status == 6001) {
       var a = n["error"];
       dialogBox(Get.context!,  a);
        isLoading.value = false;
      } else if (status == 6002) {
        var a = n["error"]??"Something went wrong";
        dialogBox(Get.context!,  a);
        isLoading.value = false;
      } else {

        isLoading.value = false;
      }
    } catch (e) {
      dialogBox(Get.context!, e.toString());

      isLoading.value = false;
    }
  }

  findGstTreatment(treatment) {
    if (treatment == "0") {
      return "Registered Business - Regular";
    } else if (treatment == "1") {
      return "Registered Business - Composition";
    } else if (treatment == "2") {
      return "Unregistered Business";
    } else if (treatment == "3") {
      return "Consumer";
    } else if (treatment == "4") {
      return "Overseas";
    } else if (treatment == "5") {
      return "Special Economic Zone";
    } else {
      return "Deemed Export";
    }
  }

  findVatTreatment(String id) {
    if (id == "0") {
      return "Business to Business(B2B)";
    } else if (id == "1") {
      return "Business to Customer(B2C)";
    } else if (id == "2") {
      return "Export";
    } else {
      return "";
    }
  }
}