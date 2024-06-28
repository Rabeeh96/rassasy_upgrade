import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'package:rassasy_new/new_design/dashboard/mobile_section/model/invoice_model_mobile.dart';

class InvoiceController extends GetxController {
  var messageShow = "".obs;
  var invoiceList = <InvoiceModelMobileClass>[].obs;
  var isLoading=false.obs;
  DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
   String currency="SR";

  late  ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  late  ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());
  Future<void> viewList({required String fromDate, required String toDate}) async {
    try {
      print("here");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isLoading.value=true;
      String baseUrl = BaseUrl.baseUrl;
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
     currency=prefs.getString("CurrencySymbol")!;

      final String url = '$baseUrl/posholds/list-pos-hold-invoices/';

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "page_number": 1,
        "page_size": 40,
        "from_date": fromDate,
        "to_date": toDate,
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
      print("url  $url");
      print("data  $data");
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];
      var responseJson = jsonResponse["data"];
      print("here6465464");
      if (status == 6000) {
        print("here tyrytrty");
        isLoading.value=false;
        messageShow("");
        invoiceList.clear();
        print("here dddddd");
        List<dynamic> list = responseJson as List;
        invoiceList.assignAll(list.map((e) => InvoiceModelMobileClass.fromJson(e)));
        print("here dsfrsdfdsf");
        if (invoiceList.isEmpty) {
          messageShow("No sale during these period");
        }
        print("here dsfrsdfdsf");
      } else if (status == 6001) {
        isLoading.value=false;
        print("here exit");
        messageShow("No sale during these period");
      } else {
        isLoading.value=false;
      }
    } catch (e) {
      isLoading.value=false;
      print("Error ${e.toString()}");
    }
  }


  var printHelperUsb =   USBPrintClass();
  var printHelperIP =   AppBlocs();
  var bluetoothHelper =   AppBlocsBT();
  printDetail({required String type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    if (defaultIp == "") {
      dialogBox(Get.context!, "Please select a printer");
    } else {
      if(printType =='Wifi'){
        var ret = await printHelperIP.printDetails();
        if (ret == 2) {
          var ip = "";
          if (type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }
          printHelperIP.print_receipt(ip, Get.context!,false);
        } else {
          dialogBox(Get.context!, 'Please try again later');
        }
        //
      }
      else{
        var ret = await printHelperUsb.printDetails();
        if (ret == 2) {
          var ip = "";

          if (type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }
          printHelperUsb.printReceipt(ip, Get.context!);
        } else {
          dialogBox(Get.context!, 'Please try again later');
        }

        /// commented
        // var loadData = await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
        // if(loadData){
        //   var printStatus =await bluetoothHelper.scan();
        //   if(printStatus ==1){
        //     dialogBox(context,"Check your bluetooth connection");
        //   }
        //   else if(printStatus ==2){
        //     dialogBox(context,"Your default printer configuration problem");
        //   }
        //   else if(printStatus ==3){
        //
        //     await bluetoothHelper.scan();
        //     // alertMessage("Try again");
        //   }
        //   else if(printStatus ==4){
        //     //  alertMessage("Printed successfully");
        //   }
        // }
        // else{
        //   dialogBox(context,"Try again");
        // }
        //
      }

    }




  }
}
