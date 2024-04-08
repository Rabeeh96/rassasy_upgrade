import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:usb_esc_printer_windows/usb_esc_printer_windows.dart' as usb_esc_printer_windows;
import 'package:charset_converter/charset_converter.dart';

class TestPrintUSB extends StatefulWidget {
  const TestPrintUSB({super.key});

  @override
  State<TestPrintUSB> createState() => _TestPrintUSBState();
}

class _TestPrintUSBState extends State<TestPrintUSB> {
  final String _printerName = "EPSON";
  late Future<CapabilityProfile> _profile;

  @override
  initState() {
    _profile = CapabilityProfile.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fluter ESC/POS Printer Pakage For Windows Platform Only'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: printReq,
                  child: const Text("Demo Print"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> loadImageFromAssets(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  printReq() async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);
    bytes += generator.setGlobalCodeTable('CP864');

    Uint8List emptyData = await CharsetConverter.encode("ISO-8859-6", "");
    bytes += generator.textEncoded(emptyData);
    Uint8List salam = await CharsetConverter.encode("ISO-8859-6", 'السلام عليكم صباح الخير عزيزتي جميعاً');
    bytes += generator.textEncoded(salam);
    bytes += generator.cut();
    final res = await usb_esc_printer_windows.sendPrintRequest(bytes, "POS-80C");
    String msg = "";
    if (res == "success") {
      msg = "Printed Successfully";
    } else {
      msg = "Failed to generate a print please make sure to use the correct printer name";
    }

    print(msg);
  }
}