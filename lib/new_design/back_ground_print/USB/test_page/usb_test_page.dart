import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';

import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart'
    as usb_esc_printer_windows;
import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'detailed_print_settings.dart';
import 'package:flutter/material.dart' hide Image;
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'test_file.dart';


class TestPrintUSB extends StatefulWidget {
  const TestPrintUSB({super.key});

  @override
  State<TestPrintUSB> createState() => _TestPrintUSBState();
}

////
class _TestPrintUSBState extends State<TestPrintUSB> {
  TextEditingController controllerName = TextEditingController();

  @override
  initState() {
    super.initState();
    loadInitial();
  }

  var temp = "";

  loadInitial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp = prefs.getString('defaultIP') ?? '';
    temp = prefs.getString("template") ?? "template4";
    controllerName.text = defaultIp;
    print("1");


    Future.delayed(Duration(seconds: 1), () async{
     imageData = await createInvoice();
    });

    print("2");


  }
var imageData;
  List<String> printerModels = [
    "XP-N160I",
    "RP80USE",
    "POS-5890",
    "RP326",
    "ZKP8001",
    "TP806L",
    "TEP-200M",
  ];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    bool isTablet = screenWidth > defaultScreenWidth;
    return Scaffold(
        appBar: isTablet
            ? AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
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
                    ElevatedButton(
                        onPressed: () {
                          Get.to(TestPrintUSBDetailed());
                        },
                        child: Text("Detailed Test")),
                  ])
            : AppBar(
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ), //
                titleSpacing: 0,
                title: const Text(
                  'Detailed settings',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                actions: <Widget>[]),
        body: isTablet ? tabUsbPage() : mobileUsbPage(),
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {

          // InvoiceDesignWidget invoiceWidget = InvoiceDesignWidget();
          // await invoiceWidget.createInvoice();
          //
          //
          // if (invoiceWidget.pngBytes != null) {
          //   // Handle _pngBytes, such as saving to a file or sending over a network
          //   print('Generated invoice image size: ${invoiceWidget.pngBytes!.lengthInBytes} bytes');
          // } else {
          //   print('Failed to generate invoice image.');
          // }

          print("1");
         // var data = await createInvoice();
          print("2");

         //printHelperIP.printDetails(id: "7d31ae19-b311-4d39-8291-faee1e0030ee",type: "SO");
          //
        }, // If button is disabled, onPressed is null
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),



    );
  }
  var printHelperIP = USBPrintClassTest();
  Widget mobileUsbPage() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    bool isTablet = screenWidth > defaultScreenWidth;
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            dividerStyleFull(),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth / 1.1,
                  height: screenHeight / 14,
                  color: Colors.white24,
                  child: TextField(
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w400, 15.0),
                      readOnly: true,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: controllerName,
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
                        labelText: "Default printer",
                        labelStyle: customisedStyle(
                            context, Colors.black, FontWeight.normal, 14.0),
                        border: InputBorder.none,
                      )),
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 6000, minHeight: 10),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Container(
                      //  color: Colors.redAccent,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(
                              bottom: kFloatingActionButtonMargin + 20),
                          shrinkWrap: true,
                          itemCount: printerModels.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  testPrintOneByONe(controllerName.text,
                                      printerModels[index]);
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          printerModels[index],
                                          style: customisedStyle(
                                              context,
                                              Colors.black,
                                              FontWeight.w400,
                                              15.0),
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
          ],
        );
      },
    );
  }

  Widget tabUsbPage() {
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 40),

                Container(
                  width: 300,
                  height: 50,
                  color: Colors.white24,
                  child: TextField(
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w400, 15.0),
                      readOnly: true,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: controllerName,
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
                        labelText: "Default printer",
                        labelStyle: customisedStyle(
                            context, Colors.black, FontWeight.normal, 14.0),
                        border: InputBorder.none,
                      )),
                ),
                const SizedBox(width: 20),

                //  Text('Local ip: $localIp', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 20),
                temp != "template4"
                    ? ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor:Colors.green,foregroundColor: Colors.white),

                onPressed: () {
                          withoutCapabilitiesPrintReq(controllerName.text);
                        },
                        child: Text("Test Print"))
                    : Container(),
              ],
            ),
            const SizedBox(height: 25),
            temp == "template4"
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 6000, minHeight: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Container(
                            //  color: Colors.redAccent,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    bottom: kFloatingActionButtonMargin + 20),
                                shrinkWrap: true,
                                itemCount: printerModels.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () async {
                                        testPrintOneByONe(controllerName.text,
                                            printerModels[index]);
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                printerModels[index],
                                                style: customisedStyle(
                                                    context,
                                                    Colors.black,
                                                    FontWeight.w400,
                                                    15.0),
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
                  )
                : Container(),



          ],
        );
      },
    );
  }

  GlobalKey _globalKey = GlobalKey();

  createInvoice() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      print(e.toString());
    }
  }

  String date = "2024-07-02";
  var invoiceType = "Retail Invoice";
  var invoiceTypeArabic = "فاتورة بيع بالتجزئة";

  bool companyNameSwitch = true;
  bool imageQr = true;
  bool grossAmountSwitch = true;
  bool arabicText = true;
  bool companyDescriptionSwitch = true;
  bool companyLogoSwitch = true;
  bool companyVatNumberSwitch = true;
  bool companyCRNumberSwitch = true;
  bool companyAddressSwitch = true;
  bool companyPhoneSwitch = true;
  bool qrCodeSwitch = true;
  bool amountInWordsSwitch = true;
  bool discountSwitch = true;
  bool taxDetailsSwitch = true;
  bool customerVatSwitch = true;
  bool customerCRSwitch = true;
  bool customerPhoneNumberSwitch = true;
  bool printDetailHeadInArabic = true;
  bool invoiceTypeSwitch = true;
  bool productDescriptionSwitch = true;
  bool productUnitNameSwitch = true;
  bool textStyleSwitch = true;
  bool paper = true;
  bool cashBalanceSwitch = true;
  bool bankBalanceSwitch = true;
  String currencyShort = "SAR";
  String voucherNumber = "INV123456";
  String salesManName = "John Doe";
  String customerName = "Jane Smith";
  String customerVatNumber = "VAT123456789";
  String customerPhoneNumber = "+1234567890";
  String netTotal = "100.00";
  String grossAmount = "120.00";
  String discountAmount = "20.00";
  String totalQty = "10";
  String currencyCode = "USD";
  String totalVAT = "15.00";
  String grandTotal = "115.00";

  String bankAmount = "50.00";
  String cashAmount = "65.00";
  String currentBalance = "1000.00";
  String companyName = "ABC Corp.";
  String companyAddress1 = "123 Main Street";
  String companyAddress2 = "Suite 456";
  String companyCountry = "USA";
  String companyPhone = "+1987654321";
  String countyCodeCompany = "001";

  String buildingDetails = "Building 1";
  String streetName = "Elm Street";
  String companyDescription = "Leading provider of retail solutions.";
  String cityCompany = "Metropolis";
  String postalCodeCompany = "12345";

  String mobileCompany = "+1234567890";
  String vatNumberCompany = "COMPANYVAT123";
  String companyGstNumber = "GST123456";
  String cRNumberCompany = "CR123456";
  String descriptionCompany = "Company description goes here.";
  String countryNameCompany = "United States";
  String stateNameCompany = "California";
  String companyLogoCompany = "logo.png";
  String qrCode = "QRCode.png";
  bool isB2b = true;

  Widget invoiceDesign() {
    return ListView(
      children: <Widget>[
        RepaintBoundary(
          key: _globalKey,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // companyLogoSwitch
                  //     ? companyLogoCompany != ""
                  //         ? Padding(
                  //             padding: const EdgeInsets.only(bottom: 8.0),
                  //             child: Container(
                  //               height: MediaQuery.of(context).size.height * .10,
                  //               // decoration: BoxDecoration(
                  //               //   border: Border.all(color: Colors.black),
                  //               //   shape: BoxShape.circle,
                  //               // ),
                  //               child: Center(child: CircleAvatar(backgroundColor: Colors.blue, backgroundImage: NetworkImage(companyLogoCompany))),
                  //             ),
                  //           )
                  //         : Container()
                  //     : Container(),

                  companyNameSwitch
                      ? Text(
                    companyName,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 25.0),
                    textAlign: TextAlign.left,
                  )
                      : Container(),
                  companyDescriptionSwitch
                      ? companyDescription != ''
                      ? Text(
                    companyDescription,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 22.0),
                    textAlign: TextAlign.left,
                  )
                      : Container()
                      : Container(),

                  buildingDetails != ''
                      ? Text(
                    buildingDetails,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 20.0),
                    textAlign: TextAlign.left,
                  )
                      : Container(),
                  companyPhoneSwitch
                      ? companyPhone != ''
                      ? Text(
                    companyPhone,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 20.0),
                    textAlign: TextAlign.left,
                  )
                      : Container()
                      : Container(),

                  streetName != ''
                      ? Text(
                    streetName,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 18.0),
                    textAlign: TextAlign.left,
                  )
                      : Container(),

                  companyVatNumberSwitch
                      ? vatNumberCompany != ""
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "Tax No:",
                                style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                vatNumberCompany,
                                style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 14.0),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          " : لا تفرض ضرائب",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 14.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container()
                      : Container(),

                  companyCRNumberSwitch
                      ? cRNumberCompany != ""
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "CR No:",
                                style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 14.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                cRNumberCompany,
                                style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 14.0),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          " :س. ت",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 14.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container()
                      : Container(),
                  invoiceTypeSwitch
                      ? Text(
                    invoiceType,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 22.0),
                    textAlign: TextAlign.left,
                  )
                      : Container(),

                  Text(
                    invoiceTypeArabic,
                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 22.0),
                    textAlign: TextAlign.left,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date :",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 15.0),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            date,
                            style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 15.0),
                          ),
                        ),
                        Text(
                          ": تاريخ ",

                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Invoice No :",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 15.0),
                          textAlign: TextAlign.left,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            voucherNumber,
                            style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 15.0),
                          ),
                        ),
                        Text(
                          ": رقم الفاتورة",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  dividerStyle(),
                  SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Text(
                                "Customer Name :",
                                // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 15.5),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Text(
                              customerName,
                              style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 15.5),
                            ),
                          ],
                        ),
                        Text(
                          ": اسم الزبون",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  customerVatSwitch
                      ? customerVatNumber != ""
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Row(
                                children: [
                                  Text(
                                    "VAT  No ",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(
                                        context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 15.0),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 56.0),
                                    child: Text(
                                      ":",
                                      // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                      style: customisedStyle(
                                          context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 15.0),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              customerVatNumber,
                              style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 15.0),
                            ),
                          ],
                        ),
                        Text(
                          ":ظريبه الشراءا ",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container()
                      : Container(),

                  customerPhoneNumberSwitch
                      ? customerPhoneNumber != ""
                      ? Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Row(
                                children: [
                                  Text(
                                    "Phone  No ",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(
                                        context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 15.0),
                                    textAlign: TextAlign.left,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Text(
                                      ":",
                                      // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                      style: customisedStyle(
                                          context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 15.0),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              customerPhoneNumber,
                              style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.normal, 15.0),
                            ),
                          ],
                        ),
                        Text(
                          ": رقم الهاتف",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container()
                      : Container(),
                  DividerStyleNew(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Product Details",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Qty",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Rate",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Total",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "تفاصيل المنتج",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w800, 16.5),
                              textAlign: TextAlign.left,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "الكمية",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w800, 16.5),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "معدل",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w800, 16.5),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "المجموع",
                                    // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                    style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w800, 16.5),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  DividerStyleNew(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Container(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 30000, minHeight: 10.0),
                          child: Container(
                            decoration: const BoxDecoration(),
                            child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 4,
                              // itemCount: billWiseData.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 3.0, bottom: 3),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Demo Product",
                                            // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                            style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 15.0),
                                            textAlign: TextAlign.left,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width * .45,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  roundStringWith("12"),
                                                  // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                                  style: customisedStyle(
                                                      context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 16.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  roundStringWith("250"),
                                                  // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                                  style: customisedStyle(
                                                      context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  roundStringWith("695"),
                                                  // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                                  style: customisedStyle(
                                                      context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w700 : FontWeight.w500, 15.0),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Description",
                                            // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                                            style: customisedStyle(context, Colors.black, textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => DividerStyleNew(),
                            ),
                          )),
                    ),
                  ),
                  DividerStyleNew(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Net Total - صافي المجموع :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(netTotal)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Discount Amt - مبلغ الخصم :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(discountAmount)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w800 : FontWeight.w600, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Total VAT - إجمالي ضريبة :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, const Color(0xff5A5A5A), FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(totalVAT)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  DividerStyleNew(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Grand Total - المجموع الإجمالي :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style: customisedStyle(context, const Color(0xff000000), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 18.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(grandTotal)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff000000), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 18.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  DividerStyleNew(),
                  bankBalanceSwitch
                      ? Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Bank Amount - مبلغ البنك :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style:
                              customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(bankAmount)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container(),
                  cashBalanceSwitch
                      ? Padding(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Cash Amount - مبلغ نقدي :",
                              // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                              style:
                              customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Text(
                          "${roundStringWith(cashAmount)} $currencyShort",
                          // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                          style: customisedStyle(context, const Color(0xff5A5A5A), textStyleSwitch ? FontWeight.w900 : FontWeight.w700, 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                      : Container(),


                  DividerStyleNew()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  testPrintOneByONe(driverName, capability) async {
    List<int> bytes = [];
    print("driverName  $driverName capability  $capability");
    var profile = await CapabilityProfile.load(name: capability);

    final supportedCodePages = profile.codePages;
    final generator = Generator(PaperSize.mm80, profile);

    print(supportedCodePages.length);

    for (var ind = 0; ind < supportedCodePages.length; ind++) {
      bytes += generator.setGlobalCodeTable(supportedCodePages[ind].name);
      var testData =
          "${supportedCodePages[ind].name} السلام عليكم $capability ";
      Uint8List salam =
          await CharsetConverter.encode("ISO-8859-6", setString(testData));
      bytes += generator.textEncoded(salam);
    }

    final res = await usb_esc_printer_windows.sendPrintRequest(
      bytes,
      driverName,
    );

    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg =
          "Failed to generate a print please make sure to use the correct printer name";
    }
  }

  withoutCapabilitiesPrintReq(driverName) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.cut();
    final res =
        await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg =
          "Failed to generate a print please make sure to use the correct printer name";
    }

    popAlert(head: "Alert", message: msg ?? "", position: SnackPosition.TOP);
  }

  returnBlankSpace(length) {
    List<String> list = [];
    for (int i = 0; i < length; i++) {
      list.add('');
    }
    return list;
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
}

Widget DividerStyleNew() {
  return Container(
    height: 1,
    width: double.infinity,
    color: Colors.black,
  );
}
