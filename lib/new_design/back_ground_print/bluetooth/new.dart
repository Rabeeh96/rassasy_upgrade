import 'package:flutter/cupertino.dart';

import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/Print/qr_generator.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/models/bluetooth_printer.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/pos_printer_manager.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/services/bluetooth_printer_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothHelperNew {
  List<BluetoothPrinter> _printers = [];
  BluetoothPrinterManager? _manager;
  late SharedPreferences prefs;
  late CapabilityProfile profile;
  PaperSize paperSize = PaperSize.mm80;

  BluetoothHelperNew() {
    _init();
  }

  Future<void> _init() async {
    prefs = await SharedPreferences.getInstance();
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    var capabilities = prefs.getString("default_capabilities") ?? "default";
    profile = await CapabilityProfile.load(name: capabilities);
  }

  Future<int> scan() async {
    _printers = await BluetoothPrinterManager.discover();
    String ip = _getPrinterIp();

    if (_printers.isEmpty) {
      print("Switch on bluetooth");
      return 1;
    }

    var printer = _findPrinterByIp(ip);
    if (printer == null) {
      print('default printer is not paired with your device');
      return 2;
    }

    await _connectToPrinter(printer);
    if (_manager?.isConnected == false) {
      await _disconnectPrinter();
      return 3;
    }

    await _printData();
    return 4;
  }

  String _getPrinterIp() {
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    return (PrintDataDetails.type == "SO") ? defaultOrderIP : defaultIp;
  }

  BluetoothPrinter? _findPrinterByIp(String ip) {
    return _printers.firstWhere((printer) => printer.address == ip,
    );
  }

  Future<void> _connectToPrinter(BluetoothPrinter printer) async {
    _manager = BluetoothPrinterManager(printer, paperSize, profile);
    await _manager?.connect();
    printer.connected = true;
  }

  Future<void> _disconnectPrinter() async {
    await _manager?.disconnect();
  }

  Future<void> _printData() async {
    var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
    var qrCode = await b64Qrcode(
      BluetoothPrintThermalDetails.companyName,
      BluetoothPrintThermalDetails.vatNumberCompany,
      isoDate,
      BluetoothPrintThermalDetails.grandTotal,
      BluetoothPrintThermalDetails.totalTax,
    );

    var service = ESCPrinterServicesArabic(qrCode, prefs, paperSize,false);
    var data = await service.getBytes(paperSize: paperSize, profile: profile);
    _manager?.writeBytes(data, isDisconnect: false);
  }
}

