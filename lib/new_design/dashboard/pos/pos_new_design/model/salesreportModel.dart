// class SalesreportModel {
//   int? statusCode;
//   List<Data>? data;
//   SumValues? sumValues;

//   SalesreportModel({this.statusCode, this.data, this.sumValues});

//   SalesreportModel.fromJson(Map<String, dynamic> json) {
//     // statusCode = json['StatusCode'];
//     // data = json['data'];
//     // // if (json['data'] != null) {
//     // //   data = <Data>[];
//     // //   json['data'].forEach((v) {
//     // //     data!.add(Data.fromJson(v));
//     // //   });
//     // // }
//     // sumValues = json['sum_values'] != null
//     //     ? SumValues.fromJson(json['sum_values'])
//     //     : null;
//     statusCode = json['StatusCode'];
//     data = (json['data'] as List?)?.map((item) => Data.fromJson(item)).toList();
//     sumValues = json['sum_values'] != null
//         ? SumValues.fromJson(json['sum_values'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['StatusCode'] = statusCode;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     if (sumValues != null) {
//       data['sum_values'] = sumValues!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   int? index;
//   String? id;
//   String? taxType;
//   String? billDiscAmt;
//   String? totalGrossAmt;
//   String? totalTax;
//   String? voucherNo;
//   String? date;
//   String? tokenNumber;
//   String? customerName;
//   String? grandTotal;
//   String? cashSale;
//   String? bankSale;
//   String? tableName;
//   String? creditSale;

//   Data(
//       {this.index,
//       this.id,
//       this.taxType,
//       this.billDiscAmt,
//       this.totalGrossAmt,
//       this.totalTax,
//       this.voucherNo,
//       this.date,
//       this.tokenNumber,
//       this.customerName,
//       this.grandTotal,
//       this.cashSale,
//       this.bankSale,
//       this.tableName,
//       this.creditSale});

//   Data.fromJson(Map<String, dynamic> json) {
//     index = json['index'];
//     id = json['id'].toString();
//     taxType = json['TaxType'];
//     billDiscAmt = json['BillDiscAmt'].toString();
//     totalGrossAmt = json['TotalGrossAmt'].toString();
//     totalTax = json['TotalTax'].toString();
//     voucherNo = json['VoucherNo'].toString();
//     date = json['Date'].toString();
//     tokenNumber = json['TokenNumber'].toString();
//     customerName = json['CustomerName'];
//     grandTotal = json['GrandTotal'].toString();
//     cashSale = json['CashSale'].toString();
//     bankSale = json['BankSale'].toString();
//     tableName = json['TableName'];
//     creditSale = json['CreditSale'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['index'] = index;
//     data['id'] = id;
//     data['TaxType'] = taxType;
//     data['BillDiscAmt'] = billDiscAmt;
//     data['TotalGrossAmt'] = totalGrossAmt;
//     data['TotalTax'] = totalTax;
//     data['VoucherNo'] = voucherNo;
//     data['Date'] = date;
//     data['TokenNumber'] = tokenNumber;
//     data['CustomerName'] = customerName;
//     data['GrandTotal'] = grandTotal;
//     data['CashSale'] = cashSale;
//     data['BankSale'] = bankSale;
//     data['TableName'] = tableName;
//     data['CreditSale'] = creditSale;
//     return data;
//   }
// }

// class SumValues {
//   String? grandTotalSum;
//   String? cashSum;
//   String? bankSum;
//   String? creditSum;

//   SumValues({this.grandTotalSum, this.cashSum, this.bankSum, this.creditSum});

//   SumValues.fromJson(Map<String, dynamic> json) {
//     grandTotalSum = json['GrandTotal_sum'].toString();
//     cashSum = json['Cash_sum'].toString();
//     bankSum = json['Bank_sum'].toString();
//     creditSum = json['Credit_sum'].toString();
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['GrandTotal_sum'] = grandTotalSum;
//     data['Cash_sum'] = cashSum;
//     data['Bank_sum'] = bankSum;
//     data['Credit_sum'] = creditSum;
//     return data;
//   }
// }

class SalesreportModel {
  int? statusCode;
  List<Data>? data;
  SumValues? sumValues;

  SalesreportModel({this.statusCode, this.data, this.sumValues});

  SalesreportModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add( Data.fromJson(v));
      });
    }
    // data = json['data'];

    sumValues = json['sum_values'] != null
        ? new SumValues.fromJson(json['sum_values'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (sumValues != null) {
      data['sum_values'] = sumValues!.toJson();
    }
    return data;
  }
}

class Data {
  int? index;
  String? id;
  String? billDiscAmt;
  String? totalGrossAmt;
  String? totalTax;
  String? voucherNo;
  String? date;
  String? tokenNumber;
  String? customerName;
  String? grandTotal;
  String? tableName;

  Data(
      {this.index,
      this.id,
      this.billDiscAmt,
      this.totalGrossAmt,
      this.totalTax,
      this.voucherNo,
      this.date,
      this.tokenNumber,
      this.customerName,
      this.grandTotal,
      this.tableName});

  Data.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    id = json['id'].toString();
    billDiscAmt = json['BillDiscAmt'].toString();
    totalGrossAmt = json['TotalGrossAmt'].toString();
    totalTax = json['TotalTax'].toString();
    voucherNo = json['VoucherNo'];
    date = json['Date'];
    tokenNumber = json['TokenNumber'].toString();
    customerName = json['CustomerName'];
    grandTotal = json['GrandTotal'].toString();
    tableName = json['TableName']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['id'] = id;
    data['BillDiscAmt'] = billDiscAmt;
    data['TotalGrossAmt'] = totalGrossAmt;
    data['TotalTax'] = totalTax;
    data['VoucherNo'] = voucherNo;
    data['Date'] = date;
    data['TokenNumber'] = tokenNumber;
    data['CustomerName'] = customerName;
    data['GrandTotal'] = grandTotal;
    data['TableName'] = tableName;
    return data;
  }
}

class SumValues {
  String? grandTotalSum;
  String? totalGrossAmtSum;
  String? totalDiscAmtSum;
  String? totalTaxSum;

  SumValues(
      {this.grandTotalSum,
      this.totalGrossAmtSum,
      this.totalDiscAmtSum,
      this.totalTaxSum});

  SumValues.fromJson(Map<String, dynamic> json) {
    grandTotalSum = json['GrandTotal_sum'].toString();
    totalGrossAmtSum = json['TotalGrossAmt_sum'].toString();
    totalDiscAmtSum = json['TotalDiscAmt_sum'].toString();
    totalTaxSum = json['TotalTax_sum'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GrandTotal_sum'] = grandTotalSum;
    data['TotalGrossAmt_sum'] = totalGrossAmtSum;
    data['TotalDiscAmt_sum'] = totalDiscAmtSum;
    data['TotalTax_sum'] = totalTaxSum;
    return data;
  }
}
