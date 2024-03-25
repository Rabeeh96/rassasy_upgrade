import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

// import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide Image;
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/charecter.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/back_ground_print_wifi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:charset_converter/charset_converter.dart';
import 'select_codepage.dart';




class PrintSettingsDetailed extends StatefulWidget {
  @override
  _PrintSettingsDetailedState createState() => _PrintSettingsDetailedState();
}

class _PrintSettingsDetailedState extends State<PrintSettingsDetailed> {



  TextEditingController code_page_controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDefault();
  }


  loadDefault()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp =  prefs.getString('defaultIP')??'';
    String width =  prefs.getString('width')??'150';
    ipController.text = defaultIp;
    widthController.text = width;
    discover(context);
    print('-default ip  ---$defaultIp');


  }

  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');
  TextEditingController widthController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  // TextEditingController ipController = TextEditingController()..text = "192.168.1.169";
  bool connectionTesting = false;

  Future<void> DemoPrint(NetworkPrinter printer,codepage) async {
    print(codepage);
    printer.setStyles(PosStyles(codeTable: codepage, align: PosAlign.center));
    Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString('السلام عليكم صباح الخير عزيزتي جميعاً'));
    printer.textEncoded(salam, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    printer.emptyLines(1);
    printer.cut();
  }

  Future<void> salesInvoicePrintDemo(NetworkPrinter printer) async {
    // List<ProductDetailsModel> tableDataDetailsPrint = [];
    //
    // var salesDetails = BluetoothPrintThermalDetails.salesDetails;
    // print(salesDetails);
    // for (Map user in salesDetails) {
    //   tableDataDetailsPrint.add(ProductDetailsModel.fromJson(user));
    // }

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
      invoiceType = "ORDER";
      invoiceTypeArabic = "(طلب المبيعات)";
    }


    var companyName = "Vikn Codes";
    var city = "Poonoor";
    var description = "Calicut";
    var companyCountry = "India";
    var companyPhone = "9876543210";
    var companyTax = "1234567890";

    var voucherNumber = "SI001";
    var name = "Rabeeh";
    var date = "16-12-2021";
    var phone = "8714152075";
    var grossAmount = "250.00";
    var discount = "10.00";
    var totalTax = "20.00";
    var grandTotal = "90.00";
    var companyCrNumber = "125457848544";
    var countyCodeCompany = "SAR";


    // var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
    var token = "121";

    var cashReceived = "150";
    var bankReceived = "150";
    var balance = "150";
    var orderType = "Dinig";

    //



    printer.setStyles(PosStyles(codeTable: 'CP864', align: PosAlign.center));
    Uint8List companyNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(companyName));
    Uint8List cityEncode = await CharsetConverter.encode("ISO-8859-6", setString(city));
    Uint8List descriptionC = await CharsetConverter.encode("ISO-8859-6", setString(description));
    Uint8List h3E = await CharsetConverter.encode("ISO-8859-6", setString('ضريبه  ' + companyTax));
    Uint8List h4E = await CharsetConverter.encode("ISO-8859-6", setString('س. ت  ' + companyCrNumber));
    Uint8List h5E = await CharsetConverter.encode("ISO-8859-6", setString('جوال ' + companyPhone));
    Uint8List h6E = await CharsetConverter.encode("ISO-8859-6", setString(invoiceType));
    Uint8List sH = await CharsetConverter.encode("ISO-8859-6", setString(invoiceTypeArabic));

    Uint8List ga = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));
    Uint8List tt = await CharsetConverter.encode("ISO-8859-6", setString('خصم'));
    Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
    Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));

    Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
    Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
    Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));

    printer.textEncoded(companyNameEnc, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    printer.textEncoded(descriptionC, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    printer.textEncoded(cityEncode, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));


    printer.textEncoded(h3E, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
    printer.textEncoded(h4E, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
    printer.textEncoded(h5E, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
    printer.textEncoded(h6E, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
    printer.textEncoded(sH, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));

    printer.emptyLines(1);


    var isoDate = DateTime.parse("2023-02-23").toIso8601String();
    printer.setStyles(PosStyles(align:PosAlign.left));
    printer.row([
      PosColumn(text: 'Token No ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: token, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(text: 'Voucher No :', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: voucherNumber, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    printer.row([
      PosColumn(text: 'Date      ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: date, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    Uint8List customerName = await CharsetConverter.encode("ISO-8859-6", setString(name));
    Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(phone));
    printer.row([
      PosColumn(text: 'Name    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(textEncoded: customerName, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);
    printer.row([
      PosColumn(text: 'Phone    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(textEncoded: phoneNoEncoded, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.row([
      PosColumn(text: 'Order type    ', width: 3, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: ':', width: 1, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
      PosColumn(text: orderType, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
    ]);

    printer.hr();
    printer.row([
      PosColumn(
          text: 'SL',
          width: 1,
          styles: PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Product Name',
          width: 6,
          styles: PosStyles(
            height: PosTextSize.size1,
          )),
      PosColumn(
          text: 'Qty',
          width: 1,
          styles: PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.center
          )),
      PosColumn(
          text: 'Rate',
          width: 2,
          styles: PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
      PosColumn(
          text: 'Net',
          width: 2,
          styles: PosStyles(
              height: PosTextSize.size1,
              align: PosAlign.right
          )),
    ]);
    printer.hr();

    for (var i = 0; i < 3; i++) {
      var slNo = i + 1;

      Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString("وصف المنتج"));
      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString("product name"));
      printer.row([
        PosColumn(
            text: "$slNo",
            width: 1,
            styles: PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(textEncoded: productName, width: 6, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: "20", width: 1, styles: PosStyles(height: PosTextSize.size1, align: PosAlign.center)),
        PosColumn(
            text: "50",
            width: 2,
            styles: PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
        PosColumn(
            text:"120",
            width: 2,
            styles: PosStyles(
                height: PosTextSize.size1,
                align: PosAlign.right
            )),
      ]);

      printer.row([
        PosColumn(textEncoded: description, width: 8, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1,align: PosAlign.right)),
        PosColumn(
            text: '',
            width: 4,
            styles: PosStyles(
              height: PosTextSize.size1,
            )),
      ]);

      printer.hr();
    }
    printer.feed(0);



    printer.row([
      PosColumn(text: 'Gross Amount', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      PosColumn(textEncoded:ga,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
      // printer.textEncoded(ga, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left));
      PosColumn(text: roundStringWith(grossAmount), width: 3, styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.row([
      PosColumn(text: 'Total Tax', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      PosColumn(textEncoded:tt,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),

      PosColumn(text: roundStringWith(totalTax), width: 3,styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Discount', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      PosColumn(textEncoded:dis,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
      PosColumn(text: roundStringWith(discount), width: 3,styles: PosStyles(align: PosAlign.right)),
    ]);

    printer.emptyLines(1);
    printer.row([
      PosColumn(text: 'Grand Total', width: 4, styles: PosStyles(bold: true, fontType: PosFontType.fontB)),
      PosColumn(textEncoded:gt,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left,bold: true)),
      PosColumn(text: countyCodeCompany + " " + roundStringWith(grandTotal), width: 3, styles: PosStyles(fontType: PosFontType.fontA, bold: true,align: PosAlign.right)),
    ]);

    if (qrCodeAvailable == true) {
      /// details commented
      // printer.row([
      //   PosColumn(text: 'Cash receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      //   PosColumn(textEncoded:cr,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
      //   PosColumn(text: roundStringWith(cashReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
      // ]);
      //
      //
      // printer.row([
      //   PosColumn(text: 'Bank receipt', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      //   PosColumn(textEncoded:br,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
      //   PosColumn(text: roundStringWith(bankReceived), width: 3,styles: PosStyles(align: PosAlign.right)),
      // ]);
      //
      // printer.row([
      //   PosColumn(text: 'Balance', width: 4, styles: PosStyles(fontType: PosFontType.fontB)),
      //   PosColumn(textEncoded:bl,width: 5, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
      //   PosColumn(text: roundStringWith(balance), width: 3,styles: PosStyles(align: PosAlign.right)),
      // ]);
      printer.feed(1);
      var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate, BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
      printer.qrcode(qrCode, size: QRSize.Size5);
    }

    printer.emptyLines(1);
    printer.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));
    printer.cut();
  }

  Future<void> demoPrint(NetworkPrinter printer) async {


    var dataa = printArabicText();

    Uint8List h5E = await CharsetConverter.encode("ISO-8859-6", setString("Rabeeh"));
    printer.textEncoded(dataa,styles:PosStyles(height:PosTextSize.size1,width:PosTextSize.size1,align: PosAlign.center));
    printer.emptyLines(1);
    final arabicText = "\u0627\u0644\u0633\u0644\u0627\u0645 \u0639\u0644\u064a\u0643\u0645"; // Arabic text encoded with Unicode
    printer.text(arabicText);



    printer.text('Powered By ViknCodes',
        styles: PosStyles(
            height: PosTextSize.size1,
            bold: true,
            width: PosTextSize.size1,
            align: PosAlign.center));

    printer.cut();

  }

  var printHelper = new AppBlocs();




  var invoiceType = "";
  var invoiceTypeArabic = "";
  var companyName = " ";
  var companyAddress1 = "";
  var companyAddress2 = " ";
  var companyDescription = " ";
  var companyCountry = "";
  var companyPhone = "";
  var companyTax = "";
  var companyCrNumber = "";
  var totalQty = "0.00";
  var currencyCode = "";
  var voucherNumber = "";
  var customerName = "";
  var customerVatNumber = "";
  var customerCrNumber = "";
  var date = "";
  var phone = "";
  var grossAmount = "0.00";
  var discount = "0.00";
  var totalTax = "0.00";
  var grandTotal = "0.00";
  var companyLogo = "";

  var qrCode = "";

  var fontSize = 10;


  Widget asd() {
    return Container(
// color: Colors.red,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Container(
            //       height: 100,
            //       width: 100,
            //       child: Image.network(companyLogo+"sd")),
            // ),
            Column(
              children: [
                Text(
                  companyName,
                  style: TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
                companyDescription != "" ? Text(
                  companyDescription,
                  style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ) : Container(),
                Text(
                  companyAddress1 + companyAddress2,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Row(
              children: [
                Text(
                  companyTax + " :",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "الرقم الضريبي",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            companyCrNumber != ""
                ? Row(
              children: [
                Text(
                  companyCrNumber + " :",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "س. ت",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            )
                : Container(),
            Row(
              children: [
                Text(
                  companyPhone,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  invoiceType,
                  style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Text(
                  invoiceTypeArabic,
                  style: TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ],

            ),
            SizedBox(
              height: 10,
              child: Text(
                  "--------------------------------------------------------------------------------------------------------"),
            ),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "Voucher No",
                        style: TextStyle(

                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        voucherNumber,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "رقم الفاتورة",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Date",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "تاريخ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'name'.tr,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        customerName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "اسم",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            customerCrNumber != ""
                ? Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "CR Number",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      customerCrNumber,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "س. ت",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )
                : Container(),
            customerVatNumber != ""
                ? Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "VAT No",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      customerVatNumber,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "الرقم الضريبي",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )
                : Container(),
            phone != ""
                ? Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Phone",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      phone,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "هاتف",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 1,
                ),
              ],
            )
                : Container(),
            SizedBox(
              height: 20,
              child: Text(
                  "--------------------------------------------------------------------------------------------------------"),
            ),
            Padding(
              padding:
              const EdgeInsets.only(left: 2.0, right: 2.00),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 9,
                    height: 50,
                    // color: Colors.yellow,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "SL",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "رقم",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Product name",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "اسم المنتج",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 8,
                    // color: Colors.green,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Qty",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "كمية",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 8,
                    // color: Colors.blue,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rate",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "معدل",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 8,
                    // color: Colors.blueGrey,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Net",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "مجموع",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
              child: Text(
                  "--------------------------------------------------------------------------------------------------------"),
            ),
            // Padding(
            //   padding:
            //   const EdgeInsets.only(left: 2.0, right: 2.00),
            //   child: ListView.builder(
            //     scrollDirection: Axis.vertical,
            //     shrinkWrap: true,
            //     physics: ScrollPhysics(),
            //     itemCount: tableDataDetailsPrint.length,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           SizedBox(
            //             height: 5,
            //
            //           ),
            //           Row(
            //             mainAxisAlignment:
            //             MainAxisAlignment.spaceBetween,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Expanded(
            //                 child: Container(
            //                   child: Center(
            //                     child: Text(
            //                       "${index + 1}",
            //                       style: TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                   ),
            //                 ),
            //                 flex: 1,
            //               ),
            //               Expanded(
            //                 child: Center(
            //                   child: Column(
            //                     children: [
            //                       Align(
            //                         alignment: Alignment.centerLeft,
            //                         child: Text(
            //                           tableDataDetailsPrint[index]
            //                               .productName,
            //                           style: TextStyle(
            //                               fontSize: 16,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       ),
            //
            //                       tableDataDetailsPrint[index].description != ""
            //                           ?
            //                       Align(
            //                         alignment: Alignment.centerLeft,
            //                         child: Text(
            //                           tableDataDetailsPrint[index]
            //                               .description,
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               fontWeight: FontWeight.bold),
            //                         ),
            //                       )
            //                           : Container(),
            //                     ],
            //                   ),
            //                 ),
            //                 flex: 6,
            //               ),
            //               Expanded(
            //                 child: Center(
            //                   child: Align(
            //                     alignment: Alignment.centerRight,
            //                     child: Text(
            //                       roundStringWith(
            //                           tableDataDetailsPrint[index]
            //                               .quantity),
            //                       style: TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                   ),
            //                 ),
            //                 flex: 2,
            //               ),
            //               Expanded(
            //                 child: Center(
            //                   child: Align(
            //                     alignment: Alignment.centerRight,
            //                     child: Text(
            //                       roundStringWith(
            //                           tableDataDetailsPrint[index]
            //                               .unitPrice),
            //                       style: TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                   ),
            //                 ),
            //                 flex: 2,
            //               ),
            //               Expanded(
            //                 child: Center(
            //                   child: Align(
            //                     alignment: Alignment.centerRight,
            //                     child: Text(
            //                       roundStringWith(
            //                           tableDataDetailsPrint[index]
            //                               .netAmount),
            //                       style: TextStyle(
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700),
            //                     ),
            //                   ),
            //                 ),
            //                 flex: 2,
            //               ),
            //             ],
            //           ),
            //
            //         ],
            //       );
            //     },
            //   ),
            // ),

            SizedBox(
              height: 10,
              child: Text(
                  "--------------------------------------------------------------------------------------------------------"),
            ),


            Padding(
              padding:
              const EdgeInsets.only(left: 2.0, right: 2.00),
              child: Column(
                children: [

                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              "Total Quantity",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "(الكمية الإجمالية)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(
                          roundStringWith(totalQty),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              "Gross Amount",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "(المبلغ الإجمالي)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        //
                        // Text(
                        //   "Gross Amount (المبلغ الإجمالي)",
                        //   style: TextStyle(
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.w700),
                        // ),
                        Text(
                          roundStringWith(grossAmount),

                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              'disc'.tr,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "(خصم)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(

                          roundStringWith(discount),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Text(
                              "Total Tax",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "(مجموع الضريبة)",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Text(

                          roundStringWith(totalTax),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Grand Total (المبلغ الإجمالي)",
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700),
                        ),
                        Container(
                          child: Text(

                            currencyCode + ' ' + roundStringWith(grandTotal),
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 20,
            ),
          ],
        ));
  }
  Widget test() {
    return Container(
      color: Colors.red,
      //  width: 100,
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "رقم",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "رقم",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "رقم",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "رقم",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
          // Container(
          //   width: 25,
          //   height: 50,
          //    child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Text(
          //         "رقم",
          //         style: TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: 100,
          //   width: 25,
          //   // color: Colors.red,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //
          //       Text(
          //         "اسم المنتج",
          //         style: TextStyle(
          //             fontSize: 15,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // ),
          // Container(
          //   height: 50,
          //   width: 25,
          //   // color: Colors.green,
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //
          //         Text(
          //           "كمية",
          //           style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   height: 50,
          //   width: 25,
          //   // color: Colors.blue,
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //
          //         Text(
          //           "معدل",
          //           style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   height: 50,
          //   width: 25,
          //   // color: Colors.blueGrey,
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //
          //         Text(
          //           "مجموع",
          //           style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.bold),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),);
  }
 // ScreenshotController screenshotController1 = ScreenshotController();


  void discover(BuildContext ctx) async {

    if(ipController.text ==""){

      dialogBox(context, "Please enter ip address ");
    }
    else{
      setState(() {

        isDiscovering = true;
        devices.clear();
        found = -1;
      });
      String ip = ipController.text;
      setState(() {
        localIp = ip;
      });

      final String subnet = ip.substring(0, ip.lastIndexOf('.'));
      int port = 9100;
      try {
        port = int.parse(portController.text);
      } catch (e) {
        portController.text = port.toString();
      }
      print('subnet:\t$subnet, port:\t$port');

      final stream = NetworkAnalyzer.discover2(subnet, port);

      stream.listen((NetworkAddress addr) {
        if (addr.exists) {
          print('Found device: ${addr.ip}');
          setState(() {
            devices.add(addr.ip);
            found = devices.length;
          });
        }
      })
        ..onDone(() {
          setState(() {
            isDiscovering = false;
            found = devices.length;
          });
        })
        ..onError((dynamic e) {});
    }

  }


  Uint8List convertStringToUint8List(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);
//111
    return unit8List;
  }


  Future<void> printDemoReceipt(NetworkPrinter printer) async {

    var h1 = " Rabeeh السلام عليكم ورحمة الله";
    // var h1 = "السلام عليكم";
    printer.text('GROCERYLY',
        styles: PosStyles(
          align: PosAlign.left,
        ),
        linesAfter: 1);

    var val = h1.split('').reversed.join();


    Uint8List h1E = await CharsetConverter.encode("ISO-8859-6", setString(h1));

    // PosColumn(textEncoded:h1E, width: 7,styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
    printer.textEncoded(h1E,  styles: PosStyles(
      align: PosAlign.center,
    ));

    printer.text('GROCERYLY',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);



    printer.hr();
    printer.cut();
  }





  saveWidth(val)async{
    if(widthController.text ==""){

    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String width = widthController.text;
      prefs.setString('width',"150");
    }

  }



  List<int> testTicket(profile) {
    List<int> bytes = [];
    // Using default profile
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  printArabicText() {
    final arabicText = 'مرحبًا'; // Arabic text
    final encodedText = utf8.encode(arabicText);
    final Uint8List bytes = Uint8List.fromList(encodedText);
    return bytes;
  }

  void directPrint(BuildContext ctx) async {


    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp =  prefs.getString('defaultIP')??'';
    print('-default ip  ---$defaultIp');



    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);





    var  port = int.parse(portController.text);
    final PosPrintResult res = await printer.connect('192.168.1.16', port: port,);

    print(res.msg);
    if(res == PosPrintResult.success) {
      await demoPrint(printer);
      printer.disconnect();
    }
  }

  void testPrint({required BuildContext ctx,required String codePage,required String capability}) async {


    //  choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    print("codePage $codePage");
    print("capability $capability");
    var profile = await CapabilityProfile.load(name: capability);
    final printer = NetworkPrinter(paper, profile);

    var  port = int.parse(portController.text);
    //  printer ip address
    var printerIp = ipController.text;

    final PosPrintResult res = await printer.connect(printerIp, port: port);

    print(res.msg);
    if(res == PosPrintResult.success) {
      //  function for printing purpose
      await DemoPrint(printer,codePage);
      printer.disconnect();
    }
  }


 void testPrint2({required BuildContext ctx,required String codePage,required String capability}) async {


    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);
    var  port = int.parse(portController.text);
    var printerIp = ipController.text;
    final PosPrintResult res = await printer.connect(printerIp, port: port);

    if(res == PosPrintResult.success) {
      await DemoPrint(printer,codePage);
      printer.disconnect();
    }
  }




  connectionTest(printerIp)async{
    const PaperSize paper = PaperSize.mm80;

    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    var  port = int.parse(portController.text);
    final PosPrintResult res = await printer.connect(printerIp, port: port);
    print(res.msg);
    if(res.msg=="Success"){
      discover(context);
    }
    else{
      discover(context);
    }
    printer.disconnect();
    return res.msg;
  }

  // connectionReconnect(printerIp)async{
  //   const PaperSize paper = PaperSize.mm80;
  //
  //   final profile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile);
  //
  //   var  port = int.parse(portController.text);
  //   final PosPrintResult res = await printer.connect(printerIp, port: port);
  //
  //
  //   // printer.reset();
  //   // printer.
  //   // dialogBox(context, res.msg);
  //
  //
  // }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = await Directory(appDocDirectory.path + '/' + 'dir')
        .create(recursive: true);
    return directory.path;
  }
  @override
  void dispose() {
    super.dispose();
    stop();
  }

  List<String> printerModels = [
    "XP-N160I",
    "RP80USE",
    "AF-240",
    "CT-S651",
    "NT-5890K",
    "OCD-100",
    "OCD-300",
    "P822D",
    "POS-5890",
    "RP326",
    "SP2000",
    "ZKP8001",
    "TP806L",
    "Sunmi-V2",
    "TEP-200M",
    "TM-P80",
    "TM-P80-42col",
    "TM-T88II",
    "TM-T88III",
    "TM-T88IV",
    "TM-T88IV-SA",
    "TM-T88V",
    "TM-U220",
    "TSP600",
    "TUP500",
    "ZJ-5870",
    "default",
    "simple",
  ];
  bool withCapabilities=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ), //
          title: const Text(
            'Detailed settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[300],
          actions: <Widget>[

            ElevatedButton(onPressed: (){
              setState(() {

                withCapabilities  =!withCapabilities;
              });
            }, child: Text("Capabilities",style: TextStyle(color:withCapabilities?Colors.red:Colors.white10),)),

          ]),



      body: Builder(
        builder: (BuildContext context) {
          return  ListView(
            children: <Widget>[
              // Screenshot(
              //   controller: screenshotController1,
              //   child: Container(
              //       width: 300,
              //       child: Column(
              //         children: [
              //           Row(
              //             children: [
              //               Text(
              //                 "محمد نعم 臺灣  ",
              //                 style: TextStyle(
              //                     fontSize: 30, fontWeight: FontWeight.bold),
              //               ),
              //             ],
              //             mainAxisAlignment: MainAxisAlignment.center,
              //           ),
              //           Text(
              //               "----------------------------------------------------------------------------------"),
              //           Padding(
              //             padding: const EdgeInsets.only(bottom: 20.0),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text(
              //                   "(  汉字 )",
              //                   style: TextStyle(
              //                       fontSize: 40, fontWeight: FontWeight.bold),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Text(
              //                   "رقم الطلب",
              //                   style: TextStyle(
              //                       fontSize: 30, fontWeight: FontWeight.bold),
              //                 ),
              //               ],
              //             ),
              //           ),
              //           SizedBox(
              //             height: 20,
              //             child: Text(
              //                 "-------------------------------------------------------------------------------------"),
              //           ),
              //           Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Expanded(
              //                 child: Center(
              //                   child: Text(
              //                     "التفاصيل",
              //                     style: TextStyle(
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //                 flex: 6,
              //               ),
              //               Expanded(
              //                 child: Center(
              //                   child: Text(
              //                     "السعر ",
              //                     style: TextStyle(
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //                 flex: 2,
              //               ),
              //               Expanded(
              //                 child: Center(
              //                   child: Text(
              //                     "العدد",
              //                     style: TextStyle(
              //                         fontSize: 25,
              //                         fontWeight: FontWeight.bold),
              //                   ),
              //                 ),
              //                 flex: 2,
              //               ),
              //             ],
              //           ),
              //           ListView.builder(
              //             scrollDirection: Axis.vertical,
              //             shrinkWrap: true,
              //             physics: ScrollPhysics(),
              //             itemCount: 4,
              //             itemBuilder: (context, index) {
              //               return Card(
              //                 child: Row(
              //                   mainAxisAlignment:
              //                   MainAxisAlignment.spaceBetween,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Expanded(
              //                       child: Center(
              //                         child: Text(
              //                           "臺灣",
              //                           style: TextStyle(fontSize: 25),
              //                         ),
              //                       ),
              //                       flex: 6,
              //                     ),
              //                     Expanded(
              //                       child: Center(
              //                         child: Text(
              //                           "تجربة عيوني انتة ",
              //                           style: TextStyle(fontSize: 25),
              //                         ),
              //                       ),
              //                       flex: 2,
              //                     ),
              //                     Expanded(
              //                       child: Center(
              //                         child: Text(
              //                           "Test My little pice of huny",
              //                           style: TextStyle(fontSize: 25),
              //                         ),
              //                       ),
              //                       flex: 2,
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //           Text(
              //               "----------------------------------------------------------------------------------"),
              //         ],
              //       )),
              // ),

              // const SizedBox(height: 100),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/7,
                    child: TextField(
                      controller: portController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Port',
                        hintText: 'Port',
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Container(
                    width: MediaQuery.of(context).size.width/7,
                    child: TextField(
                      controller: ipController,
                      decoration: const InputDecoration(
                        labelText: 'Ip',
                        hintText: 'Ip',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 20),

                  Container(
                    width: 300,
                    height: 50,
                    color: Colors.redAccent,
                    child: TextField(
                        style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                        onTap: () async {

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => select_code_page()),
                          );

                          if (result != null) {
                            code_page_controller.text = result;
                          }
                        },
                        readOnly: true,
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        controller: code_page_controller,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(width: 1, color: Colors.grey),
                          ),
                          contentPadding: const EdgeInsets.all(7),
                          suffixIcon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          ),
                          labelText: "Select code page",
                          labelStyle: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                          border: InputBorder.none,
                        )),
                  ),
                //  Text('Local ip: $localIp', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 20),

                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, // Background color
                      ),
                      child: Text(
                          isDiscovering ? 'Discovering...' : 'Discover',style: TextStyle(color: Colors.white)),
                      onPressed: isDiscovering ? null : () => discover(context)),
                  //  onPressed: isDiscovering ? null : () => discover(context)),

                  SizedBox(width: 15),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan, // Background color
                      ),
                      child: Text(
                          'Check availability',style: TextStyle(color: Colors.white)),
                      //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
                      onPressed:()async{

                        start(context);
                        var asd = await connectionTest(ipController.text);
                        stop();
                        dialogBox(context, asd.toString());

                      }
                  ),


                ],
              ),

              const SizedBox(height: 25),
              found >= 0
                  ? Text('Found: $found device(s)',
                  style: TextStyle(fontSize: 16))
                  : Container(),

              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 6000, minHeight: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        //  color: Colors.redAccent,
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 20),
                            shrinkWrap: true,
                            itemCount: printerModels.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: ListTile(
                                  onTap: () async {
                                    if(withCapabilities){
                                      testPrint(ctx: context,capability: printerModels[index],codePage: code_page_controller.text);
                                    }
                                    else
                                      {
                                        testPrint2(ctx: context,capability: printerModels[index],codePage: '');
                                      }



                                    // if (bluetooth_controller.text == "") {
                                    //   await sho("Please select printer and code page");
                                    //
                                    // } else {
                                    //   var a = await bluetoothHelper.testprint(
                                    //       context: context,
                                    //       type: "1",
                                    //       capability: printerModels[index],
                                    //       address: bluetooth_controller.text,
                                    //       codepage: code_page_controller.text);
                                    //   print("Aaaaaaaaaaa$a");
                                    //   await sho(a);
                                    //
                                    // }
                                  },
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            printerModels[index],
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ),

              // Container(
              //   height: 250,
              //
              //   child:  ListView.builder(
              //     itemCount: devices.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return InkWell(
              //         onTap: () => testPrint(devices[index], context),
              //         child: Column(
              //           children: <Widget>[
              //             Container(
              //               height: 60,
              //               padding: EdgeInsets.only(left: 10),
              //               alignment: Alignment.centerLeft,
              //               child: Row(
              //                 children: <Widget>[
              //                   Icon(Icons.print),
              //                   SizedBox(width: 10),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                       CrossAxisAlignment.start,
              //                       mainAxisAlignment:
              //                       MainAxisAlignment.center,
              //                       children: <Widget>[
              //                         Text(
              //                           '${devices[index]}:${portController.text}',
              //                           style: TextStyle(fontSize: 16),
              //                         ),
              //                         Text(
              //                           'Click to print a test receipt',
              //                           style: TextStyle(
              //                               color: Colors.grey[700]),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                   Icon(Icons.chevron_right),
              //                 ],
              //               ),
              //             ),
              //             Divider(),
              //           ],
              //         ),
              //       );
              //     },
              //   ),
              // ),

/// commented
              // Padding(
              //   padding: const EdgeInsets.only(top: 50.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         children: [
              //           Container(
              //             width: MediaQuery.of(context).size.width/6,
              //             child:TextField(
              //               controller: widthController,
              //
              //               decoration: const InputDecoration(
              //                 labelText: 'Width',
              //                 hintText: 'width',
              //               ),
              //               keyboardType: TextInputType.number,
              //             ),
              //           ),
              //           const SizedBox(width: 40),
              //
              //
              //           Container(
              //             width: MediaQuery.of(context).size.width/5,
              //
              //             child:  ElevatedButton(
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: Colors.redAccent, // Background color
              //                 ),
              //                 onPressed: () async {
              //
              //                   SharedPreferences prefs = await SharedPreferences.getInstance();
              //                   if(widthController.text ==""){
              //
              //                   }
              //                   else{
              //
              //                     var width = widthController.text;
              //                     prefs.setString('width',width);
              //
              //                   }
              //
              //                 }, child: Text('Save width')),
              //           ),
              //         ],
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(right: 18.0),
              //         child: Container(
              //           width: MediaQuery.of(context).size.width/5,
              //
              //           child:  ElevatedButton(
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.black, // Background color
              //               ),
              //               onPressed: () async{
              //                 directPrint(context);
              //               },
              //               child: const Text('Test print')),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.only(right: 18.0),
              //         child: Container(
              //           width: MediaQuery.of(context).size.width/5,
              //
              //           child:  ElevatedButton(
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.black, // Background color
              //               ),
              //               onPressed: () async{
              //                 directPrint(context);
              //               },
              //               child: const Text('Demo')),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),






            ],
          );
        },
      ),



    );
  }




//   bluetoothPrintOrderAndInvoice(BuildContext context) async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//       ipController.text = prefs.getString('defaultIP') ?? '';
//     List<ProductDetailsModel> printDalesDetails = [];
//
//
//     var userID = 62;
//     var accessToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkzNTM5MTE2LCJpYXQiOjE2NjIwMDMxMTYsImp0aSI6ImEzOGZjOTI5YTgyNzRlNThhOGY0ZTRhZmI0YjBiMGZjIiwidXNlcl9pZCI6NjJ9.ft04tnpMggAIHW7khlme4rkEREzlhytvlHfiBsIcS8nY-tJAYpl7Mojn3a11rnturIKBeLm1jwbvLOQgj-C8yF8TBsTsZAcDSKw6vtpDn7kZ7QGEYlxD8LCaNuWR8rNV_a0vVli7De4ISc-Z70-ultJUWAtt29_HzNkc641-rZAlaxxKashuGkfGI-1NViUWfdH3qAw1tNxrCdiu63NkMLmF2-_gKNmmXiC8xiMNWej23LhG7Ys3TL7DpJYiMdo0TFwTjC4IB-qBmmcJ44ZwsQZuK3rL7u3-lWNLUzbxyKLygTQ6jwj6KwXAyHlHwhnLnLs4DGapPtxziWDq8-0w4YCGeVNenuP0OrE6RJbsujPzjSZ_Nwk51Onb1MSnd4Q7-DBvVdm6WNpmYsLr0BB_cHPNngq7VeqBolrOzqlPzylGGH1t5oY4ymbCKJ_pfrPrgcxLciAXcEXAfeI34wUawcN_JR8ldumoOyYbvZnXmJ-1-hdIxUeHre5sPVZ_nsauqAob83XavvO_pcd7B1f7Z8EVcYAa2s6UR5pQwNBbXDj8gh-Om4l-o45w-poLLIqypWasMj8IBhUosjEhA2ctkeCb0MSuiWMvfVrT9YeNFwFqtDjB1_kxx_iFBQ6vAq04ykmVjbY3M_MQL3SCuzNJlf98TAbr5_GymM9kObjp2Sk';
//     var companyID ='d4ca8637-696b-4ff0-8b88-991774b9547c';
//     var branchID =  1;
//
//     String url = 'https://www.api.viknbooks.com/api/v10/posholds/view/pos-sale/invoice/0c4e75c7-cb48-4f89-94c9-77b2cdd3b72a/';
//     print(url);
//     print(accessToken);
//     Map data = {
//       "CompanyID": companyID,
//       "BranchID": branchID,
//       "CreatedUserID": userID,
//       "PriceRounding": 2,
//       "Type":'SO'
//     };
//     print(data);
//     //encode Map to JSON
//     var body = json.encode(data);
//
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
//
//     var status = n["StatusCode"];
//     var responseJson = n["data"];
//
//     if (status == 6000) {
//
//
//       printDalesDetails.clear();
//
//       BluetoothPrintThermalDetails.voucherNumber = responseJson["VoucherNo"].toString();
//       BluetoothPrintThermalDetails.customerName =
//           responseJson["CustomerName"] ?? 'Cash In Hand';
//       BluetoothPrintThermalDetails.date = responseJson["Date"];
//       BluetoothPrintThermalDetails.netTotal =
//           responseJson["NetTotal_print"].toString();
//       BluetoothPrintThermalDetails.customerPhone =
//           responseJson["OrderPhone"] ?? "";
//       BluetoothPrintThermalDetails.grossAmount = responseJson["GrossAmt_print"].toString();
//       BluetoothPrintThermalDetails.sGstAmount = responseJson["SGSTAmount"].toString();
//       BluetoothPrintThermalDetails.cGstAmount = responseJson["CGSTAmount"].toString();
//       BluetoothPrintThermalDetails.tokenNumber = responseJson["TokenNumber"].toString();
//       BluetoothPrintThermalDetails.discount =
//           responseJson["TotalDiscount_print"].toString();
//       BluetoothPrintThermalDetails.totalTax =
//           responseJson["TotalTax_print"].toString();
//       BluetoothPrintThermalDetails.grandTotal = responseJson["GrandTotal_print"].toString();
//       BluetoothPrintThermalDetails.qrCodeImage = responseJson["qr_image"];
//
//       BluetoothPrintThermalDetails.customerTaxNumber =
//           responseJson["TaxNo"].toString();
//       BluetoothPrintThermalDetails.ledgerName =
//           responseJson["LedgerName"] ?? '';
//       BluetoothPrintThermalDetails.customerAddress =
//       responseJson["Address1"];
//       BluetoothPrintThermalDetails.customerAddress2 =
//       responseJson["Address2"];
//       BluetoothPrintThermalDetails.customerCrNumber =
//           responseJson["CustomerCRNo"] ?? "";
//
//       var companyDetails = responseJson["CompanyDetails"];
//
//       BluetoothPrintThermalDetails.salesDetails = responseJson["SalesDetails"];
//       BluetoothPrintThermalDetails.companyName = companyDetails["CompanyName"] ?? '';
//       BluetoothPrintThermalDetails.buildingNumberCompany =
//           companyDetails["Address1"] ?? '';
//       BluetoothPrintThermalDetails.state =
//           companyDetails["StateName"] ?? '';
//       BluetoothPrintThermalDetails.postalCodeCompany =
//           companyDetails["PostalCode"] ?? '';
//       BluetoothPrintThermalDetails.phoneCompany =
//           companyDetails["Phone"] ?? '';
//       BluetoothPrintThermalDetails.mobileCompany =
//           companyDetails["Mobile"] ?? '';
//       BluetoothPrintThermalDetails.vatNumberCompany =
//           companyDetails["VATNumber"] ?? '';
//       BluetoothPrintThermalDetails.companyGstNumber =
//           companyDetails["GSTNumber"] ?? '';
//       BluetoothPrintThermalDetails.cRNumberCompany =
//           companyDetails["CRNumber"] ?? '';
//       // BluetoothPrintThermalDetails.descriptionCompany= companyDetails["Description"]?? '';
//       BluetoothPrintThermalDetails.countryNameCompany =
//           companyDetails["CountryName"] ?? '';
//       BluetoothPrintThermalDetails.stateNameCompany =
//           companyDetails["StateName"] ?? '';
//       BluetoothPrintThermalDetails.companyLogoCompany = companyDetails["CompanyLogo"] ?? '';
//       BluetoothPrintThermalDetails.countyCodeCompany = companyDetails["CountryCode"] ?? '';
//
//       return true;
//
//
//
//     } else if (status == 6001) {
//
//     }
//
//     //DB Error
//     else {
//
//
//     }
//
// //  }
//
//   }


  bool Check(String text) {
    print("ceck called");
    var val = false;
    bool both = true;
    if (text.contains(RegExp(r'[A-Z,a-z]'))) {
      for (int i = 0; i < text.length;) {
        int c = text.codeUnitAt(i);
        if (c >= 0x0600 && c <= 0x06FF || (c >= 0xFE70 && c <= 0xFEFF)) {
          both = false;
          return both;
        }
        else {
          both = true;
          return both;
        }
      }
    }
    else {
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
    if(tex ==""){

    }

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
          else value += "" + listSplit[i];
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
      print('Something went wrong set Stinrg ${e.toString()}');
      return e.toString();
    }
    return value;
  }

  returnBlankSpace(length){
    List<String> list = [];
    for (int i = 0; i < length; i++) {
      list.add('');

    }
    return list;
  }
  set(String str) {

    try{
      if(str ==""){

      }


      var listData = [];
      List<String> test = [];

      List<String> splitA = str.split('');
      test  = returnBlankSpace(splitA.length);


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
        if(isArabic(splitA[i])) {
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
        }
        else if (isEnglish(splitA[i])) {
          if (!ar) {
            if (listData[index] == null)
              listData[index] = splitA[i];
            else
              listData[index] += "" + splitA[i];
          }
          else {
            index++;
            listData[index] = splitA[i];
          }
          ar = false;
        }
        else if (isN(splitA[i])) {
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
    }


    catch(e){
      print("set function error ${e.toString()}");

    }

  }
  bool isArabic(String text) {
    if(text ==""){

    }

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
    if(text ==""){

    }

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
    if(value ==""){
      print("str is nll");
    }
    var val = false;
    val = double.tryParse(value) != null;
    return val;
  }

  getBytes(int id,value) {
    if(value ==""){

    }
    int datas = value.length;
    Uint8List va = Uint8List(2+datas);
    va[0] = id;
    va[1] = value.length;

    for (var i = 0; i < value.length; i++) {
      va[2+i]= value[i];
    }
    return va;
  }
  b64Qrcode(customer,vatNumber,dateTime,invoiceTotal,vatTotal){

    List<int> newList1 = [];
    var data = [utf8.encode(customer),utf8.encode(vatNumber),utf8.encode(dateTime),utf8.encode(invoiceTotal),utf8.encode(vatTotal)];
    print(data.runtimeType);
    for(var i = 0;i<data.length ;i++){
      List<int> dat = List.from(getBytes(i+1, data[i]));
      newList1 = newList1+dat;
    }

    var res = base64Encode(newList1);
    print(res);
    return res;

  }
/// new method


}
List<ProductDetailsModel> printDalesDetails = [];
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
    return  ProductDetailsModel(
      unitName: json['UnitName'],
      qty: json['quantityRounded'].toString(),
      netAmount: json['netAmountRounded'].toString(),
      productName: json['ProductName'],
      unitPrice: json['unitPriceRounded'].toString(),
      productDescription: json['ProductDescription'],
    );
  }
}

