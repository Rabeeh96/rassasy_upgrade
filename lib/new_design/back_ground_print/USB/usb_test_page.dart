import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/back_ground_print/print_details/select_codepage.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;
import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
class TestPrintUSB extends StatefulWidget {
  const TestPrintUSB({super.key});

  @override
  State<TestPrintUSB> createState() => _TestPrintUSBState();
}
////
class _TestPrintUSBState extends State<TestPrintUSB> {
  TextEditingController controllerName = TextEditingController();
  final String _printerName = "EPSON";
  late Future<CapabilityProfile> _profile;
  @override
  initState() {
    super.initState();
    loadInitial();
  }

  loadInitial()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String defaultIp =  prefs.getString('defaultIP')??'';
    controllerName.text = defaultIp;
    _profile = CapabilityProfile.load();


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
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar:  AppBar(
  //         leading: IconButton(
  //           icon: const Icon(Icons.arrow_back,color: Colors.black,),
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ), //
  //         title: const Text(
  //           'Print settings',
  //           style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //             fontSize: 23,
  //           ),
  //         ),
  //         backgroundColor: Colors.grey[300],
  //     ),
  //     body: Center(
  //       child: Container(
  //         color: Colors.white,
  //         height: 250,
  // //        width: 300,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               width: MediaQuery.of(context).size.width/5,
  //               child: TextField(
  //                 textCapitalization: TextCapitalization.words,
  //                 controller: controllerName,
  //                 style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
  //                 keyboardType: TextInputType.text,
  //                 decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'Enter Driver Address'),
  //               ),
  //             ),const SizedBox(
  //               width: 20,
  //             ),
  //
  //             Container(
  //
  //               child: ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.cyan, // Background color
  //                   ),
  //                   child: Text(
  //                       'Check Test page',style: customisedStyle(context, Colors.white, FontWeight.w400, 15.0)),
  //                   //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
  //                   onPressed:()async{
  //
  //                     var dat = "";
  //                     if(controllerName.text !=""){
  //                       dat=controllerName.text;
  //                       print("ajshkagdkagdkdgka   $dat");
  //                       printReq(dat);
  //                     }
  //                     else{
  //                       dialogBox(context, "Please enter driver details");
  //                     }
  //
  //
  //                   }
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //       ),
  //     ),
  //
  //
  //
  //   );
  // }

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

              Row(
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
                  const SizedBox(width: 20),

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




                                    if (withCodePage) {
                                      printReq(controllerName.text,printerModels[index]);
                                     // testPrint(ctx: context, capability: printerModels[index], codePage: code_page_controller.text);
                                    } else {
                                      withoutCapabilitiesPrintReq(controllerName.text,printerModels[index]);
                                     // testPrint2(ctx: context, capability: printerModels[index], codePage: '');
                                    }

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

  printReq(driverName,capabilities) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: capabilities);
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable(code_page_controller.text);


    Uint8List salam = await CharsetConverter.encode("ISO-8859-6", 'السلام عليكم صباح الخير عزيزتي جميعاً');
    bytes += generator.textEncoded(salam);
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

    popAlert(head: "Waring", message: msg ?? "", position: SnackPosition.TOP);
  }
  withoutCapabilitiesPrintReq(driverName,capabilities) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.text("Test page data");
    bytes += generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, driverName);
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

    popAlert(head: "Waring", message: msg ?? "", position: SnackPosition.TOP);


  }
}