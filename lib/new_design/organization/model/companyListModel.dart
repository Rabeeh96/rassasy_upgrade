import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"dd9335e4-b225-4871-b86f-ffb4aa9e6a0b","CompanyName":"abcd company(GST)","company_type":"Personal","ExpiryDate":"2025-01-30","CompanyLogo":"https://www.api.viknbooks.com/media/company-logo/download_6_Bgs6Cj3_Miwh3AE.jfif","Edition":"Professional","IsPosUser":true,"IsBranch":true,"Branches":[{"id":"821f6c58-ce9b-4582-8574-e83e1c941e85","BranchID":3,"BranchLogo":"","BranchName":"Milton","NickName":"Milton","IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-03-26","Edition":"Standard"},{"id":"cf3c810d-7100-4b32-bcb9-b93c4c186997","BranchID":2,"BranchLogo":"","BranchName":"Zains","NickName":"Zains","IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-03-26","Edition":"Standard"},{"id":"f5e807ec-fec1-4f1f-a6b2-81acc8002899","BranchID":1,"BranchLogo":"/media/company-logo/download_6_Bgs6Cj3_9WEsHqT.jfif","BranchName":"abcd company(GST)","NickName":null,"IsActive":true,"IsPosUser":true,"ExpiryDate":"2025-01-30","Edition":"Professional"}]},{"id":"e26a94c3-4eb9-416c-8943-0453ab62fc44","CompanyName":"Vat Company(VAT)","company_type":"Personal","ExpiryDate":"2024-04-27","CompanyLogo":"https://www.api.viknbooks.com/media/company-logo/download_7_tBUnMcb_BTJ4ZFl_2yqWuo7_wUSZuR1_jKjsIaY.jfif","Edition":"Standard","IsPosUser":false,"IsBranch":true,"Branches":[{"id":"ac78ce64-90b3-4dab-9f3d-e6cee4a862aa","BranchID":2,"BranchLogo":"","BranchName":"Sub Branch  vat","NickName":"Sub Branch  vat","IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-03-27","Edition":"Standard"},{"id":"ca1857cc-aca1-47b4-bebc-fff78c93b213","BranchID":1,"BranchLogo":"/media/company-logo/download_7_tBUnMcb_BTJ4ZFl_2yqWuo7_wUSZuR1_ORiSUhR.jfif","BranchName":"Vat Company(VAT)","NickName":null,"IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-04-27","Edition":"Standard"}]},{"id":"52294138-71cb-4cb4-8da1-397b2351f911","CompanyName":"Mile StoneGst  test","company_type":"Personal","ExpiryDate":"2024-04-08","CompanyLogo":null,"Edition":"Professional","IsPosUser":false,"IsBranch":false,"Branches":[]},{"id":"5a09676a-55ef-47e3-ab02-bac62005d847","CompanyName":"Vikn Resto Cafe","company_type":"Member","ExpiryDate":"2029-03-14","IsBranch":false,"CompanyLogo":"https://www.api.viknbooks.com/media/company-logo/icon_price_checker_t6OOhzO_7FpwdCk_aQDqX69_G8zq7ju.png","Edition":"Professional","IsPosUser":true,"Branches":[]},{"id":"1e5b8f19-0f4d-44a5-9fae-b23b23cd2b56","CompanyName":"Faera VAT","company_type":"Member","ExpiryDate":"2025-01-06","IsBranch":true,"CompanyLogo":"https://www.api.viknbooks.com/media/company-logo/Free-Electrical-Business-Logo_v05TfGi_rcMun8a_3lJscp3.webp","Edition":"Professional","IsPosUser":false,"Branches":[]},{"id":"e45324c9-0def-4f0e-b13b-12acda700c2a","CompanyName":"FAERA","company_type":"Member","ExpiryDate":"2023-07-12","IsBranch":false,"CompanyLogo":null,"Edition":"Professional","IsPosUser":false,"Branches":[]},{"id":"7eca849d-c78b-4900-a4d3-a4edee06e0ec","CompanyName":"VIKNCODES","company_type":"Member","ExpiryDate":"2023-12-28","IsBranch":false,"CompanyLogo":"https://www.api.viknbooks.com/media/company-logo/download_WYi5AHJ.jpeg","Edition":"Professional","IsPosUser":false,"Branches":[]}]
/// SoftwareVersion : {"CurrentVersion":"1.0.83","MinimumVersion":"1.0.20"}

CompanyListModel companyListModelFromJson(String str) => CompanyListModel.fromJson(json.decode(str));
String companyListModelToJson(CompanyListModel data) => json.encode(data.toJson());
class CompanyListModel {
  CompanyListModel({
      int? statusCode, 
      List<Data>? data, 
      SoftwareVersion? softwareVersion,}){
    _statusCode = statusCode;
    _data = data;
    _softwareVersion = softwareVersion;
}

