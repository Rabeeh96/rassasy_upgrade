import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/productListModelClass.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/model/taxModelListClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file/file.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../model/group_model_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file/file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/new_design/dashboard/product/detail/select_category_new.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';


class ProductController extends GetxController {
  ValueNotifier<bool> isVegNotifier = ValueNotifier<bool>(
      false); // Initialize with initial value
  ValueNotifier<bool> isNonVegNotifier = ValueNotifier<bool>(
      false); // Initialize with initial value
  ValueNotifier<bool> isInclusiveTax = ValueNotifier<bool>(
      false); // Initialize with initial value
  TextEditingController productNameController = TextEditingController();
  TextEditingController groupController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController salesPriceController = TextEditingController();
  TextEditingController taxPriceController = TextEditingController();
  TextEditingController execiveTaxPriceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  FocusNode nameFCNode = FocusNode();
  FocusNode descriptionFcNode = FocusNode();
  FocusNode categoryFcNode = FocusNode();
  FocusNode priceFcNode = FocusNode();
  FocusNode purchasePriceFcNode = FocusNode();
  FocusNode taxFCNode = FocusNode();
  FocusNode saveFcNode = FocusNode();
  int taxID=0;
  int execiveID=0;
  int groupID=0;
  var defaultTaxId = 1;
  var defaultTaxName = "None";
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }
  bool imageSelect = false;

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
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
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

  bool imageSelect2 = false;
  bool imageSelect3 = false;
  File? imgFile;
  File? imgFile2;
  File? imgFile3;

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    // setState(() {
    //   if (type == 1) {
    //     imgFile = File(imgCamera!.path);
    //     imageSelect = true;
    //   } else if (type == 2) {
    //     imgFile2 = File(imgCamera!.path);
    //     imageSelect2 = true;
    //   } else if (type == 3) {
    //     imgFile3 = File(imgCamera!.path);
    //     imageSelect3 = true;
    //   }
    //   print("camera");
    //   print(imgFile);
    // });
    Navigator.of(Get.context!).pop();
  }

  void openGallery() async {
    print('1');
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    print('2');
    print('3');
    //
    // setState(() {
    //   if (type == 1) {
    //     imgFile = File(imgGallery!.path);
    //     imageSelect = true;
    //   } else if (type == 2) {
    //     imgFile2 = File(imgGallery!.path);
    //     imageSelect2 = true;
    //   } else if (type == 3) {
    //     imgFile3 = File(imgGallery!.path);
    //     imageSelect3 = true;
    //   }
    //   print("gallery");
    //   print(imgFile);
    // });

    Navigator.of(Get.context!).pop();
  }
  Widget displayImage() {
    return GestureDetector(
      onTap: () {
        type = 1;
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

  final imgPicker = ImagePicker();
  int type = 1;
  var products = <Product>[].obs;
var isLoading=false.obs;
var isProductLoading=false.obs;
var isLoadingTax=false.obs;
var isGroupLoading=false.obs;
var isGst=false;
var createPermission=false;
var isExcise=false;
var isSingleLoading=false.obs;
var isEditLoading=false.obs;

///list products
  void fetchProducts(String search) async {
    try {
      isLoading.value=true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      isGst = prefs.getBool("check_GST") ?? false;
      createPermission = prefs.getBool("Productsave") ?? true;
      isExcise = prefs.getBool("EnableExciseTax") ?? false;
      String baseUrl = BaseUrl.baseUrl;
      var url = Uri.parse('$baseUrl/posholds/pos-product-list-paginated/');
      print(url);
      var payload = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "PriceRounding": BaseUrl.priceRounding,
        "GroupID": null,
        "page_no": 1,
        "items_per_page": 40,
        "search": search
      };

      var response = await http.post(
        url,
        body: json.encode(payload),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        isLoading.value=false;

        var jsonResponse = json.decode(response.body);
        var productList = (jsonResponse['data'] as List)
            .map((data) => Product.fromJson(data))
            .toList();
        products.assignAll(productList);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      isLoading.value=false;

      print('Error: $e');
    }
  }
  ///delete products
  Future<void> deleteProduct(String productUID) async {
    try {
      isLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/delete/product/$productUID/';

      Map<String, dynamic> data = {
        "CreatedUserID": userID,
        "CompanyID": companyID,
        "BranchID": branchID,
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

      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];

      if (status == 6000) {
        isLoading(false);
        fetchProducts(''); // Call a method to refresh the product list
        Get.snackbar('Success', 'Product deleted successfully');
      } else if (status == 6001) {
        var message = jsonResponse["message"] ?? "An error occurred";
        Get.snackbar('Error', message);
      }else if (status == 6002) {
        var message = jsonResponse["error"]??jsonResponse["message"] ;
        Get.snackbar('Error', message);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading(false);
    }
  }

  var taxLists = <TaxModelListClass>[].obs;
  ///tax list
  Future<void> getTaxDetails(String type) async {
    try {

        isLoadingTax(true);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var priceRounding = BaseUrl.priceRounding;

        String baseUrl = BaseUrl.baseUrlV11;
        final String url = '$baseUrl/taxCategories/taxListByType/';
        var checkGst = prefs.getBool("check_GST") ?? false;
        int taxType = checkGst ? 2 : 1;

        Map<String, dynamic> data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": priceRounding,
          "TaxType": taxType,
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

        Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        var status = jsonResponse["StatusCode"];

        if (status == 6000) {
          // Tax details fetched successfully
          List<dynamic> responseJson = jsonResponse["data"];
          taxLists.clear();
          if (type== "1") {
            taxLists.assignAll(responseJson.map((tax) => TaxModelListClass.fromJson(tax)));
          } else {
            var excise = jsonResponse["excise_data"];
            taxLists.assignAll(excise.map((tax) => TaxModelListClass.fromJson(tax)));
          }
        } else if (status == 6001) {
          var message = jsonResponse["error"] ?? "An error occurred";
          Get.snackbar('Error', message);
        }
      }
    catch (e) {
      // Handle error
    } finally {
      isLoadingTax(false);
    }
  }
///group
  var categoryLists = <GroupModelClassMobile>[].obs;
  ///group
  Future<void> getGroupLists() async {
    try {
      isGroupLoading(true);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/pos/product-group/list/';
      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
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

      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];

      if (status == 6000) {
        // Category details fetched successfully
        List<dynamic> responseJson = jsonResponse["data"];
        categoryLists.assignAll(responseJson.map((category) => GroupModelClassMobile.fromJson(category)));
      } else if (status == 6001) {
        var message = jsonResponse["error"] ?? "An error occurred";
        Get.snackbar('Error', message);

      }
    } catch (e) {
      // Handle error
    } finally {
      isGroupLoading(false);
    }
  }



  ///create product

  final isInclusiveNotifier = false.obs;



  var veg = false;

  var productTaxID = 0;
  var productExciseTaxID = 0;
  var categoryID = 0;

  ///createproducts
  void createProduct() async {
    try {
      isProductLoading.value=true;
      final prefs = await SharedPreferences.getInstance();
      final userID = prefs.getInt('user_id') ?? 0;
      final accessToken = prefs.getString('access') ?? '';
      final companyID = prefs.getString('companyID') ?? '0';
      final branchID = prefs.getInt('branchID') ?? 1;

      final type = veg == true ? "veg" : "Non-veg";


      var price = "0.00";
      if (salesPriceController.text.isNotEmpty) {
        price = salesPriceController.text;
      }

      var purchasePrice = "0.00";
     if (purchasePriceController.text.isNotEmpty) {
        purchasePrice = purchasePriceController.text;
    }

      final val = isInclusiveNotifier.value ? 'True' : 'False';

      final baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/posholds/product-create/';
      final headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      };

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        "SalesPrice": salesPriceController.text,
        "PurchasePrice": purchasePriceController.text,
        "BranchID": branchID.toString(),
        "CreatedUserID": userID.toString(),
        "CompanyID": companyID,
        "VegOrNonVeg": type,
        "ProductName": productNameController.text,
        "ProductGroupID": groupID.toString(),
        "Description": descriptionController.text,
        "Price": price,
        "TaxID": taxID.toString(),
        "is_inclusive": val,
        "ExciseTaxID": execiveID.toString(),
      });

      if (imageSelect) {
        request.files.add(await http.MultipartFile.fromPath('productImage1', imgFile!.path));
      }
      if (imageSelect2) {
        request.files.add(await http.MultipartFile.fromPath('productImage2', imgFile2!.path));
      }
      if (imageSelect3) {
        request.files.add(await http.MultipartFile.fromPath('productImage3', imgFile3!.path));
      }

      request.headers.addAll(headers);

      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      final n = json.decode(utf8.decode(response.bodyBytes));
      final status = n["StatusCode"];
      if (status == 6000) {
        imageSelect = false;
        imageSelect2 = false;
        imageSelect3 = false;
        /// Colors.orange;
        /// Colors.transparent;
        veg = false;
        final msg = n["message"];
        isInclusiveNotifier.value = false;
       /// addNewProduct = false;
        isProductLoading.value=false;
     clearData();
       /// defaultValue();
         Get.back();
        fetchProducts('');
      } else if (status == 6001) {
        final msg = n["message"] ?? "";
        Get.dialog(msg);
        isProductLoading.value=false;
      } else if (status == 6002) {
        final msg = n["error"] ?? "";
        Get.dialog(msg);
        isProductLoading.value=false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());


      isProductLoading.value=false;
    }
  }
  ///clear fields
  clearData() {
    productNameController.clear();
    descriptionController.clear();
    groupController.clear();
    salesPriceController.clear();
    taxPriceController.clear();
    execiveTaxPriceController.clear();

  }
