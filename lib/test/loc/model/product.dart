class Product1 {
  final String id;
  final String name;
  final String price;

  Product1({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product1.fromJson(Map<String, dynamic> json) {
    return Product1(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'].toString(),
    );
  }
}
class Product {
  final String id;
  final int productID;
  final String productName;
  final String defaultUnitName;
  final double defaultSalesPrice;
  final double defaultPurchasePrice;
  final String gstSalesTax;
  final String salesTax;
  final String gstTaxName;
  final String vatTaxName;
  final int gstID;
  final bool isInclusive;
  final int vatID;
  final String description;
  final List<PriceListDetail> priceListDetails;
  final String productImage;
  final String? productImage2;
  final String? productImage3;
  final String vegOrNonVeg;
  final String variantName;
  final String variant;
  final int productGroupID;
  final String groupName;
  final String minimumSalesPrice;
  final String productCode;
  final int exciseTaxID;
  final String exciseTaxData;
  final Tax tax;

  Product({
    required this.id,
    required this.productID,
    required this.productName,
    required this.defaultUnitName,
    required this.defaultSalesPrice,
    required this.defaultPurchasePrice,
    required this.gstSalesTax,
    required this.salesTax,
    required this.gstTaxName,
    required this.vatTaxName,
    required this.gstID,
    required this.isInclusive,
    required this.vatID,
    required this.description,
    required this.priceListDetails,
    required this.productImage,
    this.productImage2,
    this.productImage3,
    required this.vegOrNonVeg,
    required this.variantName,
    required this.variant,
    required this.productGroupID,
    required this.groupName,
    required this.minimumSalesPrice,
    required this.productCode,
    required this.exciseTaxID,
    required this.exciseTaxData,
    required this.tax,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var list = json['price_list_details'] as List;
    List<PriceListDetail> priceListDetailsList = list.map((i) => PriceListDetail.fromJson(i)).toList();

    return Product(
      id: json['id'] ?? '',
      productID: json['ProductID'] ?? 0,
      productName: json['ProductName'] ?? '',
      defaultUnitName: json['DefaultUnitName'] ?? '',
      defaultSalesPrice: (json['DefaultSalesPrice'] is int
          ? (json['DefaultSalesPrice'] as int).toDouble()
          : json['DefaultSalesPrice']?.toDouble()) ?? 0.0,
      defaultPurchasePrice: (json['DefaultPurchasePrice'] is int
          ? (json['DefaultPurchasePrice'] as int).toDouble()
          : json['DefaultPurchasePrice']?.toDouble()) ?? 0.0,
      gstSalesTax: json['GST_SalesTax'] ?? '',
      salesTax: json['SalesTax'] ?? '',
      gstTaxName: json['GST_TaxName'] ?? '',
      vatTaxName: json['VAT_TaxName'] ?? '',
      gstID: json['GST_ID'] ?? 0,
      isInclusive: json['is_inclusive'] ?? false,
      vatID: json['VatID'] ?? 0,
      description: json['Description'] ?? '',
      priceListDetails: priceListDetailsList,
      productImage: json['ProductImage'] ?? '',
      productImage2: json['ProductImage2'] as String?,
      productImage3: json['ProductImage3'] as String?,
      vegOrNonVeg: json['VegOrNonVeg'] ?? '',
      variantName: json['VariantName'] ?? '',
      variant: json['Variant'] ?? '',
      productGroupID: json['ProductGroupID'] ?? 0,
      groupName: json['GroupName'] ?? '',
      minimumSalesPrice: json['MinimumSalesPrice'] ?? '',
      productCode: json['ProductCode'] ?? '',
      exciseTaxID: json['ExciseTaxID'] ?? 0,
      exciseTaxData: json['ExciseTaxData'] ?? '',
      tax: Tax.fromJson(json['Tax'] ?? {}),
    );
  }
}

class PriceListDetail {
  final String id;
  final String unitName;
  final String salesPrice;
  final int priceListID;
  final String purchasePrice;
  final int unitID;
  final int index;
  final String multiFactor;

  PriceListDetail({
    required this.id,
    required this.unitName,
    required this.salesPrice,
    required this.priceListID,
    required this.purchasePrice,
    required this.unitID,
    required this.index,
    required this.multiFactor,
  });

  factory PriceListDetail.fromJson(Map<String, dynamic> json) {
    return PriceListDetail(
      id: json['id'] ?? '',
      unitName: json['UnitName'] ?? '',
      salesPrice: json['SalesPrice'] ?? '',
      priceListID: json['PriceListID'] ?? 0,
      purchasePrice: json['PurchasePrice'] ?? '',
      unitID: json['UnitID'] ?? 0,
      index: json['index'] ?? 0,
      multiFactor: json['MultiFactor'] ?? '',
    );
  }
}

class Tax {
  final int taxID;
  final String taxName;

  Tax({
    required this.taxID,
    required this.taxName,
  });

  factory Tax.fromJson(Map<String, dynamic> json) {
    return Tax(
      taxID: json['TaxID'] ?? 0,
      taxName: json['TaxName'] ?? '',
    );
  }
}