  CompanyListModel.fromJson(dynamic json) {
    _statusCode = json['StatusCode'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _softwareVersion = json['SoftwareVersion'] != null ? SoftwareVersion.fromJson(json['SoftwareVersion']) : null;
  }
  int? _statusCode;
  List<Data>? _data;
  SoftwareVersion? _softwareVersion;
CompanyListModel copyWith({  int? statusCode,
  List<Data>? data,
  SoftwareVersion? softwareVersion,
}) => CompanyListModel(  statusCode: statusCode ?? _statusCode,
  data: data ?? _data,
  softwareVersion: softwareVersion ?? _softwareVersion,
);
  int? get statusCode => _statusCode;
  List<Data>? get data => _data;
  SoftwareVersion? get softwareVersion => _softwareVersion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_softwareVersion != null) {
      map['SoftwareVersion'] = _softwareVersion?.toJson();
    }
    return map;
  }

}

/// CurrentVersion : "1.0.83"
/// MinimumVersion : "1.0.20"

SoftwareVersion softwareVersionFromJson(String str) => SoftwareVersion.fromJson(json.decode(str));
String softwareVersionToJson(SoftwareVersion data) => json.encode(data.toJson());
class SoftwareVersion {
  SoftwareVersion({
      String? currentVersion, 
      String? minimumVersion,}){
    _currentVersion = currentVersion;
    _minimumVersion = minimumVersion;
}

  SoftwareVersion.fromJson(dynamic json) {
    _currentVersion = json['CurrentVersion'];
    _minimumVersion = json['MinimumVersion'];
  }
  String? _currentVersion;
  String? _minimumVersion;
SoftwareVersion copyWith({  String? currentVersion,
  String? minimumVersion,
}) => SoftwareVersion(  currentVersion: currentVersion ?? _currentVersion,
  minimumVersion: minimumVersion ?? _minimumVersion,
);
  String? get currentVersion => _currentVersion;
  String? get minimumVersion => _minimumVersion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CurrentVersion'] = _currentVersion;
    map['MinimumVersion'] = _minimumVersion;
    return map;
  }

}

/// id : "dd9335e4-b225-4871-b86f-ffb4aa9e6a0b"
/// CompanyName : "abcd company(GST)"
/// company_type : "Personal"d
/// ExpiryDate : "2025-01-30"
/// CompanyLogo : "https://www.api.viknbooks.com/media/company-logo/download_6_Bgs6Cj3_Miwh3AE.jfif"
/// Edition : "Professional"
/// IsPosUser : true
/// IsBranch : true
/// Branches : [{"id":"821f6c58-ce9b-4582-8574-e83e1c941e85","BranchID":3,"BranchLogo":"","BranchName":"Milton","NickName":"Milton","IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-03-26","Edition":"Standard"},{"id":"cf3c810d-7100-4b32-bcb9-b93c4c186997","BranchID":2,"BranchLogo":"","BranchName":"Zains","NickName":"Zains","IsActive":true,"IsPosUser":false,"ExpiryDate":"2024-03-26","Edition":"Standard"},{"id":"f5e807ec-fec1-4f1f-a6b2-81acc8002899","BranchID":1,"BranchLogo":"/media/company-logo/download_6_Bgs6Cj3_9WEsHqT.jfif","BranchName":"abcd company(GST)","NickName":null,"IsActive":true,"IsPosUser":true,"ExpiryDate":"2025-01-30","Edition":"Professional"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({

      String? id, 
      String? companyName, 

      String? expiryDate, 
      String? companyLogo, 
      String? edition, 
      String? BaseURL,
   ///   bool? isPosUser,
      bool? isBranch, 
      List<Branches>? branches,}){
    _id = id;
    _companyName = companyName;

    _BaseURL = BaseURL;
    _expiryDate = expiryDate;
    _companyLogo = companyLogo;
    _edition = edition;
  ///  _isPosUser = isPosUser;
    _isBranch = isBranch;
    _branches = branches;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _companyName = json['CompanyName'];

    _BaseURL = json['BaseURL'];
    _expiryDate = json['ExpiryDate'];
    _companyLogo = json['CompanyLogo'];
    _edition = json['Edition'];
  ///  _isPosUser = json['IsPosUser'];
    _isBranch = json['IsBranch'];
    if (json['Branches'] != null) {
      _branches = [];
      json['Branches'].forEach((v) {
        _branches?.add(Branches.fromJson(v));
      });
    }
  }
  String? _id;
  String? _companyName;

  String? _expiryDate;
  String? _companyLogo;
  String? _edition;
  String? _BaseURL;
  ///bool? _isPosUser;
  bool? _isBranch;
  List<Branches>? _branches;
