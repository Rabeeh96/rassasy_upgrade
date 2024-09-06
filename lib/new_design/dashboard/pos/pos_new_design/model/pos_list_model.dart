import 'dart:convert';
/// StatusCode : 6000
/// data : [{"id":"78847d45-02da-4cf9-94dc-5ef37d65ad44","title":"Tb 1","description":"","PriceCategory":"None","Status":"Paid","priceid":"","SalesOrderID":"18751ef9-3838-46d4-831c-7f3e9bb35dca","SalesMasterID":"ff9b945a-8220-42b8-87ab-56af7b4b4ddd","SalesOrderGrandTotal":100.0,"SalesGrandTotal":115.0,"OrderTime":"2024-04-13 13:15:40.133886","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"a20c8c7e-4b4d-43f3-b72f-ce628b92a515","title":"Tb2","description":"","PriceCategory":"None","Status":"Ordered","priceid":"","SalesOrderID":"b8fb4b03-b2d3-48ac-b54c-2df2d96ece63","SalesMasterID":"cd1c0cdc-ca24-42ce-955c-bec30aad5577","SalesOrderGrandTotal":648.6,"SalesGrandTotal":115.0,"OrderTime":"2024-05-14 16:06:41.959273","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"43af78be-be39-4834-a8fd-6e250d413182","title":"Tb","description":"","PriceCategory":"None","Status":"Ordered","priceid":"","SalesOrderID":"2687a92f-b73e-4ded-b9a2-1ee27060df8c","SalesMasterID":"bc0bd281-79e1-40c8-96c2-e5207b8a7138","SalesOrderGrandTotal":115.0,"SalesGrandTotal":17.06,"OrderTime":"2024-05-14 16:44:42.102970","IsActive":true,"IsReserved":true,"reserved":[{"Table":"43af78be-be39-4834-a8fd-6e250d413182","CustomerName":"saadc","Date":"2024-05-16","FromTime":"00:58:00","ToTime":"16:58:00"}]},{"id":"81e7d306-d6bb-4d99-99fb-b01131d63f9b","title":"Ta","description":"","PriceCategory":"None","Status":"Ordered","priceid":"","SalesOrderID":"d8ee32d3-319d-451b-bad0-8773907d82bd","SalesMasterID":"f1a478f3-0aa7-4ffc-8824-a73ac48195d5","SalesOrderGrandTotal":20.7,"SalesGrandTotal":25.94,"OrderTime":"2024-05-14 17:09:08.495158","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"aa863c61-a494-4653-aca8-ace79c2ec9de","title":"Tb5","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"9d56dec4-e010-448a-a5fd-dd290a565240","SalesMasterID":"821b94b4-9fa4-4ea7-9afc-7737ebaa39dc","SalesOrderGrandTotal":29.83060411,"SalesGrandTotal":171.53,"OrderTime":"2024-04-13 17:16:23.134109","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"ec682d7e-86c7-4bfa-8580-292833727777","title":"Tb8","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"c8bc29ae-8e58-461d-ab46-175a5758af20","SalesMasterID":"874d9662-fd49-4035-aea2-79044da042ac","SalesOrderGrandTotal":1338.6,"SalesGrandTotal":230.0,"OrderTime":"2024-04-13 16:57:17.764905","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"9b365551-d7bf-415a-80e2-a1c0febc067f","title":"Tb65","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"6942a442-7d41-4602-9226-226a964fe7ae","SalesMasterID":"e9f45f17-eb5c-4529-bb42-13be9ef2905c","SalesOrderGrandTotal":374.83060411,"SalesGrandTotal":25.94,"OrderTime":"2024-04-13 17:13:32.081301","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"431d092d-9499-41dc-beb0-50a75a5d6e92","title":"Tb43","description":"Standard","PriceCategory":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","Status":"Vacant","priceid":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","SalesOrderID":"a2e9dcc4-90fb-4714-beb2-12fae3ad3243","SalesMasterID":"df4c3c04-6369-4058-abeb-2e4a1fcf0c78","SalesOrderGrandTotal":228.33060411,"SalesGrandTotal":150.0,"OrderTime":"2024-04-13 17:15:41.188126","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"2a186c45-ac63-4a62-b369-ce56aae1f035","title":"Tb12","description":"Standard","PriceCategory":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","Status":"Vacant","priceid":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","SalesOrderID":"546a635d-7638-4fc7-a10e-4fdf1f8a7d09","SalesMasterID":"71b34514-2edc-4a0b-93fe-d26032b64196","SalesOrderGrandTotal":23.01,"SalesGrandTotal":648.6,"OrderTime":"2024-04-16 13:20:36.408721","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"3ace28e7-51ef-47d8-bba2-36b71144da90","title":"3434","description":"Standard","PriceCategory":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","Status":"Vacant","priceid":"2e61b8bd-4e0f-47c6-8325-ca14fa2c8320","SalesOrderID":"ebc4f510-fe99-4579-a6dd-b81cb20ecf42","SalesMasterID":"ec27f234-a756-411d-bed2-b1b17254758a","SalesOrderGrandTotal":21.85,"SalesGrandTotal":21.85,"OrderTime":"2023-12-31 08:20:14.673450","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"91cf094f-dadc-41f9-b447-f626d5694efd","title":"Df","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"640fdcb5-a6f4-46e6-9a14-dc11e59d2f86","SalesMasterID":"09bad043-ec7d-4ea3-9f93-70e01a871a77","SalesOrderGrandTotal":179.83060411,"SalesGrandTotal":230.0,"OrderTime":"2024-04-13 17:30:15.999971","IsActive":true,"IsReserved":true,"reserved":[]},{"id":"e8c4db55-0c91-4c45-90f8-e480ddb2a43c","title":"df","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"a7603280-ba34-460b-819a-6f57c51eb679","SalesMasterID":"b9a726a1-4c3e-4e06-a6de-06c01e451a48","SalesOrderGrandTotal":21.85,"SalesGrandTotal":869.83,"OrderTime":"2023-12-30 01:51:07.751136","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"d2028a56-37c0-4bd2-839b-c59bf003279a","title":"Th","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"","SalesMasterID":"1e5c2d8f-92ae-4483-a9a5-b913edc260a3","SalesOrderGrandTotal":0.0,"SalesGrandTotal":65.0,"OrderTime":"","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"96a9360d-9e6f-4890-b209-8fe182d74fd2","title":"Table","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"cb39cac8-ea3c-41df-8a04-8e8b107b0852","SalesMasterID":"","SalesOrderGrandTotal":275.0,"SalesGrandTotal":0.0,"OrderTime":"2023-12-30 11:57:01.976572","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"411d2e31-65c2-4f28-b61d-068399201f63","title":"Demo","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"3f7686f3-54c7-4c66-889e-81694ca57fbb","SalesMasterID":"","SalesOrderGrandTotal":71.0,"SalesGrandTotal":0.0,"OrderTime":"2024-01-05 13:05:23.394117","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"fec33663-5190-4058-914a-cabe37601357","title":"Tby","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"9eda6d57-cc44-49df-8306-4ed3f7f3b5e2","SalesMasterID":"30a91362-ffdb-437f-b510-2dd579d43477","SalesOrderGrandTotal":25.0,"SalesGrandTotal":60.0,"OrderTime":"2023-12-30 12:10:16.707054","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"cb30c711-2dd9-4665-8285-a3cb61e541c2","title":"Vacant House","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"","SalesMasterID":"","SalesOrderGrandTotal":0.0,"SalesGrandTotal":0.0,"OrderTime":"","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"44cb2316-0b55-40ba-87cf-2d5e210b3403","title":"VVIP Table","description":"","PriceCategory":"None","Status":"Paid","priceid":"","SalesOrderID":"","SalesMasterID":"ff6dd9b8-9e05-40ec-bfc3-31fa8e4fa1bb","SalesOrderGrandTotal":0.0,"SalesGrandTotal":179.83,"OrderTime":"","IsActive":true,"IsReserved":false,"reserved":[]},{"id":"71c415bb-4dc7-455e-b8f7-660d30b02062","title":"Drr","description":"","PriceCategory":"None","Status":"Vacant","priceid":"","SalesOrderID":"","SalesMasterID":"8b26e9fd-b83e-49f0-a44b-32249d521cf4","SalesOrderGrandTotal":0.0,"SalesGrandTotal":138.25,"OrderTime":"","IsActive":true,"IsReserved":false,"reserved":[]}]
/// Online : [{"SalesOrderID":"686afd20-84ad-425d-9f28-7319329ab847","SalesID":"","CustomerName":"walk in customer","TokenNumber":"006","Phone":"","Status":"Ordered","SalesOrderGrandTotal":"14.83108237","SalesGrandTotal":"","OrderTime":"2024-05-16 12:16:50.367527"},{"SalesOrderID":"f135cb30-5224-4d0a-a210-bd6b69d3dbf0","SalesID":"6e234756-4087-4189-9cc1-6aeb8767532c","CustomerName":"walk in customer","TokenNumber":"005","Phone":"","Status":"Paid","SalesOrderGrandTotal":"103.00000000","SalesGrandTotal":"103.00000000","OrderTime":"2024-05-16 12:16:38.708038"}]
/// TakeAway : [{"SalesOrderID":"ef78d052-2149-4537-817c-fbf77e0eb657","SalesID":"4a2c84ac-1ad3-4cac-a411-ea2963461aa5","CustomerName":"walk in customer","TokenNumber":"003","Phone":"","Status":"Paid","SalesOrderGrandTotal":"20.70000000","SalesGrandTotal":"20.70000000","OrderTime":"2024-05-16 12:03:42.253454"},{"SalesOrderID":"9ccbd0a7-c849-4c16-90bc-21852359594c","SalesID":"","CustomerName":"walk in customer","TokenNumber":"001","Phone":"","Status":"Ordered","SalesOrderGrandTotal":"309.00000000","SalesGrandTotal":"","OrderTime":"2024-05-16 12:03:29.268489"},{"SalesOrderID":"b8dd6cfa-9628-436f-9449-a2f8c99ba9cc","SalesID":"","CustomerName":"walk in customer","TokenNumber":"001","Phone":"","Status":"Ordered","SalesOrderGrandTotal":"564.00000000","SalesGrandTotal":"","OrderTime":"2024-05-15 13:30:26.628325"}]
/// Car : [{"SalesOrderID":"e86c26a8-e17f-4ced-aab3-ea4cd118b8a1","SalesID":"d85ba2b1-8b59-44ba-ae8a-0c82ebd4ae4e","CustomerName":"walk in customer","TokenNumber":"004","Phone":"","Status":"Paid","SalesOrderGrandTotal":"17.05574472","SalesGrandTotal":"17.06000000","OrderTime":"2024-05-16 12:03:56.166097"},{"SalesOrderID":"e1e580eb-83db-4665-9cdc-50e323d8cae7","SalesID":"","CustomerName":"walk in customer","TokenNumber":"002","Phone":"","Status":"Ordered","SalesOrderGrandTotal":"103.00000000","SalesGrandTotal":"","OrderTime":"2024-05-16 12:03:34.412489"}]
/// DiningStatusCode : 6000
/// OnlineStatusCode : 6000
/// TakeAwayStatusCode : 6000
/// CarStatusCode : 6000
/// Reasons : [{"id":"5f9a31c1-0dc3-4d07-841d-5ea4b55d41ad","BranchID":1,"Reason":"Reason1"},{"id":"b9b6fffe-6087-41aa-a41f-dfee519ef8e2","BranchID":1,"Reason":"Reason3"},{"id":"b9c199ce-3c19-401b-a9b5-f452580ff343","BranchID":1,"Reason":"123"},{"id":"df9d35a5-1738-407d-9a32-e40de64ae8a7","BranchID":1,"Reason":"3."},{"id":"e4f0f318-15ca-445c-8d60-f3ebdcf44977","BranchID":1,"Reason":"Reason2"},{"id":"ec2c7909-4045-49af-8e2f-2db9aaf96df3","BranchID":1,"Reason":"Reasio"}]
/// Edition : "Professional"
/// ExpiryDate : "2029-03-14"

