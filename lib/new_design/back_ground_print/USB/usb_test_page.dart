import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;
import 'package:charset_converter/charset_converter.dart';
import 'package:shared_preferences/shared_preferences.dart';
class TestPrintUSB extends StatefulWidget {
  const TestPrintUSB({super.key});

  @override
  State<TestPrintUSB> createState() => _TestPrintUSBState();
}
//
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
            'Print settings',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[300],
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          height: 250,
  //        width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width/5,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: controllerName,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'Enter Driver Address'),
                ),
              ),const SizedBox(
                width: 20,
              ),

              Container(

                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan, // Background color
                    ),
                    child: Text(
                        'Check Test page',style: customisedStyle(context, Colors.white, FontWeight.w400, 15.0)),
                    //  onPressed: connectionTesting ? null : () => connectionTest(ipController.text)
                    onPressed:()async{

                      var dat = "";
                      if(controllerName.text !=""){
                        dat=controllerName.text;
                        print("ajshkagdkagdkdgka   $dat");
                        printReq(dat);
                      }
                      else{
                        dialogBox(context, "Please enter driver details");
                      }


                    }
                ),
              ),

            ],
          ),
        ),
      ),



    );
  }

  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  printReq(driverName) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP864');


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

    print(msg);
  }
}