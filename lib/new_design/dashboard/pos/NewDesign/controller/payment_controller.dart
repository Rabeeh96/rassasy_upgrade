import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class POSPaymentController extends GetxController{
  String currency = "SR";

  RxInt ledgerID = 1.obs;
  RxString totalNetP = "0.0".obs;
  RxString totalTaxMP = "0.0".obs;
  RxString grandTotalAmount = "0.0".obs;
  RxString totalDiscount = "0.0".obs;
  RxString roundOff = "0.0".obs;
  RxDouble totalGrossP = 0.0.obs;
  RxDouble vatAmountTotalP = 0.0.obs;
  RxDouble cGstAmountTotalP = 0.0.obs;
  RxDouble billDiscPercent = 0.0.obs;
  RxDouble sGstAmountTotalP = 0.0.obs;
  RxDouble iGstAmountTotalP = 0.0.obs;
  RxDouble exciseAmountTotalP = 0.0.obs;
  RxDouble disCount = 0.0.obs;
  RxDouble cashReceived = 0.0.obs;
  RxDouble bankReceived = 0.0.obs;
  RxDouble balance = 0.0.obs;


  RxString dateOnly = "".obs;
  RxInt deliveryManID = 0.obs;
  RxString tokenNumber = "".obs;
  RxString taxType = "".obs;
  TextEditingController cashReceivedController = TextEditingController();
  TextEditingController paymentCustomerSelection = TextEditingController()..text = "walk in customer";
  TextEditingController customerPhoneSelection = TextEditingController();
  TextEditingController bankReceivedController = TextEditingController();
  TextEditingController discountPerController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();


  Future<Null> getOrderDetails({required String uID}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        print("_________________________________________________________________its called");

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        final String url = '$baseUrl/posholds/view-pos/salesOrder/$uID/';
        print(url);
        Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
        print(data);
        print(accessToken);
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var message = n["message"] ?? "";
        var responseJson = n["data"];

        if (status == 6000) {

          cashReceivedController.text = "0.00";
          bankReceivedController.text = "0.00";
          discountPerController.text = "0.00";
          discountAmountController.text = "0.00";




          grandTotalAmount.value = responseJson["GrandTotal"].toString();
          totalTaxMP.value = responseJson["TotalTax"].toString();
          vatAmountTotalP.value = double.parse(responseJson["VATAmount"].toString());
          exciseAmountTotalP.value = double.parse(responseJson["ExciseTaxAmount"].toString());
          totalNetP.value = (responseJson["NetTotal"].toString());
          ledgerID.value = responseJson["LedgerID"];
          paymentCustomerSelection.text = responseJson["CustomerName"]??"";
          customerPhoneSelection.text = responseJson["CustomerName"]??"";

          cashReceived.value = 0.0;
          bankReceived.value = 0.0;
          balance.value = 0.0;
          totalDiscount.value = "0.0";
          roundOff.value = "0.0";
          update();
          calculationOnPayment();

          //   getLoyaltyCustomer();
        } else if (status == 6001) {
          popAlert(head: "Waring", message: message ?? "", position: SnackPosition.TOP);
        }

        //DB Error
        else {
          popAlert(head: "Error", message: "Some Network Error please try again Later", position: SnackPosition.TOP);
        }
      } catch (e) {
        print("-------${e.toString()}");
        popAlert(head: "Error", message: e.toString(), position: SnackPosition.TOP);
      }
    }
  }

  calculationOnPayment() {
    var net = double.parse(totalNetP.value.toString());

    if (discountAmountController.text == "") {

      disCount.value = 0.0;
    } else {

      disCount.value = double.parse(discountAmountController.text);
    }
    print(disCount);
    if (cashReceivedController.text == "") {
      cashReceived.value = 0.0;
    } else {
      cashReceived.value = double.parse(cashReceivedController.text);
    }

    if (bankReceivedController.text == "") {
      bankReceived.value = 0.0;
    } else {
      bankReceived.value = double.parse(bankReceivedController.text);
    }

      var gt = (net - disCount.value).toString();
      grandTotalAmount.value = roundStringWith(gt).toString();
      billDiscPercent.value = (disCount * 100 / double.parse(grandTotalAmount.value));
      balance.value = (net - disCount.value) - (cashReceived.value + bankReceived.value);
      update();
      //  balanceCalculation();

  }

  Future<Null> createSaleInvoice({required bool printSave,required BuildContext context,required String tableID,required String uUID,required int orderType}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? "0";

        var branchID = prefs.getInt('branchID') ?? 1;
        var countryID = prefs.getString('Country') ?? "1";
        var stateID = prefs.getString('State') ?? "1";
        var tableVacant = prefs.getBool("tableClearAfterPayment") ?? false;
        var employeeID = prefs.getInt('employee_ID') ?? 1;

        DateTime selectedDateAndTime = DateTime.now();
        String convertedDate = "$selectedDateAndTime";
        dateOnly.value = convertedDate.substring(0, 10);

        // var loyalty;
        // if (loyaltyCustomerID == 0) {
        //   loyalty = null;
        // } else {
        //   loyalty = loyaltyCustomerID;
        // }

        var autoC = true;

        var cardNumber = "";

        final String url = '$baseUrl/posholds/create-pos/salesInvoice/';
        print(url);
        Map data = {
          "EmployeeID": employeeID,
          'LoyaltyCustomerID': null,
          "table_vacant": tableVacant,
          "Paid": autoC,
          "CompanyID": companyID,
          "Table":tableID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "LedgerID": ledgerID.value,
          "GrandTotal": grandTotalAmount.value,
          "BillDiscPercent": "$billDiscPercent",
          "BidillDiscAmt": "$disCount",
          "CashReceived": "${cashReceived.value}",
          "BankAmount": "${bankReceived.value}",
          "CardTypeID": 0,
          "CardNumber": "",
          "SalesOrderID": uUID,
          "TotalDiscount": "${disCount.value}",
          "Date": dateOnly.value,
          "RoundOff": "0.0",
          "Balance": "${balance.value}",
          "TotalTax":totalTaxMP.value,
          "DeliveryManID": deliveryManID.value,
          "AllowCashReceiptMoreSaleAmt": false,
        };
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        print(responseJson);
        if (status == 6000) {
          stop();
          dialogBoxHide(context, "Sales created successfully!!!");
          Navigator.pop(context, [orderType, false]);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (printSave == true) {
              // PrintDataDetails.type = "SI";
              // PrintDataDetails.id = n["invoice_id"];
              // printDetail(context);
            }
          });
        } else if (status == 6001) {
          stop();
          var errorMessage = n["message"]??"";
          dialogBox(context, errorMessage);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        dialogBox(context, "Some Network Error");
        stop();
      }
    }
  }

  checkNan(value) {
    var val = value;
    if (value.isNaN) {
      return 0.0;
    } else {
      var val2 = val;
      return val2;
    }
  }

}
