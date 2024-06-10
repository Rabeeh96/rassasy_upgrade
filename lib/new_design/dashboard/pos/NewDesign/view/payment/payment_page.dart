import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/payment_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/select_deliveryman.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentPage extends StatefulWidget {
  final String uID, tableID;
  final int orderType;

  const PaymentPage({super.key, required this.uID, required this.tableID, required this.orderType});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
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
        title: Text(
          'payment'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                paymentController.getOrderDetails(uID: widget.uID);
              },
              child: Text("Retry"))
        ],
      ),
      body: SingleChildScrollView(
          child: Obx(() => paymentController.detailLoading.value
              ? Container(height: 500, child: const Center(child: CircularProgressIndicator()))
              : Column(
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
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xffE6E6E6))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(
                                    'customer'.tr,
                                    style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                  ),
                                  Text(
                                    paymentController.paymentCustomerSelection.text ?? "",
                                    style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 15,
                                  )
                                ]),
                              ),
                              DividerStyle(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(
                                    'ph_no'.tr,
                                    style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                  ),
                                  Text(
                                    paymentController.customerPhoneSelection.text ?? "",
                                    style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                  ),

                                  Text(
                                    "",
                                    style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                  ),
                                  // const Icon(
                                  //   Icons.arrow_forward_ios,
                                  //   color: Colors.black,
                                  //   size: 15,
                                  // )
                                  //


                                ]),
                              ),
                              DividerStyle(),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(
                                    'balance1'.tr,
                                    style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          paymentController.currency,
                                          style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                                        ),
                                      ),
                                      Text(
                                        roundStringWith(paymentController.balance.toString()),
                                        style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xffE6E6E6))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final result = await Get.to(SelectDeliveryMan());
                                if (result != null) {
                                  paymentController.deliveryManName.value = result[0];
                                  paymentController.deliveryManID.value = result[1];
                                  paymentController.update();
                                }
                              },
                              child: InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      'Deliveryman'.tr,
                                      style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                    ),
                                    Text(
                                      paymentController.deliveryManName.value,
                                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 15,
                                    )
                                  ]),
                                ),
                              ),
                            ),

                            ///platform
                            // DividerStyle(),
                            // Padding(
                            //   padding: const EdgeInsets.all(12.0),
                            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            //     Text(
                            //       'Platform'.tr,
                            //       style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                            //     ),
                            //     Text(
                            //       "Zomato(online)",
                            //       style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0),
                            //     ),
                            //     const Icon(
                            //       Icons.arrow_forward_ios,
                            //       color: Colors.black,
                            //       size: 15,
                            //     )
                            //   ]),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: Color(0xffE6E6E6))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      'Discount'.tr,
                                      style: customisedStyle(context, Color(0xff000000), FontWeight.w500, 15.0),
                                    ),
                                  ]),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 18.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          child: TextField(
                                            textCapitalization: TextCapitalization.words,
                                            controller: paymentController.discountAmountController,
                                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                            // focusNode: diningController.customerNode,
                                            onEditingComplete: () {
                                              FocusScope.of(context).requestFocus();
                                            },
                                            keyboardType: TextInputType.text,
                                            decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'amount'.tr),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 18.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width / 2.5,
                                          child: TextField(
                                            textCapitalization: TextCapitalization.words,
                                            controller: paymentController.discountPerController,

                                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                            // focusNode: diningController.customerNode,
                                            onEditingComplete: () {
                                              FocusScope.of(context).requestFocus();
                                            },
                                            keyboardType: TextInputType.text,
                                            decoration: TextFieldDecoration.defaultTextField(hintTextStr: ""),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xffE6E6E6))),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(
                              'gross_amount'.tr,
                              style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    paymentController.currency,
                                    style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                                  ),
                                ),
                                Text(
                                  roundStringWith(paymentController.totalGrossP.value.toString()),
                                  style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: const Color(0xffE6E6E6))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// to be paid commented
                            // Padding(
                            //   padding: const EdgeInsets.all(12.0),
                            //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            //     Text(
                            //       'to_be_paid'.tr,
                            //       style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                            //     ),
                            //     Row(
                            //       children: [
                            //         Padding(
                            //           padding: const EdgeInsets.only(right: 8.0),
                            //           child: Text(
                            //             paymentController.currency,
                            //             style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                            //           ),
                            //         ),
                            //         Text(
                            //           roundStringWith(paymentController.grandTotalAmount.value),
                            //           style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                            //         ),
                            //       ],
                            //     ),
                            //   ]),
                            // ),
                            // DividerStyle(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  'total_tax'.tr,
                                  style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        paymentController.currency,
                                        style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                                      ),
                                    ),
                                    Text(
                                      roundStringWith(paymentController.totalTaxMP.value),
                                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            DividerStyle(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  'net_total'.tr,
                                  style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 16.0),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        paymentController.currency,
                                        style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                                      ),
                                    ),
                                    Text(
                                      roundStringWith(paymentController.totalNetP.value),
                                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 18.0),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            DividerStyle(),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Text(
                                  'grand_total'.tr,
                                  style: customisedStyle(context, const Color(0xff000000), FontWeight.w600, 16.5),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        paymentController.currency,
                                        style: customisedStyle(context, const Color(0xff8C8C8C), FontWeight.w400, 18.0),
                                      ),
                                    ),
                                    Text(
                                      roundStringWith(paymentController.grandTotalAmount.value),
                                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w600, 18.0),
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all(color: Color(0xffE6E6E6))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      'cash'.tr,
                                      style: customisedStyle(context, Color(0xff000000), FontWeight.w500, 16.5),
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: TextField(
                                            controller: paymentController.cashReceivedController,
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                            ],
                                            onChanged: (val) {
                                              if (val.isEmpty) {
                                                val = "0";
                                              } else {
                                                paymentController.calculationOnPayment();
                                              }
                                            },
                                            textCapitalization: TextCapitalization.words,

                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 18.0),
                                            // focusNode: diningController.customerNode,
                                            // onEditingComplete: () {
                                            //   FocusScope.of(context).requestFocus();
                                            // },
                                            onTap: () => paymentController.cashReceivedController.selection = TextSelection(
                                                baseOffset: 0, extentOffset: paymentController.cashReceivedController.value.text.length),

                                            decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'amount'.tr),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: TextButton(
                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff10C103))),
                                            onPressed: () {
                                              paymentController.bankReceivedController.text = roundStringWith("0");
                                              paymentController.cashReceivedController.text =
                                                  roundStringWith(paymentController.grandTotalAmount.value.toString());
                                              paymentController.calculationOnPayment();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 12.0, right: 12),
                                              child: Text(
                                                'Full'.tr,
                                                style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 16.5),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  DividerStyle(),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      'bank'.tr,
                                      style: customisedStyle(context, Color(0xff000000), FontWeight.w500, 16.5),
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: TextField(
                                            textCapitalization: TextCapitalization.words,
                                            controller: paymentController.bankReceivedController,
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 18.0),
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                            ],
                                            onChanged: (val) {
                                              if (val.isEmpty) {
                                              } else {
                                                paymentController.calculationOnPayment();
                                              }
                                            },
                                            onEditingComplete: () {
                                              FocusScope.of(context).requestFocus();
                                            },
                                            onTap: () => paymentController.bankReceivedController.selection = TextSelection(
                                                baseOffset: 0, extentOffset: paymentController.bankReceivedController.value.text.length),
                                            decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'amount'.tr),
                                          ),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: TextButton(
                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff10C103))),
                                            onPressed: () {
                                              paymentController.cashReceivedController.text = roundStringWith("0");
                                              paymentController.bankReceivedController.text =
                                                  roundStringWith(paymentController.grandTotalAmount.value.toString());
                                              paymentController.calculationOnPayment();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 12.0, right: 12),
                                              child: Text(
                                                'Full'.tr,
                                                style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 16.5),
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
                ))),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
        ),
        height: MediaQuery.of(context).size.height / 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffDF1515))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/close-circle.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Text(
                            'cancel'.tr,
                            style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff10C103))),
                    onPressed: () async {

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var id = prefs.getInt("Cash_Account") ?? 1;


                      if (paymentController.ledgerID.value != id) {

                        paymentController.createSaleInvoice(orderType: widget.orderType, context: context, tableID: widget.tableID, uUID: widget.uID, printSave: false);
                      } else {
                        if ((paymentController.cashReceived.value + paymentController.bankReceived.value) >=
                            double.parse(paymentController.grandTotalAmount.value)) {
                          paymentController.createSaleInvoice(
                              orderType: widget.orderType, context: context, tableID: widget.tableID, uUID: widget.uID, printSave: false);
                        } else {
                          popAlert(head: "Waring", message: "You cant make credit sale", position: SnackPosition.TOP);
                        }
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/save_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            'Save'.tr,
                            style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                          ),
                        )
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
