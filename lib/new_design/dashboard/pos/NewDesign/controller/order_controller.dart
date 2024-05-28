import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/flavour.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/groupModel.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class OrderController extends GetxController {
  ValueNotifier<bool> isVegNotifier = ValueNotifier<bool>(false); // Initialize with initial value
  final ValueNotifier<int> selectedGroupNotifierss = ValueNotifier<int>(0);

  ValueNotifier<bool> isOrderCreate = ValueNotifier<bool>(false); // Initialize with initial value
  var groupIsLoading = false.obs;
  var productIsLoading = false.obs;

// var isLoading=false.obs;
  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController unitPriceChangingController = TextEditingController();
  late ValueNotifier<int> productSearchNotifier;
  RxBool printAfterPayment = false.obs;
  RxBool autoFocusField = false.obs;
  RxString currency = "".obs;

  RxString user_name = "".obs;
  RxString tokenNumber = "".obs;

  RxBool isGst = false.obs;
  RxInt ledgerID = 1.obs;
  RxBool isComplimentary = false.obs;
  RxBool quantityIncrement = false.obs;

  RxList orderItemList = [].obs;
  RxList deletedList = [].obs;
  RxInt selectedGroup = 0.obs;

  RxString item_status = "".obs;
  RxString unique_id = "".obs;
  RxInt detailID = 1.obs;
  RxString unitName = "".obs;
  RxInt productId = 0.obs;
  RxInt actualProductTaxID = 0.obs;
  RxInt productID = 0.obs;
  RxInt branchID = 0.obs;
  RxInt salesDetailsID = 0.obs;
  RxInt productTaxID = 0.obs;
  RxInt createdUserID = 0.obs;
  RxInt priceListID = 0.obs;
  RxString productTaxName = "".obs;
  RxString productName = "".obs;
  RxString flavourID = "".obs;
  RxString flavourName = "".obs;
  RxString salesPrice = "".obs;
  RxString purchasePrice = "".obs;
  RxString id = "".obs;
  RxString freeQty = "".obs;
  RxDouble rateWithTax = 0.0.obs;
  RxString costPerPrice = "".obs;
  RxString discountPer = "".obs;
  RxString taxType = "".obs;
  RxString dateOnly = "".obs;
  RxInt taxID = 0.obs;
  RxDouble discountAmount = 0.0.obs;
  RxDouble percentageDiscount = 0.0.obs;
  RxDouble taxableAmountPost = 0.0.obs;
  RxString grossAmount = "".obs;
  RxDouble vatPer = 0.0.obs;
  RxDouble quantity = 1.0.obs;
  RxDouble vatAmount = 0.0.obs;
  RxDouble netAmount = 0.0.obs;
  RxDouble sGSTPer = 0.0.obs;
  RxDouble sGSTAmount = 0.0.obs;
  RxDouble cGSTPer = 0.0.obs;
  RxDouble cGSTAmount = 0.0.obs;
  RxDouble iGSTPer = 0.0.obs;
  RxDouble iGSTAmount = 0.0.obs;
  RxDouble totalTax = 0.0.obs;
  RxString dataBase = "".obs;
  RxString taxableAmount = "".obs;
  RxString addDiscPer = "".obs;
  RxString addDiscAmt = "".obs;
  RxDouble gstPer = 0.0.obs;
  RxDouble gstAmount = 0.0.obs;
  RxBool isInclusive = false.obs;

  RxString actualProductTaxName = "".obs;
  RxString unitPriceAmountWR = "0.00".obs;
  RxString inclusiveUnitPriceAmountWR = "0.00".obs;
  RxString grossAmountWR = "0.00".obs;

  RxDouble exciseTaxAmount = 0.0.obs;
  RxDouble quantityForDetailsSection = 1.0.obs;

  /// Excise tax
  RxInt exciseTaxID = 0.obs;
  RxInt detailIdEdit = 0.obs;
  RxString exciseTaxName = "".obs;
  RxString BPValue = "".obs;
  RxString exciseTaxBefore = "".obs;
  RxBool isAmountTaxBefore = false.obs;
  RxBool isAmountTaxAfter = false.obs;
  RxBool isExciseProduct = false.obs;
  RxString exciseTaxAfter = "".obs;

  returnIconStatus(status) {
    if (status == "pending") {
      return const Color(0xffECAC08);
    } else if (status == "delivered") {
      return const Color(0xff034FC1);
    } else {
      return const Color(0xff000000);
    }
  }

  calculationOnEditing({required int index, required bool isQuantityButton, required String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    RxDouble grossAmount = 0.0.obs;
    RxDouble unit = 0.0.obs;
    taxType.value = "None";
    taxID.value = 32;

    RxDouble discount = 0.0.obs;
    RxDouble inclusivePer = 0.0.obs;
    RxDouble exclusivePer = 0.0.obs;

    var checkVat = prefs.getBool("checkVat") ?? false;
    var checkGst = prefs.getBool("check_GST") ?? false;
    var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
    print('----1');
    if (checkVat == true) {
      taxType.value = "VAT";
      taxID.value = 32;
      if (isInclusive.value == true) {
        inclusivePer.value = inclusivePer.value + vatPer.value;
      } else {
        exclusivePer.value = exclusivePer.value + vatPer.value;
      }
    }
    if (checkGst == true) {
      taxType.value = "GST Intra-state B2C";
      taxID.value = 22;
      if (isInclusive.value == true) {
        inclusivePer.value = inclusivePer.value + gstPer.value;
      } else {
        exclusivePer.value = exclusivePer.value + gstPer.value;
      }
    }

    if (isQuantityButton) {
      unit.value = double.parse(orderItemList[index]["UnitPrice"]);
      quantity.value = double.parse(value);
    } else {
      unit.value = double.parse(value);
    }

    if (inclusivePer.value == 0.0) {
      unitPriceAmountWR.value = (unit).toString();
      var taxAmount = (unit.value * exclusivePer.value) / 100;
      inclusiveUnitPriceAmountWR.value = (unit + taxAmount).toString();
      unit.value = unit.value;
    } else {
      var taxAmount = (unit.value * inclusivePer.value) / (100 + inclusivePer.value);
      print(taxAmount);
      unit.value = unit.value - taxAmount;
      inclusiveUnitPriceAmountWR.value = (unit.value + taxAmount).toString();
      unitPriceAmountWR.value = (unit.value).toString();
      print(unit);
    }

    discount.value = 0.0;
    percentageDiscount = 0.0.obs;
    discountAmount = 0.0.obs;
    grossAmount.value = quantity.value * unit.value;

    exciseTaxAmount.value = 0.0;
    print("isExciseProduct  $isExciseProduct");
    if (isExciseProduct.value) {
      // exciseTaxAmount = calculateExciseTax(
      //   breakEvenValue: double.parse(BPValue),
      //   greaterAmount: isAmountTaxAfter,
      //   greaterThanValue: double.parse(exciseTaxAfter),
      //   lessAmount: isAmountTaxBefore,
      //   lessThanValue: double.parse(exciseTaxBefore),
      //   price: grossAmount,
      // );
    }
    grossAmountWR.value = "$grossAmount";
    taxableAmountPost.value = grossAmount.value - discount.value;
    vatAmount.value = ((taxableAmountPost.value + exciseTaxAmount.value) * vatPer.value / 100);

    gstAmount.value = (taxableAmountPost.value * gstPer.value / 100);


    if (checkVat == false) {
      vatAmount.value = 0.0;
      print(vatAmount);
    }
    if (checkGst == false) {
      gstAmount.value = 0.0;
    }

    cGSTAmount.value = gstAmount / 2;
    sGSTAmount.value = gstAmount / 2;
    iGSTAmount.value = gstAmount.value;
    cGSTPer.value = gstPer / 2;
    iGSTPer.value = gstPer.value;
    sGSTPer.value = gstPer / 2;

    if (taxType.value == "Export") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType.value == "Import") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
      print('import');
    } else if (taxType.value == "GST Inter-state B2C") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType.value == "GST Inter-state B2B") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType.value == "GST Intra-state B2C") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + cGSTAmount.value;
    } else if (taxType.value == "GST Intra-state B2B") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + sGSTAmount.value;
    } else if (taxType.value == "None") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType.value == "VAT") {
      totalTax.value = vatAmount.value + exciseTaxAmount.value;
    }

    netAmount.value = taxableAmountPost.value + totalTax.value;
    var singleTax = totalTax.value / quantity.value;
    rateWithTax.value = unit.value + singleTax;
    costPerPrice.value = purchasePrice.value;
    percentageDiscount.value = (discount * 100 / netAmount.value);
    discountAmount.value = discount.value;
    update();

  }
  addItemToList({required int index}) {
    Map data = {
      "ProductName": productName.value,
      "Status": item_status.value,
      "UnitName": unitName.value,
      "Qty": "${quantity.value}",
      "ProductTaxName": productTaxName.value,
      "ProductTaxID": productTaxID.value,
      "SalesPrice": salesPrice.value,
      "ProductID": productID.value,
      "ActualProductTaxName": actualProductTaxName.value,
      "ActualProductTaxID": actualProductTaxID.value,
      "BranchID": branchID.value,
      "SalesDetailsID": 1,
      "unq_id": unique_id.value,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR.value,
      "RateWithTax": "${rateWithTax.value}",
      "CostPerPrice": costPerPrice.value,
      "PriceListID": priceListID.value,
      "DiscountPerc": discountPer.value,
      "DiscountAmount": "${discountAmount.value}",
      "GrossAmount": grossAmountWR.value,
      "VATPerc": "${vatPer.value}",
      "VATAmount": "${vatAmount.value}",
      "NetAmount": "${netAmount.value}",
      "detailID": detailID.value,
      "SGSTPerc": "${sGSTPer.value}",
      "SGSTAmount": "${sGSTAmount.value}",
      "CGSTPerc": "${cGSTPer.value}",
      "CGSTAmount": "${cGSTAmount.value}",
      "IGSTPerc": "${iGSTPer.value}",
      "IGSTAmount": "${iGSTAmount.value}",
      "CreatedUserID": createdUserID.value,
      "DataBase": dataBase.value,
      "flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "InclusivePrice": inclusiveUnitPriceAmountWR.value,
      "TotalTaxRounded": "${totalTax.value}",
      "Description": "",
      "ExciseTaxID":exciseTaxID.value,
      "ExciseTaxName":exciseTaxName.value,
      "BPValue":BPValue.value,
      "ExciseTaxBefore":exciseTaxBefore.value,
      "IsAmountTaxAfter":isAmountTaxAfter.value,
      "IsAmountTaxBefore":isAmountTaxBefore.value,
      "IsExciseProduct":isExciseProduct.value,
      "ExciseTaxAfter":exciseTaxAfter.value,
      "ExciseTax":exciseTaxAmount.value.toString()
    };
    print(" data $data");
    orderItemList[index] = data;
    clearDetails();
    totalAmount();
  }




  clearDetails(){


     item_status = "".obs;
     unique_id = "".obs;
     detailID = 1.obs;
     unitName = "".obs;
     productId = 0.obs;
     actualProductTaxID = 0.obs;
     productID = 0.obs;
     salesDetailsID = 0.obs;
     productTaxID = 0.obs;
     priceListID = 0.obs;
     productTaxName = "".obs;
     productName = "".obs;
     flavourID = "".obs;
     flavourName = "".obs;
     salesPrice = "".obs;
     purchasePrice = "".obs;
     id = "".obs;
     freeQty = "".obs;
     rateWithTax = 0.0.obs;
     costPerPrice = "".obs;
     discountPer = "".obs;
     discountAmount = 0.0.obs;
     percentageDiscount = 0.0.obs;
     taxableAmountPost = 0.0.obs;
     grossAmount = "".obs;
     vatPer = 0.0.obs;
     quantity = 1.0.obs;
     vatAmount = 0.0.obs;
     netAmount = 0.0.obs;
     sGSTPer = 0.0.obs;
     sGSTAmount = 0.0.obs;
     cGSTPer = 0.0.obs;
     cGSTAmount = 0.0.obs;
     iGSTPer = 0.0.obs;
     iGSTAmount = 0.0.obs;
     totalTax = 0.0.obs;
     dataBase = "".obs;
     taxableAmount = "".obs;
     addDiscPer = "".obs;
     addDiscAmt = "".obs;
     gstPer = 0.0.obs;
     gstAmount = 0.0.obs;
     isInclusive = false.obs;
     actualProductTaxName = "".obs;
     unitPriceAmountWR = "0.00".obs;
     inclusiveUnitPriceAmountWR = "0.00".obs;
     grossAmountWR = "0.00".obs;
     exciseTaxAmount = 0.0.obs;
     exciseTaxID = 0.obs;
     detailIdEdit = 0.obs;
     exciseTaxName = "".obs;
     BPValue = "".obs;
     exciseTaxBefore = "".obs;
     isAmountTaxBefore = false.obs;
     isAmountTaxAfter = false.obs;
     isExciseProduct = false.obs;
     exciseTaxAfter = "".obs;
     update();
  }

  calculation() async {
    RxDouble grossAmount = 0.0.obs;
    RxDouble unit = 0.0.obs;
    taxType = "None".obs;
    taxID = 32.obs;

    RxDouble discount = 0.0.obs;
    RxDouble inclusivePer = 0.0.obs;
    RxDouble exclusivePer = 0.0.obs;
    quantity = 1.0.obs;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var checkVat = prefs.getBool("checkVat") ?? false;
    var checkGst = prefs.getBool("check_GST") ?? false;
    var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

    if (checkVat == true) {
      taxType = "VAT".obs;
      taxID = 32.obs;
      if (isInclusive.value == true) {
        inclusivePer.value = inclusivePer.value + vatPer.value;
      } else {
        exclusivePer.value = exclusivePer.value + vatPer.value;
      }
    }
    if (checkGst == true) {
      taxType = "GST Intra-state B2C".obs;
      taxID = 22.obs;
      if (isInclusive == true) {
        inclusivePer.value = inclusivePer.value + gstPer.value;
      } else {
        exclusivePer.value = exclusivePer.value + gstPer.value;
      }
    }

    unit.value = double.parse(unitPriceAmountWR.value);
    if (inclusivePer == 0.0) {
      unitPriceAmountWR.value = (unit).toString();

      var taxAmount = (unit.value * exclusivePer.value) / 100;
      inclusiveUnitPriceAmountWR.value = (unit + taxAmount).toString();
      unit = unit;
    } else {
      var taxAmount = (unit * inclusivePer.value) / (100 + inclusivePer.value);
      print(taxAmount);
      unit.value = unit.value - taxAmount;
      inclusiveUnitPriceAmountWR.value = (unit + taxAmount).toString();
      unitPriceAmountWR.value = (unit).toString();
      print(unit);
    }

    discount.value = 0.0;
    percentageDiscount.value = 0;
    discountAmount.value = 0;

    grossAmount.value = quantity * unit.value;

    exciseTaxAmount = 0.0.obs;
    if (isExciseProduct.value) {
      // exciseTaxAmount = calculateExciseTax(
      //   breakEvenValue: double.parse(BPValue),
      //   greaterAmount: isAmountTaxAfter,
      //   greaterThanValue: double.parse(exciseTaxAfter),
      //   lessAmount: isAmountTaxBefore,
      //   lessThanValue: double.parse(exciseTaxBefore),
      //   price: grossAmount,
      // );
    }
    grossAmountWR.value = "${grossAmount.value}";
    taxableAmountPost.value = grossAmount.value - discount.value;
    vatAmount.value = ((taxableAmountPost.value + exciseTaxAmount.value) * vatPer.value / 100);

    gstAmount.value = (taxableAmountPost * gstPer.value / 100);

    if (checkVat == false) {
      vatAmount.value = 0.0;
      print(vatAmount);
    }
    if (checkGst == false) {
      gstAmount.value = 0.0;
    }

    cGSTAmount.value = gstAmount.value / 2;
    sGSTAmount.value = gstAmount.value / 2;
    iGSTAmount.value = gstAmount.value;
    cGSTPer.value = gstPer.value / 2;
    iGSTPer.value = gstPer.value;
    sGSTPer.value = gstPer.value / 2;

    if (taxType == "Export") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType == "Import") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
      print('import');
    } else if (taxType == "GST Inter-state B2C") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType == "GST Inter-state B2B") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType == "GST Intra-state B2C") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + cGSTAmount.value;
    } else if (taxType == "GST Intra-state B2B") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + sGSTAmount.value;
    } else if (taxType == "None") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
      print(totalTax.value);
    } else if (taxType.value == "VAT") {
      totalTax.value = vatAmount.value + exciseTaxAmount.value;
    }

    netAmount.value = taxableAmountPost.value + totalTax.value;
    RxDouble singleTax = 0.0.obs;
    singleTax.value = totalTax.value / quantity.value;
    rateWithTax.value = unit.value + singleTax.value;
    costPerPrice.value = purchasePrice.value;
    percentageDiscount.value = (discount.value * 100 / netAmount.value);
    discountAmount.value = discount.value;

    Map data = {
      "ProductName": productName.value,
      "Status": item_status.value,
      "UnitName": unitName.value,
      "Qty": "${quantity.value}",
      "ProductTaxName": productTaxName.value,
      "ProductTaxID": productTaxID.value,
      "SalesPrice": salesPrice.value,
      "ProductID": productID.value,
      "ActualProductTaxName": actualProductTaxName.value,
      "ActualProductTaxID": actualProductTaxID.value,
      "BranchID": branchID.value,
      "SalesDetailsID": 1,
      "unq_id": unique_id.value,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR.value,
      "RateWithTax": "${rateWithTax.value}",
      "CostPerPrice": costPerPrice.value,
      "PriceListID": priceListID.value,
      "DiscountPerc": "0.0",
      "DiscountAmount": "${discountAmount.value}",
      "GrossAmount": "${grossAmount.value}",
      "VATPerc": "${vatPer.value}",
      "VATAmount": "${vatAmount.value}",
      "NetAmount": "${netAmount.value}",
      "detailID": detailID.value,
      "SGSTPerc": "${sGSTPer.value}",
      "SGSTAmount": "${sGSTAmount.value}",
      "CGSTPerc": "${cGSTPer.value}",
      "CGSTAmount": "${cGSTAmount.value}",
      "IGSTPerc": "${iGSTPer.value}",
      "IGSTAmount": "${iGSTAmount.value}",
      "CreatedUserID": createdUserID.value,
      "DataBase": dataBase.value,
      "flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "unitPriceRounded": roundStringWith(unitPriceAmountWR.value),
      "quantityRounded": roundStringWith(quantity.value.toString()),
      "netAmountRounded": roundStringWith(netAmount.value.toString()),
      "InclusivePrice": inclusiveUnitPriceAmountWR.value,
      "TotalTaxRounded": roundStringWith(totalTax.value.toString()),
      "Description": "",
      "ExciseTaxID": exciseTaxID.value,
      "ExciseTaxName": exciseTaxName.value,
      "BPValue": BPValue.value,
      "ExciseTaxBefore": exciseTaxBefore.value,
      "IsAmountTaxAfter": isAmountTaxAfter.value,
      "IsAmountTaxBefore": isAmountTaxBefore.value,
      "IsExciseProduct": isExciseProduct.value,
      "ExciseTaxAfter": exciseTaxAfter.value,
      "ExciseTax": exciseTaxAmount.value.toString()
    };

    orderItemList.insert(0, data);
    update();
    totalAmount();
  }

  updateQty({required int type, required int index}) async {
    int indexChanging = index;
    quantity.value = double.parse(orderItemList[indexChanging]["Qty"].toString());
    if (type == 1) {
      quantity.value = quantity.value + 1.0;
    } else {
      quantity.value = quantity.value - 1.0;
    }

    detailID.value = orderItemList[indexChanging]["detailID"];
    unitPriceAmountWR.value = orderItemList[indexChanging]["UnitPrice"].toString();
    inclusiveUnitPriceAmountWR.value = orderItemList[indexChanging]["InclusivePrice"].toString();
    vatPer.value = double.parse(orderItemList[indexChanging]["VATPerc"].toString());
    gstPer.value = double.parse(orderItemList[indexChanging]["gstPer"].toString());
    unique_id.value = orderItemList[indexChanging]["unq_id"];
    productName.value = orderItemList[indexChanging]["ProductName"];
    item_status.value = orderItemList[indexChanging]["Status"];
    unitName.value = orderItemList[indexChanging]["UnitName"];
    // detailDescriptionController.text = orderItemList[indexChanging].description;
    salesPrice.value = orderItemList[indexChanging]["SalesPrice"].toString();
    purchasePrice.value = orderItemList[indexChanging]["CostPerPrice"].toString();
    productID.value = orderItemList[indexChanging]["ProductID"];
    isInclusive.value = orderItemList[indexChanging]["is_inclusive"];
    actualProductTaxName.value = orderItemList[indexChanging]["ActualProductTaxName"];
    actualProductTaxID.value = orderItemList[indexChanging]["ActualProductTaxID"];
    priceListID.value = orderItemList[indexChanging]["PriceListID"];

    RxDouble grossAmount = 0.0.obs;
    var unit;
    taxType.value = "None";
    taxID.value = 32;

    var discount;
    var inclusivePer = 0.0;
    var exclusivePer = 0.0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var checkVat = prefs.getBool("checkVat") ?? false;
    var checkGst = prefs.getBool("check_GST") ?? false;
    var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

    if (checkVat == true) {
      taxType.value = "VAT";
      taxID.value = 32;

      if (isInclusive == true) {
        inclusivePer = inclusivePer + vatPer.value;
      } else {
        exclusivePer = exclusivePer + vatPer.value;
      }
    }
    if (checkGst == true) {
      taxType.value = "GST Intra-state B2C";
      taxID.value = 22;

      if (isInclusive == true) {
        inclusivePer = inclusivePer + gstPer.value;
      } else {
        exclusivePer = exclusivePer + gstPer.value;
      }
    }

    unit = double.parse(unitPriceAmountWR.value);

    discount = 0.0;
    percentageDiscount.value = 0.0;
    discountAmount.value = 0.0;

    exciseTaxAmount.value = 0.0;
    grossAmount.value = quantity.value * unit;
    if (isExciseProduct.value) {
      // exciseTaxAmount = calculateExciseTax(
      //   breakEvenValue: double.parse(BPValue),
      //   greaterAmount: isAmountTaxAfter,
      //   greaterThanValue: double.parse(exciseTaxAfter),
      //   lessAmount: isAmountTaxBefore,
      //   lessThanValue: double.parse(exciseTaxBefore),
      //   price: grossAmount,
      // );
    }
    grossAmountWR.value = "${grossAmount.value}";
    taxableAmountPost.value = grossAmount.value - discount;
    vatAmount.value = ((taxableAmountPost.value + exciseTaxAmount.value) * vatPer.value / 100);

    gstAmount.value = (taxableAmountPost.value * gstPer.value / 100);

    if (checkVat == false) {
      vatAmount.value = 0.0;
      print(vatAmount);
    }
    if (checkGst == false) {
      gstAmount.value = 0.0;
    }

    cGSTAmount.value = gstAmount.value / 2;
    sGSTAmount.value = gstAmount.value / 2;
    iGSTAmount.value = gstAmount.value;
    cGSTPer.value = gstPer.value / 2;
    iGSTPer.value = gstPer.value;
    sGSTPer.value = gstPer.value / 2;

    if (taxType == "Export") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType.value == "Import") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType == "GST Inter-state B2C") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType == "GST Inter-state B2B") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      totalTax.value = iGSTAmount.value;
    } else if (taxType == "GST Intra-state B2C") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + cGSTAmount.value;
    } else if (taxType == "GST Intra-state B2B") {
      iGSTAmount.value = 0.0;
      totalTax.value = cGSTAmount.value + sGSTAmount.value;
    } else if (taxType == "None") {
      cGSTAmount.value = 0.0;
      sGSTAmount.value = 0.0;
      iGSTAmount.value = 0.0;
      vatAmount.value = 0.0;
      totalTax.value = 0.0;
    } else if (taxType.value == "VAT") {
      totalTax.value = vatAmount.value + exciseTaxAmount.value;
    }

    netAmount.value = taxableAmountPost.value + totalTax.value;
    var singleTax = totalTax.value / quantity.value;
    rateWithTax.value = unit + singleTax;
    costPerPrice.value = purchasePrice.value;
    percentageDiscount.value = (discount * 100 / netAmount.value);
    discountAmount.value = discount;

    Map data = {
      "ProductName": productName.value,
      "Status": item_status.value,
      "UnitName": unitName.value,
      "Qty": "${quantity.value}",
      "ProductTaxName": productTaxName.value,
      "ProductTaxID": productTaxID.value,
      "SalesPrice": salesPrice.value,
      "ProductID": productID.value,
      "ActualProductTaxName": actualProductTaxName.value,
      "ActualProductTaxID": actualProductTaxID.value,
      "BranchID": branchID.value,
      "SalesDetailsID": 1,
      "unq_id": unique_id.value,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR.value,
      "RateWithTax": "${rateWithTax.value}",
      "CostPerPrice": costPerPrice.value,
      "PriceListID": priceListID.value,
      "DiscountPerc": discountPer.value,
      "DiscountAmount": "${discountAmount.value}",
      "GrossAmount": "${grossAmount.value}",
      "VATPerc": "${vatPer.value}",
      "VATAmount": "${vatAmount.value}",
      "NetAmount": "${netAmount.value}",
      "detailID": detailID.value,
      "SGSTPerc": "${sGSTPer.value}",
      "SGSTAmount": "${sGSTAmount.value}",
      "CGSTPerc": "${cGSTPer.value}",
      "CGSTAmount": "${cGSTAmount.value}",
      "IGSTPerc": "${iGSTPer.value}",
      "IGSTAmount": "${iGSTAmount.value}",
      "CreatedUserID": createdUserID.value,
      "DataBase": dataBase.value,
      "flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "unitPriceRounded": roundStringWith(unitPriceAmountWR.value),
      "quantityRounded": roundStringWith(quantity.value.toString()),
      "netAmountRounded": roundStringWith(netAmount.value.toString()),
      "InclusivePrice": inclusiveUnitPriceAmountWR.value,
      "TotalTaxRounded": roundStringWith(totalTax.value.toString()),
      "Description": "",
      "ExciseTaxID": exciseTaxID.value,
      "ExciseTaxName": exciseTaxName.value,
      "BPValue": BPValue.value,
      "ExciseTaxBefore": exciseTaxBefore.value,
      "IsAmountTaxAfter": isAmountTaxAfter.value,
      "IsAmountTaxBefore": isAmountTaxBefore.value,
      "IsExciseProduct": isExciseProduct.value,
      "ExciseTaxAfter": exciseTaxAfter.value,
      "ExciseTax": exciseTaxAmount.value.toString(),
    };

    orderItemList[indexChanging] = data;
    update();
    totalAmount();
  }

  RxDouble totalNetP = 0.0.obs;
  RxDouble totalTaxMP = 0.0.obs;
  RxDouble totalGrossP = 0.0.obs;
  RxDouble vatAmountTotalP = 0.0.obs;
  RxDouble cGstAmountTotalP = 0.0.obs;
  RxDouble sGstAmountTotalP = 0.0.obs;
  RxDouble iGstAmountTotalP = 0.0.obs;
  RxDouble exciseAmountTotalP = 0.0.obs;

  /// function for checking that item already added in list

  checking(int proID) {
    for (var i = 0; i < orderItemList.length; i++) {
      if (orderItemList[i]["PriceListID"] == proID) {
        return [true, i];
      }
    }
    return [false, 0];
  }

  returnQuantity(int index) {
    var qty = orderItemList[index]["Qty"];
    return qty;
  }

  totalAmount() {
    double totalNet = 0;
    double totalTaxM = 0;
    double totalDiscount = 0;
    double totalGross = 0;
    double vatAmountTotal = 0;
    double cGstAmountTotal = 0;
    double sGstAmountTotal = 0;
    double iGstAmountTotal = 0;
    double exciseTaxAmount = 0;

    for (var i = 0; i < orderItemList.length; i++) {
      totalNet += double.parse(orderItemList[i]["NetAmount"].toString());
      totalTaxM += double.parse(orderItemList[i]["TotalTaxRounded"].toString());
      vatAmountTotal += double.parse(orderItemList[i]["VATAmount"].toString());
      cGstAmountTotal += double.parse(orderItemList[i]["CGSTAmount"].toString());
      sGstAmountTotal += double.parse(orderItemList[i]["SGSTAmount"].toString());
      iGstAmountTotal += double.parse(orderItemList[i]["IGSTAmount"].toString());
      totalGross += double.parse(orderItemList[i]["GrossAmount"].toString());
      exciseTaxAmount += double.parse(orderItemList[i]["ExciseTax"].toString());
    }

    totalNetP.value = totalNet;
    totalTaxMP.value = totalTaxM;
    totalGrossP.value = totalGross;
    vatAmountTotalP.value = vatAmountTotal;
    cGstAmountTotalP.value = cGstAmountTotal;
    sGstAmountTotalP.value = sGstAmountTotal;
    iGstAmountTotalP.value = iGstAmountTotal;
    exciseAmountTotalP.value = exciseTaxAmount;

    update();
  }

  deleteOrderItem({required int index}) {
    var dictionary = {
      "unq_id": orderItemList[index]["unq_id"],
    };
    deletedList.add(dictionary);
    orderItemList.removeAt(index);
    print(orderItemList[index]);
    totalAmount();
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var flavourList = <FlavourListModelClass>[].obs;
  var groupList = <GroupListModelClass>[].obs;
  var productList = <ProductListModel>[].obs;

  Future<void> getAllFlavours() async {
    try {
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      var accessToken = prefs.getString('access') ?? '';
      final String url = '$baseUrl/flavours/flavours/';
      print(url);
      Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID};
      print(data);
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      print(responseJson);
      print(status);
      if (status == 6000) {
        // Clear existing list
        flavourList.clear();

        // Add fetched items to the list
        for (Map user in responseJson) {
          flavourList.add(FlavourListModelClass.fromJson(user));
        }
      } else if (status == 6001) {
        // Show error message
        var msg = n["error"] ?? "";
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        // Handle DB Error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<Null> posFunctions({required String sectionType, required String uUID}) async {
    // loader
    // start(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    productSearchNotifier = ValueNotifier(2);
    // productList.clear();
    groupList.clear();

    //changeVal(widget.orderType);
    printAfterPayment.value = prefs.getBool("printAfterPayment") ?? false;
    currency.value = prefs.getString('CurrencySymbol') ?? "";
    isGst.value = prefs.getBool("check_GST") ?? false;
    ledgerID.value = prefs.getInt("Cash_Account") ?? 1;
    customerNameController.text = "walk in customer";
    phoneNumberController.text = "";
    isComplimentary.value = prefs.getBool("complimentary_bill") ?? false;
    quantityIncrement.value = prefs.getBool("qtyIncrement") ?? false;


    // networkConnection = true;
    if (sectionType == "Create") {
      // mainPageIndex = 7;
    } else if (sectionType == "Edit") {
      await getOrderDetails(uID: uUID);
    } else {
      /// payment section
      // mainPageIndex = 6;
      // listItemDetails(widget.UUID);
    }
    if (sectionType != "Payment") {
      await getCategoryListDetail();
    }
  }

  Future<void> getCategoryListDetail() async {
    try {
      groupIsLoading.value = true;
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      user_name.value = prefs.getString('user_name')!;
      autoFocusField.value = prefs.getBool('autoFocusField') ?? false;

      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/posholds/pos/product-group/list/';
      print(url);
      Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID};
      print(data);
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      print(responseJson);
      print(status);
      if (status == 6000) {
        groupList.clear();
        for (Map user in responseJson) {
          groupList.add(GroupListModelClass.fromJson(user));
        }
        tokenNumber.value = n["TokenNumber"] ?? "";
        groupIsLoading.value = false;
        if (groupList.isNotEmpty) {
          getProductListDetail(groupList[2].groupID);
        }
      } else if (status == 6001) {
        // Show error message
        var msg = n["error"] ?? "";
        groupIsLoading.value = false;
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        groupIsLoading.value = false;
        // Handle DB Error
      }
    } catch (e) {
      groupIsLoading.value = false;
      // Handle error
    }
  }

  Future<void> getProductListDetail(groupID) async {
    try {
      productIsLoading.value = true;
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? "0";
      var userID = prefs.getInt('user_id') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      user_name.value = prefs.getString('user_name')!;
      autoFocusField.value = prefs.getBool('autoFocusField') ?? false;

      var accessToken = prefs.getString('access') ?? '';
      var priceRounding = BaseUrl.priceRounding;
      final String url = '$baseUrl/posholds/pos-product-list/';
      print(url);
      Map data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "GroupID": groupID,
        "type": isVegNotifier.value ? 'veg' : "",
        "PriceRounding": priceRounding
      };
      print(data);
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      print(responseJson);
      print(status);
      if (status == 6000) {
        productList.clear();
        for (Map user in responseJson) {
          productList.add(ProductListModel.fromJson(user));
        }

        productIsLoading.value = false;
      } else if (status == 6001) {
        // Show error message
        var msg = n["error"] ?? "";
        productIsLoading.value = false;
        // dialogBox(context, msg);
      }
      //DB Error
      else {
        productIsLoading.value = false;
        // Handle DB Error
      }
    } catch (e) {
      productIsLoading.value = false;
      // Handle error
    }
  }

  /// function for checking any item for 0 amount
  checkNonRatableItem() {
    bool returnVal = true;
    for (var i = 0; i < orderItemList.length; i++) {
      if (double.parse(orderItemList[i]["UnitPrice"]) > 0.0) {
        returnVal = true;
      } else {
        return false;
      }
    }

    return returnVal;
  }

  /// crete order function
