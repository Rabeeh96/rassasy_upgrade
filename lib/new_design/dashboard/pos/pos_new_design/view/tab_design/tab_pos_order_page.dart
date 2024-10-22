import 'dart:ffi';

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

import '../../controller/platform_controller.dart';
import '../detail_page/customer_detail.dart';
import 'drag_drop.dart';

class TabPosOrderPage extends StatefulWidget {
  final String uID, splitID, tableID, sectionType, tableHead;
  final int orderType;
  final List cancelOrder;
  final bool isAllCombine;

  const TabPosOrderPage({
    super.key,
    required this.tableID,
    required this.splitID,
    required this.tableHead,
    required this.uID,
    required this.sectionType,
    required this.isAllCombine,
    required this.cancelOrder,
    required this.orderType,
  });

  @override
  State<TabPosOrderPage> createState() => _TabPosOrderPageState();
}

///A dismissed Dismissible widget is still part of the tree.
///add same item multiple times and delete first item
class _TabPosOrderPageState extends State<TabPosOrderPage> {
  OrderController orderController = Get.put(OrderController());
  POSController posController = Get.put(POSController());
  POSPaymentController paymentController = Get.put(POSPaymentController());
  final POSController diningController = Get.put(POSController());
  final PlatformController platformController = Get.put(PlatformController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.productList.clear();

    orderController.groupList.clear();
    orderController.orderItemList.clear();
    orderController.posFunctions(sectionType: widget.sectionType, uUID: widget.uID);
    orderController.getDefaultValue();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Scaffold(
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
            actions: [
              // IconButton(
              //     onPressed: () {
              //       addDetails();
              //     },
              //     icon: SvgPicture.asset('assets/svg/Info_mob.svg')),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Text(
              //       diningController.userName.value,
              //       style: customisedStyle(context, const Color(0xff585858),
              //           FontWeight.w500, 14.0),
              //     ),
              //     Obx(
              //       () => orderController.synMethod.value
              //           ? Container()
              //           : Text(
              //               orderController.tokenNumber.value,
              //               style: customisedStyle(
              //                   context, const Color(0xff585858), FontWeight.w500, 14.0),
              //             ),
              //     ),
              //     const SizedBox(
              //       height: 3,
              //     )
              //   ],
              // ),

              widget.sectionType == "Edit"
                  ? Text(
                      "Token Number " + "${orderController.tokenNumber.value}",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                    )
                  : Container(),

              // Obx(() {
              //   return orderController.synMethod.value
              //       ? IconButton(
              //           onPressed: () async {
              //             start(context);
              //             await orderController.fetchAndSaveProductGroupData();
              //             var savedData = await orderController
              //                 .loadSavedData("productGroupData");
              //             var allProducts = [];
              //             for (var i = 0; i < savedData.length; i++) {
              //               var groupId = savedData[i]['ProductGroupID'];
              //               var groupProducts = await orderController
              //                   .fetchAndSaveProductData(groupId);
              //               if (groupProducts is List) {
              //                 allProducts.addAll(groupProducts);
              //               }
              //             }
              //             await orderController.saveAllProduct(allProducts);
              //             await stop();
              //             orderController.posFunctions(sectionType: widget.sectionType, uUID: widget.uID);
              //           },
              //           icon:   Text('Sync Data ',style: customisedStyle(
              //               context, Color(0xff585858), FontWeight.w500, 14.0),))
              //       : Container();
              // }),

              /// commented all section one by one
              // ElevatedButton(onPressed: ()async{
              //   try{
              //     start(context);
              //     var savedData = await orderController.loadSavedData("productGroupData");
              //     pr("savedData   $savedData group lenght ${savedData.length}  ");
              //
              //     var  allProducts = [];
              //     for (var i = 0; i < savedData.length; i++) {
              //       var groupId = savedData[i]['ProductGroupID'];
              //       var data=await orderController.fetchAndSaveProductData(groupId);
              //       pr("group ID $groupId   $data");
              //
              //       var groupProducts = await orderController.fetchAndSaveProductData(groupId);
              //
              //       // Check if groupProducts is a list and add its elements to the allProducts list
              //       if (groupProducts is List) {
              //         allProducts.addAll(groupProducts);
              //       }
              //
              //     }
              //
              //     await orderController.saveAllProduct(allProducts);
              //     await stop();
              //
              //   }
              //   catch(e){
              //     pr("error ${e.toString()}");
              //       stop();
              //   }
              //
              //
              //
              // //  fetchAndSaveProductData
              //
              // }, child: Text("Download Product ")),
              //
              // ElevatedButton(onPressed: (){
              //   orderController.fetchAndSaveProductGroupData();
              // }, child: Text("Download group ")),
              //
              // ElevatedButton(onPressed: ()async{
              //   var savedData = await orderController.loadSavedData("productData");
              //   var productList = savedData["data"];
              //   pr("product   ${productList} product lenght ${productList.length}  ");
              //
              // }, child: Text("Shwo  product ")),
              //
              // ElevatedButton(onPressed: ()async{
              //   var filteredProducts = orderController.filterProductsByGroupId(2);
              //   pr("filteredProducts   ${filteredProducts} filteredProducts filteredProducts ${filteredProducts.length}  ");
              //
              // }, child: Text("Filter ")),

              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Add the functionality you want here, e.g., navigate to the settings page
                  orderController.detailPage.value = 'settings';
                  orderController.update();
                },
              ),

        Obx(() {  return orderController.synMethod.value?

    IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: ()async {
                  start(context);
                  await orderController.fetchAndSaveProductGroupData();
                  var savedData = await orderController
                      .loadSavedData("productGroupData");
                  var allProducts = [];
                  for (var i = 0; i < savedData.length; i++) {
                    var groupId = savedData[i]['ProductGroupID'];
                    var groupProducts = await orderController
                        .fetchAndSaveProductData(groupId);
                    if (groupProducts is List) {
                      allProducts.addAll(groupProducts);
                    }
                  }
                  await orderController.saveAllProduct(allProducts);
                  await stop();
                  orderController.posFunctions(sectionType: widget.sectionType, uUID: widget.uID);
                },
              ):Container(); }),




