import 'dart:convert';
import 'dart:io';

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

import '../select_codepage.dart';

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

  Future<void> testPrintOneByOne(capability,isArabic) async {
    int retryCount = 0;
    bool isConnected = false;
    var printerIp = ipController.text;
    int port = 9100;
    int timeoutDuration = 5;
    int maxRetries = 3;

    while (retryCount < maxRetries && !isConnected) {
      try {

        print("capability $capability");
        if(isArabic ==false){
          capability =  "default";
        }

        print("capability $capability");
        var profile = await CapabilityProfile.load(name: capability);
        final supportedCodePages = profile.codePages;
        final printer = NetworkPrinter(PaperSize.mm80, profile);
        final res = await printer.connect(printerIp, port: port, timeout: Duration(seconds: timeoutDuration));
        if (res == PosPrintResult.success) {
          isConnected = true;

          if(isArabic){
            for (var ind = 0; ind < supportedCodePages.length; ind++) {
              var testData = "${supportedCodePages[ind].name} السلام عليكم $capability ";
              printer.setStyles(PosStyles(codeTable: supportedCodePages[ind].name, align: PosAlign.center));
              Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData));
              printer.textEncoded(salam, styles: const PosStyles(height: PosTextSize.size1, width: PosTextSize.size1, align: PosAlign.center));
            }

            /// cpmmented upi

            // var upiID = "8714152075@ybl";
            // var name = "Rabeeh";
            // var amount = "1";
            // printer.qrcode("upi://pay?pa=$upiID&pn=$name&am=$amount&cu=INR",size:QRSize.Size8);
          }
          else{
            printer.text("Successfully printed test print");
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

  // connectionReconnect(printerIp)async{
  //   const PaperSize paper = PaperSize.mm80;
  //
  //   final profile_mobile = await CapabilityProfile.load();
  //   final printer = NetworkPrinter(paper, profile_mobile);
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
    bool isTablet = screenWidth > defaultScreenWidth;
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
        body: isTablet ? tabPrintPage() : mobilePrintPage());
  }

  Widget tabPrintPage() {
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
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
                                        testPrintOneByOne(printerModels[index],true);
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
                              testPrintOneByOne("",false);
                            }),
                      ),
                  ],
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
    bool isTablet = screenWidth > defaultScreenWidth;
    return Builder(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            dividerStyleFull(),

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
                                testPrintOneByOne(printerModels[index],true);

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