PosListModel posListModelFromJson(String str) => PosListModel.fromJson(json.decode(str));
String posListModelToJson(PosListModel data) => json.encode(data.toJson());
class PosListModel {
  PosListModel({
      int? statusCode, 
      List<Data>? data, 
      List<Online>? online, 
      List<TakeAway>? takeAway, 
      List<Car>? car, 
      int? diningStatusCode, 
      int? onlineStatusCode, 
      int? takeAwayStatusCode, 
      int? carStatusCode, 
      List<Reasons>? reasons, 
      String? edition, 
      String? expiryDate,}){
    _statusCode = statusCode;
    _data = data;
    _online = online;
    _takeAway = takeAway;
    _car = car;
    _diningStatusCode = diningStatusCode;
    _onlineStatusCode = onlineStatusCode;
    _takeAwayStatusCode = takeAwayStatusCode;
    _carStatusCode = carStatusCode;
    _reasons = reasons;
    _edition = edition;
    _expiryDate = expiryDate;
}

  PosListModel.fromJson(dynamic json) {
    _statusCode = json['StatusCode'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    if (json['Online'] != null) {
      _online = [];
      json['Online'].forEach((v) {
        _online?.add(Online.fromJson(v));
      });
    }
    if (json['TakeAway'] != null) {
      _takeAway = [];
      json['TakeAway'].forEach((v) {
        _takeAway?.add(TakeAway.fromJson(v));
      });
    }
    if (json['Car'] != null) {
      _car = [];
      json['Car'].forEach((v) {
        _car?.add(Car.fromJson(v));
      });
    }
    _diningStatusCode = json['DiningStatusCode'];
    _onlineStatusCode = json['OnlineStatusCode'];
    _takeAwayStatusCode = json['TakeAwayStatusCode'];
    _carStatusCode = json['CarStatusCode'];
    if (json['Reasons'] != null) {
      _reasons = [];
      json['Reasons'].forEach((v) {
        _reasons?.add(Reasons.fromJson(v));
      });
    }
    _edition = json['Edition'];
    _expiryDate = json['ExpiryDate'];
  }
  int? _statusCode;
  List<Data>? _data;
  List<Online>? _online;
  List<TakeAway>? _takeAway;
  List<Car>? _car;
  int? _diningStatusCode;
  int? _onlineStatusCode;
  int? _takeAwayStatusCode;
  int? _carStatusCode;
  List<Reasons>? _reasons;
  String? _edition;
  String? _expiryDate;
PosListModel copyWith({  int? statusCode,
  List<Data>? data,
  List<Online>? online,
  List<TakeAway>? takeAway,
  List<Car>? car,
  int? diningStatusCode,
  int? onlineStatusCode,
  int? takeAwayStatusCode,
  int? carStatusCode,
  List<Reasons>? reasons,
  String? edition,
  String? expiryDate,
}) => PosListModel(  statusCode: statusCode ?? _statusCode,
  data: data ?? _data,
  online: online ?? _online,
  takeAway: takeAway ?? _takeAway,
  car: car ?? _car,
  diningStatusCode: diningStatusCode ?? _diningStatusCode,
  onlineStatusCode: onlineStatusCode ?? _onlineStatusCode,
  takeAwayStatusCode: takeAwayStatusCode ?? _takeAwayStatusCode,
  carStatusCode: carStatusCode ?? _carStatusCode,
  reasons: reasons ?? _reasons,
  edition: edition ?? _edition,
  expiryDate: expiryDate ?? _expiryDate,
);
  int? get statusCode => _statusCode;
  List<Data>? get data => _data;
  List<Online>? get online => _online;
  List<TakeAway>? get takeAway => _takeAway;
  List<Car>? get car => _car;
  int? get diningStatusCode => _diningStatusCode;
  int? get onlineStatusCode => _onlineStatusCode;
  int? get takeAwayStatusCode => _takeAwayStatusCode;
  int? get carStatusCode => _carStatusCode;
  List<Reasons>? get reasons => _reasons;
  String? get edition => _edition;
  String? get expiryDate => _expiryDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StatusCode'] = _statusCode;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_online != null) {
      map['Online'] = _online?.map((v) => v.toJson()).toList();
    }
    if (_takeAway != null) {
      map['TakeAway'] = _takeAway?.map((v) => v.toJson()).toList();
    }
    if (_car != null) {
      map['Car'] = _car?.map((v) => v.toJson()).toList();
    }
    map['DiningStatusCode'] = _diningStatusCode;
    map['OnlineStatusCode'] = _onlineStatusCode;
    map['TakeAwayStatusCode'] = _takeAwayStatusCode;
    map['CarStatusCode'] = _carStatusCode;
    if (_reasons != null) {
      map['Reasons'] = _reasons?.map((v) => v.toJson()).toList();
    }
    map['Edition'] = _edition;
    map['ExpiryDate'] = _expiryDate;
    return map;
  }

}

