
class PrinterListModel {
  String id, printerName, iPAddress, type;
  int printerID;

  PrinterListModel({required this.id, required this.printerID, required this.printerName, required this.iPAddress, required this.type});

  factory PrinterListModel.fromJson(Map<dynamic, dynamic> json) {
    return PrinterListModel(
      id: json['id'],
      printerID: json['PrinterID'],
      printerName: json['PrinterName'],
      iPAddress: json['IPAddress'],
      type: json['Type'],
    );
  }
}
