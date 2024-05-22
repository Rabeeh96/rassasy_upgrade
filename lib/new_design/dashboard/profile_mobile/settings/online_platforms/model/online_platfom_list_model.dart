import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"34172b52-004a-4d94-8927-8569d5116678","Name":"Uber"},{"id":"88d613d7-1d2f-4c86-81be-02057502f1f9","Name":"Uber"},{"id":"de429b36-be7e-4777-9c16-40d9f42f8549","Name":"Zomato"}]

OnlinePlatfomListModel onlinePlatfomListModelFromJson(String str) => OnlinePlatfomListModel.fromJson(json.decode(str));
String onlinePlatfomListModelToJson(OnlinePlatfomListModel data) => json.encode(data.toJson());
class OnlinePlatfomListModel {
  OnlinePlatfomListModel({
      int? statusCode, 
      List<Data>? data,}){
    _statusCode = statusCode;
    _data = data;
}

  OnlinePlatfomListModel.fromJson(dynamic json) {
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
OnlinePlatfomListModel copyWith({  int? statusCode,
  List<Data>? data,
}) => OnlinePlatfomListModel(  statusCode: statusCode ?? _statusCode,
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

/// id : "34172b52-004a-4d94-8927-8569d5116678"
/// Name : "Uber"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? name,}){
    _id = id;
    _name = name;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['Name'];
  }
  String? _id;
  String? _name;
Data copyWith({  String? id,
  String? name,
}) => Data(  id: id ?? _id,
  name: name ?? _name,
);
  String? get id => _id;
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['Name'] = _name;
    return map;
  }

}