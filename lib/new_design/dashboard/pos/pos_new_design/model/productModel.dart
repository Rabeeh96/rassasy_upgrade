class ProductListModel {
  String productName,
      defaultUnitName,
      defaultSalesPrice,
      defaultPurchasePrice,
      gSTSalesTax,
      vatsSalesTax,
      gSTTaxName,
      description,
      vegOrNonVeg,
      productImage,
      vATTaxName;


  var exciseData;
  var taxDetails;
  int productID, defaultUnitID, gstID, vatID;
  bool isInclusive;

  ProductListModel(
      {required this.productID,
        required this.defaultUnitID,
        required this.gstID,
        required this.vatID,
        required this.productName,
        required this.defaultUnitName,
        required this.defaultSalesPrice,
        required this.exciseData,
        required this.defaultPurchasePrice,
        required this.gSTSalesTax,
        required this.vatsSalesTax,
        required this.vegOrNonVeg,
        required this.gSTTaxName,
        required this.vATTaxName,
        required this.description,
        required this.taxDetails,
        required this.productImage,
        required this.isInclusive});

  factory ProductListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductListModel(
      productID: json['ProductID'] ?? 0,
      defaultUnitID: json['DefaultUnitID'] ?? '',
      gstID: json['GST_ID'] ?? 0,
      vatID: json['VatID'] ?? 0,
      productName: json['ProductName'] ?? '',
      defaultUnitName: json['DefaultUnitName'] ?? '',
      defaultSalesPrice: json['DefaultSalesPrice'].toString(),
      defaultPurchasePrice: json['DefaultPurchasePrice'].toString(),
      gSTSalesTax: json['GST_SalesTax'] ?? '',
      vatsSalesTax: json['SalesTax'] ?? '',
      gSTTaxName: json['GST_TaxName'] ?? "",
      vATTaxName: json['VAT_TaxName'] ?? '',
      isInclusive: json['is_inclusive'] ?? false,
      description: json['Description'] ?? '',
      vegOrNonVeg: json['VegOrNonVeg'] ?? '',
      productImage: json['ProductImage'] ?? '',
      taxDetails: json['Tax'] ?? '',
      exciseData: json['ExciseTaxData'],
    );
  }
}