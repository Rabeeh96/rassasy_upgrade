import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"d78cf54a-5fa1-4ae7-9840-439caa477653","TaxID":17,"BranchID":1,"TaxName":"10 %","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"10.0000","SalesTax":"10.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-12-08T11:16:43.499998","UpdatedDate":"2023-12-14T14:07:57.289903","Action":"M","is_used":true,"IsDefault":false},{"id":"e114c090-f6c0-4f22-81ca-04d2949de547","TaxID":15,"BranchID":1,"TaxName":"yy","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"0.0000","SalesTax":"0.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-12-05T08:38:03.416581","UpdatedDate":"2023-12-05T08:38:15.684220","Action":"M","is_used":false,"IsDefault":false},{"id":"0676fec5-cf85-479e-9b03-6b0f09d71717","TaxID":14,"BranchID":1,"TaxName":"ff","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"0.0000","SalesTax":"0.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-12-04T12:44:17.119099","UpdatedDate":"2023-12-04T12:44:17.112131","Action":"A","is_used":false,"IsDefault":false},{"id":"e2342a5e-1870-4114-bd97-1e704cf6dc29","TaxID":13,"BranchID":1,"TaxName":"new","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"0.0000","SalesTax":"0.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-11-30T14:03:34.491687","UpdatedDate":"2023-11-30T14:03:34.484501","Action":"A","is_used":false,"IsDefault":false},{"id":"a920c502-79d2-47a4-b87e-43fd35d796e3","TaxID":12,"BranchID":1,"TaxName":"aAsd","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"0.0000","SalesTax":"0.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-11-29T09:06:28.621466","UpdatedDate":"2023-11-29T09:06:28.614570","Action":"A","is_used":false,"IsDefault":false},{"id":"fbac45c3-871d-43ab-876b-76a5ea68406a","TaxID":11,"BranchID":1,"TaxName":"te","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"2.0000","SalesTax":"5.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-11-28T15:54:52.642972","UpdatedDate":"2023-11-28T16:00:58.204588","Action":"M","is_used":false,"IsDefault":false},{"id":"1bdc0fd1-9013-48bf-a852-bca855ef2dbe","TaxID":10,"BranchID":1,"TaxName":"mr","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"36.0000","SalesTax":"69.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-11-28T15:43:47.944463","UpdatedDate":"2023-11-28T16:00:32.731248","Action":"M","is_used":false,"IsDefault":false},{"id":"77e4c086-51ed-4ea9-acd6-4831b32c5bd9","TaxID":9,"BranchID":1,"TaxName":"Asd","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"5.0000","SalesTax":"10.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-11-28T15:40:48.100262","UpdatedDate":"2023-11-28T15:56:16.761044","Action":"M","is_used":true,"IsDefault":false},{"id":"7ff26e95-4feb-434b-9b0b-e783a7e64b6b","TaxID":8,"BranchID":1,"TaxName":"inclusive purchase  10%","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"10.0000","SalesTax":"10.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-09-13T12:19:30.867589","UpdatedDate":"2023-09-13T12:19:30.861866","Action":"A","is_used":true,"IsDefault":false},{"id":"192305e2-61d4-4464-83fa-3d5533b7940a","TaxID":7,"BranchID":1,"TaxName":"new purchase","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"99.0000","SalesTax":"80.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-09-13T11:12:44.635231","UpdatedDate":"2023-09-13T11:12:44.625631","Action":"A","is_used":true,"IsDefault":false},{"id":"5d03f47a-e15a-4ae5-87c2-5b539ad74526","TaxID":6,"BranchID":1,"TaxName":"15","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"15.0000","SalesTax":"15.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-05-05T12:02:31.437240","UpdatedDate":"2023-05-05T12:02:31.425936","Action":"A","is_used":true,"IsDefault":false},{"id":"906d5e3e-4faf-462c-aef5-0d83c442e858","TaxID":1,"BranchID":1,"TaxName":"None","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"0.0000","SalesTax":"0.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-01-18T15:14:04.287177","UpdatedDate":"2023-01-18T15:14:04.280378","Action":"A","is_used":true,"IsDefault":true},{"id":"087aac7a-871e-4715-801b-5ee8e1cb78ed","TaxID":5,"BranchID":1,"TaxName":"Tax with 10%","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"10.0000","SalesTax":"10.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-01-16T12:03:30.507125","UpdatedDate":"2023-11-28T16:00:48.931537","Action":"M","is_used":true,"IsDefault":false},{"id":"97350976-1be8-4ab4-9f81-c3c0d4bce9be","TaxID":4,"BranchID":1,"TaxName":"3.0","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"3.0000","SalesTax":"6.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-01-16T11:10:01.262698","UpdatedDate":"2023-01-16T12:08:18.540110","Action":"M","is_used":true,"IsDefault":false},{"id":"66865b4e-4483-4ee5-bed8-be4a3ca4bcf8","TaxID":3,"BranchID":1,"TaxName":"1.0","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"1.0000","SalesTax":"1.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-01-16T11:10:01.250839","UpdatedDate":"2023-01-16T11:10:01.186157","Action":"A","is_used":true,"IsDefault":false},{"id":"60c69475-fb3c-4234-9d89-2635c43366b9","TaxID":2,"BranchID":1,"TaxName":"2.0","TaxType":"VAT","TaxTypeID":"1","PurchaseTax":"2.0000","SalesTax":"2.0000","Inclusive":false,"CreatedUserID":62,"CreatedDate":"2023-01-16T11:10:01.226303","UpdatedDate":"2023-01-16T11:10:01.186157","Action":"A","is_used":true,"IsDefault":false}]

TaxCategoryListViewModelPage taxCategoryListViewModelPageFromJson(String str) => TaxCategoryListViewModelPage.fromJson(json.decode(str));
String taxCategoryListViewModelPageToJson(TaxCategoryListViewModelPage data) => json.encode(data.toJson());
class TaxCategoryListViewModelPage {
  TaxCategoryListViewModelPage({
    int? statusCode,
    List<Data>? data,}){
    _statusCode = statusCode;
    _data = data;
  }

  TaxCategoryListViewModelPage.fromJson(dynamic json) {
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
  TaxCategoryListViewModelPage copyWith({  int? statusCode,
    List<Data>? data,
  }) => TaxCategoryListViewModelPage(  statusCode: statusCode ?? _statusCode,
    data: data ?? _data,
  );
  int? get statusCode => _statusCode;
  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "d78cf54a-5fa1-4ae7-9840-439caa477653"
/// TaxID : 17
/// BranchID : 1
/// TaxName : "10 %"
/// TaxType : "VAT"
/// TaxTypeID : "1"
/// PurchaseTax : "10.0000"
/// SalesTax : "10.0000"
/// Inclusive : false
/// CreatedUserID : 62
/// CreatedDate : "2023-12-08T11:16:43.499998"
/// UpdatedDate : "2023-12-14T14:07:57.289903"
/// Action : "M"
/// is_used : true
/// IsDefault : false

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
    String? id,
    String? taxID,
    String? branchID,
    String? taxName,
    String? taxType,
    String? taxTypeID,
    String? purchaseTax,
    String? salesTax,
    bool? inclusive,
    String? createdUserID,
    String? createdDate,
    String? updatedDate,
    String? action,
    bool? isUsed,
    bool? isDefault,}){
    _id = id;
    _taxID = taxID;
    _branchID = branchID;
    _taxName = taxName;
    _taxType = taxType;
    _taxTypeID = taxTypeID;
    _purchaseTax = purchaseTax;
    _salesTax = salesTax;
    _inclusive = inclusive;
    _createdUserID = createdUserID;
    _createdDate = createdDate;
    _updatedDate = updatedDate;
    _action = action;
    _isUsed = isUsed;
    _isDefault = isDefault;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _taxID = json['TaxID'].toString();
    _branchID = json['BranchID'].toString();
    _taxName = json['TaxName'];
    _taxType = json['TaxType'];
    _taxTypeID = json['TaxTypeID'];
    _purchaseTax = json['PurchaseTax'];
    _salesTax = json['SalesTax'];
    _inclusive = json['Inclusive'];
    _createdUserID = json['CreatedUserID'].toString();
    _createdDate = json['CreatedDate'];
    _updatedDate = json['UpdatedDate'];
    _action = json['Action'];
    _isUsed = json['is_used'];
    _isDefault = json['IsDefault'];
  }
  String? _id;
  String? _taxID;
  String? _branchID;
  String? _taxName;
  String? _taxType;
  String? _taxTypeID;
  String? _purchaseTax;
  String? _salesTax;
  bool? _inclusive;
  String? _createdUserID;
  String? _createdDate;
  String? _updatedDate;
  String? _action;
  bool? _isUsed;
  bool? _isDefault;
  Data copyWith({  String? id,
    String? taxID,
    String? branchID,
    String? taxName,
    String? taxType,
    String? taxTypeID,
    String? purchaseTax,
    String? salesTax,
    bool? inclusive,
    String? createdUserID,
    String? createdDate,
    String? updatedDate,
    String? action,
    bool? isUsed,
    bool? isDefault,
  }) => Data(  id: id ?? _id,
    taxID: taxID ?? _taxID,
    branchID: branchID ?? _branchID,
    taxName: taxName ?? _taxName,
    taxType: taxType ?? _taxType,
    taxTypeID: taxTypeID ?? _taxTypeID,
    purchaseTax: purchaseTax ?? _purchaseTax,
    salesTax: salesTax ?? _salesTax,
    inclusive: inclusive ?? _inclusive,
    createdUserID: createdUserID ?? _createdUserID,
    createdDate: createdDate ?? _createdDate,
    updatedDate: updatedDate ?? _updatedDate,
    action: action ?? _action,
    isUsed: isUsed ?? _isUsed,
    isDefault: isDefault ?? _isDefault,
  );
  String? get id => _id;
  String? get taxID => _taxID;
  String? get branchID => _branchID;
  String? get taxName => _taxName;
  String? get taxType => _taxType;
  String? get taxTypeID => _taxTypeID;
  String? get purchaseTax => _purchaseTax;
  String? get salesTax => _salesTax;
  bool? get inclusive => _inclusive;
  String? get createdUserID => _createdUserID;
  String? get createdDate => _createdDate;
  String? get updatedDate => _updatedDate;
  String? get action => _action;
  bool? get isUsed => _isUsed;
  bool? get isDefault => _isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['TaxID'] = _taxID;
    map['BranchID'] = _branchID;
    map['TaxName'] = _taxName;
    map['TaxType'] = _taxType;
    map['TaxTypeID'] = _taxTypeID;
    map['PurchaseTax'] = _purchaseTax;
    map['SalesTax'] = _salesTax;
    map['Inclusive'] = _inclusive;
    map['CreatedUserID'] = _createdUserID;
    map['CreatedDate'] = _createdDate;
    map['UpdatedDate'] = _updatedDate;
    map['Action'] = _action;
    map['is_used'] = _isUsed;
    map['IsDefault'] = _isDefault;
    return map;
  }

}