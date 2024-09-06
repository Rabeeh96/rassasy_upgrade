import 'dart:convert';
import 'dart:convert';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../back_ground_print/USB/printClass.dart';
import '../../back_ground_print/USB/test_page/test_file.dart';
import '../../back_ground_print/bluetooth/back_ground_print_bt.dart';
import '../../back_ground_print/bluetooth/new.dart';
import '../../back_ground_print/wifi_print/back_ground_print_wifi.dart';
import '../../back_ground_print/wifi_print/customisation_template/customisation_template.dart';

class InvoiceControllerA extends GetxController{
  var type = "".obs;
  var customerName = "".obs;
  var voucherNo = "".obs;
  var net_total = "".obs;
  var dateText = "".obs;
  var cashAmountReceived = "".obs;
  var bankAmountReceived = "".obs;
  var total_tax = "0.0".obs;
  var discount_amount = "0.0".obs;
  var gross_amount = "0.0".obs;
  var grand_total = "0.0".obs;
  var itemTableList = [].obs;
  var salesMasterID=0;
  var salesDetailIds = <int>[];
  var isSelectInvoice=false.obs;
  void selectAll() {
    selectedItems.assignAll(
      Map.fromIterable(
        itemTableList.asMap().entries,
        key: (e) => e.key,
        value: (e) => true, // Set all to true
      ),
    );
  }
  // Method to deselect all items
  void deselectAll() {
    selectedItems.clear();
  }
  List getSelectedItems() {
    return itemTableList.where((item) => selectedItems[itemTableList.indexOf(item)] == true).toList();
  }

  // Observable map to keep track of selected items
  var selectedItems = <int, bool>{}.obs;

  // Method to toggle selection of an item
  void toggleSelection(int index, bool isSelected) {
    selectedItems[index] = isSelected;
    update();
  }
  var isLoading = false.obs;
  var errorMessage = "".obs;

  String currency = " SR";


