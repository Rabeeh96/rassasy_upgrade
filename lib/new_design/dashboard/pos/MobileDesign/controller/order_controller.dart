import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/platform_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/model/deliveryMan.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/model/flavour.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/model/groupModel.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/model/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../model/customerModel.dart';
import 'pos_controller.dart';

class OrderController extends GetxController {
  ValueNotifier<bool> isVegNotifier = ValueNotifier<bool>(false); // Initialize with initial value
  final ValueNotifier<int> selectedGroupNotifierss = ValueNotifier<int>(0);

  ValueNotifier<bool> isOrderCreate = ValueNotifier<bool>(false); // Initialize with initial value
  var groupIsLoading = false.obs;
  var productIsLoading = false.obs;
  final ScrollController scrollController = ScrollController();

  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController platformNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController platformKartController = TextEditingController();
  TextEditingController searchKartController = TextEditingController();
  TextEditingController searchListController = TextEditingController();
  TextEditingController categoryNameKartController = TextEditingController();
  TextEditingController unitPriceChangingController = TextEditingController();
  TextEditingController rowCountController = TextEditingController();

  TextEditingController heightController = TextEditingController();

  TextEditingController widthController = TextEditingController();

  TextEditingController amountFontSizeController = TextEditingController();

  TextEditingController productNameFontSizeController = TextEditingController();

  TextEditingController groupNameFontSizeController = TextEditingController();

  TextEditingController descriptionFontSizeController = TextEditingController();

  TextEditingController heightImageSizeController = TextEditingController();

  TextEditingController widthImageSizeController = TextEditingController();

  String selectedFontSize = 'Medium';
  Rx<FontWeight> selectedFontWeight = FontWeight.normal.obs;
  Rx<FontWeight> productFontWeight = FontWeight.normal.obs;
  Rx<FontWeight> groupFontWeight = FontWeight.normal.obs;
  Rx<FontWeight> amountFontWeight = FontWeight.normal.obs;
  Rx<FontWeight> descriptionFontWeight = FontWeight.normal.obs;

  final List<Map<String, FontWeight>> fontWeights = [
    {'Regular': FontWeight.normal},
    {'SemiBold': FontWeight.w600},
    {'Bold': FontWeight.bold},
  ];

  // Method to update font weight
  // void updateFontWeight(FontWeight newWeight, String type) {
  //   if (type == 'product_weight') {
  //     productFontWeight.value = newWeight;
  //   } else if (type == 'group_weight') {
  //     groupFontWeight.value = newWeight;
  //   } else if (type == 'description_weight') {
  //     print("type  $type");
  //     descriptionFontWeight.value = newWeight;
  //   } else if (type == 'amount_weight') {
  //     amountFontWeight.value = newWeight;
  //   } else {
  //     amountFontWeight.value = newWeight;
  //   }
  // }

   Map<FontWeight, int> fontWeightToInt = {
    FontWeight.normal: 400,
    FontWeight.bold: 700,
    FontWeight.w600: 600,
    // Add any other mappings as needed
  };

  FontWeight intToFontWeight(int weight) {
    switch (weight) {
      case 100:
        return FontWeight.w100;
      case 200:
        return FontWeight.w200;
      case 300:
        return FontWeight.w300;
      case 400:
        return FontWeight.w400; // Normal
      case 500:
        return FontWeight.w500;
      case 600:
        return FontWeight.w600;
      case 700:
        return FontWeight.w700; // Bold
      case 800:
        return FontWeight.w800;
      case 900:
        return FontWeight.w900;
      default:
        return FontWeight.normal; // Default to normal weight
    }
  }

