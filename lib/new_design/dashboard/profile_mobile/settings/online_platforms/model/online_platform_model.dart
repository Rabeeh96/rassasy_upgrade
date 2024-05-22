import 'dart:convert';
/// StatusCode : 6000
/// message : "Created Successfully"

PlatFormModel onlinePlatformControllerFromJson(String str) => PlatFormModel.fromJson(json.decode(str));
String onlinePlatformControllerToJson(PlatFormModel data) => json.encode(data.toJson());
class PlatFormModel {
  PlatFormModel({
      int? statusCode, 
      String? message,}){
    _statusCode = statusCode;
    _message = message;
}

  PlatFormModel.fromJson(dynamic json) {
    _statusCode = json['StatusCode'];
    _message = json['message'];
  }
  int? _statusCode;
  String? _message;
PlatFormModel copyWith({  int? statusCode,
  String? message,
}) => PlatFormModel(  statusCode: statusCode ?? _statusCode,
  message: message ?? _message,
);
  int? get statusCode => _statusCode;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = _statusCode;
    map['message'] = _message;
    return map;
  }

}