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
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
class AppBlocsBT {
  List<BluetoothPrinter> _printers = [];
  late BluetoothPrinterManager _manager;

  scan(isCancelled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _printers = [];
    _printers = await BluetoothPrinterManager.discover();
    var paperSize = PaperSize.mm80;
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    var capabilities = prefs.getString("default_capabilities") ?? "default";

    var profile;
    if (capabilities == "default") {
      profile = await CapabilityProfile.load();
    } else {
      profile = await CapabilityProfile.load(name: capabilities);
    }
    var ip = "";
    if (PrintDataDetails.type == "SO") {
      ip = defaultOrderIP;
    } else {
      ip = defaultIp;
    }

    if (_printers.length == 0) {

      return 1;

      /// exit when no item connected
    } else {
      bool connected = false;
      int index = 0;

      for (var i = 0; i < _printers.length; i++) {
        if (_printers[i].address == ip) {
          index = i;
          connected = true;
          break;
        }
      }
      if (connected == true) {
        if (_printers[index].connected == true) {
        } else {
          var paperSize = PaperSize.mm80;
          var profile_mobile = await CapabilityProfile.load();

          var manager = BluetoothPrinterManager(_printers[index], paperSize, profile_mobile);
          await manager.connect();
          _printers[index].connected = true;
          _manager = manager;
        }

        if (_manager != null) {
          print("isConnected ${_manager.isConnected}");
          if (_manager.isConnected == false) {
            var manager = BluetoothPrinterManager(_printers[index], paperSize, profile);
            await manager.disconnect();
            return 3;
          } else {
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

  scanPrinter() async {
    // List<BluetoothPrinter> printerList = [];
    // printerList = await BluetoothPrinterManager.discover();
    // print("scan");
    // return printerList;
  }

  Future<void> kotPrint(printerAddress,profile,id, items, bool isCancelNote, isUpdate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userName = prefs.getString('user_name')??"";
    bool showUsernameKot = prefs.getBool('show_username_kot')??false;
    bool showDateTimeKot = prefs.getBool('show_date_time_kot')??false;
    var defaultCodePage = prefs.getString("default_code_page") ?? "CP864";
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
    bytes +=generator.setStyles(PosStyles(codeTable: defaultCodePage, align: PosAlign.center));

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
    bytes +=generator.setStyles( PosStyles(codeTable: defaultCodePage, align: PosAlign.left));
    bytes +=generator.textEncoded(typeArabic,
        styles:
        const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center, fontType: PosFontType.fontA, bold: true));
    bytes +=generator.text('', styles: const PosStyles(align: PosAlign.left));

    if (isCancelNote) {
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
    bytes +=generator.setStyles(  PosStyles(codeTable: defaultCodePage));
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


  }

  bluetoothPrintKOT(var id, rePrint, cancelOrder, isUpdate, isCancelled) async {
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
      "OrderID": id,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "BranchID": branchID,
      "is_test": false,
      "KitchenPrint": rePrint,
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
         // await kotPrint(printListData[i].ip, i, printListData[i].items,);
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
        printer += generator.imageRaster(resizedImage);
        //   printer.image(resizedImage);
      }
    }


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
    Uint8List dis = await CharsetConverter.encode("ISO-8859-6", setString('مجموع الضريبة'));
    Uint8List gt = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ الإجمالي'));

    Uint8List bl = await CharsetConverter.encode("ISO-8859-6", setString('الرصيد'));
    Uint8List cr = await CharsetConverter.encode("ISO-8859-6", setString('المبلغ المستلم'));
    Uint8List br = await CharsetConverter.encode("ISO-8859-6", setString('اتلقى البنك'));

    if (headerAlignment) {

      if (companyName != "") {
        printer += generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }
      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));

        printer += generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));

        //printer += generator.textEncoded(descriptionC, styles: PosStyles(height: PosTextSize.size2, width: PosTextSize.size1));
      }