/// id : "5f9a31c1-0dc3-4d07-841d-5ea4b55d41ad"
/// BranchID : 1
/// Reason : "Reason1"

Reasons reasonsFromJson(String str) => Reasons.fromJson(json.decode(str));
String reasonsToJson(Reasons data) => json.encode(data.toJson());
class Reasons {
  Reasons({
      String? id, 
      int? branchID, 
      String? reason,}){
    _id = id;
    _branchID = branchID;
    _reason = reason;
}

  Reasons.fromJson(dynamic json) {
    _id = json['id'];
    _branchID = json['BranchID'];
    _reason = json['Reason'];
  }
  String? _id;
  int? _branchID;
  String? _reason;
Reasons copyWith({  String? id,
  int? branchID,
  String? reason,
}) => Reasons(  id: id ?? _id,
  branchID: branchID ?? _branchID,
  reason: reason ?? _reason,
);
  String? get id => _id;
  int? get branchID => _branchID;
  String? get reason => _reason;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['BranchID'] = _branchID;
    map['Reason'] = _reason;
    return map;
  }

}

/// SalesOrderID : "e86c26a8-e17f-4ced-aab3-ea4cd118b8a1"
/// SalesID : "d85ba2b1-8b59-44ba-ae8a-0c82ebd4ae4e"
/// CustomerName : "walk in customer"
/// TokenNumber : "004"
/// Phone : ""
/// Status : "Paid"
/// SalesOrderGrandTotal : "17.05574472"
/// SalesGrandTotal : "17.06000000"
/// OrderTime : "2024-05-16 12:03:56.166097"