Data copyWith({  String? id,
  String? companyName,

  String? BaseURL,
  String? expiryDate,
  String? companyLogo,
  String? edition,
 /// bool? isPosUser,
  bool? isBranch,
  List<Branches>? branches,
}) => Data(  id: id ?? _id,
  companyName: companyName ?? _companyName,

  expiryDate: expiryDate ?? _expiryDate,
  companyLogo: companyLogo ?? _companyLogo,
  BaseURL: BaseURL ?? _BaseURL,
  edition: edition ?? _edition,
 /// isPosUser: isPosUser ?? _isPosUser,
  isBranch: isBranch ?? _isBranch,
  branches: branches ?? _branches,
);
  String? get id => _id;
  String? get companyName => _companyName;

  String? get expiryDate => _expiryDate;
  String? get companyLogo => _companyLogo;
  String? get BaseURL => _BaseURL;
  String? get edition => _edition;
 /// bool? get isPosUser => _isPosUser;
  bool? get isBranch => _isBranch;
  List<Branches>? get branches => _branches;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['CompanyName'] = _companyName;

    map['BaseURL'] = _BaseURL;
    map['ExpiryDate'] = _expiryDate;
    map['CompanyLogo'] = _companyLogo;
    map['Edition'] = _edition;
 ///   map['IsPosUser'] = _isPosUser;
    map['IsBranch'] = _isBranch;
    if (_branches != null) {
      map['Branches'] = _branches?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "821f6c58-ce9b-4582-8574-e83e1c941e85"
/// BranchID : 3
/// BranchLogo : ""
/// BranchName : "Milton"
/// NickName : "Milton"
/// IsActive : true
/// IsPosUser : false
/// ExpiryDate : "2024-03-26"
/// Edition : "Standard"

Branches branchesFromJson(String str) => Branches.fromJson(json.decode(str));
String branchesToJson(Branches data) => json.encode(data.toJson());
class Branches {
  Branches({
      String? id, 
      int? branchID, 
      String? branchLogo, 
      String? branchName, 
      String? nickName, 
      bool? isActive, 
      bool? isPosUser, 
      String? expiryDate, 
      String? edition,}){
    _id = id;
    _branchID = branchID;
    _branchLogo = branchLogo;
    _branchName = branchName;
    _nickName = nickName;
    _isActive = isActive;
    _isPosUser = isPosUser;
    _expiryDate = expiryDate;
    _edition = edition;
}

  Branches.fromJson(dynamic json) {
    _id = json['id'];
    _branchID = json['BranchID'];
    _branchLogo = json['BranchLogo'];
    _branchName = json['BranchName'];
    _nickName = json['NickName'];
    _isActive = json['IsActive'];
    _isPosUser = json['IsPosUser'];
    _expiryDate = json['ExpiryDate'];
    _edition = json['Edition'];
  }
  String? _id;
  int? _branchID;
  String? _branchLogo;
  String? _branchName;
  String? _nickName;
  bool? _isActive;
  bool? _isPosUser;
  String? _expiryDate;
  String? _edition;
Branches copyWith({  String? id,
  int? branchID,
  String? branchLogo,
  String? branchName,
  String? nickName,
  bool? isActive,
  bool? isPosUser,
  String? expiryDate,
  String? edition,
}) => Branches(  id: id ?? _id,
  branchID: branchID ?? _branchID,
  branchLogo: branchLogo ?? _branchLogo,
  branchName: branchName ?? _branchName,
  nickName: nickName ?? _nickName,
  isActive: isActive ?? _isActive,
  isPosUser: isPosUser ?? _isPosUser,
  expiryDate: expiryDate ?? _expiryDate,
  edition: edition ?? _edition,
);
  String? get id => _id;
  int? get branchID => _branchID;
  String? get branchLogo => _branchLogo;
  String? get branchName => _branchName;
  String? get nickName => _nickName;
  bool? get isActive => _isActive;
  bool? get isPosUser => _isPosUser;
  String? get expiryDate => _expiryDate;
  String? get edition => _edition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['BranchID'] = _branchID;
    map['BranchLogo'] = _branchLogo;
    map['BranchName'] = _branchName;
    map['NickName'] = _nickName;
    map['IsActive'] = _isActive;
    map['IsPosUser'] = _isPosUser;
    map['ExpiryDate'] = _expiryDate;
    map['Edition'] = _edition;
    return map;
  }

}