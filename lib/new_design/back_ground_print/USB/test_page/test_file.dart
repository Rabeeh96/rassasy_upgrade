import 'dart:convert';
import 'package:image/image.dart' as Img;
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:rassasy_new/Print/qr_generator.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart'
    as usb_esc_printer_windows;
 import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';

import 'dart:ui' as ui;
class USBPrintClassTest {
  printDetails(
      {required String id,
      required String type,
      required BuildContext context}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      popAlert(
          head: "Alert",
          message: "Check your network connection",
          position: SnackPosition.TOP);
    } else {
      try {
        print("  ---------   --------- start to api call  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
        // start(context);
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var currency = prefs.getString('CurrencySymbol') ?? "";
        final String url = '$baseUrl/posholds/view/pos-sale/invoice/$id/';
        print(url);
        print(accessToken);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,
          "Type": type
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

        if (status == 6000) {
          print("  ---------   --------- get api response  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
          var voucherNumber = responseJson["VoucherNo"].toString();
          var customerName = responseJson["CustomerName"] ?? 'Cash In Hand';
          var date = responseJson["Date"];
          var netTotal = responseJson["NetTotal_print"].toString();
          var customerPhone = responseJson["OrderPhone"] ?? "";
          var grossAmount = responseJson["GrossAmt_print"].toString();
          var sGstAmount = responseJson["SGSTAmount"].toString();
          var cGstAmount = responseJson["CGSTAmount"].toString();
          var tokenNumber = responseJson["TokenNumber"].toString();
          var discount = responseJson["TotalDiscount_print"].toString();
          var grandTotal = responseJson["GrandTotal_print"].toString();
          var qrCodeImage = responseJson["qr_image"];
          var customerTaxNumber = responseJson["TaxNo"].toString();

          var ledgerName = responseJson["LedgerName"] ?? '';
          var customerAddress = responseJson["Address1"];
          var customerAddress2 = responseJson["Address2"];
          var customerCrNumber = responseJson["CustomerCRNo"] ?? "";
          var cashReceived = responseJson["CashReceived"].toString() ?? "0";
          var bankReceived = responseJson["BankAmount"].toString() ?? "0";

          var balance = responseJson["Balance"].toString() ?? "";
          var salesType = responseJson["OrderType"] ?? "";
          var salesDetails = responseJson["SalesDetails"];
          var totalVATAmount = responseJson["VATAmount"];
          var totalExciseAmount = responseJson["ExciseTaxAmount"] ?? "0";
          var totalTax = responseJson["TotalTax_print"].toString();
          var companyDetails = responseJson["CompanyDetails"];

          var companyName = companyDetails["CompanyName"] ?? '';
          var buildingNumber = companyDetails["Address1"] ?? '';
          var secondName = companyDetails["CompanyNameSec"] ?? '';
          var streetName = companyDetails["Street"] ?? '';
          var state = companyDetails["StateName"] ?? '';
          var postalCodeCompany = companyDetails["PostalCode"] ?? '';
          var phoneCompany = companyDetails["Phone"] ?? '';
          var mobileCompany = companyDetails["Mobile"] ?? '';
          var taxNumberCompany = companyDetails["VATNumber"] ?? '';
          var companyGstNumber = companyDetails["GSTNumber"] ?? '';
          var cRNumberCompany = companyDetails["CRNumber"] ?? '';
          var descriptionCompany = companyDetails["Description"] ?? '';
          var countryNameCompany = companyDetails["CountryName"] ?? '';
          var stateNameCompany = companyDetails["StateName"] ?? '';
          var companyLogoCompany = companyDetails["CompanyLogo"] ?? '';
          var countyCodeCompany = companyDetails["CountryCode"] ?? '';
          var buildingNumberCompany = companyDetails["Address1"] ?? '';
          var tableName = responseJson["TableName"] ?? '';
          var time = responseJson["CreatedDate"] ?? "${DateTime.now()}";
          print("  ---------   --------- start to generate image   ---------   ${DateTime.now().minute} ${DateTime.now().second} ");

          final arabicImageBytes = await generateInvoice(
              balance: "",
              bankReceived: bankReceived,
              companyLogoCompany: companyLogoCompany,
              buildingDetails: buildingNumberCompany,
              cashReceived: cashReceived,
              companyCountry: countryNameCompany,
              companyCrNumber: cRNumberCompany,
              companyName: companyName,
              companyPhone: phoneCompany,
              companySecondName: secondName,
              companyTax: taxNumberCompany,
              countyCodeCompany: countyCodeCompany,
              customerName: customerName,
              customerPhone: customerPhone,
              date: date,
              discount: discount,
              exciseAmountTotal: totalExciseAmount,
              grandTotal: grandTotal,
              grossAmount: grossAmount,
              orderType: salesType,
              qrCodeData: "",
              streetName: streetName,
              tableName: tableName,
              token: tokenNumber,
              totalTax: totalTax,
              vatAmountTotal: totalVATAmount,
              voucherNumber: voucherNumber,
              voucherType: type,
              saleDetails: salesDetails);
        //  stop();

          print("------------------ get image response  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");

     //  return  arabicImageBytes;
          var isoDate = DateTime.parse(date).toIso8601String();
          var qrCode = await b64Qrcode(companyName, taxNumberCompany, isoDate, grandTotal, totalTax);
          await printReq(arabicImageBytes, qrCode, type == "SI" ? true : false);
          return 2;
        } else if (status == 6001) {
         // stop();
          return 3;
        }

        //DB Error
        else {
        //  stop();
          return 3;
        }
      } catch (e) {
      //  stop();
        return 3;
      }
    }
  }

  // dependencies:
  // flutter_image_compress: ^1.1.0
  // Import the package in your Dart file:



// Usage
//   final compressedImageBytes = await compressImage(arabicImageBytes);
//   final Img.Image? image = Img.decodeImage(compressedImageBytes);
//   final Img.Image resizedImage = Img.copyResize(image!, width: 550);
//   bytes += generator.imageRaster(resizedImage);





  Future<Uint8List> _fetchImageData(l) async {
    final http.Response response = await http.get(Uri.parse("https://www.api.viknbooks.com/media/company-logo/blob_xAHD3sX"));
    // final http.Response response = await http.get(Uri.parse("https://www.api.viknbooks.com/media/company-logo/WhatsApp_Image_2024-07-10_at_12.43.00_PM_s4PUuKU.jpeg"));
    return response.bodyBytes;
  }


  printReq(arabicImageBytes,qrCode, needQR) async {
    print("  ---------start print method  ---------   ---------     ${DateTime.now().second} ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    // List<int> bytes = [];
    // final profile = await CapabilityProfile.load();
    // final generator = Generator(PaperSize.mm80, profile,);


    //
    // print("Start");
    // // Decode and resize image asynchronously with explicit types
    // final Img.Image? image = await compute<Uint8List, Img.Image?>(decodeImage, arabicImageBytes);
    // final DateTime afterDecode = DateTime.now();
    // print("Image decoded: ${afterDecode.minute} ${afterDecode.second}");
    //
    // if (image == null) {
    //   print("Failed to decode image");
    //   return;
    // }
    //
    // final Img.Image resizedImage = await compute<Img.Image, Img.Image>(resizeImage, image);
    // final DateTime afterResize = DateTime.now();
    // print("Image resized: ${afterResize.minute} ${afterResize.second}");
    //
    // // Generate ESC/POS bytes
    List<int> bytes = [];
    final generator = Generator(PaperSize.mm80, await CapabilityProfile.load());
    // bytes.addAll(generator.imageRaster(resizedImage));
    // final DateTime afterRaster = DateTime.now();
    // print("Image rasterized: ${afterRaster.minute} ${afterRaster.second}");
    //
    //



/// crop method
    // var ii = Img.decodeImage(arabicImageBytes!);
    // final Img.Image _resize = Img.copyResize(ii!, width:PaperSize.mm80.width);
    // // bytes += generator.imageRaster(_resize,);
    // int width = ii!.width;
    // int height = ii.height;
    // print('Original Resolution: ${width}x${height}');
    // print('Resized Resolution: ${_resize.width}x${_resize.height}');
    // print('--------------: ${_resize.width*_resize.height}');
    // // Get the total height
    // // int totalHeight = _resize.height;
    //
    // // Calculate height for each part
    //
    // int totalHeight = _resize.height;
    // print("totalHeight $totalHeight");
    //
    // // Calculate number of parts
    // int parts = (totalHeight / 10).ceil();
    //
    // for (int i = 0; i < parts; i++) {
    //   // Calculate the start y position for cropping
    //   int startY = i * 10;
    //
    //   print("startY $startY");
    //   // Ensure the last part captures any remaining height
    //   int height = (i == parts - 1) ? (totalHeight - startY) : 10;
    //   print("height $height");
    //   // Crop the image
    //   final Img.Image cropped = Img.copyCrop(_resize, x: 0, y: startY, width: _resize.width, height: height);
    //
    //   // Add the cropped part to bytes
    //   bytes += generator.imageRaster(cropped);
    // }





    // final Uint8List imageData = await _fetchImageData("");
    // final Img.Image? image1 = Img.decodeImage(imageData);
    // final Img.Image resizedImage1 = Img.copyResize(image1!, width: 500,height: 1000);
    // bytes += generator.imageRaster(resizedImage1);




    // bytes.addAll(generator.cut());


    // final ByteData data = await rootBundle.load('assets/png/Edit_Icon_png.png');
    // final Uint8List bytess = data.buffer.asUint8List();
    // final Img.Image? image = Img.decodeImage(bytess!);
    // bytes += generator.imageRaster(image!);
    /// multiple pbject
    //  var arabicImageBytes  =await testData();
    // var arabicImageBytes1  =await testData();
    // var arabicImageBytes2  =await testData();

    // final Img.Image? image = Img.decodeImage(bytess);
    // final Img.Image resizedImage = Img.copyResize(image!, width: 259);
    // bytes += generator.imageRaster(resizedImage);
    // //
    // final Img.Image? image1 = Img.decodeImage(arabicImageBytes1);
    // final Img.Image resizedImage1= Img.copyResize(image1!, width: 600);
    // bytes += generator.imageRaster(resizedImage1);
    //
    // final Img.Image? image2 = Img.decodeImage(arabicImageBytes2);
    // final Img.Image resizedImage2 = Img.copyResize(image2!, width: 570);
    // bytes += generator.imageRaster(resizedImage2);
    /// commented for test purpose


    print("  ---------    --------- img function 1 before decode  ---------   ${DateTime.now().minute} ${DateTime.now().second}  ${DateTime.now().millisecond}" );
    final Img.Image? image = Img.decodeImage(arabicImageBytes);
    print("  ---------   --------- img function 2 cafter decode------resize ${DateTime.now().minute} ${DateTime.now().second}  ${DateTime.now().millisecond}" );
    final Img.Image resizedImage = Img.copyResize(image!, width: 530);
    print("resizedImage.frames${resizedImage.frames}");
    print("  ---------   --------- img function 3  ---------b raster         ${DateTime.now().minute} ${DateTime.now().second}  ${DateTime.now().millisecond}" );
    bytes += generator.imageRaster(resizedImage,);
    print("  ---------   --------- img function 4  ---------a raster         ${DateTime.now().minute} ${DateTime.now().second}  ${DateTime.now().millisecond} ");

    if (needQR) {
      bytes += generator.feed(1);
      bytes += generator.qrcode(qrCode, size: QRSize.Size5);
    }
    bytes.addAll(generator.cut());
    //bytes += generator.text("text");

    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, defaultIp,);

    print("  ---------   --------- img function final  ---------   ${DateTime.now().minute} ${DateTime.now().second} ${DateTime.now().millisecond} ");
    String msg = "";

    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }
  }

