class CustomerModel {
  final int id;
  final String userName;
  final String openingBalance;
  final String customerLedgerBalance;

  CustomerModel({
    required this.id,
    required this.userName,
    required this.openingBalance,
    required this.customerLedgerBalance,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['LedgerID'],
      userName: json['LedgerName'],
      openingBalance: json['OpeningBalance'].toString(),
      customerLedgerBalance: json['CustomerLedgerBalance'].toString(),

    );
  }
}
