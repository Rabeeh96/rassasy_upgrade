import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU0NzMzOTkwLCJpYXQiOjE3MjMxOTc5OTAsImp0aSI6IjY1ZmQwOTQwMDI2ZjQzMTJhYTk2OTBmNTlkNTQwYjZkIiwidXNlcl9pZCI6MzcxfQ.ngqkBT3aH7DmzmpcDZUpcvvH7ktE8WpwWmUzarawNBtP75IFqfGA3YyqV0vQfl7ZrgROTGyigDvtFWqRR2hUmDhbyF2a58WaVP0YktcdcysL6fHIzzBUVEz6knbujQZaoDKom_UI8FW8wDx-JzYnNFxlfOfDBdXkt9AB6TRo_3VBz2_8TwzcYSI2ccHIiK-xo0LMGNDnAXSSXZLyPUB24Uje2ei06s4D1WAkInsi2zMo-cRfaqn7AFamICprY4KlCY5uKPg27luK_XthmS2vySwijf7gQkMMZi3Z1yQvEgVgq6O3Ry5f3l0FmM6NAC9jr5x80oEj6DXHtvX21Z0SckrGLty0jlWJEA4wDrNDfHNFGWYRex4CLHJMi6900qns4Zd_i-PSEg7JiLy7CQArzRk34cUvqsErfJr7xtxtsLHmqpkDMBFNWXxDE_mU5uCsyT5ltR4XQa0yDkQbnGKeioxulQGMVS0Kdg3YyYiVft7d3_8dP9e1VoS1W8kHkFRm4D_Sk-oJ5x3sbKPat-cX3lrOXJA4nR6zzgy46qlPJrgu5ddhdiGQnsKZSKGrCC2AiIXxhcpwAOo1hlS4_1no3tKZuUPIvk846TTBPdYiIysC9MY3tj7E_XAnotuDgcigXl3fC1Sgho_2mno2698rB5qk6UCuPWmSQ13DCs92HDM";
  final String apiUrl = 'https://www.api.viknbooks.com/api/v10/posholds/pos-product-list/';

  @override
  void onInit() {
    loadProductDatasList();
    super.onInit();
  }

  var productDatasList = [].obs; // Observable list to store product IDs
  var fetchedList = [].obs; // Observable list to store product IDs
  List productsForGroup=[];
  Future<void> fetchProducts(int groupId) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "CompanyID": "5a09676a-55ef-47e3-ab02-bac62005d847",
          "BranchID": 1,
          "GroupID": groupId,
          "type": "",
          "PriceRounding": 2
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['StatusCode'] == 6000) {
          var productList = data['data'] as List;

          /// products.value = productList.map((e) => Product.fromJson(e)).toList();
          print("productList  $productList");

          productDatasList.addAll(productList);
          saveProductDatasList(productList.cast<Map<String, dynamic>>());
          log("productDatasList $productDatasList");
          print("leng${productDatasList.length}");
        } else {
          errorMessage.value = 'Error: ${data['StatusCode']}';
        }
      } else {
        errorMessage.value = 'Failed to load data';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveProductDatasList(List<Map<String, dynamic>> productList) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert the list of maps to a JSON string
    String jsonString = jsonEncode(productList);

    // Save the JSON string to SharedPreferences
    await prefs.setString('productsList', jsonString);

    // Print the added data to verify
    print("Data saved to SharedPreferences:");
    await printAllItems();
  }

  Future<void> printAllItems() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the JSON string from SharedPreferences
    String? jsonString = prefs.getString('productsList');

    if (jsonString != null) {
      // Decode the JSON string to a list of maps
      List<dynamic> jsonList = jsonDecode(jsonString);
      print("All items in SharedPreferences:");

      for (var item in jsonList) {
        print(item);
      }
    } else {
      print("No items found in SharedPreferences.");
    }
  }
  List getProductsByGroupId(int groupId) {
    return productDatasList.where((product) => product['ProductGroupID'] == groupId).toList();
  }
  void displayProductsByGroupId(int groupId) {
    productsForGroup= getProductsByGroupId(groupId);
    print("Products for group $groupId: $productsForGroup");
  }
  Future<void> loadProductDatasList() async {
    print("load all data");
    final prefs = await SharedPreferences.getInstance();

    // Get the JSON string from SharedPreferences
    String? jsonString = prefs.getString('productsList');
    print("json string $jsonString");

    if (jsonString != null) {
      // Decode the JSON string to a list of maps
      List<dynamic> jsonList = jsonDecode(jsonString);
      fetchedList.addAll(jsonList.cast<Map<String, dynamic>>());
      log("json productDatasList $fetchedList");
      log("length ${fetchedList.length}");

    } else {
      print("No items found in SharedPreferences.");
    }
  }
}

// Future<void> saveProductDatasListHive(List<Map<String, dynamic>> productList) async {
//     final box = Hive.box('productsBox');
//     await box.clear(); // Optional: Clear existing data before adding new
//
//     for (var product in productList) {
//       log("Saving product: $product");
//       await box.put(product['id'], product);
//     }
//
//     // Print the added data to verify
//     print("Data saved to Hive:");
//     await printAllItems();
//   }
//
//   Future<void> printAllItems() async {
//     final box = Hive.box('productsBox');
//     print("All items in the Hive box:");
//
//     for (var key in box.keys) {
//       var item = box.get(key);
//       print("Key: $key, Value: $item");
//     }
//   }
//
//   Future<void> loadProductDatasListhive() async {
//     final box = Hive.box('productsBox');
//     var productsList = box.values.toList().cast<Map<String, dynamic>>();
//     productDatasList.addAll(productsList);
//   }