Car carFromJson(String str) => Car.fromJson(json.decode(str));
String carToJson(Car data) => json.encode(data.toJson());
class Car {
  Car({
      String? salesOrderID, 
      String? salesID, 
      String? customerName, 
      String? tokenNumber, 
      String? phone, 
      String? status, 
      String? salesOrderGrandTotal, 
      String? salesGrandTotal, 
      String? orderTime,}){
    _salesOrderID = salesOrderID;
    _salesID = salesID;
    _customerName = customerName;
    _tokenNumber = tokenNumber;
    _phone = phone;
    _status = status;
    _salesOrderGrandTotal = salesOrderGrandTotal;
    _salesGrandTotal = salesGrandTotal;
    _orderTime = orderTime;
}

  Car.fromJson(dynamic json) {
    _salesOrderID = json['SalesOrderID'];
    _salesID = json['SalesID'];
    _customerName = json['CustomerName'];
    _tokenNumber = json['TokenNumber'];
    _phone = json['Phone'];
    _status = json['Status'];
    _salesOrderGrandTotal = json['SalesOrderGrandTotal'];
    _salesGrandTotal = json['SalesGrandTotal'];
    _orderTime = json['OrderTime'];
  }
  String? _salesOrderID;
  String? _salesID;
  String? _customerName;
  String? _tokenNumber;
  String? _phone;
  String? _status;
  String? _salesOrderGrandTotal;
  String? _salesGrandTotal;
  String? _orderTime;
Car copyWith({  String? salesOrderID,
  String? salesID,
  String? customerName,
  String? tokenNumber,
  String? phone,
  String? status,
  String? salesOrderGrandTotal,
  String? salesGrandTotal,
  String? orderTime,
}) => Car(  salesOrderID: salesOrderID ?? _salesOrderID,
  salesID: salesID ?? _salesID,
  customerName: customerName ?? _customerName,
  tokenNumber: tokenNumber ?? _tokenNumber,
  phone: phone ?? _phone,
  status: status ?? _status,
  salesOrderGrandTotal: salesOrderGrandTotal ?? _salesOrderGrandTotal,
  salesGrandTotal: salesGrandTotal ?? _salesGrandTotal,
  orderTime: orderTime ?? _orderTime,
);
  String? get salesOrderID => _salesOrderID;
  String? get salesID => _salesID;
  String? get customerName => _customerName;
  String? get tokenNumber => _tokenNumber;
  String? get phone => _phone;
  String? get status => _status;
  String? get salesOrderGrandTotal => _salesOrderGrandTotal;
  String? get salesGrandTotal => _salesGrandTotal;
  String? get orderTime => _orderTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SalesOrderID'] = _salesOrderID;
    map['SalesID'] = _salesID;
    map['CustomerName'] = _customerName;
    map['TokenNumber'] = _tokenNumber;
    map['Phone'] = _phone;
    map['Status'] = _status;
    map['SalesOrderGrandTotal'] = _salesOrderGrandTotal;
    map['SalesGrandTotal'] = _salesGrandTotal;
    map['OrderTime'] = _orderTime;
    return map;
  }

}

