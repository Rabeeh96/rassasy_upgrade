import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/enums/connection_type.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/pos/models/pos_printer.dart';


class BluetoothPrinter extends POSPrinter {
  BluetoothPrinter({
    String? id,
    String? name,
    String? address,
    bool connected= false,
    int type= 0,
    ConnectionType? connectionType,
  }) {
    this.id = id;
    this.name = name;
    this.address = address;
    this.connected = connected;
    this.type = type;
    this.connectionType = ConnectionType.bluetooth;
  }
}