  /// 2.83second
  //
  // printReq(arabicImageBytes,qrCode, needQR) async {
  //   print("  ---------start print method  ---------   ---------     ${DateTime.now().second} ");
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var defaultIp = prefs.getString('defaultIP') ?? '';
  //   List<int> bytes = [];
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile,);
  //
  //
  //   print("Start");
  //   final Img.Image? image = await compute<Uint8List, Img.Image?>(decodeImage, arabicImageBytes);
  //   final DateTime afterDecode = DateTime.now();
  //   print("Image decoded: ${afterDecode.minute} ${afterDecode.second}");
  //
  //   if (image == null) {
  //     print("Failed to decode image");
  //     return;
  //   }
  //
  //   final Img.Image resizedImage = await compute<Img.Image, Img.Image>(resizeImage, image);
  //   final DateTime afterResize = DateTime.now();
  //   print("Image resized: ${afterResize.minute} ${afterResize.second}");
  //
  //
  //
  //
  //   // Generate ESC/POS bytes
  //
  //   bytes.addAll(generator.imageRaster(resizedImage));
  //   final DateTime afterRaster = DateTime.now();
  //   print("Image rasterized: ${afterRaster.minute} ${afterRaster.second}");
  //
  //   if (needQR) {
  //     bytes.addAll(generator.feed(1));
  //     bytes.addAll(generator.qrcode(qrCode, size: QRSize.Size5));
  //     final DateTime afterQR = DateTime.now();
  //     print("QR code added: ${afterQR.minute} ${afterQR.second}");
  //   }
  //
  //   bytes.addAll(generator.cut());
  //
  //
  //   // final ByteData data = await rootBundle.load('assets/png/Edit_Icon_png.png');
  //   // final Uint8List bytess = data.buffer.asUint8List();
  //   // final Img.Image? image = Img.decodeImage(bytess!);
  //   // bytes += generator.imageRaster(image!);
  //   /// multiple pbject
  //   //  var arabicImageBytes  =await testData();
  //   // var arabicImageBytes1  =await testData();
  //   // var arabicImageBytes2  =await testData();
  //
  //   // final Img.Image? image = Img.decodeImage(bytess);
  //   // final Img.Image resizedImage = Img.copyResize(image!, width: 259);
  //   // bytes += generator.imageRaster(resizedImage);
  //   // //
  //   // final Img.Image? image1 = Img.decodeImage(arabicImageBytes1);
  //   // final Img.Image resizedImage1= Img.copyResize(image1!, width: 600);
  //   // bytes += generator.imageRaster(resizedImage1);
  //   //
  //   // final Img.Image? image2 = Img.decodeImage(arabicImageBytes2);
  //   // final Img.Image resizedImage2 = Img.copyResize(image2!, width: 570);
  //   // bytes += generator.imageRaster(resizedImage2);
  //   /// commented for test purpose
  //
  //
  //
  //
  //
  //
  //   // final Img.Image? image = Img.decodeImage(arabicImageBytes);
  //   // // print("  ---------   --------- img function 1  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
  //   // final Img.Image resizedImage = Img.copyResize(image!, width: 570);
  //   // print("  ---------   --------- img function 2  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
  //   // bytes += generator.imageRaster(resizedImage);
  //   // print("  ---------   --------- img function 3  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
  //   // if (needQR) {
  //   //   bytes += generator.feed(1);
  //   //   bytes += generator.qrcode(qrCode, size: QRSize.Size5);
  //   // }
  //
  //   //bytes += generator.text("text");
  //
  //   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, defaultIp,);
  //
  //   print("  ---------   --------- img function final  ---------   ${DateTime.now().minute} ${DateTime.now().second} ");
  //   String msg = "";
  //
  //   if (res == "success") {
  //     msg = "Printed Successfully";
  //   } else {
  //     msg = "Failed to generate a print please make sure to use the correct printer name";
  //   }
  // }

  Img.Image decodeImage(Uint8List bytes) {
    return Img.decodeImage(bytes)!;
  }

  Img.Image resizeImage(Img.Image image) {
    return Img.copyResize(image, width: 570);
  }
  double calculateItemSectionHeight(items) {
    double baseHeightPerItem = 50.0; // Base height for each item
    double additionalHeightForDescription = 50.0; // Additional height if description is present
    double totalHeight = 0;
    for (final item in items) {
      totalHeight += baseHeightPerItem;
      if (item['ProductDescription'].isNotEmpty) {
        totalHeight += additionalHeightForDescription;
      }
    }
    return totalHeight;
  }

  double calculateItemSectionHeightKOT(items) {
    List<ItemsDetails> dataPrint = items;
    double baseHeightPerItem = 50.0; // Base height for each item
    double additionalHeightForDescription = 30.0; // Additional height if description is present
    double totalHeight = 0;
    for (final item in dataPrint) {
      totalHeight += baseHeightPerItem;
      if (item.productDescription.isNotEmpty) {
        totalHeight += additionalHeightForDescription;
      }
    }
    return totalHeight;
  }

  Future<Uint8List> generateInvoice(
      {required String companyName,
        required String buildingDetails,
        required String streetName,
        required String companySecondName,
        required String companyLogoCompany,
        required String companyCountry,
        required String companyPhone,
        required String companyTax,
        required String companyCrNumber,
        required String countyCodeCompany,
        required String qrCodeData,
        required String voucherNumber,
        required String customerName,
        required String date,
        required String customerPhone,
        required String grossAmount,
        required String discount,
        required String totalTax,
        required String grandTotal,
        required String vatAmountTotal,
        required String exciseAmountTotal,
        required String token,
        required String cashReceived,
        required String bankReceived,
        required String balance,
        required String orderType,
        required String tableName,
        required String voucherType,
        required saleDetails}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    double companyDetailsHeight = 80;
    List<String> fields = [
      companySecondName,
      buildingDetails,
      streetName,
      companyTax
    ];
    companyDetailsHeight += fields.where((field) => field.isNotEmpty).length * 40;
    double voucherDetailsHeight = 250;
    double detailHeight = calculateItemSectionHeight(saleDetails) + 80;
    double footerHeight = 350;

    double totalHeight = companyDetailsHeight +
        voucherDetailsHeight +
        detailHeight +
        footerHeight+50;

    if (hilightTokenNumber) {
      totalHeight = totalHeight + 80;
    }


    Size canvasSize1 = Size(500, totalHeight);
    const Color backgroundColor = Colors.white; // Specify your desired background color
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize1.width, canvasSize1.height), Paint()..color = backgroundColor,);

    var invoiceType = "SIMPLIFIED TAX INVOICE";
    var invoiceTypeArabic = "فاتورة ضريبية مبسطة";

    if (voucherType == "SO") {
      // Adjusting other variables for a sales order scenario
      invoiceType = "SALES ORDER";
      invoiceTypeArabic = "طلب المبيعات";
    }

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
      ..pushStyle(ui.TextStyle(
          color: Colors.black,
          fontSize: 40.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700))
      ..addText(companyName);
    final companyNameParagraph = companyNameBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(companyNameParagraph, Offset(0, positionHeight),);
    // Add Second name

    if (companySecondName != "") {
      positionHeight = positionHeight + 40;
      final companySecondNameBuilder =
      ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 35.0))
        ..addText(companySecondName);
      final companySecondNameParagraph = companySecondNameBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(
          companySecondNameParagraph, Offset(0, positionHeight));
    }

    // buildingDetails
    if (buildingDetails != "") {
      positionHeight = positionHeight + 40;
      final buildingDetailsBuilder =
      ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
        ..addText(buildingDetails);
      final buildingDetailsParagraph = buildingDetailsBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(buildingDetailsParagraph, Offset(0, positionHeight));
    }

    // Street name

    if (streetName != "") {
      positionHeight = positionHeight + 40;
      final streetBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
        ..addText(streetName);
      final streetBuilderParagraph = streetBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(streetBuilderParagraph, Offset(0, positionHeight));
    }

    // Company tax number

    if (companyTax != "") {
      positionHeight = positionHeight + 40;
      final taxDetailsBuilder =
      ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
        ..addText(companyTax);
      final taxDetailsParagraph = taxDetailsBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(taxDetailsParagraph, Offset(0, positionHeight));
    }

    // InvoiceDetails eng
    positionHeight = positionHeight + 40;
    final invoiceEngNameBuilder =
    ui.ParagraphBuilder(companyDetailsParagraphStyle)
      ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
      ..addText(invoiceType);
    final invoiceDetailsDetailsParagraph = invoiceEngNameBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(
        invoiceDetailsDetailsParagraph, Offset(0, positionHeight));

    // InvoiceDetails

    positionHeight = positionHeight + 30;
    final invoiceArabicNameBuilder =
    ui.ParagraphBuilder(companyDetailsParagraphStyle)
      ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
      ..addText(invoiceTypeArabic);
    final invoiceDetailsArabicDetailsParagraph = invoiceArabicNameBuilder
        .build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(
        invoiceDetailsArabicDetailsParagraph, Offset(0, positionHeight));
    positionHeight = positionHeight + 40;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    positionHeight = positionHeight + 10;
    if (hilightTokenNumber) {
      final tokenNumberBuilder =
      ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0))
        ..addText("Token Number");
      final tokenNumberParagraph = tokenNumberBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(tokenNumberParagraph, Offset(0, positionHeight));
      positionHeight = positionHeight + 40;

      final tokenDetail = ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0 ,fontWeight: FontWeight.w500,))
        ..addText(token);
      final tokenNumberDetail = tokenDetail.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(tokenNumberDetail, Offset(0, positionHeight));
      positionHeight = positionHeight + 40;

      final tokenNumberArabic =
      ui.ParagraphBuilder(companyDetailsParagraphStyle)
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.w500,))
        ..addText("رقم الرمز المميز");
      final tokenNumberArabicBuilder = tokenNumberArabic.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
      canvas.drawParagraph(tokenNumberArabicBuilder, Offset(0, positionHeight));
      positionHeight = positionHeight + 40;
      canvas.drawLine(Offset(0, positionHeight),
          Offset(canvasSize1.width, positionHeight), linePaint);
    }

    var voucherDetails = [
      ['Token Number:', token, 'رقم الطيب '],
      ['Invoice No:', voucherNumber, 'رقم القسيمة '],
      ['Date:', date, 'التاريخ '],
      ['Name:', customerName, 'اسم '],
    ];

    if (hilightTokenNumber) {
      voucherDetails = [
        ['Invoice No:', voucherNumber, 'رقم القسيمة '],
        ['Date:', date, 'التاريخ '],
        ['Name:', customerName, 'اسم '],

      ];
    }
