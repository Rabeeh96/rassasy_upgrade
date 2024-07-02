import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/select_codepage.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart'
    as usb_esc_printer_windows;
import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'detailed_print_settings.dart';

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
        body: isTablet ? tabUsbPage() : mobileUsbPage());
  }

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