//   postingData(isPayment) {
//     var detailsList = [];
//
//     print("=====================================================");
//     print(orderItemList.length);
//
//
//     print("=====================================================");
//     for (var i = 0; i < orderItemList.length; i++) {
//       var dictionary = {
//         "detailID": orderItemList[i]["detailID"],
//         "Status": orderItemList[i]["Status"],
//         "Qty": orderItemList[i]["Qty"],
//         "ProductID": orderItemList[i]["ProductID"],
//         "UnitPrice": orderItemList[i]["UnitPrice"],
//         "RateWithTax": orderItemList[i]["RateWithTax"],
//         "PriceListID": orderItemList[i]["PriceListID"],
//         "GrossAmount": orderItemList[i]["GrossAmount"],
//         "TaxableAmount": orderItemList[i]["TaxableAmount"],
//         "VATPerc": orderItemList[i]["VATPerc"],
//         "VATAmount": orderItemList[i]["VATAmount"],
//         "SGSTPerc": orderItemList[i]["SGSTPerc"],
//         "SGSTAmount": orderItemList[i]["SGSTAmount"],
//         "CGSTPerc": orderItemList[i]["CGSTPerc"],
//         "CGSTAmount": orderItemList[i]["CGSTAmount"],
//         "IGSTPerc": orderItemList[i]["IGSTPerc"],
//         "IGSTAmount": orderItemList[i]["IGSTAmount"],
//         "NetAmount": orderItemList[i]["NetAmount"],
//         "InclusivePrice": orderItemList[i]["InclusivePrice"],
//         "Description": orderItemList[i]["Description"],
//         "ProductTaxID": orderItemList[i]["ProductTaxID"],
//         "unq_id": orderItemList[i]["unq_id"],
//         "Flavour": orderItemList[i]["flavour"],
//         "ExciseTax": orderItemList[i]["ExciseTax"],
//         "ExciseTaxID": orderItemList[i]["ExciseTaxID"],
//         "FreeQty": "0",
//         "DiscountPerc": "0",
//         "DiscountAmount": "0",
//         "TAX1Perc": "0",
//         "TAX1Amount": "0",
//         "TAX2Perc": "0",
//         "TAX2Amount": "0",
//         "TAX3Perc": "0",
//         "TAX3Amount": "0",
//         "KFCAmount": "0",
//         "BatchCode": "0",
//         "SerialNos": [],
//       };
//
//       print("=================================================================");
//       print(i);
//       print(dictionary);
//       detailsList.add(dictionary);
//     }
//
//    //  if (widget.type == "Edit") {
//    // ///   updateSalesOrderRequest(detailsList, isPayment);
//    //  } else {
//    //    createSalesOrderRequest(detailsList, isPayment);
//    //  }
//     createSalesOrderRequest(detailsList, isPayment);
//   }

  /// function for load edit details
  Future<Null> getOrderDetails({required String uID}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        print("_________________________________________________________________its called");

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        final String url = '$baseUrl/posholds/view-pos/salesOrder/$uID/';
        print(url);
        Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
        print(data);
        print(accessToken);
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var message = n["message"] ?? "";
        var responseJson = n["data"];

        if (status == 6000) {

          ledgerID.value = responseJson["LedgerID"];
          totalNetP.value = double.parse(responseJson["NetTotal"].toString());
          totalTaxMP.value = double.parse(responseJson["TotalTax"].toString());
          totalGrossP.value = double.parse(responseJson["TotalGrossAmt"].toString());
          vatAmountTotalP.value = double.parse(responseJson["VATAmount"].toString());
          cGstAmountTotalP.value = double.parse(responseJson["CGSTAmount"].toString());
          sGstAmountTotalP.value = double.parse(responseJson["SGSTAmount"].toString());
          iGstAmountTotalP.value = double.parse(responseJson["IGSTAmount"].toString());
          iGstAmountTotalP.value = double.parse(responseJson["IGSTAmount"].toString());
          dateOnly.value = responseJson["Date"]??"";
          tokenNumber.value = responseJson["TokenNumber"]??"";
          phoneNumberController.text = responseJson["Phone"]??"";
          customerNameController.text = responseJson["CustomerName"]??"";
          print("_________________________________________________________________12");
          var checkVat = prefs.getBool("checkVat") ?? false;
          var checkGst = prefs.getBool("check_GST") ?? false;

          if (checkVat == true) {
            taxType.value = "VAT";
          }
          if (checkGst == true) {
            taxType.value = "GST Intra-state B2C";
          }

          orderItemList.clear();
          orderItemList.value = responseJson["SalesOrderDetails"];
          update();
          totalAmount();
          //   getLoyaltyCustomer();
        } else if (status == 6001) {
          popAlert(head: "Waring", message: message ?? "", position: SnackPosition.TOP);
        }

        //DB Error
        else {
          popAlert(head: "Error", message: "Some Network Error please try again Later", position: SnackPosition.TOP);
        }
      } catch (e) {
        print("-------${e.toString()}");
        popAlert(head: "Error", message: e.toString(), position: SnackPosition.TOP);
      }
    }
  }

  /// function for create
  Future<Null> createSalesOrderRequest(
      {required BuildContext context, required bool isPayment, required int orderType, required String tableID, required String tableHead}) async {
    start(context);
    try {
      if (tokenNumber.value == "") {
        tokenNumber.value = "001";
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      String baseUrl = BaseUrl.baseUrl;

      var checkVat = prefs.getBool("checkVat") ?? false;
      var checkGst = prefs.getBool("check_GST") ?? false;
      var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
      var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

      var taxTypeID = 31;
      if (checkVat == true) {
        taxTypeID = 32;
        taxType.value = "VAT";
      } else if (checkGst == true) {
        taxTypeID = 22;
        taxType.value = "GST Intra-state B2C";
      } else {
        taxTypeID = 31;
        taxType.value = "None";
      }

      var userID = prefs.getInt('user_id') ?? 0;
      var employeeID = prefs.getInt('employee_ID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var countryID = prefs.getString('Country') ?? 1;
      var stateID = prefs.getString('State') ?? 1;
      var printAfterOrder = prefs.getBool('print_after_order') ?? false;

      DateTime selectedDateAndTime = DateTime.now();
      String convertedDate = "$selectedDateAndTime";
      dateOnly.value = convertedDate.substring(0, 10);
      var orderTime = "$selectedDateAndTime";

      var type = "Dining";
      var customerName = "walk in customer";
      var phoneNumber = "";
      var time = "";

      if (orderType == 1) {
        type = "Dining";
        customerName = customerNameController.text;
        phoneNumber = phoneNumberController.text;
        time = "";
      } else if (orderType == 2) {
        type = "TakeAway";
        customerName = customerNameController.text;
        phoneNumber = phoneNumberController.text;
        time = "";
      }
      // ignore: unrelated_type_equality_checks
      else if (orderType == 3) {
        type = "Online";
        customerName = customerNameController.text;
        phoneNumber = phoneNumberController.text;

        time = "";
      } else if (orderType == 4) {
        type = "Car";
        customerName = customerNameController.text;
        phoneNumber = phoneNumberController.text;
        time = "";
      } else {}

      final String url = '$baseUrl/posholds/create-pos/salesOrder/';

      Map data = {
        "Table": tableID,
        "EmployeeID": employeeID,
        "CompanyID": companyID,
        "CreatedUserID": userID,
        "BranchID": branchID,
        "OrderTime": orderTime,
        "Date": dateOnly.value,
        "DeliveryDate": dateOnly.value,
        "TotalTax": "${totalTaxMP.value}",
        "NetTotal": "${totalNetP.value}",
        "GrandTotal": "${totalNetP.value}",
        "TotalGrossAmt": "${totalGrossP.value}",
        "TaxType": taxType.value,
        "TaxID": taxTypeID,
        "VATAmount": "${vatAmountTotalP.value}",
        "SGSTAmount": "${sGstAmountTotalP.value}",
        "CGSTAmount": "${cGstAmountTotalP.value}",
        "IGSTAmount": "${iGstAmountTotalP.value}",
        "ExciseTaxAmount": "${exciseAmountTotalP.value}",
        "Type": type,
        "LedgerID": ledgerID.value,
        "CustomerName": customerName,
        "Country_of_Supply": countryID,
        "State_of_Supply": stateID,
        "VAT_Treatment": "1",
        "TokenNumber": tokenNumber.value,
        "Phone": phoneNumber,
        "saleOrdersDetails": orderItemList,
        "VoucherNo": "",
        "BillDiscAmt": "0",
        "BillDiscPercent": "0",
        "DeliveryTime": "",
        "GST_Treatment": "",
        "Address1": "",
        "Address2": "",
        "Notes": "",
        "PriceCategoryID": 1,
        "FinacialYearID": 1,
        "TAX1Amount": "0",
        "TAX2Amount": "0",
        "TAX3Amount": "0",
        "ShippingCharge": "0",
        "shipping_tax_amount": "0",
        "TaxTypeID": "",
        "SAC": "",
        "SalesTax": "0",
        "RoundOff": "0",
        "IsActive": true,
        "IsInvoiced": "N",
      };
      log_data(data);
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);

      print("${response.statusCode}");
      print("${response.body}");
      Map n = json.decode(utf8.decode(response.bodyBytes));
      var status = n["StatusCode"];
      var responseJson = n["data"];
      print(responseJson);
      if (status == 6000) {
        stop();
        var id = n["OrderID"];

        Navigator.pop(context, [orderType, isPayment, id, tableID, tableHead]);

        if (printAfterOrder) {
          /// printing section
          // PrintDataDetails.type = "SO";
          // PrintDataDetails.id = n["OrderID"];
          // await printDetail(context);
        }

        // dialogBoxHide(context, 'Order created successfully !!!');

        Future.delayed(const Duration(seconds: 1), () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var kot = prefs.getBool("KOT") ?? false;
          if (kot == true) {
            /// commented kot print
            // PrintDataDetails.type = "SO";
            // PrintDataDetails.id = id;
            // printKOT(id, false, [], false);
          } else {}
        });
      } else if (status == 6001) {
        var errorMessage = n["message"];
        dialogBox(context, errorMessage);
      } else if (status == 6003) {
        stop();
        dialogBox(context, "Change token number and retry please");

        /// commented repeated token number issuer solution
        // tokenNumberController.text = "$tokenNumber";
        // changeQtyTextField(context);
      }

      //DB Error
      else {
        stop();
        dialogBox(context, "Please try again later");
      }
    } catch (e) {
      stop();
      dialogBox(context, e.toString());
    }
  }
}
