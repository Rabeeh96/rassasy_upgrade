import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/order/kartPage.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_detail_page.dart';
import 'search_items.dart';

class OrderCreateView extends StatefulWidget {
 final String uID, tableID, sectionType, tableHead;
 final int orderType;

  const OrderCreateView({super.key, required this.tableID, required this.tableHead, required this.uID, required this.sectionType, required this.orderType,});

  @override
  State<OrderCreateView> createState() => _OrderCreateViewState();
}

class _OrderCreateViewState extends State<OrderCreateView> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.posFunctions(sectionType: widget.sectionType,uUID: widget.uID);
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
            Text(
              widget.tableHead,
             style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
             // style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Table Order',
                  style: customisedStyle(context, Color(0xff585858), FontWeight.w400, 14.0),

                ),
                Obx(() => Text(
                      orderController.tokenNumber.value,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),

                    )),
              ],
            ),
          ],
        ),
        actions: [
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
      body: Column(
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
                          "Choose items",
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
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Veg Only",
                                        style: TextStyle(
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
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width / 3.2,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(5.0),
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         orderController.isVeg.value = false;
                      //       },
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           border:
                      //               Border.all(color: const Color(0xffDBDBDB)),
                      //           borderRadius: BorderRadius.circular(5),
                      //         ),
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 8, right: 8, top: 4, bottom: 4),
                      //           child: Row(
                      //             children: [
                      //               SvgPicture.asset(
                      //                 "assets/svg/veg_mob.svg",
                      //                 color: orderController.isVeg.value == true
                      //                     ? const Color(0xff00775E)
                      //                     : const Color(0xffDF1515),
                      //               ),
                      //               const Padding(
                      //                 padding: EdgeInsets.only(left: 8.0),
                      //                 child: Text(
                      //                   "Veg Only",
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     color: Color(0xff585858),
                      //                   ),
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
          DividerStyle(),
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
              ? Container(height: 500, child: const Center(child: CircularProgressIndicator()))
              : Expanded(
                  child:

                Obx(() =>   ListView.separated(separatorBuilder: (context, index) => DividerStyle(),
                  itemCount: orderController.productList.length,
                  itemBuilder: (context, index) {
                    var alreadyExist =  orderController.checking(orderController.productList[index].productID);
                    print("-----------------------already $alreadyExist");
                    return GestureDetector(
                      onTap: () async {

                      },
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20,
                              top: 10,
                              bottom: 10
                          ),
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
                                    child: Container(
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
                              Obx(() =>  Container(
                                height: MediaQuery.of(context).size.height / 8.5,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // Set border radius to make the Container round
                                ),
                                child:

                                Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        // Clip image to match the rounded corners of the Container
                                        child: Image.network(
                                          orderController.productList[index].productImage != ""
                                              ? orderController.productList[index].productImage
                                              : 'https://picsum.photos/250?image=9',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    /// Quantity increment on case




                                    orderController.quantityIncrement.value?
                                    /// The quantity increment is on here, so make sure this product has been added already.
                                    alreadyExist[0] ?
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
                                                  var alreadyExist =  orderController.checking(orderController.productList[index].productID);
                                                  orderController.updateQty(index: alreadyExist[1], type: 0);
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  color: Colors.white,
                                                ),
                                              ),
                                             Obx(() =>
                                              alreadyExist[0]?Text(
                                                orderController.orderItemList[alreadyExist[1]]["Qty"],
                                                style: customisedStyle(context, Colors.white, FontWeight.w400, 18.0),
                                              ):Container(),
                                            ),

                                              GestureDetector(
                                                onTap: () {
                                                  var alreadyExist =  orderController.checking(orderController.productList[index].productID);
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
                                    ):
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: ()async{
                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                          var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                          orderController.unitPriceAmountWR.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.inclusiveUnitPriceAmountWR.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.vatPer.value = double.parse(orderController.productList[index].vatsSalesTax);
                                          orderController.gstPer.value = double.parse(orderController.productList[index].gSTSalesTax);

                                          orderController.priceListID.value = orderController.productList[index].defaultUnitID;
                                          orderController.productName.value = orderController.productList[index].productName;
                                          orderController.item_status.value = "pending";
                                          orderController.unitName.value = orderController.productList[index].defaultUnitName;

                                          var taxDetails = orderController.productList[index].taxDetails;
                                          if (taxDetails != "") {
                                            orderController.productTaxID.value = taxDetails["TaxID"];
                                            orderController.productTaxName.value = taxDetails["TaxName"];
                                          }

                                          orderController.detailID.value = 1;
                                          orderController.salesPrice.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.purchasePrice.value = orderController.productList[index].defaultPurchasePrice;
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

                                          setState(() {

                                          });


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
                                                  side: const BorderSide(
                                                      color: Color(0xffF25F29)),
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child:   Center(
                                                child: Text(
                                                  'Add',
                                                  style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 15.0),
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
                                    ):
                                    /// Quantity increment off case
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                        onTap: ()async{
                                          SharedPreferences prefs = await SharedPreferences.getInstance();

                                          var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                          orderController.unitPriceAmountWR.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.inclusiveUnitPriceAmountWR.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.vatPer.value = double.parse(orderController.productList[index].vatsSalesTax);
                                          orderController.gstPer.value = double.parse(orderController.productList[index].gSTSalesTax);

                                          orderController.priceListID.value = orderController.productList[index].defaultUnitID;
                                          orderController.productName.value = orderController.productList[index].productName;
                                          orderController.item_status.value = "pending";
                                          orderController.unitName.value = orderController.productList[index].defaultUnitName;

                                          var taxDetails = orderController.productList[index].taxDetails;
                                          if (taxDetails != "") {
                                            orderController.productTaxID.value = taxDetails["TaxID"];
                                            orderController.productTaxName.value = taxDetails["TaxName"];
                                          }

                                          orderController.detailID.value = 1;
                                          orderController.salesPrice.value = orderController.productList[index].defaultSalesPrice;
                                          orderController.purchasePrice.value = orderController.productList[index].defaultPurchasePrice;
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
                                                  side: const BorderSide(
                                                      color: Color(0xffF25F29)),
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child:   Center(
                                                child: Text(
                                                  'Add',
                                                  style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 15.0),
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


                                  ],
                                ),
                              ))
                              ,
                              // else







                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ))

          )

          )
        ],
      ),
      bottomNavigationBar:
      Obx(() => SizedBox(
        height: orderController.orderItemList.isNotEmpty ?
        MediaQuery.of(context).size.height / 5.9 :
        MediaQuery.of(context).size.height / 11,
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
                        child: Obx(() => orderController.groupIsLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : orderController.groupList.isEmpty
                            ? const Center(child: Text("Group Not Found!"))
                            : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: orderController.groupList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                orderController.selectedGroup.value = index;
                                orderController.productIsLoading.value = true;
                                orderController.getProductListDetail(orderController.groupList[index].groupID);
                                setState(() {});
                              },
                              child: Container(
                                /// width: MediaQuery.of(context).size.width / 5,
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
                                          13.0),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ))),
                    GestureDetector(
                        onTap: () {
                          // _showPopupAlert(context);
                          //  showPopover(
                          //
                          //    context: context,
                          //    bodyBuilder: (context) =>  ListItems(),
                          //    onPop: () => print('Popover was popped! here'),
                          //    direction: PopoverDirection.top,
                          //    width: 200,
                          //    height: 400,
                          //    arrowHeight: 15,
                          //    arrowWidth: 30,
                          //  );
                          //
                        },
                        child: SvgPicture.asset("assets/svg/menu_mob.svg"))
                    //
                    //     GestureDetector(
                    //       onTap: () {
                    //         _showPopupAlert(context);
                    //
                    //       },
                    //       child:SvgPicture.asset("assets/svg/menu_mob.svg")
                    //     )
                  ],
                ),
              ),
            ),
            orderController.orderItemList.isNotEmpty
                ? GestureDetector(
              onTap: () async{
                Get.to(OrderDetailPage(tableID: widget.tableID,tableHead: widget.tableHead,uID: widget.uID,sectionType: widget.sectionType,orderType: widget.orderType,));

              },
              child: Container(
                height: MediaQuery.of(context).size.height / 12,
                decoration: const BoxDecoration(
                      color: Color(0xff00775E)
                ),
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
      ))
      ,
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
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Details",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
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
              Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.customerNameController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'Customer'),
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
                      "Balance",
                      style: customisedStyle(context, Color(0xff8C8C8C), FontWeight.w400, 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      orderController.currency.value,
                      style: customisedStyle(context, Color(0xff8C8C8C), FontWeight.w400, 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("00.0", style: customisedStyle(context, Color(0xff000000), FontWeight.w500, 15.0)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.phoneNumberController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'Phone No'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.deliveryManController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(hintTextStr: 'Delivery Man'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.platformController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(hintTextStr: 'Platform(Online Only)'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 5),
                child: Container(
                  height: MediaQuery.of(context).size.height / 17,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(const Color(0xffF25F29)),
                    ),
                    onPressed: () {
                      // Do something with the text

                      Get.back(); // Close the bottom sheet
                    },
                    child: Text(
                      'save'.tr,
                      style: customisedStyle(context, Colors.white, FontWeight.normal, 12.0),
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

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[400],
            child: const Center(child: Text('Entry D')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[500],
            child: const Center(child: Text('Entry E')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text('Entry F')),
          ),
        ],
      ),
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
//                 'https://picsum.photos/250?image=9',
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
