import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/enums/bluetooth_printer_type.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/enums/connection_type.dart';

// import 'package:vikn_books/viknbook/view_section/print/pos/pos_printer_manager.dart';

class POSPrinter {
  String? id;
  String? name;
  String? address;
  int? deviceId;
  int? vendorId;
  int? productId;
  bool connected;
  int type;
  BluetoothPrinterType get bluetoothType => type.printerType();
  ConnectionType? connectionType;

  factory POSPrinter.instance() => POSPrinter();

  POSPrinter({
    this.id,
    this.name,
    this.address,
    this.deviceId,
    this.vendorId,
    this.productId,
    this.connected= false,
    this.type= 0,
    this.connectionType,
  });
}

extension on int {
  BluetoothPrinterType printerType() {
    BluetoothPrinterType value;
    switch (this) {
      case 1:
        value = BluetoothPrinterType.classic;
        break;
      case 2:
        value = BluetoothPrinterType.le;
        break;
      case 3:
        value = BluetoothPrinterType.dual;
        break;
      default:
        value = BluetoothPrinterType.unknown;
    }
    return value;
  }
}