/// SalesOrderID : "ef78d052-2149-4537-817c-fbf77e0eb657"
/// SalesID : "4a2c84ac-1ad3-4cac-a411-ea2963461aa5"
/// CustomerName : "walk in customer"
/// TokenNumber : "003"
/// Phone : ""
/// Status : "Paid"
/// SalesOrderGrandTotal : "20.70000000"
/// SalesGrandTotal : "20.70000000"
/// OrderTime : "2024-05-16 12:03:42.253454"

TakeAway takeAwayFromJson(String str) => TakeAway.fromJson(json.decode(str));
String takeAwayToJson(TakeAway data) => json.encode(data.toJson());
class TakeAway {
  TakeAway({
      String? salesOrderID, 
      String? salesID, 
      String? customerName, 
      String? tokenNumber, 
      String? phone, 
      String? status, 
      String? salesOrderGrandTotal, 
      String? salesGrandTotal, 
      String? orderTime,}){
    _salesOrderID = salesOrderID;
    _salesID = salesID;
    _customerName = customerName;
    _tokenNumber = tokenNumber;
    _phone = phone;
    _status = status;
    _salesOrderGrandTotal = salesOrderGrandTotal;
    _salesGrandTotal = salesGrandTotal;
    _orderTime = orderTime;
}

  TakeAway.fromJson(dynamic json) {
    _salesOrderID = json['SalesOrderID'];
    _salesID = json['SalesID'];
    _customerName = json['CustomerName'];
    _tokenNumber = json['TokenNumber'];
    _phone = json['Phone'];
    _status = json['Status'];
    _salesOrderGrandTotal = json['SalesOrderGrandTotal'];
    _salesGrandTotal = json['SalesGrandTotal'];
    _orderTime = json['OrderTime'];
  }
  String? _salesOrderID;
  String? _salesID;
  String? _customerName;
  String? _tokenNumber;
  String? _phone;
  String? _status;
  String? _salesOrderGrandTotal;
  String? _salesGrandTotal;
  String? _orderTime;
TakeAway copyWith({  String? salesOrderID,
  String? salesID,
  String? customerName,
  String? tokenNumber,
  String? phone,
  String? status,
  String? salesOrderGrandTotal,
  String? salesGrandTotal,
  String? orderTime,
}) => TakeAway(  salesOrderID: salesOrderID ?? _salesOrderID,
  salesID: salesID ?? _salesID,
  customerName: customerName ?? _customerName,
  tokenNumber: tokenNumber ?? _tokenNumber,
  phone: phone ?? _phone,
  status: status ?? _status,
  salesOrderGrandTotal: salesOrderGrandTotal ?? _salesOrderGrandTotal,
  salesGrandTotal: salesGrandTotal ?? _salesGrandTotal,
  orderTime: orderTime ?? _orderTime,
);
  String? get salesOrderID => _salesOrderID;
  String? get salesID => _salesID;
  String? get customerName => _customerName;
  String? get tokenNumber => _tokenNumber;
  String? get phone => _phone;
  String? get status => _status;
  String? get salesOrderGrandTotal => _salesOrderGrandTotal;
  String? get salesGrandTotal => _salesGrandTotal;
  String? get orderTime => _orderTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SalesOrderID'] = _salesOrderID;
    map['SalesID'] = _salesID;
    map['CustomerName'] = _customerName;
    map['TokenNumber'] = _tokenNumber;
    map['Phone'] = _phone;
    map['Status'] = _status;
    map['SalesOrderGrandTotal'] = _salesOrderGrandTotal;
    map['SalesGrandTotal'] = _salesGrandTotal;
    map['OrderTime'] = _orderTime;
    return map;
  }

}

