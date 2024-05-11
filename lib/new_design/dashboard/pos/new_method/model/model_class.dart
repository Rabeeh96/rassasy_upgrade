
class PrintDetails {
  var items, kitchenName, ip, totalQty;

  PrintDetails({
    this.kitchenName,
    this.items,
    this.ip,
    this.totalQty,
  });

  factory PrintDetails.fromJson(Map<dynamic, dynamic> json) {
    return PrintDetails(
      items: json['Items'],
      kitchenName: json['kitchen_name'],
      ip: json['IPAddress'],
      totalQty: json['TotalQty'].toString(),
    );
  }
}
class ItemsDetails {
  var productName, productDescription, qty, tableName, orderTypeI, tokenNumber, flavour, voucherNo;

  ItemsDetails(
      {this.productName, this.productDescription, this.qty, this.tableName, this.orderTypeI, this.tokenNumber, this.flavour, this.voucherNo});

  factory ItemsDetails.fromJson(Map<dynamic, dynamic> json) {
    return ItemsDetails(
      productName: json['ProductName'],
      productDescription: json['ProductDescription']??"",
      qty: json['Qty'].toString(),
      tableName: json['TableName']??"",
      orderTypeI: json['OrderType'],
      tokenNumber: json['TokenNumber'],
      voucherNo: json['VoucherNo'],
      flavour: json['flavour'] ?? '',
    );
  }
}
class CardDetailsDetails {
  final int paymentID;
  final String paymentNetworkName;

  CardDetailsDetails({required this.paymentID, required this.paymentNetworkName});

  factory CardDetailsDetails.fromJson(Map<dynamic, dynamic> json) {
    return CardDetailsDetails(
      paymentID: json['TransactionTypesID'],
      paymentNetworkName: json['Name'],
    );
  }
}
class CategoryListModel {
  final String categoryId, categoryName;
  final int categoryGroupId;

  CategoryListModel({required this.categoryName, required this.categoryGroupId, required this.categoryId});

  factory CategoryListModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryListModel(categoryName: json['GroupName'], categoryGroupId: json['ProductGroupID'], categoryId: json['id']);
  }
}
class FlavourListModel {
  final String id, flavourName, bgColor;
  final int flavourID;
  final bool isActive;

  FlavourListModel({
    required this.id,
    required this.flavourID,
    required this.flavourName,
    required this.bgColor,
    required this.isActive,
  });

  factory FlavourListModel.fromJson(Map<dynamic, dynamic> json) {
    return FlavourListModel(
      id: json['id'],
      flavourID: json['FlavourID'],
      flavourName: json['FlavourName'],
      bgColor: json['BgColor'],
      isActive: json['IsActive'],
    );
  }
}
class ProductListModelDetail {
  String productName,
      defaultUnitName,
      defaultSalesPrice,
      defaultPurchasePrice,
      gSTSalesTax,
      vatsSalesTax,
      gSTTaxName,
      description,
      vegOrNonVeg,
      productImage,
      vATTaxName;


  var exciseData;
  var taxDetails;
   int productID, defaultUnitID, gstID, vatID;
  bool isInclusive;

  ProductListModelDetail(
      {required this.productID,
        required this.defaultUnitID,
        required this.gstID,
        required this.vatID,
        required this.productName,
        required this.defaultUnitName,
        required this.defaultSalesPrice,
        required this.exciseData,
        required this.defaultPurchasePrice,
        required this.gSTSalesTax,
        required this.vatsSalesTax,
        required this.vegOrNonVeg,
        required this.gSTTaxName,
        required this.vATTaxName,
        required this.description,
        required this.taxDetails,
        required this.productImage,
        required this.isInclusive});