      if (buildingDetails != "") {
        Uint8List buildingAddressEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));

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

      if (streetName != "") {
        Uint8List streetNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));

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

      // if (salesMan != "") {
      //   printer += generator.row([
      //     PosColumn(text: 'Sales man', width: 2, styles: const PosStyles(align: PosAlign.left)),
      //     PosColumn(text: '', width: 1, styles: const PosStyles(align: PosAlign.left)),
      //     PosColumn(
      //         textEncoded: salesManDetailsEnc,
      //         width: 9,
      //         styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      //   ]);
      //   //  printer += generator.textEncoded(companyPhoneEnc, styles: PosStyles(height: PosTextSize.size1, width: PosTextSize.size1));
      // }
    }
    else {
      if (companyName != "") {
        printer += generator.textEncoded(companyNameEnc,
            styles: const PosStyles(
                height: PosTextSize.size2, width: PosTextSize.size1, fontType: PosFontType.fontA, bold: true, align: PosAlign.center));
      }

      if (companySecondName != "") {
        Uint8List companySecondNameEncode = await CharsetConverter.encode("ISO-8859-6", setString(companySecondName));

        printer += generator.textEncoded(companySecondNameEncode,
            styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (buildingDetails != "") {
        Uint8List buildingDetailsEncode = await CharsetConverter.encode("ISO-8859-6", setString(buildingDetails));

        printer += generator.textEncoded(buildingDetailsEncode,
            styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
      }

      if (streetName != "") {
        Uint8List secondAddressEncode = await CharsetConverter.encode("ISO-8859-6", setString(streetName));

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

    printer += generator.emptyLines(1);
    printer += generator.textEncoded(invoiceTypeEnc, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, align: PosAlign.center));
    printer += generator.textEncoded(invoiceTypeArabicEnc, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size1, align: PosAlign.center));
    printer += generator.emptyLines(1);
    var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
    Uint8List tokenEnc = await CharsetConverter.encode("ISO-8859-6", setString('رمز'));
    Uint8List voucherNoEnc = await CharsetConverter.encode("ISO-8859-6", setString('رقم الفاتورة'));
    Uint8List dateEnc = await CharsetConverter.encode("ISO-8859-6", setString('تاريخ'));
    Uint8List customerEnc = await CharsetConverter.encode("ISO-8859-6", setString('اسم'));
    Uint8List typeEnc = await CharsetConverter.encode("ISO-8859-6", setString('يكتب'));
    // printer += generator.setStyles(PosStyles.defaults());


    if (highlightTokenNumber) {
      printer += generator.hr();
      printer += generator.text('Token No ', styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, bold: true, align: PosAlign.center));

      printer += generator.text(token, styles: const PosStyles(height: PosTextSize.size2, width: PosTextSize.size2, bold: true, align: PosAlign.center));
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
      PosColumn(text: 'Voucher No  ', width: 3, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: voucherNoEnc,
          width: 3,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: voucherNumber, width: 6, styles: const PosStyles(align: PosAlign.right)),
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
      Uint8List customerNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(customerName));

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
      Uint8List phoneNoEncoded = await CharsetConverter.encode("ISO-8859-6", setString(customerPhone));

      Uint8List phoneEnc = await CharsetConverter.encode("ISO-8859-6", setString('هاتف'));

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
      Uint8List tableEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

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
      Uint8List timeEnc = await CharsetConverter.encode("ISO-8859-6", setString('طاولة'));

      printer += generator.row([
        PosColumn(text: 'Time   ', width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(
            textEncoded: timeEnc, width: 3, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(text: timeInvoice, width: 6, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      ]);
    }

    printer += generator.hr();

    ///

    Uint8List slNoEnc = await CharsetConverter.encode("ISO-8859-6", setString("رقم"));
    Uint8List productNameEnc = await CharsetConverter.encode("ISO-8859-6", setString("أغراض"));
    Uint8List qtyEnc = await CharsetConverter.encode("ISO-8859-6", setString(" الكمية "));
    Uint8List rateEnc = await CharsetConverter.encode("ISO-8859-6", setString("معدل"));
    Uint8List netEnc = await CharsetConverter.encode("ISO-8859-6", setString("المجموع"));



    printer += generator.row([
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

    printer += generator.row([
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

    printer += generator.hr();

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var slNo = i + 1;

      Uint8List productName = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productName));

      printer += generator.row([
        PosColumn(
            text: "$slNo",
            width: 1,
            styles: const PosStyles(
              height: PosTextSize.size1,
            )),
        PosColumn(textEncoded: productName, width: 5, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1)),
        PosColumn(text: tableDataDetailsPrint[i].qty, width: 1, styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.center, bold: true)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].unitPrice),
            width: 2,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
        PosColumn(
            text: roundStringWith(tableDataDetailsPrint[i].netAmount),
            width: 3,
            styles: const PosStyles(height: PosTextSize.size1, align: PosAlign.right)),
      ]);

      var description = tableDataDetailsPrint[i].productDescription ?? '';
      if (description != "") {
        Uint8List description = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].productDescription));
        printer += generator.row([
          PosColumn(
              textEncoded: description,
              width: 7,
              styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
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
        if(flavourInOrderPrint){
          if(flavour!=""){
            Uint8List flavourNameEnc = await CharsetConverter.encode("ISO-8859-6", setString(tableDataDetailsPrint[i].flavourName));
            printer += generator.row([
              PosColumn(
                  textEncoded: flavourNameEnc,
                  width: 7,
                  styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.left)),
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



      printer += generator.hr();
    }
    printer += generator.emptyLines(1);
    printer += generator.row([
      PosColumn(text: 'Gross Amount', width: 4, styles: const PosStyles(fontType: PosFontType.fontB)),
      PosColumn(
          textEncoded: ga,
          width: 4,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(grossAmount), width: 4, styles: const PosStyles(align: PosAlign.right)),
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
          width: 4,
          styles: const PosStyles(fontType: PosFontType.fontA, height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.right)),
      PosColumn(text: roundStringWith(discount), width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);
    // printer += generator.setStyles(PosStyles.defaults());

    printer += generator.hr();
    printer += generator.row([
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

    ///
    if (qrCodeAvailable) {
      printer += generator.feed(1);
      var qrCode = await b64Qrcode(BluetoothPrintThermalDetails.companyName, BluetoothPrintThermalDetails.vatNumberCompany, isoDate,
          BluetoothPrintThermalDetails.grandTotal, BluetoothPrintThermalDetails.totalTax);
      printer += generator.qrcode(qrCode, size: QRSize.Size5);
    }
    // printer += generator.emptyLines(1);
    // printer += generator.text('Powered By Vikn Codes', styles: PosStyles(height: PosTextSize.size1, bold: true, width: PosTextSize.size1, align: PosAlign.center));

    printer += generator.cut();
    if (PrintDataDetails.type == "SI") {
      if (openDrawer) {
        printer += generator.drawer();
      }
    }

    return printer;
  }
}

class ESCBTTEST {



  List<int>? _bytes;

  List<int>? get bytes => _bytes;

  CapabilityProfile? _profile;

  ESCBTTEST();
//
  Future<List<int>> getBytes({
    PaperSize paperSize = PaperSize.mm80,
    required CapabilityProfile profile, String name = "default",
  }) async {

    List<int> printer = [];
    _profile = profile;
    final supportedCodePages = profile.codePages;
    Generator generator = Generator(PaperSize.mm80, _profile!);
    for(var ind = 0;ind<supportedCodePages.length ;ind++){
      printer += generator.setGlobalCodeTable(supportedCodePages[ind].name);
      var testData ="${supportedCodePages[ind].name} السلام ${profile.name} ";
      Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData));
      printer += generator.textEncoded(salam);
    }

    // printer += generator.text("Test Data",);
    // printer += generator.emptyLines(3);

    return printer;
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