  Future<void> updateFontWeight(FontWeight newWeight, String type) async {
    print("new weight $newWeight");
    print("new type $type");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int weightValue = fontWeightToInt[newWeight] ?? 400; // Default value
print("weightValue   $weightValue");
    switch (type) {
      case 'product_weight':
        productFontWeight.value = newWeight;
        await prefs.setInt('product_weight', weightValue);
        print("ty${prefs.getInt('product_weight')}");
        break;
      case 'group_weight':
        groupFontWeight.value = newWeight;
        await prefs.setInt('group_weight', weightValue);
        break;
      case 'description_weight':
        descriptionFontWeight.value = newWeight;
        await prefs.setInt('description_weight', weightValue);
        break;
      case 'amount_weight':
        amountFontWeight.value = newWeight;
        await prefs.setInt('amount_weight', weightValue);
        break;
      default:
      // Default case
        amountFontWeight.value = newWeight;
        await prefs.setInt('amount_weight', weightValue);
        break;
    }
  }

  // Future<void> updateFontWeight(FontWeight newWeight, String type) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int weightValue = fontWeightToInt[newWeight] ?? 400; // Default to 400 if not found
  //   if (type == 'product_weight') {
  //     productFontWeight.value = newWeight;
  //     await prefs.setInt('product_weight', weightValue);
  //   } else if (type == 'group_weight') {
  //     groupFontWeight.value = newWeight;
  //     await prefs.setInt('group_weight', weightValue);
  //   } else if (type == 'description_weight') {
  //     descriptionFontWeight.value = newWeight;
  //     await prefs.setInt('description_weight', weightValue);
  //   } else if (type == 'amount_weight') {
  //     amountFontWeight.value = newWeight;
  //     await prefs.setInt('amount_weight', weightValue);
  //   } else {
  //     amountFontWeight.value = newWeight;
  //     await prefs.setInt('amount_weight', weightValue); // Default case
  //   }
  // }



  double amountFontSize = 15.0;
  double productFontSize = 15.0;
  double groupFontSize = 13.0;
  double descriptionFontSize = 13.0;

  var rowCountGridView = 2;
  var heightOfITem = 12.0;
  var widthOfItem = 4.0;
  late ValueNotifier<int> productSearchNotifier;
  var detailPage = 'item_add'.obs;
  var isShowImage = true.obs;
  var isArrange = true.obs;
  RxBool showProductDescription = true.obs;
  RxBool showWegOrNoVeg = true.obs;
  var productNameDetail = '';
  var indexDetail = 0;
  var heightOfImage = 8.0;
  var widthOfImage = 8.0;

  ///added
  var selectedIndex = RxInt(0);

  saveDefaultValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('product_font_size', productFontSize).toString();
    prefs.setDouble('amount_font_size', amountFontSize).toString();
    prefs.setDouble('group_font_size', groupFontSize).toString();
    prefs.setDouble('height_of_item', heightOfITem).toString();
    prefs.setDouble('widthOfItem', widthOfItem);

