class CustomerModel {
  final int ledgerID;
  final String ledgerName;
  final String openingBalance;
  final String customerLedgerBalance;

  CustomerModel({
    required this.ledgerID,
    required this.ledgerName,
    required this.openingBalance,
    required this.customerLedgerBalance,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      ledgerID: json['LedgerID'],
      ledgerName: json['LedgerName'],
      openingBalance: json['OpeningBalance'].toString(),
      customerLedgerBalance: json['CustomerLedgerBalance'].toString(),

    );
  }
}
