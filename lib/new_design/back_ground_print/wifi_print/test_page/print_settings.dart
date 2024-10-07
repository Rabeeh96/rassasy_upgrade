import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:charset_converter/charset_converter.dart';

// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

// import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/test_page/detailed_print_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'new_method.dart';

class PrintSettingsPage extends StatefulWidget {
  @override
  _PrintSettingsPageState createState() => _PrintSettingsPageState();
}

class _PrintSettingsPageState extends State<PrintSettingsPage> {
  @override
  void initState() {
    super.initState();
    loadDefault();
  }

  var temp = "";

  loadDefault() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp = prefs.getString('defaultIP') ?? '';
    temp = prefs.getString("template") ?? "template4";
    ipController.text = defaultIp;
    discover(context);
  }

  void executeAfterDelay() {
    Future.delayed(Duration(seconds: 3), () async {
      print("1");
      var data = await createInvoice();
      print("2");

      //    printHelperIP.print_demo(ipController.text, context, data);
      // Code to be executed after 3 seconds
      print("This code runs after a 3-second delay.");
    });
  }

  String localIp = '';
  List<String> devices = [];
  bool isDiscovering = false;
  int found = -1;
  TextEditingController portController = TextEditingController(text: '9100');
  TextEditingController ipController = TextEditingController();

  void discover(BuildContext ctx) async {
    if (ipController.text == "") {
      dialogBox(context, "Please enter ip address ");
    } else {
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

  String centerText(String text, int totalWidth) {
    int textLength = text.length;
    int spaces = (totalWidth - textLength) ~/ 2;
    return ' ' * spaces + text;
  }

  Future<void> testPrintOneByOne(capability, isArabic) async {
    int retryCount = 0;
    bool isConnected = false;
    var printerIp = ipController.text;
    int port = 9100;
    int timeoutDuration = 5;
    int maxRetries = 3;

    while (retryCount < maxRetries && !isConnected) {
      try {
        if (isArabic == false) {
          capability = "default";
        }

        var profile = await CapabilityProfile.load(name: capability);
        final supportedCodePages = profile.codePages;
        final printer = NetworkPrinter(PaperSize.mm80, profile);
        final res = await printer.connect(printerIp, port: port, timeout: Duration(seconds: timeoutDuration));
        if (res == PosPrintResult.success) {
          isConnected = true;
          var testData = "/";



          if (isArabic) {
            for (var ind = 0; ind < supportedCodePages.length; ind++) {
              var testData = "${supportedCodePages[ind].name} / السلام عليكم $capability ";
              printer.setStyles(PosStyles(codeTable: supportedCodePages[ind].name, align: PosAlign.right));
              printer.setStyles(PosStyles(codeTable: supportedCodePages[ind].name, align: PosAlign.left));
              printer.setStyles(PosStyles(codeTable: supportedCodePages[ind].name, align: PosAlign.left));
              Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData));
              printer.textEncoded(salam, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
            }

            /// cpmmented upi

            //           String companySecondName = "Your Company Name5565685689469846584968469861111545554";
            //           int totalWidth = 48; // Adjust based on your paper size and font
            //
            //           printer.text(centerText(companySecondName, totalWidth), styles: PosStyles(
            //             height: PosTextSize.size2,
            //             width: PosTextSize.size1,
            //             fontType: PosFontType.fontA,
            //             bold: true,
            //             align: PosAlign.center, // Align left since we manually centered the text
            //           ));
            //
            //           // Another example line
            //           String anotherLine = "Another centered line";
            //           printer..text(centerText(anotherLine, totalWidth), styles: PosStyles(
            //             height: PosTextSize.size1,
            //             width: PosTextSize.size1,
            //             fontType: PosFontType.fontA,
            //             bold: false,
            //             align: PosAlign.center, // Align left since we manually centered the text
            //           ));
            //
            // printer..text(centerText("anotherLine", totalWidth), styles: PosStyles(
            //             height: PosTextSize.size1,
            //             width: PosTextSize.size1,
            //             fontType: PosFontType.fontA,
            //             bold: false,
            //             align: PosAlign.center, // Align left since we manually centered the text
            //           ));

            // var upiID = "8714152075@ybl";
            // var name = "Rabeeh";
            // var amount = "1";
            // printer.qrcode("upi://pay?pa=$upiID&pn=$name&am=$amount&cu=INR",size:QRSize.Size8);
          } else {
            //   printer.text("Successfully printed test print");
          }

          printer.cut();
          printer.disconnect();
          print('Receipt printed successfully.');
        } else {
          print('Failed to connect: ${res.msg}');
        }
      } catch (e) {
        print('Error: $e');
      }

      if (!isConnected) {
        retryCount++;
        print('Retrying connection ($retryCount/$maxRetries)...');
        await Future.delayed(Duration(seconds: 2)); // Wait before retrying
      }
    }

    if (!isConnected) {
      print('Failed to connect to printer after $maxRetries attempts.');
    }
  }

  connectionTest(printerIp) async {
    const PaperSize paper = PaperSize.mm80;

    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    var port = int.parse(portController.text);
    final PosPrintResult res = await printer.connect(printerIp, port: port);

    if (res.msg == "Success") {
      discover(context);
    } else {
      discover(context);
    }
    printer.disconnect();
    return res.msg;
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    Directory directory = await Directory(appDocDirectory.path + '/' + 'dir').create(recursive: true);
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
    bool isTablet = enableTabDesign;
    return Scaffold(
      appBar: isTablet
          ? AppBar(
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: Text('Detailed print settings', style: TextStyle(color: Colors.white)),
                    //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
                    onPressed: () async {
                      Get.to(PrintSettingsDetailed());
                    }),
              ],
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
                'Print Test',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 23,
                ),
              ),
              backgroundColor: Colors.grey[300],
            )
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
                  fontSize: 18,
                ),
              ),
            ),
      body: isTablet ? tabPrintPage() : mobilePrintPage(),

      /// commented
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

          // print("1");
          // var data = await createInvoice();
          //  print("2  data $data");
          // final imageBytes = await _generateImageFromString(
          //   "textToPrint",
          //   TextAlign.center,
          // );
          //
          // print(imageBytes);
          //
          // Future.delayed(Duration(seconds: 2), () async {
          //   print("1");
          //   var data = await createInvoice();
          //   print("2");
          //
          printHelperIP.print_demo(ipController.text, context);
          //  // Code to be executed after 3 seconds
          //   print("This code runs after a 3-second delay.");
          // });

          // printHelperIP.print_demo(ipController.text, context,data);
          //
        }, // If button is disabled, onPressed is null
        child: const Icon(
          Icons.print,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<Uint8List> bitmapToBytes(ui.Image bitmap, bool gradient) async {
    bool isSizeEdit = false;
    int bitmapWidth = bitmap.width,
        bitmapHeight = bitmap.height,
        maxWidth = bitmapWidth, // Increase the maximum width if necessary
        maxHeight = bitmapHeight; // Increase the maximum height if necessary

    if (bitmapWidth > maxWidth) {
      bitmapHeight = ((bitmapHeight * maxWidth) / bitmapWidth).round();
      bitmapWidth = maxWidth;
      isSizeEdit = true;
    }
    if (bitmapHeight > maxHeight) {
      bitmapWidth = ((bitmapWidth * maxHeight) / bitmapHeight).round();
      bitmapHeight = maxHeight;
      isSizeEdit = true;
    }

    if (isSizeEdit) {
      bitmap = await resizeBitmap(bitmap, bitmapWidth, bitmapHeight);
    }

    return bitmapToBytesEscPos(bitmap, gradient);
  }

  Future<ui.Image> resizeBitmap(ui.Image bitmap, int targetWidth, int targetHeight) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final paint = Paint();
    final src = Rect.fromLTWH(0, 0, bitmap.width.toDouble(), bitmap.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble());

    canvas.drawImageRect(bitmap, src, dst, paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(targetWidth, targetHeight);
    return img;
  }

  Future<Uint8List> bitmapToBytesEscPos(ui.Image bitmap, bool gradient) async {
    // Assuming you have a method in EscPosPrinterCommands to handle the conversion.
    // Replace this with actual implementation.
    // For example:
    // return EscPosPrinterCommands.bitmapToBytes(bitmap, gradient);

    // Placeholder implementation for illustration
    final byteData = await bitmap.toByteData(format: ui.ImageByteFormat.rawRgba);
    return byteData!.buffer.asUint8List();
  }

  getCanvasImage(String str) async {
    var builder = ParagraphBuilder(ParagraphStyle(fontStyle: FontStyle.normal));
    builder.addText(str);
    Paragraph paragraph = builder.build();
    paragraph.layout(const ParagraphConstraints(width: 100));

    final recorder = PictureRecorder();
    var newCanvas = Canvas(recorder);

    newCanvas.drawParagraph(paragraph, Offset.zero);

    final picture = recorder.endRecording();
    var res = await picture.toImage(100, 100);
    ByteData? data = await res.toByteData(format: ImageByteFormat.png);
    Uint8List uint8list = data!.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    print(data.runtimeType);
    print(uint8list);
    return uint8list;
  }

  Future<Uint8List> _generateImageFromString(
    String text,
    ui.TextAlign align,
  ) async {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(
        recorder,
        Rect.fromCenter(
          center: Offset(0, 0),
          width: 550,
          height: 400, // cheated value, will will clip it later...
        ));
    TextSpan span = TextSpan(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: ui.FontWeight.bold,
      ),
      text: text,
    );
    TextPainter tp = TextPainter(text: span, maxLines: 3, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 550, maxWidth: 550);
    tp.paint(canvas, const Offset(0.0, 0.0));
    var picture = recorder.endRecording();
    final pngBytes = await picture.toImage(
      tp.size.width.toInt(),
      tp.size.height.toInt() - 2, // decrease padding
    );
    final byteData = await pngBytes.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  var printHelperIP = NewMethod();

  Widget tabPrintPage() {
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Container(height: 10, child: invoiceDesign()),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  height: 50,
                  color: Colors.white24,
                  child: TextField(
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: portController,
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
                        labelText: "Port",
                        labelStyle: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                        border: InputBorder.none,
                      )),
                ),
                const SizedBox(width: 40),
                Container(
                  width: 300,
                  height: 50,
                  color: Colors.white24,
                  child: TextField(
                      style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: ipController,
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
                        labelText: "IP",
                        labelStyle: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                        border: InputBorder.none,
                      )),
                ),
                const SizedBox(width: 20),
                found >= 0 ? Center(child: Text('Found: $found device(s)', style: TextStyle(fontSize: 16))) : Container(),
                SizedBox(width: 15),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: Text('Check availability', style: TextStyle(color: Colors.white)),
                    //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
                    onPressed: () async {
                      start(context);
                      var asd = await connectionTest(ipController.text);
                      stop();
                      popAlertWithColor(
                          head: "Alert",
                          message: asd.toString(),
                          backGroundColor: Colors.blueGrey,
                          forGroundColor: Colors.white,
                          position: SnackPosition.TOP);
                    }),
              ],
            ),
            const SizedBox(height: 25),
            temp == "template4"
                ? Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 6000, minHeight: 10),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Container(
                            child: ListView.builder(
                                padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 20),
                                shrinkWrap: true,
                                itemCount: printerModels.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      onTap: () async {
                                        testPrintOneByOne(printerModels[index], true);
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
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // Background color
                            ),
                            child: Text('    Test Print     ', style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              testPrintOneByOne("", false);
                            }),
                      ),
                    ],
                  ),
          ],
        );
      },
    );
  }

  /// new method
  GlobalKey _globalKey = GlobalKey();

  Future<Uint8List?> createInvoices() async {
    try {
      // Ensure the widget is built before accessing its context
      Completer<Uint8List?> completer = Completer();
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        try {
          RenderRepaintBoundary? boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
          if (boundary != null) {
            ui.Image image = await boundary.toImage(pixelRatio: 3.0);
            ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
            Uint8List pngBytes = byteData!.buffer.asUint8List();
            completer.complete(pngBytes);
          } else {
            completer.completeError('Render boundary is null');
          }
        } catch (e) {
          completer.completeError(e);
        }
      });

      return completer.future;
    } catch (e) {
      print(e.toString());
      throw e; // Handle or rethrow the error as needed
    }
  }

  createInvoice() async {
    try {
      GlobalKey _globalKeys = GlobalKey();

      RepaintBoundary(
        key: _globalKeys,
        child: Container(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Background color
              ),
              child: Text(' Test Print ', style: TextStyle(color: Colors.white)),
              onPressed: () async {}),
        ),
      );

      RenderRepaintBoundary boundary = _globalKeys.currentContext!.findRenderObject() as RenderRepaintBoundary;
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

                  DividerStyleNew(),
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

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Dismiss dialog on outside tap
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Container(
            height: double.infinity,
            width: double.infinity,
            child: invoiceDesign(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Printing on background'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget mobilePrintPage() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            dividerStyleFull(),
            // Container(height: 10, child: invoiceDesign()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth / 2.5,
                      child: TextField(
                        controller: portController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: 'Port',
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: screenWidth / 2.5,
                      child: TextField(
                        controller: ipController,
                        decoration: const InputDecoration(
                          labelText: 'Ip',
                          hintText: 'Ip',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(height: 8),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: Text('Check availability', style: TextStyle(color: Colors.white)),
                    //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
                    onPressed: () async {
                      start(context);
                      var asd = await connectionTest(ipController.text);
                      stop();
                      dialogBox(context, asd.toString());
                    }),
                SizedBox(height: 8),
              ],
            ),
            const SizedBox(height: 10),
            found >= 0 ? Text('Found: $found device(s)', style: TextStyle(fontSize: 16)) : Container(),
            Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 6000, minHeight: 10),
                child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 20),
                        shrinkWrap: true,
                        itemCount: printerModels.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () async {
                                testPrintOneByOne(printerModels[index], true);

                                // if (withCodePage) {
                                //
                                //   testPrint(ctx: context, capability: printerModels[index], codePage: code_page_controller.text);
                                // } else {
                                //   testPrint2(ctx: context, capability: printerModels[index], codePage: '');
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
                        })),
              ),
            ),
          ],
        );
      },
    );
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
      print("1 ---$tex");
      if (Check(tex)) {
        print("2 ---");
        beforeSplit = set(tex);
        print("3 ---");
        listSplit = beforeSplit.reversed.toList();
        print("4--- $listSplit");
      } else {
        listSplit = set(tex);
      }
      for (int i = 0; i < listSplit.length; i++) {
        if (listSplit[i] == null)
          value += "";
        else if (isArabic(listSplit[i])) {
          print("*isArabic${listSplit[i]} ---");
          if (value == "")
            value += listSplit[i];
          else
            value += "" + listSplit[i];
        } else if (isN(listSplit[i])) {
          print("*isN(listSplit[i])");
          if (value == "")
            value += listSplit[i].toString().split('').reversed.join();
          else
            value += "" + listSplit[i].toString().split('').reversed.join();
        } else {
          print("************value $value");
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
          print(splitA);
        }
        splitA = test;
      }

      listData.length = splitA.length;
      bool ar = false;
      int index = 0;

      for (int i = 0; i < splitA.length; i++) {
        if (isArabic(splitA[i])) {
          print("isAr  ");
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
        } else {
          if (listData[index] == null)
            listData[index] = splitA[i];
          else
            listData[index] += "" + splitA[i];
          ar = false;
        }
      }
      print("set listData error ${listData}");
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

  bool isSpecialCharacter(String character) {
    // Regular expression to check for special characters
    final RegExp specialCharRegExp = RegExp(r'[^a-zA-Z0-9]');

    // Check if the character matches the regular expression
    return specialCharRegExp.hasMatch(character);
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

  b64Qrcode(customer, vatNumber, dateTime, invoiceTotal, vatTotal) {
    List<int> newList1 = [];
    var data = [utf8.encode(customer), utf8.encode(vatNumber), utf8.encode(dateTime), utf8.encode(invoiceTotal), utf8.encode(vatTotal)];
    print(data.runtimeType);
    for (var i = 0; i < data.length; i++) {
      List<int> dat = List.from(getBytes(i + 1, data[i]));
      newList1 = newList1 + dat;
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

Widget DividerStyle() {
  // Color(0xffE8E8E8): Color(0xff1C3347)
  Color lightgrey = const Color(0xFFE8E8E8);
  Color grey = const Color(0xFFE8E8E8).withOpacity(.3);
//  themeChangeController.isDarkMode.value ? Color(0xffE8E8E8): Color(0xff1C3347)
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient: LinearGradient(
      colors: [
        grey, // Transparent color
        lightgrey, // Middle color
        grey, // Transparent color
      ],
      stops: [0.1, 0.4, 1.0],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    )),
  );
}

Widget DividerStyleNew() {
  return Container(
    height: 1,
    width: double.infinity,
    color: Colors.black,
  );
}
