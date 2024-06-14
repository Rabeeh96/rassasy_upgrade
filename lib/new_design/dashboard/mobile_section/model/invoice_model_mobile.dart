
class InvoiceModelMobileClass {
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

  InvoiceModelMobileClass(
      {required this.id,
        required this.voucherNo,
        required this.saleOrderID,
        required this.date,
        required this.deliveryDate,
        required this.deliveryTime,
        required this.salesMasterID,
        required this.custName,
        required this.netTotal,
        required this.tokenNo});

  factory InvoiceModelMobileClass.fromJson(Map<dynamic, dynamic> json) {
    return InvoiceModelMobileClass(
        id: json['id'],
        voucherNo: json['VoucherNo'],
        saleOrderID: json['SalesOrderMasterID'].toString(),
        date: json['Date'],
        deliveryDate: json['DeliveryDate'],
        deliveryTime: json['DeliveryTime'],
        custName: json['CustomerName'],
        netTotal: json['NetTotal'],
        salesMasterID: json['SalesMasterID']??'',
        tokenNo: json['TokenNumber']);
  }
}
