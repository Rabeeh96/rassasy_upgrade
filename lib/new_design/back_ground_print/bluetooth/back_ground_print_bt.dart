import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/Print/qr_generator.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/models/bluetooth_printer.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/pos_printer_manager.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/services/bluetooth_printer_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Img;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'dart:convert';
import 'dart:ui';
import 'package:image/image.dart' as Img;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class AppBlocsBT {
  List<BluetoothPrinter> _printers = [];
  late BluetoothPrinterManager _manager;




///old
  scan(isCancelled) async {
    print("-------scan----------scan------------------------scan---------------------${DateTime.now().second}--");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _printers = [];
    _printers = await BluetoothPrinterManager.discover();
    var paperSize = PaperSize.mm80;
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    var capabilities = prefs.getString("default_capabilities") ?? "default";

    print("asd-------- 1");
    var profile;
    if (capabilities == "default") {
      print("asd-------- 1");
      profile = await CapabilityProfile.load();
    } else {
      print("asd-------- 1");
      profile = await CapabilityProfile.load(name: capabilities);
    }
    var ip = "";
    if (PrintDataDetails.type == "SO") {
      ip = defaultOrderIP;
    } else {
      ip = defaultIp;
    }
    print("asd-------- 11");
    if (_printers.isEmpty) {
      return 1;
      /// exit when no item connected
    }
    else {
      print("asd-------- 111");
      bool connected = false;
      int index = 0;

      for (var i = 0; i < _printers.length; i++) {
        print("asd-------- 1111");
        if (_printers[i].address == ip) {
          index = i;
          connected = true;
          break;
        }
      }
      print("asd-------- 11111");
      if (connected == true) {
        if (_printers[index].connected == true) {

        }
        else {
          print("asd-------- 111112");
          var paperSize = PaperSize.mm80;
          print("-------- 1---------------");
          var profile_mobile = await CapabilityProfile.load();
          print("asd-------- 120---------------");
          var manager = BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
          print("asd-------- 1236---------------");
          await manager.connect();
          print("asd-------- 12367---------------");
          _printers[index].connected = true;
          print("asd-------- 123678---------------");

          print("asd-------- 1236789---------------");
          _manager = manager;
          _manager.isConnected = true;
          print("asd-------- 12367899---------------");
        }
        print("asd-------- 1111122");
        if (_manager != null) {
          print("asd-------- 111112223");
          print("isConnected ${_manager.isConnected}");
          if (_manager.isConnected == false) {
            var manager = BluetoothPrinterManager(_printers[index], paperSize, profile);
            await manager.disconnect();
            return 3;
          }
          else {
            print("asd-------- 1111123");
            var paperSize = PaperSize.mm80;
            var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
            var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
                BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
            var service = ESCPrinterServicesArabic(qrCode, prefs, PaperSize.mm80,isCancelled);
            var data = await service.getBytes(paperSize: paperSize, profile: profile);
            if (_manager != null) {
              print("isConnected ${_manager.isConnected}");
              _manager.writeBytes(data, isDisconnect: false);
              return 4;
            }
          }
        }
      } else {
        print('default printer is not pared with your device');
        return 2;
      }
      print('--print---$connected');
    }
  }

  bluetoothPrintOrderAndInvoice(BuildContext context) async {
    print("-------bluetoothPrintOrderAndInvoice----------bluetoothPrintOrderAndInvoice------------------------bluetoothPrintOrderAndInvoice---------------------${DateTime.now().second}--");
    List<ProductDetailsModelOld> printDalesDetails = [];
    String baseUrl = BaseUrl.baseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    var currency = prefs.getString('CurrencySymbol') ?? "";
    var pk = PrintDataDetails.id;
    final String url = '$baseUrl/posholds/view/pos-sale/invoice/$pk/';
    print(url);
    Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "PriceRounding": 2, "Type": PrintDataDetails.type};

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
      BluetoothPrintThermalDetails.voucherNumber = responseJson["VoucherNo"].toString();
      BluetoothPrintThermalDetails.customerName = responseJson["CustomerName"] ?? 'Cash In Hand';
      BluetoothPrintThermalDetails.date = responseJson["Date"];
      BluetoothPrintThermalDetails.netTotal = responseJson["NetTotal_print"].toString();
      BluetoothPrintThermalDetails.customerPhone = responseJson["OrderPhone"] ?? "";
      BluetoothPrintThermalDetails.grossAmount = responseJson["GrossAmt_print"].toString();
      BluetoothPrintThermalDetails.sGstAmount = responseJson["SGSTAmount"].toString();
      BluetoothPrintThermalDetails.cGstAmount = responseJson["CGSTAmount"].toString();
      BluetoothPrintThermalDetails.tokenNumber = responseJson["TokenNumber"].toString();
      BluetoothPrintThermalDetails.discount = responseJson["TotalDiscount_print"].toString();
      BluetoothPrintThermalDetails.grandTotal = responseJson["GrandTotal_print"].toString();
      BluetoothPrintThermalDetails.qrCodeImage = responseJson["qr_image"];

      BluetoothPrintThermalDetails.customerTaxNumber = responseJson["TaxNo"].toString();
      BluetoothPrintThermalDetails.ledgerName = responseJson["LedgerName"] ?? '';
      BluetoothPrintThermalDetails.customerAddress = responseJson["Address1"];
      BluetoothPrintThermalDetails.customerAddress2 = responseJson["Address2"];
      BluetoothPrintThermalDetails.customerCrNumber = responseJson["CustomerCRNo"] ?? "";
      BluetoothPrintThermalDetails.cashReceived = responseJson["CashReceived"].toString() ?? "0";
      BluetoothPrintThermalDetails.bankReceived = responseJson["BankAmount"].toString() ?? "50";
      BluetoothPrintThermalDetails.balance = responseJson["Balance"].toString() ?? "";
      BluetoothPrintThermalDetails.salesType = responseJson["OrderType"] ?? "";
      BluetoothPrintThermalDetails.salesDetails = responseJson["SalesDetails"];
      BluetoothPrintThermalDetails.totalVATAmount = responseJson["VATAmount"] ?? '0';
      BluetoothPrintThermalDetails.totalExciseAmount = responseJson["ExciseTaxAmount"] ?? "0";
      BluetoothPrintThermalDetails.totalTax = responseJson["TotalTax_print"].toString();
      var companyDetails = responseJson["CompanyDetails"];
      BluetoothPrintThermalDetails.companyName = companyDetails["CompanyName"] ?? '';
      BluetoothPrintThermalDetails.buildingNumber = companyDetails["Address1"] ?? '';
      BluetoothPrintThermalDetails.secondName = companyDetails["CompanyNameSec"] ?? '';
      BluetoothPrintThermalDetails.streetName = companyDetails["Street"] ?? '';
      BluetoothPrintThermalDetails.state = companyDetails["StateName"] ?? '';
      BluetoothPrintThermalDetails.postalCodeCompany = companyDetails["PostalCode"] ?? '';
      BluetoothPrintThermalDetails.phoneCompany = companyDetails["Phone"] ?? '';
      BluetoothPrintThermalDetails.mobileCompany = companyDetails["Mobile"] ?? '';
      BluetoothPrintThermalDetails.vatNumberCompany = companyDetails["VATNumber"] ?? '';
      BluetoothPrintThermalDetails.companyGstNumber = companyDetails["GSTNumber"] ?? '';
      BluetoothPrintThermalDetails.cRNumberCompany = companyDetails["CRNumber"] ?? '';
      BluetoothPrintThermalDetails.countryNameCompany = companyDetails["CountryName"] ?? '';
      BluetoothPrintThermalDetails.stateNameCompany = companyDetails["StateName"] ?? '';

      BluetoothPrintThermalDetails.companyLogoCompany = companyDetails["CompanyLogo"] ?? '';
      BluetoothPrintThermalDetails.countyCodeCompany = companyDetails["CountryCode"] ?? '';
      BluetoothPrintThermalDetails.buildingNumberCompany = companyDetails["Address1"] ?? '';

      BluetoothPrintThermalDetails.tableName = responseJson["TableName"] ?? "";
      BluetoothPrintThermalDetails.time = responseJson["CreatedDate"] ?? "${DateTime.now()}";

      BluetoothPrintThermalDetails.currency = currency;


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

  bluetoothPrintKOT(
      var id,
      rePrint,
      cancelOrder,
      isUpdate,
      isCancelled
      ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;

    String baseUrl = BaseUrl.baseUrl;
    final String url = '$baseUrl/posholds/kitchen-print/';

    Map data = {
      "OrderID": id,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "BranchID": branchID,
      "is_test": false,
      "KitchenPrint": rePrint,
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

    Map n = json.decode(utf8.decode(response.bodyBytes));
    var status = n["StatusCode"];
    var responseJson = n["final_data"];

    if (status == 6000) {
      dataPrint.clear();
      printListData.clear();
      for (Map user in responseJson) {
        printListData.add(PrintDetails.fromJson(user));
      }

      for (var i = 0; i < printListData.length; i++) {
        bool printSuccess = false;
        int retryCount = 0;
        const int maxRetries = 3;

        while (!printSuccess && retryCount < maxRetries) {
          try {
            dataPrint.clear();
            await connectToPrinter(
              printerAddress: printListData[i].ip,
              dataIndex: i,
              items: printListData[i].items,
              cancelNote: cancelOrder,
              isUpdate: isUpdate,
              isCancel: isCancelled,
            );

            printSuccess = true;
          } catch (e) {
            print('Error printing: ${e.toString()}');
            retryCount++;
            if (retryCount < maxRetries) {
              print('Retrying... ($retryCount/$maxRetries)');
              await Future.delayed(Duration(seconds: 1)); // Wait before retrying
            } else {
              print('Max retries reached. Skipping this print job.');
            }
          }
        }
      }
    } else {

    }
  }

  Future<void> bluetoothPrintKOTs(
      var id,
      rePrint,
      cancelOrder,
      isUpdate,
      isCancelled
      ) async {


    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      String baseUrl = BaseUrl.baseUrl;
      final String url = '$baseUrl/posholds/kitchen-print/';

      Map data = {
        "OrderID": id,
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "is_test": false,
        "KitchenPrint": rePrint,
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

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["final_data"];

      if (status == 6000) {
        dataPrint.clear();
        printListData.clear();
        for (Map user in responseJson) {
          printListData.add(PrintDetails.fromJson(user));
        }

        for (var i = 0; i < printListData.length; i++) {
          try {

            dataPrint.clear();
            await connectToPrinter(
                printerAddress: printListData[i].ip,
                dataIndex: i,
                items: printListData[i].items,
                cancelNote: cancelOrder,
                isUpdate: isUpdate,
                isCancel: isCancelled
            );
          } catch (e) {
            print(e.toString());
          }
        }
      } else {

      }
    }
    catch(e){
      print(e.toString());
    }

  }

  // Future<void> connectToPrinter({
  //   required String printerAddress,
  //   required int dataIndex,
  //   required List items,
  //   required List cancelNote,
  //   required bool isUpdate,
  //   required bool isCancel,
  // }) async {
  //
  //   try{
  //
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     _printers = [];
  //     _printers = await BluetoothPrinterManager.discover();
  //     var paperSize = PaperSize.mm80;
  //
  //
  //     var capabilities = prefs.getString("default_capabilities") ?? "default";
  //     var profile = (capabilities == "default")
  //         ? await CapabilityProfile.load()
  //         : await CapabilityProfile.load(name: capabilities);
  //     print("--------12");
  //     if (_printers.isEmpty) {
  //       return; // Exit when no printer is connected
  //     }
  //     print("--------2");
  //     for (var printer in _printers) {
  //       print("--------1");
  //       if (printer.address == printerAddress) {
  //         print("--------2");
  //         if (!printer.connected) {
  //           print("--------3");
  //           var manager = BluetoothPrinterManager(printer, paperSize, profile);
  //           await manager.connect();
  //           printer.connected = true;
  //           _manager = manager;
  //         }
  //         print("--------4");
  //         if (_manager.isConnected) {
  //           print("--------5");
  //           var service = ESCPrinterServicesArabicKOT(
  //               prefs, printerAddress, dataIndex, items, cancelNote, isUpdate, isCancel
  //           );
  //           var data = await service.getBytes(paperSize: paperSize, profile: profile);
  //             _manager.writeBytes(data, isDisconnect: true);
  //         } else {
  //           print("--------6");
  //           await _manager.disconnect();
  //         }
  //         break;
  //       }
  //     }
  //   }
  //   catch(e){
  //     print(e.toString());
  //   }
  //
  //
  // }
  //

  Future<void> connectToPrinter({
    required String printerAddress,
    required int dataIndex,
    required List items,
    required List cancelNote,
    required bool isUpdate,
    required bool isCancel,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _printers = [];
      _printers = await BluetoothPrinterManager.discover();
      var paperSize = PaperSize.mm80;

      var capabilities = prefs.getString("default_capabilities") ?? "default";
      var profile = (capabilities == "default")
          ? await CapabilityProfile.load()
          : await CapabilityProfile.load(name: capabilities);

      if (_printers.isEmpty) {
        print("No printers found");
        return; // Exit when no printer is connected
      }

      print("--------rab------------1");
      for (var printer in _printers) {
        print("---------rab-----------2");
        if (printer.address == printerAddress) {
          print("--------rab------------3");
          if (!printer.connected) {
            print("--------rab------------4");
            var manager = BluetoothPrinterManager(printer, paperSize, profile);
            await manager.connect();
            printer.connected = true;

            _manager = manager;
            print("-_manager.isConnected--${_manager.isConnected}-------");
            _manager.isConnected = true;
            print("-_manager.isConnected--${_manager.isConnected}-------");
          }

          print("--------rab------------5");
          if (_manager.isConnected) {
            print("--------rab------------6");
            var service = ESCPrinterServicesArabicKOT(
                prefs, printerAddress, dataIndex, items, cancelNote, isUpdate, isCancel);
            var data = await service.getBytes(paperSize: paperSize, profile: profile);
            _manager.writeBytes(data, isDisconnect: false);



          }
          else {
            print("--------rab------------7");
            await _manager.disconnect();
          }
          break;
        }
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      await _manager.disconnect(); // Ensure disconnection on error
    }
  }

  Future<void> disconnectPrinter() async {
    try {
      if (_manager != null && _manager.isConnected) {
        await _manager.disconnect();
        print("Printer disconnected successfully.");
      } else {
        print("Printer is not connected.");
      }
    } catch (e) {
      print("Error during disconnecting: ${e.toString()}");
    }
  }

/// print old
//   bluetoothPrintKOT(var id, rePrint, cancelOrder, isUpdate, isCancelled) async {
//     // print("__________________________________________1");
//     // _printers = [];
//     // _printers = await BluetoothPrinterManager.discover();
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var userID = prefs.getInt('user_id') ?? 0;
//     var accessToken = prefs.getString('access') ?? '';
//     var companyID = prefs.getString('companyID') ?? 0;
//     var branchID = prefs.getInt('branchID') ?? 1;
//
//     String baseUrl = BaseUrl.baseUrl;
//     print("__________________________________________2");
//
//     final String url = '$baseUrl/posholds/kitchen-print/';
//     print(url);
//     print(accessToken);
//     Map data = {
//       "OrderID": id,
//       "CompanyID": companyID,
//       "CreatedUserID": userID,
//       "BranchID": branchID,
//       "is_test": false,
//       "KitchenPrint": rePrint,
//     };
//     print("__________________________________________3");
//
//     print(data);
//     //encode Map to JSON
//     var body = json.encode(data);
//     var response = await http.post(Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: body);
//
//     print("${response.statusCode}");
//     print("${response.body}");
//     Map n = json.decode(utf8.decode(response.bodyBytes));
//     print("__________________________________________4");
//     var status = n["StatusCode"];
//     var responseJson = n["final_data"];
//
//     if (status == 6000) {
//
//
//
//       dataPrint.clear();
//       printListData.clear();
//       for (Map user in responseJson) {
//         printListData.add(PrintDetails.fromJson(user));
//       }
//       print("__________________________________________6");
//       for (var i = 0; i < printListData.length; i++) {
//         try {
//           print("__________________________________________7");
//           dataPrint.clear();
//           await connectToPrinter(printerAddress: printListData[i].ip, dataIndex: i, items: printListData[i].items, cancelNote: cancelOrder, isUpdate: isUpdate, isCancel: isCancelled);
//           // await kotPrint(printerAddress: printListData[i].ip, profile: profile, index: i, items: printListData[i].items, cancelNote: cancelOrder, isUpdate: isUpdate,isCancel: isCancelled);
//           // await kotPrint(printListData[i].ip, i, printListData[i].items,isUpdate,cancelOrder);
//         } catch (e) {
//           print(e.toString());
//         }
//       }
//     } else if (status == 6001) {
//       return false;
//     }
//
//     //DB Error
//     else {
//       return false;
//     }
//
// //  }
//   }
//   connectToPrinter({required printerAddress,required dataIndex,required items,required cancelNote,required isUpdate,required isCancel}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _printers = [];
//     _printers = await BluetoothPrinterManager.discover();
//     var paperSize = PaperSize.mm80;
//
//     var capabilities = prefs.getString("default_capabilities") ?? "default";
//
//     var profile;
//     if (capabilities == "default") {
//       profile = await CapabilityProfile.load();
//     } else {
//       profile = await CapabilityProfile.load(name: capabilities);
//     }
//     var ip =printerAddress;
//
//     print("ip  $ip  connected to printers");
//
//
//
//     if (_printers.length == 0) {
//
//      //return 1;
//
//       /// exit when no item connected
//     } else {
//       bool connected = false;
//       int index = 0;
//
//       for (var i = 0; i < _printers.length; i++) {
//         if (_printers[i].address == ip) {
//           index = i;
//           connected = true;
//           break;
//         }
//       }
//       if (connected == true) {
//         if (_printers[index].connected == true) {
//         } else {
//           var paperSize = PaperSize.mm80;
//           var profile_mobile = await CapabilityProfile.load();
//
//           var manager = BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
//           await manager.connect();
//           _printers[index].connected = true;
//           _manager = manager;
//         }
//
//         if (_manager != null) {
//           print("isConnected ${_manager.isConnected}");
//           if (_manager.isConnected == false) {
//             var manager = BluetoothPrinterManager(_printers[index], paperSize, profile);
//             await manager.disconnect();
//           ///  return 3;
//           } else {
//             var paperSize = PaperSize.mm80;
//
//             print("--------------------------12--------------------------12");
//             var service = ESCPrinterServicesArabicKOT(prefs, printerAddress, dataIndex, items, cancelNote, isUpdate, isCancel);
//             print("--------------------------123--------------------------1233");
//             var data = await service.getBytes(paperSize: paperSize, profile: profile);
//             if (_manager != null) {
//               print("isConnected ${_manager.isConnected}");
//               _manager.writeBytes(data, isDisconnect: false);
//           ///    return 4;
//             }
//           }
//         }
//       } else {
//         print('default printer is not pared with your device');
//      //   return 2;
//       }
//       print('--print---$connected');
//     }
//   }
//

  ///

  // Future<void> kotPrint({required printerAddress,required profile,required index,required items,required cancelNote,required isUpdate,required isCancel}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   var userName = prefs.getString('user_name')??"";
  //   bool showUsernameKot = prefs.getBool('show_username_kot')??false;
  //   bool showDateTimeKot = prefs.getBool('show_date_time_kot')??false;
  //   var defaultCodePage = prefs.getString("default_code_page") ?? "CP864";
  //   var currentTime = DateTime.now();
  //   List<int> bytes = [];
  //
  //   final generator = Generator(PaperSize.mm80, profile);
  //   List<ItemsDetails> dataPrint = [];
  //   dataPrint.clear();
  //
  //   for (Map user in items) {
  //     dataPrint.add(ItemsDetails.fromJson(user));
  //   }
  //
  //   var kitchenName ="";
  //   var totalQty = dataPrint[0].qty;
  //   if(printListData.isNotEmpty){
  //     kitchenName = printListData[index].kitchenName??"";
  //     totalQty = printListData[index].totalQty;
  //   }
  //
  //
  //   var tableName = dataPrint[0].tableName;
  //   var tokenNumber = dataPrint[0].tokenNumber;
  //   var orderType = dataPrint[0].orderTypeI ?? "";
  //
  //   bytes +=generator.setStyles(const PosStyles.defaults());
  //   bytes +=generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));
  //
  //   var cancelNoteArabic = "تم إلغاء هذا العنصر من قبل العميل.";
  //   var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";
  //
  //   var updateNoteArabic = "تم إجراء بعض التغييرات في";
  //   var updateNote = "MADE SOME CHANGES IN";
  //
  //   Uint8List cancelNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(cancelNoteArabic));
  //   Uint8List updateNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(updateNoteArabic));
  //
  //   var invoiceType = "KOT";
  //   var invoiceTypeArabic = "(طباعة المطب";
  //
  //   Uint8List typeEng = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
  //   Uint8List typeArabic = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));
  //   bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
  //
  //   bytes +=generator.textEncoded(typeEng, styles:
  //   const PosStyles(height: PosTextSize.size3, width: PosTextSize.size5, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
  //   bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
  //   bytes +=generator.textEncoded(typeArabic,
  //       styles:
  //       const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
  //   bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
  //
  //   if (isCancel) {
  //     bytes +=generator.text(cancelNoteData,
  //         styles:
  //         const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
  //     bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
  //     bytes +=generator.textEncoded(cancelNoteEnc,
  //         styles:
  //         const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
  //   }
  //   print("-----3");
  //   if (isUpdate) {
  //     bytes +=generator.text(updateNote,
  //         styles:
  //         const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
  //     bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
  //     bytes +=generator.textEncoded(updateNoteEnc,
  //         styles:
  //         const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
  //   }
  //
  //   Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
  //   bytes +=generator.hr();
  //   bytes +=generator.text('Token No', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
  //   bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
  //   bytes +=generator.text(tokenNumber, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
  //   bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
  //   bytes +=generator.textEncoded(tokenEnc, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //   bytes +=generator.hr();
  //   print("-----4");
  //
  //   if(showUsernameKot){
  //     bytes +=generator.row([
  //       PosColumn(text: 'User name     :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(text: userName, width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
  //     ]);
  //   }
  //   if(showDateTimeKot){
  //     bytes +=generator.row([
  //       PosColumn(text: 'Time    :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(text: convertDateAndTime(currentTime), width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
  //     ]);
  //   }
  //   bytes +=generator.row([
  //     PosColumn(text: 'Kitchen name :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //     PosColumn(text: kitchenName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   ]);
  //
  //   bytes +=generator.row([
  //     PosColumn(text: 'Order type       :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //     PosColumn(text: orderType, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   ]);
  //
  //   if (orderType == "Dining") {
  //     bytes +=generator.row([
  //       PosColumn(text: 'Table Name       :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(text: tableName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //     ]);
  //   }
  //   print("-----5");
  //   bytes +=generator.setStyles(const PosStyles.defaults());
  //   bytes +=generator.setStyles(  PosStyles(codeTable: defaultCodePage));
  //   bytes +=generator.hr();
  //   bytes +=generator.row([
  //     PosColumn(
  //         text: 'SL',
  //         width: 2,
  //         styles: const PosStyles(
  //           height: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //         text: 'Product Name',
  //         width: 8,
  //         styles: const PosStyles(
  //           height: PosTextSize.size1,
  //         )),
  //     PosColumn(text: 'Qty', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //   ]);
  //   bytes +=generator.hr();
  //   print("-----5.5");
  //   for (var i = 0; i < dataPrint.length; i++) {
  //     var slNo = i + 1;
  //     print("-----5.6");
  //     var productDescription = dataPrint[i].productDescription;
  //
  //
  //     Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(dataPrint[i].productName));
  //
  //     print("-----5.7");
  //     bytes +=generator.row([
  //       PosColumn(
  //           text: '$slNo',
  //           width: 2,
  //           styles: const PosStyles(
  //             height: PosTextSize.size1,
  //           )),
  //       PosColumn(textEncoded: productName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(text: dataPrint[i].qty, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //     ]);
  //
  //     if (productDescription != "") {
  //       Uint8List productDescriptionEnc = await CharsetConverter.encode("ISO-8859-6", setString(productDescription));
  //       bytes +=generator.textEncoded(productDescriptionEnc,
  //           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //     }
  //
  //     // if (dataPrint[i].f != "") {
  //     //   Uint8List flavour = await CharsetConverter.encode("ISO-8859-6", setString(dataPrint[i].flavour));
  //     //   bytes +=generator.textEncoded(flavour, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //     // }
  //     bytes +=generator.hr();
  //   }
  //
  //   bytes +=generator.feed(1);
  //   bytes +=generator.row([
  //     PosColumn(
  //         text: 'Total quantity',
  //         width: 3,
  //         styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontB, bold: true)),
  //     PosColumn(text: '', width: 7),
  //     PosColumn(
  //         text: roundStringWith(totalQty),
  //         width: 2,
  //         styles:
  //         (const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontB, bold: true, align: PosAlign.right))),
  //   ]);
  //   bytes +=generator.cut();
  //
  //
  // }
}

List<PrintDetails> printListData = [];
List<ItemsDetails> dataPrint = [];

class ItemsDetails {
  var productName, productDescription, qty, tableName, orderTypeI, tokenNumber, voucherNo;

  ItemsDetails({this.productName, this.productDescription, this.qty, this.tableName, this.orderTypeI, this.tokenNumber, this.voucherNo});

  factory ItemsDetails.fromJson(Map<dynamic, dynamic> json) {
    return   ItemsDetails(
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

Future<Uint8List> _fetchImageData(String imageUrl) async {
  final http.Response response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes;
}
class ESCPrinterServicesArabic {
  var qr;
  var prefs;
bool isCancelled;
  List<int>? _bytes;

  List<int>? get bytes => _bytes;
  PaperSize? _paperSize;
  CapabilityProfile? _profile;

  ESCPrinterServicesArabic(this.qr, this.prefs, this._paperSize, this.isCancelled);

  Future<List<int>> getBytes({
    PaperSize paperSize = PaperSize.mm80,
    required CapabilityProfile profile,
    String name = "default",
  }) async {

    var productGrossAmountCustomized = prefs.getBool("ProductGrossAmountCustomized") ?? false;
    String defaultCodePage = prefs.getString("defaultCodePage") ?? "CP864";
    var highlightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
    var hideTaxDetails = prefs.getBool("hideTaxDetails") ?? false;
    var flavourInOrderPrint = prefs.getBool("flavour_in_order_print") ?? false;
  //  var flavourInOrderPrint = prefs.getBool("flavour_in_order_print") ?? false;
    List<int> printer = [];
    _profile = profile;

    var paper = prefs.get("PrintPaperSizeCustomized") ?? "80mm";
    if (paper == "80mm") {
      paperSize = PaperSize.mm80;
    } else if (paper == "58mm") {
      paperSize = PaperSize.mm58;
    } else if (paper == "72mm") {
      paperSize = PaperSize.mm72;
    } else {
      paperSize = PaperSize.mm80;
    }
    _paperSize = paperSize;

    Generator generator = Generator(_paperSize!, _profile!);
    var textStyleSwitch = prefs.getBool("textStylingCustomized") ?? false;

    var paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
    var headerAlignment = prefs.getBool("headerAlignment") ?? false;
    var salesMan = prefs.getString("user_name") ?? '';
    var openDrawer = prefs.getBool("OpenDrawer") ?? false;
    var timeInPrint = prefs.getBool("time_in_invoice") ?? false;
    var reverseArabicOption = prefs.getBool("reverseArabicOption") ?? false;

    List<ProductDetailsModel> tableDataDetailsPrint = [];

    var salesDetails = BluetoothPrintThermalDetails.salesDetails;
    print(salesDetails);
    for (Map user in salesDetails) {
      tableDataDetailsPrint.add(ProductDetailsModel.fromJson(user));
    }

    var logoAvailable = true;
    var productDecBool = true;
    var qrCodeAvailable = true;


    var invoiceType;
    var invoiceTypeArabic;

    invoiceType = "SIMPLIFIED TAX INVOICE";
    invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";

    if (PrintDataDetails.type == "SI") {
      invoiceType = "SIMPLIFIED TAX INVOICE";
      invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
    }
    if (PrintDataDetails.type == "SO") {
      logoAvailable = false;
      qrCodeAvailable = false;
      productDecBool = false;
      invoiceType = "SALES ORDER";
      invoiceTypeArabic = "(طلب المبيعات)";
    }

    var companyName = BluetoothPrintThermalDetails.companyName;
    var buildingDetails = BluetoothPrintThermalDetails.buildingNumber;
    var streetName = BluetoothPrintThermalDetails.streetName;
    var companySecondName = BluetoothPrintThermalDetails.secondName;
    var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
    var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
    var companyTax = BluetoothPrintThermalDetails.vatNumberCompany;



     var companyCrNumber = BluetoothPrintThermalDetails.cRNumberCompany;


    print("companyCrNumber   $companyCrNumber companyTax  $companyTax ");


    var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
    var qrCodeData = BluetoothPrintThermalDetails.qrCodeImage;

    var voucherNumber = BluetoothPrintThermalDetails.voucherNumber;
    var customerName = BluetoothPrintThermalDetails.ledgerName;

    if (BluetoothPrintThermalDetails.ledgerName == "Cash In Hand") {
      customerName = BluetoothPrintThermalDetails.customerName;
    }
    var date = BluetoothPrintThermalDetails.date;
    var customerPhone = BluetoothPrintThermalDetails.customerPhone;
    var grossAmount = roundStringWith(BluetoothPrintThermalDetails.grossAmount);
    var discount = roundStringWith(BluetoothPrintThermalDetails.discount);
    var totalTax = roundStringWith(BluetoothPrintThermalDetails.totalTax);
    var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
    var vatAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalVATAmount);
    var exciseAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalExciseAmount);
    bool showExcise = double.parse(exciseAmountTotal) > 0.0 ? true : false;
    var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
    //var companyLogo = "";
    var token = BluetoothPrintThermalDetails.tokenNumber;

    var cashReceived = BluetoothPrintThermalDetails.cashReceived;
    var bankReceived = BluetoothPrintThermalDetails.bankReceived;
    var balance = BluetoothPrintThermalDetails.balance;
    var orderType = BluetoothPrintThermalDetails.salesType;
    var tableName = BluetoothPrintThermalDetails.tableName;
     if (isCancelled) {
      var cancelNoteData = "THIS ORDER WAS CANCELLED BY THE CUSTOMER.";
      printer += generator.text(cancelNoteData,
          styles:
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
    }
    //
    /// image print commented

    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));
/// logo commented



    if (PrintDataDetails.type == "SI") {
      if (companyLogo != "") {
        final Uint8List imageData = await _fetchImageData(companyLogo);
        final Img.Image? image = Img.decodeImage(imageData);
        final Img.Image resizedImage = Img.copyResize(image!, width: 200);
        printer += generator.imageRaster(resizedImage,imageFn:PosImageFn.bitImageRaster,highDensityVertical: true,highDensityHorizontal: true);



     //    final Img.Image? image = Img.decodeImage(imageData);
     //    final Img.Image resizedImage = Img.copyResize(image!, width: 200);
     // //   printer += generator.imageRaster(resizedImage);
     //
     //    printer += generator.imageRaster(resizedImage,imageFn:PosImageFn.bitImageRaster,highDensityVertical: true,highDensityHorizontal: true);


        //   printer.image(resizedImage);
      }
    }

    print("------------------------*1");

    print("-----------------------------------------------------------------------------*-*-*-*-*${setString('ضريبه  ' + companyTax,reverseArabicOption)}");

    Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName,reverseArabicOption));
    Uint8List companyTaxEnc = await CharsetConverter.encode("ISO-8859-6", setString(' الرقم الضريبي: ' + companyTax,reverseArabicOption));
    Uint8List companyCREnc = await CharsetConverter.encode("ISO-8859-6", setString('س.ت: ' + companyCrNumber,reverseArabicOption));
    Uint8List companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone,reverseArabicOption));
    Uint8List salesManDetailsEnc = await CharsetConverter.encode("ISO-8859-6", setString('رجل المبيعات ' + salesMan,reverseArabicOption));
    print("------------------------*1");
    // if (headerAlignment) {
    //   companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyPhone,reverseArabicOption));
    // }

    Uint8List invoiceTypeEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType,reverseArabicOption));
    Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic,reverseArabicOption));

    Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('    الإجمالي قبل الضريبة',reverseArabicOption));
    Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة',reverseArabicOption));
    Uint8List exciseTax = await CharsetConverter.encode("ISO-8859-6", setString('مبلغ الضريبة الانتقائية',reverseArabicOption));
    Uint8List vatTax = await CharsetConverter.encode("ISO-8859-6", setString('ضريبة القيمة المضافة',reverseArabicOption));
    Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('الخصم',reverseArabicOption));
    Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('Total صافي الفاتورة بعد الضريبة ',reverseArabicOption));
    print("------------------------*1111111");
    Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد',reverseArabicOption));
    Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم',reverseArabicOption));
    Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك',reverseArabicOption));
    print("------------------------*1111111");
    if (headerAlignment) {
      printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
      if (companyName != "") {
        printer += generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }

      print("------------------------*1");
      if (companySecondName != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName,reverseArabicOption));
        printer += generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
      }
      print("------------------------*1");

      if (buildingDetails != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        Uint8List buildingDetailsEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails,reverseArabicOption));

        printer += generator.textEncoded(buildingDetailsEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      print("------------------------*1");
      if (streetName != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        Uint8List secondAddressEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName,reverseArabicOption));

        printer += generator.textEncoded(secondAddressEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (companyTax != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        printer += generator.textEncoded(companyTaxEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }

      if (companyCrNumber != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        printer += generator.textEncoded(companyCREnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }

      if (companyPhone != "") {
        printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        printer += generator.textEncoded(companyPhoneEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }




/*      if (companyName != "") {
        printer += generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }
      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName,reverseArabicOption));

        printer += generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));

        //printer += generator.textEncoded(descriptionC, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1));
      }

      if (buildingDetails != "") {
        Uint8List buildingAddressEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails,reverseArabicOption));

        printer += generator.row([
          PosColumn(text: 'Building', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1),
          PosColumn(
              textEncoded: buildingAddressEncode,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);

        // printer += generator.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }
      print("------------------------*595959595");
      if (streetName != "") {
        Uint8List streetNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName,reverseArabicOption));

        printer += generator.row([
          PosColumn(text: 'Building ', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: streetNameEncode,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);

        // printer += generator.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }
      print("------------------------*4444444");
      if (companyTax != "") {
        printer += generator.row([
          PosColumn(text: 'Vat Number', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyTaxEnc,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
        //  printer += generator.textEncoded(companyTaxEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }
      // if(companyCrNumber !=""){
      //   printer += generator.row([
      //     PosColumn(text: '', width: 1,styles:PosStyles(align: PosAlign.left)),
      //     PosColumn(textEncoded: companyCREnc,width: 10, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center)),
      //     PosColumn(text: '', width: 1,styles:PosStyles(align: PosAlign.left)),
      //   ]);
      //   //  printer += generator.textEncoded(companyCREnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      // }

      if (companyPhone != "") {
        printer += generator.row([
          PosColumn(text: 'Phone', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyPhoneEnc,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
       }
    */


    }
    else {


      if (companyName != "") {
        printer += generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }

      print("------------------------*1");
      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName,reverseArabicOption));
        printer += generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
      }
      print("------------------------*1");

      if (buildingDetails != "") {
        Uint8List buildingDetailsEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails,reverseArabicOption));
        printer += generator.textEncoded(buildingDetailsEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      print("------------------------*1");
      if (streetName != "") {
        Uint8List secondAddressEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName,reverseArabicOption));

        printer += generator.textEncoded(secondAddressEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (companyTax != "") {
        printer += generator.textEncoded(companyTaxEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }

      if (companyCrNumber != "") {
        printer += generator.textEncoded(companyCREnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }

      if (companyPhone != "") {
        printer += generator.textEncoded(companyPhoneEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      // if (salesMan != "") {
      //   printer += generator.textEncoded(salesManDetailsEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      // }
    }
    print("------------------------*41212121212");
    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    printer += generator.textEncoded(invoiceTypeEnc, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, align: PosAlign.center));
    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    printer += generator.textEncoded(invoiceTypeArabicEnc, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
    Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز ',reverseArabicOption));
    Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة',reverseArabicOption));
    Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ ',reverseArabicOption));
    Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString(' اسم ',reverseArabicOption));
    Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب ',reverseArabicOption));
    // printer += generator.setStyles(PosStyles.defaults()); ///


    if (highlightTokenNumber) {
      printer += generator.hr();
      printer += generator.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
      printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
      printer += generator.text(token, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
      printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
      printer += generator.textEncoded(tokenEnc, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      printer += generator.hr();
    } else {
      printer += generator.row([
        PosColumn(text: 'Token No ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tokenEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: token, width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    printer += generator.row([
      PosColumn(text: 'Voucher No', width: 4, styles: const PosStyles(fontType: PosFontType.fontB,align: PosAlign.left)),
      PosColumn(
          textEncoded: voucherNoEnc,
          width: 4,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: voucherNumber, width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    printer += generator.row([
      PosColumn(text: 'Date  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: dateEnc,
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: date, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);

    if (customerName != "") {
      Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName,reverseArabicOption));

      printer += generator.row([
        PosColumn(text: 'Name    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: customerEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            textEncoded: customerNameEnc,
            width: 6,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }
    if (customerPhone != "") {
      Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone,reverseArabicOption));

      Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف',reverseArabicOption));

      printer += generator.row([
        PosColumn(text: 'Phone    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: phoneEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            textEncoded: phoneNoEncoded,
            width: 6,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }

    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage));
    printer += generator.row([
      PosColumn(text: 'Order type    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(textEncoded: typeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: orderType, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    ]);

    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage));

    if (tableName != "") {
      Uint8List tableEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة',reverseArabicOption));

      printer += generator.row([
        PosColumn(text: 'Table Name   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: tableEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: tableName, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }
    if (timeInPrint) {
      var time = BluetoothPrintThermalDetails.time;

      String timeInvoice = await convertToSaudiArabiaTime(time, countyCodeCompany);
      Uint8List timeEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة',reverseArabicOption));

      printer += generator.row([
        PosColumn(text: 'Time   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: timeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: timeInvoice, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }

    printer += generator.hr();

    ///

    Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم ",reverseArabicOption));
    Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("إسم المادة ",reverseArabicOption));
    Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString(" كمية ",reverseArabicOption));
    Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("السعر ",reverseArabicOption));
    Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("إجمالي ",reverseArabicOption));

    print("------------------------*1111111111111111111111");

    printer += generator.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: 'Item Name', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(text: 'Rate', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: 'Total', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));

    printer += generator.row([
      PosColumn(
          textEncoded: slNoEnc,
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
            fontType: PosFontType.fontA,
          )),
      PosColumn(textEncoded: productNameEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.left)),
      PosColumn(textEncoded: qtyEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(textEncoded: rateEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(textEncoded: netEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    printer += generator.hr();

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var slNo = i + 1;

      //Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName,reverseArabicOption));

      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString("$slNo ${tableDataDetailsPrint[i].productName}",reverseArabicOption));
      printer+= generator.textEncoded(productName,styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.left));


      printer += generator.row([
        // PosColumn(
        //     text: "$slNo",
        //     width: 1,
        //     styles: const PosStyles(
        //       height: PosTextSize.size1,
        //     )),
        PosColumn(text: "", width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: tableDataDetailsPrint[i].qty, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: true)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
            width: 3,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].netAmount),
            width: 3,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      var description = tableDataDetailsPrint[i].productDescription ?? '';
      if (description != "") {
        Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription,reverseArabicOption));
        printer+= generator.textEncoded(  description,   styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right));

        // printer += generator.row([
        //   PosColumn(
        //       textEncoded: description,
        //       width: 10,
        //       styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        //   PosColumn(
        //       text: '',
        //       width: 2,
        //       styles: const PosStyles(
        //         height: PosTextSize.size1,
        //       ))
       // ]);
      }
      var flavour = tableDataDetailsPrint[i].flavourName ?? '';

      if (PrintDataDetails.type == "SO") {
        if(flavourInOrderPrint){
          if(flavour!=""){
            Uint8List flavourNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].flavourName,reverseArabicOption));
            printer += generator.row([
              PosColumn(
                  textEncoded: flavourNameEnc,
                  width: 10,
                  styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
              PosColumn(
                  text: '',
                  width: 2,
                  styles: const PosStyles(
                    height: PosTextSize.size1,
                  ))
            ]);
          }

        }
      }
      printer += generator.hr();
    }
    printer += generator.emptyLines(1);
    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));


    printer += generator.row([
      PosColumn(text: 'Gross Amount', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: ga,
          width: 7,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(grossAmount), width: 2, styles: const PosStyles(align: PosAlign.right)),
    ]);

    if (hideTaxDetails) {
      if (showExcise) {
        printer += generator.row([
          PosColumn(text: 'Total Excise Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: exciseTax,
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(text: roundStringWith(exciseAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]);
        printer += generator.row([
          PosColumn(text: 'Total VAT', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: vatTax,
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(text: roundStringWith(vatAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      printer += generator.row([
        PosColumn(text: 'Total Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tt,
            width: 4,
            styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: roundStringWith(totalTax), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    printer += generator.row([
      PosColumn(text: 'Discount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: dis,
          width: 5,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(discount), width: 3, styles: const PosStyles(align: PosAlign.right)),
    ]);
    // printer += generator.setStyles(PosStyles.defaults());

    printer += generator.hr();


///

    printer += generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));



    printer += generator.row([

      PosColumn(
          textEncoded: gt,
          width: 9,
          styles:
          const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left, bold: true)),

      PosColumn(
          text: countyCodeCompany+ " " +roundStringWith(grandTotal),
          width: 3,
          styles: const PosStyles(
            fontType: PosFontType.fontA,
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
    ]);
    printer += generator.hr();
    if (PrintDataDetails.type == "SI") {
      if (paymentDetailsInPrint) {
        printer += generator.row([
          PosColumn(text: 'Cash receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: cr,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(cashReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer += generator.row([
          PosColumn(text: 'Bank receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: br,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(bankReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer += generator.row([
          PosColumn(text: 'Balance', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: bl,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(balance), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }
    }
    print("------------------------*1111111111111111111111ok");
    ///
    if (qrCodeAvailable) {
      printer += generator.feed(1);
      var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
          BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
      printer += generator.qrcode(qrCode, size: QRSize.size5);
    }
    // printer += generator.emptyLines(1);
    // printer += generator.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));

    printer += generator.cut();
    if (PrintDataDetails.type == "SI") {
      openDrawer= checkCashDrawer(cashReceived,bankReceived);
      if (openDrawer) {
        printer += generator.drawer();
      }
    }
    return printer;
  }
  bool checkCashDrawer(cash,bank) {
    double cashReceived = double.parse(cash??'0');
    double bankAmount = double.parse(bank??'0');

    if (cashReceived > 0.0) {
      return true;
    } else if (cashReceived == 0.0 && bankAmount > 0.0) {
      return false;
    }
    return false;
  }

}

class ESCPrinterServicesArabicKOT {

  var prefs;


 String printerAddress;
 int index;
 var  items,cancelNote;
 bool isUpdate,isCancel;

  PaperSize? _paperSize;
  CapabilityProfile? _profile;

  ESCPrinterServicesArabicKOT(this.prefs,this.printerAddress, this.index, this.items, this.cancelNote, this.isUpdate, this.isCancel);

  Future<List<int>> getBytes({
    PaperSize paperSize = PaperSize.mm80,
    required CapabilityProfile profile,
    String name = "default",
  }) async {


    print("--------------------------123");

    String defaultCodePage = prefs.getString("defaultCodePage") ?? "CP864";
    var hideTaxDetails = prefs.getBool("hideTaxDetails") ?? false;
    var flavourInOrderPrint = prefs.getBool("flavour_in_order_print") ?? false;

    _profile = profile;

    var paper = prefs.get("PrintPaperSizeCustomized") ?? "80mm";

    if (paper == "80mm") {
      paperSize = PaperSize.mm80;
    } else if (paper == "58mm") {
      paperSize = PaperSize.mm58;
    } else if (paper == "72mm") {
      paperSize = PaperSize.mm72;
    } else {
      paperSize = PaperSize.mm80;
    }
    _paperSize = paperSize;

    Generator generator = Generator(_paperSize!, _profile!);


    var userName = prefs.getString('user_name')??"";
    bool showUsernameKot = prefs.getBool('show_username_kot')??false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot')??false;
    var reverseArabicOption = prefs.getBool("reverseArabicOption") ?? false;

    var currentTime = DateTime.now();
    List<int> bytes = [];


    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();

    for (Map user in items) {
      dataPrint.add(ItemsDetails.fromJson(user));
    }


    print("---------------------${printListData}   $index");
    var kitchenName ="";
    var totalQty = dataPrint[0].qty;
    if(printListData.isNotEmpty){
      kitchenName = printListData[index].kitchenName??"";
      totalQty = printListData[index].totalQty;
    }


    var tableName = dataPrint[0].tableName;
    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI ?? "";

    bytes +=generator.setStyles(const PosStyles.defaults());
    bytes +=generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));

    var cancelNoteArabic = "تم إلغاء هذا العنصر من قبل العميل.";
    var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";

    var updateNoteArabic = "تم إجراء بعض التغييرات في";
    var updateNote = "MADE SOME CHANGES IN";

    Uint8List cancelNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(cancelNoteArabic,reverseArabicOption));
    Uint8List updateNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(updateNoteArabic,reverseArabicOption));

    var invoiceType = "KOT";
    var invoiceTypeArabic = "(طباعة المطب";

    Uint8List typeEng = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType,reverseArabicOption));
    Uint8List typeArabic = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic,reverseArabicOption));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    bytes +=generator.textEncoded(typeEng, styles:
    const PosStyles(height: PosTextSize.size3, width: PosTextSize.size5, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
    bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    bytes +=generator.textEncoded(typeArabic,
        styles:
        const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    if (isCancel) {
      bytes +=generator.text(cancelNoteData,
          styles:
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
      bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
      bytes +=generator.textEncoded(cancelNoteEnc,
          styles:
          const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    }
    print("-----3");
    if (isUpdate) {
      bytes +=generator.text(updateNote,
          styles:
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
      bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
      bytes +=generator.textEncoded(updateNoteEnc,
          styles:
          const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    }

    Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز',reverseArabicOption));
    bytes +=generator.hr();
    bytes +=generator.text('Token No', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
    bytes +=generator.text(tokenNumber, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
    bytes +=generator.textEncoded(tokenEnc, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.hr();
    print("-----4");

    if(showUsernameKot){
      bytes +=generator.row([
        PosColumn(text: 'User name     :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: userName, width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }
    if(showDateTimeKot){
      bytes +=generator.row([
        PosColumn(text: 'Time    :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: convertDateAndTime(currentTime), width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }
    bytes +=generator.row([
      PosColumn(text: 'Kitchen name :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: kitchenName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    bytes +=generator.row([
      PosColumn(text: 'Order type       :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: orderType, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    if (orderType == "Dining") {
      bytes +=generator.row([
        PosColumn(text: 'Table Name       :', width: 4, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: tableName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }
    print("-----5");
    bytes +=generator.setStyles(const PosStyles.defaults());
    bytes +=generator.setStyles(  PosStyles(codeTable: defaultCodePage));
    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Product Name',
          width: 9,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    bytes +=generator.hr();
    print("-----5.5");
    for (var i = 0; i < dataPrint.length; i++) {
      var slNo = i + 1;
      print("-----5.6");
      var productDescription = dataPrint[i].productDescription;
      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString( "$slNo  "+dataPrint[i].productName,reverseArabicOption));

      bytes +=generator.row([
        // PosColumn(
        //     text: '$slNo',
        //     width: 2,
        //     styles: const PosStyles(
        //       height: PosTextSize.size1,
        //     )),
        PosColumn(textEncoded: productName, width: 10, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: dataPrint[i].qty, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (productDescription != "") {
        Uint8List productDescriptionEnc = await CharsetConverter.encode("ISO-8859-6", setString(productDescription,reverseArabicOption));
        bytes +=generator.textEncoded(productDescriptionEnc,styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      // if (dataPrint[i].f != "") {
      //   Uint8List flavour = await CharsetConverter.encode("ISO-8859-6", setString(dataPrint[i].flavour));
      //   bytes +=generator.textEncoded(flavour, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      // }
      bytes +=generator.hr();
    }

    bytes +=generator.feed(1);
    bytes +=generator.row([
      PosColumn(
          text: 'Total quantity',
          width: 3,
          styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontB, bold: true)),
      PosColumn(text: '', width: 7),
      PosColumn(
          text: roundStringWith(totalQty),
          width: 2,
          styles:
          (const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontB, bold: true, align: PosAlign.right))),
    ]);
    bytes +=generator.cut();
    return bytes;
  }
}


class ESCBTTEST {

  String? option;
  List<int>? _bytes;
  List<int>? get bytes => _bytes;
  CapabilityProfile? _profile;

  ESCBTTEST();
//
  Future<List<int>> getBytes({
    PaperSize paperSize = PaperSize.mm80, required CapabilityProfile profile, String name = "default",required String option}) async {

    List<int> printer = [];
    _profile = profile;
    final supportedCodePages = profile.codePages;
    Generator generator = Generator(PaperSize.mm80, _profile!);
// image printing commented
//     final arabicImageBytes = await generateInvoice();
//     var ii = Img.decodeImage(arabicImageBytes);
//     final Img.Image _resize = Img.copyResize(ii!, width: 300);
//     printer += generator.imageRaster(_resize);


  //  printer += generator.image(_resize);



    print("-------------------------------------$option");

    if(option =="1"){
      print("-------------------------------------$option");
      final Uint8List imageData = await _fetchImageData("https://www.api.viknbooks.com/media/company-logo/WhatsApp_Image_2024-07-10_at_12.43.00_PM_s4PUuKU.jpeg");
      final Img.Image? image = Img.decodeImage(imageData);
      final Img.Image resizedImage = Img.copyResize(image!, width: 200);
      printer += generator.imageRaster(resizedImage,imageFn:PosImageFn.bitImageRaster,highDensityVertical: true,highDensityHorizontal: true);
    }
    else if(option =="2"){
      final Uint8List imageData = await _fetchImageData("https://www.api.viknbooks.com/media/company-logo/WhatsApp_Image_2024-07-10_at_12.43.00_PM_s4PUuKU.jpeg");
      final Img.Image? image = Img.decodeImage(imageData);
      final Img.Image resizedImage = Img.copyResize(image!, width: 200);
      printer += generator.imageRaster(resizedImage,imageFn:PosImageFn.bitImageRaster,highDensityVertical: false,highDensityHorizontal: false);
    }
    else if(option =="3"){


      final Uint8List imageData = await _fetchImageData("https://www.api.viknbooks.com/media/company-logo/WhatsApp_Image_2024-07-10_at_12.43.00_PM_s4PUuKU.jpeg");
      final Img.Image? image = Img.decodeImage(imageData);
      final Img.Image resizedImage = Img.copyResize(image!, width: 200);
      printer += generator.imageRaster(resizedImage,imageFn:PosImageFn.bitImageRaster,highDensityVertical: true,highDensityHorizontal: false);
    }
    else if(option =="6"){

      // const utf8Encoder = Utf8Encoder();
      // printer += generator.reset();
      // final encodedStr = utf8Encoder.convert(".السلامالسلامالسلامالسلامالسلام",);
      // printer += generator.textEncoded(Uint8List.fromList([
      //   ...[0x1C, 0x26, 0x1C, 0x43, 0xFF],
      //   ...encodedStr
      // ]));

      for(var ind = 0;ind<supportedCodePages.length ;ind++){
        printer += generator.setGlobalCodeTable(supportedCodePages[ind].name);
        var testData ="${supportedCodePages[ind].name} السلام ${profile.name} ";
        Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData,false));
        printer += generator.text("السلام------------------------",containsChinese: true);
        printer += generator.textEncoded(salam,styles: const PosStyles(align:PosAlign.center),);
      }
    }



    else{
      final Uint8List imageData = await _fetchImageData("https://www.api.viknbooks.com/media/company-logo/WhatsApp_Image_2024-07-10_at_12.43.00_PM_s4PUuKU.jpeg");
      final Img.Image? image = Img.decodeImage(imageData);
      final Img.Image resizedImage = Img.copyResize(image!, width: 200);
      printer += generator.imageRaster(resizedImage);
    }

        //printer.image(resizedImage);


       printer += generator.text("Test Data",);
       printer += generator.emptyLines(3);

    return printer;
  }
}

Future<Uint8List> generateInvoice() async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  // Define canvas size and background color
  // const Size canvasSize = Size(500, 600);
  const Size canvasSize1 = Size(500, 1200);

  // Adjust size as needed
  const Color backgroundColor = Colors.white; // Specify your desired background color

  // Draw background

  canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize1.width, canvasSize1.height), Paint()..color = backgroundColor);

  var invoiceType = "SIMPLIFIED TAX INVOICE";
  var invoiceTypeArabic = "فاتورة ضريبية مبسطة";
  var type = "SI";
// Simulated conditions based on PrintDataDetails.type
  if (type == "SI") {
    invoiceType = "SIMPLIFIED TAX INVOICE";
    invoiceTypeArabic = "فاتورة ضريبية مبسطة";
  }
  if (type == "SO") {
    // Adjusting other variables for a sales order scenario
    var logoAvailable = false;
    var qrCodeAvailable = false;
    var productDecBool = false;
    invoiceType = "SALES ORDER";
    invoiceTypeArabic = "طلب المبيعات";
  }

  var companyName = "Sample Company";
  var buildingDetails = "123";
  var streetName = "Sample Street";
  var companySecondName = "شركة رافع الغيلث بن";
  var companyCountry = "Sample Country";
  var companyPhone = "+1234567890";
  var companyTax = "123456789";
  var companyCrNumber = "CR123456";
  var countyCodeCompany = "XYZ";
  var qrCodeData = "QR Code Data";

  var voucherNumber = "V123456";
  var customerName = "John Doe";

  if (customerName == "Cash In Hand") {
    customerName = "Jane Doe";
  }

  var date = "2024-07-04";
  var customerPhone = "+9876543210";
  var grossAmount = "1000.00";
  var discount = "100.00";
  var totalTax = "150.00";
  var grandTotal = "1050.00";
  var vatAmountTotal = "50.00";
  var exciseAmountTotal = "25.00";
  bool showExcise = double.parse(exciseAmountTotal) > 0.0 ? true : false;
  var companyLogo = "path_to_company_logo.jpg";
  var token = "Token123";

  var cashReceived = "500.00";
  var bankReceived = "550.00";
  var balance = "0.00";
  var orderType = "Dining";
  var tableName = "Table 1";

  // Set up paint for text and lines
  final textPaint = Paint()..color = Colors.black;
  final linePaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2.0;

  // Set up text styles with custom font
  const titleStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  const headerStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  const itemStyle = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );
  const totalTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  const companyDetailsStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
  // var companyDetailsStyle = GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 15.0));
  // Define paragraph styles
  final titleParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontSize: titleStyle.fontSize,
    fontWeight: titleStyle.fontWeight,
    fontFamily: titleStyle.fontFamily,
  );
  final headerParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.left,
    fontSize: headerStyle.fontSize,
    fontWeight: headerStyle.fontWeight,
    fontFamily: headerStyle.fontFamily,
  );
  final itemParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.left,
    fontSize: itemStyle.fontSize,
    fontWeight: itemStyle.fontWeight,
    fontFamily: itemStyle.fontFamily,
  );

  final voucherDetailsStyleLeft = ui.ParagraphStyle(
    textAlign: TextAlign.left,
    fontSize: itemStyle.fontSize,
    fontWeight: itemStyle.fontWeight,
    fontFamily: itemStyle.fontFamily,
  );
  final voucherDetailsStyleRight = ui.ParagraphStyle(
    textAlign: TextAlign.right,
    fontSize: itemStyle.fontSize,
    fontWeight: itemStyle.fontWeight,
    fontFamily: itemStyle.fontFamily,
  );
  final voucherDetailsStyleCenter = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontSize: itemStyle.fontSize,
    fontWeight: itemStyle.fontWeight,
    fontFamily: itemStyle.fontFamily,
  );
  final totalTextParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.left,
    fontSize: totalTextStyle.fontSize,
    fontWeight: totalTextStyle.fontWeight,
    fontFamily: totalTextStyle.fontFamily,
  );

  final totalAmountParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.right,
    fontSize: totalTextStyle.fontSize,
    fontWeight: totalTextStyle.fontWeight,
    fontFamily: totalTextStyle.fontFamily,
  );
  final companyDetailsParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.center,
    fontSize: companyDetailsStyle.fontSize,
    fontWeight: companyDetailsStyle.fontWeight,
    fontFamily: companyDetailsStyle.fontFamily,
  );

  double positionHeight = 5.0;

  // Add company name
  final companyNameBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 40.0,fontFamily: 'Poppins',fontWeight: FontWeight.w700))
    ..addText(companyName);
  final companyNameParagraph = companyNameBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(companyNameParagraph, Offset(0, positionHeight));
  // Add Second name
  positionHeight = positionHeight + 40;
  final companySecondNameBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 35.0))
    ..addText(companySecondName);
  final companySecondNameParagraph = companySecondNameBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(companySecondNameParagraph, Offset(0, positionHeight));

  // buildingDetails
  positionHeight = positionHeight + 40;
  final buildingDetailsBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
    ..addText(buildingDetails);
  final buildingDetailsParagraph = buildingDetailsBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(buildingDetailsParagraph, Offset(0, positionHeight));

  // Street name
  positionHeight = positionHeight + 40;
  final streetBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
    ..addText(streetName);
  final streetBuilderParagraph = streetBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(streetBuilderParagraph, Offset(0, positionHeight));

  // Street name
  positionHeight = positionHeight + 40;
  final taxDetailsBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
    ..addText(companyTax);
  final taxDetailsParagraph = taxDetailsBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(taxDetailsParagraph, Offset(0, positionHeight));

  // InvoiceDetails eng
  positionHeight = positionHeight + 40;
  final invoiceEngNameBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
    ..addText(invoiceType);
  final invoiceDetailsDetailsParagraph = invoiceEngNameBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(invoiceDetailsDetailsParagraph, Offset(0, positionHeight));

  // InvoiceDetails

  positionHeight = positionHeight + 30;
  final invoiceArabicNameBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
    ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
    ..addText(invoiceTypeArabic);
  final invoiceDetailsArabicDetailsParagraph = invoiceArabicNameBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  canvas.drawParagraph(invoiceDetailsArabicDetailsParagraph, Offset(0, positionHeight));
  positionHeight = positionHeight + 40;
  canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

  positionHeight = positionHeight + 40;
  final voucherDetails = [
    ['Token Number:', token, 'رقم الطيب '],
    ['Voucher No:', voucherNumber, 'رقم القسيمة '],
    ['Date:', date, 'التاريخ '],
    ['Order Type:', orderType, 'نوع الطلب '],
    ['Table Name:', tableName, 'اسم الطاولة '],
  ];

// Layout constraints for each column
  final double column1Width = canvasSize1.width / 3;
  final double column2Width = canvasSize1.width / 3;
  final double column3Width = canvasSize1.width / 3;

  for (final item in voucherDetails) {
    // English label
    final englishTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleLeft)
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(item[0]);
    final englishTextParagraph = englishTextBuilder.build()..layout(ui.ParagraphConstraints(width: column1Width));
    canvas.drawParagraph(englishTextParagraph, Offset(0, positionHeight));

    // Arabic label
    final arabicTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleCenter)
      ..pushStyle(ui.TextStyle(
        color: Colors.black,
      ))
      ..addText(item[1]);
    final arabicTextParagraph = arabicTextBuilder.build()..layout(ui.ParagraphConstraints(width: column2Width));
    canvas.drawParagraph(arabicTextParagraph, Offset(column1Width, positionHeight));

    // Value
    final valueTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleRight)
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(item[2]);
    final valueTextParagraph = valueTextBuilder.build()..layout(ui.ParagraphConstraints(width: column3Width));
    canvas.drawParagraph(valueTextParagraph, Offset(column1Width + column2Width, positionHeight));

    // Adjust offsetY based on the tallest paragraph in the row
    positionHeight += [englishTextParagraph.height, arabicTextParagraph.height, valueTextParagraph.height].reduce((a, b) => a > b ? a : b) + 10;
  }
  positionHeight = positionHeight + 25;
  canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

  final headers = ['Sl', 'Product Details', 'Qty', 'Rate', 'Total'];
  final headerWidths = [40.0, 250.0, 70.0, 70.0, 70.0]; // Adjust widths as needed

  for (int i = 0; i < headers.length; i++) {
    final alignment = (i == 1)
        ? TextAlign.left
        : (i == 0)
        ? TextAlign.center
        : TextAlign.right;
    final headerBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: alignment,
        fontSize: headerStyle.fontSize,
        fontFamily: headerStyle.fontFamily,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(headers[i]);
    final headerParagraph = headerBuilder.build()..layout(ui.ParagraphConstraints(width: headerWidths[i]));
    canvas.drawParagraph(headerParagraph, Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b), positionHeight));
  }
  positionHeight = positionHeight + 30;

  final headersArab = ['رقم', 'منتج', 'كمية', 'معدل', 'المجموع'];
  for (int i = 0; i < headersArab.length; i++) {
    final alignment = (i == 1)
        ? TextAlign.left
        : (i == 0)
        ? TextAlign.center
        : TextAlign.right;
    final headerBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: alignment,
        fontSize: headerStyle.fontSize,
        fontFamily: headerStyle.fontFamily,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(headersArab[i]);
    final headerParagraph = headerBuilder.build()..layout(ui.ParagraphConstraints(width: headerWidths[i]));
    canvas.drawParagraph(headerParagraph, Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b), positionHeight));
  }
  positionHeight = positionHeight + 30;
  canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

  // Draw horizontal line below headers

  // Add items
  final items = [
    ['1', 'PRINC', '1.00', '90.91', '90.91', 'Description of item 1'],
    ['2', 'P EX', '1.00', '100.00', '100.00', ''],
    ['3', '54545455454No Tax Product', '3.00', '12.96', '38.88', 'Description of item 3'],
    ['4', 'Price category product', '3.00', '100.00', '300.00', 'Description of item 4'],
  ];
  positionHeight = positionHeight + 40;
  for (final item in items) {
    double offsetX = 0;
    double rowHeight = 0;

    // Draw item details
    for (int i = 0; i < item.length - 1; i++) {
      final alignment = (i == 1 || i == 5)
          ? TextAlign.left
          : (i == 0)
          ? TextAlign.center
          : TextAlign.right;
      final itemBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: alignment,
          fontSize: itemStyle.fontSize,
          fontFamily: itemStyle.fontFamily,
        ),
      )
        ..pushStyle(ui.TextStyle(color: Colors.black))
        ..addText(item[i]);
      final itemParagraph = itemBuilder.build()..layout(ui.ParagraphConstraints(width: headerWidths[i]));
      canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
      offsetX += headerWidths[i];
      rowHeight = itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
    }

    positionHeight += rowHeight + 10; // Adjust height after drawing item details

    // Draw item description if not empty
    if (item[item.length - 1].isNotEmpty) {
      final descriptionBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: itemStyle.fontSize,
          fontFamily: itemStyle.fontFamily,
        ),
      )
        ..pushStyle(ui.TextStyle(color: Colors.black))
        ..addText(item[item.length - 1]);
      final descriptionParagraph = descriptionBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width)); // Adjust width as needed
      canvas.drawParagraph(descriptionParagraph, Offset(40, positionHeight));

      positionHeight += descriptionParagraph.height + 10;
      // Adjust height after drawing description
    } else {
      positionHeight += 10; // Skip space if description is empty
    }
  }

  positionHeight = positionHeight + 25;
  canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

  positionHeight = positionHeight + 25;
  canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

  final totals = [
    ['Gross Amount:', roundStringWith(grossAmount)],
    ['Total Tax:', roundStringWith(totalTax)],
    ['Discount:', roundStringWith(discount)],
    ['Grand Total:', roundStringWith(grandTotal)],
  ];

  positionHeight = positionHeight + 25; // Space before totals
  for (final total in totals) {
    final totalTextStyle = (total[0] == 'Grand Total:')
        ? TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    )
        : TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    );

    final totalTextBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: totalTextStyle.fontSize,
        fontWeight: totalTextStyle.fontWeight,
        fontFamily: totalTextStyle.fontFamily,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(total[0]);
    final totalTextParagraph = totalTextBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
    canvas.drawParagraph(totalTextParagraph, Offset(0, positionHeight));

    final totalAmountBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.right,
        fontSize: totalTextStyle.fontSize,
        fontWeight: totalTextStyle.fontWeight,
        fontFamily: totalTextStyle.fontFamily,
      ),
    )
      ..pushStyle(ui.TextStyle(color: Colors.black))
      ..addText(total[1]);
    final totalAmountParagraph = totalAmountBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
    canvas.drawParagraph(totalAmountParagraph, Offset(canvasSize1.width / 2, positionHeight));

    positionHeight += totalTextParagraph.height + 10;
  }

  ///

  // Add title
  // final titleBuilder = ui.ParagraphBuilder(titleParagraphStyle)
  //   ..pushStyle(ui.TextStyle(color: Colors.black))
  //   ..addText('فاتورة ضريبية مبسطة');
  // final titleParagraph = titleBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  // canvas.drawParagraph(titleParagraph, const Offset(0, 200));
  //
  // // Add invoice details
  // final detailsBuilder = ui.ParagraphBuilder(headerParagraphStyle)
  //   ..pushStyle(ui.TextStyle(color: Colors.black))
  //   ..addText('Date: 2024-06-24\nInvoice No: SI-382');
  // final detailsParagraph = detailsBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  // canvas.drawParagraph(detailsParagraph, const Offset(0, 240));
  //
  // // Add customer details
  // final customerBuilder = ui.ParagraphBuilder(headerParagraphStyle)
  //   ..pushStyle(ui.TextStyle(color: Colors.black))
  //   ..addText('Customer Name: Cash In Hand');
  // final customerParagraph = customerBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width));
  // canvas.drawParagraph(customerParagraph, const Offset(0, 290));
  //
  // // Add headers
  double offsetY = 330;
  // final headers = ['Sl No', 'Product Details', 'Qty', 'Rate', 'Total'];
  // final headerWidths = [40.0, 250.0, 80.0, 80.0, 80.0]; // Adjust widths as needed
  // for (int i = 0; i < headers.length; i++) {
  //   final headerBuilder = ui.ParagraphBuilder(headerParagraphStyle)
  //     ..pushStyle(ui.TextStyle(color: Colors.black))
  //     ..addText(headers[i]);
  //   final headerParagraph = headerBuilder.build()..layout(ui.ParagraphConstraints(width: headerWidths[i]));
  //   canvas.drawParagraph(headerParagraph, Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b), offsetY));
  // }
  //
  // // Draw horizontal line below headers
  // canvas.drawLine(Offset(0, offsetY + 30), Offset(canvasSize1.width, offsetY + 30), linePaint);
  //
  // // Add items
  // final items = [
  //   ['1', 'PRINC', '1.00', '90.91', '90.91'],
  //   ['2', 'P EX', '1.00', '100.00', '100.00'],
  //   ['3', 'No Tax Product', '3.00', '12.96', '38.88'],
  //   ['4', 'Price category product', '3.00', '100.00', '300.00'],
  // ];
  // offsetY = 370;
  // for (final item in items) {
  //   double offsetX = 0;
  //   double rowHeight = 0;
  //   for (int i = 0; i < item.length; i++) {
  //     final itemBuilder = ui.ParagraphBuilder(itemParagraphStyle)
  //       ..pushStyle(ui.TextStyle(color: Colors.black))
  //       ..addText(item[i]);
  //     final itemParagraph = itemBuilder.build()..layout(ui.ParagraphConstraints(width: headerWidths[i]));
  //     canvas.drawParagraph(itemParagraph, Offset(offsetX, offsetY));
  //     offsetX += headerWidths[i];
  //     rowHeight = itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
  //   }
  //   offsetY += rowHeight + 10; // Adjust height based on item content
  // }
  //
  // // Add totals
  // final totals = [
  //   ['Net Total:', '548.88 SAR'],
  //   ['Discount Amt:', '0.00 SAR'],
  //   ['Total VAT:', '19.09 SAR'],
  //   ['Grand Total:', '548.88 SAR'],
  // ];
  // offsetY += 20; // Space before totals
  // for (final total in totals) {
  //   final totalTextBuilder = ui.ParagraphBuilder(totalTextParagraphStyle)
  //     ..pushStyle(ui.TextStyle(color: Colors.black))
  //     ..addText(total[0]);
  //   final totalTextParagraph = totalTextBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
  //   canvas.drawParagraph(totalTextParagraph, Offset(0, offsetY));
  //
  //   final totalAmountBuilder = ui.ParagraphBuilder(totalAmountParagraphStyle)
  //     ..pushStyle(ui.TextStyle(color: Colors.black))
  //     ..addText(total[1]);
  //   final totalAmountParagraph = totalAmountBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
  //   canvas.drawParagraph(totalAmountParagraph, Offset(canvasSize1.width / 2, offsetY));
  //
  //   offsetY += totalTextParagraph.height + 10;
  // }

  final picture = recorder.endRecording();
  final img = await picture.toImage(canvasSize1.width.toInt(), canvasSize1.height.toInt());
  final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
  return pngBytes!.buffer.asUint8List();
}



returnBlankSpace(length) {
  List<String> list = [];
  for (int i = 0; i < length; i++) {
    list.add('');
  }
  return list;
}
setString(String tex,reverseArabicOption) {

  if(reverseArabicOption){
    return tex;
  }


  if (tex == "") {}
  String value = "";
  try {
    var listSplit = [];
    var beforeSplit = [];

    if (Check(tex)) {
      beforeSplit = set(tex);
      listSplit = beforeSplit.reversed.toList();
    } else {
      listSplit = set(tex);
    }
    for (int i = 0; i < listSplit.length; i++) {
      if (listSplit[i] == null)
        value += "";
      else if (isArabic(listSplit[i])) {
        if (value == "")
          value += listSplit[i];
        else
          value += "" + listSplit[i];
      } else if (isN(listSplit[i])) {
        if (value == "")
          value += listSplit[i].toString().split('').reversed.join();
        else
          value += "" + listSplit[i].toString().split('').reversed.join();
      } else {
        if (value == "")
          value += listSplit[i].toString().split('').reversed.join();
        else
          value += "" + listSplit[i].toString().split('').reversed.join();
      }
    }
  } catch (e) {
    return e.toString();
  }
  return value;
}
bool Check(String text) {
  var val = false;
  bool both = true;
  if (text.contains(RegExp(r'[A-Z,a-z]'))) {
    for (int i = 0; i < text.length;) {
      int c = text.codeUnitAt(i);
      if (c >= 0x0600 && c <= 0x06FF || (c >= 0xFE70 && c <= 0xFEFF)) {
        both = false;
        return both;
      } else {
        both = true;
        return both;
      }
    }
  } else {
    val = false;
    for (int i = 0; i < text.length; i++) {
      if (val = double.tryParse(text[i]) != null) {
        if (val == true) {
          both = false;
        } else {
          both = true;
        }
        return both;
      }
    }

    // both = true;
  }
  print('result of check $both');

  return both;
}
set(String str) {
  try {
    if (str == "") {}

    var listData = [];
    List<String> test = [];

    List<String> splitA = str.split('');
    test = returnBlankSpace(splitA.length);

    // test.length = splitA.length;

    if (str.contains('')) {
      for (int i = 0; i < splitA.length; i++) {
        test[i] = splitA[splitA.length - 1 - i];
        print(splitA);
      }
      splitA = test;
    }

    listData.length = splitA.length;
    bool ar = false;
    int index = 0;

    for (int i = 0; i < splitA.length; i++) {
      if (isArabic(splitA[i])) {
        if (ar) {
          if (listData[index] == null)
            listData[index] = splitA[i];
          else
            listData[index] += "" + splitA[i];
        } else {
          if (listData[index] == null)
            listData[index] = splitA[i];
          else {
            index++;
            listData[index] = splitA[i];
          }
        }
        ar = true;
      } else if (isEnglish(splitA[i])) {
        if (!ar) {
          if (listData[index] == null)
            listData[index] = splitA[i];
          else
            listData[index] += "" + splitA[i];
        } else {
          index++;
          listData[index] = splitA[i];
        }
        ar = false;
      } else if (isN(splitA[i])) {
        if (!ar) {
          if (listData[index] == null)
            listData[index] = splitA[i];
          else
            listData[index] += "" + splitA[i];
        } else {
          index++;
          listData[index] = splitA[i];
        }
        ar = false;
      }
    }

    return listData;
  } catch (e) {
    print("set function error ${e.toString()}");
  }
}
bool isArabic(String text) {
  if (text == "") {}

  String arabicText = text.trim().replaceAll(" ", "");
  for (int i = 0; i < arabicText.length;) {
    int c = arabicText.codeUnitAt(i);
    //range of arabic chars/symbols is from 0x0600 to 0x06ff
    //the arabic letter 'لا' is special case having the range from 0xFE70 to 0xFEFF
    if (c >= 0x0600 && c <= 0x06FF || (c >= 0xFE70 && c <= 0xFEFF))
      i++;
    else
      return false;
  }
  return true;
}
bool isEnglish(String text) {
  if (text == "") {}

  bool onlyEnglish = false;

  String englishText = text.trim().replaceAll(" ", "");
  if (englishText.contains(RegExp(r'[A-Z,a-z]'))) {
    onlyEnglish = true;
    print(onlyEnglish);
  } else {
    onlyEnglish = false;
    print(onlyEnglish);
  }
  return onlyEnglish;
}
bool isN(String value) {
  if (value == "") {
    print("str is nll");
  }
  var val = false;
  val = double.tryParse(value) != null;
  return val;
}
getBytes(int id, value) {
  if (value == "") {}
  int datas = value.length;
  Uint8List va = Uint8List(2 + datas);
  va[0] = id;
  va[1] = value.length;

  for (var i = 0; i < value.length; i++) {
    va[2 + i] = value[i];
  }
  return va;
}




class ProductDetailsModel {
  final String unitName, qty, netAmount,flavourName, productName, unitPrice, productDescription;

  ProductDetailsModel({
    required this.unitName,
    required this.qty,
    required this.netAmount,
    required this.productName,
    required this.unitPrice,
    required this.productDescription,
    required this.flavourName,
  });

  factory ProductDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductDetailsModel(
      unitName: json['UnitName'],
      qty: json['quantityRounded'].toString(),
      netAmount: json['netAmountRounded'].toString(),
      productName: json['ProductName'],
      unitPrice: json['unitPriceRounded'].toString(),
      productDescription: json['ProductDescription'],
      flavourName: json['flavour_name']??"",
    );
  }
}