import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"c71d8368-ab09-4707-9045-e37635d64ff7","ProductID":21,"ProductName":"horlicks","DefaultUnitID":21,"DefaultUnitName":"Piece","DefaultSalesPrice":340.0,"DefaultPurchasePrice":0.0,"GST_SalesTax":"36.00000000","SalesTax":"36.00000000","GST_TaxName":"tyhh","VAT_TaxName":"tyhh","GST_ID":1,"is_inclusive":false,"VatID":1,"Description":"","price_list_details":[{"id":"741895cd-6282-4672-86ca-130da71a8598","UnitName":"Piece","SalesPrice":"340.00000000","PriceListID":21,"PurchasePrice":"0.00000000","UnitID":1,"index":0,"MultiFactor":"1.00000000"}],"ProductImage":"","VegOrNonVeg":"","VariantName":"","Variant":"","ProductGroupID":1,"GroupName":"Primary Group","MinimumSalesPrice":"340.00000000","ProductCode":"PC1020","ExciseTaxID":1,"ExciseTaxData":"","Tax":{"TaxID":1,"TaxName":"tyhh"}}]

ProductSearchModel productSearchModelFromJson(String str) => ProductSearchModel.fromJson(json.decode(str));
String productSearchModelToJson(ProductSearchModel data) => json.encode(data.toJson());
class ProductSearchModel {
  ProductSearchModel({
      int? statusCode, 
      List<Data>? data,}){
    _statusCode = statusCode;
    _data = data;
}