// Layout constraints for each column
    final double column1Width = canvasSize1.width / 3.5;
    final double column2Width = canvasSize1.width / 2.5;
    final double column3Width = canvasSize1.width / 3.5;

    for (final item in voucherDetails) {
      // English label
      final englishTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleLeft)
        ..pushStyle(ui.TextStyle(color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 25.0,
        ))
        ..addText(item[0]);
      final englishTextParagraph = englishTextBuilder.build()..layout(ui.ParagraphConstraints(width: column1Width));
      canvas.drawParagraph(englishTextParagraph, Offset(0, positionHeight));

      // Arabic label
      final arabicTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleCenter)
        ..pushStyle(ui.TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 25.0,

        ))
        ..addText(item[1]);
      final arabicTextParagraph = arabicTextBuilder.build()..layout(ui.ParagraphConstraints(width: column2Width));
      canvas.drawParagraph(arabicTextParagraph, Offset(column1Width, positionHeight));

      // Value
      final valueTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleRight)..pushStyle(ui.TextStyle( color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 25.0,))..addText(item[2]);
      final valueTextParagraph = valueTextBuilder.build()..layout(ui.ParagraphConstraints(width: column3Width));
      canvas.drawParagraph(valueTextParagraph, Offset(column1Width + column2Width, positionHeight));


      positionHeight += [
        englishTextParagraph.height,
        arabicTextParagraph.height,
        valueTextParagraph.height
      ].reduce((a, b) => a > b ? a : b) +
          10;
    }

    positionHeight = positionHeight + 10;
    print("positio Height voucher height after $positionHeight");
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    final headers = ['Sl', 'Product Details', 'Qty', 'Rate', 'Net'];
    final headerWidths = [
      40.0,
      270.0,
      45.0,
      65.0,
      65.0
    ]; // Adjust widths as needed

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
        ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 25))
        ..addText(headers[i]);
      final headerParagraph = headerBuilder.build()
        ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
      canvas.drawParagraph(
          headerParagraph,
          Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
              positionHeight));
    }

    print(
        "-----------------------------------------before item section-----------------$positionHeight");
    positionHeight = positionHeight + 30;

    final headersArab = ['رقم', 'منتج', 'كمية', 'معدل', 'شبكة'];
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
        ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 23))
        ..addText(headersArab[i]);
      final headerParagraph = headerBuilder.build()
        ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
      canvas.drawParagraph(
          headerParagraph,
          Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
              positionHeight));
    }
    positionHeight = positionHeight + 40;
    canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);
    positionHeight = positionHeight + 30;
    for (int index = 0; index < saleDetails.length; index++) {
      final item = saleDetails[index];
      double offsetX = 0;
      double rowHeight = 0;

      // Draw item details
      final itemDetails = [
        (index + 1).toString(), // Index as Sl. No
        item["ProductName"],
        roundStringWith1(item["Qty"].toString()),
        roundStringWith(item["UnitPrice"].toString()),
        roundStringWith(item["NetAmount"].toString())
      ];

      for (int i = 0; i < itemDetails.length; i++) {
        final alignment = (i == 1)
            ? TextAlign.left
            : (i == 0||i == 2)
            ? TextAlign.center
            : TextAlign.right;
        final itemBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: alignment,
            fontSize: itemStyle.fontSize,
            fontFamily: itemStyle.fontFamily,
          ),
        )
          ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 23))
          ..addText(itemDetails[i]);
        final itemParagraph = itemBuilder.build()
          ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
        canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
        offsetX += headerWidths[i];
        rowHeight =
        itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
      }

      positionHeight +=
          rowHeight + 10; // Adjust height after drawing item details

      // Draw item description if not empty
      if (item["ProductDescription"].isNotEmpty) {


        print("=canvasSize1==${canvasSize1.width}=headerWidths=${headerWidths[1]}==========");


        final descriptionBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: TextAlign.right,
            fontSize: itemStyle.fontSize,
            fontFamily: itemStyle.fontFamily,
          ),
        )
          ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 22))
          ..addText(item["ProductDescription"]);
        final descriptionParagraph = descriptionBuilder.build()
          ..layout(ui.ParagraphConstraints(width: canvasSize1.width)); // Adjust width as needed
        canvas.drawParagraph(descriptionParagraph, Offset(50, positionHeight));
        positionHeight += descriptionParagraph.height + 10; // Adjust height after drawing description
      } else {
        positionHeight += 10; // Skip space if description is empty
      }
    }



    positionHeight = positionHeight + 15;
     canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);
    print("--------------------------------------------------------------------------");

    // positionHeight = positionHeight + 25;
    // canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);

    var totals = [
      ['Gross Amount:', roundStringWith(grossAmount)],
      ['Total Tax:', roundStringWith(totalTax)],
      ['Discount:', roundStringWith(discount)],
      ['Grand Total:', roundStringWith(grandTotal)],
    ];
   print("-----------------------------------------------------------------voucherType---------$voucherType");

    if (voucherType == "SI") {
      print("--------------------------------------------------------------------------123123123");

      totals = [
        ['Gross Amount:', roundStringWith(grossAmount)],
        ['Total Tax:', roundStringWith(totalTax)],
        ['Discount:', roundStringWith(discount)],
        ['Grand Total:', roundStringWith(grandTotal)],
        ['Cash:', roundStringWith(cashReceived)],
        ['Bank:', roundStringWith(bankReceived)],

      ];
    }
    positionHeight = positionHeight + 25; // Space before totals
    for (final total in totals) {
      final totalTextStyle = (total[0] == 'Grand Total:')
          ? TextStyle(
        fontFamily: 'Poppins',
        fontSize: 27,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      )
          : TextStyle(
        fontFamily: 'Poppins',
        fontSize: 26,
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
      final totalTextParagraph = totalTextBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
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
      final totalAmountParagraph = totalAmountBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
      canvas.drawParagraph(
          totalAmountParagraph, Offset(canvasSize1.width / 2, positionHeight));

      positionHeight += totalTextParagraph.height;
    }

    print("-----------------------------------------after------------------------------positionHeight $positionHeight");


    final picture = recorder.endRecording();
    final img = await picture.toImage(canvasSize1.width.toInt(), canvasSize1.height.toInt(),);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png,);
    return pngBytes!.buffer.asUint8List();
  }

  String roundStringWith1(String val) {

    var decimal = 0;
    double convertedTodDouble = double.parse(val);
    var number = convertedTodDouble.toStringAsFixed(decimal);
    return number;
  }
  /// full worked