  factory ProductListModelDetail.fromJson(Map<dynamic, dynamic> json) {
    return ProductListModelDetail(
      productID: json['ProductID'] ?? 0,
      defaultUnitID: json['DefaultUnitID'] ?? '',
      gstID: json['GST_ID'] ?? 0,
      vatID: json['VatID'] ?? 0,
      productName: json['ProductName'] ?? '',
      defaultUnitName: json['DefaultUnitName'] ?? '',
      defaultSalesPrice: json['DefaultSalesPrice'].toString(),
      defaultPurchasePrice: json['DefaultPurchasePrice'].toString(),
      gSTSalesTax: json['GST_SalesTax'] ?? '',
      vatsSalesTax: json['SalesTax'] ?? '',
      gSTTaxName: json['GST_TaxName'] ?? "",
      vATTaxName: json['VAT_TaxName'] ?? '',
      isInclusive: json['is_inclusive'] ?? false,
      description: json['Description'] ?? '',
      vegOrNonVeg: json['VegOrNonVeg'] ?? '',
      productImage: json['ProductImage'] ?? '',
      taxDetails: json['Tax'] ?? '',
      exciseData: json['ExciseTaxData'],
    );
  }
}
class PassingDetails {
  int productId, priceListId, createUserId, salesDetailsID, detailID, actualProductTaxID, productTaxID,exciseTaxID;
  String productName,
      quantity,
  exciseTaxName,
  bPValue,
  exciseTaxBefore,
  exciseTaxAfter,
      unitPrice,
      netAmount,
      uniqueId,
      exciseTaxAmount,
      flavourID,
      flavourName,
      discountAmount,
      grossAmount,
      rateWithTax,
      status,
      costPerPrice,
      discountPercentage,
      taxableAmount,
      vatPer,
      vatAmount,
      sgsPer,
      sgsAmount,
      cgsPer,
      cgsAmount,
      roundedUnitPrice,
      netAmountRounded,
      igsPer,
      igsAmount,
      roundedQuantity,
      inclusivePrice,
      unitPriceName,
      additionalDiscount,
      gstPer,
      actualProductTaxName,
      salesPrice,
      totalTaxRounded,
      description,
      productTaxName;
  bool productInc,  isAmountTaxAfter,  isAmountTaxBefore,
      isExciseProduct;

  PassingDetails({
    required this.uniqueId,
    required this.productName,
    required this.grossAmount,
    required this.unitPrice,
    required this.exciseTaxAmount,
    required this.netAmount,
    required this.salesDetailsID,
    required this.quantity,
    required this.discountAmount,
    required this.productId,
    required this.rateWithTax,
    required this.costPerPrice,
    required this.priceListId,
    required this.additionalDiscount,
    required this.discountPercentage,
    required this.isAmountTaxBefore,
    required this.taxableAmount,
    required this.vatPer,
    required this.vatAmount,
    required this.sgsPer,
    required this.cgsAmount,
    required this.cgsPer,
    required this.createUserId,
    required this.flavourID,
    required this.flavourName,
    required this.igsAmount,
    required this.igsPer,
    required this.sgsAmount,
    required this.netAmountRounded,
    required this.detailID,
    required this.status,
    required this.inclusivePrice,
    required this.roundedUnitPrice,
    required this.roundedQuantity,
    required this.gstPer,
    required this.unitPriceName,
    required this.productTaxID,
    required this.productTaxName,
    required this.actualProductTaxName,
    required this.actualProductTaxID,
    required this.salesPrice,
    required this.productInc,
    required this.totalTaxRounded,
    required this.description,
    required this.exciseTaxID,
    required this.exciseTaxName,
    required this.bPValue,
    required this.exciseTaxBefore,
    required this.isAmountTaxAfter,
    required this.isExciseProduct,
    required this.exciseTaxAfter,
  });

  factory PassingDetails.fromJson(Map<dynamic, dynamic> json) {
    return PassingDetails(
      uniqueId: json['id'],
      productId: json['ProductID'],
      productName: json['ProductName'],
      quantity: json['Qty'].toString(),
      unitPrice: json['UnitPrice'].toString(),
      description: json['Description'] ?? "",
      rateWithTax: json['RateWithTax'].toString(),
      costPerPrice: json['CostPerPrice'].toString(),
      exciseTaxAmount: json['ExciseTax'].toString(),
      grossAmount: json['GrossAmount'].toString(),
      netAmount: json['NetAmount'].toString(),
      priceListId: json['PriceListID'],
      discountPercentage: json['DiscountPerc'].toString(),
      discountAmount: json['DiscountAmount'].toString(),
      taxableAmount: json['TaxableAmount'].toString(),
      vatPer: json['VATPerc'].toString(),
      vatAmount: json['VATAmount'].toString(),
      salesDetailsID: json['SalesDetailsID'],
      sgsPer: json['SGSTPerc'].toString(),
      sgsAmount: json['SGSTAmount'].toString(),
      cgsPer: json['CGSTPerc'].toString(),
      cgsAmount: json['CGSTAmount'].toString(),
      igsPer: json['IGSTPerc'].toString(),
      igsAmount: json['IGSTAmount'].toString(),
      additionalDiscount: json['AddlDiscAmt'].toString(),
      createUserId: json['CreatedUserID'],
      detailID: json['detailID'],
      productInc: json['is_inclusive'],
      roundedUnitPrice: json['unitPriceRounded'].toString(),
      roundedQuantity: json['quantityRounded'].toString(),
      inclusivePrice: json['InclusivePrice'].toString(),
      netAmountRounded: json['netAmountRounded'].toString(),
      unitPriceName: json['UnitName'],
      gstPer: json['gstPer'].toString(),
      productTaxName: json['ProductTaxName'],
      flavourID: json['flavour'] ?? "",
      flavourName: json['Flavour_Name'] ?? "",
      productTaxID: json['ProductTaxID'],
      status: json['Status'],
      actualProductTaxName: json['ActualProductTaxName'],
      actualProductTaxID: json['ActualProductTaxID'],
      salesPrice: json['SalesPrice'].toString(),
      totalTaxRounded: json['TotalTaxRounded'].toString(),
      exciseTaxID: json['ExciseTaxID']??0,
      exciseTaxName: json['ExciseTaxName'].toString(),
      bPValue: json['BPValue'].toString(),
      exciseTaxBefore: json['ExciseTaxBefore'].toString(),
      isAmountTaxAfter: json['IsAmountTaxAfter']??false,
      isExciseProduct: json['IsExciseProduct']??false,
      isAmountTaxBefore: json['IsAmountTaxBefore']??false,
      exciseTaxAfter: json['ExciseTaxAfter'].toString(),

    );
  }
}
class PosListModel {
  final String salesOrderId, salesId, custName, tokenNo, phone, status, salesOrderGrandTotal, salesGrandTotal, orderTime;

