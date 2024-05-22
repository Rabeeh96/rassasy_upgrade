import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:pos_printer_manager/pos_printer_manager.dart';

import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppBlocsBT {
  // List<BluetoothPrinter> _printers = [];
  // late BluetoothPrinterManager _manager;

  scan() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _printers = [];
    // _printers = await BluetoothPrinterManager.discover();
    // var paperSize = PaperSize.mm80;
    // var defaultIp = prefs.getString('defaultIP') ?? '';
    // var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    // var ip = "";
    // if (PrintDataDetails.type == "SO") {
    //   ip = defaultOrderIP;
    // } else {
    //   ip = defaultIp;
    // }
    //
    // if (_printers.length == 0) {
    //   print("Switch on bluetooth");
    //   return 1;
    //
    //   /// exit when no item connected
    // } else {
    //   bool connected = false;
    //   int index = 0;
    //
    //   for (var i = 0; i < _printers.length; i++) {
    //     if (_printers[i].address == ip) {
    //       index = i;
    //       connected = true;
    //       break;
    //     }
    //   }
    //   if (connected == true) {
    //     if (_printers[index].connected == true) {
    //     } else {
    //       var paperSize = PaperSize.mm80;
    //       var profile_mobile = await CapabilityProfile.load();
    //
    //       var manager =
    //           BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
    //       await manager.connect();
    //       _printers[index].connected = true;
    //       _manager = manager;
    //     }
    //
    //     if (_manager != null) {
    //       print("isConnected ${_manager.isConnected}");
    //       if (_manager.isConnected == false) {
    //         var profile_mobile = await CapabilityProfile.load();
    //         var manager =
    //             BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
    //         await manager.disconnect();
    //         return 3;
    //       } else {
    //         var paperSize = PaperSize.mm80;
    //
    //         var content;
    //
    //         content = await ArabicThermalPrint.invoiceDesign();
    //         var bytes =
    //             await WebcontentConverter.contentToImage(content: content);
    //         var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date)
    //             .toIso8601String();
    //         var qrCode = await b64Qrcode(
    //             BluetoothPrintThermalDetails.companyName,
    //             BluetoothPrintThermalDetails.vatNumberCompany,
    //             isoDate,
    //             BluetoothPrintThermalDetails.grandTotal,
    //             BluetoothPrintThermalDetails.totalTax);
    //
    //         var service;
    //
    //         if (PrintDataDetails.type == "SO") {
    //           BluetoothPrintThermalDetails.qrCodeImageBool = false;
    //           service = ESCPrinterServices(bytes, "", false, prefs);
    //         } else {
    //           service = ESCPrinterServices(bytes, qrCode, true, prefs);
    //         }
    //
    //         var data = await service.getBytes(paperSize: paperSize);
    //         if (_manager != null) {
    //           print("isConnected ${_manager.isConnected}");
    //           _manager.writeBytes(data, isDisconnect: false);
    //           return 4;
    //         }
    //       }
    //     }
    //   } else {
    //     print('default printer is not pared with your device');
    //     return 2;
    //   }
    //   print('--print---$connected');
    // }
  }

  bluetoothPrintOrderAndInvoice(BuildContext context) async {
    List<ProductDetailsModelOld> printDalesDetails = [];
    String baseUrl = BaseUrl.baseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    var pk = PrintDataDetails.id;
    final String url = '$baseUrl/posholds/view/pos-sale/invoice/$pk/';
    print(url);
    Map data = {
      "CompanyID": companyID,
      "BranchID": branchID,
      "CreatedUserID": userID,
      "PriceRounding": 2,
      "Type": PrintDataDetails.type
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

    Map n = json.decode(utf8.decode(response.bodyBytes));

    var status = n["StatusCode"];
    var responseJson = n["data"];

    if (status == 6000) {
      printDalesDetails.clear();
      BluetoothPrintThermalDetails.voucherNumber =
          responseJson["VoucherNo"].toString();
      BluetoothPrintThermalDetails.customerName =
          responseJson["CustomerName"] ?? 'Cash In Hand';
      BluetoothPrintThermalDetails.date = responseJson["Date"];
      BluetoothPrintThermalDetails.netTotal =
          responseJson["NetTotal_print"].toString();
      BluetoothPrintThermalDetails.customerPhone =
          responseJson["OrderPhone"] ?? "";
      BluetoothPrintThermalDetails.grossAmount =
          responseJson["GrossAmt_print"].toString();
      BluetoothPrintThermalDetails.sGstAmount =
          responseJson["SGSTAmount"].toString();
      BluetoothPrintThermalDetails.cGstAmount =
          responseJson["CGSTAmount"].toString();
      BluetoothPrintThermalDetails.tokenNumber =
          responseJson["TokenNumber"].toString();
      BluetoothPrintThermalDetails.discount =
          responseJson["TotalDiscount_print"].toString();
      BluetoothPrintThermalDetails.totalTax =
          responseJson["TotalTax_print"].toString();
      BluetoothPrintThermalDetails.grandTotal =
          responseJson["GrandTotal_print"].toString();
      BluetoothPrintThermalDetails.qrCodeImage = responseJson["qr_image"];

      BluetoothPrintThermalDetails.customerTaxNumber =
          responseJson["TaxNo"].toString();
      BluetoothPrintThermalDetails.ledgerName =
          responseJson["LedgerName"] ?? '';
      BluetoothPrintThermalDetails.customerAddress = responseJson["Address1"];
      BluetoothPrintThermalDetails.customerAddress2 = responseJson["Address2"];
      BluetoothPrintThermalDetails.customerCrNumber =
          responseJson["CustomerCRNo"] ?? "";

      var companyDetails = responseJson["CompanyDetails"];

      BluetoothPrintThermalDetails.salesDetails = responseJson["SalesDetails"];
      BluetoothPrintThermalDetails.companyName =
          companyDetails["CompanyName"] ?? '';
      BluetoothPrintThermalDetails.buildingNumberCompany =
          companyDetails["Address1"] ?? '';
      BluetoothPrintThermalDetails.state = companyDetails["StateName"] ?? '';
      BluetoothPrintThermalDetails.postalCodeCompany =
          companyDetails["PostalCode"] ?? '';
      BluetoothPrintThermalDetails.phoneCompany = companyDetails["Phone"] ?? '';
      BluetoothPrintThermalDetails.mobileCompany =
          companyDetails["Mobile"] ?? '';
      BluetoothPrintThermalDetails.vatNumberCompany =
          companyDetails["VATNumber"] ?? '';
      BluetoothPrintThermalDetails.companyGstNumber =
          companyDetails["GSTNumber"] ?? '';
      BluetoothPrintThermalDetails.cRNumberCompany =
          companyDetails["CRNumber"] ?? '';
      BluetoothPrintThermalDetails.countryNameCompany =
          companyDetails["CountryName"] ?? '';
      BluetoothPrintThermalDetails.stateNameCompany =
          companyDetails["StateName"] ?? '';
      BluetoothPrintThermalDetails.companyLogoCompany =
          companyDetails["CompanyLogo"] ?? '';
      BluetoothPrintThermalDetails.countyCodeCompany =
          companyDetails["CountryCode"] ?? '';

      if (BluetoothPrintThermalDetails.customerName == "") {
        BluetoothPrintThermalDetails.customerName =
            BluetoothPrintThermalDetails.ledgerName;
      }

      return true;
    } else if (status == 6001) {
      return false;
    }

    //DB Error
    else {
      return false;
      // _scaffoldKey.currentState.showSnackBar(SnackBar(
      //   content: Text('Some Network Error please try again Later'),
      //   duration: Duration(seconds: 1),
      // ));
    }

//  }
  }

  scanPrinter() async {
    // List<BluetoothPrinter> printerList = [];
    // printerList = await BluetoothPrinterManager.discover();
    // print("scan");
    // return printerList;
  }

  kot(ip, index, printData) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var printDevice;
    // var paperSize = PaperSize.mm80;
    // print("__________________________________________8");
    // List<BluetoothPrinter> printerList = await scanPrinter();
    // print('length ${printerList.length}');
    //
    // printerList.forEach((a) {
    //   if (a.id!.toLowerCase().contains(ip.toLowerCase())) printDevice = a;
    // });
    //
    // var profile_mobile = await CapabilityProfile.load();
    // var manager = BluetoothPrinterManager(printDevice, paperSize, profile_mobile);
    // await manager.connect();
    //
    // print(printListData[index].items);
    // List<ItemsDetails> dataPrint = [];
    // dataPrint.clear();
    //
    // print('---index   $index');
    // final content = ThermalEnglishDesignKot.getInvoiceContent(index, printData);
    // var bytes = await WebcontentConverter.contentToImage(content: content);
    // var service = ESCPrinterServices(bytes, "qrCode", false, prefs);
    //
    // var data = await service.getBytes(paperSize: paperSize);
    // if (manager != null) {
    //   print("isConnected ${manager.isConnected}");
    //   manager.writeBytes(data, isDisconnect: false);
    // }
  }

  bluetoothPrintKOT(BuildContext context, kitchenPrint, orderID) async {


    // print("__________________________________________1");
    // _printers = [];
    // _printers = await BluetoothPrinterManager.discover();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    String baseUrl = BaseUrl.baseUrl;
    print("__________________________________________2");

    final String url = '$baseUrl/posholds/kitchen-print/';
    print(url);
    print(accessToken);
    Map data = {
      "OrderID": orderID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "BranchID": branchID,
      "is_test": false,
      "KitchenPrint": kitchenPrint,
    };
    print("__________________________________________3");

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
    print("__________________________________________4");
    var status = n["StatusCode"];
    var responseJson = n["final_data"];

    if (status == 6000) {
      dialogBox(context, "Please wait");
      print("__________________________________________5");

      dataPrint.clear();
      printListData.clear();
      for (Map user in responseJson) {
        printListData.add(PrintDetails.fromJson(user));
      }
      print("__________________________________________6");
      for (var i = 0; i < printListData.length; i++) {
        try {
          print("__________________________________________7");
          dataPrint.clear();
          await kot(printListData[i].ip, i, printListData[i].items);
        } catch (e) {
          print(e.toString());
        }
      }
    } else if (status == 6001) {
      return false;
    }

    //DB Error
    else {
      return false;
    }

//  }
  }
}

