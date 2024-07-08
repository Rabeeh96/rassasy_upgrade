import 'dart:convert';
import 'package:image/image.dart' as Img;
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/global.dart';

import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;
import 'dart:convert';


import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class USBPrintClassTest {

  printReq() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    final arabicImageBytes = await generateInvoice();



    final Img.Image? image = Img.decodeImage(arabicImageBytes);
    print("------113");
    final Img.Image resizedImage = Img.copyResize(image!,width: 550);
    print("------114");

    bytes += generator.imageRaster(resizedImage);
    // bytes += generator.setGlobalCodeTable('CP864');
    // Uint8List salam = await CharsetConverter.encode("ISO-8859-6", 'السلام عليكم صباح الخير عزيزتي جميعاً');
    // bytes += generator.textEncoded(salam);
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





  /// Direct text method for Gst company





}