/// SalesOrderID : "686afd20-84ad-425d-9f28-7319329ab847"
/// SalesID : ""
/// CustomerName : "walk in customer"
/// TokenNumber : "006"
/// Phone : ""
/// Status : "Ordered"
/// SalesOrderGrandTotal : "14.83108237"
/// SalesGrandTotal : ""
/// OrderTime : "2024-05-16 12:16:50.367527"

Online onlineFromJson(String str) => Online.fromJson(json.decode(str));
String onlineToJson(Online data) => json.encode(data.toJson());
class Online {
  Online({
      String? salesOrderID, 
      String? salesID, 
      String? customerName, 
      String? tokenNumber, 
      String? phone, 
      String? status, 
      String? salesOrderGrandTotal, 
      String? salesGrandTotal, 
      String? orderTime,}){
    _salesOrderID = salesOrderID;
    _salesID = salesID;
    _customerName = customerName;
    _tokenNumber = tokenNumber;
    _phone = phone;
    _status = status;
    _salesOrderGrandTotal = salesOrderGrandTotal;
    _salesGrandTotal = salesGrandTotal;
    _orderTime = orderTime;
}

  Online.fromJson(dynamic json) {
    _salesOrderID = json['SalesOrderID'];
    _salesID = json['SalesID'];
    _customerName = json['CustomerName'];
    _tokenNumber = json['TokenNumber'];
    _phone = json['Phone'];
    _status = json['Status'];
    _salesOrderGrandTotal = json['SalesOrderGrandTotal'];
    _salesGrandTotal = json['SalesGrandTotal'];
    _orderTime = json['OrderTime'];
  }
  String? _salesOrderID;
  String? _salesID;
  String? _customerName;
  String? _tokenNumber;
  String? _phone;
  String? _status;
  String? _salesOrderGrandTotal;
  String? _salesGrandTotal;
  String? _orderTime;
Online copyWith({  String? salesOrderID,
  String? salesID,
  String? customerName,
  String? tokenNumber,
  String? phone,
  String? status,
  String? salesOrderGrandTotal,
  String? salesGrandTotal,
  String? orderTime,
}) => Online(  salesOrderID: salesOrderID ?? _salesOrderID,
  salesID: salesID ?? _salesID,
  customerName: customerName ?? _customerName,
  tokenNumber: tokenNumber ?? _tokenNumber,
  phone: phone ?? _phone,
  status: status ?? _status,
  salesOrderGrandTotal: salesOrderGrandTotal ?? _salesOrderGrandTotal,
  salesGrandTotal: salesGrandTotal ?? _salesGrandTotal,
  orderTime: orderTime ?? _orderTime,
);
  String? get salesOrderID => _salesOrderID;
  String? get salesID => _salesID;
  String? get customerName => _customerName;
  String? get tokenNumber => _tokenNumber;
  String? get phone => _phone;
  String? get status => _status;
  String? get salesOrderGrandTotal => _salesOrderGrandTotal;
  String? get salesGrandTotal => _salesGrandTotal;
  String? get orderTime => _orderTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SalesOrderID'] = _salesOrderID;
    map['SalesID'] = _salesID;
    map['CustomerName'] = _customerName;
    map['TokenNumber'] = _tokenNumber;
    map['Phone'] = _phone;
    map['Status'] = _status;
    map['SalesOrderGrandTotal'] = _salesOrderGrandTotal;
    map['SalesGrandTotal'] = _salesGrandTotal;
    map['OrderTime'] = _orderTime;
    return map;
  }

}