  ProductSearchModel.fromJson(dynamic json) {
    _statusCode = json['StatusCode'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }
  int? _statusCode;
  List<Data>? _data;
ProductSearchModel copyWith({  int? statusCode,
  List<Data>? data,
}) => ProductSearchModel(  statusCode: statusCode ?? _statusCode,
  data: data ?? _data,
);
  int? get statusCode => _statusCode;
  List<Data>? get data => _data;

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['StatusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "c71d8368-ab09-4707-9045-e37635d64ff7"
/// ProductID : 21
/// ProductName : "horlicks"
/// DefaultUnitID : 21
/// DefaultUnitName : "Piece"
/// DefaultSalesPrice : 340.0
/// DefaultPurchasePrice : 0.0
/// GST_SalesTax : "36.00000000"
/// SalesTax : "36.00000000"
/// GST_TaxName : "tyhh"
/// VAT_TaxName : "tyhh"
/// GST_ID : 1
/// is_inclusive : false
/// VatID : 1
/// Description : ""
/// price_list_details : [{"id":"741895cd-6282-4672-86ca-130da71a8598","UnitName":"Piece","SalesPrice":"340.00000000","PriceListID":21,"PurchasePrice":"0.00000000","UnitID":1,"index":0,"MultiFactor":"1.00000000"}]
/// ProductImage : ""
/// VegOrNonVeg : ""
/// VariantName : ""
/// Variant : ""
/// ProductGroupID : 1
/// GroupName : "Primary Group"
/// MinimumSalesPrice : "340.00000000"
/// ProductCode : "PC1020"
/// ExciseTaxID : 1
/// ExciseTaxData : ""
/// Tax : {"TaxID":1,"TaxName":"tyhh"}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      int? productID, 
      String? productName, 
      int? defaultUnitID, 
      String? defaultUnitName, 
      double? defaultSalesPrice, 
      double? defaultPurchasePrice, 
      String? gSTSalesTax, 
      String? salesTax, 
      String? gSTTaxName, 
      String? vATTaxName, 
      int? gstid, 
      bool? isInclusive, 
      int? vatID, 
      String? description, 
      List<PriceListDetails>? priceListDetails, 
      String? productImage, 
      String? vegOrNonVeg, 
      String? variantName, 
      String? variant, 
      int? productGroupID, 
      String? groupName, 
      String? minimumSalesPrice, 
      String? productCode, 
      int? exciseTaxID, 
      String? exciseTaxData, 
      Tax? tax,}){
    _id = id;
    _productID = productID;
    _productName = productName;
    _defaultUnitID = defaultUnitID;
    _defaultUnitName = defaultUnitName;
    _defaultSalesPrice = defaultSalesPrice;
    _defaultPurchasePrice = defaultPurchasePrice;
    _gSTSalesTax = gSTSalesTax;
    _salesTax = salesTax;
    _gSTTaxName = gSTTaxName;
    _vATTaxName = vATTaxName;
    _gstid = gstid;
    _isInclusive = isInclusive;
    _vatID = vatID;
    _description = description;
    _priceListDetails = priceListDetails;
    _productImage = productImage;
    _vegOrNonVeg = vegOrNonVeg;
    _variantName = variantName;
    _variant = variant;
    _productGroupID = productGroupID;
    _groupName = groupName;
    _minimumSalesPrice = minimumSalesPrice;
    _productCode = productCode;
    _exciseTaxID = exciseTaxID;
    _exciseTaxData = exciseTaxData;
    _tax = tax;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _productID = json['ProductID'];
    _productName = json['ProductName'];
    _defaultUnitID = json['DefaultUnitID'];
    _defaultUnitName = json['DefaultUnitName'];
    _defaultSalesPrice = json['DefaultSalesPrice'];
    _defaultPurchasePrice = json['DefaultPurchasePrice'];
    _gSTSalesTax = json['GST_SalesTax'];
    _salesTax = json['SalesTax'];
    _gSTTaxName = json['GST_TaxName'];
    _vATTaxName = json['VAT_TaxName'];
    _gstid = json['GST_ID'];
    _isInclusive = json['is_inclusive'];
    _vatID = json['VatID'];
    _description = json['Description'];
    if (json['price_list_details'] != null) {
      _priceListDetails = [];
      json['price_list_details'].forEach((v) {
        _priceListDetails?.add(PriceListDetails.fromJson(v));
      });
    }
    _productImage = json['ProductImage'];
    _vegOrNonVeg = json['VegOrNonVeg'];
    _variantName = json['VariantName'];
    _variant = json['Variant'];
    _productGroupID = json['ProductGroupID'];
    _groupName = json['GroupName'];
    _minimumSalesPrice = json['MinimumSalesPrice'];
    _productCode = json['ProductCode'];
    _exciseTaxID = json['ExciseTaxID'];
    _exciseTaxData = json['ExciseTaxData'];
    _tax = json['Tax'] != null ? Tax.fromJson(json['Tax']) : null;
  }
  String? _id;
  int? _productID;
  String? _productName;
  int? _defaultUnitID;
  String? _defaultUnitName;
  double? _defaultSalesPrice;
  double? _defaultPurchasePrice;
  String? _gSTSalesTax;
  String? _salesTax;
  String? _gSTTaxName;
  String? _vATTaxName;
  int? _gstid;
  bool? _isInclusive;
  int? _vatID;
  String? _description;
  List<PriceListDetails>? _priceListDetails;
  String? _productImage;
  String? _vegOrNonVeg;
  String? _variantName;
  String? _variant;
  int? _productGroupID;
  String? _groupName;
  String? _minimumSalesPrice;
  String? _productCode;
  int? _exciseTaxID;
  String? _exciseTaxData;
  Tax? _tax;
Data copyWith({  String? id,
  int? productID,
  String? productName,
  int? defaultUnitID,
  String? defaultUnitName,
  double? defaultSalesPrice,
  double? defaultPurchasePrice,
  String? gSTSalesTax,
  String? salesTax,
  String? gSTTaxName,
  String? vATTaxName,
  int? gstid,
  bool? isInclusive,
  int? vatID,
  String? description,
  List<PriceListDetails>? priceListDetails,
  String? productImage,
  String? vegOrNonVeg,
  String? variantName,
  String? variant,
  int? productGroupID,
  String? groupName,
  String? minimumSalesPrice,
  String? productCode,
  int? exciseTaxID,
  String? exciseTaxData,
  Tax? tax,
}) => Data(  id: id ?? _id,
  productID: productID ?? _productID,
  productName: productName ?? _productName,
  defaultUnitID: defaultUnitID ?? _defaultUnitID,
  defaultUnitName: defaultUnitName ?? _defaultUnitName,
  defaultSalesPrice: defaultSalesPrice ?? _defaultSalesPrice,
  defaultPurchasePrice: defaultPurchasePrice ?? _defaultPurchasePrice,
  gSTSalesTax: gSTSalesTax ?? _gSTSalesTax,
  salesTax: salesTax ?? _salesTax,
  gSTTaxName: gSTTaxName ?? _gSTTaxName,
  vATTaxName: vATTaxName ?? _vATTaxName,
  gstid: gstid ?? _gstid,
  isInclusive: isInclusive ?? _isInclusive,
  vatID: vatID ?? _vatID,
  description: description ?? _description,
  priceListDetails: priceListDetails ?? _priceListDetails,
  productImage: productImage ?? _productImage,
  vegOrNonVeg: vegOrNonVeg ?? _vegOrNonVeg,
  variantName: variantName ?? _variantName,
  variant: variant ?? _variant,
  productGroupID: productGroupID ?? _productGroupID,
  groupName: groupName ?? _groupName,
  minimumSalesPrice: minimumSalesPrice ?? _minimumSalesPrice,
  productCode: productCode ?? _productCode,
  exciseTaxID: exciseTaxID ?? _exciseTaxID,
  exciseTaxData: exciseTaxData ?? _exciseTaxData,
  tax: tax ?? _tax,
);
  String? get id => _id;
  int? get productID => _productID;
  String? get productName => _productName;
  int? get defaultUnitID => _defaultUnitID;
  String? get defaultUnitName => _defaultUnitName;
  double? get defaultSalesPrice => _defaultSalesPrice;
  double? get defaultPurchasePrice => _defaultPurchasePrice;
  String? get gSTSalesTax => _gSTSalesTax;
  String? get salesTax => _salesTax;
  String? get gSTTaxName => _gSTTaxName;
  String? get vATTaxName => _vATTaxName;
  int? get gstid => _gstid;
  bool? get isInclusive => _isInclusive;
  int? get vatID => _vatID;
  String? get description => _description;
  List<PriceListDetails>? get priceListDetails => _priceListDetails;
  String? get productImage => _productImage;
  String? get vegOrNonVeg => _vegOrNonVeg;
  String? get variantName => _variantName;
  String? get variant => _variant;
  int? get productGroupID => _productGroupID;
  String? get groupName => _groupName;
  String? get minimumSalesPrice => _minimumSalesPrice;
  String? get productCode => _productCode;
  int? get exciseTaxID => _exciseTaxID;
  String? get exciseTaxData => _exciseTaxData;
  Tax? get tax => _tax;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ProductID'] = _productID;
    map['ProductName'] = _productName;
    map['DefaultUnitID'] = _defaultUnitID;
    map['DefaultUnitName'] = _defaultUnitName;
    map['DefaultSalesPrice'] = _defaultSalesPrice;
    map['DefaultPurchasePrice'] = _defaultPurchasePrice;
    map['GST_SalesTax'] = _gSTSalesTax;
    map['SalesTax'] = _salesTax;
    map['GST_TaxName'] = _gSTTaxName;
    map['VAT_TaxName'] = _vATTaxName;
    map['GST_ID'] = _gstid;
    map['is_inclusive'] = _isInclusive;
    map['VatID'] = _vatID;
    map['Description'] = _description;
    if (_priceListDetails != null) {
      map['price_list_details'] = _priceListDetails?.map((v) => v.toJson()).toList();
    }
    map['ProductImage'] = _productImage;
    map['VegOrNonVeg'] = _vegOrNonVeg;
    map['VariantName'] = _variantName;
    map['Variant'] = _variant;
    map['ProductGroupID'] = _productGroupID;
    map['GroupName'] = _groupName;
    map['MinimumSalesPrice'] = _minimumSalesPrice;
    map['ProductCode'] = _productCode;
    map['ExciseTaxID'] = _exciseTaxID;
    map['ExciseTaxData'] = _exciseTaxData;
    if (_tax != null) {
      map['Tax'] = _tax?.toJson();
    }
    return map;
  }

}

