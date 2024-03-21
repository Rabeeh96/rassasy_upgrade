import 'dart:typed_data';
// import 'package:esc_pos_printer/esc_pos_printer.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer_plus/esc_pos_printer_plus.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart';

Future<void> testReceiptImage(
    NetworkPrinter printer,  Uint8List theimageThatC) async {
  final Image? image = decodeImage(theimageThatC);
  printer.image(image! , align: PosAlign.center);

  // printer.imageRaster(image!,highDensityHorizontal: false,highDensityVertical: false);
  printer.cut();
}


Future<void> testReceiptText(
    NetworkPrinter printer,  text) async {

  printer.text("Test printer");
  printer.text("Test printer");
  printer.text("Test printer");
  printer.text("Test printer");
  // printer.imageRaster(image!,highDensityHorizontal: false,highDensityVertical: false);
  printer.cut();
}