/// id : "78847d45-02da-4cf9-94dc-5ef37d65ad44"
/// title : "Tb 1"
/// description : ""
/// PriceCategory : "None"
/// Status : "Paid"
/// priceid : ""
/// SalesOrderID : "18751ef9-3838-46d4-831c-7f3e9bb35dca"
/// SalesMasterID : "ff9b945a-8220-42b8-87ab-56af7b4b4ddd"
/// SalesOrderGrandTotal : 100.0
/// SalesGrandTotal : 115.0
/// OrderTime : "2024-04-13 13:15:40.133886"
/// IsActive : true
/// IsReserved : true
/// reserved : []

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String? id, 
      String? title, 
      String? description, 
      String? priceCategory, 
      String? status, 
      String? priceid, 
      String? salesOrderID, 
      String? salesMasterID, 
      String? salesOrderGrandTotal,
      String? salesGrandTotal,
      String? orderTime, 
      bool? isActive, 
      bool? isReserved,

      List<dynamic>? reserved,}){
    _id = id;
    _title = title;
    _description = description;
    _priceCategory = priceCategory;
    _status = status;
    _priceid = priceid;
    _salesOrderID = salesOrderID;
    _salesMasterID = salesMasterID;
    _salesOrderGrandTotal = salesOrderGrandTotal;
    _salesGrandTotal = salesGrandTotal;
    _orderTime = orderTime;
    _isActive = isActive;
    _isReserved = isReserved;
    _reserved = reserved;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _description = json['description'];
    _priceCategory = json['PriceCategory'];
    _status = json['Status'];
    _priceid = json['priceid'];
    _salesOrderID = json['SalesOrderID'];
    _salesMasterID = json['SalesMasterID'];
    _salesOrderGrandTotal = json['SalesOrderGrandTotal'].toString();
    _salesGrandTotal = json['SalesGrandTotal'].toString();
    _orderTime = json['OrderTime'];
    _isActive = json['IsActive'];
    _isReserved = json['IsReserved'];
    _reserved = json['reserved'];
    // if (json['reserved'] != null) {
    //   _reserved = [];
    //   json['reserved'].forEach((v) {
    //     _reserved?.add(Dynamic.fromJson(v));
    //   });
    // }
  }
  String? _id;
  String? _title;
  String? _description;
  String? _priceCategory;
  String? _status;
  String? _priceid;
  String? _salesOrderID;
  String? _salesMasterID;
  String? _salesOrderGrandTotal;
  String? _salesGrandTotal;
  String? _orderTime;
  bool? _isActive;
  bool? _isReserved;
  List<dynamic>? _reserved;