///arabic translation
  Future<void> convertToArabic({required String name}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access') ?? '';
      final baseUrl = BaseUrl.baseUrl;
      final url = "$baseUrl/translate/translate/";

      final data = {
        "keyword": name,
        "language": "ar"
      };

      final body = json.encode(data);
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      final statusCode = response.statusCode;
      final responseBody = utf8.decode(response.bodyBytes);

      if (statusCode == 200) {
        final responseData = json.decode(responseBody);
        final status = responseData["StatusCode"];
        final arabic = responseData["data"];

        if (status == 6000) {
          descriptionController.text = arabic;
        } else {
          final msg='Try again';
          Get.dialog(msg as Widget);

        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      Get.dialog("Error In Loading: $e" as Widget);
      print('Error In Loading: $e');
    }
  }


  ///singleview for edit products
  Future<void> getProductSingleView(String id) async {
    try {
      isSingleLoading.value=true;

      print("2");
      final prefs = await SharedPreferences.getInstance();
      final userID = prefs.getInt('user_id') ?? 0;
      final accessToken = prefs.getString('access') ?? '';
      final companyID = prefs.getString('companyID') ?? '0';
      final branchID = prefs.getInt('branchID') ?? 1;


      print("3");
      final baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/posholds/single/product/$id/';
      print(url);
      final data = {
        "CompanyID": companyID,
      };
      print("4");
      print(data);
      //encode Map to JSON
      final body = json.encode(data);
      final response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      print("5   $accessToken");
      print(response.statusCode);

      final n = json.decode(utf8.decode(response.bodyBytes));
      final status = n["StatusCode"];
      final responseJson = n["data"];
      print(responseJson);

      print("6");
      print(responseJson);
      if (status == 6000) {
        isSingleLoading.value=false;
        imageSelect2 = false;
        imageSelect = false;
        imageSelect3 = false;

        final checkVat = prefs.getBool("checkVat") ?? false;
        final checkGst = prefs.getBool("check_GST") ?? false;

        if (checkVat == true) {
          taxID = responseJson['VatID'];
          taxPriceController.text = responseJson['VAT_TaxName'];
          execiveTaxPriceController.text = responseJson['VAT_TaxName'];
          execiveID = responseJson['VatID'];

          final exciseData = responseJson["ExciseTaxData"] ?? '';
          print("------------------------asd");
          if (exciseData != '') {
            print("------------------------dsa");
            execiveTaxPriceController.text = exciseData["TaxName"] ?? '';
            productExciseTaxID = exciseData["TaxID"] ?? 6;
          } else {
            productExciseTaxID = taxID;
            execiveTaxPriceController.text = defaultTaxName;
          }
        }

        if (checkGst == true) {
          productTaxID = responseJson['GST_ID'];
          taxPriceController.text = responseJson['GST_TaxName'];
        }


        categoryID = responseJson['ProductGroupID'];

        isInclusiveNotifier.value = responseJson['is_inclusive'];
        productNameController.text = responseJson['ProductName'];
        salesPriceController.text = responseJson['DefaultSalesPrice'].toString();
        purchasePriceController.text =        responseJson['DefaultPurchasePrice'].toString();
        descriptionController.text = responseJson['Description'];
        groupController.text = responseJson['GroupName'];

        final imgData = responseJson["ProductImage"] ?? '';
        final imgData2 = responseJson["ProductImage2"] ?? '';
        final imgData3 = responseJson["ProductImage3"] ?? '';

        // if (imgData != '') {
        //   loadImage(imgData, 1);
        // }
        // if (imgData2 != '') {
        //   loadImage(imgData2, 2);
        // }
        // if (imgData3 != '') {
        //   loadImage(imgData3, 3);
        // }


      } else if (status == 6001) {
        isSingleLoading.value=false;
        final msg = n["error"] ?? '';
        Get.snackbar('Error', msg);

      } else {
        isSingleLoading.value=false;
        // DB Error
      }
    } catch (e) {
      isSingleLoading.value=false;
      print('Error In Loading: $e');
      Get.snackbar('Error', e.toString());
    }
  }
  // Future<File> getFileFromNetworkImage(String imageUrl) async {
  //   var response = await http.get(Uri.parse(imageUrl));
  //   final documentDirectory = await getApplicationDocumentsDirectory();
  //   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   File file = File(p.join(documentDirectory.path, '$fileName.png'));
  //   file.writeAsBytes(response.bodyBytes);
  //   return file;
  // }
  // loadImage(image, type) async {
  //   try {
  //     final file = await getFileFromNetworkImage(image);
  //     if (type == 1) {
  //       imageSelect = true;
  //       imgFile = file;
  //     } else if (type == 2) {
  //       imageSelect2 = true;
  //       imgFile2 = file;
  //     } else {
  //       imageSelect3 = true;
  //       imgFile3 = file;
  //     }
  //   } catch (e) {}
  // }

  Future<void> editProduct(String id) async {
    try {
      isEditLoading.value=true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? '0';
      var branchID = prefs.getInt('branchID') ?? 1;

      var type = veg == true ? "veg" : "Non-veg";

      var val = isInclusiveNotifier.value == true ? 'True' : 'False';
      var price = "0.00";

      if (salesPriceController.text.isNotEmpty) {
        price = salesPriceController.text;
      }
      var purchasePrice = "0.00";

      if (purchasePriceController.text.isNotEmpty) {
        purchasePrice = purchasePriceController.text;
      }

      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/posholds/edit/product/$id/';

      var headers = {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $accessToken',
      };

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        "SalesPrice": price,
        "PurchasePrice": purchasePriceController.text,
        "BranchID": branchID.toString(),
        "CreatedUserID": userID.toString(),
        "CompanyID": companyID,
        "VegOrNonVeg": type,
        "ProductName": productNameController.text,
        "ProductGroupID": groupID.toString(),
        "Description": descriptionController.text,
        "Price": purchasePrice,
        "TaxID": taxID.toString(),
        "is_inclusive": val,
        "ExciseTaxID": execiveID.toString(),
      });

      if (imageSelect) {
        request.files.add(await http.MultipartFile.fromPath('productImage1', imgFile!.path));
      }
      if (imageSelect2) {
        request.files.add(await http.MultipartFile.fromPath('productImage2', imgFile2!.path));
      }
      if (imageSelect3) {
        request.files.add(await http.MultipartFile.fromPath('productImage3', imgFile3!.path));
      }

      request.headers.addAll(headers);
      final streamResponse = await request.send();
      final response = await http.Response.fromStream(streamResponse);
      Map n = json.decode(utf8.decode(response.bodyBytes));

      var status = n["StatusCode"];
      if (status == 6000) {

        isEditLoading.value=false;
        isInclusiveNotifier.value = false;

        veg = false;
        imageSelect = false;
        imageSelect2 = false;
        imageSelect3 = false;
        var msg = n["message"] ?? '';
        Get.dialog(msg);
       /// addNewProduct = false;
        Get.back();
        clearData();
        print("ghdfdfgdfgdffffffffffffdhfhghf");
      //  edit = false;
      //  defaultValue();
        fetchProducts('');
      } else if (status == 6001) {
        var msg = n["message"] ?? '';
        Get.dialog(msg);
        isEditLoading.value=false;
      }
    } catch (e) {

      isEditLoading.value=false;
    }
  }
}