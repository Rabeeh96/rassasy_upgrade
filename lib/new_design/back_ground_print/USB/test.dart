//
//./
// Future<void> invoicePrintTemplate4(defaultIP,profile,tokenVal, paymentDetailsInPrint, headerAlignment, salesMan, OpenDrawer,timeInPrint,hideTaxDetails,defaultCodePage) async {
//   List<int> bytes = [];
//   final generator = Generator(PaperSize.mm80, profile);
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
//   var buildingDetails = BluetoothPrintThermalDetails.buildingNumber;
//   var streetName = BluetoothPrintThermalDetails.streetName;
//   var companySecondName = BluetoothPrintThermalDetails.secondName;
//   var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
//   var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
//   var companyTax = BluetoothPrintThermalDetails.vatNumberCompany;
//   var companyCrNumber = BluetoothPrintThermalDetails.cRNumberCompany;
//   var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
//   var qrCodeData = BluetoothPrintThermalDetails.qrCodeImage;
//
//   var voucherNumber = BluetoothPrintThermalDetails.voucherNumber;
//   var customerName = BluetoothPrintThermalDetails.ledgerName;
//   print("________________LedgerName   ${BluetoothPrintThermalDetails.ledgerName}");
//   print("________________customerName     ${BluetoothPrintThermalDetails.customerName}");
//
//   if (BluetoothPrintThermalDetails.ledgerName == "Cash In Hand") {
//     customerName = BluetoothPrintThermalDetails.customerName;
//   }
//
//   var date = BluetoothPrintThermalDetails.date;
//   var customerPhone = BluetoothPrintThermalDetails.customerPhone;
//   var grossAmount = roundStringWith(BluetoothPrintThermalDetails.grossAmount);
//   var discount = roundStringWith(BluetoothPrintThermalDetails.discount);
//   var totalTax = roundStringWith(BluetoothPrintThermalDetails.totalTax);
//   var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
//   var vatAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalVATAmount);
//   var exciseAmountTotal = roundStringWith(BluetoothPrintThermalDetails.totalExciseAmount);
//   bool showExcise = double.parse(exciseAmountTotal) > 0.0 ? true : false;
//   var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
//
//   var token = BluetoothPrintThermalDetails.tokenNumber;
//
//   var cashReceived = BluetoothPrintThermalDetails.cashReceived;
//   var bankReceived = BluetoothPrintThermalDetails.bankReceived;
//   var balance = BluetoothPrintThermalDetails.balance;
//   var orderType = BluetoothPrintThermalDetails.salesType;
//   var tableName = BluetoothPrintThermalDetails.tableName;
//
//
//   bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.center));
//
//   if (PrintDataDetails.type == "SI") {
//     if (companyLogo != "") {
//       final Uint8List imageData = await _fetchImageData(companyLogo);
//       final Img.Image? image = Img.decodeImage(imageData);
//       final Img.Image resizedImage = Img.copyResize(image!, width: 200);
//       bytes +=generator.imageRaster(resizedImage);
//       //   bytes +=generator.image(resizedImage);
//     }
//   }
//
//   bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
//   Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName));
//
//
//
//
//
//   Uint8List companyTaxEnc = await CharsetConverter.encode("ISO-8859-6", setString('ضريبه  ' + companyTax));
//   Uint8List companyCREnc = await CharsetConverter.encode("ISO-8859-6", setString('س. ت  ' + companyCrNumber));
//   Uint8List companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone));
//   Uint8List salesManDetailsEnc = await CharsetConverter.encode("ISO-8859-6", setString('رجل المبيعات ' + salesMan));
//
//   if (headerAlignment) {
//     companyPhoneEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyPhone));
//   }
//
//   Uint8List invoiceTypeEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
//   Uint8List invoiceTypeArabicEnc = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));
//
//   Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
//   Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
//   Uint8List exciseTax = await CharsetConverter.encode("ISO-8859-6", setString('مبلغ الضريبة الانتقائية'));
//   Uint8List vatTax = await CharsetConverter.encode("ISO-8859-6", setString('ضريبة القيمة المضافة'));
//   Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('خصم'));
//   Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
//
//   Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
//   Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
//   Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));
//
//   if (headerAlignment) {
//     bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
//     if (companyName != "") {
//       bytes +=generator.textEncoded(companyNameEnc,
//           styles: const PosStyles(
//               height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
//     }
//     if (companySecondName != "") {
//       Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));
//
//       bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));
//       bytes +=generator.textEncoded(companySecondNameEncode,
//           styles: const PosStyles(
//               height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
//
//     }
//
//     if (buildingDetails != "") {
//       Uint8List buildingDetailsEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));
//       bytes +=generator.row([
//         PosColumn(text: 'Building', width: 2, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(text: '', width: 1),
//         PosColumn(
//             textEncoded: buildingDetailsEncode,
//             width: 9,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//
//     }
//
//     if (streetName != "") {
//
//       Uint8List streetNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));
//
//       bytes +=generator.row([
//         PosColumn(text: 'Street ', width: 2, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(
//             textEncoded: streetNameEncode,
//             width: 9,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//
//     }
//
//     if (companyTax != "") {
//       bytes +=generator.row([
//         PosColumn(text: 'Vat Number', width: 2, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(
//             textEncoded: companyTaxEnc,
//             width: 9,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//     }
//
//     if (companyPhone != "") {
//       bytes +=generator.row([
//         PosColumn(text: 'Phone', width: 2, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(
//             textEncoded: companyPhoneEnc,
//             width: 9,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//       //  bytes +=generator.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
//     }
//
//     if (salesMan != "") {
//       bytes +=generator.row([
//         PosColumn(text: 'Sales man', width: 2, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
//         PosColumn(
//             textEncoded: salesManDetailsEnc,
//             width: 9,
//             styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       ]);
//       //  bytes +=generator.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
//     }
//   } else {
//     if (companyName != "") {
//       bytes +=generator.textEncoded(companyNameEnc,
//           styles: const PosStyles(
//               height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
//     }
//
//     if (companySecondName != "") {
//       Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));
//
//       bytes +=generator.textEncoded(companySecondNameEncode,
//           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (buildingDetails != "") {
//       Uint8List secondAddress1Encode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));
//       bytes +=generator.textEncoded(secondAddress1Encode,
//           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (streetName != "") {
//       Uint8List streetEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));
//
//       bytes +=generator.textEncoded(streetEncode,
//           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (companyTax != "") {
//       bytes +=generator.textEncoded(companyTaxEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
//     }
//     if (companyCrNumber != "") {
//       bytes +=generator.textEncoded(companyCREnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.center));
//     }
//
//     if (companyPhone != "") {
//       bytes +=generator.textEncoded(companyPhoneEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//
//     if (salesMan != "") {
//       bytes +=generator.textEncoded(salesManDetailsEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     }
//   }
//
//   bytes +=generator.emptyLines(1);
//
//   bytes +=generator.textEncoded(invoiceTypeEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size2, align: PosAlign.center));
//   bytes +=generator.textEncoded(invoiceTypeArabicEnc, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size2, align: PosAlign.center));
//
//   var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
//   Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
//   Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
//   Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
//   Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
//   Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));
//   Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
//   Uint8List tableEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));
//
//
//   if (tokenVal) {
//     bytes +=generator.hr();
//     bytes +=generator.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));
//     bytes +=generator.text(token, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
//     bytes +=generator.textEncoded(tokenEnc, styles: const PosStyles(bold: true, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
//     bytes +=generator.hr();
//   } else {
//     bytes +=generator.row([
//       PosColumn(text: 'Token No ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           textEncoded: tokenEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: token, width: 6, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//   }
//
//   bytes +=generator.row([
//     PosColumn(text: 'Voucher No  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//     PosColumn(
//         textEncoded: voucherNoEnc,
//         width: 3,
//         styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: voucherNumber, width: 6, styles: const PosStyles(align: PosAlign.right)),
//   ]);
//
//   bytes +=generator.row([
//     PosColumn(text: 'Date  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
//     PosColumn(
//         textEncoded: dateEnc,
//         width: 3,
//         styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: date, width: 6, styles: const PosStyles(align: PosAlign.right)),
//   ]);
//
//
//   if (customerName != "") {
//
//     Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName));
//
//     bytes +=generator.row([
//       PosColumn(text: 'Name    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           textEncoded: customerEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(
//           textEncoded: customerNameEnc,
//           width: 6,
//           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//   }
//   if (customerPhone != "") {
//
//     Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));
//
//     bytes +=generator.row([
//       PosColumn(text: 'Phone    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           textEncoded: phoneEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(
//           textEncoded: phoneNoEncoded,
//           width: 6,
//           styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//   }
//
//   bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage));
//   bytes +=generator.row([
//     PosColumn(text: 'Order type    ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//     PosColumn(textEncoded: typeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: orderType, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//   ]);
//
//   bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage));
//
//   if (tableName != "") {
//     bytes +=generator.row([
//       PosColumn(text: 'Table Name   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           textEncoded: tableEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: tableName, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//   }
//   if (timeInPrint) {
//     var time = BluetoothPrintThermalDetails.time;
//
//     String timeInvoice = convertToSaudiArabiaTime(time,countyCodeCompany);
//     Uint8List timeEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));
//
//     bytes +=generator.row([
//       PosColumn(text: 'Time   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(
//           textEncoded: timeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: timeInvoice, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//   }
//   bytes +=generator.hr();
//
//   Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
//   Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
//   Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString(" الكمية "));
//   Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
//   Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));
//
//   bytes +=generator.row([
//     PosColumn(
//         text: 'SL',
//         width: 1,
//         styles: const PosStyles(
//           height: PosTextSize.size1,
//         )),
//     PosColumn(text: 'Item Name', width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     PosColumn(text: 'Qty', width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     PosColumn(text: 'Rate', width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: 'Net', width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//   ]);
//
//   bytes +=generator.row([
//     PosColumn(
//         textEncoded: slNoEnc,
//         width: 1,
//         styles: const PosStyles(
//           height: PosTextSize.size1,
//           fontType: PosFontType.fontA,
//         )),
//     PosColumn(textEncoded: productNameEnc, width: 5, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     PosColumn(textEncoded: qtyEnc, width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
//     PosColumn(textEncoded: rateEnc, width: 2, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(textEncoded: netEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//   ]);
//
//   bytes +=generator.hr();
//
//   for (var i = 0; i < tableDataDetailsPrint.length; i++) {
//     var slNo = i + 1;
//
//     Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName));
//
//     bytes +=generator.row([
//       PosColumn(
//           text: "$slNo",
//           width: 1,
//           styles: const PosStyles(
//             height: PosTextSize.size1,
//           )),
//       PosColumn(textEncoded: productName, width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
//       PosColumn(text: tableDataDetailsPrint[i].qty, width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: tokenVal)),
//       PosColumn(
//           text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
//           width: 2,
//           styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(
//           text: roundStringWith(tableDataDetailsPrint[i].netAmount),
//           width: 3,
//           styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
//     ]);
//
//
//
//     String productDescription =tableDataDetailsPrint[i].productDescription;
//
//     if(productDescription!=""){
//       Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription));
//       bytes +=generator.row([
//         PosColumn(
//             textEncoded: description, width: 7, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(
//             text: '',
//             width: 5,
//             styles: const PosStyles(
//               height: PosTextSize.size1,
//             ))
//       ]);
//     }
//
//
//
//     bytes +=generator.hr();
//   }
//   bytes +=generator.emptyLines(1);
//   bytes +=generator.row([
//     PosColumn(text: 'Gross Amount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//     PosColumn(
//         textEncoded: ga,
//         width: 4,
//         styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: roundStringWith(grossAmount), width: 4, styles: const PosStyles(align: PosAlign.right)),
//   ]);
//
//
//
//   if(hideTaxDetails){
//
//     if (showExcise) {
//       bytes +=generator.row([
//         PosColumn(text: 'Total Excise Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: exciseTax,
//             width: 4,
//             styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(text: roundStringWith(exciseAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//       bytes +=generator.row([
//         PosColumn(text: 'Total VAT', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: vatTax,
//             width: 4,
//             styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//         PosColumn(text: roundStringWith(vatAmountTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//     }
//
//
//     bytes +=generator.row([
//       PosColumn(text: 'Total Tax', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//       PosColumn(
//           textEncoded: tt,
//           width: 4,
//           styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//       PosColumn(text: roundStringWith(totalTax), width: 4, styles: const PosStyles(align: PosAlign.right)),
//     ]);
//
//   }
//
//   bytes +=generator.row([
//     PosColumn(text: 'Discount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//     PosColumn(
//         textEncoded: dis,
//         width: 4,
//         styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
//     PosColumn(text: roundStringWith(discount), width: 4, styles: const PosStyles(align: PosAlign.right)),
//   ]);
//   // bytes +=generator.setStyles(PosStyles.defaults());
//
//   bytes +=generator.hr();
//   bytes +=generator.row([
//     PosColumn(
//         text: 'Grand Total',
//         width: 3,
//         styles: const PosStyles(
//           bold: true,
//           fontType: PosFontType.fontB,
//           height: PosTextSize.size2,
//         )),
//     PosColumn(
//         textEncoded: gt,
//         width: 3,
//         styles:
//         const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right, bold: true)),
//     PosColumn(
//         text: "$countyCodeCompany ${roundStringWith(grandTotal)}",
//         width: 6,
//         styles: const PosStyles(
//           fontType: PosFontType.fontA,
//           bold: true,
//           align: PosAlign.right,
//           height: PosTextSize.size2,
//           width: PosTextSize.size1,
//         )),
//   ]);
//   bytes +=generator.hr();
//   if (PrintDataDetails.type == "SI") {
//     if (paymentDetailsInPrint) {
//       bytes +=generator.row([
//         PosColumn(text: 'Cash receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: cr,
//             width: 5,
//             styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//         PosColumn(text: roundStringWith(cashReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//
//       bytes +=generator.row([
//         PosColumn(text: 'Bank receipt', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: br,
//             width: 5,
//             styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//         PosColumn(text: roundStringWith(bankReceived), width: 3, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//
//       bytes +=generator.row([
//         PosColumn(text: 'Balance', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
//         PosColumn(
//             textEncoded: bl,
//             width: 5,
//             styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
//         PosColumn(text: roundStringWith(balance), width: 3, styles: const PosStyles(align: PosAlign.right)),
//       ]);
//     }
//   }
//
//   if (qrCodeAvailable) {
//     bytes +=generator.feed(1);
//     var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
//         BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
//     bytes +=generator.qrcode(qrCode, size: QRSize.Size5);
//   }
//   // bytes +=generator.emptyLines(1);
//   // bytes +=generator.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));
//
//   bytes +=generator.cut();
//   if (PrintDataDetails.type == "SI") {
//     if (OpenDrawer) {
//       bytes +=generator.drawer();
//     }
//   }
//
//   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, defaultIP);
//   String msg = "";
//
//
//   if (res == "success") {
//     msg = "Printed Successfully";
//   } else {
//     msg = "Failed to generate a print please make sure to use the correct printer name";
//   }
//
// }
