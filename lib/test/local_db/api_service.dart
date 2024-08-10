// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/test/local_db/data_base_global.dart';
//
// import 'model.dart';
//
// class ApiService {
//   static const String apiUrl = 'https://www.api.viknbooks.com/api/v10/posholds/pos-product-list/';
//   static const String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU0NTYwMzQwLCJpYXQiOjE3MjMwMjQzNDAsImp0aSI6IjQ0OWJiYjA5YTk2YjRlZTI5ZDc0OTFmOTgwOGZkNjhlIiwidXNlcl9pZCI6NjJ9.aOyTABZFFxsEm4-6f3TlaK2bow9AosLQFTBRKHf_JUIX_v8sh5O1hBOP8Y6whgbDiZ0QAJ_Hx1Z8qqXOT1EJYM80yy_AvaEFJ7fv85T-V4PsjRxfxnPnEiuBh37u_HRFIE9AI1F9T1wD6LFqNDbca5DN--oC6V2NZF-uWmsTyUJBiW2Sla9poR_QhsYWD8rCXq72nud97xK1M71aYiBiZ1TT9sgJ1eiJdxDyuupAVJr3Uceny0Lc0-HwqolEFxjasMjoYxJgnb8x-vQvml14fipeFvDubPvp3KqpblhBrJyzL-7PdwwyVtIqL5nzx9xLy7_8JKAmsNJvjv-FtnIls_PplljD7efHtPCrYkANicTRuSSenvyisdcv94PkC7bRBQ6v7itMbXf6y_5NX5e-FRO6s2KJDpMWGs3ggjkk1oXs3cbztge1rR-Llad8p54-DARDytOGsHOsVxbu2soYbTM0AxjrcwF5nuRKli9SsMKwOIscC0zUD6C889HHO_6awphNcGjxiu3EX7SbLCiyFXoq1MtS3I2q7NtXH3doskqCxXRLpgOTKc6YSPzzmmAmqvEXI24fnMV6bwTMaOGDeF2mchipUc2FbDn6ayzVDBOPONf7hu-wqM42vzbVLFBSQ2O4EDiL-zWSfYlndz47ZY8SUa0RAg4Okc_o_Y7EnFs';
//
//   static Future<void> fetchAndSaveProducts() async {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: jsonEncode({
//         'CompanyID': '5a09676a-55ef-47e3-ab02-bac62005d847',
//         'BranchID': 1,
//         'GroupID': 12,
//         'type': '',
//         'PriceRounding': 2,
//       }),
//     );
//
//
//     print(response.body);
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//
//       // Assuming the product data is in a key named 'products'
//       final List<dynamic> data = responseData['data'];
//       final List<Product> products = data.map((item) {
//         return Product(
//           id: item['id'],
//           productId: item['ProductID'],
//           name: item['ProductName'],
//           salePrice: item['DefaultSalesPrice'].toString(),
//           purchasePrice: item['DefaultPurchasePrice'].toString(),
//           salesTax: item['SalesTax'].toString(),
//           description: item['Description'],
//         );
//       }).toList();
//       log_data("-------------------------");
//
//       final dbHelper = DatabaseHelper();
//       log_data("-------------------------987456321");
//       for (final product in products) {
//         dbHelper.insertProduct(product);
//       }
//
//     } else {
//
//       throw Exception('Failed to load products');
//     }
//   }
// }