              // IconButton(
              //     onPressed: () async {
              //       Get.to(() => DragDrop(
              //           uID: widget.uID, sectionType: widget.sectionType));
              //     },
              //     icon: const Text('Draggable')),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xffE9E9E9), width: 2))),
            child: Row(
              children: [
                ///group list section
                Flexible(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xffE9E9E9)))),
                      width: MediaQuery.of(context).size.width / 6,
                      child: Obx(() {
                        if (orderController.groupIsLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (orderController.groupList.isEmpty) {
                          return const Center(child: Text("Group Not Found!"));
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: orderController.groupList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  orderController.selectIndex(index);
                                  orderController.selectedGroup.value = index;
                                  orderController.productIsLoading.value = true;

                                  pr("========productIsLoading=======${orderController.productIsLoading.value}");
                                  if (orderController.synMethod.value) {
                                    orderController.getProductListDetailLocal(orderController.groupList[index].groupID);
                                  } else {
                                    orderController.getProductListDetail(orderController.groupList[index].groupID);
                                  }

                                  //
                                },
                                child: Obx(() {
                                  return Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                                color: orderController.selectedIndex.value == index ? const Color(0xffff4400) : Colors.transparent,
                                                width: 5)),
                                        gradient: LinearGradient(
                                          colors: orderController.selectedIndex.value == index
                                              ? [Colors.white.withOpacity(.4), const Color(0xffff4400).withOpacity(.001)]
                                              : [Colors.transparent, Colors.transparent],
                                          // Colors to be used in gradient
                                          stops: const [0.4, 1.9],
                                          // Position of each color
                                          begin: Alignment.topLeft,
                                          // Start of the gradient
                                          end: Alignment.bottomRight, // End of the gradient
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Obx(() {
                                          return Text(
                                            orderController.groupList[index].groupName,
                                            style: customisedStyle(
                                                context,
                                                orderController.selectedIndex.value == index ? const Color(0xffF25F29) : const Color(0xff585858),
                                                orderController.groupFontWeight.value,
                                                orderController.groupFontSize),
                                          );
                                        }),
                                      ));
                                }),
                              );
                            },
                          );
                        }
                      }),
                    )),

                ///product list section
                Flexible(
                  flex: 10,
                  child: Container(
                    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xffE9E9E9)))),
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 10, top: 7),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 15,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(right: 8.0),
                                    //   child: Text(
                                    //     'choose_item'.tr,
                                    //     style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                    //   ),
                                    // ),
                                    ValueListenableBuilder<bool>(
                                      valueListenable: orderController.isVegNotifier,
                                      builder: (context, isVegValue, child) {
                                        return GestureDetector(
                                          onTap: () async {
                                            orderController.isVegNotifier.value = !isVegValue;
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: const Color(0xffDBDBDB)),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
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
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          addDetails();
                                        },
                                        icon: SvgPicture.asset('assets/svg/Info_mob.svg')),

                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 22,
                                      decoration: BoxDecoration(color: const Color(0xffFFF6F2), borderRadius: BorderRadius.circular(29)),
                                      child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                          child: Obx(() => DropdownButton(
                                                borderRadius: BorderRadius.circular(29),
                                                // Initial Value
                                                value: orderController.dropdownvalue.value,
                                                underline: Container(color: Colors.transparent),
                                                // Down Arrow Icon
                                                icon: SvgPicture.asset("assets/svg/drop_arrow.svg"),
                                                // Array list of items
                                                items: orderController.items.map((String item) {
                                                  return DropdownMenuItem(
                                                    value: item,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 0.0, left: 5),
                                                      child:
                                                          Text(item, style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 12.0)),
                                                    ),
                                                  );
                                                }).toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: (String? newValue) {
                                                  orderController.dropdownvalue.value = newValue!;
                                                },
                                              ))),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 6,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                        onChanged: (quary) async {
                                          if (orderController.synMethod.value) {
                                            orderController.getProductListDetailSearchLocal(quary);
                                          } else {
                                            orderController.searchItemsTab(
                                                productName: quary,
                                                isCode: orderController.dropdownvalue.value == "Code" ? true : false,
                                                isDescription: orderController.dropdownvalue.value == "Description" ? true : false);
                                          }

                                          /// local
                                        },
                                        controller: orderController.searchController,
                                        decoration: InputDecoration(
                                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE7E7E7))),
                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE7E7E7))),
                                          disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffE7E7E7))),
                                          contentPadding: const EdgeInsets.all(10),
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Image.asset('assets/png/search_grey_png.png'),
                                          ),
                                          hintText: 'search'.tr,
                                          hintStyle: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.normal, 12.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),




                              ],
                            ),
                          ),
                        ),
                        //   diningController.selectedIndexNotifier.value =
                        /// product list
                        Obx(() => orderController.productIsLoading.value
                            ? const SizedBox(height: 500, child: Center(child: CircularProgressIndicator()))
                            : Expanded(
                                child: Obx(() => GridView.builder(
                                      padding: const EdgeInsets.all(10.0),
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: orderController.rowCountGridView,
                                        mainAxisSpacing: 2.0,
                                        mainAxisExtent: orderController.heightOfITem * 10,
                                        // childAspectRatio: widthGrid/heightGrid,
                                        childAspectRatio: 3.2,
                                        crossAxisSpacing: 2,
                                      ),
                                      //separatorBuilder: (context, index) => dividerStyle(),
                                      itemCount: orderController.productList.length,
                                      itemBuilder: (context, index) {

                                        return Card(
                                          color: Colors.red.shade50,
                                          child: GestureDetector(
                                            onTap: () async {
                                              orderController.detailPage.value = 'item_add';
                                              SharedPreferences prefs = await SharedPreferences.getInstance();



                                              var alreadyExist = orderController.checking(orderController.productList[index].productID);

                                              var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                              pr("=====qtyIncrement $qtyIncrement alreadyExist $alreadyExist");

                                              if(qtyIncrement&&alreadyExist[0]){
                                                print("-----------------------already $alreadyExist");

                                                orderController.updateQty(index: alreadyExist[1], type: 1);
                                                print("-----------------------already $alreadyExist");
                                              }
                                              else{
                                                orderController.unitPriceAmount.value = orderController.productList[index].defaultSalesPrice;
                                                orderController.inclusiveUnitPriceAmountWR.value = orderController.productList[index].defaultSalesPrice;
                                                orderController.vatPer.value = double.parse(orderController.productList[index].vatsSalesTax);
                                                orderController.gstPer.value = double.parse(orderController.productList[index].gSTSalesTax);
                                                orderController.priceListID.value = orderController.productList[index].defaultUnitID;
                                                orderController.productName.value = orderController.productList[index].productName;
                                                orderController.productDescription.value = orderController.productList[index].description;
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
                                              }





                                              //setState(() {});
                                              /// commented for new tax working

                                              /// qty increment
                                            },
                                            child: InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5.0, right: 5, top: 8, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    ///productname,des,rate,veg
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Obx(() {
                                                          return orderController.showWegOrNoVeg.value
                                                              ? Container(
                                                                  child: SvgPicture.asset(
                                                                    "assets/svg/veg_mob.svg",
                                                                    color: orderController.productList[index].vegOrNonVeg == "Non-veg"
                                                                        ? const Color(0xffDF1515)
                                                                        : const Color(0xff00775E),
                                                                  ),
                                                                )
                                                              : Container();
                                                        }),
                                                        Obx(() {
                                                          // Use Obx to rebuild the text widget when selectedFontWeight changes
                                                          return Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: orderController.returnProductLength(
                                                                    orderController.rowCountGridView, orderController.isShowImage.value)),
                                                            // constraints: BoxConstraints(maxWidth:orderController.returnProductLength(orderController.rowCountGridView,orderController.isShowImage.value)),
                                                            child: Text(
                                                              orderController.productList[index].productName,
                                                              style: customisedStyle(context, Colors.black, orderController.productFontWeight.value,
                                                                  orderController.productFontSize),
                                                              overflow: TextOverflow.ellipsis,
                                                              softWrap: true,
                                                              maxLines: 4,
                                                            ),
                                                          );
                                                        }),
                                                        Obx(() {
                                                          return orderController.showProductDescription.value
                                                              ? Container(
                                                                  constraints: BoxConstraints(
                                                                      maxWidth: orderController.returnProductLength(
                                                                          orderController.rowCountGridView, orderController.isShowImage.value)),
                                                                  child: Text(
                                                                    orderController.productList[index].description,
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Colors.black,
                                                                        orderController.descriptionFontWeight.value,
                                                                        orderController.descriptionFontSize),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    softWrap: true,
                                                                    maxLines: 4,
                                                                  ),
                                                                )
                                                              : Container();
                                                        }),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              orderController.currency.value,
                                                              style: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.w400, 13.0),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 5.0),
                                                              child: Obx(() {
                                                                return Text(
                                                                  roundStringWith(orderController.productList[index].defaultSalesPrice),
                                                                  style: customisedStyle(context, Colors.black,
                                                                      orderController.amountFontWeight.value, orderController.amountFontSize),
                                                                );
                                                              }),
                                                            ),
                                                            //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    ///image
                                                    Obx(() => orderController.isShowImage.value
                                                        ? Container(
                                                            height: MediaQuery.of(context).size.height * orderController.heightOfImage / 100,
                                                            width: MediaQuery.of(context).size.width * (orderController.widthOfImage / 100),
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
                                                              ],
                                                            ),
                                                          )
                                                        : Container()),
                                                    // else
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ))))
                      ],
                    ),
                  ),
                ),
                //here we need condition
                /// item details
                Flexible(
                    flex: 6,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: Obx(() {
                          switch (orderController.detailPage.value) {
                            case 'item_add':
                              return itemAddWidget();
                            case 'detail_page':
                              return productDetailPage();
                            case 'settings':
                              return settingsUI();
                            default:
                              return itemAddWidget();
                          }
                        }))),
              ],
            ),
          ),
        ));
  }

  loadData() async {
    pr(orderController.orderItemList[orderController.indexDetail]);

    orderController.flavourList.clear();
    await orderController.getAllFlavours();
    orderController.productName.value = orderController.orderItemList[orderController.indexDetail]["ProductName"];
    orderController.productDescription.value = orderController.orderItemList[orderController.indexDetail]["Description"];
    orderController.item_status.value = orderController.orderItemList[orderController.indexDetail]["Status"];
    orderController.unitName.value = orderController.orderItemList[orderController.indexDetail]["UnitName"];
    orderController.quantity.value = double.parse(orderController.orderItemList[orderController.indexDetail]["Qty"].toString());
    orderController.productTaxName.value = orderController.orderItemList[orderController.indexDetail]["ProductTaxName"];
    orderController.productTaxID.value = orderController.orderItemList[orderController.indexDetail]["ProductTaxID"];
    orderController.salesPrice.value = orderController.orderItemList[orderController.indexDetail]["SalesPrice"].toString();
    orderController.productID.value = orderController.orderItemList[orderController.indexDetail]["ProductID"];
    orderController.actualProductTaxName.value = orderController.orderItemList[orderController.indexDetail]["ActualProductTaxName"];
    orderController.actualProductTaxID.value = orderController.orderItemList[orderController.indexDetail]["ActualProductTaxID"];
    orderController.branchID.value = orderController.orderItemList[orderController.indexDetail]["BranchID"];
    orderController.unique_id.value = orderController.orderItemList[orderController.indexDetail]["unq_id"];
    orderController.unitPriceAmount.value = orderController.orderItemList[orderController.indexDetail]["UnitPrice"].toString();
    orderController.rateWithTax.value = double.parse(orderController.orderItemList[orderController.indexDetail]["RateWithTax"].toString());
    orderController.costPerPrice.value = orderController.orderItemList[orderController.indexDetail]["CostPerPrice"].toString();
    orderController.priceListID.value = orderController.orderItemList[orderController.indexDetail]["PriceListID"];
    orderController.discountPer.value = orderController.orderItemList[orderController.indexDetail]["DiscountPerc"].toString();
    orderController.discountAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["DiscountAmount"].toString());
    orderController.grossAmountWR.value = orderController.orderItemList[orderController.indexDetail]["GrossAmount"].toString();
    orderController.vatPer.value = double.parse(orderController.orderItemList[orderController.indexDetail]["VATPerc"].toString());
    orderController.vatAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["VATAmount"].toString());
    orderController.netAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["NetAmount"].toString());
    orderController.detailID.value = orderController.orderItemList[orderController.indexDetail]["detailID"];
    orderController.sGSTPer.value = double.parse(orderController.orderItemList[orderController.indexDetail]["SGSTPerc"].toString());
    orderController.sGSTAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["SGSTAmount"].toString());
    orderController.cGSTPer.value = double.parse(orderController.orderItemList[orderController.indexDetail]["CGSTPerc"].toString());
    orderController.cGSTAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["CGSTAmount"].toString());
    orderController.iGSTPer.value = double.parse(orderController.orderItemList[orderController.indexDetail]["IGSTPerc"].toString());
    orderController.iGSTAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["IGSTAmount"].toString());
    orderController.createdUserID.value = orderController.orderItemList[orderController.indexDetail]["CreatedUserID"];
    orderController.dataBase.value = orderController.orderItemList[orderController.indexDetail]["DataBase"] ?? "";

    orderController.flavourID.value = orderController.orderItemList[orderController.indexDetail]["Flavour"] ?? "";
    if (orderController.flavourID.value == "") {
      orderController.flavourID.value = orderController.orderItemList[orderController.indexDetail]["flavour"] ?? "";
    }
    orderController.flavourName.value = orderController.orderItemList[orderController.indexDetail]["Flavour_Name"] ?? "";
    orderController.taxableAmountPost.value = double.parse(orderController.orderItemList[orderController.indexDetail]["TaxableAmount"].toString());
    var gst = orderController.orderItemList[orderController.indexDetail]["gstPer"] ?? '0';
    orderController.gstPer.value = double.parse(gst.toString());
    orderController.isInclusive.value = orderController.orderItemList[orderController.indexDetail]["is_inclusive"];
    orderController.inclusiveUnitPriceAmountWR.value = orderController.orderItemList[orderController.indexDetail]["InclusivePrice"].toString();
    orderController.totalTax.value = double.parse(orderController.orderItemList[orderController.indexDetail]["TotalTaxRounded"].toString());

    print("orderController.flavourID.value ${orderController.flavourID.value} ");
    print("    orderController.flavourName.value ${orderController.flavourName.value} ");

    /// excise tax not working
    // orderController.exciseTaxID.value = orderController.orderItemList[widget.index]["ExciseTaxID"];
    // orderController.exciseTaxName.value = orderController.orderItemList[widget.index]["ExciseTaxName"];
    // orderController.BPValue.value = orderController.orderItemList[widget.index]["BPValue"];
    // orderController.exciseTaxBefore.value = orderController.orderItemList[widget.index]["ExciseTaxBefore"];
    // orderController.isAmountTaxAfter.value = orderController.orderItemList[widget.index]["IsAmountTaxAfter"];
    // orderController.isAmountTaxBefore.value = orderController.orderItemList[widget.index]["IsAmountTaxBefore"];
    // orderController.isExciseProduct.value = orderController.orderItemList[widget.index]["IsExciseProduct"];
    // orderController.exciseTaxAfter.value = orderController.orderItemList[widget.index]["ExciseTaxAfter"];
    orderController.exciseTaxAmount.value = double.parse(orderController.orderItemList[orderController.indexDetail]["ExciseTax"].toString());
    orderController.unitPriceChangingController.text = roundStringWith(orderController.unitPriceAmount.value);
    orderController.quantityForDetailsSection.value = double.parse(orderController.quantity.value.toString());