    prefs.setBool('showProductDescription', showProductDescription.value);
    prefs.setBool('showWegOrNoVeg', showWegOrNoVeg.value);
    prefs.setDouble('description_fontSize', descriptionFontSize).toString();
    prefs.setInt('count_of_row', rowCountGridView).toString();
    prefs.setBool('show_product_image', isShowImage.value);
    prefs.setDouble('heightOfImage', heightOfImage);
    prefs.setDouble('widthOfImage', widthOfImage);
  }

  getDefaultValue() async {
    detailPage = 'item_add'.obs;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    amountFontSize = prefs.getDouble('amount_font_size') ?? 15.0;
    productFontSize = prefs.getDouble('product_font_size') ?? 15.0;
    groupFontSize = prefs.getDouble('group_font_size') ?? 13.0;
    rowCountGridView = prefs.getInt('count_of_row') ?? 2;
    heightOfITem = prefs.getDouble('height_of_item') ?? 12.0;
    descriptionFontSize = prefs.getDouble('description_fontSize') ?? 13.0;
    widthOfItem = prefs.getDouble('widthOfItem') ?? 4.0;
    heightOfImage = prefs.getDouble('heightOfImage') ?? 8.0;
    widthOfImage = prefs.getDouble('widthOfImage') ?? 8.0;


    heightImageSizeController.text = heightOfImage.toString();
    widthImageSizeController.text = widthOfImage.toString();
    productNameFontSizeController.text = productFontSize.toString();
    amountFontSizeController.text = amountFontSize.toString();

    groupNameFontSizeController.text = groupFontSize.toString();
    heightController.text = heightOfITem.toString();
    widthController.text = widthOfItem.toString();
    descriptionFontSizeController.text = descriptionFontSize.toString();
    rowCountController.text = rowCountGridView.toString();

    showProductDescription.value = prefs.getBool('showProductDescription') ?? true;
    showWegOrNoVeg.value = prefs.getBool('showWegOrNoVeg') ?? true;
    isShowImage.value = prefs.getBool('show_product_image') ?? true;
    productFontWeight.value= intToFontWeight(prefs.getInt('product_weight')!) ;
    groupFontWeight.value= intToFontWeight(prefs.getInt('group_weight')!);
    descriptionFontWeight.value=intToFontWeight(prefs.getInt('description_weight')!);
    amountFontWeight.value=intToFontWeight(prefs.getInt('amount_weight')!);
  }

  // Method to update selected index
  void selectIndex(int index) {
    selectedIndex.value = index;
  }

  RxBool printAfterPayment = false.obs;
  RxBool autoFocusField = false.obs;
  RxString currency = "".obs;

  RxString user_name = "".obs;
  RxString tokenNumber = "".obs;
  RxString customerBalance = "0.0".obs;

  RxBool isGst = false.obs;
  RxBool isVat = false.obs;
  RxInt ledgerID = 1.obs;
  RxBool isComplimentary = false.obs;
  RxBool quantityIncrement = false.obs;

  RxList orderItemList = [].obs;
  RxList searchOrderItemList = [].obs;
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
  RxBool unitPriceEdit = false.obs;
  RxList kartChange = [].obs;
   filterList(String query) {
    String query = searchListController.text.toLowerCase();
    if (query.isEmpty) {
      searchOrderItemList.value = List.from(orderItemList); // Show all items if query is empty
    } else {
      searchOrderItemList.value = orderItemList.where((item) {
        return item["ProductName"].toLowerCase().contains(query);
      }).toList();
    }
  }

  bool checkValueInList(value) {
    return kartChange.contains(value);
  }

  changeStatus(status) {
    for (var i = 0; i < kartChange.length; i++) {
      orderItemList[i]["Status"] = status;
    }
    kartChange.clear();
    orderItemList.refresh();
    update();
    totalAmount();
  }

  returnStatus(status) {
    if (status == "pending") {
      return "Pending";
    } else if (status == "delivered") {
      return "Delivered";
    } else {
      return "Take away";
    }
  }

  RxString actualProductTaxName = "".obs;
  RxString unitPriceAmount = "0.00".obs;
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
      return const Color(0xff000000);
    } else {
      return const Color(0xff034FC1);
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
      unitPriceAmount.value = (unit.value).toString();
      var taxAmount = (unit.value * exclusivePer.value) / 100;
      inclusiveUnitPriceAmountWR.value = (unit.value + taxAmount).toString();
      unit.value = unit.value;
    } else {
      var taxAmount = (unit.value * inclusivePer.value) / (100 + inclusivePer.value);
      print(taxAmount);
      unit.value = unit.value - taxAmount;
      inclusiveUnitPriceAmountWR.value = (unit.value + taxAmount).toString();
      unitPriceAmount.value = (unit.value).toString();
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

  ///add aitems to lsit
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
      "UnitPrice": unitPriceAmount.value,
      "RateWithTax": "${rateWithTax.value}",
      "CostPerPrice": costPerPrice.value,
      "PriceListID": priceListID.value,
      "DiscountPerc": "0",
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
      "Flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "InclusivePrice": inclusiveUnitPriceAmountWR.value,
      "TotalTaxRounded": "${totalTax.value}",
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
      "unitPriceRounded": roundStringWith(unitPriceAmount.value),
      "quantityRounded": roundStringWith(quantity.value.toString()),
      "netAmountRounded": roundStringWith(netAmount.value.toString()),
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "TAX1Perc": "0",
      "TAX1Amount": "0",
      "TAX2Perc": "0",
      "TAX2Amount": "0",
      "TAX3Perc": "0",
      "TAX3Amount": "0",
      "KFCAmount": "0",
      "BatchCode": "0",
      "SerialNos": [],
    };

    print("--------------------data $data");

    orderItemList[index] = data;
    clearDetails();
    totalAmount();
  }

  clearDetails() {
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
    unitPriceAmount = "0.00".obs;
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
    print("-------------------------------- ${unitPriceAmount.value}");

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

    print("------${checkVat}------${inclusivePer.value}----------${vatPer.value}--------${exclusivePer}--------------------------------");
    if (checkGst == true) {
      taxType = "GST Intra-state B2C".obs;
      taxID = 22.obs;
      if (isInclusive.value == true) {
        inclusivePer.value = inclusivePer.value + gstPer.value;
      } else {
        exclusivePer.value = exclusivePer.value + gstPer.value;
      }
    }

    unit.value = double.parse(unitPriceAmount.value);
    print("inclusivePer.value ${inclusivePer.value}");
    print("coming value ${unit.value}");

    if (inclusivePer.value == 0.0) {
      unitPriceAmount.value = (unit.value).toString();
      var taxAmount = (unit.value * exclusivePer.value) / 100;
      inclusiveUnitPriceAmountWR.value = (unit.value + taxAmount).toString();
      unit.value = unit.value;
    } else {
      var taxAmount = (unit.value * inclusivePer.value) / (100 + inclusivePer.value);
      unit.value = unit.value - taxAmount;
      inclusiveUnitPriceAmountWR.value = (unit.value + taxAmount).toString();
      unitPriceAmount.value = (unit.value).toString();
    }
    discount.value = 0.0;
    percentageDiscount.value = 0;
    discountAmount.value = 0;
    grossAmount.value = quantity.value * unit.value;
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
      "UnitPrice": unitPriceAmount.value,
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
      "Flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "unitPriceRounded": roundStringWith(unitPriceAmount.value),
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
      "TAX1Perc": "0",
      "TAX1Amount": "0",
      "TAX2Perc": "0",
      "TAX2Amount": "0",
      "TAX3Perc": "0",
      "TAX3Amount": "0",
      "KFCAmount": "0",
      "BatchCode": "0",
      "SerialNos": [],
    };

    log_data(" data $data");
    orderItemList.insert(0, data);
    ///heree adding item to search
    searchOrderItemList.value=orderItemList;

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
    unitPriceAmount.value = orderItemList[indexChanging]["UnitPrice"].toString();
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

      if (isInclusive.value == true) {
        inclusivePer = inclusivePer + vatPer.value;
      } else {
        exclusivePer = exclusivePer + vatPer.value;
      }
    }
    if (checkGst == true) {
      taxType.value = "GST Intra-state B2C";
      taxID.value = 22;

      if (isInclusive.value == true) {
        inclusivePer = inclusivePer + gstPer.value;
      } else {
        exclusivePer = exclusivePer + gstPer.value;
      }
    }

    unit = double.parse(unitPriceAmount.value);

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
      "UnitPrice": unitPriceAmount.value,
      "RateWithTax": "${rateWithTax.value}",
      "CostPerPrice": costPerPrice.value,
      "PriceListID": priceListID.value,
      "DiscountPerc": '0',
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
      "Flavour": flavourID.value,
      "Flavour_Name": flavourName.value,
      "TaxableAmount": "${taxableAmountPost.value}",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "${gstPer.value}",
      "is_inclusive": isInclusive.value,
      "unitPriceRounded": roundStringWith(unitPriceAmount.value),
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
      "TAX1Perc": "0",
      "TAX1Amount": "0",
      "TAX2Perc": "0",
      "TAX2Amount": "0",
      "TAX3Perc": "0",
      "TAX3Amount": "0",
      "KFCAmount": "0",
      "BatchCode": "0",
      "SerialNos": [],
    };

    log_data(data);
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
      if (orderItemList[i]["ProductID"] == proID) {
        return [true, i];
      }
    }
    return [false, 0];
  }

  returnQuantity(int index) {
    var qty = orderItemList[index]["Qty"];
    return qty;
  }

  checkAndReturnQty(int proID) {
    for (var i = 0; i < orderItemList.length; i++) {
      if (orderItemList[i]["ProductID"] == proID) {
        return orderItemList[i]["Qty"];
      }
    }
    return "Add";
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
    try {
      var dictionary = {
        "unq_id": orderItemList[index]["unq_id"],
      };
      if (orderItemList[index]["detailID"] == 0) {
        deletedList.add(dictionary);
      }
      orderItemList.removeAt(index);
      totalAmount();
      update();
    } catch (e) {
      print("---------${e.toString()}");
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  var flavourList = <FlavourListModelClass>[].obs;
  var groupList = <GroupListModelClass>[].obs;
  var productList = <ProductListModel>[].obs;
  var searchProductList = <ProductListModel>[].obs;

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
    // loader dd
    // start(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    productSearchNotifier = ValueNotifier(2);

    groupList.clear();
    //changeVal(widget.orderType);
    printAfterPayment.value = prefs.getBool("printAfterPayment") ?? false;
    currency.value = prefs.getString('CurrencySymbol') ?? "";
    isGst.value = prefs.getBool("check_GST") ?? false;
    isVat.value = prefs.getBool("checkVat") ?? false;
    ledgerID.value = prefs.getInt("Cash_Account") ?? 1;
    customerNameController.text = "walk in customer";
    phoneNumberController.text = "";
    isComplimentary.value = prefs.getBool("complimentary_bill") ?? false;
    quantityIncrement.value = prefs.getBool("qtyIncrement") ?? false;

    if (sectionType == "Edit") {
      await getOrderDetails(uID: uUID);
    }
    await getCategoryListDetail(sectionType);
  }

  Future<void> getCategoryListDetail(sectionType) async {
    try {
      print("2");
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
      Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "is_used_group": true};
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
        print("1........................................................................11");
        groupList.clear();
        for (Map user in responseJson) {
          groupList.add(GroupListModelClass.fromJson(user));
        }
        print("..........2");
        if (sectionType != "Edit") {
          tokenNumber.value = n["TokenNumber"] ?? "";
        }

        groupIsLoading.value = false;
        if (groupList.isNotEmpty) {
          getProductListDetail(groupList[0].groupID);
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
        print("........................");
        productList.clear();
        for (Map user in responseJson) {
          productList.add(ProductListModel.fromJson(user));
        }
        print(".....ddddddddd...................");

        productIsLoading.value = false;
      } else if (status == 6001) {
        productList.clear();
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
      if (double.parse(orderItemList[i]["UnitPrice"].toString()) > 0.0) {
        returnVal = true;
      } else {
        return false;
      }
    }

    return returnVal;
  }

  /// update list



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
          dateOnly.value = responseJson["Date"] ?? "";
          tokenNumber.value = responseJson["TokenNumber"] ?? "";
          phoneNumberController.text = responseJson["Phone"] ?? "";
          customerNameController.text = responseJson["CustomerName"] ?? "";
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
          searchOrderItemList.clear();
          orderItemList.value = responseJson["SalesOrderDetails"];
          searchOrderItemList.value = responseJson["SalesOrderDetails"];

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

  /// create section
  createMethod({
    required BuildContext context,
    required int orderType,
    required String tableHead,
    required String sectionType,
    required bool isPayment,
    required String tableID,
    required String orderID,
    required String platformID,
  }) async {
    var netWork = await checkNetwork();
    if (netWork) {
      if (orderItemList.isEmpty) {
        popAlert(head: "Waring", message: "At least one product", position: SnackPosition.TOP);
      } else {
        bool val = await checkNonRatableItem();
        if (val) {
          createSalesOrderRequest(
              context: context,
              isPayment: isPayment,
              sectionType: sectionType,
              orderType: orderType,
              tableHead: tableHead,
              tableID: tableID,
              platformID: platformID,
              orderID: orderID);
        } else {
          popAlert(head: "Waring", message: "Price must be greater than 0", position: SnackPosition.TOP);
        }
      }
    } else {
      popAlert(head: "Alert", message: "You are connected to the internet", position: SnackPosition.TOP);
    }
  }

  final POSController posController = Get.put(POSController());

  /// function for create
  Future<Null> createSalesOrderRequest({
    required BuildContext context,
    required bool isPayment,
    required int orderType,
    required String tableID,
    required String tableHead,
    required String sectionType,
    required String platformID,
    required String orderID,
  }) async {
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

      String url = '$baseUrl/posholds/create-pos/salesOrder/';

      if (sectionType == "Edit") {
        url = '$baseUrl/posholds/edit/pos-sales-order/$orderID/';
      }
      log_data(
          "--------------------------printAfterOrder    --------------------------printAfterOrder   --------------------------   $orderItemList");

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
        "deleted_data": deletedList,
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
        "onlinePlatform":platformID
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
      List cancelPrint = n["final_data"] ?? [];
      print(responseJson);
      if (status == 6000) {
        stop();
        var id = n["OrderID"];

        Navigator.pop(context, [orderType, isPayment, id, tableID, tableHead]);

        if (printAfterOrder) {
          /// printing section
          posController.printSection(context: context, id: n["OrderID"], isCancelled: false, voucherType: "SO");
        }

        Future.delayed(const Duration(seconds: 1), () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var kot = prefs.getBool("KOT") ?? false;
          if (kot == true) {
            posController.printKOT(cancelList: cancelPrint, isUpdate: sectionType == "Edit" ? true : false, orderID: n["OrderID"], rePrint: false);

            /// commented kot print
            // PrintDataDetails.type = "SO";
            // PrintDataDetails.id = id;
            // printKOT(id, false, [], false);
          } else {}
        });
      } else if (status == 6001) {
        stop();
        var errorMessage = n["message"] ?? "";
        popAlert(head: "Waring", message: errorMessage, position: SnackPosition.TOP);
      } else if (status == 6002) {
        stop();
        var errorMessage = n["error"] ?? "";
        popAlert(head: "Waring", message: errorMessage, position: SnackPosition.TOP);
      } else if (status == 6003) {
        stop();
        popAlert(head: "Waring", message: "Change token number and retry please", position: SnackPosition.TOP);

        /// commented repeated token number issuer solution
        // tokenNumberController.text = "$tokenNumber";
        // changeQtyTextField(context);
      }

      //DB Error
      else {
        stop();
        popAlert(head: "Error", message: "Please try again later", position: SnackPosition.TOP);
      }
    } catch (e) {
      stop();
      popAlert(head: "Error", message: e.toString(), position: SnackPosition.TOP);
    }
  }

  ///deliveryman
  var isCustomerLoading = true.obs;
  var dropdownvalue = 'Name'.obs;

  /// search item

  var items = [
    'Code',
    'Name',
    'Description',
  ].obs;

  var isLoading = false.obs;

  void searchItems({required String productName, required bool isCode, required bool isDescription}) async {
    isLoading.value = true;
    String baseUrl = BaseUrl.baseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyID = prefs.getString('companyID');
    var userID = prefs.getInt('user_id') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;

    var accessToken = prefs.getString('access') ?? '';
    var url = '$baseUrl/posholds/products-search-pos/';
    var payload = {
      "IsCode": isCode,
      "IsDescription": isDescription,
      "BranchID": branchID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "product_name": productName,
      "length": productName.length,
      "type": ""
    };

    try {
      print("payload   $payload");
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to headers
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        print("3d");
        var data = jsonDecode(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var responseJson = n["data"];
        searchProductList.clear();
        for (Map user in responseJson) {
          searchProductList.add(ProductListModel.fromJson(user));
        }

        //  productList.assignAll(data['data']);
        update();
        print("7");
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      isLoading.value = false;
      print('Exception occurred: $e');
    }
  }

  void searchItemsTab({required String productName, required bool isCode, required bool isDescription}) async {
    isLoading.value = true;
    print("enter");
    String baseUrl = BaseUrl.baseUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyID = prefs.getString('companyID');
    var userID = prefs.getInt('user_id') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    print("brancvh");
    var accessToken = prefs.getString('access') ?? '';
    var url = '$baseUrl/posholds/products-search-pos/';
    print("rl $url");

    var payload = {
      "IsCode": isCode,
      "IsDescription": isDescription,
      "BranchID": branchID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "product_name": productName,
      "length": productName.length,
      "type": ""
    };
    print("payload $payload");

    try {
      print("payload   $payload");
      var response = await http.post(
        Uri.parse(url),
        body: jsonEncode(payload),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add token to headers
        },
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        print("response ");

        print("3d");
        var data = jsonDecode(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var responseJson = n["data"];
        print("res $responseJson");

        productList.clear();
        for (Map user in responseJson) {
          productList.add(ProductListModel.fromJson(user));
        }
        print("productList $productList");

        //  productList.assignAll(data['data']);
        update();
        print("7");
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      isLoading.value = false;
      print('Exception occurred: $e');
    }
  }

  var users = <DeliveryManModel>[].obs;

  /// list employee
  Future<void> fetchUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCustomerLoading.value = true;
    String baseUrl = BaseUrl.baseUrlV11;
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    final url = Uri.parse('$baseUrl/posholds/list/pos-users/');
    final payload = {
      "BranchID": branchID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "search": "",
      "is_deliveryman": true,
    };

    print("----url  $url");
    print("----payload  $payload");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add the token here
        },
        body: json.encode(payload));

    if (response.statusCode == 200) {
      isCustomerLoading.value = false;
      final jsonResponse = json.decode(response.body);

      users.assignAll((jsonResponse['data'] as List).map((data) => DeliveryManModel.fromJson(data)).toList());
    } else {
      isCustomerLoading.value = false;
      throw Exception('Failed to load users');
    }
  }

  ///
  Future<void> fetchCancelReason() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCustomerLoading.value = true;
    String baseUrl = BaseUrl.baseUrlV11;
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    final url = Uri.parse('$baseUrl/posholds/list/pos-users/');
    final payload = {
      "BranchID": branchID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "search": "",
      "is_deliveryman": true,
    };

    print("----url  $url");
    print("----payload  $payload");
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add the token here
        },
        body: json.encode(payload));

    if (response.statusCode == 200) {
      isCustomerLoading.value = false;
      final jsonResponse = json.decode(response.body);

      users.assignAll((jsonResponse['data'] as List).map((data) => DeliveryManModel.fromJson(data)).toList());
    } else {
      isCustomerLoading.value = false;
      throw Exception('Failed to load users');
    }
  }

  ///customer
  var isLoadingValue = true.obs;

  var customerList = <CustomerModel>[].obs;

  Future<void> fetchCustomers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoadingValue.value = true;
    String baseUrl = BaseUrl.baseUrl;
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    final url = Uri.parse('$baseUrl/posholds/pos-ledgerListByID/');
    final payload = {
      "BranchID": branchID,
      "CompanyID": companyID,
      "CreatedUserID": userID,
      "PriceRounding": BaseUrl.priceRounding,
      "load_data": true,
      "type_invoice": "SalesInvoice",
      "ledger_name": "",
      "length": ""
    };

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken', // Add the token here
        },
        body: json.encode(payload));

    print(response.body);

    if (response.statusCode == 200) {
      isLoadingValue.value = false;
      final jsonResponse = json.decode(response.body);
      customerList.assignAll((jsonResponse['data'] as List).map((data) => CustomerModel.fromJson(data)).toList());
    } else {
      isLoadingValue.value = false;
      throw Exception('Failed to load users');
    }
  }


  ///grp reorder
  void reorderGroups(int oldIndex, int newIndex) {

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = groupList.removeAt(oldIndex);
    groupList.insert(newIndex, item);
  }

}