  PosListModel(
      {required this.salesOrderId,
        required this.salesId,
        required this.custName,
        required this.tokenNo,
        required this.phone,
        required this.status,
        required this.salesOrderGrandTotal,
        required this.salesGrandTotal,
        required this.orderTime});

  factory PosListModel.fromJson(Map<dynamic, dynamic> json) {
    return PosListModel(
        salesOrderId: json['SalesOrderID'],
        salesId: json['SalesID'],
        custName: json['CustomerName'],
        tokenNo: json['TokenNumber'],
        phone: json['Phone']??"",
        status: json['Status'],
        salesOrderGrandTotal: json['SalesOrderGrandTotal'],
        salesGrandTotal: json['SalesGrandTotal'],
        orderTime: json['OrderTime']);
  }
}
class DiningListModel {
  final String tableId, title, description, status, salesGrandTotal, salesOrderID, salesMasterID, orderTime, salesOrderGrandTotal;
  var reserved;
  final bool isReserved;

  DiningListModel(
      {required this.title,
        required this.tableId,
        required this.description,
        required this.status,
        required this.salesOrderID,
        required this.salesGrandTotal,
        required this.salesMasterID,
        required this.isReserved,
        required this.reserved,
        required this.orderTime,
        required this.salesOrderGrandTotal});

  factory DiningListModel.fromJson(Map<dynamic, dynamic> json) {
    return DiningListModel(
      tableId: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['Status'],
      salesOrderID: json['SalesOrderID'],
      salesMasterID: json['SalesMasterID'],
      orderTime: json['OrderTime'],
      isReserved: json['IsReserved'],
      reserved: json['reserved'] ?? [],
      salesOrderGrandTotal: json['SalesOrderGrandTotal'].toString(),
      salesGrandTotal: json['SalesGrandTotal'].toString(),
    );
  }
}
class CancelReportModel {
  final String id, reason;
  final int branchID;

  CancelReportModel({required this.id, required this.reason, required this.branchID});

  factory CancelReportModel.fromJson(Map<dynamic, dynamic> json) {
    return CancelReportModel(id: json['id'], branchID: json['BranchID'], reason: json['Reason']);
  }
}
class LoyaltyCustomerModel {
  int loyaltyCustomerID;
  String customerName, id, phone;

  LoyaltyCustomerModel({required this.customerName, required this.id, required this.loyaltyCustomerID, required this.phone});

  factory LoyaltyCustomerModel.fromJson(Map<dynamic, dynamic> json) {
    return LoyaltyCustomerModel(
      customerName: json['FirstName'],
      loyaltyCustomerID: json['LoyaltyCustomerID'],
      id: json['id'],
      phone: json['MobileNo'],
    );
  }
}
///
// class PaymentData {
//   static int cardTypeId = 0;
//  // static int ledgerID = 0;
//   static String deliveryManID = "0";
//   static int loyaltyCustomerID = 0;
//   static String salesOrderID = "";
// }
List<PrintDetails> printListData = [];
List<ItemsDetails> dataPrint = [];