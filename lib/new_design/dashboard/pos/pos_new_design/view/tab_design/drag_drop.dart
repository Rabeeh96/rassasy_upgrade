
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/payment_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/pos_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart'; // Import the package
import '../../controller/draggable_controller.dart';
import '../../controller/platform_controller.dart';
import '../detail_page/customer_detail.dart';

class DragDrop extends StatefulWidget {
  final String uID,  sectionType;

  const DragDrop({
    super.key,
    required this.uID,
    required this.sectionType,

  });
  @override
  State<DragDrop> createState() => _DragDropState();
}


class _DragDropState extends State<DragDrop> {
  DragAndDropController orderController = Get.put(DragAndDropController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.productList.clear();
    orderController.groupList.clear();
    orderController.getCategoryListDetail(1);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDFDFD),
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Choose Items",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            border:
            Border(top: BorderSide(color: Color(0xffE9E9E9), width: 2))),
        child: Row(
          children: [
            ///group list section

            ///
            Flexible(
                flex: 3,
                child: groupListReorderableWidget()
            ),

            ///product list section
            Flexible(
              flex: 10,
              child: productListReorderableWidget()

            ),
            //here we need condition

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: (){},
        child: Text("Save",style: customisedStyle(context, Colors.white, FontWeight.w400, 13.0),),
      ),
    );
  }
  Widget groupListReorderableWidget(){
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            right: BorderSide(color: Color(0xffE9E9E9))),
      ),
      width: MediaQuery.of(context).size.width / 4,
      child: Obx(() {
        if (orderController.groupIsLoading.value) {
          return const Center(
              child: CircularProgressIndicator());
        } else if (orderController.groupList.isEmpty) {
          return const Center(
              child: Text("Group Not Found!"));
        } else {
          return ReorderableListView.builder(
            buildDefaultDragHandles: false,
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder:
                    (BuildContext context, Widget? child) {
                  final double animValue = Curves.easeInOut
                      .transform(animation.value);
                  final double scale =
                  lerpDouble(1, 1.1, animValue)!;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: child,
              );
            },
            onReorder: (oldIndex, newIndex) {
              // Print the IDs before reordering
              print("Reordering: Old index ID = ${orderController.groupList[oldIndex].groupID}, New index ID = ${orderController.groupList[newIndex].groupID}");

              // Adjust indices if needed
              if (newIndex > oldIndex) {
                newIndex -= 1;
              }
              final item = orderController.groupList
                  .removeAt(oldIndex);
              orderController.groupList
                  .insert(newIndex, item);

              // Print the updated list of IDs after reordering
              print("Reordered List IDs:");
              for (var group in orderController.groupList) {
                print("group.groupID  ${group.groupID}");
              }
            },
            itemCount: orderController.groupList.length,
            itemBuilder: (BuildContext context, int index) =>
                ReorderableDragStartListener(
                  index: index,
                  key: Key('$index'),
                  child: Card(
                      color: Colors.transparent,
                      margin: EdgeInsets.zero,
                      elevation: 0,
                      semanticContainer: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          orderController.selectIndex(index);
                          orderController.selectedGroup.value =
                              index;
                          orderController.productIsLoading.value =
                          true;
                          print(
                              "Selected Group ID: ${orderController.groupList[index].groupID}");
                          orderController.getProductListDetail(
                              orderController
                                  .groupList[index].groupID);

                          print(
                              "orderController.groupList[index].groupID");
                          print(orderController
                              .groupList[index].groupID);
                          print(
                              "...............................");
                        },
                        key: ValueKey(orderController
                            .groupList[index].groupID),
                        // Unique key for reordering
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: orderController
                                      .selectedIndex
                                      .value ==
                                      index
                                      ? const Color(0xffff4400)
                                      : Colors.transparent,
                                  width: 5,
                                ),
                              ),
                              gradient: LinearGradient(
                                colors: orderController
                                    .selectedIndex
                                    .value ==
                                    index
                                    ? [
                                  Colors.white
                                      .withOpacity(.4),
                                  const Color(0xffff4400)
                                      .withOpacity(.001)
                                ]
                                    : [
                                  Colors.transparent,
                                  Colors.transparent
                                ],
                                stops: const [0.4, 1.9],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ListTile(
                              trailing: const SizedBox.shrink(),
                              title: Obx(() {
                                return Text(
                                  orderController
                                      .groupList[index].groupName,
                                  style: customisedStyle(
                                    context,
                                    orderController.selectedIndex
                                        .value ==
                                        index
                                        ? const Color(0xffF25F29)
                                        : const Color(0xff585858),
                                    FontWeight.w400,
                                    13.0,
                                  ),
                                );
                              }),
                            ),
                          );
                        }),
                      )),
                ),
          );
        }
      }),
    );
  }
  Widget productListReorderableWidget(){
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              right: BorderSide(color: Color(0xffE9E9E9)))),
      width: MediaQuery.of(context).size.width / 1.3,
      child: Column(
        children: [

          //   diningController.selectedIndexNotifier.value =
          /// product list
          Obx(() => orderController.productIsLoading.value
              ? const SizedBox(
              height: 500,
              child: Center(
                  child: CircularProgressIndicator()))
              : Expanded(
            child: Obx(() => ReorderableGridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
              4,
                mainAxisSpacing: 6.0,
                mainAxisExtent:
                130,
                childAspectRatio: 3.2,
                crossAxisSpacing: 6,
              ),
              itemCount:
              orderController.productList.length,
              itemBuilder: (context, index) {
                var alreadyExist = orderController
                    .checking(orderController
                    .productList[index]
                    .productID);
                return Container(
                    key: ValueKey(orderController
                        .productList[index]
                        .productID),
                    color: Colors.red.shade50,
                    child: GestureDetector(
                      onTap: () {},
                      // onTap: () async {
                      //
                      //   SharedPreferences prefs =
                      //   await SharedPreferences
                      //       .getInstance();
                      //
                      //   var qtyIncrement =
                      //       prefs.getBool(
                      //           "qtyIncrement") ??
                      //           true;
                      //
                      //   orderController
                      //       .unitPriceAmount
                      //       .value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultSalesPrice;
                      //   orderController
                      //       .inclusiveUnitPriceAmountWR
                      //       .value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultSalesPrice;
                      //   orderController.vatPer.value =
                      //       double.parse(
                      //           orderController
                      //               .productList[
                      //           index]
                      //               .vatsSalesTax);
                      //   orderController.gstPer.value =
                      //       double.parse(
                      //           orderController
                      //               .productList[
                      //           index]
                      //               .gSTSalesTax);
                      //
                      //   orderController
                      //       .priceListID.value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultUnitID;
                      //   orderController
                      //       .productName.value =
                      //       orderController
                      //           .productList[index]
                      //           .productName;
                      //   orderController.item_status
                      //       .value = "pending";
                      //   orderController
                      //       .unitName.value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultUnitName;
                      //
                      //   var taxDetails =
                      //       orderController
                      //           .productList[index]
                      //           .taxDetails;
                      //
                      //   if (taxDetails != "") {
                      //     orderController.productTaxID
                      //         .value =
                      //     taxDetails["TaxID"];
                      //     orderController
                      //         .productTaxName
                      //         .value =
                      //     taxDetails["TaxName"];
                      //   }
                      //
                      //   orderController
                      //       .detailID.value = 1;
                      //   orderController
                      //       .salesPrice.value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultSalesPrice;
                      //   orderController
                      //       .purchasePrice.value =
                      //       orderController
                      //           .productList[index]
                      //           .defaultPurchasePrice;
                      //   orderController
                      //       .productID.value =
                      //       orderController
                      //           .productList[index]
                      //           .productID;
                      //   orderController
                      //       .isInclusive.value =
                      //       orderController
                      //           .productList[index]
                      //           .isInclusive;
                      //
                      //   orderController
                      //       .detailIdEdit.value = 0;
                      //   orderController
                      //       .flavourID.value = "";
                      //   orderController
                      //       .flavourName.value = "";
                      //
                      //   var newTax = orderController
                      //       .productList[index]
                      //       .exciseData;
                      //
                      //   if (newTax != "") {
                      //     orderController
                      //         .isExciseProduct
                      //         .value = true;
                      //     orderController
                      //         .exciseTaxID.value =
                      //     newTax["TaxID"];
                      //     orderController
                      //         .exciseTaxName
                      //         .value =
                      //     newTax["TaxName"];
                      //     orderController
                      //         .BPValue.value =
                      //         newTax["BPValue"]
                      //             .toString();
                      //     orderController
                      //         .exciseTaxBefore
                      //         .value =
                      //         newTax["TaxBefore"]
                      //             .toString();
                      //     orderController
                      //         .isAmountTaxBefore
                      //         .value =
                      //     newTax[
                      //     "IsAmountTaxBefore"];
                      //     orderController
                      //         .isAmountTaxAfter
                      //         .value =
                      //     newTax[
                      //     "IsAmountTaxAfter"];
                      //     orderController
                      //         .exciseTaxAfter
                      //         .value =
                      //         newTax["TaxAfter"]
                      //             .toString();
                      //   } else {
                      //     orderController
                      //         .exciseTaxID.value = 0;
                      //     orderController
                      //         .exciseTaxName
                      //         .value = "";
                      //     orderController
                      //         .BPValue.value = "0";
                      //     orderController
                      //         .exciseTaxBefore
                      //         .value = "0";
                      //     orderController
                      //         .isAmountTaxBefore
                      //         .value = false;
                      //     orderController
                      //         .isAmountTaxAfter
                      //         .value = false;
                      //     orderController
                      //         .isExciseProduct
                      //         .value = false;
                      //     orderController
                      //         .exciseTaxAfter
                      //         .value = "0";
                      //   }
                      //
                      //   orderController
                      //       .unique_id.value = "0";
                      //   orderController.calculation();
                      //
                      //   /// commented for new tax working
                      //
                      //   /// qty increment
                      // },
                      child: InkWell(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(
                              left: 5.0,
                              right: 5,
                              top: 8,
                              bottom: 8),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                            children: [
                              ///productname,des,rate,veg
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Obx(() {
                                    return orderController
                                        .showWegOrNoVeg
                                        .value
                                        ? Container(
                                      child: SvgPicture
                                          .asset(
                                        "assets/svg/veg_mob.svg",
                                        color: orderController.productList[index].vegOrNonVeg ==
                                            "Non-veg"
                                            ? const Color(0xffDF1515)
                                            : const Color(0xff00775E),
                                      ),
                                    )
                                        : Container();
                                  }),
                                  Obx(() {
                                    // Use Obx to rebuild the text widget when selectedFontWeight changes
                                    return Container(
                                      constraints: const BoxConstraints(
                                          maxWidth: 160),
                                      child: Text(
                                        orderController
                                            .productList[
                                        index]
                                            .productName,
                                        style: customisedStyle(
                                            context,
                                            Colors
                                                .black,
                                            FontWeight.w400,
                                            13.0),
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        softWrap:
                                        true,
                                        maxLines: 4,
                                      ),
                                    );
                                  }),
                                  Obx(() {
                                    return  Container(
                                      constraints: const BoxConstraints(
                                          maxWidth:  170),
                                      child:
                                      Text(
                                        orderController
                                            .productList[index]
                                            .description,
                                        style: customisedStyle(
                                            context,
                                            Colors.black,
                                            FontWeight.normal,
                                            12.0),
                                        overflow:
                                        TextOverflow.ellipsis,
                                        softWrap:
                                        true,
                                        maxLines:
                                        4,
                                      ),
                                    );

                                  }),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    children: [
                                      Text(
                                        orderController
                                            .currency
                                            .value,
                                        style: customisedStyle(
                                            context,
                                            const Color(
                                                0xffA5A5A5),
                                            FontWeight
                                                .w400,
                                            13.0),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            left:
                                            5.0),
                                        child:
                                        Obx(() {
                                          return Text(
                                            roundStringWith(orderController
                                                .productList[
                                            index]
                                                .defaultSalesPrice),
                                            style: customisedStyle(
                                                context,
                                                Colors
                                                    .black, FontWeight.w500,
                                               13.0),
                                          );
                                        }),
                                      ),
                                      //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                    ],
                                  ),
                                ],
                              ),

                              ///image
                              Obx(() =>
                               Container(
                                height: MediaQuery.of(context)
                                    .size
                                    .height *

                                   .13,
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    .06,
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                  // Set border radius to make the Container round
                                ),
                                child:
                                Stack(
                                  children: <Widget>[
                                    Positioned
                                        .fill(
                                      child:
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        // Clip image to match the rounded corners of the Container
                                        child:
                                        Image.network(
                                          orderController.productList[index].productImage != "" ? orderController.productList[index].productImage : 'https://www.api.viknbooks.com/media/uploads/Group_5140.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  ),
                              // else
                            ],
                          ),
                        ),
                      ),
                    ));
              },
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = orderController
                    .productList
                    .removeAt(oldIndex);
                orderController.productList
                    .insert(newIndex, item);
                printReorderedIDs(
                    orderController.productList);
              },
            )),
          ))
        ],
      ),
    );
  }








  void printReorderedIDs(List productList) {
    print("Current order of product IDs:");
    for (var product in productList) {
      print(product.productID); // Print each product ID
    }
  }

}