//    orderController.calculationOnEditing(index: widget.index, isQuantityButton: false, value: orderController.unitPriceAmountWR.value.toString());
  }

  Widget settingsUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 12),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .75,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Font Customization",
                          style: customisedStyle(context, Colors.black, FontWeight.w600, 16.0),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Group Name",
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 23,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        height: MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.groupFontSize <= 0) {
                                              } else {
                                                orderController.groupFontSize = orderController.groupFontSize - 1;
                                                orderController.groupNameFontSizeController.text = "${orderController.groupFontSize}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          readOnly: true,
                                          controller: orderController.groupNameFontSizeController,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.0),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.groupFontSize = double.parse(text);
                                              orderController.groupNameFontSizeController.text = "${orderController.groupFontSize}";
                                              prefs.setDouble('group_font_size', orderController.groupFontSize);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.groupFontSize = orderController.groupFontSize + 1;
                                                orderController.groupNameFontSizeController.text = "${orderController.groupFontSize}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: const Color(0xffD7D7D7)),
                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 5),
                                    child: Obx(() {
                                      return DropdownButton<FontWeight>(
                                        focusColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        underline: const SizedBox(),
                                        value: orderController.groupFontWeight.value,
                                        items: orderController.fontWeights.map((Map<String, FontWeight> fontWeight) {
                                          String key = fontWeight.keys.first;
                                          return DropdownMenuItem<FontWeight>(
                                            value: fontWeight[key],
                                            child: Text(
                                              key,
                                              style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (FontWeight? newWeight) async {
                                          if (newWeight != null) {
                                            await orderController.updateFontWeight(newWeight, 'group_weight');
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                )

                                // Container(
                                //   decoration: BoxDecoration(
                                //       border: Border.all(color: const Color(0xffD7D7D7)), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                //   child: Padding(
                                //     padding: const EdgeInsets.only(left: 8.0, right: 5),
                                //     child: Obx(() {
                                //       // Use Obx to rebuild when selectedFontWeight changes
                                //       return DropdownButton<FontWeight>(
                                //         focusColor: Colors.transparent,
                                //         borderRadius: BorderRadius.circular(8),
                                //         underline: const SizedBox(),
                                //         value: orderController.groupFontWeight.value,
                                //         items: orderController.fontWeights.map((Map<String, FontWeight> fontWeight) {
                                //           String key = fontWeight.keys.first;
                                //           return DropdownMenuItem<FontWeight>(
                                //             value: fontWeight[key],
                                //             child: Text(
                                //               key,
                                //               style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                //             ),
                                //           );
                                //         }).toList(),
                                //         onChanged: (FontWeight? newWeight) async {
                                //           SharedPreferences prefs = await SharedPreferences.getInstance();
                                //
                                //           if (newWeight != null) {
                                //             orderController.updateFontWeight(newWeight, 'group_weight');
                                //
                                //           }
                                //         },
                                //       );
                                //     }),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Name",
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 23,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        // height:
                                        //     MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.productFontSize <= 0) {
                                              } else {
                                                orderController.productFontSize = orderController.productFontSize - 1;
                                                orderController.productNameFontSizeController.text = "${orderController.productFontSize}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                        alignment: Alignment.center,
                                        // height: MediaQuery.of(context).size.height /
                                        //     18, //height of button
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          controller: orderController.productNameFontSizeController,
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.5),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.productFontSize = double.parse(text);
                                              orderController.productNameFontSizeController.text = "${orderController.productFontSize}";
                                              prefs.setDouble('product_font_size', orderController.productFontSize);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.productFontSize = orderController.productFontSize + 1;
                                                orderController.productNameFontSizeController.text = "${orderController.productFontSize}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7)), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 5),
                                    child: Obx(() {
                                      // Use Obx to rebuild when selectedFontWeight changes
                                      return DropdownButton<FontWeight>(
                                        focusColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        underline: const SizedBox(),
                                        value: orderController.productFontWeight.value,
                                        items: orderController.fontWeights.map((Map<String, FontWeight> fontWeight) {
                                          String key = fontWeight.keys.first;
                                          return DropdownMenuItem<FontWeight>(
                                            value: fontWeight[key],
                                            child: Text(
                                              key,
                                              style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (FontWeight? newWeight) {
                                          if (newWeight != null) {
                                            orderController.updateFontWeight(newWeight, 'product_weight');
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Description",
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 23,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        height: MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.descriptionFontSize <= 0) {
                                              } else {
                                                orderController.descriptionFontSize = orderController.descriptionFontSize - 1;
                                                orderController.descriptionFontSizeController.text = "${orderController.descriptionFontSize}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          controller: orderController.descriptionFontSizeController,
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.0),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.descriptionFontSize = double.parse(text);
                                              orderController.descriptionFontSizeController.text = "${orderController.descriptionFontSize}";
                                              prefs.setDouble('description_fontSize', orderController.descriptionFontSize);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.descriptionFontSize = orderController.descriptionFontSize + 1;
                                                orderController.descriptionFontSizeController.text = "${orderController.descriptionFontSize}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7)), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 5),
                                    child: Obx(() {
                                      // Use Obx to rebuild when selectedFontWeight changes
                                      return DropdownButton<FontWeight>(
                                        focusColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        underline: const SizedBox(),
                                        value: orderController.descriptionFontWeight.value,
                                        items: orderController.fontWeights.map((Map<String, FontWeight> fontWeight) {
                                          String key = fontWeight.keys.first;
                                          return DropdownMenuItem<FontWeight>(
                                            value: fontWeight[key],
                                            child: Text(
                                              key,
                                              style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (FontWeight? newWeight) {
                                          if (newWeight != null) {
                                            orderController.updateFontWeight(newWeight, 'description_weight');
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amount ", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 23,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        height: MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.amountFontSize <= 0) {
                                              } else {
                                                orderController.amountFontSize = orderController.amountFontSize - 1;
                                                orderController.amountFontSizeController.text = "${orderController.amountFontSize}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))), //height of button
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          controller: orderController.amountFontSizeController,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          readOnly: true,
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.0),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.amountFontSize = double.parse(text);
                                              orderController.descriptionFontSizeController.text = "${orderController.amountFontSize}";
                                              prefs.setDouble('amount_font_size', orderController.amountFontSize);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.amountFontSize = orderController.amountFontSize + 1;
                                                orderController.amountFontSizeController.text = "${orderController.amountFontSize}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7)), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 5),
                                    child: Obx(() {
                                      // Use Obx to rebuild when selectedFontWeight changes
                                      return DropdownButton<FontWeight>(
                                        focusColor: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        underline: const SizedBox(),
                                        value: orderController.amountFontWeight.value,
                                        items: orderController.fontWeights.map((Map<String, FontWeight> fontWeight) {
                                          String key = fontWeight.keys.first;
                                          return DropdownMenuItem<FontWeight>(
                                            value: fontWeight[key],
                                            child: Text(
                                              key,
                                              style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (FontWeight? newWeight) {
                                          if (newWeight != null) {
                                            orderController.updateFontWeight(newWeight, 'amount_weight');
                                          }
                                        },
                                      );
                                    }),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Style",
                          style: customisedStyle(context, Colors.black, FontWeight.w600, 16.0),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 17,
                    decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Text(
                                'Show Description',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                          return FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            valueFontSize: 30.0,
                            toggleSize: 15.0,
                            value: orderController.showProductDescription.value,
                            borderRadius: 20.0,
                            padding: 1.0,
                            activeColor: const Color(0xff3183FF),
                            activeTextColor: Colors.green,
                            //   inactiveTextColor: Repository.textColor(context),
                            inactiveColor: Colors.grey,
                            // showOnOff: true,
                            onToggle: (val) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              orderController.showProductDescription.value = !orderController.showProductDescription.value;
                              prefs.setBool('showProductDescription', orderController.showProductDescription.value);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 17,
                    decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Show Product type',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Tooltip(
                                  message: 'Show/Hide Product Veg Or Not',
                                  textStyle: const TextStyle(color: Colors.white),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Icon(
                                    Icons.info,
                                    color: Color(0xffF25F29),
                                    size: 25.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Obx(() {
                          return FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            valueFontSize: 30.0,
                            toggleSize: 15.0,
                            value: orderController.showWegOrNoVeg.value,
                            borderRadius: 20.0,
                            padding: 1.0,
                            activeColor: const Color(0xff3183FF),
                            activeTextColor: Colors.green,
                            //   inactiveTextColor: Repository.textColor(context),
                            inactiveColor: Colors.grey,
                            // showOnOff: true,
                            onToggle: (val) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              orderController.showWegOrNoVeg.value = !orderController.showWegOrNoVeg.value;
                              prefs.setBool('showWegOrNoVeg', orderController.showWegOrNoVeg.value);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 17,
                    decoration: const BoxDecoration(color: Color(0xffF5F5F5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Display Product Image ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13.0,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Tooltip(
                                message: 'Show/Hide Product Image',
                                textStyle: const TextStyle(color: Colors.white),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: const Icon(
                                  Icons.info,
                                  color: Color(0xffF25F29),
                                  size: 25.0,
                                ),
                              )
                            ],
                          ),
                        ),
                        Obx(() {
                          return FlutterSwitch(
                            width: 40.0,
                            height: 20.0,
                            valueFontSize: 30.0,
                            toggleSize: 15.0,
                            value: orderController.isShowImage.value,
                            borderRadius: 20.0,
                            padding: 1.0,
                            activeColor: const Color(0xff3183FF),
                            activeTextColor: Colors.green,
                            //   inactiveTextColor: Repository.textColor(context),
                            inactiveColor: Colors.grey,
                            // showOnOff: true,
                            onToggle: (val) async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              orderController.isShowImage.value = !orderController.isShowImage.value;
                              prefs.setBool('show_product_image', orderController.isShowImage.value);
                            },
                          );
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Count of Row", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                borderRadius: const BorderRadius.all(Radius.circular(8))),
                            height: MediaQuery.of(context).size.height / 23, //height of button
                            width: MediaQuery.of(context).size.width / 9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 40,
                                  height: MediaQuery.of(context).size.height / 22,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (orderController.rowCountGridView <= 1) {
                                        } else {
                                          orderController.rowCountGridView = orderController.rowCountGridView - 1;
                                          orderController.rowCountController.text = "${orderController.rowCountGridView}";
                                        }
                                      });
                                    },
                                    child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                          right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                  width: MediaQuery.of(context).size.width / 20,
                                  child: TextField(
                                    readOnly: true,
                                    controller: orderController.rowCountController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.00),
                                    onChanged: (text) async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();

                                      if (text.isNotEmpty) {
                                        orderController.rowCountGridView = int.parse(text);
                                        orderController.groupNameFontSizeController.text = "${orderController.rowCountGridView}";
                                        prefs.setInt('count_of_row', orderController.rowCountGridView);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                        hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 40,
                                  child: GestureDetector(
                                      onTap: () {
                                        if (orderController.rowCountGridView == 5) {
                                        } else {
                                          setState(() {
                                            orderController.rowCountGridView = orderController.rowCountGridView + 1;
                                            orderController.rowCountController.text = "${orderController.rowCountGridView}";
                                          });
                                        }
                                      },
                                      child: InkWell(
                                        child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  orderController.isShowImage.value
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Image Height", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        height: MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.heightOfImage <= 1) {
                                              } else {
                                                orderController.heightOfImage = orderController.heightOfImage - 1;
                                                orderController.heightImageSizeController.text = "${orderController.heightOfImage}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          controller: orderController.heightImageSizeController,
                                          textAlign: TextAlign.center,
                                          readOnly: true,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.00),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.heightOfImage = double.parse(text);
                                              orderController.heightImageSizeController.text = "${orderController.heightOfImage}";
                                              prefs.setDouble('heightOfImage', orderController.heightOfImage);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.heightOfImage = orderController.heightOfImage + 1;
                                                orderController.heightImageSizeController.text = "${orderController.heightOfImage}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  orderController.isShowImage.value
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width / 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Image Width", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                                  height: MediaQuery.of(context).size.height / 23, //height of button
                                  width: MediaQuery.of(context).size.width / 9,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        height: MediaQuery.of(context).size.height / 22,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (orderController.widthOfImage <= 1) {
                                              } else {
                                                orderController.widthOfImage = orderController.widthOfImage - 1;
                                                orderController.widthImageSizeController.text = "${orderController.widthOfImage}";
                                              }
                                            });
                                          },
                                          child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                                right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                        width: MediaQuery.of(context).size.width / 20,
                                        child: TextField(
                                          controller: orderController.widthImageSizeController,
                                          textAlign: TextAlign.center,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          readOnly: true,
                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.00),
                                          onChanged: (text) async {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            if (text.isNotEmpty) {
                                              orderController.widthOfImage = double.parse(text);
                                              orderController.widthImageSizeController.text = "${orderController.rowCountGridView}";
                                              prefs.setDouble('widthOfImage', orderController.widthOfImage);
                                            } else {}
                                          },
                                          decoration: const InputDecoration(
                                              hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width / 40,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                orderController.widthOfImage = orderController.widthOfImage + 1;
                                                orderController.widthImageSizeController.text = "${orderController.widthOfImage}";
                                              });
                                            },
                                            child: InkWell(
                                              child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),

                  ///height
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Height", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                                borderRadius: const BorderRadius.all(Radius.circular(8))),
                            height: MediaQuery.of(context).size.height / 23, //height of button
                            width: MediaQuery.of(context).size.width / 9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 40,
                                  height: MediaQuery.of(context).size.height / 22,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (orderController.heightOfITem <= 0) {
                                        } else {
                                          orderController.heightOfITem = orderController.heightOfITem - 1;
                                          orderController.heightController.text = "${orderController.heightOfITem}";
                                        }
                                      });
                                    },
                                    child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                          right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                  width: MediaQuery.of(context).size.width / 20,
                                  child: TextField(
                                    controller: orderController.heightController,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    readOnly: true,
                                    style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.0),
                                    onChanged: (text) async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();

                                      if (text.isNotEmpty) {
                                        orderController.heightOfITem = double.parse(text);
                                        //  orderController.heightController.text = "${orderController.heightOfITem}";
                                        prefs.setDouble('height_of_item', orderController.heightOfITem);
                                      } else {}
                                    },
                                    decoration: const InputDecoration(
                                        hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 40,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          orderController.heightOfITem = orderController.heightOfITem + 1;
                                          orderController.heightController.text = "${orderController.heightOfITem}";
                                        });
                                      },
                                      child: InkWell(
                                        child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //width commented herer
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 8.0, top: 8),
                  //   child: Container(
                  //     alignment: Alignment.centerLeft,
                  //     width: MediaQuery.of(context).size.width / 3,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text("Size",
                  //             style: customisedStyle(
                  //                 context, Colors.black, FontWeight.w500, 13.0)),
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               border:
                  //                   Border.all(color: Color(0xffD7D7D7), width: .5),
                  //               borderRadius: BorderRadius.all(Radius.circular(8))),
                  //           height: MediaQuery.of(context).size.height /
                  //               23, //height of button
                  //           width: MediaQuery.of(context).size.width / 11,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: [
                  //               Container(
                  //                 alignment: Alignment.center,
                  //                 width: MediaQuery.of(context).size.width / 40,
                  //                 height: MediaQuery.of(context).size.height / 22,
                  //                 child: GestureDetector(
                  //                   onTap: () {
                  //                     setState(() {
                  //                       if (orderController.widthOfItem <= 0) {
                  //                       } else {
                  //                         orderController.widthOfItem =
                  //                             orderController.widthOfItem + 1;
                  //                         orderController.widthController.text =
                  //                         "${orderController.widthOfItem}";
                  //                       }
                  //                     });
                  //                   },
                  //                   child: InkWell(
                  //                       child: SvgPicture.asset(
                  //                           'assets/svg/minus_mob.svg')),
                  //                 ),
                  //               ),
                  //               Container(
                  //                 alignment: Alignment.center,
                  //                 height: MediaQuery.of(context).size.height /
                  //                     20, //height of button
                  //                 width: MediaQuery.of(context).size.width / 29,
                  //                 child: TextField(
                  //                   controller: orderController.widthController,
                  //                   textAlign: TextAlign.center,
                  //                   inputFormatters: [
                  //                     FilteringTextInputFormatter.allow(
                  //                         RegExp(r'[0-9]')),
                  //                   ],
                  //                   style: customisedStyle(
                  //                       context,
                  //                       const Color(0xff000000),
                  //                       FontWeight.w500,
                  //                       12.5),
                  //                   onChanged: (text) async {
                  //                     SharedPreferences prefs =
                  //                         await SharedPreferences.getInstance();
                  //
                  //                     if (text.isNotEmpty) {
                  //                       orderController.widthOfItem =
                  //                           double.parse(text);
                  //                       orderController.heightController.text =
                  //                           "${orderController.widthOfItem}";
                  //                       prefs.setDouble('widthOfItem',
                  //                           orderController.widthOfItem);
                  //                     } else {}
                  //                   },
                  //                   decoration: const InputDecoration(
                  //                     hintText: '15.0',
                  //                     isDense: true,
                  //                     contentPadding: EdgeInsets.all(12),
                  //                     enabledBorder: OutlineInputBorder(
                  //                         borderSide: BorderSide(
                  //                             width: .5, color: Color(0xffD7D7D7))),
                  //                     focusedBorder: OutlineInputBorder(
                  //                         borderSide: BorderSide(
                  //                             width: .5, color: Color(0xffD7D7D7))),
                  //                     disabledBorder: OutlineInputBorder(
                  //                         borderSide: BorderSide(
                  //                             color: Color(0xffD7D7D7), width: .5)),
                  //                   ),
                  //                 ),
                  //               ),
                  //               Container(
                  //                 alignment: Alignment.center,
                  //                 width: MediaQuery.of(context).size.width / 40,
                  //                 child: GestureDetector(
                  //                     onTap: () {
                  //                       setState(() {
                  //                         orderController.widthOfItem =
                  //                             orderController.widthOfItem - 1;
                  //                         orderController.widthController.text =
                  //                         "${orderController.widthOfItem}";
                  //                       });
                  //
                  //                     },
                  //                     child: InkWell(
                  //                       child: Center(
                  //                           child: SvgPicture.asset(
                  //                               'assets/svg/plus_mob.svg')),
                  //                     )),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //
                  //         ///
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
            ),
            height: MediaQuery.of(context).size.height * .11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffDF1515))),
                        onPressed: () {
                          orderController.detailPage.value = 'item_add';
                          orderController.getDefaultValue();
                          setState(() {});
                          //     orderController.update();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/svg/close-circle.svg"),
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, right: 12),
                              child: Text(
                                'cancel'.tr,
                                style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 13.0),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xff10C103))),
                        onPressed: () {
                          orderController.saveDefaultValue();
                          orderController.detailPage.value = 'item_add';
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/svg/save_mob.svg'),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: Text(
                                'Save',
                                style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                              ),
                            )
                          ],
                        ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget productDetailPage() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 10.0,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Product Details",
                style: customisedStyle(context, Colors.black, FontWeight.w600, 16.0),
              ),


              Row(
                children: [
                  IconButton(
                    icon: SvgPicture.asset(
                      height: 40,
                      width: 50,
                      "assets/svg/close-circle.svg",
                      colorFilter: ColorFilter.mode(
                        Color(0xffDF1515),
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      orderController.detailPage.value = 'item_add';
                      orderController.update();
                      // Add your desired action here
                    },
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      height: 40,
                      width: 50,
                      "assets/svg/save_mob.svg",
                      colorFilter: ColorFilter.mode(
                        Color(0xff10C103),
                        BlendMode.srcIn,

                      ),
                    ),
                    onPressed: () {
                      orderController.addItemToList(index: orderController.indexDetail);
                      orderController.detailPage.value = 'item_add';
                      orderController.update();
                      // Add your desired action here
                    },
                  )
                ],
              ),


              // Container(
              //   decoration: const BoxDecoration(
              //     border: Border(
              //         top: BorderSide(
              //           //  color: Colors.red
              //             color: Color(0xFFE8E8E8))),
              //   ),
              //   //  height: 50,
              //   height: MediaQuery.of(context).size.height * .11,
              //   child: Center(
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         TextButton(
              //             style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffDF1515))),
              //             onPressed: () {
              //               orderController.detailPage.value = 'item_add';
              //               orderController.update();
              //             },
              //             child: Row(
              //               children: [
              //                 SvgPicture.asset("assets/svg/close-circle.svg"),
              //                 Padding(
              //                   padding: const EdgeInsets.only(left: 12.0, right: 12),
              //                   child: Text(
              //                     'cancel'.tr,
              //                     style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 13.0),
              //                   ),
              //                 ),
              //               ],
              //             )),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         TextButton(
              //             style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xff10C103))),
              //             onPressed: () {
              //               orderController.addItemToList(index: orderController.indexDetail);
              //               orderController.detailPage.value = 'item_add';
              //               orderController.update();
              //             },
              //             child: Row(
              //               children: [
              //                 SvgPicture.asset('assets/svg/save_mob.svg'),
              //                 Padding(
              //                   padding: const EdgeInsets.only(left: 8.0, right: 8),
              //                   child: Text(
              //                     'Save'.tr,
              //                     style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
              //                   ),
              //                 )
              //               ],
              //             )),
              //       ],
              //     ),
              //   ),
              // )

            ],
          ),
        ),

        dividerStyle(),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// image commented
                  // Container(
                  //   // color:Colors.red,
                  //   height: MediaQuery.of(context).size.height / 11,
                  //   width: MediaQuery.of(context).size.width / 17,
                  //   child: CircleAvatar(child: SvgPicture.asset("assets/svg/no_image.svg")),
                  // ),

                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.19,
                      child: Column(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            orderController.productNameDetail,
                            style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          orderController.productDescription.value != ""
                              ? Text(
                                  orderController.productDescription.value,
                                  style: customisedStyle(context, Colors.grey, FontWeight.w400, 12.0),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),

                  SvgPicture.asset(
                    "assets/svg/veg_mob.svg",
                    //       color: widget.isColor == true ? const Color(0xff00775E) : const Color(0xffDF1515),
                  ),

                  // Check if the current index is the selected index and the additem is true
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      orderController.currency.value,
                      style: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.w400, 15.0),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 19,
                    width: MediaQuery.of(context).size.width / 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Color(0xffE7E7E7))
                    ),
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                      ],
                      //  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      onTap: () => orderController.unitPriceChangingController.selection =
                          TextSelection(baseOffset: 0, extentOffset: orderController.unitPriceChangingController.value.text.length),
                      onChanged: (value) {
                        if (value != "") {
                          orderController.quantity.value = double.parse(orderController.orderItemList[orderController.indexDetail]["Qty"].toString());
                          orderController.calculationOnEditing(index: orderController.indexDetail, isQuantityButton: false, value: value.toString());
                        }
                      },
                      controller: orderController.unitPriceChangingController,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                      decoration: TextFieldDecoration.defaultTextField(hintTextStr: ""),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: SvgPicture.asset(
                      "assets/svg/minus_mob.svg",
                    ),
                    onPressed: () {
                      if (orderController.quantityForDetailsSection.value != 1.0) {
                        orderController.quantityForDetailsSection.value = orderController.quantityForDetailsSection.value - 1;
                        orderController.calculationOnEditing(
                            index: orderController.indexDetail,
                            isQuantityButton: true,
                            value: orderController.quantityForDetailsSection.value.toString());
                      }
                    },
                  ),
                  Obx(
                    () => Container(
                      height: MediaQuery.of(context).size.height / 19,
                      width: MediaQuery.of(context).size.width / 15,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffE7E7E7))),
                      child: Center(
                        child: Text(
                          roundStringWith(orderController.quantityForDetailsSection.value.toString()),
                          style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                          // style: TextStyle(
                          //   fontSize: 18,
                          //   color: Colors.black,
                          // ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset("assets/svg/plus_mob.svg"),
                    onPressed: () {
                      orderController.quantityForDetailsSection.value = orderController.quantityForDetailsSection.value + 1;
                      orderController.calculationOnEditing(
                          index: orderController.indexDetail,
                          isQuantityButton: true,
                          value: orderController.quantityForDetailsSection.value.toString());
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 10),
          child: Container(
            height: MediaQuery.of(context).size.height / 19,
            // width: MediaQuery.of(context).size.width / 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: Color(0xffE7E7E7))
            ),
            child: TextField(
              controller: orderController.productNoteController,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              decoration: TextFieldDecoration.defaultTextField(hintTextStr: "Description"),
            ),
          ),
        ),

        /// flavour commented on last

        const SizedBox(
          height: 20,
        ),
        Obx(() => orderController.flavourList.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select a Flavour",
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                    ),
                    orderController.flavourID.value != ""
                        ? GestureDetector(
                            onTap: () {
                              orderController.flavourID.value = "";
                              orderController.update();
                            },
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.blueGrey,
                            ),
                          )
                        : Container(),
                  ],
                ),
              )
            : Container()),
        Obx(() => orderController.flavourList.isNotEmpty ? dividerStyle() : Container()),
        Obx(() => orderController.flavourList.isNotEmpty
            ? ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 280, minHeight: 280),
                child: ListView.separated(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => dividerStyle(),
                    itemCount: orderController.flavourList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () async {
                          orderController.flavourName.value = orderController.flavourList[index].flavourName;
                          orderController.flavourID.value = orderController.flavourList[index].id;
                          orderController.update();
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    orderController.flavourList[index].flavourName,
                                    style: customisedStyle(context, Colors.black, FontWeight.w400, 13.0),
                                  ),
                                  Obx(() => orderController.flavourID.value == orderController.flavourList[index].id
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Color(0xffF25F29),
                                        )
                                      : Container()),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
            : Container(
                height: 280,
              )),


        // DividerStyle()
      ],
    );
  }

  Widget itemAddWidget() {
    return Column(
      children: [
        Obx(() =>  Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Disable KOT',
                style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 5.0),
                child: FlutterSwitch(
                  width: 50.0,
                  height: 25.0,
                  valueFontSize: 30.0,
                  toggleSize: 15.0,
                  value: orderController.disableKOT.value,
                  borderRadius: 20.0,
                  padding: 1.0,
                  activeColor: Colors.green,
                  activeTextColor: Colors.green,
                  inactiveTextColor: Colors.white,
                  inactiveColor: Colors.grey,
                  // showOnOff: true,
                  onToggle: (val){
                    orderController.disableKOT.value = val;
                    orderController.update();
                  },
                ),
              )
            ],
          ),
        )),
        Obx(
          () => Expanded(
              child: ListView.separated(
            separatorBuilder: (context, index) => dividerStyle(),
            itemCount: orderController.orderItemList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  orderController.deleteOrderItem(index: index);
                },
                background: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: AlignmentDirectional.centerEnd,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    orderController.detailPage.value = 'detail_page';
                    orderController.update();
                    loadData();
                    orderController.productNameDetail = orderController.orderItemList[index]["ProductName"];
                    orderController.indexDetail = index;
                  },
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 0.0, right: 2, top: 10, bottom: 10),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(
                              () => IconButton(
                                icon: Icon(Icons.check_circle,
                                    size: 25,
                                    color: orderController.checkValueInList(index) == true ? const Color(0xffF25F29) : const Color(0xfffdddddd)),
                                onPressed: () {
                                  var result = orderController.checkValueInList(index);
                                  if (result) {
                                    orderController.kartChange.remove(index);
                                    orderController.update();
                                  } else {
                                    orderController.kartChange.add(index);
                                  }
                                },
                              ),
                            ),
                            Obx(
                              () => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/svg/veg_mob.svg"),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10.0, top: 0, left: 10),
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.11,
                                          child: Text(
                                            orderController.orderItemList[index]["ProductName"] ?? '',
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  orderController.orderItemList[index]["Description"] != ""
                                      ? ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 160, minWidth: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10.0, right: 5),
                                            child: Text(
                                              orderController.orderItemList[index]["Description"],
                                              style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 12.0),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          orderController.orderItemList[index]["Flavour_Name"] != ""
                                              ? Padding(
                                                  padding: const EdgeInsets.only(left: 5.0),
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width / 15,
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 5),
                                                      child: Text(
                                                        orderController.orderItemList[index]["Flavour_Name"] ?? "",
                                                        style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 13.0),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  height: MediaQuery.of(context).size.height / 30,
                                                  width: MediaQuery.of(context).size.width / 15,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffFFF6F2),
                                                    borderRadius: BorderRadius.circular(30),
                                                  ),
                                                  child: const Center(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: Text(
                                                        "  + Flavour",
                                                        style: TextStyle(fontSize: 11, color: Colors.redAccent),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          Obx(() => Container(
                                                height: MediaQuery.of(context).size.height / 33,
                                                decoration: BoxDecoration(
                                                  color: orderController.returnIconStatus(orderController.orderItemList[index]["Status"]),
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                    child: Text(
                                                      orderController.returnStatus(orderController.orderItemList[index]["Status"]),
                                                      style: const TextStyle(fontSize: 11, color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      orderController.currency.value,
                                      style: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.w400, 14.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        roundStringWith(orderController.orderItemList[index]["UnitPrice"].toString()),
                                        style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: SvgPicture.asset("assets/svg/minus_mob.svg"),
                                      onPressed: () {
                                        if (double.parse(orderController.orderItemList[index]["Qty"].toString()) >= 2.0) {
                                          orderController.updateQty(index: index, type: 0);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height / 21,
                                      width: MediaQuery.of(context).size.width / 20,
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffE7E7E7))),
                                      child: Center(
                                        child: Text(
                                          roundStringWith(orderController.orderItemList[index]["Qty"].toString()),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset("assets/svg/plus_mob.svg"),
                                      onPressed: () {
                                        orderController.updateQty(index: index, type: 1);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )),
        ),

        ///

        SizedBox(
          height: MediaQuery.of(context).size.height * .22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// status chnageing commented
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffEEF5FF))),
                    onPressed: () {
                      orderController.changeStatus("take_away");
                      orderController.update();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Text(
                        "TakeAway",
                        style: customisedStyle(context, const Color(0xff034FC1), FontWeight.normal, 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  TextButton(
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffF0F0F0))),
                      onPressed: () {
                        orderController.changeStatus("delivered");
                        orderController.update();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Text(
                          'Delivered',
                          style: customisedStyle(context, const Color(0xff000000), FontWeight.normal, 12.0),
                        ),
                      )),
                  const SizedBox(
                    width: 7,
                  ),
                ],
              ),
              const SizedBox(
                height: 9,
              ),

              Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'to_be_paid'.tr,
                          style: customisedStyle(context, const Color(0xff9E9E9E), FontWeight.w400, 17.0),
                        ),
                      ),
                      Text(
                        orderController.currency.value,
                        style: customisedStyle(context, const Color(0xff000000), FontWeight.w400, 16.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text(
                          roundStringWith(orderController.totalNetP.toString()),
                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffDF1515))),
                        onPressed: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/svg/close-circle.svg"),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0, right: 5),
                              child: Text(
                                'cancel'.tr,
                                style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      width: 7,
                    ),
                    posController.checkPermissionForSave(widget.orderType)
                        ? TextButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xff10C103))),
                            onPressed: () async {
                              orderController.createMethod(
                                  tableID: widget.tableID,
                                  tableHead: widget.tableHead,
                                  orderType: widget.orderType,
                                  context: context,
                                  orderID: widget.uID,
                                  splitID: widget.splitID,
                                  isPayment: false,
                                  sectionType: widget.sectionType,
                                  platformID: platformController.platformID.value);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/save_mob.svg'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                                  child: Text(
                                    'Save'.tr,
                                    style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                                  ),
                                )
                              ],
                            ))
                        : Container(),
                    const SizedBox(
                      width: 7,
                    ),
                    posController.checkPermissionForSave(widget.orderType)
                        ? TextButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xff00775E))),
                            onPressed: () {
                              orderController.createMethod(
                                  tableID: widget.tableID,
                                  tableHead: widget.tableHead,
                                  orderType: widget.orderType,
                                  splitID: widget.splitID,
                                  context: context,
                                  orderID: widget.uID,
                                  isPayment: true,
                                  sectionType: widget.sectionType,
                                  platformID: platformController.platformID.value);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/svg/payment_mob.svg'),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0, right: 5),
                                  child: Text(
                                    'payment'.tr,
                                    style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                                  ),
                                )
                              ],
                            ))
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
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
                      child: Text(orderController.customerBalance.value,
                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0)),
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