//   Future<Uint8List> generateInvoice(
//       {required String companyName,
//       required String buildingDetails,
//       required String streetName,
//       required String companySecondName,
//       required String companyLogoCompany,
//       required String companyCountry,
//       required String companyPhone,
//       required String companyTax,
//       required String companyCrNumber,
//       required String countyCodeCompany,
//       required String qrCodeData,
//       required String voucherNumber,
//       required String customerName,
//       required String date,
//       required String customerPhone,
//       required String grossAmount,
//       required String discount,
//       required String totalTax,
//       required String grandTotal,
//       required String vatAmountTotal,
//       required String exciseAmountTotal,
//       required String token,
//       required String cashReceived,
//       required String bankReceived,
//       required String balance,
//       required String orderType,
//       required String tableName,
//       required String voucherType,
//       required saleDetails}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var hilightTokenNumber = prefs.getBool("hilightTokenNumber") ?? false;
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder);
//
//     double companyDetailsHeight = 80;
//     List<String> fields = [
//       companySecondName,
//       buildingDetails,
//       streetName,
//       companyTax
//     ];
//     companyDetailsHeight += fields.where((field) => field.isNotEmpty).length * 40;
//     double voucherDetailsHeight = 250;
//     double detailHeight = calculateItemSectionHeight(saleDetails) + 80;
//     double footerHeight = 250;
//
//     double totalHeight = companyDetailsHeight +
//         voucherDetailsHeight +
//         detailHeight +
//         footerHeight+80;
//
//     if (hilightTokenNumber) {
//       totalHeight = totalHeight + 80;
//     }
//
//
//     Size canvasSize1 = Size(500, totalHeight);
//     const Color backgroundColor = Colors.white; // Specify your desired background color
//     canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize1.width, canvasSize1.height), Paint()..color = backgroundColor);
//
//     var invoiceType = "SIMPLIFIED TAX INVOICE";
//     var invoiceTypeArabic = "فاتورة ضريبية مبسطة";
//
//     if (voucherType == "SO") {
//       // Adjusting other variables for a sales order scenario
//       invoiceType = "SALES ORDER";
//       invoiceTypeArabic = "طلب المبيعات";
//     }
//
//     final linePaint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 2.0;
//
//     // Set up text styles with custom font
//     const titleStyle = TextStyle(
//       fontSize: 30,
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     );
//     const headerStyle = TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     );
//     const itemStyle = TextStyle(
//       fontSize: 20,
//       color: Colors.black,
//     );
//     const totalTextStyle = TextStyle(
//       fontSize: 20,
//       fontWeight: FontWeight.bold,
//       color: Colors.black,
//     );
//     const companyDetailsStyle = TextStyle(
//       fontSize: 16,
//       color: Colors.black,
//     );
//     // var companyDetailsStyle = GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight.w600,color: Colors.black,fontSize: 15.0));
//     // Define paragraph styles
//     final titleParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.center,
//       fontSize: titleStyle.fontSize,
//       fontWeight: titleStyle.fontWeight,
//       fontFamily: titleStyle.fontFamily,
//     );
//     final headerParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.left,
//       fontSize: headerStyle.fontSize,
//       fontWeight: headerStyle.fontWeight,
//       fontFamily: headerStyle.fontFamily,
//     );
//     final itemParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.left,
//       fontSize: itemStyle.fontSize,
//       fontWeight: itemStyle.fontWeight,
//       fontFamily: itemStyle.fontFamily,
//     );
//
//     final voucherDetailsStyleLeft = ui.ParagraphStyle(
//       textAlign: TextAlign.left,
//       fontSize: itemStyle.fontSize,
//       fontWeight: itemStyle.fontWeight,
//       fontFamily: itemStyle.fontFamily,
//     );
//     final voucherDetailsStyleRight = ui.ParagraphStyle(
//       textAlign: TextAlign.right,
//       fontSize: itemStyle.fontSize,
//       fontWeight: itemStyle.fontWeight,
//       fontFamily: itemStyle.fontFamily,
//     );
//     final voucherDetailsStyleCenter = ui.ParagraphStyle(
//       textAlign: TextAlign.center,
//       fontSize: itemStyle.fontSize,
//       fontWeight: itemStyle.fontWeight,
//       fontFamily: itemStyle.fontFamily,
//     );
//     final totalTextParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.left,
//       fontSize: totalTextStyle.fontSize,
//       fontWeight: totalTextStyle.fontWeight,
//       fontFamily: totalTextStyle.fontFamily,
//     );
//
//     final totalAmountParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.right,
//       fontSize: totalTextStyle.fontSize,
//       fontWeight: totalTextStyle.fontWeight,
//       fontFamily: totalTextStyle.fontFamily,
//     );
//     final companyDetailsParagraphStyle = ui.ParagraphStyle(
//       textAlign: TextAlign.center,
//       fontSize: companyDetailsStyle.fontSize,
//       fontWeight: companyDetailsStyle.fontWeight,
//       fontFamily: companyDetailsStyle.fontFamily,
//     );
//
//     double positionHeight = 5.0;
//
//     // Add company name
//     final companyNameBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
//       ..pushStyle(ui.TextStyle(
//           color: Colors.black,
//           fontSize: 40.0,
//           fontFamily: 'Poppins',
//           fontWeight: FontWeight.w700))
//       ..addText(companyName);
//     final companyNameParagraph = companyNameBuilder.build()
//       ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//     canvas.drawParagraph(companyNameParagraph, Offset(0, positionHeight));
//     // Add Second name
//
//     if (companySecondName != "") {
//       positionHeight = positionHeight + 40;
//       final companySecondNameBuilder =
//           ui.ParagraphBuilder(companyDetailsParagraphStyle)
//             ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 35.0))
//             ..addText(companySecondName);
//       final companySecondNameParagraph = companySecondNameBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(
//           companySecondNameParagraph, Offset(0, positionHeight));
//     }
//
//     // buildingDetails
//     if (buildingDetails != "") {
//       positionHeight = positionHeight + 40;
//       final buildingDetailsBuilder =
//           ui.ParagraphBuilder(companyDetailsParagraphStyle)
//             ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
//             ..addText(buildingDetails);
//       final buildingDetailsParagraph = buildingDetailsBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(buildingDetailsParagraph, Offset(0, positionHeight));
//     }
//
//     // Street name
//
//     if (streetName != "") {
//       positionHeight = positionHeight + 40;
//       final streetBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
//         ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
//         ..addText(streetName);
//       final streetBuilderParagraph = streetBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(streetBuilderParagraph, Offset(0, positionHeight));
//     }
//
//     // Company tax number
//
//     if (companyTax != "") {
//       positionHeight = positionHeight + 40;
//       final taxDetailsBuilder =
//           ui.ParagraphBuilder(companyDetailsParagraphStyle)
//             ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
//             ..addText(companyTax);
//       final taxDetailsParagraph = taxDetailsBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(taxDetailsParagraph, Offset(0, positionHeight));
//     }
//
//     // InvoiceDetails eng
//     positionHeight = positionHeight + 40;
//     final invoiceEngNameBuilder =
//         ui.ParagraphBuilder(companyDetailsParagraphStyle)
//           ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
//           ..addText(invoiceType);
//     final invoiceDetailsDetailsParagraph = invoiceEngNameBuilder.build()
//       ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//     canvas.drawParagraph(
//         invoiceDetailsDetailsParagraph, Offset(0, positionHeight));
//
//     // InvoiceDetails
//
//     positionHeight = positionHeight + 30;
//     final invoiceArabicNameBuilder =
//         ui.ParagraphBuilder(companyDetailsParagraphStyle)
//           ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
//           ..addText(invoiceTypeArabic);
//     final invoiceDetailsArabicDetailsParagraph = invoiceArabicNameBuilder
//         .build()
//       ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//     canvas.drawParagraph(
//         invoiceDetailsArabicDetailsParagraph, Offset(0, positionHeight));
//     positionHeight = positionHeight + 40;
//     canvas.drawLine(Offset(0, positionHeight),
//         Offset(canvasSize1.width, positionHeight), linePaint);
//
//     positionHeight = positionHeight + 10;
//     if (hilightTokenNumber) {
//       final tokenNumberBuilder =
//           ui.ParagraphBuilder(companyDetailsParagraphStyle)
//             ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 30.0))
//             ..addText("Token Number");
//       final tokenNumberParagraph = tokenNumberBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(tokenNumberParagraph, Offset(0, positionHeight));
//       positionHeight = positionHeight + 40;
//
//       final tokenDetail = ui.ParagraphBuilder(companyDetailsParagraphStyle)
//         ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0 ,fontWeight: FontWeight.w500,))
//         ..addText(token);
//       final tokenNumberDetail = tokenDetail.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(tokenNumberDetail, Offset(0, positionHeight));
//       positionHeight = positionHeight + 40;
//
//       final tokenNumberArabic =
//           ui.ParagraphBuilder(companyDetailsParagraphStyle)
//             ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.w500,))
//             ..addText("رقم الرمز المميز");
//       final tokenNumberArabicBuilder = tokenNumberArabic.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
//       canvas.drawParagraph(tokenNumberArabicBuilder, Offset(0, positionHeight));
//       positionHeight = positionHeight + 40;
//       canvas.drawLine(Offset(0, positionHeight),
//           Offset(canvasSize1.width, positionHeight), linePaint);
//     }
//
//     var voucherDetails = [
//       ['Token Number:', token, 'رقم الطيب '],
//       ['Voucher No:', voucherNumber, 'رقم القسيمة '],
//       ['Date:', date, 'التاريخ '],
//       ['Order Type:', orderType, 'نوع الطلب '],
//       ['Table Name:', tableName, 'اسم الطاولة '],
//     ];
//
//     if (hilightTokenNumber) {
//       voucherDetails = [
//         ['Voucher No:', voucherNumber, 'رقم القسيمة '],
//         ['Date:', date, 'التاريخ '],
//         ['Order Type:', orderType, 'نوع الطلب '],
//         ['Table Name:', tableName, 'اسم الطاولة '],
//       ];
//     }
// // Layout constraints for each column
//     final double column1Width = canvasSize1.width / 3;
//     final double column2Width = canvasSize1.width / 3;
//     final double column3Width = canvasSize1.width / 3;
//
//     for (final item in voucherDetails) {
//       // English label
//       final englishTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleLeft)
//         ..pushStyle(ui.TextStyle(color: Colors.black,
//           fontWeight: FontWeight.w500,
//           fontSize: 25.0,
//         ))
//         ..addText(item[0]);
//       final englishTextParagraph = englishTextBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: column1Width));
//       canvas.drawParagraph(englishTextParagraph, Offset(0, positionHeight));
//
//       // Arabic label
//       final arabicTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleCenter)
//         ..pushStyle(ui.TextStyle(
//           color: Colors.black,
//             fontWeight: FontWeight.w500,
//             fontSize: 25.0,
//
//         ))
//         ..addText(item[1]);
//       final arabicTextParagraph = arabicTextBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: column2Width));
//       canvas.drawParagraph(
//           arabicTextParagraph, Offset(column1Width, positionHeight));
//
//       // Value
//       final valueTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleRight)..pushStyle(ui.TextStyle( color: Colors.black,
//         fontWeight: FontWeight.w500,
//         fontSize: 25.0,))..addText(item[2]);
//       final valueTextParagraph = valueTextBuilder.build()..layout(ui.ParagraphConstraints(width: column3Width));
//       canvas.drawParagraph(valueTextParagraph, Offset(column1Width + column2Width, positionHeight));
//
//
//       positionHeight += [
//             englishTextParagraph.height,
//             arabicTextParagraph.height,
//             valueTextParagraph.height
//           ].reduce((a, b) => a > b ? a : b) +
//           10;
//     }
//
//     positionHeight = positionHeight + 10;
//     print("positio Height voucher height after $positionHeight");
//     canvas.drawLine(Offset(0, positionHeight),
//         Offset(canvasSize1.width, positionHeight), linePaint);
//
//     final headers = ['Sl', 'Product Details', 'Qty', 'Rate', 'Total'];
//     final headerWidths = [
//       40.0,
//       250.0,
//       70.0,
//       70.0,
//       70.0
//     ]; // Adjust widths as needed
//
//     for (int i = 0; i < headers.length; i++) {
//       final alignment = (i == 1)
//           ? TextAlign.left
//           : (i == 0)
//               ? TextAlign.center
//               : TextAlign.right;
//       final headerBuilder = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//           textAlign: alignment,
//           fontSize: headerStyle.fontSize,
//           fontFamily: headerStyle.fontFamily,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 25))
//         ..addText(headers[i]);
//       final headerParagraph = headerBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
//       canvas.drawParagraph(
//           headerParagraph,
//           Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
//               positionHeight));
//     }
//
//     print(
//         "-----------------------------------------before item section-----------------$positionHeight");
//     positionHeight = positionHeight + 30;
//
//     final headersArab = ['رقم', 'منتج', 'كمية', 'معدل', 'المجموع'];
//     for (int i = 0; i < headersArab.length; i++) {
//       final alignment = (i == 1)
//           ? TextAlign.left
//           : (i == 0)
//               ? TextAlign.center
//               : TextAlign.right;
//
//       final headerBuilder = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//           textAlign: alignment,
//           fontSize: headerStyle.fontSize,
//           fontFamily: headerStyle.fontFamily,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 23))
//         ..addText(headersArab[i]);
//       final headerParagraph = headerBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
//       canvas.drawParagraph(
//           headerParagraph,
//           Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
//               positionHeight));
//     }
//     positionHeight = positionHeight + 40;
//     canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);
//     positionHeight = positionHeight + 30;
//     for (int index = 0; index < saleDetails.length; index++) {
//       final item = saleDetails[index];
//       double offsetX = 0;
//       double rowHeight = 0;
//
//       // Draw item details
//       final itemDetails = [
//         (index + 1).toString(), // Index as Sl. No
//         item["ProductName"],
//         roundStringWith(item["Qty"].toString()),
//         roundStringWith(item["UnitPrice"].toString()),
//         roundStringWith(item["NetAmount"].toString())
//       ];
//
//       for (int i = 0; i < itemDetails.length; i++) {
//         final alignment = (i == 1)
//             ? TextAlign.left
//             : (i == 0)
//                 ? TextAlign.center
//                 : TextAlign.right;
//         final itemBuilder = ui.ParagraphBuilder(
//           ui.ParagraphStyle(
//             textAlign: alignment,
//             fontSize: itemStyle.fontSize,
//             fontFamily: itemStyle.fontFamily,
//           ),
//         )
//           ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w400,fontSize: 23))
//           ..addText(itemDetails[i]);
//         final itemParagraph = itemBuilder.build()
//           ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
//         canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
//         offsetX += headerWidths[i];
//         rowHeight =
//             itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
//       }
//
//       positionHeight +=
//           rowHeight + 10; // Adjust height after drawing item details
//
//       // Draw item description if not empty
//       if (item["ProductDescription"].isNotEmpty) {
//         final descriptionBuilder = ui.ParagraphBuilder(
//           ui.ParagraphStyle(
//             textAlign: TextAlign.left,
//             fontSize: itemStyle.fontSize,
//             fontFamily: itemStyle.fontFamily,
//           ),
//         )
//           ..pushStyle(ui.TextStyle(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 24))
//           ..addText(item["ProductDescription"]);
//         final descriptionParagraph = descriptionBuilder.build()
//           ..layout(ui.ParagraphConstraints(
//               width: canvasSize1.width -
//                   headerWidths[1])); // Adjust width as needed
//         canvas.drawParagraph(
//             descriptionParagraph, Offset(headerWidths[1], positionHeight));
//         positionHeight += descriptionParagraph.height +
//             10; // Adjust height after drawing description
//       } else {
//         positionHeight += 10; // Skip space if description is empty
//       }
//     }
//
//     ///old one
//     // Add items
//     // final items = [
//     //   ['1', 'PRINC', '1.00', '90.91', '90.91', 'Description of item 1'],
//     //   ['2', 'P EX', '1.00', '100.00', '100.00', ''],
//     //   ['3', '54545455454No Tax Product', '3.00', '12.96', '38.88', 'Description of item 3'],
//     //   ['4', 'Price category product', '3.00', '100.00', '300.00', 'Description of item 4'],
//     // ];
//     // positionHeight = positionHeight + 40;
//     // for (final item in items) {
//     //   print("==============================$item");
//     //   double offsetX = 0;
//     //   double rowHeight = 0;
//     //
//     //
//     //   // Draw item details
//     //   for (int i = 0; i < item.length - 1; i++) {
//     //     final alignment = (i == 1 || i == 5) ? TextAlign.left : (i == 0)
//     //         ? TextAlign.center
//     //         : TextAlign.right;
//     //     final itemBuilder = ui.ParagraphBuilder(
//     //       ui.ParagraphStyle(
//     //         textAlign: alignment,
//     //         fontSize: itemStyle.fontSize,
//     //         fontFamily: itemStyle.fontFamily,
//     //       ),
//     //     )
//     //       ..pushStyle(ui.TextStyle(color: Colors.black))
//     //       ..addText(item[i]);
//     //     final itemParagraph = itemBuilder.build()
//     //       ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
//     //     canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
//     //     offsetX += headerWidths[i];
//     //     rowHeight =
//     //     itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
//     //   }
//     //
//     //   positionHeight +=
//     //       rowHeight + 10; // Adjust height after drawing item details
//     //
//     //
//     //   positionHeight = positionHeight + 40;
//     //
//
//     //   for (final item in saleDetails) {
//     //     double offsetX = 0;
//     //     double rowHeight = 0;
//     //
//     //     // Draw item details
//     //     final itemDetails = [
//     //       "",
//     //       item["ProductName"],
//     //       item["Qty"].toString(),
//     //       item["UnitPrice"].toString(),
//     //       item["NetAmount"].toString()
//     //     ];
//     //
//     //     for (int i = 0; i < itemDetails.length; i++) {
//     //       final alignment = (i == 1)
//     //           ? TextAlign.left
//     //           : (i == 0)
//     //           ? TextAlign.center
//     //           : TextAlign.right;
//     //       final itemBuilder = ui.ParagraphBuilder(
//     //         ui.ParagraphStyle(
//     //           textAlign: alignment,
//     //           fontSize: itemStyle.fontSize,
//     //           fontFamily: itemStyle.fontFamily,
//     //         ),
//     //       )
//     //         ..pushStyle(ui.TextStyle(color: Colors.black))
//     //         ..addText(itemDetails[i]);
//     //       final itemParagraph = itemBuilder.build()
//     //         ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
//     //       canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
//     //       offsetX += headerWidths[i];
//     //       rowHeight = itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
//     //     }
//     //
//     //     positionHeight += rowHeight + 10; // Adjust height after drawing item details
//     //
//     //     // Draw item description if not empty
//     //     if (item["ProductDescription"].isNotEmpty) {
//     //       final descriptionBuilder = ui.ParagraphBuilder(
//     //         ui.ParagraphStyle(
//     //           textAlign: TextAlign.left,
//     //           fontSize: itemStyle.fontSize,
//     //           fontFamily: itemStyle.fontFamily,
//     //         ),
//     //       )
//     //         ..pushStyle(ui.TextStyle(color: Colors.black))
//     //         ..addText(item["ProductDescription"]);
//     //       final descriptionParagraph = descriptionBuilder.build()
//     //         ..layout(ui.ParagraphConstraints(width: canvasSize1.width - headerWidths[1])); // Adjust width as needed
//     //       canvas.drawParagraph(descriptionParagraph, Offset(headerWidths[1], positionHeight));
//     //
//     //       positionHeight += descriptionParagraph.height + 10; // Adjust height after drawing description
//     //     } else {
//     //       positionHeight += 10; // Skip space if description is empty
//     //     }
//     //   }
//     //
//     //   positionHeight = positionHeight + 25;
//     //   canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);
//     //
//     //
//     //
//     //
//     //
//     //   // Draw item description if not empty
//     //   if (item[item.length - 1].isNotEmpty) {
//     //     final descriptionBuilder = ui.ParagraphBuilder(
//     //       ui.ParagraphStyle(
//     //         textAlign: TextAlign.left,
//     //         fontSize: itemStyle.fontSize,
//     //         fontFamily: itemStyle.fontFamily,
//     //       ),
//     //     )
//     //       ..pushStyle(ui.TextStyle(color: Colors.black))
//     //       ..addText(item[item.length - 1]);
//     //     final descriptionParagraph = descriptionBuilder.build()..layout(ui.ParagraphConstraints(width: canvasSize1.width)); // Adjust width as needed
//     //     canvas.drawParagraph(descriptionParagraph, Offset(40, positionHeight));
//     //
//     //     positionHeight += descriptionParagraph.height + 10;
//     //     // Adjust height after drawing description
//     //   } else {
//     //     positionHeight += 10; // Skip space if description is empty
//     //   }
//     // }
//
//     positionHeight = positionHeight + 15;
//     print(
//         "-----------------------------------------after item section-----------------$positionHeight");
//     print(
//         "-----------------------------------------------------------------------positionHeight $positionHeight");
//     canvas.drawLine(Offset(0, positionHeight),
//         Offset(canvasSize1.width, positionHeight), linePaint);
//
//     // positionHeight = positionHeight + 25;
//     // canvas.drawLine(Offset(0, positionHeight), Offset(canvasSize1.width, positionHeight), linePaint);
//
//     final totals = [
//       ['Gross Amount:', roundStringWith(grossAmount)],
//       ['Total Tax:', roundStringWith(totalTax)],
//       ['Discount:', roundStringWith(discount)],
//       ['Grand Total:', roundStringWith(grandTotal)],
//     ];
//
//     positionHeight = positionHeight + 25; // Space before totals
//     for (final total in totals) {
//       final totalTextStyle = (total[0] == 'Grand Total:')
//           ? TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 27,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             )
//           : TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 26,
//               fontWeight: FontWeight.w400,
//               color: Colors.black,
//             );
//
//       final totalTextBuilder = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//           textAlign: TextAlign.left,
//           fontSize: totalTextStyle.fontSize,
//           fontWeight: totalTextStyle.fontWeight,
//           fontFamily: totalTextStyle.fontFamily,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: Colors.black))
//         ..addText(total[0]);
//       final totalTextParagraph = totalTextBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
//       canvas.drawParagraph(totalTextParagraph, Offset(0, positionHeight));
//
//       final totalAmountBuilder = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//           textAlign: TextAlign.right,
//           fontSize: totalTextStyle.fontSize,
//           fontWeight: totalTextStyle.fontWeight,
//           fontFamily: totalTextStyle.fontFamily,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: Colors.black))
//         ..addText(total[1]);
//       final totalAmountParagraph = totalAmountBuilder.build()
//         ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
//       canvas.drawParagraph(
//           totalAmountParagraph, Offset(canvasSize1.width / 2, positionHeight));
//
//       positionHeight += totalTextParagraph.height + 10;
//     }
//
//     print(
//         "-----------------------------------------after------------------------------positionHeight $positionHeight");
//
//
//
//     final picture = recorder.endRecording();
//     final img = await picture.toImage(canvasSize1.width.toInt(), canvasSize1.height.toInt(),);
//     final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png,);
//     return pngBytes!.buffer.asUint8List();
//   }

  Future<Uint8List> generateKOT({
    required String printerAddress,
    required int id,
    required items,
    required bool isCancelNote,
    required isUpdate,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('user_name') ?? "";
    bool showUsernameKot = prefs.getBool('show_username_kot') ?? false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot') ?? false;
    var defaultCodePage = prefs.getString("default_code_page") ?? "CP864";
    var currentTime = DateTime.now();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();

    for (Map user in items) {
      dataPrint.add(ItemsDetails.fromJson(user));
    }
    var kitchenName = "";
    var totalQty = dataPrint[0].qty;
    if (printListData.isNotEmpty) {
      kitchenName = printListData[id].kitchenName ?? "";
      totalQty = printListData[id].totalQty;
    }

    var tableName = dataPrint[0].tableName;
    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI ?? "";

    double companyDetailsHeight = 300;
    double voucherDetailsHeight = 250;
    double detailHeight = calculateItemSectionHeightKOT(dataPrint) + 80;
    double footerHeight = 100;
    double totalHeight = companyDetailsHeight +
        voucherDetailsHeight +
        detailHeight +
        footerHeight;
    Size canvasSize1 = Size(500, totalHeight);
    // Adjust size as needed
    const Color backgroundColor =
        Colors.white; // Specify your desired background color
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize1.width, canvasSize1.height),
        Paint()..color = backgroundColor);

    var invoiceType = "KOT";
    var invoiceTypeArabic = "طباعة المطب";

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
      fontWeight: FontWeight.w600,
    );

    const companyDetailsStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
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

    final companyDetailsParagraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: companyDetailsStyle.fontSize,
      fontWeight: companyDetailsStyle.fontWeight,
      fontFamily: companyDetailsStyle.fontFamily,
    );

    double positionHeight = 5.0;

    // heading details
    positionHeight = positionHeight + 20;
    final invoiceEngNameBuilder =
        ui.ParagraphBuilder(companyDetailsParagraphStyle)
          ..pushStyle(ui.TextStyle(
              color: Colors.black, fontSize: 35.0, fontWeight: FontWeight.bold))
          ..addText(invoiceType);

    final invoiceDetailsDetailsParagraph = invoiceEngNameBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(
        invoiceDetailsDetailsParagraph, Offset(0, positionHeight));

    positionHeight = positionHeight + 30;
    final invoiceArabicNameBuilder =
        ui.ParagraphBuilder(companyDetailsParagraphStyle)
          ..pushStyle(ui.TextStyle(
              color: Colors.black, fontSize: 35.0, fontWeight: FontWeight.bold))
          ..addText(invoiceTypeArabic);
    final invoiceDetailsArabicDetailsParagraph = invoiceArabicNameBuilder
        .build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(
        invoiceDetailsArabicDetailsParagraph, Offset(0, positionHeight));
    positionHeight = positionHeight + 50;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);
    positionHeight = positionHeight + 15;
    final tokenNumberBuilder = ui.ParagraphBuilder(companyDetailsParagraphStyle)
      ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
      ..addText("Token Number");
    final tokenNumberParagraph = tokenNumberBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(tokenNumberParagraph, Offset(0, positionHeight));
    positionHeight = positionHeight + 40;

    final tokenDetail = ui.ParagraphBuilder(companyDetailsParagraphStyle)
      ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
      ..addText(tokenNumber);
    final tokenNumberDetail = tokenDetail.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(tokenNumberDetail, Offset(0, positionHeight));
    positionHeight = positionHeight + 40;

    final tokenNumberArabic = ui.ParagraphBuilder(companyDetailsParagraphStyle)
      ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 30.0))
      ..addText("رقم الرمز المميز");
    final tokenNumberArabicBuilder = tokenNumberArabic.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(tokenNumberArabicBuilder, Offset(0, positionHeight));

    // InvoiceDetails
    positionHeight = positionHeight + 40;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);
    positionHeight = positionHeight + 10;

    print("positionHeight     positionHeight positionHeight   $positionHeight");
    final voucherDetails = [
      ['Kitchen Name:', kitchenName, 'اسم المطبخ '],
      ['User name:', userName, 'اسم المستخدم'],
      ['Time:', convertDateAndTime(currentTime), 'وقت '],
      ['Order Type:', orderType, 'نوع الطلب'],
      ['Table Name:', tableName, 'اسم الطاولة'],
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
      final englishTextParagraph = englishTextBuilder.build()
        ..layout(ui.ParagraphConstraints(width: column1Width));
      canvas.drawParagraph(englishTextParagraph, Offset(0, positionHeight));

      // Arabic label
      final arabicTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleCenter)
        ..pushStyle(ui.TextStyle(
          color: Colors.black,
        ))
        ..addText(item[1]);
      final arabicTextParagraph = arabicTextBuilder.build()
        ..layout(ui.ParagraphConstraints(width: column2Width));
      canvas.drawParagraph(
          arabicTextParagraph, Offset(column1Width, positionHeight));

      // Value
      final valueTextBuilder = ui.ParagraphBuilder(voucherDetailsStyleRight)
        ..pushStyle(ui.TextStyle(color: Colors.black))
        ..addText(item[2]);
      final valueTextParagraph = valueTextBuilder.build()
        ..layout(ui.ParagraphConstraints(width: column3Width));
      canvas.drawParagraph(valueTextParagraph,
          Offset(column1Width + column2Width, positionHeight));

      // Adjust offsetY based on the tallest paragraph in the row
      positionHeight += [
            englishTextParagraph.height,
            arabicTextParagraph.height,
            valueTextParagraph.height
          ].reduce((a, b) => a > b ? a : b) +
          10;
    }

    positionHeight = positionHeight + 10;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    final headers = ['Sl', 'Product Details', 'Qty'];
    final headerWidths = [40.0, 390.0, 70.0]; // Adjust widths as needed

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
      final headerParagraph = headerBuilder.build()
        ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
      canvas.drawParagraph(
          headerParagraph,
          Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
              positionHeight));
    }

    positionHeight = positionHeight + 30;

    final headersArab = [
      'رقم',
      'منتج',
      'كمية',
    ];
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
      final headerParagraph = headerBuilder.build()
        ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
      canvas.drawParagraph(
          headerParagraph,
          Offset(headerWidths.sublist(0, i).fold(0.0, (a, b) => a + b),
              positionHeight));
    }
    positionHeight = positionHeight + 30;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    positionHeight = positionHeight + 40;
    for (int index = 0; index < dataPrint.length; index++) {
      final item = dataPrint[index];
      double offsetX = 0;
      double rowHeight = 0;

      // Draw item details
      final itemDetails = [
        (index + 1).toString(), // Index as Sl. No
        item.productName,
        roundStringWith(item.qty),
      ];

      for (int i = 0; i < itemDetails.length; i++) {
        final alignment = (i == 1)
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
          ..addText(itemDetails[i]);
        final itemParagraph = itemBuilder.build()
          ..layout(ui.ParagraphConstraints(width: headerWidths[i]));
        canvas.drawParagraph(itemParagraph, Offset(offsetX, positionHeight));
        offsetX += headerWidths[i];
        rowHeight =
            itemParagraph.height > rowHeight ? itemParagraph.height : rowHeight;
      }

      positionHeight +=
          rowHeight + 10; // Adjust height after drawing item details

      // Draw item description if not empty
      if (item.productDescription.isNotEmpty) {
        final descriptionBuilder = ui.ParagraphBuilder(
          ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: itemStyle.fontSize,
            fontFamily: itemStyle.fontFamily,
          ),
        )
          ..pushStyle(ui.TextStyle(color: Colors.black))
          ..addText(item.productDescription);

        final descriptionParagraph = descriptionBuilder.build()
          ..layout(ui.ParagraphConstraints(
              width: canvasSize1.width -
                  headerWidths[1])); // Adjust width as needed
        canvas.drawParagraph(
            descriptionParagraph, Offset(headerWidths[1], positionHeight));
        positionHeight += descriptionParagraph.height +
            10; // Adjust height after drawing description
      } else {
        positionHeight += 10; // Skip space if description is empty
      }
    }

    positionHeight = positionHeight + 15;
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    final totals = [
      ['Total quantity:', roundStringWith(totalQty)],
    ];
    positionHeight = positionHeight + 25; // Space before totals
    for (final total in totals) {
      const totalTextStyle = TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        fontWeight: FontWeight.w700,
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
      final totalTextParagraph = totalTextBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
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
      final totalAmountParagraph = totalAmountBuilder.build()
        ..layout(ui.ParagraphConstraints(width: canvasSize1.width / 2));
      canvas.drawParagraph(
          totalAmountParagraph, Offset(canvasSize1.width / 2, positionHeight));

      positionHeight += totalTextParagraph.height + 10;
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(
        canvasSize1.width.toInt(), canvasSize1.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  Future<Uint8List> testData() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    Size canvasSize1 = Size(500, 100);

    const Color backgroundColor = Colors.white; // Specify your desired background color
    canvas.drawRect(Rect.fromLTWH(0, 0, canvasSize1.width, canvasSize1.height), Paint()..color = backgroundColor);

    final linePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    const companyDetailsStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );

    final companyDetailsParagraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: companyDetailsStyle.fontSize,
      fontWeight: companyDetailsStyle.fontWeight,
      fontFamily: companyDetailsStyle.fontFamily,
    );

    double positionHeight = 5.0;

    positionHeight = positionHeight + 20;
    final invoiceEngNameBuilder =
        ui.ParagraphBuilder(companyDetailsParagraphStyle)
          ..pushStyle(ui.TextStyle(
              color: Colors.black, fontSize: 35.0, fontWeight: FontWeight.bold))
          ..addText("Demo data");

    final invoiceDetailsDetailsParagraph = invoiceEngNameBuilder.build()
      ..layout(ui.ParagraphConstraints(width: canvasSize1.width));
    canvas.drawParagraph(
        invoiceDetailsDetailsParagraph, Offset(0, positionHeight));
    canvas.drawLine(Offset(0, positionHeight),
        Offset(canvasSize1.width, positionHeight), linePaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(
        canvasSize1.width.toInt(), canvasSize1.height.toInt());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  ///Image method
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
              dataPrint.clear();
              await kotPrintConnect(printListData[i].ip, i,
                  printListData[i].items, false, isUpdate);
              await Future.delayed(
                  const Duration(seconds: 1)); // Add a delay between print jobs
            } catch (e) {
              print('log ${e.toString()}');
              print(e.toString());
            }
          }

          /// cancel order print
          for (var i = 0; i < cancelOrder.length; i++) {
            try {
              dataPrint.clear();
              await kotPrintConnect(printListDataCancel[i].ip, i,
                  printListDataCancel[i].items, true, false);
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
      } catch (e) {}
    }
  }

  Future<void> kotPrintConnect(
      String printerIp, id, items, bool isCancelNote, isUpdate) async {
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
      await kotPrint(printerIp, profile, id, items, isCancelNote, isUpdate);
    } catch (e) {
      print('------------------------------${e.toString()}');
    }
  }

  Future<void> kotPrint(
      printerAddress, profile, id, items, bool isCancelNote, isUpdate) async {
    List<int> bytes = [];
    final generator = Generator(PaperSize.mm80, profile);
    final arabicImageBytes = await generateKOT(
        printerAddress: printerAddress,
        id: id,
        items: items,
        isCancelNote: isCancelNote,
        isUpdate: isUpdate);
    final Img.Image? image = Img.decodeImage(arabicImageBytes);
    final Img.Image resizedImage = Img.copyResize(image!, width: 520);
    bytes += generator.imageRaster(resizedImage);
    bytes += generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, printerAddress);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg =
          "Failed to generate a print please make sure to use the correct printer name";
    }
  }
}

