class TaxListModelClass {
  String taxName, type, id, salesPrice, purchasePrice;

  TaxListModelClass({required this.taxName, required this.type, required this.id, required this.purchasePrice, required this.salesPrice});

  factory TaxListModelClass.fromJson(Map<dynamic, dynamic> json) {
    return TaxListModelClass(
        type: json['TaxType'],
        taxName: json['TaxName'],
        id: json['id'],
        purchasePrice: json['PurchaseTax'].toString(),
        salesPrice: json['SalesTax'].toString());
  }
}