Data copyWith({  String? id,
  String? title,
  String? description,
  String? priceCategory,
  String? status,
  String? priceid,
  String? salesOrderID,
  String? salesMasterID,
  String? salesOrderGrandTotal,
  String? salesGrandTotal,
  String? orderTime,
  bool? isActive,
  bool? isReserved,
  List<dynamic>? reserved,
}) => Data(  id: id ?? _id,
  title: title ?? _title,
  description: description ?? _description,
  priceCategory: priceCategory ?? _priceCategory,
  status: status ?? _status,
  priceid: priceid ?? _priceid,
  salesOrderID: salesOrderID ?? _salesOrderID,
  salesMasterID: salesMasterID ?? _salesMasterID,
  salesOrderGrandTotal: salesOrderGrandTotal ?? _salesOrderGrandTotal,
  salesGrandTotal: salesGrandTotal ?? _salesGrandTotal,
  orderTime: orderTime ?? _orderTime,
  isActive: isActive ?? _isActive,
  isReserved: isReserved ?? _isReserved,
  reserved: reserved ?? _reserved,
);
  String? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get priceCategory => _priceCategory;
  String? get status => _status;
  String? get priceid => _priceid;
  String? get salesOrderID => _salesOrderID;
  String? get salesMasterID => _salesMasterID;
  String? get salesOrderGrandTotal => _salesOrderGrandTotal;
  String? get salesGrandTotal => _salesGrandTotal;
  String? get orderTime => _orderTime;
  bool? get isActive => _isActive;
  bool? get isReserved => _isReserved;
  List<dynamic>? get reserved => _reserved;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    map['PriceCategory'] = _priceCategory;
    map['Status'] = _status;
    map['priceid'] = _priceid;
    map['SalesOrderID'] = _salesOrderID;
    map['SalesMasterID'] = _salesMasterID;
    map['SalesOrderGrandTotal'] = _salesOrderGrandTotal;
    map['SalesGrandTotal'] = _salesGrandTotal;
    map['OrderTime'] = _orderTime;
    map['IsActive'] = _isActive;
    map['IsReserved'] = _isReserved;
    if (_reserved != null) {
      map['reserved'] = _reserved?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}