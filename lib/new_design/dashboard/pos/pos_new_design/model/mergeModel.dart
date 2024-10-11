class MergeData {
  String? id;
  List<dynamic>? splitData;
  String? salesOrderID;
  String? salesMasterID;
  String? salesOrderGrandTotal;
  String? salesGrandTotal;
  String? orderTime;
  String? priceCategory;
  int? branchID;
  String? tableName;
  String? status;
  int? position;
  bool? isActive;
  bool? isReserved;
  String? companyID;
  List<dynamic>? mergedWith;

  MergeData(
      {this.id,
      this.splitData,
      this.salesOrderID,
      this.salesMasterID,
      this.salesOrderGrandTotal,
      this.salesGrandTotal,
      this.orderTime,
      this.priceCategory,
      this.branchID,
      this.tableName,
      this.status,
      this.position,
      this.isActive,
      this.isReserved,
      this.companyID,
      this.mergedWith});

  MergeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // if (json['Split_data'] != null) {
    //   splitData = <Null>[];
    //   json['Split_data'].forEach((v) {
    //     splitData!.add(Null.fromJson(v));
    //   });
    // }
    splitData = json['Split_data'];
    salesOrderID = json['SalesOrderID'];
    salesMasterID = json['SalesMasterID'];
    salesOrderGrandTotal = json['SalesOrderGrandTotal'].toString();
    salesGrandTotal = json['SalesGrandTotal'].toString();
    orderTime = json['OrderTime'];
    priceCategory = json['PriceCategory'];
    branchID = json['BranchID'];
    tableName = json['TableName'];
    status = json['Status'];
    position = json['Position'];
    isActive = json['IsActive'];
    isReserved = json['IsReserved'];
    companyID = json['CompanyID'];
    mergedWith = json['MergedWith'];

    // if (json['MergedWith'] != null) {
    //   mergedWith = <Null>[];
    //   json['MergedWith'].forEach((v) {
    //     mergedWith!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (splitData != null) {
      data['Split_data'] = splitData?.map((v) => v.toJson()).toList();
    }

    data['SalesOrderID'] = salesOrderID;
    data['SalesMasterID'] = salesMasterID;
    data['SalesOrderGrandTotal'] = salesOrderGrandTotal;
    data['SalesGrandTotal'] = salesGrandTotal;
    data['OrderTime'] = orderTime;
    data['PriceCategory'] = priceCategory;
    data['BranchID'] = branchID;
    data['TableName'] = tableName;
    data['Status'] = status;
    data['Position'] = position;
    data['IsActive'] = isActive;
    data['IsReserved'] = isReserved;
    data['CompanyID'] = companyID;
    if (mergedWith != null) {
      data['MergedWith'] = mergedWith!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
