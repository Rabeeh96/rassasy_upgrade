import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"841402e7-7a73-4ff1-a482-dbcbbecdf7a7","TableName":"Tb","CreatedUserID":62,"CreatedDate":"2024-05-16T09:29:34.043675","BranchID":1,"CustomerName":"saadc","Date":"2024-05-16","FromTime":"00:58:00","ToTime":"16:58:00","CompanyID":"5a09676a-55ef-47e3-ab02-bac62005d847","Table":"43af78be-be39-4834-a8fd-6e250d413182"}]
/// message : "Table reservatioin listed successfully"

ReservationModelClass reservationModelClassFromJson(String str) => ReservationModelClass.fromJson(json.decode(str));
String reservationModelClassToJson(ReservationModelClass data) => json.encode(data.toJson());
class ReservationModelClass {
  ReservationModelClass({
      int? statusCode, 
      List<Data>? data, 
      String? message,}){
    _statusCode = statusCode;
    _data = data;
    _message = message;
}

  ReservationModelClass.fromJson(dynamic json) {
    _statusCode = json['StatusCode'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _message = json['message'];
  }
  int? _statusCode;
  List<Data>? _data;
  String? _message;
ReservationModelClass copyWith({  int? statusCode,
  List<Data>? data,
  String? message,
}) => ReservationModelClass(  statusCode: statusCode ?? _statusCode,
  data: data ?? _data,
  message: message ?? _message,
);
  int? get statusCode => _statusCode;
  List<Data>? get data => _data;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['message'] = _message;
    return map;
  }

}

/// id : "841402e7-7a73-4ff1-a482-dbcbbecdf7a7"
/// TableName : "Tb"
/// CreatedUserID : 62
/// CreatedDate : "2024-05-16T09:29:34.043675"
/// BranchID : 1
/// CustomerName : "saadc"
/// Date : "2024-05-16"
/// FromTime : "00:58:00"
/// ToTime : "16:58:00"
/// CompanyID : "5a09676a-55ef-47e3-ab02-bac62005d847"
/// Table : "43af78be-be39-4834-a8fd-6e250d413182"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? tableName, 
      int? createdUserID, 
      String? createdDate, 
      int? branchID, 
      String? customerName, 
      String? date, 
      String? fromTime, 
      String? toTime, 
      String? companyID, 
      String? table,}){
    _id = id;
    _tableName = tableName;
    _createdUserID = createdUserID;
    _createdDate = createdDate;
    _branchID = branchID;
    _customerName = customerName;
    _date = date;
    _fromTime = fromTime;
    _toTime = toTime;
    _companyID = companyID;
    _table = table;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _tableName = json['TableName'];
    _createdUserID = json['CreatedUserID'];
    _createdDate = json['CreatedDate'];
    _branchID = json['BranchID'];
    _customerName = json['CustomerName'];
    _date = json['Date'];
    _fromTime = json['FromTime'];
    _toTime = json['ToTime'];
    _companyID = json['CompanyID'];
    _table = json['Table'];
  }
  String? _id;
  String? _tableName;
  int? _createdUserID;
  String? _createdDate;
  int? _branchID;
  String? _customerName;
  String? _date;
  String? _fromTime;
  String? _toTime;
  String? _companyID;
  String? _table;
Data copyWith({  String? id,
  String? tableName,
  int? createdUserID,
  String? createdDate,
  int? branchID,
  String? customerName,
  String? date,
  String? fromTime,
  String? toTime,
  String? companyID,
  String? table,
}) => Data(  id: id ?? _id,
  tableName: tableName ?? _tableName,
  createdUserID: createdUserID ?? _createdUserID,
  createdDate: createdDate ?? _createdDate,
  branchID: branchID ?? _branchID,
  customerName: customerName ?? _customerName,
  date: date ?? _date,
  fromTime: fromTime ?? _fromTime,
  toTime: toTime ?? _toTime,
  companyID: companyID ?? _companyID,
  table: table ?? _table,
);
  String? get id => _id;
  String? get tableName => _tableName;
  int? get createdUserID => _createdUserID;
  String? get createdDate => _createdDate;
  int? get branchID => _branchID;
  String? get customerName => _customerName;
  String? get date => _date;
  String? get fromTime => _fromTime;
  String? get toTime => _toTime;
  String? get companyID => _companyID;
  String? get table => _table;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['TableName'] = _tableName;
    map['CreatedUserID'] = _createdUserID;
    map['CreatedDate'] = _createdDate;
    map['BranchID'] = _branchID;
    map['CustomerName'] = _customerName;
    map['Date'] = _date;
    map['FromTime'] = _fromTime;
    map['ToTime'] = _toTime;
    map['CompanyID'] = _companyID;
    map['Table'] = _table;
    return map;
  }

}