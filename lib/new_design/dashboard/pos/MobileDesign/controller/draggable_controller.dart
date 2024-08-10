import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/global.dart';

class TableListController extends GetxController {
  var tableList = <Map<String, dynamic>>[].obs;
  var isLoading=true.obs;
  var selectedValue = 3.obs;
  Future<void> fetchTables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
  // Future<void> fetchTables() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var branchID = prefs.getInt('branchID') ?? 0;
  //   var companyID = prefs.getString('companyID') ?? '';
  //   var accessToken = prefs.getString('access') ?? '';
  //   String baseUrl1 = BaseUrl.baseUrl;
  //   final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
  //   print(baseUrl);
  //
  //   final payload = {
  //     "CompanyID": companyID,
  //     "BranchID": branchID,
  //     "POSTableList": [],  // Assuming this is needed for the request
  //     "Type": "List"
  //   };
  //   print(payload);
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(baseUrl),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken', // Add token here if needed
  //       },
  //       body: jsonEncode(payload),
  //     );
  //     print(' rres: ${response.body}');
  //     if (response.statusCode == 200) {
  //       print('Unexpected StatusCode: ${response.statusCode}');
  //       print('Unexpected StatusCode: ${response.body}');
  //
  //       final data = jsonDecode(response.body);
  //
  //       // Ensure StatusCode is what you expect
  //       if (data['StatusCode'] == 6000) {
  //         final List<dynamic> tableListData = data['data'];
  //         tableList.value = tableListData.map((json) => TableListModelClass.fromJson(json)).toList();
  //       } else {
  //         print('Unexpected StatusCode: ${data['StatusCode']}');
  //       }
  //
  //
  //
  //     } else {
  //       print('Failed to fetch tables: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }


// controller.addTable(TableListModelClass(
// id: 'new-id',
// tableName: 'New Table',
// position: 1,
// ));
// controller.updateTableList();

  void addTable(Map<String, dynamic> table) {
    tableList.add(table);
  }

  void removeTable(String id) {
    tableList.removeWhere((table) => table['id'] == id);
  }
}

class TableListModelClass {
  String id, tableName;
  int position;

  TableListModelClass({required this.id, required this.tableName,required this.position});

  factory TableListModelClass.fromJson(Map<dynamic, dynamic> json) {
    return TableListModelClass(
      id: json['id'],
      tableName: json['TableName'],
      position: json['Position'],
    );
  }}


// }import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../global/global.dart';
//
// class TableListController extends GetxController {
//   var tableList = <TableListModelClass>[].obs;
//    var isLoading=true.obs;
//   Future<void> fetchTables() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var branchID = prefs.getInt('branchID') ?? 0;
//     var companyID = prefs.getString('companyID') ?? '';
//     var accessToken = prefs.getString('access') ?? '';
//     String baseUrl1 = BaseUrl.baseUrl;
//     final String baseUrl = '$baseUrl1/posholds/pos-table-update/';
//     print(baseUrl);
//
//     final payload = {
//       "CompanyID": companyID,
//       "BranchID": branchID,
//       "POSTableList": [],  // Assuming this is needed for the request
//       "Type": "List"
//     };
//     print(payload);
//
//     try {
//       final response = await http.post(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $accessToken', // Add token here if needed
//         },
//         body: jsonEncode(payload),
//       );
//       print(' rres: ${response.body}');
//       if (response.statusCode == 200) {
//         print('Unexpected StatusCode: ${response.statusCode}');
//         print('Unexpected StatusCode: ${response.body}');
//
//         final data = jsonDecode(response.body);
//
//         // Ensure StatusCode is what you expect
//         if (data['StatusCode'] == 6000) {
//           final List<dynamic> tableListData = data['data'];
//           tableList.value = tableListData.map((json) => TableListModelClass.fromJson(json)).toList();
//         } else {
//           print('Unexpected StatusCode: ${data['StatusCode']}');
//         }
//
//
//
//       } else {
//         print('Failed to fetch tables: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   void addTable(TableListModelClass table) {
//     tableList.add(table);
//   }
// // controller.addTable(TableListModelClass(
// // id: 'new-id',
// // tableName: 'New Table',
// // position: 1,
// // ));
// // controller.updateTableList();
//
//   void removeTable(String id) {
//     tableList.removeWhere((table) => table.id == id);
//   }
// }
//
// class TableListModelClass {
//   String id, tableName;
//   int position;
//
//   TableListModelClass({required this.id, required this.tableName,required this.position});
//
//   factory TableListModelClass.fromJson(Map<dynamic, dynamic> json) {
//     return TableListModelClass(
//       id: json['id'],
//       tableName: json['TableName'],
//       position: json['Position'],
//     );
//   }
// }