List<ItemsDetails> dataPrint = [];
List<PrintDetails> printListData = [];

class PrintDetails {
  var items, kitchenName, ip, totalQty;

  PrintDetails({
    this.kitchenName,
    this.items,
    this.ip,
    this.totalQty,
  });

  factory PrintDetails.fromJson(Map<dynamic, dynamic> json) {
    return PrintDetails(
      items: json['Items'],
      kitchenName: json['kitchen_name'],
      ip: json['IPAddress'],
      totalQty: json['TotalQty'].toString(),
    );
  }
}

class ItemsDetails {
  var productName,
      productDescription,
      qty,
      tableName,
      orderTypeI,
      tokenNumber,
      flavour,
      voucherNo;

  ItemsDetails(
      {this.productName,
      this.productDescription,
      this.qty,
      this.tableName,
      this.orderTypeI,
      this.tokenNumber,
      this.flavour,
      this.voucherNo});

  factory ItemsDetails.fromJson(Map<dynamic, dynamic> json) {
    return ItemsDetails(
      productName: json['ProductName'],
      productDescription: json['ProductDescription'] ?? "",
      qty: json['Qty'].toString(),
      tableName: json['TableName'] ?? "",
      orderTypeI: json['OrderType'],
      tokenNumber: json['TokenNumber'].toString(),
      voucherNo: json['VoucherNo'],
      flavour: json['flavour'] ?? '',
    );
  }
}
