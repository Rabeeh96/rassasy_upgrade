import 'dart:convert';
import 'package:image/image.dart' as Img;
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/Print/html_kot.dart';
import 'package:rassasy_new/Print/qr_generator.dart';
import 'package:rassasy_new/new_design/dashboard/pos/new_method/model/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webcontent_converter/webcontent_converter.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;

class USBPrintClass {
  List<ProductDetailsModel> printDalesDetails = [];

  printDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return 1;
    } else {
      try {
        printDalesDetails.clear();
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
        print(accessToken);
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

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));

        var status = n["StatusCode"];
        var responseJson = n["data"];

        if (status == 6000) {
          stop();

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
          BluetoothPrintThermalDetails.bankReceived = responseJson["BankAmount"].toString() ?? "0";
          BluetoothPrintThermalDetails.balance = responseJson["Balance"].toString() ?? "";
          BluetoothPrintThermalDetails.salesType = responseJson["OrderType"] ?? "";
          BluetoothPrintThermalDetails.salesDetails = responseJson["SalesDetails"];
          BluetoothPrintThermalDetails.totalVATAmount = responseJson["VATAmount"];
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
          // BluetoothPrintThermalDetails.descriptionCompany= companyDetails["Description"]?? '';
          BluetoothPrintThermalDetails.countryNameCompany = companyDetails["CountryName"] ?? '';
          BluetoothPrintThermalDetails.stateNameCompany = companyDetails["StateName"] ?? '';
          BluetoothPrintThermalDetails.companyLogoCompany = companyDetails["CompanyLogo"] ?? '';
          BluetoothPrintThermalDetails.countyCodeCompany = companyDetails["CountryCode"] ?? '';
          BluetoothPrintThermalDetails.buildingNumberCompany = companyDetails["Address1"] ?? '';
          BluetoothPrintThermalDetails.tableName = responseJson["TableName"];
          BluetoothPrintThermalDetails.time = responseJson["CreatedDate"];
          BluetoothPrintThermalDetails.currency = currency;
          print("-------------  everything is fine-------------  ");
          return 2;
        } else if (status == 6001) {
          stop();
          return 3;
        }

        //DB Error
        else {
          stop();
          return 3;
        }
      } catch (e) {
        stop();
        return 3;
      }
    }
  }


  printReq() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP864');

    Uint8List salam = await CharsetConverter.encode("ISO-8859-6", 'السلام عليكم صباح الخير عزيزتي جميعاً');
    bytes += generator.textEncoded(salam);
    bytes += generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, "POS-80C");
    String msg = "";

    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

    print(msg);
  }
  /// print order and invoice
  void printReceipt(String printerIp, BuildContext ctx) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString("template") ?? "template4";
    var capabilities = prefs.getString("default_capabilities") ?? "default";
    var hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
    var paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
    var headerAlignment = prefs.getBool("headerAlignment") ?? false;
    var salesMan = prefs.getString("user_name") ?? '';
    var OpenDrawer = prefs.getBool("OpenDrawer") ?? false;
    var timeInPrint = prefs.getBool("time_in_invoice") ?? false;
    var hideTaxDetails = prefs.getBool("hideTaxDetails") ?? false;
    print("---------------------------------OpenDrawer-------------------------------$printerIp--------------$OpenDrawer");

    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;

    var profile;
    if (capabilities == "default") {
      profile = await CapabilityProfile.load();
    } else {
      profile = await CapabilityProfile.load(name: capabilities);
    }

      if (temp == 'template4') {
        await invoicePrintTemplate4(printerIp,profile,hilightTokenNumber, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint,hideTaxDetails);
      } else if (temp == 'template3') {
        await invoicePrintTemplate3(printerIp,profile,hilightTokenNumber, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint,hideTaxDetails);
      } else {

      }

  }





  // void printDailyReceipt(String printerIp, BuildContext ctx) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var temp = prefs.getString("template") ?? "template4";
  //   var capabilities = prefs.getString("default_capabilities") ?? "default";
  //   var hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
  //   var paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
  //   var headerAlignment = prefs.getBool("headerAlignment") ?? false;
  //   var salesMan = prefs.getString("user_name") ?? '';
  //   var OpenDrawer = prefs.getBool("OpenDrawer") ?? false;
  //   var timeInPrint = prefs.getBool("time_in_invoice") ?? false;
  //   print("---------------------------------OpenDrawer-------------------------------$printerIp--------------$OpenDrawer");
  //
  //   // TODO Don't forget to choose printer's paper size
  //   const PaperSize paper = PaperSize.mm80;
  //
  //   var profile_mobile;
  //   if (capabilities == "default") {
  //     profile_mobile = await CapabilityProfile.load();
  //   } else {
  //     profile_mobile = await CapabilityProfile.load(name: capabilities);
  //   }
  //
  //     if (temp == 'template4') {
  //       await invoicePrintTemplate4(printerIp,profile_mobile,hilightTokenNumber, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint);
  //     } else if (temp == 'template3') {
  //       await invoicePrintTemplate3(printerIp,profile_mobile,hilightTokenNumber, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint);
  //     } else {
  //
  //     }
  //
  // }

  Future<Uint8List> _fetchImageData(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }



  Future<void> invoicePrintTemplate4(defaultIP,profile,tokenVal, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint,hideTaxDetails) async {
    List<int> bytes = [];
    final generator = Generator(PaperSize.mm80, profile);
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
    var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
    var qrCodeData = BluetoothPrintThermalDetails.qrCodeImage;

    var voucherNumber = BluetoothPrintThermalDetails.voucherNumber;
    var customerName = BluetoothPrintThermalDetails.ledgerName;
    print("________________LedgerName   ${BluetoothPrintThermalDetails.ledgerName}");
    print("________________customerName     ${BluetoothPrintThermalDetails.customerName}");

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

    var token = BluetoothPrintThermalDetails.tokenNumber;

    var cashReceived = BluetoothPrintThermalDetails.cashReceived;
    var bankReceived = BluetoothPrintThermalDetails.bankReceived;
    var balance = BluetoothPrintThermalDetails.balance;
    var orderType = BluetoothPrintThermalDetails.salesType;
    var tableName = BluetoothPrintThermalDetails.tableName;


    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));

    if (PrintDataDetails.type == "SI") {
      if (companyLogo != "") {
        final Uint8List imageData = await _fetchImageData(companyLogo);
        final Img.Image? image = Img.decodeImage(imageData);
        final Img.Image resizedImage = Img.copyResize(image!, width: 200);
        bytes +=generator.imageRaster(resizedImage);
        //   bytes +=generator.image(resizedImage);
      }
    }

    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
    Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName));





    Uint8List companyTaxEnc = await CharsetConverter.encode("ISO-8859-6", setString('ضريبه  ' + companyTax));
    Uint8List companyCREnc = await CharsetConverter.encode("ISO-8859-6", setString('س. ت  ' + companyCrNumber));
    Uint8List companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone));
    Uint8List salesManDetailsEnc = await CharsetConverter.encode("ISO-8859-6", setString('رجل المبيعات ' + salesMan));

    if (headerAlignment) {
      companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyPhone));
    }

    Uint8List invoiceTypeEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
    Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));

    Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
    Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
    Uint8List exciseTax = await CharsetConverter.encode("ISO-8859-6", setString('مبلغ الضريبة الانتقائية'));
    Uint8List vatTax = await CharsetConverter.encode("ISO-8859-6", setString('ضريبة القيمة المضافة'));
    Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('خصم'));
    Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));

    Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
    Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
    Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));

    if (headerAlignment) {
      bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
      if (companyName != "") {
        bytes +=generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }
      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));

        bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
        bytes +=generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));

       }

      if (buildingDetails != "") {
        Uint8List buildingDetailsEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));
        bytes +=generator.row([
          PosColumn(text: 'Building', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1),
          PosColumn(
              textEncoded: buildingDetailsEncode,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);

       }

      if (streetName != "") {

        Uint8List streetNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));

        bytes +=generator.row([
          PosColumn(text: 'Street ', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: streetNameEncode,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);

       }

      if (companyTax != "") {
        bytes +=generator.row([
          PosColumn(text: 'Vat Number', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyTaxEnc,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
       }

      if (companyPhone != "") {
        bytes +=generator.row([
          PosColumn(text: 'Phone', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyPhoneEnc,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
        //  bytes +=generator.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (salesMan != "") {
        bytes +=generator.row([
          PosColumn(text: 'Sales man', width: 2, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: salesManDetailsEnc,
              width: 9,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
        //  bytes +=generator.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }
    } else {
      if (companyName != "") {
        bytes +=generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }

      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));

        bytes +=generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (buildingDetails != "") {
        Uint8List secondAddress1Encode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));
        bytes +=generator.textEncoded(secondAddress1Encode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (streetName != "") {
        Uint8List streetEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));

        bytes +=generator.textEncoded(streetEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (companyTax != "") {
        bytes +=generator.textEncoded(companyTaxEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }
      if (companyCrNumber != "") {
        bytes +=generator.textEncoded(companyCREnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
      }

      if (companyPhone != "") {
        bytes +=generator.textEncoded(companyPhoneEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (salesMan != "") {
        bytes +=generator.textEncoded(salesManDetailsEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }
    }

    bytes +=generator.emptyLines(1);

    bytes +=generator.textEncoded(invoiceTypeEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size2, align: PosAlign.center));
    bytes +=generator.textEncoded(invoiceTypeArabicEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size2, align: PosAlign.center));

    var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
    Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
    Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
    Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
    Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
    Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));
    Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
    Uint8List tableEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));


    if (tokenVal) {
      bytes +=generator.hr();
      bytes +=generator.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
      bytes +=generator.text(token, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
      bytes +=generator.textEncoded(tokenEnc, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      bytes +=generator.hr();
    } else {
      bytes +=generator.row([
        PosColumn(text: 'Token No ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tokenEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: token, width: 6, styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    bytes +=generator.row([
      PosColumn(text: 'Voucher No  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: voucherNoEnc,
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: voucherNumber, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);

    bytes +=generator.row([
      PosColumn(text: 'Date  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: dateEnc,
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: date, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);


    if (customerName != "") {

      Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName));

      bytes +=generator.row([
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

      Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));

      bytes +=generator.row([
        PosColumn(text: 'Phone    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: phoneEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            textEncoded: phoneNoEncoded,
            width: 6,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }

    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));
    bytes +=generator.row([
      PosColumn(text: 'Order type    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(textEncoded: typeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: orderType, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    ]);

    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));

    if (tableName != "") {
      bytes +=generator.row([
        PosColumn(text: 'Table Name   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: tableEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: tableName, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }
    if (timeInPrint) {
      var time = BluetoothPrintThermalDetails.time;

      String timeInvoice = convertToSaudiArabiaTime(time,countyCodeCompany);
      Uint8List timeEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

      bytes +=generator.row([
        PosColumn(text: 'Time   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: timeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: timeInvoice, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }
    bytes +=generator.hr();

    Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
    Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
    Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString(" الكمية "));
    Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
    Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));

    bytes +=generator.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: 'Item Name', width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(text: 'Qty', width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(text: 'Rate', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: 'Net', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    bytes +=generator.row([
      PosColumn(
          textEncoded: slNoEnc,
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
            fontType: PosFontType.fontA,
          )),
      PosColumn(textEncoded: productNameEnc, width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(textEncoded: qtyEnc, width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(textEncoded: rateEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(textEncoded: netEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    bytes +=generator.hr();

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var slNo = i + 1;

      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName));

      bytes +=generator.row([
        PosColumn(
            text: "$slNo",
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(textEncoded: productName, width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: tableDataDetailsPrint[i].qty, width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: tokenVal)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
            width: 2,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].netAmount),
            width: 3,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);



      String productDescription =tableDataDetailsPrint[i].productDescription;

      if(productDescription!=""){
        Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription));
        bytes +=generator.row([
          PosColumn(
              textEncoded: description, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(
              text: '',
              width: 5,
              styles: const PosStyles(
                height: PosTextSize.size1,
              ))
        ]);
      }



      bytes +=generator.hr();
    }
    bytes +=generator.emptyLines(1);
    bytes +=generator.row([
      PosColumn(text: 'Gross Amount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: ga,
          width: 4,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(grossAmount), width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);



    if(hideTaxDetails){

      if (showExcise) {
        bytes +=generator.row([
          PosColumn(text: 'Total Excise Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: exciseTax,
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(text: roundStringWith(exciseAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]);
        bytes +=generator.row([
          PosColumn(text: 'Total VAT', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: vatTax,
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(text: roundStringWith(vatAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }


      bytes +=generator.row([
        PosColumn(text: 'Total Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tt,
            width: 4,
            styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: roundStringWith(totalTax), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]);

    }

    bytes +=generator.row([
      PosColumn(text: 'Discount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: dis,
          width: 4,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(discount), width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);
    // bytes +=generator.setStyles(PosStyles.defaults());

    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: 'Grand Total',
          width: 3,
          styles: const PosStyles(
            bold: true,
            fontType: PosFontType.fontB,
            height: PosTextSize.size2,
          )),
      PosColumn(
          textEncoded: gt,
          width: 3,
          styles:
          const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right, bold: true)),
      PosColumn(
          text: "$countyCodeCompany ${roundStringWith(grandTotal)}",
          width: 6,
          styles: const PosStyles(
            fontType: PosFontType.fontA,
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
    ]);
    bytes +=generator.hr();
    if (PrintDataDetails.type == "SI") {
      if (paymentDetailsInPrint) {
        bytes +=generator.row([
          PosColumn(text: 'Cash receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: cr,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(cashReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);

        bytes +=generator.row([
          PosColumn(text: 'Bank receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: br,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(bankReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);

        bytes +=generator.row([
          PosColumn(text: 'Balance', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: bl,
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(balance), width: 3, styles: const PosStyles(align: PosAlign.right)),
        ]);
      }
    }

    if (qrCodeAvailable) {
      bytes +=generator.feed(1);
      var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
          BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
      bytes +=generator.qrcode(qrCode, size: QRSize.Size5);
    }
    // bytes +=generator.emptyLines(1);
    // bytes +=generator.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));

    bytes +=generator.cut();
    if (PrintDataDetails.type == "SI") {
      if (OpenDrawer) {
        bytes +=generator.drawer();
      }
    }

    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, defaultIP);
    String msg = "";


    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

  }

  Future<void> invoicePrintTemplate3(defaultIP,profile,tokenVal, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint,hideTaxDetails) async {

    try{
      List<int> bytes = [];
      print("-------------------------------------------- Start ");
      final generator = Generator(PaperSize.mm80, profile);
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

      invoiceType = "SIMPLIFIED TAX INVOICE";

      if (PrintDataDetails.type == "SI") {
        invoiceType = "SIMPLIFIED TAX INVOICE";
      }
      if (PrintDataDetails.type == "SO") {
        logoAvailable = false;
        qrCodeAvailable = false;
        productDecBool = false;
        invoiceType = "SALES ORDER";
      }

      var companyName = BluetoothPrintThermalDetails.companyName;
      var buildingDetails = BluetoothPrintThermalDetails.buildingNumber;
      var streetName = BluetoothPrintThermalDetails.streetName;
      var companySecondName = BluetoothPrintThermalDetails.secondName;
      var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
      var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
      var companyTax = BluetoothPrintThermalDetails.companyGstNumber;

      var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
      print("-------------------------------------------- Start ");

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
      var sGstAmount = roundStringWith(BluetoothPrintThermalDetails.sGstAmount);
      var cGstAmount = roundStringWith(BluetoothPrintThermalDetails.cGstAmount);
      var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
      var vatAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalVATAmount);
      var exciseAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalExciseAmount);
      bool showExcise = double.parse(exciseAmountTotal) > 0.0 ? true : false;
      var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
      var token = BluetoothPrintThermalDetails.tokenNumber;

      var cashReceived = BluetoothPrintThermalDetails.cashReceived;
      var bankReceived = BluetoothPrintThermalDetails.bankReceived;
      var balance = BluetoothPrintThermalDetails.balance;
      var orderType = BluetoothPrintThermalDetails.salesType;
      var tableName = BluetoothPrintThermalDetails.tableName;

      //
      /// image print commented

      bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));
      if (PrintDataDetails.type == "SI") {
        if (companyLogo != "") {
          final Uint8List imageData = await _fetchImageData(companyLogo);
          final Img.Image? image = Img.decodeImage(imageData);
          final Img.Image resizedImage = Img.copyResize(image!, width: 200);
          bytes +=generator.imageRaster(resizedImage);
          //bytes +=generator.image(resizedImage);
        }
      }

      bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

      if (headerAlignment) {
        bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
        if (companyName != "") {
          bytes +=generator.text(companyName,
              styles: const PosStyles(
                  height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
        }
        if (companySecondName != "") {
          bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
          bytes +=generator.text(companySecondName,
              styles: const PosStyles(
                  height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
        }

        if (buildingDetails != "") {
          bytes +=generator.row([
            PosColumn(text: 'Building', width: 2, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: '', width: 1),
            PosColumn(
                text: buildingDetails, width: 9, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          ]);
        }

        if (streetName != "") {
          bytes +=generator.row([
            PosColumn(text: 'Street', width: 3, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                text: streetName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          ]);
        }

        if (companyTax != "") {
          bytes +=generator.row([
            PosColumn(text: 'GST No  ', width: 2, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                text: companyTax,
                width: 9,
                styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          ]);
        }

        if (companyPhone != "") {
          bytes +=generator.row([
            PosColumn(text: 'Phone', width: 2, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                text:  companyPhone,
                width: 9,
                styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          ]);
        }

        if (salesMan != "") {
          bytes +=generator.row([
            PosColumn(text: 'Sales man', width: 4, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
            PosColumn(text: salesMan, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          ]);
        }
      } else {
        if (companyName != "") {
          bytes +=generator.text(companyName,
              styles: const PosStyles(
                  height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
        }

        if (companySecondName != "") {
          bytes +=generator.text(companySecondName, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
        }

        if (buildingDetails != "") {
          bytes +=generator.text(buildingDetails, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
        }

        if (streetName != "") {
          bytes +=generator.text(streetName, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
        }
        if (companyTax != "") {
          bytes +=generator.text("GST NO:$companyTax", styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
        }
        if (companyPhone != "") {
          bytes +=generator.text(companyPhone, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
        }

      }

      bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
      bytes +=generator.text(invoiceType, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));

      if (tokenVal) {
        bytes +=generator.hr();
        bytes +=generator.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
        bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
        bytes +=generator.text(token, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
        bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
        bytes +=generator.text("Token Number", styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
        bytes +=generator.hr();
      } else {
        bytes +=generator.row([
          PosColumn(
              text: 'Token No ',
              width: 4,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )
          ),
          PosColumn(
              text: token,
              width: 8,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              )),
        ]);
      }

      bytes +=generator.row([
        PosColumn(
            text: 'Voucher No  ',
            width: 4,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: voucherNumber,
            width: 8,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right,
            )),
      ]);

      bytes +=generator.row([
        PosColumn(
            text: 'Date  ',
            width: 4,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: date,
            width: 8,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right,
            )),
      ]);

      if (customerName != "") {
        bytes +=generator.row([
          PosColumn(
              text: 'Name  ',
              width: 4,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: customerName,
              width: 8,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              )),
        ]);
      }
      if (customerPhone != "") {
        bytes +=generator.row([
          PosColumn(
              text: 'Phone  ',
              width: 4,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: customerPhone,
              width: 8,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              )),
        ]);
      }

      bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));
      bytes +=generator.row([
        PosColumn(
            text: 'Order type  ',
            width: 4,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: orderType,
            width: 8,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right,
            )),
      ]);

      bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));

      if (tableName != "") {
        bytes +=generator.row([
          PosColumn(
              text: 'Table Name  ',
              width: 4,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: tableName,
              width: 8,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              )),
        ]);
      }
      if (timeInPrint) {
        var time = BluetoothPrintThermalDetails.time;

        String timeInvoice = convertToSaudiArabiaTime(time,countyCodeCompany);
        Uint8List timeEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

        bytes +=generator.row([
          PosColumn(text: 'Time   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
          PosColumn(
              textEncoded: timeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(text: timeInvoice, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        ]);
      }

      print("-------------------------------------------- Start ");
      if (salesMan != "") {
        bytes +=generator.row([
          PosColumn(
              text: 'Sales man  ',
              width: 4,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
              )),
          PosColumn(
              text: salesMan,
              width: 8,
              styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right,
              )),
        ]);
      }



      bytes +=generator.emptyLines(1);
      bytes +=generator.hr();

      bytes +=generator.row([
        PosColumn(
            text: 'SL',
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(text: 'Item Name', width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Qty', width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Rate', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: 'Net', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      bytes +=generator.hr();

      for (var i = 0; i < tableDataDetailsPrint.length; i++) {
        var slNo = i + 1;

        bytes +=generator.row([
          PosColumn(
              text: "$slNo",
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(text: tableDataDetailsPrint[i].productName, width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
          PosColumn(text: roundStringWith(tableDataDetailsPrint[i].qty), width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: tokenVal)),
          PosColumn(
              text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
              width: 2,
              styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
          PosColumn(
              text: roundStringWith(tableDataDetailsPrint[i].netAmount),
              width: 3,
              styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
        ]);

        if (tableDataDetailsPrint[i].productDescription != "") {
          bytes +=generator.row([
            PosColumn(
                text: '',
                width: 1,
                styles: const PosStyles(
                  height: PosTextSize.size1,
                )),
            PosColumn(
                text: tableDataDetailsPrint[i].productDescription,
                width: 11,
                styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),

          ]);
        }

        bytes +=generator.hr();
      }
      bytes +=generator.emptyLines(1);
      bytes +=generator.row([

        PosColumn(
            text: "Gross Amount",
            width: 5,
            styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
        PosColumn(text: roundStringWith(grossAmount), width: 7, styles: const PosStyles(align: PosAlign.right)),
      ]);

      if(hideTaxDetails){

        bytes +=generator.row([

          PosColumn(
              text: "SGST ",
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(sGstAmount), width: 7, styles: const PosStyles(align: PosAlign.right)),
        ]);

        bytes +=generator.row([

          PosColumn(
              text: "CGST",
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(cGstAmount), width: 7, styles: const PosStyles(align: PosAlign.right)),
        ]);

        bytes +=generator.row([

          PosColumn(
              text: " ",
              width: 8,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: "---------", width: 4, styles: const PosStyles(align: PosAlign.right)),
        ]);



        bytes +=generator.row([

          PosColumn(
              text: "Total Tax",
              width: 5,
              styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
          PosColumn(text: roundStringWith(totalTax), width: 7, styles: const PosStyles(align: PosAlign.right)),
        ]);


      }




      bytes +=generator.row([

        PosColumn(
            text: "Discount",
            width: 5,
            styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
        PosColumn(text: roundStringWith(discount), width: 7, styles: const PosStyles(align: PosAlign.right)),
      ]);

      bytes +=generator.hr();
      bytes +=generator.row([
        PosColumn(
            text: "Grand Total",
            width: 6,
            styles: const PosStyles(
              fontType: PosFontType.fontA,
              bold: true,
              align: PosAlign.left,
              height: PosTextSize.size2,
              width: PosTextSize.size1,
            )),
        PosColumn(
            text: "$countyCodeCompany ${roundStringWith(grandTotal)}",
            width: 6,
            styles: const PosStyles(
              fontType: PosFontType.fontA,
              bold: true,
              align: PosAlign.right,
              height: PosTextSize.size2,
              width: PosTextSize.size1,
            )),
      ]);
      bytes +=generator.hr();
      if (PrintDataDetails.type == "SI") {
        if (paymentDetailsInPrint) {
          bytes +=generator.row([
            PosColumn(
                text: "Cash receipt",
                width: 5,
                styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
            PosColumn(text: roundStringWith(cashReceived), width: 7, styles: const PosStyles(align: PosAlign.right)),
          ]);

          bytes +=generator.row([
            PosColumn(
                text: "Bank receipt",
                width: 5,
                styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
            PosColumn(text: roundStringWith(bankReceived), width: 7, styles: const PosStyles(align: PosAlign.right)),
          ]);

          bytes +=generator.row([
            PosColumn(
                text: "Balance",
                width: 5,
                styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
            PosColumn(text: roundStringWith(balance), width: 7, styles: const PosStyles(align: PosAlign.right)),
          ]);
          bytes +=generator.hr();

        }
      }

      bytes +=generator.cut();
      if (PrintDataDetails.type == "SI") {
        if (OpenDrawer) {
          bytes +=generator.drawer();
        }
      }

      print("-------------------------------------------- Start $bytes");
      final res = await usb_esc_printer_windows.sendPrintRequest(bytes, defaultIP);
      print(res);
      String msg = "";

      if (res == "success") {
        msg = "Printed Successfully";
      } else {
        msg = "Failed to generate a print please make sure to use the correct printer name";
      }
    }
    catch(e){
      print("error in ${e.toString()}");
    }

  }

  printKotPrint(var id, rePrint, cancelOrder, isUpdate) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        printListData.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        final String url = '$baseUrl/posholds/kitchen-print/';
        print(url);
        print(accessToken);
        Map data = {
          "OrderID": id,
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "KitchenPrint": rePrint,
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
        var responseJson = n["final_data"];

        print(responseJson);
        if (status == 6000) {
          dataPrint.clear();
          printListData.clear();
          List<PrintDetails> printListDataCancel = [];
          for (Map user in responseJson) {
            printListData.add(PrintDetails.fromJson(user));
          }

          for (Map user in cancelOrder) {
            printListDataCancel.add(PrintDetails.fromJson(user));
          }

          for (var i = 0; i < printListData.length; i++) {
            try {
              print('------------------ index $i');
              dataPrint.clear();
              await kotPrintConnect(printListData[i].ip, i, printListData[i].items, false, isUpdate);
              await Future.delayed(const Duration(seconds: 1)); // Add a delay between print jobs
            } catch (e) {
              print('log ${e.toString()}');
              print(e.toString());
            }
          }
          /// cancel order print
          for (var i = 0; i < cancelOrder.length; i++) {
            try {
              print('------------------ index $i');
              dataPrint.clear();
              await kotPrintConnect(printListDataCancel[i].ip, i, printListDataCancel[i].items, true, false);
              await Future.delayed(const Duration(seconds: 1)); // Add a delay between print jobs
            } catch (e) {
              print('log ${e.toString()}');
              print(e.toString());
            }
          }


        } else if (status == 6001) {
          stop();
          var errorMessage = n["message"];
          // Alert(message: errorMessage);
        }

        //DB Error
        else {
          //  Alert(message: "Some Network Error");
          stop();
        }
      } catch (e) {}
    }
  }

  // printKotPrintRe(id) async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //   } else {
  //     try {
  //       printListData.clear();
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       String baseUrl = BaseUrl.baseUrl;
  //       var userID = prefs.getInt('user_id') ?? 0;
  //       var accessToken = prefs.getString('access') ?? '';
  //       var companyID = prefs.getString('companyID') ?? 0;
  //       var branchID = prefs.getInt('branchID') ?? 1;
  //
  //       final String url = '$baseUrl/posholds/kitchen-print/';
  //       print(url);
  //       Map data = {
  //         "OrderID": id,
  //         "CompanyID": companyID,
  //         "CreatedUserID": userID,
  //         "BranchID": branchID,
  //         "is_test": false,
  //         "KitchenPrint": true,
  //       };
  //
  //       print(data);
  //       //encode Map to JSON
  //       var body = json.encode(data);
  //
  //       var response = await http.post(Uri.parse(url),
  //           headers: {
  //             "Content-Type": "application/json",
  //             'Authorization': 'Bearer $accessToken',
  //           },
  //           body: body);
  //
  //       print("${response.statusCode}");
  //       print("${response.body}");
  //
  //       Map n = json.decode(utf8.decode(response.bodyBytes));
  //       var status = n["StatusCode"];
  //       var responseJson = n["final_data"];
  //       var tableName = "";
  //       print(responseJson);
  //       if (status == 6000) {
  //         dataPrint.clear();
  //         printListData.clear();
  //         for (Map user in responseJson) {
  //           printListData.add(PrintDetails.fromJson(user));
  //         }
  //
  //         for (var i = 0; i < printListData.length; i++) {
  //           try {
  //             print('------------------ index $i');
  //             dataPrint.clear();
  //             await kotPrintConnect(printListData[i].ip, i, printListData[i].items);
  //           } catch (e) {
  //             print(e.toString());
  //           }
  //         }
  //       } else if (status == 6001) {
  //         stop();
  //         var errorMessage = n["message"];
  //         // Alert(message: errorMessage);
  //       }
  //
  //       //DB Error
  //       else {
  //         //  Alert(message: "Some Network Error");
  //         stop();
  //       }
  //     } catch (e) {}
  //   }
  // }

  Future<void> kotPrintConnect(String printerIp, id, items, bool isCancelNote, isUpdate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var temp = prefs.getString("template") ?? "template4";
      var capabilities = prefs.getString("default_capabilities") ?? "default";

      print("template =---------------------- $temp");
      var profile;
      if (capabilities == "default") {
        profile = await CapabilityProfile.load();
      } else {
        profile = await CapabilityProfile.load(name: capabilities);
      }

      if (temp == 'template4') {
          await kotPrint(printerIp,profile, id, items, isCancelNote, isUpdate);
        }
        else if (temp == 'template3') {
          await kotPrintGst(printerIp,profile, id, items, isCancelNote, isUpdate);
        }


    } catch (e) {
      print('------------------------------${e.toString()}');
    }
  }

  /// Direct text method
  Future<void> kotPrint(printerAddress,profile,id, items, bool isCancelNote, isUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userName = prefs.getString('user_name')??"";
    bool showUsernameKot = prefs.getBool('show_username_kot')??false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot')??false;
    var currentTime = DateTime.now();
    List<int> bytes = [];

    final generator = Generator(PaperSize.mm80, profile);
    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();

    for (Map user in items) {
      dataPrint.add(ItemsDetails.fromJson(user));
    }
    var kitchenName ="";
    var totalQty = dataPrint[0].qty;
    if(printListData.isNotEmpty){
      kitchenName = printListData[id].kitchenName??"";
      totalQty = printListData[id].totalQty;
    }


    var tableName = dataPrint[0].tableName;

    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI ?? "";

    bytes +=generator.setStyles(const PosStyles.defaults());
    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));

    var cancelNoteArabic = "تم إلغاء هذا العنصر من قبل العميل.";
    var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";

    var updateNoteArabic = "تم إجراء بعض التغييرات في";
    var updateNote = "MADE SOME CHANGES IN";

    Uint8List cancelNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(cancelNoteArabic));
    Uint8List updateNoteEnc = await CharsetConverter.encode("ISO-8859-6", setString(updateNoteArabic));

    var invoiceType = "KOT";
    var invoiceTypeArabic = "(طباعة المطب";

    Uint8List typeEng = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
    Uint8List typeArabic = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    bytes +=generator.textEncoded(typeEng, styles:
        const PosStyles(height: PosTextSize.size3, width: PosTextSize.size5, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.left));
    bytes +=generator.textEncoded(typeArabic,
        styles:
        const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    if (isCancelNote) {
      bytes +=generator.text(cancelNoteData,
          styles:
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
      bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.left));
      bytes +=generator.textEncoded(cancelNoteEnc,
          styles:
          const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    }
    print("-----3");
    if (isUpdate) {
      bytes +=generator.text(updateNote,
          styles:
          const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
      bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.left));
      bytes +=generator.textEncoded(updateNoteEnc,
          styles:
          const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    }

    Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
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
    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));
    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: 'SL',
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Product Name',
          width: 8,
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


      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(dataPrint[i].productName));

      print("-----5.7");
      bytes +=generator.row([
        PosColumn(
            text: '$slNo',
            width: 2,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(textEncoded: productName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: dataPrint[i].qty, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (productDescription != "") {
        Uint8List productDescriptionEnc = await CharsetConverter.encode("ISO-8859-6", setString(productDescription));
        bytes +=generator.textEncoded(productDescriptionEnc,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (dataPrint[i].flavour != "") {
        Uint8List flavour = await CharsetConverter.encode("ISO-8859-6", setString(dataPrint[i].flavour));
        bytes +=generator.textEncoded(flavour, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }
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
    print("-----8   $printerAddress");
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, printerAddress);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }
  }
  /// Direct text method for Gst company
  Future<void> kotPrintGst(printerAddress,profile, id, items, bool isCancelNote, isUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userName = prefs.getString('user_name')??"";
    bool showUsernameKot = prefs.getBool('show_username_kot')??false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot')??false;
    var currentTime = DateTime.now();
    List<int> bytes = [];
    final generator = Generator(PaperSize.mm80, profile);
    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();

    for (Map user in items) {
      dataPrint.add(ItemsDetails.fromJson(user));
    }

    var kitchenName = printListData[id].kitchenName;
    var tableName = dataPrint[0].tableName;
    var totalQty = printListData[id].totalQty;
    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI ?? "";


    var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";
    var updateNote = "MADE SOME CHANGES IN";
    var invoiceType = "KOT";
    bytes +=generator.text(invoiceType, styles: const PosStyles(height: PosTextSize.size3, width: PosTextSize.size5, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    if (isCancelNote) {
      bytes +=generator.text(cancelNoteData, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));

    }

    if (isUpdate) {
      bytes +=generator.text(updateNote, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontB, bold: true));
    }


    bytes +=generator.hr();
    bytes +=generator.text('Token No', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
    bytes +=generator.text(tokenNumber, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
    bytes +=generator.hr();

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
      PosColumn(text: 'Kitchen name     :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: kitchenName, width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    bytes +=generator.row([
      PosColumn(text: 'Order type       :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: orderType, width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    if (orderType == "Dining") {
      bytes +=generator.row([
        PosColumn(text: 'Table Name       :', width: 4, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: tableName, width: 8, styles: const PosStyles(fontType: PosFontType.fontA,height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }

    // bytes +=generator.setStyles(const PosStyles.defaults());
    // bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864'));
    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: 'SL',
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Product Name',
          width: 8,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    bytes +=generator.hr();

    for (var i = 0; i < dataPrint.length; i++) {
      var slNo = i + 1;

      var productDescription = dataPrint[i].productDescription;

      bytes +=generator.row([
        PosColumn(
            text: '$slNo',
            width: 2,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(text: dataPrint[i].productName, width: 8, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: roundStringWith(dataPrint[i].qty), width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (productDescription != "") {
        bytes +=generator.row([
          PosColumn(
              text: '',
              width: 2,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(text: productDescription, width: 10, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        ]);


      }

      if (dataPrint[i].flavour != "") {
        bytes +=generator.text (dataPrint[i].flavour, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }
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
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, printerAddress);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }
  }


  Future<void> printDailyReport(printerAddress,profile, id, items, bool isCancelNote, isUpdate) async {




    List<int> bytes = [];
    final generator = Generator(PaperSize.mm80, profile);

    var fromTime = "25-02-2024 to 16-02-2036";
    var userName = "Rabeeh";
    var invoiceType = "DAILY REPORT";
    var grossAmount = "13233";
    var discount = "100";
    var totalTax = "36";
    var grandTotal = "15452";

    var grossAmountSale = "13233";
    var discountSale = "100";
    var totalTaxSale = "36";
    var grandTotalSale = "15452";
    var noOfOrders = "10";
    var ordersAmount = "1524";
    var noOfCanceled = "1524";
    var canceledAmount = "1524";
    var diningAmount = "500";
    var takeAwayAmount = "700";
    var carAmount = "350";
    var totalCashAmount = "12540";
    var totalBankAmount = "3500";
    var totalBankCredit = "500";




    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));

    bytes +=generator.text(invoiceType, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.hr();
    bytes +=generator.emptyLines(1);
    bytes +=generator.row([
      PosColumn(
          text: "User",
          width: 3,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: userName, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    bytes +=generator.row([
      PosColumn(
          text: "Date",
          width: 3,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(text: fromTime, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    bytes +=generator.hr();
    bytes +=generator.emptyLines(2);

    bytes +=generator.text("Sales Order", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.emptyLines(1);
    bytes +=generator.row([
      PosColumn(
          text: "Gross Amount",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(text: roundStringWith(grossAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Discount",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(discount),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Total Tax",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,

          )),
      PosColumn(
          text: roundStringWith(totalTax),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);

    bytes +=generator.hr();
    bytes +=generator.emptyLines(2);
    bytes +=generator.text("Order Details", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.emptyLines(1);


    bytes +=generator.row([
      PosColumn(
          text: "No of orders",
          width: 4,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(noOfOrders),
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(
          text: "Amount",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,

          )),
      PosColumn(
          text: roundStringWith(ordersAmount),
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "No of Canceled",
          width: 4,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(noOfCanceled),
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(
          text: "Amount",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(canceledAmount),
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);




    bytes +=generator.hr(ch: "=");
    bytes +=generator.emptyLines(2);

    bytes +=generator.text("Effective sale", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.emptyLines(1);
    bytes +=generator.row([
      PosColumn(
          text: "Gross Amount",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(text: roundStringWith(grossAmountSale), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,   align: PosAlign.right)),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Discount",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(discountSale),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Total Tax",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(totalTaxSale),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,   align: PosAlign.right
          )),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Grand total",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(grandTotalSale),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);


    bytes +=generator.hr(ch: "=");
    bytes +=generator.emptyLines(2);
    bytes +=generator.text("Sale by type", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.emptyLines(1);
    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: "Type",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
            bold: true,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "Amount",
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              bold: true,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.hr();
    bytes +=generator.row([
      PosColumn(
          text: "Dining",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(diningAmount),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);

    bytes +=generator.row([
      PosColumn(
          text: "Take away",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(takeAwayAmount),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Online",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: roundStringWith(carAmount),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    bytes +=generator.hr(ch: "=");
    bytes +=generator.emptyLines(2);
    bytes +=generator.text("Total revenue", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    bytes +=generator.emptyLines(1);
    bytes +=generator.row([
      PosColumn(
          text: "Total Cash",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(text: roundStringWith(totalCashAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,   align: PosAlign.right)),
    ]);
    bytes +=generator.row([
      PosColumn(
          text: "Total Bank",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(text: roundStringWith(totalBankAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,   align: PosAlign.right)),
    ]);    bytes +=generator.row([
      PosColumn(
          text: "Total Credit",
          width: 5,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: "",
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(text: roundStringWith(totalBankCredit), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,   align: PosAlign.right)),
    ]);


    bytes +=generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, printerAddress);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }
  }



  Future<void> reportPrint({required printerIP,required capabilities,required details,required date,
    required template,
    required invoiceType,
    required totalCash,
    required totalBank,
    required totalCredit,
    required totalGrand,

  }) async {


    List<int> bytes = [];
    var profile;
    if (capabilities == "default") {
      profile = await CapabilityProfile.load();
    } else {
      profile = await CapabilityProfile.load(name: capabilities);
    }
    final generator = Generator(PaperSize.mm80, profile);
    bytes +=generator.setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));
    bytes +=generator.text(date, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center,bold: true));
    if(invoiceType == "Sales report"||invoiceType == "Dining report"||invoiceType == "TakeAway report"||invoiceType == "Car report"||invoiceType == "TableWise report"){
      bytes +=generator.hr();
      bytes +=generator.row([
        PosColumn(
            text: 'SL',
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: 'Date',
            width: 3,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(text: 'Voucher No', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Ledger Name', width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Amount', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

      ]);
      bytes +=generator.hr();
      print("------------------template   ------------------template   $template");
      if (template == 'template4') {

        Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
        Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString("تاريخ"));
        Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم القسيمة"));

        Uint8List ledgerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("اسم دفتر الأستاذ"));
        Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));



        bytes +=generator.row([
          PosColumn(
              textEncoded: slNoEnc,
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),

          PosColumn(textEncoded: dateEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),

          PosColumn(textEncoded: voucherNoEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: ledgerNameEnc, width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: rateEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

        ]);

        bytes +=generator.hr();
      }



      print("----------------------------------$details");

      for (var i = 0; i < details.length; i++) {
        Uint8List ledgerName = await CharsetConverter.encode("ISO-8859-6", setString(details[i]["CustomerName"]));
        bytes +=generator.row([
          PosColumn(
              text: (i+1).toString(),
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),

          PosColumn(text: details[i]["Date"], width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),

          PosColumn(text: details[i]["VoucherNo"] , width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: ledgerName, width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(text: roundStringWith(details[i]["GrandTotal"].toString()), width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

        ]);
      }



      bytes +=generator.hr(ch: "=");
      bytes +=generator.row([
        PosColumn(
            text: "Total Cash sale",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalCash), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);


      bytes +=generator.row([
        PosColumn(
            text: "Total Bank sale",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalBank), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);

      bytes +=generator.row([
        PosColumn(
            text: "Total Credit sale",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalCredit), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);

      bytes +=generator.row([
        PosColumn(
            text: "Grand total",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalGrand), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);
    }
    else {
      bytes +=generator.hr();
      bytes +=generator.row([
        PosColumn(
            text: 'SL',
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: 'Date',
            width: 3,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(text: 'Voucher No', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Ledger Name', width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(text: 'Amount', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

      ]);
      bytes +=generator.hr();
      print("------------------template   ------------------template   $template");
      if (template == 'template4') {

        Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
        Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString("تاريخ"));
        Uint8List unitName = await CharsetConverter.encode("ISO-8859-6", setString("وحدة"));

        Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("اسم المنتج"));
        Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("عدد السلعة المباعة"));



        bytes +=generator.row([
          PosColumn(
              textEncoded: slNoEnc,
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),

          PosColumn(textEncoded: dateEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),

          PosColumn(textEncoded: unitName, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: productNameEnc, width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: rateEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

        ]);

        bytes +=generator.hr();
      }



      print("----------------------------------$details");

      for (var i = 0; i < details.length; i++) {
        Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(details[i]["ProductName"]));
        Uint8List unitName = await CharsetConverter.encode("ISO-8859-6", setString(details[i]["UnitName"]));
        bytes +=generator.row([
          PosColumn(
              text: (i+1).toString(),
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),

          PosColumn(text: details[i]["date"], width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),

          PosColumn(textEncoded: unitName , width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(textEncoded: productName, width: 4, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(text: roundStringWith(details[i]["noOfSold"].toString()), width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),

        ]);
      }



      bytes +=generator.hr(ch: "=");
      bytes +=generator.row([
        PosColumn(
            text: "Total sold",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalCash), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);


      bytes +=generator.row([
        PosColumn(
            text: "Grand total",
            width: 5,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: "",
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(text: roundStringWith(totalGrand), width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
      ]);


    }

    bytes +=generator.hr(ch: "=");



    bytes +=generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, printerIP);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }
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

  setString(String tex) {
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

  returnBlankSpace(length) {
    List<String> list = [];
    for (int i = 0; i < length; i++) {
      list.add('');
    }
    return list;
  }

  set(String str) {
    try {
      if (str == "") {}

      var listData = [];
      List<String> test = [];
      List<String> splitA = str.split('');
      test = returnBlankSpace(splitA.length);

      if (str.contains('')) {
        for (int i = 0; i < splitA.length; i++) {
          test[i] = splitA[splitA.length - 1 - i];
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
    } catch (e) {}
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
    } else {
      onlyEnglish = false;
    }
    return onlyEnglish;
  }

  bool isN(String value) {
    if (value == "") {}
    var val = false;
    val = double.tryParse(value) != null;
    return val;
  }


}

class ProductDetailsModel {
  final String unitName, qty, netAmount, productName, unitPrice, productDescription;

  ProductDetailsModel({
    required this.unitName,
    required this.qty,
    required this.netAmount,
    required this.productName,
    required this.unitPrice,
    required this.productDescription,
  });

  factory ProductDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductDetailsModel(
      unitName: json['UnitName'],
      qty: json['quantityRounded'].toString(),
      netAmount: json['netAmountRounded'].toString(),
      productName: json['ProductName'],
      unitPrice: json['unitPriceRounded'].toString(),
      productDescription: json['ProductDescription'],
    );
  }
}