List<PrintDetails> printListData = [];
List<ItemsDetails> dataPrint = [];

class ItemsDetails {
  var productName,
      productDescription,
      qty,
      tableName,
      orderTypeI,
      tokenNumber,
      voucherNo;

  ItemsDetails(
      {this.productName,
      this.productDescription,
      this.qty,
      this.tableName,
      this.orderTypeI,
      this.tokenNumber,
      this.voucherNo});

  factory ItemsDetails.fromJson(Map<dynamic, dynamic> json) {
    return new ItemsDetails(
      productName: json['ProductName'],
      productDescription: json['ProductDescription'],
      qty: json['Qty'].toString(),
      tableName: json['TableName'],
      orderTypeI: json['OrderType'],
      tokenNumber: json['TokenNumber'],
      voucherNo: json['VoucherNo'],
    );
  }
}

class PrintDetails {
  var items, kitchenName, ip, totalQty;

  PrintDetails({
    this.kitchenName,
    this.items,
    this.ip,
    this.totalQty,
  });

  factory PrintDetails.fromJson(Map<dynamic, dynamic> json) {
    return new PrintDetails(
      items: json['Items'],
      kitchenName: json['kitchen_name'],
      ip: json['IPAddress'],
      totalQty: json['TotalQty'].toString(),
    );
  }
}
