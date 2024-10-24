import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/salesreportModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportController extends GetxController {
  var selectedValue = 'Invoice'.obs;

  var reporttype = 'Invoice Report'.obs;
  var servicetypevalue = 'dinein'.obs;
  var servicetype = ''.obs;
  final RxInt reportDetailValue = 1.obs;
  final RxInt tablewisereportValue = 1.obs;
  final RxInt productValue = 1.obs;
  final selectproduct = 'cbf'.obs;
  final selectproductgroup = 'All'.obs;
  var rmstypevalue = 'date'.obs;
  var rmstype = ''.obs;
  var isLoading = true.obs;

  void reportonChanged(String? value) {
    selectedValue.value = value ?? '';
    if (value == 'Invoice') {
      reporttype.value = 'Invoice Report';
    } else if (value == 'Sales') {
      reporttype.value = 'Sales Report';
    } else if (value == 'Salesorder') {
      reporttype.value = 'Sales Order Report';
    } else if (value == 'Product') {
      reporttype.value = 'Product Report';
    } else if (value == 'Tablewise') {
      reporttype.value = 'Table Wise Report';
    } else if (value == 'Dailysummary') {
      reporttype.value = 'Daily Summary';
    }
  }

  void serviceonChanged(String? value) {
    servicetypevalue.value = value ?? '';
    if (value == 'dinein') {
      servicetype.value = 'Dine In';
    } else if (value == 'takeaway') {
      servicetype.value = 'Take Away';
    } else if (value == 'online') {
      servicetype.value = 'Online';
    } else {
      servicetype.value = '';
    }
  }

  void rmstypeonChanged(String? value) {
    rmstypevalue.value = value ?? '';

    if (value == 'date') {
      rmstype.value = 'Date';
    } else if (value == 'transactiondate') {
      rmstype.value = 'Transaction Date';
    } else if (value == 'createddate') {
      rmstype.value = 'Created Date';
    } else {
      rmstype.value = '';
    }
  }

  var salesReportList = <SalesreportModel>[].obs;

  Future<List<SalesreportModel>?> getSalesReport() async {
    try {
      isLoading(true);
      String baseUrl = BaseUrl.baseUrlV11;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '';
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/posholds/rassassy-reports/';

      Map<String, dynamic> data = {
        "CompanyID": "1599a958-2f9b-4d92-9eb3-58738a805f2d",
        "BranchID": 1,
        "PriceRounding": 2,
        "ReportType": "SalesReport",
        "EmployeeID": 0,
        "FromDate": "2024-10-15",
        "ToDate": "2024-10-23",
        "FromTime": "11:38",
        "ToTime": "11:38",
        "CreatedUserID": 62,
        "filterVal ": "all"
      };

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode(data));

      pr("Sales Report Response:  ${response.body}");
      final jsonData = jsonDecode(response.body);
      if (jsonData['StatusCode'] == 6000) {
        pr("data 6000");

        // salesReportList.value = (jsonData['data'])
        //     .map((item) => SalesreportModel.fromJson(item))
        //     .toList();
        salesReportList.assignAll((jsonData['data'])
            .map((json) => SalesreportModel.fromJson(json))
            .toList());

        pr("data aa");
        pr(salesReportList);
        return salesReportList;
      } else if (jsonData['StatusCode'] == 6001) {
        final msg = jsonData["message"];
        Get.snackbar('Error', msg);
        pr('failed');
        return null;
      }
    
    } catch (e) {
      // Handle exceptions
    } finally {
      isLoading(false);
    }
    return null;
  }
}
