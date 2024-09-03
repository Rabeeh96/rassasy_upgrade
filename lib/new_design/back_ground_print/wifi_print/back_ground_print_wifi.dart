import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:charset_converter/charset_converter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:image/image.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/Print/html_kot.dart';
import 'package:rassasy_new/Print/qr_generator.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/Templates/template1.dart';
import 'package:rassasy_new/new_design/back_ground_print/Templates/template2.dart';
import 'package:rassasy_new/new_design/dashboard/pos/new_method/model/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webcontent_converter/webcontent_converter.dart';

import '../Templates/template3.dart';

class AppBlocs {
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

        print("${response.statusCode}");
        log("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));

        var status = n["StatusCode"];
        var responseJson = n["data"];

        print("----------------------------${response.body}");
        if (status == 6000) {
          stop();

          print("==================================================");
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
          BluetoothPrintThermalDetails.grandTotal =
              responseJson["GrandTotal_print"].toString();
          BluetoothPrintThermalDetails.qrCodeImage = responseJson["qr_image"];

          BluetoothPrintThermalDetails.customerTaxNumber =
              responseJson["TaxNo"].toString();
          BluetoothPrintThermalDetails.ledgerName =
              responseJson["LedgerName"] ?? '';
          BluetoothPrintThermalDetails.customerAddress =
              responseJson["Address1"];
          BluetoothPrintThermalDetails.customerAddress2 =
              responseJson["Address2"];
          BluetoothPrintThermalDetails.customerCrNumber =
              responseJson["CustomerCRNo"] ?? "";

          // BluetoothPrintThermalDetails.cashReceived = "150";
          // BluetoothPrintThermalDetails.bankReceived = "50";
          // BluetoothPrintThermalDetails.balance =  "1";
          // BluetoothPrintThermalDetails.salesType =  "Dining";

          BluetoothPrintThermalDetails.cashReceived =
              responseJson["CashReceived"].toString() ?? "0";
          BluetoothPrintThermalDetails.bankReceived =
              responseJson["BankAmount"].toString() ?? "50";
          BluetoothPrintThermalDetails.balance =
              responseJson["Balance"].toString() ?? "";
          BluetoothPrintThermalDetails.salesType =
              responseJson["OrderType"] ?? "";
          BluetoothPrintThermalDetails.salesDetails =
              responseJson["SalesDetails"];
          BluetoothPrintThermalDetails.totalVATAmount =
              responseJson["VATAmount"] ?? '0';

          BluetoothPrintThermalDetails.totalExciseAmount =
              responseJson["ExciseTaxAmount"] ?? "0";
          BluetoothPrintThermalDetails.totalTax =
              responseJson["TotalTax_print"].toString();

          var companyDetails = responseJson["CompanyDetails"];

          BluetoothPrintThermalDetails.companyName =
              companyDetails["CompanyName"] ?? '';
          BluetoothPrintThermalDetails.buildingNumber =
              companyDetails["Address1"] ?? '';
          BluetoothPrintThermalDetails.secondName =
              companyDetails["CompanyNameSec"] ?? '';
          BluetoothPrintThermalDetails.streetName =
              companyDetails["Street"] ?? '';
          BluetoothPrintThermalDetails.state =
              companyDetails["StateName"] ?? '';
          BluetoothPrintThermalDetails.postalCodeCompany =
              companyDetails["PostalCode"] ?? '';
          BluetoothPrintThermalDetails.phoneCompany =
              companyDetails["Phone"] ?? '';
          BluetoothPrintThermalDetails.mobileCompany =
              companyDetails["Mobile"] ?? '';
          BluetoothPrintThermalDetails.vatNumberCompany =
              companyDetails["VATNumber"] ?? '';
          BluetoothPrintThermalDetails.companyGstNumber =
              companyDetails["GSTNumber"] ?? '';
          BluetoothPrintThermalDetails.cRNumberCompany =
              companyDetails["CRNumber"] ?? '';
          // BluetoothPrintThermalDetails.descriptionCompany= companyDetails["Description"]?? '';
          BluetoothPrintThermalDetails.countryNameCompany =
              companyDetails["CountryName"] ?? '';
          BluetoothPrintThermalDetails.stateNameCompany =
              companyDetails["StateName"] ?? '';

          BluetoothPrintThermalDetails.companyLogoCompany =
              companyDetails["CompanyLogo"] ?? '';
          BluetoothPrintThermalDetails.countyCodeCompany =
              companyDetails["CountryCode"] ?? '';
          BluetoothPrintThermalDetails.buildingNumberCompany =
              companyDetails["Address1"] ?? '';
          print("1-------------------------------");
          BluetoothPrintThermalDetails.tableName =
              responseJson["TableName"] ?? "";
          BluetoothPrintThermalDetails.time =
              responseJson["CreatedDate"] ?? "${DateTime.now()}";
          print("1-------------------------------");
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
        print('   error ${e.toString()}');
        stop();
        return 3;
      }
    }
  }

  /// print order and invoice ////
  void print_receipt(
      String printerIp, BuildContext ctx, isCancelled, orderSection) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString("template") ?? "template4";
    var capabilities = prefs.getString("default_capabilities") ?? "default";
    var defaultCodePage = prefs.getString("default_code_page") ?? "CP864";
    var hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
    var paymentDetailsInPrint = prefs.getBool("paymentDetailsInPrint") ?? false;
    var headerAlignment = prefs.getBool("headerAlignment") ?? false;
    var salesMan = prefs.getString("user_name") ?? '';
    var OpenDrawer = prefs.getBool("OpenDrawer") ?? false;
    var timeInPrint = prefs.getBool("time_in_invoice") ?? false;
    var hideTaxDetails = prefs.getBool("hideTaxDetails") ?? false;
    var showDiscountPrint = prefs.getBool("isDiscountInPrint") ?? false;
    var showCustomerName = prefs.getBool("isCustomerNameDisplay") ?? false;
    var showCustomerPhone = prefs.getBool("isCustomerPhoneDisplay") ?? false;
    var showSalesMan = prefs.getBool("isSalesmanDisplay") ?? false;
    var showGrossAmount = prefs.getBool("isGrossAmountDisplay") ?? false;
    var flavourInOrderPrint = prefs.getBool("flavour_in_order_print") ?? false;
    String copies = prefs.getString("number_of_print") ?? '1';

    print(
        "------flavourInOrderPrint---------------flavourInOrderPrint-------------------------$copies");

    int numberOfCopies = 1;

    if (orderSection) {
      numberOfCopies = int.parse(copies);
    }
    print(
        "------numberOfCopies---------------numberOfCopies-------------------------$numberOfCopies");
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    var profile;
    if (capabilities == "default") {
      profile = await CapabilityProfile.load();
    } else {
      profile = await CapabilityProfile.load(name: capabilities);
    }

    final printer = NetworkPrinter(paper, profile);
    var port = int.parse("9100");
    final PosPrintResult res = await printer.connect(printerIp, port: port);

    if (res == PosPrintResult.success) {
      if (temp == 'template4') {
        for (var i = 0; i < numberOfCopies; i++) {
          await arabicTemplateForInvoiceAndOrder(
              printer,
              hilightTokenNumber,
              paymentDetailsInPrint,
              headerAlignment,
              salesMan,
              OpenDrawer,
              timeInPrint,
              hideTaxDetails,
              defaultCodePage,
              isCancelled,
              flavourInOrderPrint,showDiscountPrint, showCustomerName,
              showCustomerPhone,
              showSalesMan,showGrossAmount);
        }
      } else if (temp == 'template3') {
        for (var i = 0; i < numberOfCopies; i++) {
          ///
          await englishInvoicePrint(
              printer,
              hilightTokenNumber,
              paymentDetailsInPrint,
              headerAlignment,
              salesMan,
              OpenDrawer,
              timeInPrint,
              hideTaxDetails,
              isCancelled,
              flavourInOrderPrint,
              showDiscountPrint,
              showCustomerName,
              showCustomerPhone,
              showSalesMan,showGrossAmount);
        }
      } else {
        await printArabic(printer);
      }

      Future.delayed(Duration(seconds: numberOfCopies + 2), () async {
        printer.disconnect();
      });
    } else {
      popAlert(
          head: "Error",
          message: "Check your printer connection",
          position: SnackPosition.TOP);
    }
  }

  Future<Uint8List> _fetchImageData(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  /// template supported  english and arabic template
  Future<void> arabicTemplateForInvoiceAndOrder(
      NetworkPrinter printer,
      tokenVal,
      paymentDetailsInPrint,
      headerAlignment,
      salesMan,
      OpenDrawer,
      timeInPrint,
      taxDetails,
      defaultCodePage,
      isCancelled,
      flavourInOrderPrint,showDiscountPrint, showCustomerName,
      showCustomerPhone,
      showSalesMan,showGrossAmount) async {
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

    if (BluetoothPrintThermalDetails.ledgerName == "Cash In Hand") {
      customerName = BluetoothPrintThermalDetails.customerName;
    }

    var date = BluetoothPrintThermalDetails.date;
    var customerPhone = BluetoothPrintThermalDetails.customerPhone;
    var grossAmount = roundStringWith(BluetoothPrintThermalDetails.grossAmount);
    var discount = roundStringWith(BluetoothPrintThermalDetails.discount);
    var totalTax = roundStringWith(BluetoothPrintThermalDetails.totalTax);
    var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
    var vatAmountTotal =
        roundStringWith(BluetoothPrintThermalDetails.totalVATAmount);
    var exciseAmountTotal =
        roundStringWith(BluetoothPrintThermalDetails.totalExciseAmount);
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
      printer.text(cancelNoteData,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
              fontType: PosFontType.fontB,
              bold: true));
    }
    //
    /// image print commented

    printer.setStyles(
        PosStyles(codeTable: defaultCodePage, align: PosAlign.center));

    if (PrintDataDetails.type == "SI") {
      if (companyLogo != "") {
        final Uint8List imageData = await _fetchImageData(companyLogo);
        final Img.Image? image = Img.decodeImage(imageData);
        final Img.Image resizedImage = Img.copyResize(image!, width: 200);
        printer.imageRaster(resizedImage);
        //   printer.image(resizedImage);
      }
    }

    printer.text('', styles: const PosStyles(align: PosAlign.left));
    Uint8List companyNameEnc =
        await CharsetConverter.encode("ISO-8859-6", setString(companyName));
    Uint8List companyTaxEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString('ضريبه  ' + companyTax));
    Uint8List companyCREnc = await CharsetConverter.encode(
        "ISO-8859-6", setString('س. ت  ' + companyCrNumber));
    Uint8List companyPhoneEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString('جوال ' + companyPhone));
    Uint8List salesManDetailsEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString('رجل المبيعات ' + salesMan));

    if (headerAlignment) {
      if (companyPhone != "") {
        companyPhoneEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString(companyPhone));
      }
    }

    Uint8List invoiceTypeEnc =
        await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
    Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString(invoiceTypeArabic));

    Uint8List ga = await CharsetConverter.encode(
        "ISO-8859-6", setString('المبلغ الإجمالي'));
    Uint8List tt =
        await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
    Uint8List exciseTax = await CharsetConverter.encode(
        "ISO-8859-6", setString('مبلغ الضريبة الانتقائية'));
    Uint8List vatTax = await CharsetConverter.encode(
        "ISO-8859-6", setString('ضريبة القيمة المضافة'));
    Uint8List dis =
        await CharsetConverter.encode("ISO-8859-6", setString('تخفيض'));
    Uint8List gt = await CharsetConverter.encode(
        "ISO-8859-6", setString('المبلغ الإجمالي'));

    Uint8List bl =
        await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
    Uint8List cr = await CharsetConverter.encode(
        "ISO-8859-6", setString('المبلغ المستلم'));
    Uint8List br =
        await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));

    if (headerAlignment) {
      printer.text('', styles: const PosStyles(align: PosAlign.left));
      if (companyName != "") {
        printer.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));
      }
      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode(
            "ISO-8859-6", setString(companySecondName));

        printer.text('', styles: const PosStyles(align: PosAlign.left));
        printer.textEncoded(companySecondNameEncode,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));

        //printer.textEncoded(descriptionC, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1));
      }

      if (buildingDetails != "") {
        Uint8List buildingAddressEncode = await CharsetConverter.encode(
            "ISO-8859-6", setString(buildingDetails));

        printer.row([
          PosColumn(
              text: 'Building',
              width: 2,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1),
          PosColumn(
              textEncoded: buildingAddressEncode,
              width: 9,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);

        // printer.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (streetName != "") {
        Uint8List streetNameEncode =
            await CharsetConverter.encode("ISO-8859-6", setString(streetName));

        printer.row([
          PosColumn(
              text: 'Building ',
              width: 2,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: streetNameEncode,
              width: 9,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);

        // printer.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (companyTax != "") {
        printer.row([
          PosColumn(
              text: 'Vat Number',
              width: 2,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyTaxEnc,
              width: 9,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
        //  printer.textEncoded(companyTaxEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }
      // if(companyCrNumber !=""){
      //   printer.row([
      //     PosColumn(text: '', width: 1,styles:PosStyles(align: PosAlign.left)),
      //     PosColumn(textEncoded: companyCREnc,width: 10, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center)),
      //     PosColumn(text: '', width: 1,styles:PosStyles(align: PosAlign.left)),
      //   ]);
      //   //  printer.textEncoded(companyCREnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      // }
      if (companyPhone != "") {
        printer.row([
          PosColumn(
              text: 'Phone',
              width: 2,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              textEncoded: companyPhoneEnc,
              width: 9,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
        //  printer.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      }

     if(showSalesMan){
       if (salesMan != "") {
         printer.row([
           PosColumn(
               text: 'Sales man',
               width: 2,
               styles: const PosStyles(align: PosAlign.left)),
           PosColumn(
               text: '',
               width: 1,
               styles: const PosStyles(align: PosAlign.left)),
           PosColumn(
               textEncoded: salesManDetailsEnc,
               width: 9,
               styles: const PosStyles(
                   height: PosTextSize.size1,
                   width: PosTextSize.size1,
                   align: PosAlign.right)),
         ]);
         //  printer.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
       }
     }
    } else {
      if (companyName != "") {
        printer.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));
      }

      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode(
            "ISO-8859-6", setString(companySecondName));

        printer.textEncoded(companySecondNameEncode,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (buildingDetails != "") {
        Uint8List buildingDetailsEncode = await CharsetConverter.encode(
            "ISO-8859-6", setString(buildingDetails));

        printer.textEncoded(buildingDetailsEncode,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (streetName != "") {
        Uint8List secondAddressEncode =
            await CharsetConverter.encode("ISO-8859-6", setString(streetName));

        printer.textEncoded(secondAddressEncode,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (companyTax != "") {
        printer.textEncoded(companyTaxEnc,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (companyCrNumber != "") {
        printer.textEncoded(companyCREnc,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (companyPhone != "") {
        printer.textEncoded(companyPhoneEnc,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

    if(showSalesMan){
      if (salesMan != "") {
        printer.textEncoded(salesManDetailsEnc,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }
    }
    }

    printer.text('', styles: const PosStyles(align: PosAlign.left));
    printer.textEncoded(invoiceTypeEnc,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center));
    printer.text('', styles: const PosStyles(align: PosAlign.left));
    printer.textEncoded(invoiceTypeArabicEnc,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center));

    var isoDate =
        DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
    Uint8List tokenEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
    Uint8List voucherNoEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
    Uint8List dateEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
    Uint8List customerEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
    Uint8List typeEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
    // printer.setStyles(PosStyles.defaults());
    printer.text('', styles: const PosStyles(align: PosAlign.left));

    if (tokenVal) {
      printer.hr();
      printer.text('Token No ',
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true,
              align: PosAlign.center));
      printer.text('', styles: const PosStyles(align: PosAlign.left));
      printer.text(token,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              bold: true,
              align: PosAlign.center));
      printer.text('', styles: const PosStyles(align: PosAlign.left));
      printer.textEncoded(tokenEnc,
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center));
      printer.hr();
    } else {
      printer.row([
        PosColumn(
            text: 'Token No ',
            width: 3,
            styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tokenEnc,
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: token,
            width: 6,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    printer.row([
      PosColumn(
          text: 'Voucher No  ',
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: voucherNoEnc,
          width: 3,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
      PosColumn(
          text: voucherNumber,
          width: 6,
          styles: const PosStyles(align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(
          text: 'Date  ',
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: dateEnc,
          width: 3,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
      PosColumn(
          text: date, width: 6, styles: const PosStyles(align: PosAlign.right)),
    ]);

if(showCustomerName){
  if (customerName != "") {
    Uint8List customerNameEnc =
    await CharsetConverter.encode("ISO-8859-6", setString(customerName));

    printer.row([
      PosColumn(
          text: 'Name    ',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          textEncoded: customerEnc,
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
      PosColumn(
          textEncoded: customerNameEnc,
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
    ]);
  }

}
  if(showCustomerPhone){
    if (customerPhone != "") {
      Uint8List phoneNoEncoded =
      await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));

      Uint8List phoneEnc =
      await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));

      printer.row([
        PosColumn(
            text: 'Phone    ',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: phoneEnc,
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            textEncoded: phoneNoEncoded,
            width: 6,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    }
  }

    printer.setStyles(PosStyles(codeTable: defaultCodePage));
    printer.row([
      PosColumn(
          text: 'Order type    ',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          textEncoded: typeEnc,
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
      PosColumn(
          text: orderType,
          width: 6,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
    ]);

    printer.setStyles(PosStyles(codeTable: defaultCodePage));

    if (tableName != "") {
      Uint8List tableEnc =
          await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

      printer.row([
        PosColumn(
            text: 'Table Name   ',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: tableEnc,
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: tableName,
            width: 6,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    }
    if (timeInPrint) {
      var time = BluetoothPrintThermalDetails.time;

      String timeInvoice =
          await convertToSaudiArabiaTime(time, countyCodeCompany);
      Uint8List timeEnc =
          await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

      printer.row([
        PosColumn(
            text: 'Time   ',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: timeEnc,
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: timeInvoice,
            width: 6,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    }

    printer.hr();

    ///

    Uint8List slNoEnc =
        await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
    Uint8List productNameEnc =
        await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
    Uint8List qtyEnc =
        await CharsetConverter.encode("ISO-8859-6", setString(" الكمية "));
    Uint8List rateEnc =
        await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
    Uint8List netEnc =
        await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));

    // printer.setStyles(PosStyles(align: PosAlign.center));
    // printer.setStyles(PosStyles(align: PosAlign.left));

    printer.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Item Name',
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          text: 'Rate',
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(
          text: 'Net',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(
          textEncoded: slNoEnc,
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
            fontType: PosFontType.fontA,
          )),
      PosColumn(
          textEncoded: productNameEnc,
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          textEncoded: qtyEnc,
          width: 1,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          textEncoded: rateEnc,
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(
          textEncoded: netEnc,
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    printer.hr();

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var slNo = i + 1;
      Uint8List productName = await CharsetConverter.encode(
          "ISO-8859-6", setString(tableDataDetailsPrint[i].productName));
      printer.row([
        PosColumn(
            text: "$slNo",
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            textEncoded: productName,
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: tableDataDetailsPrint[i].qty,
            width: 1,
            styles: PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.center,
                bold: tokenVal)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].netAmount),
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      var description = tableDataDetailsPrint[i].productDescription ?? '';
      if (description != "") {
        Uint8List description = await CharsetConverter.encode("ISO-8859-6",
            setString(tableDataDetailsPrint[i].productDescription));
        printer.row([
          PosColumn(
              textEncoded: description,
              width: 7,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
          PosColumn(
              text: '',
              width: 5,
              styles: const PosStyles(
                height: PosTextSize.size1,
              ))
        ]);
      }

      var flavour = tableDataDetailsPrint[i].flavourName ?? '';

      if (PrintDataDetails.type == "SO") {
        if (flavourInOrderPrint) {
          if (flavour != "") {
            Uint8List flavourNameEnc = await CharsetConverter.encode(
                "ISO-8859-6", setString(tableDataDetailsPrint[i].flavourName));
            printer.row([
              PosColumn(
                  textEncoded: flavourNameEnc,
                  width: 7,
                  styles: const PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.left)),
              PosColumn(
                  text: '',
                  width: 5,
                  styles: const PosStyles(
                    height: PosTextSize.size1,
                  ))
            ]);
          }
        }
      }

      printer.hr();
    }
    printer.emptyLines(1);
    if(showGrossAmount) {
      printer.row([
        PosColumn(
            text: 'Gross Amount',
            width: 4,
            styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: ga,
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(grossAmount),
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    if (taxDetails) {
      if (showExcise) {
        printer.row([
          PosColumn(
              text: 'Total Excise Tax',
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: exciseTax,
              width: 4,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
          PosColumn(
              text: roundStringWith(exciseAmountTotal),
              width: 4,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
        printer.row([
          PosColumn(
              text: 'Total VAT',
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: vatTax,
              width: 4,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
          PosColumn(
              text: roundStringWith(vatAmountTotal),
              width: 4,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
      }

      printer.row([
        PosColumn(
            text: 'Total Tax',
            width: 4,
            styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: tt,
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalTax),
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    if(showDiscountPrint){
      printer.row([
        PosColumn(
            text: 'Discount',
            width: 4,
            styles: const PosStyles(fontType: PosFontType.fontB)),
        PosColumn(
            textEncoded: dis,
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(discount),
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    // printer.setStyles(PosStyles.defaults());

    printer.hr();
    printer.row([
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
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right,
              bold: true)),
      PosColumn(
          text: countyCodeCompany + " " + roundStringWith(grandTotal),
          width: 6,
          styles: const PosStyles(
            fontType: PosFontType.fontA,
            bold: true,
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
    ]);
    printer.hr();
    if (PrintDataDetails.type == "SI") {
      if (paymentDetailsInPrint) {
        printer.row([
          PosColumn(
              text: 'Cash receipt',
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: cr,
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(cashReceived),
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer.row([
          PosColumn(
              text: 'Bank receipt',
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: br,
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(bankReceived),
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer.row([
          PosColumn(
              text: 'Balance',
              width: 4,
              styles: const PosStyles(fontType: PosFontType.fontB)),
          PosColumn(
              textEncoded: bl,
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(balance),
              width: 3,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
      }
    }

    ///
    if (qrCodeAvailable) {
      printer.feed(1);
      var qrCode = await b64Qrcode(
          BluetoothPrintThermalDetails.companyName,
          BluetoothPrintThermalDetails.vatNumberCompany,
          isoDate,
          BluetoothPrintThermalDetails.grandTotal,
          BluetoothPrintThermalDetails.totalTax);
      printer.qrcode(qrCode, size: QRSize.Size5);
    }

    printer.cut();
    if (PrintDataDetails.type == "SI") {
      OpenDrawer = checkCashDrawer(cashReceived, bankReceived);
      if (OpenDrawer) {
        printer.drawer();
      }
    }
  }

  bool checkCashDrawer(cash, bank) {
    double cashReceived = double.parse(cash ?? '0');
    double bankAmount = double.parse(bank ?? '0');

    if (cashReceived > 0.0) {
      return true;
    } else if (cashReceived == 0.0 && bankAmount > 0.0) {
      return false;
    }
    return false;
  }

  /// template supported only english
  Future<void> englishInvoicePrint(
      NetworkPrinter printer,
      tokenVal,
      paymentDetailsInPrint,
      headerAlignment,
      salesMan,
      OpenDrawer,
      timeInPrint,
      taxDetails,
      isCancelled,
      flavourInOrderPrint,
      isDiscountPrint,
      showCustomerName,
      showCustomerPhone,
      showSalesman,showGrossAmount) async {
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
    var vatAmountTotal =
        roundStringWith(BluetoothPrintThermalDetails.totalVATAmount);
    var exciseAmountTotal =
        roundStringWith(BluetoothPrintThermalDetails.totalExciseAmount);
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

    if (isCancelled) {
      var cancelNoteData = "THIS ORDER WAS CANCELLED BY THE CUSTOMER.";
      printer.text(cancelNoteData,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
              fontType: PosFontType.fontB,
              bold: true));
    }

    if (PrintDataDetails.type == "SI") {
      if (companyLogo != "") {
        final Uint8List imageData = await _fetchImageData(companyLogo);
        final Img.Image? image = Img.decodeImage(imageData);
        final Img.Image resizedImage = Img.copyResize(image!, width: 200);
        printer.imageRaster(resizedImage);
        //printer.image(resizedImage);
      }
    }

    printer.text('', styles: const PosStyles(align: PosAlign.left));

    if (headerAlignment) {
      if (companyName != "") {
        printer.text(companyName,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));
      }
      if (companySecondName != "") {
        printer.text(companySecondName,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));
      }

      if (buildingDetails != "") {
        printer.row([
          PosColumn(
              text: 'Building',
              width: 3,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(text: '', width: 1),
          PosColumn(
              text: buildingDetails,
              width: 8,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
      }

      if (streetName != "") {
        printer.row([
          PosColumn(
              text: 'Street ',
              width: 3,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: streetName,
              width: 8,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
      }

      if (companyTax != "") {
        printer.row([
          PosColumn(
              text: 'GST No  ',
              width: 3,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: companyTax,
              width: 8,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
      }

      if (companyPhone != "") {
        printer.row([
          PosColumn(
              text: 'Phone',
              width: 2,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(align: PosAlign.left)),
          PosColumn(
              text: companyPhone,
              width: 9,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.right)),
        ]);
      }
      if (showSalesman) {
        if (salesMan != "") {
          printer.row([
            PosColumn(
                text: 'Sales man',
                width: 4,
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                text: '',
                width: 1,
                styles: const PosStyles(align: PosAlign.left)),
            PosColumn(
                text: salesMan,
                width: 7,
                styles: const PosStyles(
                    height: PosTextSize.size1,
                    width: PosTextSize.size1,
                    align: PosAlign.right)),
          ]);
        }
      }
    } else {
      if (companyName != "") {
        printer.text(companyName,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                fontType: PosFontType.fontA,
                bold: true,
                align: PosAlign.center));
      }

      if (companySecondName != "") {
        printer.text(companySecondName,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (buildingDetails != "") {
        printer.text(buildingDetails,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (streetName != "") {
        printer.text(streetName,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (companyTax != "") {
        printer.text("GST NO:$companyTax",
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1));
      }

      if (companyPhone != "") {
        printer.text(companyPhone,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }
    }

    printer.text('', styles: const PosStyles(align: PosAlign.left));
    printer.text(invoiceType,
        styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size1,
            align: PosAlign.center));

    if (tokenVal) {
      printer.hr();
      printer.text('Token No ',
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              bold: true,
              align: PosAlign.center));
      printer.text('', styles: const PosStyles(align: PosAlign.left));
      printer.text(token,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size2,
              bold: true,
              align: PosAlign.center));
      printer.text('', styles: const PosStyles(align: PosAlign.left));
      printer.text("Token Number",
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.center));
      printer.hr();
    } else {
      printer.row([
        PosColumn(
            text: 'Token No ',
            width: 4,
            styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
            )),
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

    printer.row([
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

    printer.row([
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

    if (showCustomerName) {
      if (customerName != "") {
        printer.row([
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
    }
    if (showCustomerPhone) {
      if (customerPhone != "") {
        printer.row([
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
    }

    printer.row([
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

    if (tableName != "") {
      printer.row([
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

      String timeInvoice = convertToSaudiArabiaTime(time, countyCodeCompany);

      printer.row([
        PosColumn(
            text: 'Time   ',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: '   ',
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: timeInvoice,
            width: 6,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    }

    // if (salesMan != "") {
    //   printer.row([
    //     PosColumn(
    //         text: 'Sales man  ',
    //         width: 4,
    //         styles: const PosStyles(
    //           height: PosTextSize.size1,
    //           width: PosTextSize.size1,
    //         )),
    //     PosColumn(
    //         text: salesMan,
    //         width: 8,
    //         styles: const PosStyles(
    //           height: PosTextSize.size1,
    //           width: PosTextSize.size1,
    //           align: PosAlign.right,
    //         )),
    //   ]);
    // }

    printer.emptyLines(1);
    printer.hr();

    printer.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: const PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Item Name',
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.center)),
      PosColumn(
          text: 'Rate',
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(
          text: 'Net',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    printer.hr();

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var slNo = i + 1;

      printer.row([
        PosColumn(
            text: "$slNo",
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: tableDataDetailsPrint[i].productName,
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: tableDataDetailsPrint[i].qty,
            width: 1,
            styles: PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.center,
                bold: tokenVal)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].netAmount),
            width: 3,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (tableDataDetailsPrint[i].productDescription != "") {
        printer.row([
          PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              text: tableDataDetailsPrint[i].productDescription,
              width: 11,
              styles: const PosStyles(
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
        ]);
      }
      var flavour = tableDataDetailsPrint[i].flavourName ?? '';

      if (PrintDataDetails.type == "SO") {
        if (flavourInOrderPrint) {
          if (flavour != "") {
            printer.row([
              PosColumn(
                  text: flavour,
                  width: 7,
                  styles: const PosStyles(
                      height: PosTextSize.size1,
                      width: PosTextSize.size1,
                      align: PosAlign.left)),
              PosColumn(
                  text: '',
                  width: 5,
                  styles: const PosStyles(
                    height: PosTextSize.size1,
                  ))
            ]);
          }
        }
      }

      printer.hr();
    }
    printer.emptyLines(1);
    if(showGrossAmount) {
      printer.row([
        PosColumn(
            text: "Gross Amount",
            width: 5,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: roundStringWith(grossAmount),
            width: 7,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }
    ///
    if (taxDetails) {
      printer.row([
        PosColumn(
            text: "SGST ",
            width: 5,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: roundStringWith(sGstAmount),
            width: 7,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      printer.row([
        PosColumn(
            text: "CGST",
            width: 5,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: roundStringWith(cGstAmount),
            width: 7,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      printer.row([
        PosColumn(
            text: " ",
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: "---------",
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]);

      printer.row([
        PosColumn(
            text: "Total Tax",
            width: 5,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: roundStringWith(totalTax),
            width: 7,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    ///
    if (isDiscountPrint) {
      printer.row([
        PosColumn(
            text: "Discount",
            width: 5,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.left)),
        PosColumn(
            text: roundStringWith(discount),
            width: 7,
            styles: const PosStyles(align: PosAlign.right)),
      ]);
    }

    printer.hr();
    printer.row([
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
    printer.hr();
    if (PrintDataDetails.type == "SI") {
      if (paymentDetailsInPrint) {
        printer.row([
          PosColumn(
              text: "Cash receipt",
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(cashReceived),
              width: 7,
              styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer.row([
          PosColumn(
              text: "Bank receipt",
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(bankReceived),
              width: 7,
              styles: const PosStyles(align: PosAlign.right)),
        ]);

        printer.row([
          PosColumn(
              text: "Balance",
              width: 5,
              styles: const PosStyles(
                  fontType: PosFontType.fontA,
                  height: PosTextSize.size1,
                  width: PosTextSize.size1,
                  align: PosAlign.left)),
          PosColumn(
              text: roundStringWith(balance),
              width: 7,
              styles: const PosStyles(align: PosAlign.right)),
        ]);
        printer.hr();
      }
    }

    printer.cut();
    if (PrintDataDetails.type == "SI") {
      if (OpenDrawer) {
        printer.drawer();
      }
    }
  }

  void print_report(
      {required String printerIp,
      required reportTypeR,
      required BuildContext ctx,
      required detailsR,
      required dateR,
      required totalCashR,
      required totalBankR,
      required totalCreditR,
      required totalGrandR,
      required fromTime,
      required userName,
      required effectiveSale,
      required orderDetails,
      required saleByType,
      required salesOrder,
      required totalRevenue}) async {
    print("its acall");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = prefs.getString("template") ?? "template4";
    var capabilities = prefs.getString("default_capabilities") ?? "default";

    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    var profile;
    if (capabilities == "default") {
      profile = await CapabilityProfile.load();
    } else {
      profile = await CapabilityProfile.load(name: capabilities);
    }

    final printer = NetworkPrinter(paper, profile);
    var port = int.parse("9100");
    final PosPrintResult res = await printer.connect(printerIp, port: port);

    if (res == PosPrintResult.success) {
      if (reportTypeR == "daily_report") {
        await dailyReportEnglish(
            printer: printer,
            fromTime: fromTime,
            userName: userName,
            effectiveSale: effectiveSale,
            orderDetails: orderDetails,
            saleByType: saleByType,
            salesOrder: salesOrder,
            totalRevenue: totalRevenue);
      } else {
        await reportPrint(
          printer: printer,
          date: dateR,
          details: detailsR,
          template: temp,
          invoiceType: reportTypeR,
          totalCash: totalCashR,
          totalBank: totalBankR,
          totalCredit: totalCreditR,
          totalGrand: totalGrandR,
        );
      }

      // if (temp == 'template4') {
      //   await dailyReportEnglish(printer);
      // } else if (temp == 'template3') {
      //   await dailyReportEnglish(printer);
      // }
      // else {
      //   await printArabic(printer);
      // }
      Future.delayed(const Duration(seconds: 2), () async {
        print("------after delay----------------------------strt printing");
        printer.disconnect();
      });
    } else {
      popAlert(
          head: "Error",
          message: "heck your printer connection",
          position: SnackPosition.TOP);
    }
  }

  Future<void> dailyReportEnglish({
    required NetworkPrinter printer,
    required fromTime,
    required userName,
    var salesOrder,
    var orderDetails,
    var saleByType,
    var effectiveSale,
    var totalRevenue,
  }) async {
    // var fromTime = "25-02-2024 to 16-02-2036";
    // var userName = "Rabeeh";
    // var invoiceType = "DAILY REPORT";
    // var grossAmount = "13233";
    // var discount = "100";
    // var totalTax = "36";
    // var grandTotal = "15452";
    //
    // var grossAmountSale = "13233";
    // var discountSale = "100";
    // var totalTaxSale = "36";
    // var grandTotalSale = "15452";
    // var noOfOrders = "10";
    // var ordersAmount = "1524";
    // var noOfCanceled = "1524";
    // var canceledAmount = "1524";
    // var diningAmount = "500";
    // var takeAwayAmount = "700";
    // var carAmount = "350";
    // var totalCashAmount = "12540";
    // var totalBankAmount = "3500";
    // var totalBankCredit = "500";
    ///
    printer
        .setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));

    printer.text("DAILY REPORT",
        styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size1,
            align: PosAlign.center));
    printer.hr();
    printer.emptyLines(1);
    printer.row([
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
      PosColumn(
          text: userName,
          width: 7,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.row([
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
      PosColumn(
          text: fromTime,
          width: 7,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.hr();
    printer.emptyLines(2);
    print("salesOrder -----------------");
    print(salesOrder);
    printer.text("Sales Order",
        styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size1,
            align: PosAlign.center));
    printer.emptyLines(1);
    printer.row([
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
              height: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(
          text: roundStringWith(orderDetails["gross_amount"].toString()),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              align: PosAlign.right)),
    ]);
    printer.row([
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
          text: roundStringWith(orderDetails["discount"].toString()),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    printer.row([
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
          text: roundStringWith(orderDetails["total_tax"].toString()),
          width: 5,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);

    // printer.hr();
    // printer.emptyLines(2);
    // printer.text("Order Details", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    // printer.emptyLines(1);
    //
    // printer.row([
    //   PosColumn(
    //       text: "No of orders",
    //       width: 4,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(noOfOrders), width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: "Amount",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(ordersAmount), width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "No of Canceled",
    //       width: 4,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(noOfCanceled), width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: "Amount",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(canceledAmount), width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    //
    // printer.hr(ch: "=");
    // printer.emptyLines(2);
    //
    // printer.text("Effective sale", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    // printer.emptyLines(1);
    // printer.row([
    //   PosColumn(
    //       text: "Gross Amount",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: "", width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: roundStringWith(grossAmountSale),
    //       width: 5,
    //       styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Discount",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(discountSale), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Total Tax",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(totalTaxSale), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Grand total",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(grandTotalSale), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    //
    // printer.hr(ch: "=");
    // printer.emptyLines(2);
    // printer.text("Sale by type", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    // printer.emptyLines(1);
    // printer.hr();
    // printer.row([
    //   PosColumn(
    //       text: "Type",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //         bold: true,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: "Amount", width: 5, styles: const PosStyles(height: PosTextSize.size1, bold: true, align: PosAlign.right)),
    // ]);
    // printer.hr();
    // printer.row([
    //   PosColumn(
    //       text: "Dining",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(diningAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    //
    // printer.row([
    //   PosColumn(
    //       text: "Take away",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(takeAwayAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Online",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(
    //       text: "",
    //       width: 2,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: roundStringWith(carAmount), width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.hr(ch: "=");
    // printer.emptyLines(2);
    // printer.text("Total revenue", styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    // printer.emptyLines(1);
    // printer.row([
    //   PosColumn(
    //       text: "Total Cash",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: "", width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: roundStringWith(totalCashAmount),
    //       width: 5,
    //       styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Total Bank",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: "", width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: roundStringWith(totalBankAmount),
    //       width: 5,
    //       styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.row([
    //   PosColumn(
    //       text: "Total Credit",
    //       width: 5,
    //       styles: const PosStyles(
    //         height: PosTextSize.size1,
    //       )),
    //   PosColumn(text: "", width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
    //   PosColumn(
    //       text: roundStringWith(totalBankCredit),
    //       width: 5,
    //       styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
    // ]);
    // printer.hr(ch: "=");
    printer.cut();
  }

  Future<void> reportPrint({
    required NetworkPrinter printer,
    required details,
    required date,
    required template,
    required invoiceType,
    required totalCash,
    required totalBank,
    required totalCredit,
    required totalGrand,
  }) async {
    printer
        .setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));
    printer.text(date,
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center,
            bold: true));
    if (invoiceType == "Sales report" ||
        invoiceType == "Dining report" ||
        invoiceType == "TakeAway report" ||
        invoiceType == "Car report" ||
        invoiceType == "TableWise report") {
      printer.hr();
      printer.row([
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
        PosColumn(
            text: 'Voucher No',
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(
            text: 'Ledger Name',
            width: 4,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(
            text: 'Amount',
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);
      printer.hr();
      print(
          "------------------template   ------------------template   $template");
      if (template == 'template4') {
        Uint8List slNoEnc =
            await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
        Uint8List dateEnc =
            await CharsetConverter.encode("ISO-8859-6", setString("تاريخ"));
        Uint8List voucherNoEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString("رقم القسيمة"));

        Uint8List ledgerNameEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString("اسم دفتر الأستاذ"));
        Uint8List rateEnc =
            await CharsetConverter.encode("ISO-8859-6", setString("معدل"));

        printer.row([
          PosColumn(
              textEncoded: slNoEnc,
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              textEncoded: dateEnc,
              width: 3,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: voucherNoEnc,
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: ledgerNameEnc,
              width: 4,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: rateEnc,
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.right)),
        ]);

        printer.hr();
      }

      print("----------------------------------$details");

      for (var i = 0; i < details.length; i++) {
        Uint8List ledgerName = await CharsetConverter.encode(
            "ISO-8859-6", setString(details[i]["CustomerName"]));
        printer.row([
          PosColumn(
              text: (i + 1).toString(),
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              text: details[i]["Date"],
              width: 3,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              text: details[i]["VoucherNo"],
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: ledgerName,
              width: 4,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              text: roundStringWith(details[i]["GrandTotal"].toString()),
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.right)),
        ]);
      }

      printer.hr(ch: "=");
      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalCash),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);

      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalBank),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);

      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalCredit),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);

      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalGrand),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    } else {
      printer.hr();
      printer.row([
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
        PosColumn(
            text: 'Voucher No',
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(
            text: 'Ledger Name',
            width: 4,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(
            text: 'Amount',
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);
      printer.hr();
      print(
          "------------------template   ------------------template   $template");
      if (template == 'template4') {
        Uint8List slNoEnc =
            await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
        Uint8List dateEnc =
            await CharsetConverter.encode("ISO-8859-6", setString("تاريخ"));
        Uint8List unitName =
            await CharsetConverter.encode("ISO-8859-6", setString("وحدة"));

        Uint8List productNameEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString("اسم المنتج"));
        Uint8List rateEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString("عدد السلعة المباعة"));

        printer.row([
          PosColumn(
              textEncoded: slNoEnc,
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              textEncoded: dateEnc,
              width: 3,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: unitName,
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: productNameEnc,
              width: 4,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: rateEnc,
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.right)),
        ]);

        printer.hr();
      }

      print("----------------------------------$details");

      for (var i = 0; i < details.length; i++) {
        Uint8List productName = await CharsetConverter.encode(
            "ISO-8859-6", setString(details[i]["ProductName"]));
        Uint8List unitName = await CharsetConverter.encode(
            "ISO-8859-6", setString(details[i]["UnitName"]));
        printer.row([
          PosColumn(
              text: (i + 1).toString(),
              width: 1,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              text: details[i]["date"],
              width: 3,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: unitName,
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              textEncoded: productName,
              width: 4,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.center)),
          PosColumn(
              text: roundStringWith(details[i]["noOfSold"].toString()),
              width: 2,
              styles: const PosStyles(
                  height: PosTextSize.size1, align: PosAlign.right)),
        ]);
      }

      printer.hr(ch: "=");
      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalCash),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);

      printer.row([
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
                height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(totalGrand),
            width: 5,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.right)),
      ]);
    }

    printer.hr(ch: "=");
    printer.cut();
  }

  /// commented
  //
  // Future<void> InvoicePrintTemplate3(NetworkPrinter printer,tokenVal) async {
  //   List<ProductDetailsModel> tableDataDetailsPrint = [];
  //
  //   var salesDetails = BluetoothPrintThermalDetails.salesDetails;
  //   print(salesDetails);
  //   for (Map user in salesDetails) {
  //     tableDataDetailsPrint.add(ProductDetailsModel.fromJson(user));
  //   }
  //
  //   var logoAvailable = true;
  //   var productDecBool = true;
  //   var qrCodeAvailable = true;
  //
  //   var invoiceType;
  //   var invoiceTypeArabic;
  //
  //   invoiceType = "SIMPLIFIED TAX INVOICE";
  //   invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
  //
  //   if (PrintDataDetails.type == "SI") {
  //     invoiceType = "SIMPLIFIED TAX INVOICE";
  //     invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
  //   }
  //   if (PrintDataDetails.type == "SO") {
  //     logoAvailable = false;
  //     qrCodeAvailable = false;
  //     productDecBool = false;
  //     invoiceType = "SALES ORDER";
  //     invoiceTypeArabic = "(طلب المبيعات)";
  //   }
  //
  //   var companyName = BluetoothPrintThermalDetails.companyName;
  //   var companyAddress1 = BluetoothPrintThermalDetails.address1Company;
  //   var city = BluetoothPrintThermalDetails.city;
  //   var description = BluetoothPrintThermalDetails.description;
  //   var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
  //   var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
  //   var companyTax = BluetoothPrintThermalDetails.vatNumberCompany;
  //   var companyCrNumber = BluetoothPrintThermalDetails.cRNumberCompany;
  //   var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
  //   var qrCodeData = BluetoothPrintThermalDetails.qrCodeImage;
  //
  //   var voucherNumber = BluetoothPrintThermalDetails.voucherNumber;
  //   var customerName =BluetoothPrintThermalDetails.ledgerName;
  //   print("________________LedgerName   ${BluetoothPrintThermalDetails.ledgerName}");
  //   print("________________customerName     ${BluetoothPrintThermalDetails.customerName}");
  //
  //   if(BluetoothPrintThermalDetails.ledgerName == "Cash In Hand"){
  //     customerName=BluetoothPrintThermalDetails.customerName;
  //   }
  //
  //
  //   var date = BluetoothPrintThermalDetails.date;
  //   var customerPhone = BluetoothPrintThermalDetails.customerPhone;
  //   var grossAmount = roundStringWith(BluetoothPrintThermalDetails.grossAmount);
  //   var discount = roundStringWith(BluetoothPrintThermalDetails.discount);
  //   var totalTax = roundStringWith(BluetoothPrintThermalDetails.totalTax);
  //   var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
  //   var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
  //   var token = BluetoothPrintThermalDetails.tokenNumber;
  //
  //   var cashReceived = BluetoothPrintThermalDetails.cashReceived;
  //   var bankReceived = BluetoothPrintThermalDetails.bankReceived;
  //   var balance = BluetoothPrintThermalDetails.balance;
  //   var orderType = BluetoothPrintThermalDetails.salesType;
  //
  //   //
  //   /// image print commented
  //   // final Uint8List imageData = await _fetchImageData(BluetoothPrintThermalDetails.companyLogoCompany);
  //   //
  //   // final Img.Image? image = Img.decodeImage(imageData);
  //   // final Img.Image resizedImage = Img.copyResize(image!, width: 200);
  //   // printer.image(resizedImage);
  //
  //
  //   printer.setStyles(PosStyles(codeTable: 'CP864', align: PosAlign.center));
  //   Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName));
  //   Uint8List cityEncode = await CharsetConverter.encode("ISO-8859-6", setString(city));
  //   Uint8List descriptionC = await CharsetConverter.encode("ISO-8859-6", setString(description));
  //   Uint8List companyTaxEnc = await CharsetConverter.encode("ISO-8859-6", setString('ضريبه  ' + companyTax));
  //   Uint8List companyCREnc = await CharsetConverter.encode("ISO-8859-6", setString('س. ت  ' + companyCrNumber));
  //   Uint8List companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone));
  //
  //   Uint8List invoiceTypeEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
  //   Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));
  //
  //   Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
  //   Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('خصم'));
  //   Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
  //   Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
  //
  //   Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
  //   Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
  //   Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));
  //
  //
  //   if(companyName !=""){
  //     printer.textEncoded(companyNameEnc, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
  //   }
  //   if(description !=""){
  //     printer.textEncoded(descriptionC, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
  //   }
  //
  //   if(city !=""){
  //     printer.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //   }
  //
  //   if(companyTax !=""){
  //     printer.textEncoded(companyTaxEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //   }
  //   if(companyCrNumber !=""){
  //     printer.textEncoded(companyCREnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //   }
  //   if(companyPhone !=""){
  //     printer.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //
  //   }
  //
  //   printer.emptyLines(1);
  //
  //
  //   printer.textEncoded(invoiceTypeEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
  //   printer.textEncoded(invoiceTypeArabicEnc, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
  //
  //   printer.emptyLines(1);
  //
  //   var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
  //   printer.setStyles(PosStyles(align: PosAlign.left));
  //
  //   Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
  //   Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
  //   Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
  //   Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
  //   Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));
  //   Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
  //
  //
  //   if(tokenVal){
  //     printer.hr();
  //     printer.text('Token No ',styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,bold: true, align: PosAlign.center));
  //     printer.text(token,styles: PosStyles(height: PosTextSize.size3, width: PosTextSize.size3,bold: true, align: PosAlign.center));
  //     printer.textEncoded(tokenEnc,  styles: PosStyles(align: PosAlign.right,bold: true,));
  //     printer.hr();
  //   }
  //   else{
  //     printer.row([
  //       PosColumn(text: 'Token No ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //       PosColumn(textEncoded: tokenEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //       PosColumn(text: token, width: 6, styles: PosStyles(align: PosAlign.right)),
  //     ]);
  //
  //   }
  //
  //
  //
  //
  //
  //
  //
  //   printer.row([
  //     PosColumn(text: 'Voucher No  ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: voucherNoEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: voucherNumber, width: 6, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   printer.row([
  //     PosColumn(text: 'Date  ', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: dateEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: date, width: 6, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //
  //   Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName));
  //   Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));
  //
  //   if(customerName != ""){
  //     printer.row([
  //       PosColumn(text: 'Name    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(textEncoded: customerEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //       PosColumn(textEncoded: customerNameEnc, width: 6, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
  //     ]);
  //   }
  //   if(customerPhone != ""){
  //
  //     printer.row([
  //       PosColumn(text: 'Phone    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(textEncoded: phoneEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //       PosColumn(textEncoded: phoneNoEncoded, width: 6, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
  //
  //     ]);
  //   }
  //
  //   printer.setStyles(PosStyles.defaults());
  //   printer.setStyles(PosStyles(codeTable: 'CP864'));
  //   printer.row([
  //     PosColumn(text: 'Order type    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //     PosColumn(textEncoded: typeEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: orderType, width: 6, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
  //   ]);
  //
  //
  //
  //   // printer.row([
  //   //   PosColumn(text: '', width: 5, styles: PosStyles(fontType: PosFontType.fontB)),
  //   //   PosColumn(text: "", width: 7, styles: PosStyles(align: PosAlign.right)),
  //   // ]);
  //
  //   // printer.row([
  //   //   PosColumn(text: 'Token No ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: token, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   // ]);
  //
  //   // printer.row([
  //   //   PosColumn(text: 'Voucher No :', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: voucherNumber, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   // ]);
  //   // printer.row([
  //   //   PosColumn(text: 'Date      ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: date, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   // ]);
  //
  //   // if(customerName != ""){
  //   //   printer.row([
  //   //     PosColumn(text: 'Name    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //     PosCol
  //   //     umn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //     PosColumn(textEncoded: customerNameEnc, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   ]);
  //   // }
  //   //
  //   // if(customerPhone != ""){
  //   //   printer.row([
  //   //     PosColumn(text: 'Phone    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //     PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //     PosColumn(textEncoded: phoneNoEncoded, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   ]);
  //   // }
  //   //
  //
  //
  //   // printer.row([
  //   //   PosColumn(text: 'Order type    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   //   PosColumn(text: orderType, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //   // ]);
  //
  //
  //   printer.hr();
  //
  //   Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
  //   Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
  //   Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString("كمية"));
  //   Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
  //   Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));
  //
  //   // printer.setStyles(PosStyles(align: PosAlign.center));
  //   // printer.setStyles(PosStyles(align: PosAlign.left));
  //
  //   printer.row([
  //     PosColumn(
  //         text: 'SL',
  //         width: 1,
  //         styles: PosStyles(
  //           height: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //         text: 'Item Name',
  //         width: 5,
  //         styles: PosStyles(
  //             height: PosTextSize.size1,
  //             align:PosAlign.center
  //         )),
  //     PosColumn(text: 'Qty', width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
  //     PosColumn(text: 'Rate', width: 2, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: 'Net', width: 3, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //   ]);
  //
  //   printer.row([
  //     PosColumn(
  //         textEncoded: slNoEnc,
  //         width: 1,
  //         styles: PosStyles(
  //           height: PosTextSize.size1,
  //         )),
  //     PosColumn(
  //         textEncoded: productNameEnc,
  //         width: 5,
  //         styles: PosStyles(
  //             height: PosTextSize.size1,
  //             align:PosAlign.center
  //         )),
  //     PosColumn(textEncoded: qtyEnc, width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
  //     PosColumn(textEncoded:rateEnc, width: 2, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(textEncoded: netEnc, width: 3, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //   ]);
  //
  //   printer.hr();
  //
  //   for (var i = 0; i < tableDataDetailsPrint.length; i++) {
  //     var slNo = i + 1;
  //
  //     Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription));
  //     Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName));
  //
  //     printer.row([
  //       PosColumn(
  //           text: "$slNo",
  //           width: 1,
  //           styles: PosStyles(
  //             height: PosTextSize.size1,
  //           )),
  //       PosColumn(textEncoded: productName, width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
  //       PosColumn(text: tableDataDetailsPrint[i].qty, width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
  //       PosColumn(text: roundStringWith(tableDataDetailsPrint[i].unitPrice), width: 2, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //       PosColumn(text: roundStringWith(tableDataDetailsPrint[i].netAmount), width: 3, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
  //     ]);
  //
  //     printer.row([
  //       PosColumn(textEncoded: description, width: 7, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
  //       PosColumn(
  //           text: '',
  //           width: 5,
  //           styles: PosStyles(
  //             height: PosTextSize.size1,
  //           ))]);
  //     printer.hr();
  //   }
  //   printer.emptyLines(1);
  //   printer.row([
  //     PosColumn(text: 'Gross Amount', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: ga, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: roundStringWith(grossAmount), width: 6, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.row([
  //     PosColumn(text: 'Total Tax', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: tt, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: roundStringWith(totalTax), width: 6, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.row([
  //     PosColumn(text: 'Discount', width: 3, styles: PosStyles(fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: dis, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
  //     PosColumn(text: roundStringWith(discount), width: 6, styles: PosStyles(align: PosAlign.right)),
  //   ]);
  //   printer.setStyles(PosStyles.defaults());
  //   printer.setStyles(PosStyles(codeTable: 'CP864'));
  //   printer.hr();
  //   printer.row([
  //     PosColumn(text: 'Grand Total', width: 3, styles: PosStyles(bold: true, fontType: PosFontType.fontB)),
  //     PosColumn(textEncoded: gt, width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right, bold: true)),
  //     PosColumn(
  //         text: countyCodeCompany + " " + roundStringWith(grandTotal),
  //         width: 6,
  //         styles: PosStyles(fontType: PosFontType.fontA, bold: true, align: PosAlign.right)),
  //   ]);
  //   if (qrCodeAvailable == true) {
  //     /// details commented
  //     // printer.row([
  //     //   PosColumn(text: 'Cash receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
  //     //   PosColumn(textEncoded:cr,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
  //     //   PosColumn(text: roundStringWith(cashReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
  //     // ]);
  //     //
  //     //
  //     // printer.row([
  //     //   PosColumn(text: 'Bank receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
  //     //   PosColumn(textEncoded:br,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
  //     //   PosColumn(text: roundStringWith(bankReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
  //     // ]);
  //     //
  //     // printer.row([
  //     //   PosColumn(text: 'Balance', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
  //     //   PosColumn(textEncoded:bl,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
  //     //   PosColumn(text: roundStringWith(balance), width: 3,styles: PosStyles(align: PosAlign.right)),
  //     // ]);
  //     printer.feed(1);
  //     var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
  //         BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
  //     printer.qrcode(qrCode, size: QRSize.Size5);
  //   }
  //   // printer.emptyLines(1);
  //   // printer.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));
  //   printer.cut();
  // }
  /// commented because not using
//   Future<void> InvoicePrintTemplateDirectText({
//     required NetworkPrinter printer,
//     required bool tokenVal,
//     required String companyName,
//     required String address1Company,
//     required String city,
//     required String description,
//     required String countryNameCompany,
//     required String phoneCompany,
//     required String vatNumberCompany,
//     required String cRNumberCompany,
//     required String countyCodeCompany,
//     required String qrCodeImage,
//     required String voucherNumber,
//     required String ledgerName,
//     required String customerName,
//     required String date,
//     required String customerPhone,
//     required String grossAmount,
//     required String discount,
//     required String totalTax,
//     required String grandTotal,
//     required String companyLogoCompany,
//     required String tokenNumber,
//     required String cashReceived,
//     required String bankReceived,
//     required String balance,
//     required String salesType,
//     required var salesDetails,
//   }) async {
//     List<ProductDetailsModel> tableDataDetailsPrint = [];
//
//     // var salesDetails = BluetoothPrintThermalDetails.salesDetails;
//     print(salesDetails);
//     for (Map user in salesDetails) {
//       tableDataDetailsPrint.add(ProductDetailsModel.fromJson(user));
//     }
//
//     var logoAvailable = true;
//     var productDecBool = true;
//     var qrCodeAvailable = true;
//
//     var invoiceType;
//     var invoiceTypeArabic;
//
//     invoiceType = "SIMPLIFIED TAX INVOICE";
//     invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
//
//     if (PrintDataDetails.type == "SI") {
//       invoiceType = "SIMPLIFIED TAX INVOICE";
//       invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
//     }
//     if (PrintDataDetails.type == "SO") {
//       logoAvailable = false;
//       qrCodeAvailable = false;
//       productDecBool = false;
//       invoiceType = "SALES ORDER";
//       invoiceTypeArabic = "(طلب المبيعات)";
//     }
//
//     var companyAddress1 = address1Company;
//
//     var companyCountry = countryNameCompany;
//     var companyPhone = phoneCompany;
//     var companyTax = vatNumberCompany;
//     var companyCrNumber = cRNumberCompany;
//
//     var qrCodeData = qrCodeImage;
//
//     var customerName = ledgerName;
//     print("________________LedgerName   ${ledgerName}");
//     print("________________customerName     ${customerName}");
//
//     if (ledgerName == "Cash In Hand") {
//       customerName = customerName;
//     }
//
//     var orderType = salesType;
//
//     //
//     /// image print commented
//     // final Uint8List imageData = await _fetchImageData(BluetoothPrintThermalDetails.companyLogoCompany);
//     //
//     // final Img.Image? image = Img.decodeImage(imageData);
//     // final Img.Image resizedImage = Img.copyResize(image!, width: 200);
//     // printer.image(resizedImage);
//
//     printer.row([
//       PosColumn(text: '', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(text: '', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(text: '', width: 6, styles: const PosStyles(align: PosAlign.center)),
//     ]);
//     Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName));
//     Uint8List cityEncode = await CharsetConverter.encode("ISO-8859-6", setString(city));
//     Uint8List descriptionC = await CharsetConverter.encode("ISO-8859-6", setString(description));
//     Uint8List companyTaxEnc = await CharsetConverter.encode("ISO-8859-6", setString('ضريبه  ' + companyTax));
//     Uint8List companyCREnc = await CharsetConverter.encode("ISO-8859-6", setString('س. ت  ' + companyCrNumber));
//     Uint8List companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone));
//
//     Uint8List invoiceTypeEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
//     Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));
//
//     Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
//     Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('خصم'));
//     Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
//     Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
//
//     Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
//     Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
//     Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));
//
//     if (companyName != "") {
//       printer.textEncoded(companyNameEnc,
//           styles:
//               const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
//     }
//     if (description != "") {
//       printer.textEncoded(descriptionC, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (city != "") {
//       printer.textEncoded(cityEncode, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (companyTax != "") {
//       printer.textEncoded(companyTaxEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//     if (companyCrNumber != "") {
//       printer.textEncoded(companyCREnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//     if (companyPhone != "") {
//       printer.textEncoded(companyPhoneEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     printer.emptyLines(1);
//
//     printer.textEncoded(invoiceTypeEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     printer.textEncoded(invoiceTypeArabicEnc, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
//
//     printer.emptyLines(1);
//
//     var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
//     printer.setStyles(const PosStyles(align: PosAlign.left));
//
//     Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
//     Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
//     Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
//     Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
//     Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));
//     Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
//
//     if (tokenVal) {
//       printer.hr();
//       printer.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
//       printer.text(tokenNumber, styles: const PosStyles(height: PosTextSize.size3, width: PosTextSize.size3, bold: true, align: PosAlign.center));
//       printer.textEncoded(tokenEnc,
//           styles: const PosStyles(
//             align: PosAlign.right,
//             bold: true,
//           ));
//       printer.hr();
//     } else {
//       printer.row([
//         PosColumn(text: 'Token No ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: tokenEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(text: tokenNumber, width: 6, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//     }
//
//     printer.row([
//       PosColumn(text: 'Voucher No  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           textEncoded: voucherNoEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: voucherNumber, width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//
//     printer.row([
//       PosColumn(text: 'Date  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(textEncoded: dateEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: date, width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//
//     Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName));
//     Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));
//
//     if (customerName != "") {
//       printer.row([
//         PosColumn(text: 'Name    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//         PosColumn(
//             textEncoded: customerEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(
//             textEncoded: customerNameEnc,
//             width: 6,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//     }
//     if (customerPhone != "") {
//       printer.row([
//         PosColumn(text: 'Phone    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//         PosColumn(
//             textEncoded: phoneEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(
//             textEncoded: phoneNoEncoded,
//             width: 6,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//     }
//
//     printer.setStyles(const PosStyles.defaults());
//     printer.setStyles(const PosStyles(codeTable: 'CP864'));
//     printer.row([
//       PosColumn(text: 'Order type    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(textEncoded: typeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: orderType, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//     // printer.row([
//     //   PosColumn(text: '', width: 5, styles: PosStyles(fontType: PosFontType.fontB)),
//     //   PosColumn(text: "", width: 7, styles: PosStyles(align: PosAlign.right)),
//     // ]);
//
//     // printer.row([
//     //   PosColumn(text: 'Token No ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: token, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // ]);
//
//     // printer.row([
//     //   PosColumn(text: 'Voucher No :', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: voucherNumber, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // ]);
//     // printer.row([
//     //   PosColumn(text: 'Date      ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: date, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // ]);
//
//     // if(customerName != ""){
//     //   printer.row([
//     //     PosColumn(text: 'Name    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //     PosCol
//     //     umn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //     PosColumn(textEncoded: customerNameEnc, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   ]);
//     // }
//     //
//     // if(customerPhone != ""){
//     //   printer.row([
//     //     PosColumn(text: 'Phone    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //     PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //     PosColumn(textEncoded: phoneNoEncoded, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   ]);
//     // }
//     //
//
//     // printer.row([
//     //   PosColumn(text: 'Order type    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     //   PosColumn(text: orderType, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     // ]);
//
//     printer.hr();
//
//     Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
//     Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
//     Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString("كمية"));
//     Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
//     Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));
//
//     // printer.setStyles(PosStyles(align: PosAlign.center));
//     // printer.setStyles(PosStyles(align: PosAlign.left));
//
//     printer.row([
//       PosColumn(
//           text: 'SL',
//           width: 1,
//           styles: const PosStyles(
//             height: PosTextSize.size1,
//           )),
//       PosColumn(text: 'Item Name', width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(text: 'Qty', width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(text: 'Rate', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: 'Net', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//     printer.row([
//       PosColumn(
//           textEncoded: slNoEnc,
//           width: 1,
//           styles: const PosStyles(
//             height: PosTextSize.size1,
//           )),
//       PosColumn(textEncoded: productNameEnc, width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(textEncoded: qtyEnc, width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//       PosColumn(textEncoded: rateEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(textEncoded: netEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//     printer.hr();
//
//     for (var i = 0; i < tableDataDetailsPrint.length; i++) {
//       var slNo = i + 1;
//
//       Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription));
//       Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName));
//
//       printer.row([
//         PosColumn(
//             text: "$slNo",
//             width: 1,
//             styles: const PosStyles(
//               height: PosTextSize.size1,
//             )),
//         PosColumn(textEncoded: productName, width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//         PosColumn(text: tableDataDetailsPrint[i].qty, width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: tokenVal)),
//         PosColumn(
//             text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
//             width: 2,
//             styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(
//             text: roundStringWith(tableDataDetailsPrint[i].netAmount),
//             width: 3,
//             styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//
//       printer.row([
//         PosColumn(
//             textEncoded: description, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(
//             text: '',
//             width: 5,
//             styles: const PosStyles(
//               height: PosTextSize.size1,
//             ))
//       ]);
//       printer.hr();
//     }
//     printer.emptyLines(1);
//     printer.row([
//       PosColumn(text: 'Gross Amount', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(textEncoded: ga, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: roundStringWith(grossAmount), width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//     printer.row([
//       PosColumn(text: 'Total Tax', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(textEncoded: tt, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: roundStringWith(totalTax), width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//     printer.row([
//       PosColumn(text: 'Discount', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(textEncoded: dis, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: roundStringWith(discount), width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//     printer.setStyles(const PosStyles.defaults());
//     printer.setStyles(const PosStyles(codeTable: 'CP864'));
//     printer.hr();
//     printer.row([
//       PosColumn(text: 'Grand Total', width: 3, styles: const PosStyles(bold: true, fontType: PosFontType.fontB)),
//       PosColumn(
//           textEncoded: gt, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right, bold: true)),
//       PosColumn(
//           text: countyCodeCompany + " " + roundStringWith(grandTotal),
//           width: 6,
//           styles: const PosStyles(fontType: PosFontType.fontA, bold: true, align: PosAlign.right)),
//     ]);
//     if (qrCodeAvailable == true) {
//       /// details commented
//       // printer.row([
//       //   PosColumn(text: 'Cash receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
//       //   PosColumn(textEncoded:cr,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//       //   PosColumn(text: roundStringWith(cashReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
//       // ]);
//       //
//       //
//       // printer.row([
//       //   PosColumn(text: 'Bank receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
//       //   PosColumn(textEncoded:br,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//       //   PosColumn(text: roundStringWith(bankReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
//       // ]);
//       //
//       // printer.row([
//       //   PosColumn(text: 'Balance', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
//       //   PosColumn(textEncoded:bl,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//       //   PosColumn(text: roundStringWith(balance), width: 3,styles: PosStyles(align: PosAlign.right)),
//       // ]);
//       printer.feed(1);
//       var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
//           BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
//       printer.qrcode(qrCode, size: QRSize.Size5);
//     }
//     // printer.emptyLines(1);
//     // printer.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));
//
//     printer.cut();
//   }

  printKotPrint(var id, rePrint, cancelOrder, isUpdate, isCancelled) async {
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

        print("url  $url");

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
              await kotPrintConnect(printListData[i].ip, i,
                  printListData[i].items, false, isUpdate, isCancelled);
              await Future.delayed(
                  const Duration(seconds: 1)); // Add a delay between print jobs
            } catch (e) {
              print('log ${e.toString()}');
              print(e.toString());
            }
          }

          /// cancel order print
          print(
              "------------------------cancelOrder-----$cancelOrder---------cancelOrder---------------");
          for (var index = 0; index < cancelOrder.length; index++) {
            try {
              print('------------------ index $index');
              dataPrint.clear();
              await kotPrintConnect(printListDataCancel[index].ip, index,
                  printListDataCancel[index].items, true, false, false);
              await Future.delayed(
                  const Duration(seconds: 1)); // Add a delay between print jobs
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
      } catch (e) {
        print("got error in kot api ${e.toString()}");
      }
    }
  }

  Future<void> kotPrintConnect(String printerIp, id, items, bool isCancelNote,
      isUpdate, isCancelled) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var temp = prefs.getString("template") ?? "template4";
      var userName = prefs.getString('user_name') ?? "";
      var capabilities = prefs.getString("default_capabilities") ?? "default";

      print("template =---------------------- $temp");
      var profile;
      if (capabilities == "default") {
        profile = await CapabilityProfile.load();
      } else {
        profile = await CapabilityProfile.load(name: capabilities);
      }
      const PaperSize paper = PaperSize.mm80;
      final printer = NetworkPrinter(paper, profile);
      var port = int.parse("9100");

      print(
          "-------------------------------1------------------------------------------");
      // Function to connect to printer with retries
      Future<PosPrintResult> connectPrinter() async {
        int retries = 3;
        for (int i = 0; i < retries; i++) {
          print(
              "-------------------------------1.5------------------------------------------");
          final PosPrintResult res =
              await printer.connect(printerIp, port: port);
          if (res == PosPrintResult.success) {
            return res;
          } else {
            print("Attempt ${i + 1} failed: ${res.msg}");
          }
        }
        return PosPrintResult.timeout; // or any other error you wish to return
      }

      print(
          "-------------------------------2------------------------------------------");
      final PosPrintResult res = await connectPrinter();
      print("print result ${res.msg}");

      if (res == PosPrintResult.success) {
        if (temp == 'template4') {
          print(
              "-------------------------------3------------------------------------------");
          await kotPrint(
              printer, id, items, isCancelNote, isUpdate, isCancelled);
        } else if (temp == 'template3') {
          await kotPrintGst(printer, id, items, isCancelNote, isUpdate);
        } else {
          await printArabicKot(printer, id, items);
        }
        print(
            "-------------------------------4------------------------------------------");
        // Disconnecting printer properly
        await Future.delayed(const Duration(seconds: 1));
        printer.disconnect();
        print("Printer disconnected successfully.");
      } else {
        print('---${res.msg}----d------------');
      }
    } catch (e) {
      print('--------******************----------------------${e.toString()}');
    }
  }

  // Future<void> kotPrintConnect(String printerIp, id, items, bool isCancelNote, isUpdate) async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var temp = prefs.getString("template") ?? "template4";
  //     var userName = prefs.getString('user_name')??"";
  //     var capabilities = prefs.getString("default_capabilities") ?? "default";
  //
  //
  //     print("template =---------------------- $temp");
  //     var profile;
  //     if (capabilities == "default") {
  //       profile = await CapabilityProfile.load();
  //     } else {
  //       profile = await CapabilityProfile.load(name: capabilities);
  //     }
  //     const PaperSize paper = PaperSize.mm80;
  //     final printer = NetworkPrinter(paper, profile);
  //
  //     var port = int.parse("9100");
  //     final PosPrintResult reconnect = await printer.connect(printerIp, port: port);
  //     if(reconnect == PosPrintResult.success){
  //       printer.disconnect();
  //     }
  //
  //     final PosPrintResult res = await printer.connect(printerIp, port: port);
  //     print("print result ${res.msg}");
  //
  //     if (res == PosPrintResult.success) {
  //       if (temp == 'template4') {
  //         await kotPrint(printer, id, items, isCancelNote, isUpdate);
  //      //   await disconnectWithPrinter(printer);
  //       }
  //       else if (temp == 'template3') {
  //         await kotPrintGst(printer, id, items, isCancelNote, isUpdate);
  //       }
  //       else {
  //         await printArabicKot(printer, id, items);
  //       }
  //
  //       // Future.delayed(const Duration(seconds: 1), ()async {
  //       //   print("------after delay----------------------------strting for printing process");
  //       //   printer.disconnect();
  //       // });
  //
  //
  //
  //     } else {
  //       print('---${res.msg}----d------------');
  //     }
  //   } catch (e) {
  //     print('------------------------------${e.toString()}');
  //   }
  // }

  disconnectWithPrinter(NetworkPrinter printer) {
    print(
        "------after delay----------------------------strting for printing process");
    printer.disconnect(delayMs: 10);
  }

  /// Direct text method
  Future<void> kotPrint(NetworkPrinter printer, id, items, bool isCancelNote,
      isUpdate, isCancelled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('user_name') ?? "";
    bool showUsernameKot = prefs.getBool('show_username_kot') ?? false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot') ?? false;
    bool extraDetailsInKOT = prefs.getBool('extraDetailsInKOT') ?? false;
    var defaultCodePage = prefs.getString("default_code_page") ?? "CP864";
    var currentTime = DateTime.now();
    print("----------------$currentTime");

    List kotList = [];

    //   List<ItemsDetails> dataPrints = [];
    kotList.clear();
    kotList = items;
    print(
        "-------------------------------10----------------------------$items--------------");

    var kitchenName = "";

    var totalQty = (kotList[0]["Qty"]?.toString() ?? "0");

    if (isCancelNote == false) {
      if (printListData.isNotEmpty) {
        kitchenName = printListData[id].kitchenName ?? "";
        totalQty = printListData[id].totalQty ?? "0";
      }
    }

    var tableName = kotList[0]["TableName"] ?? "";
    var tokenNumber = kotList[0]["TokenNumber"].toString();
    var orderType = kotList[0]["OrderType"] ?? "";
    printer.setStyles(
        PosStyles(codeTable: defaultCodePage, align: PosAlign.center));

    var cancelNoteArabic = "تم إلغاء هذا العنصر من قبل العميل.";
    var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";

    var updateNoteArabic = "تم إجراء بعض التغييرات في";
    var updateNote = "MADE SOME CHANGES IN";

    Uint8List cancelNoteEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString(cancelNoteArabic));
    Uint8List updateNoteEnc = await CharsetConverter.encode(
        "ISO-8859-6", setString(updateNoteArabic));

    var invoiceType = "KOT";
    var invoiceTypeArabic = "طباعة المطب";

    Uint8List typeEng =
        await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
    Uint8List typeArabic = await CharsetConverter.encode(
        "ISO-8859-6", setString(invoiceTypeArabic));
    //printer.text('', styles: const PosStyles(align: PosAlign.left));

    printer.textEncoded(typeEng,
        styles: const PosStyles(
            height: PosTextSize.size3,
            width: PosTextSize.size5,
            align: PosAlign.center,
            fontType: PosFontType.fontB,
            bold: true));
    // printer.text('', styles: PosStyles(align: PosAlign.left));

    if (isCancelled) {
      printer.text("ORDER CANCELLED",
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size3,
              align: PosAlign.center,
              fontType: PosFontType.fontB,
              bold: true));
    }

    printer
        .setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    printer.textEncoded(typeArabic,
        styles: const PosStyles(
            height: PosTextSize.size2,
            width: PosTextSize.size1,
            align: PosAlign.center,
            fontType: PosFontType.fontA,
            bold: true));
    printer.text('', styles: const PosStyles(align: PosAlign.left));
    if (extraDetailsInKOT) {
      if (isCancelNote) {
        printer.text(cancelNoteData,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center,
                fontType: PosFontType.fontB,
                bold: true));
        printer.setStyles(
            PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        printer.textEncoded(cancelNoteEnc,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center,
                fontType: PosFontType.fontA,
                bold: true));
      }

      if (isUpdate) {
        printer.text(updateNote,
            styles: const PosStyles(
                height: PosTextSize.size2,
                width: PosTextSize.size1,
                align: PosAlign.center,
                fontType: PosFontType.fontB,
                bold: true));
        printer.setStyles(
            PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
        printer.textEncoded(updateNoteEnc,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center,
                fontType: PosFontType.fontA,
                bold: true));
      }
    }

    Uint8List tokenEnc =
        await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
    printer.hr();
    printer.text('Token No',
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
            align: PosAlign.center));
    printer.text('', styles: const PosStyles(align: PosAlign.left));
    printer.text(tokenNumber,
        styles: const PosStyles(
            height: PosTextSize.size4,
            width: PosTextSize.size5,
            bold: false,
            align: PosAlign.center));
    //  printer.text(tokenNumber, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
    printer.text('', styles: const PosStyles(align: PosAlign.left));
    printer.textEncoded(tokenEnc,
        styles: const PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            align: PosAlign.center));
    printer.hr();
    print(
        "******************************************************************************************************************7");
    if (showUsernameKot) {
      printer.row([
        PosColumn(
            text: 'User name     :',
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
        PosColumn(
            text: userName,
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
      ]);
    }
    if (showDateTimeKot) {
      printer.row([
        PosColumn(
            text: 'Time    :',
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
        PosColumn(
            text: convertDateAndTime(currentTime),
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
      ]);
    }
    printer.row([
      PosColumn(
          text: 'Kitchen name :',
          width: 4,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: kitchenName,
          width: 8,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(
          text: 'Order type       :',
          width: 4,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(
          text: orderType,
          width: 8,
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    if (orderType == "Dining") {
      printer.row([
        PosColumn(
            text: 'Table Name       :',
            width: 4,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: tableName,
            width: 8,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
      ]);
    }

    // printer.setStyles(const PosStyles.defaults());
    printer.setStyles(PosStyles(codeTable: defaultCodePage));
    printer.hr();
    printer.row([
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
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    printer.hr();
    print(
        "-------------------------------13------------------------------------------");
    for (var i = 0; i < kotList.length; i++) {
      var slNo = i + 1;

      var productDescription = kotList[i]["ProductDescription"] ?? '';
      Uint8List productName = await CharsetConverter.encode(
          "ISO-8859-6", setString(kotList[i]["ProductName"]));

      printer.row([
        PosColumn(
            text: '$slNo',
            width: 2,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            textEncoded: productName,
            width: 8,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: kotList[i]["Qty"].toString(),
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (productDescription != "") {
        Uint8List productDescriptionEnc = await CharsetConverter.encode(
            "ISO-8859-6", setString(productDescription));
        printer.textEncoded(productDescriptionEnc,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }

      if (kotList[i]["flavour"] != "") {
        Uint8List flavour = await CharsetConverter.encode(
            "ISO-8859-6", setString(kotList[i]["flavour"]));
        printer.textEncoded(flavour,
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }
      printer.hr();
    }
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Total quantity',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              fontType: PosFontType.fontB,
              bold: true)),
      PosColumn(text: '', width: 7),
      PosColumn(
          text: roundStringWith(totalQty),
          width: 2,
          styles: (const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              fontType: PosFontType.fontB,
              bold: true,
              align: PosAlign.right))),
    ]);

    printer.cut();
  }

  /// Direct text method for Gst company
  Future<void> kotPrintGst(
      NetworkPrinter printer, id, items, bool isCancelNote, isUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userName = prefs.getString('user_name') ?? "";
    bool showUsernameKot = prefs.getBool('show_username_kot') ?? false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot') ?? false;
    var currentTime = DateTime.now();

    List kotList = [];

    kotList.clear();
    kotList = items;

    var kitchenName = "";

    var totalQty = (kotList[0]["Qty"]?.toString() ?? "0");
    if (isCancelNote == false) {
      if (printListData.isNotEmpty) {
        kitchenName = printListData[id].kitchenName ?? "";
        totalQty = printListData[id].totalQty ?? "0";
      }
    }

    var tableName = kotList[0]["TableName"] ?? "";
    var tokenNumber = kotList[0]["TokenNumber"].toString();
    var orderType = kotList[0]["OrderType"] ?? "";

    var cancelNoteData = "THIS ITEM WAS CANCELLED BY THE CUSTOMER.";
    var updateNote = "RUNNING ORDER";
    var invoiceType = "KOT";
    printer.text(invoiceType,
        styles: const PosStyles(
            height: PosTextSize.size3,
            width: PosTextSize.size5,
            align: PosAlign.center,
            fontType: PosFontType.fontB,
            bold: true));
    printer.text('', styles: const PosStyles(align: PosAlign.left));

    if (isCancelNote) {
      printer.text(cancelNoteData,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
              fontType: PosFontType.fontB,
              bold: true));
    }

    if (isUpdate) {
      printer.text(updateNote,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              align: PosAlign.center,
              fontType: PosFontType.fontB,
              bold: true));
    }
    print("------------------------------------------------3");

    printer.hr();
    printer.text('Token No',
        styles: const PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            bold: true,
            align: PosAlign.center));
    // printer.text('', styles: const PosStyles(align: PosAlign.left));

    printer.text(tokenNumber,
        styles: const PosStyles(
            height: PosTextSize.size4,
            width: PosTextSize.size5,
            bold: false,
            align: PosAlign.center));

    // printer.text('', styles: const PosStyles(align: PosAlign.left,fontType: PosFontType.fontB,));
    printer.hr();

    if (showUsernameKot) {
      printer.row([
        PosColumn(
            text: 'User name     ',
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
        PosColumn(
            text: userName,
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
      ]);
    }
    if (showDateTimeKot) {
      printer.row([
        PosColumn(
            text: 'Time    :',
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
        PosColumn(
            text: convertDateAndTime(currentTime),
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
      ]);
    }
    printer.row([
      PosColumn(
          text: 'Kitchen name     :',
          width: 4,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1)),
      PosColumn(
          text: kitchenName,
          width: 8,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(
          text: 'Order type       :',
          width: 4,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1)),
      PosColumn(
          text: orderType,
          width: 8,
          styles: const PosStyles(
              fontType: PosFontType.fontA,
              height: PosTextSize.size1,
              width: PosTextSize.size1)),
    ]);

    if (orderType == "Dining") {
      printer.row([
        PosColumn(
            text: 'Table Name       :',
            width: 4,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
        PosColumn(
            text: tableName,
            width: 8,
            styles: const PosStyles(
                fontType: PosFontType.fontA,
                height: PosTextSize.size1,
                width: PosTextSize.size1)),
      ]);
    }
    print("------------------------------------------------4");

    // printer.setStyles(const PosStyles.defaults());
    // printer.setStyles(const PosStyles(codeTable: 'CP864'));
    printer.hr();
    printer.row([
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
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    printer.hr();
    print("------------------------------------------------4");

    for (var i = 0; i < kotList.length; i++) {
      var slNo = i + 1;

      var productDescription = kotList[i]["ProductDescription"] ?? '';

      print("------------------------------------------------4");

      printer.row([
        PosColumn(
            text: '$slNo',
            width: 2,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(
            text: kotList[i]["ProductName"],
            width: 8,
            styles: const PosStyles(
                height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            text: roundStringWith(kotList[i]["Qty"].toString()),
            width: 2,
            styles: const PosStyles(
                height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      if (productDescription != "") {
        printer.row([
          PosColumn(
              text: '',
              width: 2,
              styles: const PosStyles(
                height: PosTextSize.size1,
              )),
          PosColumn(
              text: productDescription,
              width: 10,
              styles: const PosStyles(
                  height: PosTextSize.size1, width: PosTextSize.size1)),
        ]);
      }
      print("------------------------------------------------4");

      if (kotList[i]["flavour"] != "") {
        printer.text(kotList[i]["flavour"],
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size1,
                align: PosAlign.center));
      }
      printer.hr();
    }
    printer.feed(1);
    printer.row([
      PosColumn(
          text: 'Total quantity',
          width: 3,
          styles: const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              fontType: PosFontType.fontB,
              bold: true)),
      PosColumn(text: '', width: 7),
      PosColumn(
          text: roundStringWith(totalQty),
          width: 2,
          styles: (const PosStyles(
              height: PosTextSize.size2,
              width: PosTextSize.size1,
              fontType: PosFontType.fontB,
              bold: true,
              align: PosAlign.right))),
    ]);
    printer.cut();
    //   printer.disconnect();
  }

  /// arabic kot image print method
  Future<void> printArabicKot(NetworkPrinter printer, id, items) async {
    print('----------printArabicKot-----------------$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var width = prefs.getString('width') ?? '150';

    final content =
        ThermalEnglishDesignKot.getInvoiceContent(id, items, width + 'mm');
    var bytes = await WebcontentConverter.contentToImage(content: content);
    final Image? image = decodeImage(bytes);
    printer.imageRaster(image!);
    printer.cut();
  }

  /// test print
  Future<void> testPrintConnect(String printerIp) async {
    try {
      print("a");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var temp = prefs.getString("template") ?? "template4";
      var capabilities = prefs.getString("default_capabilities") ?? "default";
      print("a");
      var profile;
      if (capabilities == "default") {
        profile = await CapabilityProfile.load();
      } else {
        profile = await CapabilityProfile.load(name: capabilities);
      }
      print("a");
      const PaperSize paper = PaperSize.mm80;
      final printer = NetworkPrinter(paper, profile);
      var port = int.parse("9100");
      print("a $printerIp");
      final PosPrintResult res = await printer.connect(printerIp, port: port);
      print("print result ${res.msg}");

      if (res == PosPrintResult.success) {
        testPrint(printer);

        printer.disconnect();
      } else {
        print('---${res.msg}----d------------');
      }
    } catch (e) {
      print('------------------------------${e.toString()}');
    }
  }

  Future<void> testPrint(NetworkPrinter printer) async {
    // final ByteData data = await rootBundle.load('assets/fonts/CustomArabicFont.ttf');
    // final Uint8List fontData = data.buffer.asUint8List();

    // Render text to image
    // final img.Image image = img.Image(width: 200,height: 400);
    // img.fill(image,  color: Colors.black);
    // final ttf = img.BitmapFont.fromTtf(fontData, 24);
    // img.drawString(image, ttf, 20, 'السلام عليكم وصباح الخير 98', font: ttf);

    printer.setStyles(const PosStyles.defaults());
    printer
        .setStyles(const PosStyles(codeTable: 'CP864', align: PosAlign.center));
    printer.text('Test kot', styles: const PosStyles(align: PosAlign.left));
    printer.emptyLines(1);
    printer.setStyles(const PosStyles.defaults());
    printer.setStyles(const PosStyles(codeTable: 'CP864'));
    printer.hr();
    printer.row([
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
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: const PosStyles(
              height: PosTextSize.size1, align: PosAlign.right)),
    ]);
    printer.hr();

    printer.disconnect();
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

  Future<void> printArabic(NetworkPrinter printer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var temp = prefs.getString("template") ?? "template4";
    var width = prefs.getString('width') ?? '150';

    final content;
    if (temp == 'template1') {
      content = ArabicThermalPrint.getInvoiceContent(width + 'mm');
    } else if (temp == 'template2') {
      content = ThermalPrint.invoiceDesign(width + 'mm');
    } else {
      content = ThermalArabicShort.invoiceDesign(width + 'mm');
    }

    var bytes = await WebcontentConverter.contentToImage(content: content);
    final Image? image = decodeImage(bytes);
    printer.imageRaster(image!);

    printer.cut();
  }
}

class ProductDetailsModel {
  final String unitName,
      qty,
      netAmount,
      productName,
      flavourName,
      unitPrice,
      productDescription;

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
      flavourName: json['flavour_name'] ?? "",
    );
  }
}
