import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/models/bluetooth_printer.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/select_codepage.dart';

import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/pos_printer_manager.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/services/bluetooth_printer_manager.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart' hide Image;
class TestPrintBT extends StatefulWidget {
  const TestPrintBT({super.key});

  @override
  State<TestPrintBT> createState() => _TestPrintBTState();
}
////
class _TestPrintBTState extends State<TestPrintBT> {
  TextEditingController controllerName = TextEditingController();


  @override
  initState() {
    super.initState();
    loadInitial();
  }

  loadInitial()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp =  prefs.getString('defaultIP')??'';
    controllerName.text = defaultIp;


  }
  TextEditingController code_page_controller = TextEditingController()..text = "CP864";

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

  bool withCodePage = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

            ElevatedButton(onPressed: (){

             // testPrintAllCodePage(controllerName.text);
            }, child: Text("Demo")),

            ElevatedButton(
                onPressed: () {
                  setState(() {
                    withCodePage = !withCodePage;
                    print(withCodePage);
                  });
                },
                child: Text(
                  withCodePage?"With Codepage":"Without code page",
                  style: TextStyle(color: withCodePage ? Colors.red : Colors.black),
                )),
          ]),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              const SizedBox(height: 50),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const SizedBox(width: 40),

                  Container(
                    width: 300,
                    height: 50,
                    color: Colors.white24,
                    child: TextField(
                        style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),

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
                          labelStyle: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                          border: InputBorder.none,
                        )),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: 300,
                    height: 50,
                    color: Colors.white24,
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



                ],
              ),

              const SizedBox(height: 25),


              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(onPressed: (){
              //       var bluetoothHelper = AppBlocsBTEST();
              //       bluetoothHelper.scanAndPrint("Sunmi-V2","1");
              //     }, child: Text("Option 1",style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),)),
              //
              //     Padding(
              //       padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              //       child: ElevatedButton(onPressed: (){
              //
              //         var bluetoothHelper = AppBlocsBTEST();
              //         bluetoothHelper.scanAndPrint("Sunmi-V2","2");
              //       }, child: Text("Option 2",style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),)),
              //     ),
              //
              //     Padding(
              //       padding: const EdgeInsets.only(left: 20.0,right: 20.0),
              //       child: ElevatedButton(onPressed: (){
              //         var bluetoothHelper = AppBlocsBTEST();
              //         bluetoothHelper.scanAndPrint("Sunmi-V2","3");
              //       }, child: Text("Option 3",style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),)),
              //     ),
              //
              //      ElevatedButton(onPressed: (){
              //       var bluetoothHelper = AppBlocsBTEST();
              //       bluetoothHelper.scanAndPrint("Sunmi-V2","4");
              //     }, child: Text("Option 4",style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),)),
              //
              //
              //   ],
              // ),


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
                                    //scanAndPrint();


                                    print(printerModels[index]);
                                    var bluetoothHelper = AppBlocsBTEST();
                                    bluetoothHelper.scanAndPrint(printerModels[index],"6");

                                    // if (withCodePage) {
                                    //   testPrintOneByONe(controllerName.text,printerModels[index]);
                                    // } else {
                                    //   withoutCapabilitiesPrintReq(controllerName.text,printerModels[index]);
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

            ],
          );
        },
      ),
    );
  }



  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }
  List<BluetoothPrinter> _printers = [];
  late BluetoothPrinterManager _manager;



  // Future<void> scanAndPrint() async {
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     setState(() {
  //       _printers = [];
  //     });
  //
  //
  //
  //     // Discover printers
  //     _printers = await BluetoothPrinterManager.discover();
  //     if (_printers.isEmpty) {
  //       print('No printers found');
  //       return;
  //     }
  //
  //     var paperSize = PaperSize.mm80;
  //     var defaultIp = prefs.getString('defaultIP') ?? '';
  //     var capabilities = prefs.getString("default_capabilities") ?? "default";
  //
  //     var profile = capabilities == "default"
  //         ? await CapabilityProfile.load()
  //         : await CapabilityProfile.load(name: capabilities);
  //
  //     // Find the default printer
  //     var printer = _printers.firstWhere(
  //           (printer) => printer.address == defaultIp,
  //
  //     );
  //
  //     if (printer == null) {
  //       print('Default printer is not paired with your device');
  //       return;
  //     }
  //
  //     // Initialize manager if needed
  //     if (_manager == null || _manager.printer.address != printer.address) {
  //       _manager = BluetoothPrinterManager(printer, paperSize, profile);
  //     }
  //
  //     // Connect if not connected
  //     if (!_manager.isConnected) {
  //       print('Connecting to printer...');
  //       await _manager.connect();
  //       await Future.delayed(Duration(seconds: 2)); // Wait a bit for connection to stabilize
  //       print('Connected to printer: ${_manager.isConnected}');
  //     }
  //
  //     // Check connection status again
  //     if (!_manager.isConnected) {
  //       print('Failed to connect to the printer');
  //       return;
  //     }
  //
  //     // Send print data
  //     var service = ESCBTTEST();
  //     var data = await service.getBytes(paperSize: paperSize, profile: profil,option: "");
  //     _manager.writeBytes(data, isDisconnect: true);
  //     print('Print successful');
  //
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }




  // printReq(driverName,capabilities) async {
  //   List<int> bytes = [];
  //
  //   final profile = await CapabilityProfile.load(name: capabilities);
  //   // PaperSize.mm80 or PaperSize.mm58
  //   final generator = Generator(PaperSize.mm80, profile);
  //   bytes += generator.setGlobalCodeTable(code_page_controller.text);
  //
  //
  //   Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString('السلام عليكم صباح الخير عزيزتي جميعاً'));
  //   bytes += generator.textEncoded(salam);
  //
  //   bytes += generator.text("Test page data");
  //   bytes += generator.text("Test page data");
  //   bytes += generator.text("with code page ${code_page_controller.text}  capabilities ${capabilities}  ");
  //   bytes += generator.text("Test page data");
  //   bytes += generator.text("Test page data");
  //   bytes += generator.cut();
  //   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
  //   String msg = "";
  //   if (res == "success") {
  //     msg = "Printed Successfully";
  //   } else {
  //     msg = "Failed to generate a print please make sure to use the correct printer name";
  //   }
  //
  //   popAlert(head: "Waring", message: msg ?? "", position: SnackPosition.TOP);
  // }
  //
  //
  // testPrintAllCodePage(driverName) async {
  //
  //   List<int> bytes = [];
  //
  //
  //   var result = await CapabilityProfile.getAvailableProfiles();
  //   for(var i = 0;i<result.length ;i++){
  //     var profile = await CapabilityProfile.load(name: result[i]["key"]);
  //     final generator = Generator(PaperSize.mm80, profile);
  //     final supportedCodePages = profile.codePages;
  //
  //     var capability = result[i]["key"];
  //     for(var ind = 0;ind<supportedCodePages.length ;ind++){
  //       bytes += generator.setGlobalCodeTable(supportedCodePages[ind].name);
  //       var testData ="${supportedCodePages[ind].name} السلام $capability ";
  //       Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData));
  //       bytes += generator.textEncoded(salam);
  //       //  popAlert(head: "Waring", message: msg ?? "", position: SnackPosition.TOP);
  //     }
  //   }
  //
  //   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName,);
  //   String msg = "";
  //   if (res == "success") {
  //     msg = "Printed Successfully";
  //   } else {
  //     msg = "Failed to generate a print please make sure to use the correct printer name";
  //   }
  //
  //
  //   // PaperSize.mm80 or PaperSize.mm58
  //   // final generator = Generator(PaperSize.mm80, profile);
  //   // bytes += generator.setGlobalCodeTable(code_page_controller.text);
  //   //
  //   //
  //   // Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString('السلام عليكم صباح الخير عزيزتي جميعاً'));
  //   // bytes += generator.textEncoded(salam);
  //   //
  //   // bytes += generator.text("Test page data");
  //   // bytes += generator.text("Test page data");
  //   // bytes += generator.text("with code page ${code_page_controller.text}  capabilities ${capabilities}  ");
  //   // bytes += generator.text("Test page data");
  //   // bytes += generator.text("Test page data");
  //   // bytes += generator.cut();
  //   // final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
  //   // String msg = "";
  //   // if (res == "success") {
  //   //   msg = "Printed Successfully";
  //   // } else {
  //   //   msg = "Failed to generate a print please make sure to use the correct printer name";
  //   // }
  //
  // }
  //
  // testPrintOneByONe(driverName,capability) async {
  //
  //   List<int> bytes = [];
  //   print("driverName  $driverName capability  $capability");
  //   var profile = await CapabilityProfile.load(name:capability);
  //
  //   final supportedCodePages = profile.codePages;
  //   final generator = Generator(PaperSize.mm80, profile);
  //
  //   print(supportedCodePages.length);
  //
  //   for(var ind = 0;ind<supportedCodePages.length ;ind++){
  //     print("$ind");
  //     bytes += generator.setGlobalCodeTable(supportedCodePages[ind].name);
  //     var testData ="${supportedCodePages[ind].name} السلام $capability ";
  //     Uint8List salam = await CharsetConverter.encode("ISO-8859-6", setString(testData));
  //     bytes += generator.textEncoded(salam);
  //
  //   }
  //
  //
  //
  //   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName,);
  //
  //   String msg = "";
  //   if (res == "success") {
  //     msg = "Printed Successfully";
  //   } else {
  //     msg = "Failed to generate a print please make sure to use the correct printer name";
  //   }
  //
  // }
  //
  //
  // withoutCapabilitiesPrintReq(driverName,capabilities) async {
  //   List<int> bytes = [];
  //
  //   final profile = await CapabilityProfile.load();
  //   // PaperSize.mm80 or PaperSize.mm58
  //   final generator = Generator(PaperSize.mm80, profile);
  //   bytes += generator.text("Test page data");
  //   bytes += generator.cut();
  //   final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
  //   String msg = "";
  //   if (res == "success") {
  //     msg = "Printed Successfully";
  //   } else {
  //     msg = "Failed to generate a print please make sure to use the correct printer name";
  //   }
  //
  //   popAlert(head: "Waring", message: msg ?? "", position: SnackPosition.TOP);
  //
  //
  // }

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


class AppBlocsBTEST{
  List<BluetoothPrinter> _printers = [];
  late BluetoothPrinterManager _manager;
  void scanAndPrint(capabilities,option) async {
    try {
      print("---------------------1");


      SharedPreferences prefs = await SharedPreferences.getInstance();
      _printers = [];
      print("---------------------2");

      // Discover printers
      _printers = await BluetoothPrinterManager.discover();
      if (_printers.isEmpty) {
        // 'No printers found';
        popAlert(head: "Alert", message: "No Bluetooth device found, Check your Bluetooth connection", position:  SnackPosition.TOP);
        return;
      }

      var paperSize = PaperSize.mm80;
      var defaultIp = prefs.getString('defaultIP') ?? '';


      var profile = await CapabilityProfile.load(name: capabilities);

      print("---------------------13");


      // Find the default printer
      var printer = _printers.firstWhere((printer) => printer.address == defaultIp);

      if (printer == null) {
        print('Default printer is not paired with your device');
        return;
      }
      print("---------------------4");
      // Initialize manager if needed

      _manager = BluetoothPrinterManager(printer, paperSize, profile);
      if (_manager == null || _manager.printer.address != printer.address) {
        _manager = BluetoothPrinterManager(printer, paperSize, profile);
      }


      // Connect if not connected
      if (!_manager.isConnected) {
        print('Connecting to printer...');
        await _manager.connect();
        print('Connected to printer: ${_manager.isConnected}');
      }
      print("---------------------5");
      // Check connection status again

      print("---------------------6");
      // Send print data
      var service = ESCBTTEST();
      var data = await service.getBytes(paperSize: paperSize, profile: profile,option: option);
      _manager.writeBytes(data, isDisconnect: true);
      print('Print successful');

    } catch (e) {
      print('Error: $e');
    }
  }

}