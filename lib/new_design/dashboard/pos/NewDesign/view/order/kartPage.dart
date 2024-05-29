import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/customer_detail.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/select_deliveryman.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/payment/payment_page.dart';

import 'product_detail_page.dart';

class OrderDetailPage extends StatefulWidget {
  final String uID, tableID, sectionType, tableHead;
  final int orderType;

  const OrderDetailPage({
    super.key,
    required this.tableID,
    required this.tableHead,
    required this.uID,
    required this.sectionType,
    required this.orderType,
  });

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderController orderController = Get.put(OrderController());
  var selectedItem = '';

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
            const Text(
              'Table Order',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Table Order',
                  style: TextStyle(
                      color: Color(0xff585858),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Obx(() => Text(
                      orderController.tokenNumber.value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
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
                  orderController.deliveryManController.clear();
                  orderController.customerNameController.clear();
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
          SearchFieldWidgetNew(
            autoFocus: false,
            mHeight: MediaQuery.of(context).size.height / 18,
            hintText: 'Search',
            controller: orderController.searchController,
            onChanged: (quary) async {},
          ),
          DividerStyle(),
          Obx(
            () => Expanded(
                child: ListView.separated(
              separatorBuilder: (context, index) => DividerStyle(),
              itemCount: orderController.orderItemList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(orderController.orderItemList[index]["unq_id"]
                      .toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    // Remove the item from your data source.
                    ///  orderController.deleteOrderItem(index: index);
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
                      Get.to(ProductDetailPage(
                        index: index,
                        image: "",
                      ));
                    },
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 5, top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Color(0xffF25F29)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/svg/veg_mob.svg"),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, top: 0, left: 10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Text(
                                          orderController.orderItemList[index]
                                                  ["ProductName"] ??
                                              'sdsd',
                                          style: customisedStyle(
                                              context,
                                              Colors.black,
                                              FontWeight.w400,
                                              15.0),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                orderController.orderItemList[index]
                                            ["Description"] !=
                                        ""
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 5),
                                        child: Text(
                                          orderController.orderItemList[index]
                                              ["Description"],
                                          style: customisedStyle(
                                              context,
                                              const Color(0xffF25F29),
                                              FontWeight.w400,
                                              13.0),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      orderController.orderItemList[index]
                                                  ["Flavour_Name"] !=
                                              ""
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0, right: 5),
                                              child: Text(
                                                orderController.orderItemList[
                                                            index]
                                                        ["Flavour_Name"] ??
                                                    "",
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xffF25F29),
                                                    FontWeight.w400,
                                                    13.0),
                                              ),
                                            )
                                          : Container(),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              32,
                                          decoration: BoxDecoration(
                                            color: orderController
                                                .returnIconStatus(
                                                    orderController
                                                            .orderItemList[
                                                        index]["Status"]),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, right: 10),
                                              child: Text(
                                                orderController
                                                        .orderItemList[index]
                                                    ["Status"],
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      orderController.currency.value,
                                      style: customisedStyle(
                                          context,
                                          const Color(0xffA5A5A5),
                                          FontWeight.w400,
                                          14.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        roundStringWith(orderController
                                            .orderItemList[index]["NetAmount"]
                                            .toString()),
                                        style: customisedStyle(
                                            context,
                                            const Color(0xff000000),
                                            FontWeight.w500,
                                            16.0),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: SvgPicture.asset(
                                          "assets/svg/minus_mob.svg"),
                                      onPressed: () {
                                        orderController.updateQty(
                                            index: index, type: 0);
                                      },
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              21,
                                      width:
                                          MediaQuery.of(context).size.width / 7,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: const Color(0xffE7E7E7))),
                                      child: Center(
                                        child: Text(
                                          roundStringWith(orderController
                                              .orderItemList[index]["Qty"]
                                              .toString()),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: SvgPicture.asset(
                                          "assets/svg/plus_mob.svg"),
                                      onPressed: () {
                                        orderController.updateQty(
                                            index: index, type: 1);
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
                );
              },
            )),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// status chnageing commented
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     TextButton(
            //         style: ButtonStyle(
            //             backgroundColor:
            //             MaterialStateProperty.all(const Color(0xffEEF5FF))),
            //         onPressed: () {},
            //         child: Padding(
            //           padding: const EdgeInsets.only(left: 5.0, right: 5),
            //           child: Text(
            //             "TakeAway",
            //             style: customisedStyle(
            //                 context,
            //                 const Color(0xff034FC1),
            //                 FontWeight.normal,
            //                 12.0),
            //           ),
            //         ),),
            //     const SizedBox(
            //       width: 7,
            //     ),
            //     TextButton(
            //         style: ButtonStyle(
            //             backgroundColor:
            //             MaterialStateProperty.all(const Color(0xffF0F0F0))),
            //         onPressed: () {},
            //         child:  Padding(
            //           padding: const EdgeInsets.only(left: 5.0, right: 5),
            //           child: Text(
            //             'Delivered',
            //             style: customisedStyle(
            //                 context,
            //                 const Color(0xff000000),
            //                 FontWeight.normal,
            //                 12.0),
            //           ),
            //         )),
            //     const SizedBox(
            //       width: 7,
            //     ),
            //     TextButton(
            //         style: ButtonStyle(
            //             backgroundColor:
            //             MaterialStateProperty.all(const Color(0xffFFF6F2))),
            //         onPressed: () {
            //           Get.back();
            //         },
            //         child: Row(
            //           children: [
            //             const Icon(Icons.add,color: Color(0xffF25F29),),
            //             Padding(
            //               padding: const EdgeInsets.only(left: 5.0, right: 5),
            //               child: Text(
            //                 'Items',
            //                 style: customisedStyle(
            //                     context,
            //                     const Color(0xffF25F29),
            //                     FontWeight.normal,
            //                     12.0),
            //               ),
            //             )
            //           ],
            //         )),
            //   ],
            // ),
            // const SizedBox(
            //   height: 9,
            // ),
            Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
            const SizedBox(
              height: 8,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "To be paid",
                      style: customisedStyle(context, const Color(0xff9E9E9E),
                          FontWeight.w400, 17.0),
                    ),
                  ),
                  Text(
                    orderController.currency.value,
                    style: customisedStyle(context, const Color(0xff000000),
                        FontWeight.w400, 16.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0),
                    child: Text(
                      roundStringWith(orderController.totalNetP.toString()),
                      style: customisedStyle(context, const Color(0xff000000),
                          FontWeight.w500, 18.0),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffDF1515))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/close-circle.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            "Cancel",
                            style: customisedStyle(
                                context,
                                const Color(0xffffffff),
                                FontWeight.normal,
                                12.0),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 7,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff10C103))),
                    onPressed: () async {
                      var netWork = await checkNetwork();
                      if (netWork) {
                        if (orderController.orderItemList.isEmpty) {
                          popAlert(
                              head: "Waring",
                              message: "At least one product",
                              position: SnackPosition.TOP);
                        } else {
                          bool val =
                              await orderController.checkNonRatableItem();
                          if (val) {
                            orderController.createSalesOrderRequest(
                                context: context,
                                isPayment: false,
                                orderType: widget.orderType,
                                tableHead: widget.tableHead,
                                tableID: widget.tableID);
                          } else {
                            popAlert(
                                head: "Waring",
                                message: "Price must be greater than 0",
                                position: SnackPosition.TOP);
                          }
                        }
                      } else {
                        popAlert(
                            head: "Alert",
                            message: "You are connected to the internet",
                            position: SnackPosition.TOP);
                      }
                    },
                    //
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/save_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            'Save'.tr,
                            style: customisedStyle(
                                context,
                                const Color(0xffffffff),
                                FontWeight.normal,
                                12.0),
                          ),
                        )
                      ],
                    )),
                const SizedBox(
                  width: 7,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff00775E))),
                    onPressed: () {
                      Get.to(PaymentPage(
                        uID: widget.uID,
                      ));
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/payment_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            'Payment',
                            style: customisedStyle(
                                context,
                                const Color(0xffffffff),
                                FontWeight.normal,
                                12.0),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addDetails() {
    Get.bottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          // Set border radius to the top left corner
          topRight: Radius.circular(
              10.0), // Set border radius to the top right corner
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
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
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
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      final result = await Get.to(CustomerDetailPage());

                      if (result != null) {
                        orderController.customerNameKartController.text = result[0];

                      }

                    },
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.customerNameKartController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),

                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(
                        hintTextStr: 'Customer'),
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
                      style: customisedStyle(context, const Color(0xff8C8C8C),
                          FontWeight.w400, 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      orderController.currency.value,
                      style: customisedStyle(context, const Color(0xff8C8C8C),
                          FontWeight.w400, 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("00.0",
                        style: customisedStyle(context, const Color(0xff000000),
                            FontWeight.w500, 15.0)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                    ], keyboardType: TextInputType.number,
                    controller: orderController.phoneNumberKartController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),


                    decoration: TextFieldDecoration.defaultTextField(
                        hintTextStr: 'Phone No'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    readOnly: true,
                    onTap: () async {
                      final result = await Get.to(SelectDeliveryMan());

                      if (result != null) {
                        orderController.deliveryManKartController.text = result[0];

                      }
                    }
                    ,
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.deliveryManKartController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),

                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(
                        hintTextStr: 'Delivery Man'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 12, bottom: 12),
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.platformKartController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),

                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextFieldIcon(
                        hintTextStr: 'Platform(Online Only)'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16, bottom: 16, top: 5),
                child: Container(
                  height: MediaQuery.of(context).size.height / 17,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffF25F29)),
                    ),
                    onPressed: () {
                      // Do something with the text

                      Get.back(); // Close the bottom sheet
                    },
                    child: Text(
                      'save'.tr,
                      style: customisedStyle(
                          context, Colors.white, FontWeight.normal, 12.0),
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