/// TaxID : 1
/// TaxName : "tyhh"

Tax taxFromJson(String str) => Tax.fromJson(json.decode(str));
String taxToJson(Tax data) => json.encode(data.toJson());
class Tax {
  Tax({
      int? taxID, 
      String? taxName,}){
    _taxID = taxID;
    _taxName = taxName;
}

  Tax.fromJson(dynamic json) {
    _taxID = json['TaxID'];
    _taxName = json['TaxName'];
  }
  int? _taxID;
  String? _taxName;
Tax copyWith({  int? taxID,
  String? taxName,
}) => Tax(  taxID: taxID ?? _taxID,
  taxName: taxName ?? _taxName,
);
  int? get taxID => _taxID;
  String? get taxName => _taxName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TaxID'] = _taxID;
    map['TaxName'] = _taxName;
    return map;
  }

}

/// id : "741895cd-6282-4672-86ca-130da71a8598"
/// UnitName : "Piece"
/// SalesPrice : "340.00000000"
/// PriceListID : 21
/// PurchasePrice : "0.00000000"
/// UnitID : 1
/// index : 0
/// MultiFactor : "1.00000000"

PriceListDetails priceListDetailsFromJson(String str) => PriceListDetails.fromJson(json.decode(str));
String priceListDetailsToJson(PriceListDetails data) => json.encode(data.toJson());
class PriceListDetails {
  PriceListDetails({
      String? id, 
      String? unitName, 
      String? salesPrice, 
      int? priceListID, 
      String? purchasePrice, 
      int? unitID, 
      int? index, 
      String? multiFactor,}){
    _id = id;
    _unitName = unitName;
    _salesPrice = salesPrice;
    _priceListID = priceListID;
    _purchasePrice = purchasePrice;
    _unitID = unitID;
    _index = index;
    _multiFactor = multiFactor;
}

