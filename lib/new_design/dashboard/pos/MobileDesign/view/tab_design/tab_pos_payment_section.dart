import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../global/customclass.dart';
import '../../../../../../global/global.dart';
import '../../../../../../global/textfield_decoration.dart';
import '../../../../../back_ground_print/wifi_print/test_page/print_settings.dart';
import '../../../detail/selected_customer.dart';
import '../../controller/payment_controller.dart';
import '../detail_page/customer_detail.dart';
import '../detail_page/platform.dart';

class TabPaymentSection extends StatefulWidget {
  final String uID, tableID,type;
  final int orderType;

  const TabPaymentSection(
      {super.key,
      required this.uID,
      required this.type,
      required this.tableID,
      required this.orderType});

  @override
  State<TabPaymentSection> createState() => _TabPaymentSectionState();
}

class _TabPaymentSectionState extends State<TabPaymentSection> {
  POSPaymentController paymentController = Get.put(POSPaymentController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentController.getOrderDetails(uID: widget.uID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Payment",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
        ),
        actions: const [],
      ),
      body: Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xffE9E9E9))),
        child: Row(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 15),
                decoration: const BoxDecoration(
                    border:
                        Border(right: BorderSide(color: Color(0xffE9E9E9)))),
                child: Column(
                  children: [
                    //   diningController.selectedIndexNotifier.value =
                    /// product list
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, top: 15, left: 20),
                          child: Text(
                            "Payment",
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 14.0),
                          ),
                        ),
                      ],
                    ),
                    dividerStyle(),
                    SingleChildScrollView(
                        child: Obx(() => paymentController.detailLoading.value
                            ? Container(
                            height: 500,
                            child: const Center(
                                child: CircularProgressIndicator()))
                            : Container(
                          height:
                          MediaQuery.of(context).size.height * .80,
                          child: Row(
                            children: [
                              Container(
                                width:MediaQuery.of(context).size.width*.32,
                                child: ListView(
                                  children: [
                                    Container(
                                      height: 1,
                                      color: const Color(0xffE9E9E9),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Obx(
                                          () => Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(11),
                                              border: Border.all(
                                                  color: const Color(
                                                      0xffE6E6E6))),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    ///  addDetails();
                                                    final result = await Get.to(CustomerDetailPage());
                                                    if (result != null) {
                                                      paymentController.paymentCustomerSelection.text = result[0];
                                                      paymentController.ledgerID.value = result[2];
                                                      setState(() {

                                                      });

                                                    }
                                                  },
                                                  child: InkWell(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(12.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'customer'.tr,
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff8C8C8C),
                                                                  FontWeight
                                                                      .w400,
                                                                  16.0),
                                                            ),
                                                            Text(
                                                              paymentController
                                                                  .paymentCustomerSelection
                                                                  .text,
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff000000),
                                                                  FontWeight
                                                                      .w500,
                                                                  16.5),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              color: Colors
                                                                  .black,
                                                              size: 15,
                                                            )
                                                          ]),
                                                    ),
                                                  )),
                                              dividerStyle(),
                                              GestureDetector(
                                                  onTap: () async {
                                                    ///addDetails();
                                                  },
                                                  child: InkWell(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .all(12.0),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'ph_no'.tr,
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff8C8C8C),
                                                                  FontWeight
                                                                      .w400,
                                                                  16.0),
                                                            ),
                                                            Text(
                                                              paymentController
                                                                  .customerPhoneSelection
                                                                  .text ??
                                                                  "",
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff000000),
                                                                  FontWeight
                                                                      .w500,
                                                                  16.0),
                                                            ),
                                
                                                            Text(
                                                              "",
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff000000),
                                                                  FontWeight
                                                                      .w500,
                                                                  16.0),
                                                            ),
                                                            // const Icon(
                                                            //   Icons.arrow_forward_ios,
                                                            //   color: Colors.black,
                                                            //   size: 15,
                                                            // )
                                                            //
                                                          ]),
                                                    ),
                                                  )),
                                              dividerStyle(),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                    12.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'balance1'.tr,
                                                        style: customisedStyle(
                                                            context,
                                                            const Color(
                                                                0xff8C8C8C),
                                                            FontWeight.w400,
                                                            16.0),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right:
                                                                8.0),
                                                            child: Text(
                                                              paymentController
                                                                  .currency
                                                                  .value,
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff8C8C8C),
                                                                  FontWeight
                                                                      .w400,
                                                                  16.0),
                                                            ),
                                                          ),
                                                          Text(
                                                            roundStringWith(
                                                                paymentController
                                                                    .balance
                                                                    .toString()),
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff000000),
                                                                FontWeight
                                                                    .w500,
                                                                16.0),
                                                          ),
                                                        ],
                                                      ),
                                                      const Text(
                                                        "",
                                                      ),
                                                    ]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(11),
                                            border: Border.all(
                                                color:
                                                const Color(0xffE6E6E6))),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                ///addDetails();
                                                // final result = await Get.to(SelectDeliveryMan());
                                                // if (result != null) {
                                                //   paymentController.deliveryManName.value = result[0];
                                                //   paymentController.deliveryManID.value = result[1];
                                                //   paymentController.update();
                                                // }
                                              },
                                              child: InkWell(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(
                                                      12.0),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Deliveryman'.tr,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff8C8C8C),
                                                              FontWeight.w400,
                                                              16.0),
                                                        ),
                                                        Text(
                                                          paymentController
                                                              .deliveryManName
                                                              .value,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              16.0),
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: Colors.black,
                                                          size: 15,
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                
                                            ///platform
                                            widget.type=='online'?  DividerStyle():Container(),
                                            widget.type=='online'?
                                                GestureDetector(
                                                    onTap:() async {
                                                      final result = await Get.to(() => OnlinePlatforms());

                                                      // Handle the result
                                                      if (result != null) {
                                                        print('Selected Platform Name: $result');

                                                        paymentController.platformName.value=result[0];
                                                      // paymentController.platformID.value=result[1];
                                                      }

                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(12.0),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                        Text(
                                                          'Platform'.tr,
                                                          style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                                        ),
                                                        Text(
                                                          paymentController.platformName.value,
                                                          style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0),
                                                        ),
                                                        const Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.black,
                                                          size: 15,
                                                        )
                                                      ]),
                                                    ),
                                                )
                                            :Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(11),
                                            border: Border.all(
                                                color:
                                                const Color(0xffE6E6E6))),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Discount'.tr,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              15.0),
                                                        ),
                                                      ]),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 18.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              10,
                                                          child: TextField(
                                                            textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                            controller:
                                                            paymentController
                                                                .discountAmountController,
                                                            keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                signed:
                                                                true,
                                                                decimal:
                                                                true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .deny(RegExp(
                                                                  '[-, ]')),
                                                            ],
                                                            onChanged:
                                                                (value) {
                                                              if (value
                                                                  .isEmpty) {
                                                                paymentController
                                                                    .discountCalc(
                                                                    2,
                                                                    "0");
                                                              } else {
                                                                paymentController
                                                                    .discountCalc(
                                                                    2,
                                                                    value);
                                                              }
                                                            },
                                                            onTap: () => paymentController
                                                                .discountAmountController
                                                                .selection =
                                                                TextSelection(
                                                                    baseOffset:
                                                                    0,
                                                                    extentOffset: paymentController
                                                                        .discountAmountController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                            style:
                                                            customisedStyle(
                                                                context,
                                                                Colors
                                                                    .black,
                                                                FontWeight
                                                                    .w500,
                                                                14.0),
                                                            // focusNode: diningController.customerNode,
                                
                                                            decoration: TextFieldDecoration
                                                                .defaultTextField(
                                                                hintTextStr:
                                                                'amount'
                                                                    .tr),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 18.0),
                                                        child: Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              10,
                                                          child: TextField(
                                                            textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                            keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                signed:
                                                                true,
                                                                decimal:
                                                                true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .deny(RegExp(
                                                                  '[-, ]')),
                                                            ],
                                                            onTap: () => paymentController
                                                                .discountPerController
                                                                .selection =
                                                                TextSelection(
                                                                    baseOffset:
                                                                    0,
                                                                    extentOffset: paymentController
                                                                        .discountPerController
                                                                        .value
                                                                        .text
                                                                        .length),
                                
                                                            controller:
                                                            paymentController
                                                                .discountPerController,
                                                            onChanged:
                                                                (value) {
                                                              if (value
                                                                  .isEmpty) {
                                                                paymentController
                                                                    .discountCalc(
                                                                    1,
                                                                    "0.0");
                                                              } else {
                                                                paymentController
                                                                    .discountCalc(
                                                                    1,
                                                                    value);
                                                              }
                                                            },
                                                            style:
                                                            customisedStyle(
                                                                context,
                                                                Colors
                                                                    .black,
                                                                FontWeight
                                                                    .w500,
                                                                14.0),
                                                            // focusNode: diningController.customerNode,
                                                            // onEditingComplete: () {
                                                            //   FocusScope.of(context).requestFocus();
                                                            // },
                                                            decoration: TextFieldDecoration
                                                                .defaultTextField(
                                                                hintTextStr:
                                                                "Percentage"),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ///
                                
                                  ],
                                ),
                              ),
                              Container(

                                width:MediaQuery.of(context).size.width*.32,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20,top: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(11),
                                            border: Border.all(
                                                color:
                                                const Color(0xffE6E6E6))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  'gross_amount'.tr,
                                                  style: customisedStyle(
                                                      context,
                                                      const Color(0xff8C8C8C),
                                                      FontWeight.w400,
                                                      16.0),
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          right: 8.0),
                                                      child: Text(
                                                        paymentController
                                                            .currency.value,
                                                        style: customisedStyle(
                                                            context,
                                                            const Color(
                                                                0xff8C8C8C),
                                                            FontWeight.w400,
                                                            16.0),
                                                      ),
                                                    ),
                                                    Text(
                                                      roundStringWith(
                                                          paymentController
                                                              .totalGrossP
                                                              .value
                                                              .toString()),
                                                      style: customisedStyle(
                                                          context,
                                                          const Color(
                                                              0xff000000),
                                                          FontWeight.w500,
                                                          16.0),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(11),
                                            border: Border.all(
                                                color:
                                                const Color(0xffE6E6E6))),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(12.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'total_tax'.tr,
                                                      style: customisedStyle(
                                                          context,
                                                          const Color(
                                                              0xff8C8C8C),
                                                          FontWeight.w400,
                                                          16.0),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 8.0),
                                                          child: Text(
                                                            paymentController
                                                                .currency
                                                                .value,
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff8C8C8C),
                                                                FontWeight
                                                                    .w400,
                                                                16.0),
                                                          ),
                                                        ),
                                                        Text(
                                                          roundStringWith(
                                                              paymentController
                                                                  .totalTaxMP
                                                                  .value),
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            dividerStyle(),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(12.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'net_total'.tr,
                                                      style: customisedStyle(
                                                          context,
                                                          const Color(
                                                              0xff8C8C8C),
                                                          FontWeight.w400,
                                                          16.0),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 8.0),
                                                          child: Text(
                                                            paymentController
                                                                .currency
                                                                .value,
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff8C8C8C),
                                                                FontWeight
                                                                    .w400,
                                                                16.0),
                                                          ),
                                                        ),
                                                        Text(
                                                          roundStringWith(
                                                              paymentController
                                                                  .totalNetP
                                                                  .value),
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              16.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                            dividerStyle(),
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(12.0),
                                              child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'grand_total'.tr,
                                                      style: customisedStyle(
                                                          context,
                                                          const Color(
                                                              0xff000000),
                                                          FontWeight.w600,
                                                          16.5),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              right: 8.0),
                                                          child: Text(
                                                            paymentController
                                                                .currency
                                                                .value,
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff8C8C8C),
                                                                FontWeight
                                                                    .w400,
                                                                16.5),
                                                          ),
                                                        ),
                                                        Text(
                                                          roundStringWith(
                                                              paymentController
                                                                  .grandTotalAmount
                                                                  .value),
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w600,
                                                              17.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(11),
                                            border: Border.all(
                                                color:
                                                const Color(0xffE6E6E6))),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.all(12.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'cash'.tr,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              16.5),
                                                        ),
                                                      ]),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              10,
                                                          child: TextField(
                                                            controller:
                                                            paymentController
                                                                .cashReceivedController,
                                                            keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal:
                                                                true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                  r'^\d+\.?\d{0,8}')),
                                                            ],
                                                            onChanged: (val) {
                                                              if (val
                                                                  .isEmpty) {
                                                                val = "0";
                                                              } else {
                                                                paymentController
                                                                    .calculationOnPayment();
                                                              }
                                                            },
                                                            textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                
                                                            style:
                                                            customisedStyle(
                                                                context,
                                                                Colors
                                                                    .black,
                                                                FontWeight
                                                                    .w400,
                                                                18.0),
                                                            // focusNode: diningController.customerNode,
                                                            // onEditingComplete: () {
                                                            //   FocusScope.of(context).requestFocus();
                                                            // },
                                                            onTap: () => paymentController
                                                                .cashReceivedController
                                                                .selection =
                                                                TextSelection(
                                                                    baseOffset:
                                                                    0,
                                                                    extentOffset: paymentController
                                                                        .cashReceivedController
                                                                        .value
                                                                        .text
                                                                        .length),
                                
                                                            decoration: TextFieldDecoration
                                                                .defaultTextField(
                                                                hintTextStr:
                                                                'amount'
                                                                    .tr),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 35,
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              15,
                                                          child: TextButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                WidgetStateProperty.all(
                                                                    const Color(
                                                                        0xff10C103))),
                                                            onPressed: () {
                                                              paymentController
                                                                  .bankReceivedController
                                                                  .text =
                                                                  roundStringWith(
                                                                      "0");
                                                              paymentController
                                                                  .cashReceivedController
                                                                  .text =
                                                                  roundStringWith(paymentController
                                                                      .grandTotalAmount
                                                                      .value
                                                                      .toString());
                                                              paymentController
                                                                  .calculationOnPayment();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left:
                                                                  12.0,
                                                                  right:
                                                                  12),
                                                              child: Text(
                                                                'Full'.tr,
                                                                style: customisedStyle(
                                                                    context,
                                                                    const Color(
                                                                        0xffffffff),
                                                                    FontWeight
                                                                        .normal,
                                                                    15.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  dividerStyle(),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'bank'.tr,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff000000),
                                                              FontWeight.w500,
                                                              16.5),
                                                        ),
                                                      ]),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              10,
                                                          child: TextField(
                                                            textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                            controller:
                                                            paymentController
                                                                .bankReceivedController,
                                                            style:
                                                            customisedStyle(
                                                                context,
                                                                Colors
                                                                    .black,
                                                                FontWeight
                                                                    .w400,
                                                                18.0),
                                                            keyboardType:
                                                            const TextInputType
                                                                .numberWithOptions(
                                                                decimal:
                                                                true),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .allow(RegExp(
                                                                  r'^\d+\.?\d{0,8}')),
                                                            ],
                                                            onChanged: (val) {
                                                              if (val
                                                                  .isEmpty) {
                                                              } else {
                                                                if (paymentController
                                                                    .checkBank(
                                                                    val)) {
                                                                  paymentController
                                                                      .calculationOnPayment();
                                                                } else {
                                                                  popAlert(
                                                                      head:
                                                                      "Waring",
                                                                      message:
                                                                      "More Amount received in bank",
                                                                      position:
                                                                      SnackPosition.TOP);
                                                                }
                                                              }
                                                            },
                                                            onEditingComplete:
                                                                () {
                                                              FocusScope.of(
                                                                  context)
                                                                  .requestFocus();
                                                            },
                                                            onTap: () => paymentController
                                                                .bankReceivedController
                                                                .selection =
                                                                TextSelection(
                                                                    baseOffset:
                                                                    0,
                                                                    extentOffset: paymentController
                                                                        .bankReceivedController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                            decoration: TextFieldDecoration
                                                                .defaultTextField(
                                                                hintTextStr:
                                                                'amount'
                                                                    .tr),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 35,
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width /
                                                              15,
                                                          child: TextButton(
                                                            style: ButtonStyle(
                                                                backgroundColor:
                                                                WidgetStateProperty.all(
                                                                    const Color(
                                                                        0xff10C103))),
                                                            onPressed: () {
                                                              paymentController
                                                                  .cashReceivedController
                                                                  .text =
                                                                  roundStringWith(
                                                                      "0");
                                                              paymentController
                                                                  .bankReceivedController
                                                                  .text =
                                                                  roundStringWith(paymentController
                                                                      .grandTotalAmount
                                                                      .value
                                                                      .toString());
                                                              paymentController
                                                                  .calculationOnPayment();
                                                            },
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left:
                                                                  12.0,
                                                                  right:
                                                                  12),
                                                              child: Text(
                                                                'Full'.tr,
                                                                style: customisedStyle(
                                                                    context,
                                                                    const Color(
                                                                        0xffffffff),
                                                                    FontWeight
                                                                        .normal,
                                                                    16.5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ))),
                  
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                  decoration: const BoxDecoration(
                      border:
                          Border(right: BorderSide(color: Color(0xffE9E9E9)))),
                  child: Column(
                    children: [
                      Obx(() => paymentController.detailLoading.value
                          ? SizedBox(
                          height: 500,
                          child: const Center(
                              child: CircularProgressIndicator()))
                          : Expanded(
                          child: Obx(() => GridView.builder(
                            padding: const EdgeInsets.all(10.0),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,

                              mainAxisSpacing: 20.0,
                              mainAxisExtent: 130,

                              childAspectRatio: 5,
                              // orderController.heightOfITem,
                              // childAspectRatio: 3.2,
                              crossAxisSpacing: 30,
                            ),
                            //separatorBuilder: (context, index) => dividerStyle(),
                            itemCount:
                            paymentController.saleOrderDetail.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () async {},
                                child: InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Color(0xffE8E8E8))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 15,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    top: 8),
                                                child: SvgPicture.asset(
                                                  "assets/svg/veg_mob.svg",
                                                  // color: orderController
                                                  //             .productList[
                                                  //                 index]
                                                  //             .vegOrNonVeg ==
                                                  //         "Non-veg"
                                                  //     ? const Color(
                                                  //         0xff00775E)
                                                  //     : const Color(
                                                  //         0xffDF1515),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 7,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        top: 4.0,
                                                        bottom: 4),
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            .13,
                                                        child: Text(
                                                          paymentController
                                                              .saleOrderDetail[
                                                          index][
                                                          "ProductName"],
                                                          style: customisedStyle(
                                                              context,
                                                              Colors
                                                                  .black,
                                                              FontWeight
                                                                  .w500,
                                                              15.0),
                                                          maxLines: 3,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                        )),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        paymentController.saleOrderDetail[
                                                        index]
                                                        [
                                                        "Description"] ==
                                                            ""
                                                            ? Container()
                                                            : Container(
                                                          width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                              .13,
                                                          child: Text(
                                                            paymentController
                                                                .saleOrderDetail[index]
                                                            [
                                                            "Description"],
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff8C8C8C),
                                                                FontWeight
                                                                    .w400,
                                                                11.0),
                                                          ),
                                                        ),
                                                        Text(
                                                          paymentController.saleOrderDetail[index]['Flavour_Name'] ==
                                                              '' ||
                                                              paymentController.saleOrderDetail[index]['Flavour_Name'] ==
                                                                  null
                                                              ? ""
                                                              : paymentController
                                                              .saleOrderDetail[index]
                                                          [
                                                          'Flavour_Name'],
                                                          style: customisedStyle(
                                                              context,
                                                              Color(
                                                                  0xffF25F29),
                                                              FontWeight
                                                                  .w400,
                                                              13.0),
                                                        ),
                                                        Container(

                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                            // crossAxisAlignment:
                                                            // CrossAxisAlignment
                                                            //     .center,
                                                            children: [

                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Qty :",
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Color(
                                                                            0xffA5A5A5),
                                                                        FontWeight
                                                                            .normal,
                                                                        10.0),
                                                                  ),
                                                                  Text(
                                                                    roundStringWith(paymentController
                                                                        .saleOrderDetail[
                                                                    index]
                                                                    [
                                                                    'Qty']
                                                                        .toString()),
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Colors
                                                                            .black,
                                                                        FontWeight
                                                                            .w500,
                                                                        12.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(width: 15,),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Unit Price :",
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Color(
                                                                            0xffA5A5A5),
                                                                        FontWeight
                                                                            .normal,
                                                                        10.0),
                                                                  ),
                                                                  Text(
                                                                    roundStringWith(paymentController
                                                                        .saleOrderDetail[
                                                                    index]
                                                                    [
                                                                    'UnitPrice']
                                                                        .toString()),
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Colors
                                                                            .black,
                                                                        FontWeight
                                                                            .w500,
                                                                        12.0),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(width: 15,),

                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Gross Amount :",
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Color(
                                                                            0xffA5A5A5),
                                                                        FontWeight
                                                                            .normal,
                                                                        10.0),
                                                                  ),
                                                                  Text(
                                                                    roundStringWith(paymentController
                                                                        .saleOrderDetail[
                                                                    index]
                                                                    [
                                                                    'GrossAmount']
                                                                        .toString()),
                                                                    style: customisedStyle(
                                                                        context,
                                                                        Colors
                                                                            .black,
                                                                        FontWeight
                                                                            .w500,
                                                                        12.0),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Discount ",
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xffA5A5A5),
                                                                  FontWeight
                                                                      .w400,
                                                                  13.0),
                                                            ),
                                                            Text(
                                                              paymentController
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
                                                              child: Text(
                                                                roundStringWith(paymentController
                                                                    .saleOrderDetail[
                                                                index]
                                                                [
                                                                "DiscountAmount"]
                                                                    .toString()),
                                                                style: customisedStyle(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500,
                                                                    15.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'NetTotal ',
                                                              style: customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xffA5A5A5),
                                                                  FontWeight
                                                                      .w400,
                                                                  13.0),
                                                            ),
                                                            Text(
                                                              paymentController
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
                                                              child: Text(
                                                                paymentController.saleOrderDetail[index]["NetAmount"] ==
                                                                    null
                                                                    ? "0.0"
                                                                    : roundStringWith(paymentController
                                                                    .saleOrderDetail[index]["NetAmount"]
                                                                    .toString()),
                                                                style: customisedStyle(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500,
                                                                    15.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),

                                                        //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Container(
                                              height:
                                              MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  8,
                                              width:
                                              MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  16,
                                              //  width: MediaQuery.of(context).size.width / 4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    10),
                                                // Set border radius to make the Container round
                                              ),
                                              child: Positioned.fill(
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(10),
                                                  // Clip image to match the rounded corners of the Container
                                                  child: Image.network(
                                                    'https://www.api.viknbooks.com/media/uploads/Group_5140.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )))),
                      Container(
                        height: MediaQuery.of(context).size.height * .15,
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
                            //       style: ButtonStyle(
                            //           backgroundColor: WidgetStateProperty.all(
                            //               const Color(0xffEEF5FF))),
                            //       onPressed: () {
                            //         orderController.changeStatus("take_away");
                            //         orderController.update();
                            //       },
                            //       child: Padding(
                            //         padding: const EdgeInsets.only(
                            //             left: 5.0, right: 5),
                            //         child: Text(
                            //           "TakeAway",
                            //           style: customisedStyle(
                            //               context,
                            //               const Color(0xff034FC1),
                            //               FontWeight.normal,
                            //               12.0),
                            //         ),
                            //       ),
                            //     ),
                            //     const SizedBox(
                            //       width: 7,
                            //     ),
                            //     TextButton(
                            //         style: ButtonStyle(
                            //             backgroundColor:
                            //                 WidgetStateProperty.all(
                            //                     const Color(0xffF0F0F0))),
                            //         onPressed: () {
                            //           orderController.changeStatus("delivered");
                            //           orderController.update();
                            //         },
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 5.0, right: 5),
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
                            //   ],
                            // ),
                            // const SizedBox(
                            //   height: 9,
                            // ),

                            Container(
                              height: 1,
                              color: const Color(0xffE9E9E9),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10.0),
                              child: Obx(
                                () => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        'to_be_paid'.tr,
                                        style: customisedStyle(
                                            context,
                                            const Color(0xff9E9E9E),
                                            FontWeight.w400,
                                            17.0),
                                      ),
                                    ),
                                    Text(
                                      paymentController.currency.value,
                                      style: customisedStyle(
                                          context,
                                          const Color(0xff000000),
                                          FontWeight.w400,
                                          16.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: Text(
                                        roundStringWith(paymentController
                                            .grandTotalAmount
                                            .toString()),
                                        style: customisedStyle(
                                            context,
                                            const Color(0xff000000),
                                            FontWeight.w500,
                                            18.0),
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
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  const Color(0xffDF1515))),
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/svg/close-circle.svg"),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5),
                                            child: Text(
                                              'cancel'.tr,
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
                                              WidgetStateProperty.all(
                                                  const Color(0xff00775E))),
                                      onPressed: () {
                                        if (double.parse(paymentController
                                                .grandTotalAmount.value) >
                                            0) {
                                          if (paymentController
                                                  .paymentCustomerSelection
                                                  .text !=
                                              "walk in customer") {
                                            paymentController.createSaleInvoice(
                                                orderType: widget.orderType,
                                                context: context,
                                                tableID: widget.tableID,
                                                uUID: widget.uID,
                                                printSave: false);
                                          } else {
                                            if ((paymentController
                                                        .cashReceived.value +
                                                    paymentController
                                                        .bankReceived.value) >=
                                                double.parse(paymentController
                                                    .grandTotalAmount.value)) {
                                              paymentController
                                                  .createSaleInvoice(
                                                      orderType:
                                                          widget.orderType,
                                                      context: context,
                                                      tableID: widget.tableID,
                                                      uUID: widget.uID,
                                                      printSave: false);
                                            } else {
                                              popAlert(
                                                  head: "Waring",
                                                  message:
                                                      "You cant make credit sale",
                                                  position: SnackPosition.TOP);
                                            }
                                          }
                                        } else {
                                          popAlert(
                                              head: "Waring",
                                              message:
                                                  "You cant make this sale ..Please check Grand Total",
                                              position: SnackPosition.TOP);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                              'assets/svg/payment_mob.svg'),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, right: 5),
                                            child: Text(
                                              'payment'.tr,
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
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
