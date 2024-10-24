class InvoiceModelClass {
  String id,
      voucherNo,
      saleOrderID,
      date,
      deliveryDate,
      deliveryTime,
      custName,
      netTotal,
      salesMasterID,
      tokenNo;
  var salesData;

  InvoiceModelClass(
      {required this.id,
      required this.voucherNo,
      required this.saleOrderID,
      required this.date,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.salesMasterID,
      required this.salesData,
      required this.custName,
      required this.netTotal,
      required this.tokenNo});

  factory InvoiceModelClass.fromJson(Map<dynamic, dynamic> json) {
    return InvoiceModelClass(
        id: json['id'],
        voucherNo: json['VoucherNo'],
        saleOrderID: json['SalesOrderMasterID'].toString(),
        date: json['Date'],
        deliveryDate: json['DeliveryDate'],
        deliveryTime: json['DeliveryTime'],
        salesData: json['SalesData'],
        custName: json['CustomerName'],
        netTotal: json['NetTotal'],
        salesMasterID: json['SalesMasterID'] ?? '',
        tokenNo: json['TokenNumber'].toString());
  }
}
