class TaxModelListClass {
  int taxID;
  String taxName, type, salesPrice, purchasePrice;
  bool IsDefault;

  TaxModelListClass(
      {required this.taxName,
        required this.type,
        required this.IsDefault,

        required this.taxID,
        required this.purchasePrice,
        required this.salesPrice});

  factory TaxModelListClass.fromJson(Map<dynamic, dynamic> json) {
    return TaxModelListClass(
        type: json['TaxType'],
        taxName: json['TaxName'],
        taxID: json['TaxID'],
        IsDefault: json['IsDefault'],
        purchasePrice: json['PurchaseTax'].toString(),
        salesPrice: json['SalesTax'].toString());

  }
}