 var place_of_supply = "".obs;
  // var whatsUppNumber = "";
  // var warehouseName = "";
  // var reference_bill_number = "";
  // var reference_bill_date = "";
  // var notesVisibility = false;
  // var statusShow = false;
  Future<void> getSingleSalesDetails(String masterUID) async {

    print("master id ${masterUID}");
    bool network = await checkNetwork();
    if (!network) {
      // Handle network error
      errorMessage.value = "No network connection";
      return;
    }

    isLoading.value = true;

    try {
      // Retrieve SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int userID = prefs.getInt('user_id') ?? 0;
      int branchID = prefs.getInt('branchID') ?? 1;
      String accessToken = prefs.getString('access') ?? '';
      String companyID = prefs.getString('companyID') ?? '';
      String baseUrl = BaseUrl.baseUrlV11;
      String url = '$baseUrl/sales/view/salesMaster/$masterUID/';
      print("url $url");
      // Prepare the request data
      Map<String, dynamic> data = {
        "BranchID": branchID,
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "PriceRounding": 2,
      };
      print("data $data");

      var body = json.encode(data);
      print("bbody ");
      // Send the request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      pr("response ${response.body}  ");
      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var message = n["message"];
      var responseJson = n["data"];
      var salesData = responseJson["MasterData"];
      var ledgerData = responseJson["LedgerData"];
      var placeData = responseJson["PlaceData"];


      if (status == 6000) {
        print("1");
        type.value = "sales_invoice";
        customerName.value = ledgerData["LedgerName"];
        place_of_supply.value=placeData['Place_of_Supply']??'';

        print("2");

        voucherNo.value = responseJson["VoucherNo"];
        print("3");

        net_total.value = responseJson['Balance'].toString();
        print("4");

        String dt = responseJson["Date"].toString();
        DateTime selectedDateAndTime = DateTime.parse(dt);
        final DateFormat formatter = DateFormat('dd-MM-yyyy');
        dateText.value = formatter.format(selectedDateAndTime);
        print("5");

        cashAmountReceived.value = roundStringWith(salesData["CashReceived"].toString());
        print("6");

        bankAmountReceived.value = roundStringWith(salesData["BankAmount"].toString());
        print("7");

        total_tax.value = roundStringWith(salesData['TotalTax'].toString());
        print("8");

        discount_amount.value = roundStringWith(salesData['DiscountAmount']?.toString() ?? '0');
        grand_total.value = roundStringWith(salesData["GrandTotal"]?.toString() ?? '0');
         // discount_amount.value = roundStringWith(salesData['DiscountAmount']);
        // grand_total.value = roundStringWith(salesData["GrandTotal"]);
        gross_amount.value = roundStringWith(salesData['TotalGrossAmt']?.toString() ?? '0');
        salesMasterID=responseJson['SalesMasterID'];
        itemTableList.assignAll(responseJson["SalesDetails"]);
       // salesDetailsID=itemTableList['SalesDetailsID']
        print("12");

      } else {
        errorMessage.value = message;
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
    } finally {
      isLoading.value = false;
    }
  }


  checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
  var printHelperNew = USBPrintClassTest();
  var printHelperUsb = USBPrintClass();
  var printHelperIP = AppBlocs();
  var bluetoothHelper = AppBlocsBT();
  var wifiNewMethod = WifiPrintClassTest();

  printDetail(id, voucherType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    var temp = prefs.getString("template") ?? "template4";
    if (defaultIp == "") {
      popAlert(
          head: "Error",
          message: "Please select a printer",
          position: SnackPosition.TOP);
    } else {
      if (printType == 'Wifi') {
        if (temp == "template5") {
          var ip = "";
          if (PrintDataDetails.type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }

          print("temp  $temp");
          wifiNewMethod.printDetails(
              id: id,
              type: voucherType,
              context: Get.context!,
              ipAddress: ip,
              isCancelled: false,
              orderSection: false);
        } else {
          var ret = await printHelperIP.printDetails();
          if (ret == 2) {
            var ip = "";
            if (PrintDataDetails.type == "SO") {
              ip = defaultOrderIP;
            } else {
              ip = defaultIp;
            }
            printHelperIP.print_receipt(ip, Get.context!, false, false);
          } else {
            popAlert(
                head: "Error",
                message: "Please try again later",
                position: SnackPosition.TOP);
          }
        }
      }
      else if (printType == 'USB') {
        if (temp == "template5") {
          print(
              "Date ---------step 1   ---------   ---------     ${DateTime.now().second} ");
          printHelperNew.printDetails(
              id: id, type: voucherType, context: Get.context!);
        } else {
          var ret = await printHelperUsb.printDetails();
          if (ret == 2) {
            var ip = "";
            if (PrintDataDetails.type == "SO") {
              ip = defaultOrderIP;
            } else {
              ip = defaultIp;
            }
            printHelperUsb.printReceipt(ip, Get.context!);
          } else {
            popAlert(
                head: "Error",
                message: "Please try again later",
                position: SnackPosition.TOP);
          }
        }

        /// commented
      }
      else {
        var loadData =
        await bluetoothHelper.bluetoothPrintOrderAndInvoice(Get.context!);
        // handlePrint(context);

        if (loadData) {
          var printStatus = await bluetoothHelper.scan(false);
          if (printStatus == 1) {
            dialogBox(Get.context!, "Check your bluetooth connection");
          } else if (printStatus == 2) {
            dialogBox(Get.context!, "Your default printer configuration problem");
          } else if (printStatus == 3) {
            await bluetoothHelper.scan(false);
            // alertMessage("Try again");
          } else if (printStatus == 4) {
            //  alertMessage("Printed successfully");
          }
        } else {
          dialogBox(Get.context!, "Try again");
        }
      }
    }
  }

  Future<void> handlePrint(BuildContext context) async {
    var bluetoothHelper = BluetoothHelperNew();
    var printStatus = await bluetoothHelper.scan();

    switch (printStatus) {
      case 1:
        dialogBox(context, "Check your bluetooth connection");
        break;
      case 2:
        dialogBox(context, "Your default printer configuration problem");
        break;
      case 3:
        await bluetoothHelper.scan();
        // alertMessage("Try again");
        break;
      case 4:
      // alertMessage("Printed successfully");
        break;
    }
  }


  // Method to make the API call with an authentication token
  void createSalesReturn() async {
     String apiUrl = '${BaseUrl.baseUrlV11}/salesReturns/sales-return-rassasy/';
     SharedPreferences prefs = await SharedPreferences.getInstance();
     int userID = prefs.getInt('user_id') ?? 0;
     int branchID = prefs.getInt('branchID') ?? 1;
     String accessToken = prefs.getString('access') ?? '';
     String companyID = prefs.getString('companyID') ?? '';
    final payload = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "CreatedUserID": userID,
      "SalesMasterID": salesMasterID,
      "SalesDetailID": salesDetailIds
    };

    try {
      // Make the HTTP POST request with the token in headers
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to headers
        },
        body: jsonEncode(payload),
      );

      // Check for successful response
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['StatusCode'] == 6000) {
          print('Success: ${responseBody['message']}');
          Get.back();
        } else {
          print('Error: ${responseBody['message']}');
        }
      } else {
        print('Failed to connect to the API');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
}