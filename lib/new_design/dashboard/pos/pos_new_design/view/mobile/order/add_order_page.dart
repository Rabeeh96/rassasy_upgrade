import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/detail_page/customer_detail.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/detail_page/group_list.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/detail_page/select_deliveryman.dart';
import 'package:popover/popover.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kartPage.dart';
import 'product_detail_page.dart';
import 'search_items.dart';

class OrderCreateView extends StatefulWidget {
  final String uID, tableID, sectionType, tableHead;
  final int orderType;
  final List cancelOrder;

  const OrderCreateView({
    super.key,
    required this.tableID,
    required this.tableHead,
    required this.uID,
    required this.sectionType,
    required this.cancelOrder,
    required this.orderType,
  });

  @override
  State<OrderCreateView> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends State<OrderCreateView> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.posFunctions(sectionType: widget.sectionType, uUID: widget.uID);
  }

  void onDropdownChanged(int newIndex) {
    orderController.selectedGroup.value = newIndex;
    orderController.productIsLoading.value = true;
    orderController.getProductListDetail(orderController.groupList[newIndex].groupID);
    scrollToIndex(newIndex);
  }

  void scrollToIndex(int index) {
    double scrollPosition = index * (MediaQuery.of(context).size.width / 5); // Adjust the multiplier based on your item width
    orderController.scrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  widget.tableHead,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
                  // style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                orderController.synMethod.value
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Obx(() => Text(
                              orderController.tokenNumber.value,
                              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                            )),
                      ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   crossAxisAlignment: CrossAxisAlignment.end,
                //   children: [
                //     Text(
                //       'Table_Order'.tr,
                //       style: customisedStyle(context, Color(0xff585858), FontWeight.w400, 14.0),
                //     ),
                //     Obx(() => Text(
                //       orderController.tokenNumber.value,
                //       style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                //     )),
                //
                //   ],
                // ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(() {
                  return orderController.synMethod.value
                      ? IconButton(
                          onPressed: () async {
                            start(context);
                            await orderController.fetchAndSaveProductGroupData();
                            var savedData = await orderController.loadSavedData("productGroupData");
                            var allProducts = [];
                            for (var i = 0; i < savedData.length; i++) {
                              var groupId = savedData[i]['ProductGroupID'];
                              var groupProducts = await orderController.fetchAndSaveProductData(groupId);
                              if (groupProducts is List) {
                                allProducts.addAll(groupProducts);
                              }
                            }
                            await orderController.saveAllProduct(allProducts);
                            await stop();
                          },
                          icon: Text(
                            'Sync',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                          ))
                      : Container();
                }),
                Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: IconButton(
                      onPressed: () {
                        addDetails();
                      },
                      icon: SvgPicture.asset('assets/svg/Info_mob.svg')),
                )
              ],
            ),
          ],
        ),
        actions: const [
          // Padding(
          //   padding: const EdgeInsets.only(right: 6.0),
          //   child: IconButton(
          //       onPressed: () {
          //         addDetails();
          //       },
          //       icon: SvgPicture.asset('assets/svg/Info_mob.svg')),
          // )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            'choose_item'.tr,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: orderController.isVegNotifier,
                          builder: (context, isVegValue, child) {
                            return GestureDetector(
                              onTap: () {
                                orderController.isVegNotifier.value = !isVegValue; // Toggle the value
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffDBDBDB)),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/veg_mob.svg",
                                        color: isVegValue ? const Color(0xff00775E) : const Color(0xffDF1515),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'veg_only'.tr,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff585858),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SearchItems());
                      },
                      child: SvgPicture.asset("assets/svg/search-normal.svg"),
                    )
                  ],
                ),
              ),
            ),
            dividerStyle(),
            orderController.groupList.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(left: 30.0, bottom: 8, top: 8),
                          child: Text(
                            orderController.groupList[orderController.selectedGroup.value].groupName,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(),

            //   diningController.selectedIndexNotifier.value =
            /// product list
            Obx(() => orderController.productIsLoading.value
                ? SizedBox(height: 500, child: const Center(child: CircularProgressIndicator()))
                : Expanded(
                    child: Obx(() => ListView.separated(
                          separatorBuilder: (context, index) => dividerStyle(),
                          itemCount: orderController.productList.length,
                          itemBuilder: (context, index) {
                            var alreadyExist = orderController.checking(orderController.productList[index].productID);
                            print("-----------------------already $alreadyExist");
                            return GestureDetector(
                              onTap: () async {},
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/veg_mob.svg",
                                            color: orderController.productList[index].vegOrNonVeg == "Non-veg"
                                                ? const Color(0xff00775E)
                                                : const Color(0xffDF1515),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0, top: 8),
                                            child: SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              child: Text(
                                                orderController.productList[index].productName,
                                                style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  orderController.currency.value,
                                                  style: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.w400, 13.0),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                    roundStringWith(orderController.productList[index].defaultSalesPrice),
                                                    style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                                  ),
                                                ),
                                                //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(() => Container(
                                            height: MediaQuery.of(context).size.height / 8.5,
                                            width: MediaQuery.of(context).size.width / 4,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              // Set border radius to make the Container round
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                Positioned.fill(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    // Clip image to match the rounded corners of the Container
                                                    child: Image.network(
                                                      orderController.productList[index].productImage != ""
                                                          ? orderController.productList[index].productImage
                                                          : 'https://www.api.viknbooks.com/media/uploads/Group_5140.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),

                                                /// Quantity increment on case

                                                Obx(
                                                  () => orderController.quantityIncrement.value ?
                                                      /// The quantity increment is on here, so make sure this product has been added already.
                                                      alreadyExist[0]
                                                          ?
                                                      Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height / 30,
                                                                decoration: const BoxDecoration(
                                                                  color: Color(0xffF25F29),
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(10),
                                                                    // Match the bottom left and right corners of the Container
                                                                    bottomRight: Radius.circular(10),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 3.0, right: 3),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    children: <Widget>[
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          var alreadyExist =
                                                                              orderController.checking(orderController.productList[index].productID);
                                                                          if (double.parse(
                                                                                  orderController.orderItemList[alreadyExist[1]]["Qty"].toString()) >=
                                                                              2.0) {
                                                                            orderController.updateQty(index: alreadyExist[1], type: 0);
                                                                          }
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.remove,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                      Obx(
                                                                        () => alreadyExist[0]
                                                                            ? Text(
                                                                                roundStringWith(
                                                                                    orderController.orderItemList[alreadyExist[1]]["Qty"].toString()),
                                                                                style: customisedStyle(context, Colors.white, FontWeight.w400, 16.0),
                                                                              )
                                                                            : Container(),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () {
                                                                          var alreadyExist =
                                                                              orderController.checking(orderController.productList[index].productID);
                                                                          orderController.updateQty(index: alreadyExist[1], type: 1);
                                                                        },
                                                                        child: const Icon(
                                                                          Icons.add,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Align(
                                                              alignment: Alignment.bottomCenter,
                                                              child: GestureDetector(
                                                                onTap: () async {
                                                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                                                  var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                                                  orderController.unitPriceAmount.value =
                                                                      orderController.productList[index].defaultSalesPrice;
                                                                  orderController.inclusiveUnitPriceAmountWR.value =
                                                                      orderController.productList[index].defaultSalesPrice;
                                                                  orderController.vatPer.value =
                                                                      double.parse(orderController.productList[index].vatsSalesTax);
                                                                  orderController.gstPer.value =
                                                                      double.parse(orderController.productList[index].gSTSalesTax);

                                                                  orderController.priceListID.value =
                                                                      orderController.productList[index].defaultUnitID;
                                                                  orderController.productName.value = orderController.productList[index].productName;
                                                                  orderController.item_status.value = "pending";
                                                                  orderController.unitName.value = orderController.productList[index].defaultUnitName;
                                                                  orderController.productDescription.value = orderController.productList[index].description;
                                                                  var taxDetails = orderController.productList[index].taxDetails;
                                                                  if (taxDetails != "") {
                                                                    orderController.productTaxID.value = taxDetails["TaxID"];
                                                                    orderController.productTaxName.value = taxDetails["TaxName"];
                                                                  }

                                                                  orderController.detailID.value = 1;
                                                                  orderController.salesPrice.value =
                                                                      orderController.productList[index].defaultSalesPrice;
                                                                  orderController.purchasePrice.value =
                                                                      orderController.productList[index].defaultPurchasePrice;
                                                                  orderController.productID.value = orderController.productList[index].productID;
                                                                  orderController.isInclusive.value = orderController.productList[index].isInclusive;

                                                                  orderController.detailIdEdit.value = 0;
                                                                  orderController.flavourID.value = "";
                                                                  orderController.flavourName.value = "";

                                                                  var newTax = orderController.productList[index].exciseData;

                                                                  if (newTax != "") {
                                                                    orderController.isExciseProduct.value = true;
                                                                    orderController.exciseTaxID.value = newTax["TaxID"];
                                                                    orderController.exciseTaxName.value = newTax["TaxName"];
                                                                    orderController.BPValue.value = newTax["BPValue"].toString();
                                                                    orderController.exciseTaxBefore.value = newTax["TaxBefore"].toString();
                                                                    orderController.isAmountTaxBefore.value = newTax["IsAmountTaxBefore"];
                                                                    orderController.isAmountTaxAfter.value = newTax["IsAmountTaxAfter"];
                                                                    orderController.exciseTaxAfter.value = newTax["TaxAfter"].toString();
                                                                  } else {
                                                                    orderController.exciseTaxID.value = 0;
                                                                    orderController.exciseTaxName.value = "";
                                                                    orderController.BPValue.value = "0";
                                                                    orderController.exciseTaxBefore.value = "0";
                                                                    orderController.isAmountTaxBefore.value = false;
                                                                    orderController.isAmountTaxAfter.value = false;
                                                                    orderController.isExciseProduct.value = false;
                                                                    orderController.exciseTaxAfter.value = "0";
                                                                  }

                                                                  orderController.unique_id.value = "0";
                                                                  orderController.calculation();
                                                                  orderController.update();
                                                                  setState(() {});

                                                                  /// commented for new tax working

                                                                  /// qty increment

                                                                  // if (qtyIncrement == true) {
                                                                  //   var checkingAlready = orderController.checking(orderController.priceListID.value);
                                                                  //   if (checkingAlready[0]) {
                                                                  //     orderController.unique_id.value = orderController.orderItemList[checkingAlready[1]].uniqueId;
                                                                  //     orderController.updateQty(type: 1,index:checkingAlready[1]);
                                                                  //   } else {
                                                                  //     orderController.unique_id.value = "0";
                                                                  //     orderController.calculation();
                                                                  //   }
                                                                  // } else {
                                                                  //   orderController.unique_id.value = "0";
                                                                  //   orderController.calculation();
                                                                  // }
                                                                },
                                                                child: InkWell(
                                                                  child: Container(
                                                                    height: MediaQuery.of(context).size.height / 30,
                                                                    width: 75,
                                                                    decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                        bottomLeft: Radius.circular(10),
                                                                        bottomRight: Radius.circular(10),
                                                                      ),
                                                                    ),
                                                                    child: DecoratedBox(
                                                                      decoration: ShapeDecoration(
                                                                        shape: RoundedRectangleBorder(
                                                                          side: const BorderSide(color: Color(0xffF25F29)),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                        color: Colors.white,
                                                                      ),
                                                                      child: Center(
                                                                        child: Text(
                                                                          'add'.tr,
                                                                          style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 15.0),
                                                                          // style: TextStyle(
                                                                          //   color: Color(0xffF25F29),
                                                                          // ),
                                                                          textAlign: TextAlign.center,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                      :

                                                      /// Quantity increment off case
                                                      Align(
                                                          alignment: Alignment.bottomCenter,
                                                          child: GestureDetector(
                                                            onTap: () async {
                                                              SharedPreferences prefs = await SharedPreferences.getInstance();

                                                              var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                                              orderController.unitPriceAmount.value =
                                                                  orderController.productList[index].defaultSalesPrice;
                                                              orderController.inclusiveUnitPriceAmountWR.value =
                                                                  orderController.productList[index].defaultSalesPrice;
                                                              orderController.vatPer.value =
                                                                  double.parse(orderController.productList[index].vatsSalesTax);
                                                              orderController.gstPer.value =
                                                                  double.parse(orderController.productList[index].gSTSalesTax);

                                                              orderController.priceListID.value = orderController.productList[index].defaultUnitID;
                                                              orderController.productName.value = orderController.productList[index].productName;
                                                              orderController.item_status.value = "pending";
                                                              orderController.unitName.value = orderController.productList[index].defaultUnitName;

                                                              var taxDetails = orderController.productList[index].taxDetails;

                                                              if (taxDetails != "") {
                                                                orderController.productTaxID.value = taxDetails["TaxID"];
                                                                orderController.productTaxName.value = taxDetails["TaxName"];
                                                              }

                                                              orderController.productDescription.value = orderController.productList[index].description;

                                                              orderController.detailID.value = 1;
                                                              orderController.salesPrice.value = orderController.productList[index].defaultSalesPrice;
                                                              orderController.purchasePrice.value =
                                                                  orderController.productList[index].defaultPurchasePrice;
                                                              orderController.productID.value = orderController.productList[index].productID;
                                                              orderController.isInclusive.value = orderController.productList[index].isInclusive;

                                                              orderController.detailIdEdit.value = 0;
                                                              orderController.flavourID.value = "";
                                                              orderController.flavourName.value = "";

                                                              var newTax = orderController.productList[index].exciseData;

                                                              if (newTax != "") {
                                                                orderController.isExciseProduct.value = true;
                                                                orderController.exciseTaxID.value = newTax["TaxID"];
                                                                orderController.exciseTaxName.value = newTax["TaxName"];
                                                                orderController.BPValue.value = newTax["BPValue"].toString();
                                                                orderController.exciseTaxBefore.value = newTax["TaxBefore"].toString();
                                                                orderController.isAmountTaxBefore.value = newTax["IsAmountTaxBefore"];
                                                                orderController.isAmountTaxAfter.value = newTax["IsAmountTaxAfter"];
                                                                orderController.exciseTaxAfter.value = newTax["TaxAfter"].toString();
                                                              } else {
                                                                orderController.exciseTaxID.value = 0;
                                                                orderController.exciseTaxName.value = "";
                                                                orderController.BPValue.value = "0";
                                                                orderController.exciseTaxBefore.value = "0";
                                                                orderController.isAmountTaxBefore.value = false;
                                                                orderController.isAmountTaxAfter.value = false;
                                                                orderController.isExciseProduct.value = false;
                                                                orderController.exciseTaxAfter.value = "0";
                                                              }

                                                              orderController.unique_id.value = "0";
                                                              orderController.calculation();

                                                              //setState(() {});
                                                              /// commented for new tax working

                                                              /// qty increment

                                                              // if (qtyIncrement == true) {
                                                              //   var checkingAlready = orderController.checking(orderController.priceListID.value);
                                                              //   if (checkingAlready[0]) {
                                                              //     orderController.unique_id.value = orderController.orderItemList[checkingAlready[1]].uniqueId;
                                                              //     orderController.updateQty(type: 1,index:checkingAlready[1]);
                                                              //   } else {
                                                              //     orderController.unique_id.value = "0";
                                                              //     orderController.calculation();
                                                              //   }
                                                              // } else {
                                                              //   orderController.unique_id.value = "0";
                                                              //   orderController.calculation();
                                                              // }
                                                            },
                                                            child: InkWell(
                                                              child: Container(
                                                                height: MediaQuery.of(context).size.height / 30,
                                                                width: 75,
                                                                decoration: const BoxDecoration(
                                                                  borderRadius: BorderRadius.only(
                                                                    bottomLeft: Radius.circular(10),
                                                                    bottomRight: Radius.circular(10),
                                                                  ),
                                                                ),
                                                                child: DecoratedBox(
                                                                  decoration: ShapeDecoration(
                                                                    shape: RoundedRectangleBorder(
                                                                      side: const BorderSide(color: Color(0xffF25F29)),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    color: Colors.white,
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'add'.tr,
                                                                      style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 15.0),
                                                                      // style: TextStyle(
                                                                      //   color: Color(0xffF25F29),
                                                                      // ),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            ),
                                          )),
                                      // else
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ))))
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => SizedBox(
            height: orderController.orderItemList.isNotEmpty ? MediaQuery.of(context).size.height / 5.9 : MediaQuery.of(context).size.height / 11,
            child: Column(
              children: [
                Container(
                  height: 1,
                  color: const Color(0xffE9E9E9),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 12,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///group list section
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 25,
                          width: MediaQuery.of(context).size.height / 3.5,
                          child: Obx(() {
                            if (orderController.groupIsLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (orderController.groupList.isEmpty) {
                              return const Center(child: Text("Group Not Found!"));
                            } else {
                              return GroupListView(scrollController: orderController.scrollController);
                            }
                          }),
                        ),

                        GestureDetector(
                            onTap: () async {
                              var resultData = await Get.to(SelectProductGroup());

                              if (resultData != null) {
                                onDropdownChanged(resultData[2]);
                                orderController.selectedGroup.value = resultData[2];
                                orderController.productIsLoading.value = true;

                                if (orderController.synMethod.value) {
                                  orderController.getProductListDetailLocal(resultData[1]);
                                  //  await orderController.loadLocalData();
                                } else {
                                  orderController.getProductListDetail(resultData[1]);
                                }
                              }
                            },
                            child: SvgPicture.asset("assets/svg/menu_mob.svg"))
                      ],
                    ),
                  ),
                ),
                orderController.orderItemList.isNotEmpty
                    ? GestureDetector(
                        onTap: () async {
                          var resultData = await Get.to(KartPage(
                            tableID: widget.tableID,
                            tableHead: widget.tableHead,
                            uID: widget.uID,
                            sectionType: widget.sectionType,
                            orderType: widget.orderType,
                          ));

                          setState(() {});
                          if (resultData != null) {
                            Get.back(result: resultData);
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 12,
                          decoration: const BoxDecoration(color: Color(0xff00775E)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  '${orderController.orderItemList.length} Items Added',
                                  style: customisedStyle(context, const Color(0xffFfffff), FontWeight.normal, 16.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${orderController.currency} ',
                                      style: customisedStyle(context, const Color(0xffFfffff), FontWeight.w500, 16.0),
                                    ),
                                    Text(
                                      roundStringWith(orderController.totalNetP.toString()),
                                      style: customisedStyle(context, const Color(0xffFfffff), FontWeight.w500, 18.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          )),
    );
  }

  void addDetails() {
    Get.bottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          // Set border radius to the top left corner
          topRight: Radius.circular(10.0), // Set border radius to the top right corner
        ),
      ),
      backgroundColor: Colors.white,
      Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Details'.tr,
                      style: customisedStyle(context, Colors.black, FontWeight.w700, 18.0),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              dividerStyle(),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.customerNameController,
                    readOnly: true,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onTap: () async {
                      final result = await Get.to(CustomerDetailPage());

                      if (result != null) {
                        orderController.customerNameController.text = result[0];
                        orderController.ledgerID.value = result[2];
                        orderController.customerBalance.value = result[1];
                        orderController.update();
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(hintTextStr: 'customer'.tr),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      'balance'.tr,
                      style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      orderController.currency.value,
                      style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 15.0),
                    ),
                  ),
                  Obx(
                    () => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(orderController.customerBalance.value, style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0)),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 15, bottom: 15),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.phoneNumberController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                    keyboardType: TextInputType.phone,
                    decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'ph_no'.tr),
                  ),
                ),
              ),

              /// delivery man section
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width / 4,
              //     child: TextField(
              //       textCapitalization: TextCapitalization.words,
              //       controller: orderController.deliveryManController,
              //       style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              //     onTap: () async {
              //       final result = await Get.to(SelectDeliveryMan());
              //
              //       if (result != null) {
              //         orderController.deliveryManController.text = result[0];
              //
              //       }
              //     },
              //       readOnly: true,
              //       keyboardType: TextInputType.text,
              //       decoration: TextFieldDecoration.defaultTextFieldIcon(hintTextStr: 'Delivery Man'),
              //     ),
              //   ),
              // ),

              /// online plat form is commented
              // Padding(
              //   padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              //   child: Container(
              //     width: MediaQuery.of(context).size.width / 4,
              //     child: TextField(
              //       textCapitalization: TextCapitalization.words,
              //       controller: orderController.platformController,
              //       style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              //      readOnly: true,
              //       keyboardType: TextInputType.text,
              //       decoration: TextFieldDecoration.defaultTextFieldIcon(hintTextStr: 'Platform(Online Only)'),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 5),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 17,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(const Color(0xffF25F29)),
                    ),
                    onPressed: () {
                      // Do something with the text

                      Get.back(); // Close the bottom sheet
                    },
                    child: Text(
                      'save'.tr,
                      style: customisedStyle(context, Colors.white, FontWeight.normal, 15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupListView extends StatelessWidget {
  final OrderController orderController = Get.find<OrderController>();
  final ScrollController scrollController;

  GroupListView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: orderController.groupList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            orderController.selectedGroup.value = index;
            orderController.productIsLoading.value = true;

            pr("orderController.synMethod  ${orderController.synMethod}");
            if (orderController.synMethod.value) {
              orderController.getProductListDetailLocal(orderController.groupList[index].groupID);
              //  await orderController.loadLocalData();
            } else {
              orderController.getProductListDetail(orderController.groupList[index].groupID);
            }
            //  orderController.getProductListDetail(orderController.groupList[index].groupID);
          },
          child: Obx(() {
            return Container(
              decoration: BoxDecoration(
                color: orderController.selectedGroup.value == index ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Text(
                    orderController.groupList[index].groupName,
                    style: customisedStyle(
                      context,
                      orderController.selectedGroup.value == index ? Colors.white : Colors.black,
                      FontWeight.w400,
                      13.0,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// old stack
///old
// Stack(
//   alignment: Alignment.bottomCenter,
//   children: <Widget>[
//     Container(
//       height:
//           MediaQuery.of(context).size.height /
//               7,
//       width:
//           MediaQuery.of(context).size.width /
//               4,
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.stretch,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Positioned.fill(
//             child: ClipRRect(
//               borderRadius:
//                   BorderRadius.circular(10),
//               child: Image.network(
//                 'https://www.api.viknbooks.com/media/uploads/Rassasy.png',
//                 fit: BoxFit.cover,
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//     Positioned(
//       bottom: 15,
//       child: GestureDetector(
//         onTap: () {
//           print("gjhdfghdf");
//           orderController.isAddItem.value =      true;
//           orderController.isOrderCreate.value=true;
//         },
//         child: SizedBox(
//           height: MediaQuery.of(context)
//                   .size
//                   .height /
//               30,
//           width: MediaQuery.of(context)
//                   .size
//                   .width /
//               6,
//           child: DecoratedBox(
//             decoration: ShapeDecoration(
//               shape: RoundedRectangleBorder(
//                 side: const BorderSide(
//                     color: Color(0xffF25F29)),
//                 borderRadius:
//                     BorderRadius.circular(10),
//               ),
//               color: Colors.white,
//             ),
//             child: const Center(
//               child: Text(
//                 'Add',
//                 style: TextStyle(
//                   color: Color(0xffF25F29),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ),
//       ),
//     ),
//   ],
// )