  PriceListDetails.fromJson(dynamic json) {
    _id = json['id'];
    _unitName = json['UnitName'];
    _salesPrice = json['SalesPrice'];
    _priceListID = json['PriceListID'];
    _purchasePrice = json['PurchasePrice'];
    _unitID = json['UnitID'];
    _index = json['index'];
    _multiFactor = json['MultiFactor'];
  }
  String? _id;
  String? _unitName;
  String? _salesPrice;
  int? _priceListID;
  String? _purchasePrice;
  int? _unitID;
  int? _index;
  String? _multiFactor;
PriceListDetails copyWith({  String? id,
  String? unitName,
  String? salesPrice,
  int? priceListID,
  String? purchasePrice,
  int? unitID,
  int? index,
  String? multiFactor,
}) => PriceListDetails(  id: id ?? _id,
  unitName: unitName ?? _unitName,
  salesPrice: salesPrice ?? _salesPrice,
  priceListID: priceListID ?? _priceListID,
  purchasePrice: purchasePrice ?? _purchasePrice,
  unitID: unitID ?? _unitID,
  index: index ?? _index,
  multiFactor: multiFactor ?? _multiFactor,
);
  String? get id => _id;
  String? get unitName => _unitName;
  String? get salesPrice => _salesPrice;
  int? get priceListID => _priceListID;
  String? get purchasePrice => _purchasePrice;
  int? get unitID => _unitID;
  int? get index => _index;
  String? get multiFactor => _multiFactor;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['UnitName'] = _unitName;
    map['SalesPrice'] = _salesPrice;
    map['PriceListID'] = _priceListID;
    map['PurchasePrice'] = _purchasePrice;
    map['UnitID'] = _unitID;
    map['index'] = _index;
    map['MultiFactor'] = _multiFactor;
    return map;
  }

}



