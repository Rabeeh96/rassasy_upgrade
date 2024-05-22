import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  POSController orderController = Get.put(POSController());
  var selectedItem = '';
  final ValueNotifier<int> _counter = ValueNotifier<int>(1);

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
        title: const Text(
          'Payment',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(child: Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xffE6E6E6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Customer",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Text(
                            "Savad",
                            style: customisedStyle(context, const Color(0xff000000),
                                FontWeight.w500, 15.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PhoneNo",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Text(
                            "988667888",
                            style: customisedStyle(context, const Color(0xff000000),
                                FontWeight.w500, 15.0),
                          ),
                          const Text(
                            "",
                          ),
                        ]),
                  ),
                  DividerStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Balance",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  orderController.currency,
                                  style: customisedStyle(context,
                                      const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                ),
                              ),
                              Text(
                                "6.00",
                                style: customisedStyle(context,
                                    const Color(0xff000000), FontWeight.w500, 16.0),
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
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xffE6E6E6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Deliveryman",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Text(
                            "Savad",
                            style: customisedStyle(context, const Color(0xff000000),
                                FontWeight.w500, 15.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Platform",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Text(
                            "Zomato(online)",
                            style: customisedStyle(context, const Color(0xff000000),
                                FontWeight.w500, 15.0),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                            size: 15,
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: const Color(0xffE6E6E6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "To be Paid",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  orderController.currency,
                                  style: customisedStyle(context,
                                      const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                ),
                              ),
                              Text(
                                "6.00",
                                style: customisedStyle(context,
                                    const Color(0xff000000), FontWeight.w500, 16.0),
                              ),
                            ],
                          ),

                        ]),
                  ),
                  DividerStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Tax",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  orderController.currency,
                                  style: customisedStyle(context,
                                      const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                ),
                              ),
                              Text(
                                "6.00",
                                style: customisedStyle(context,
                                    const Color(0xff000000), FontWeight.w500, 16.0),
                              ),
                            ],
                          ),

                        ]),
                  ),
                  DividerStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Net Total",
                            style: customisedStyle(context, const Color(0xff8C8C8C),
                                FontWeight.w400, 14.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  orderController.currency,
                                  style: customisedStyle(context,
                                      const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                ),
                              ),
                              Text(
                                "6.00",
                                style: customisedStyle(context,
                                    const Color(0xff000000), FontWeight.w500, 16.0),
                              ),
                            ],
                          ),

                        ]),
                  ),
                  DividerStyle(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grand Total",
                            style: customisedStyle(context, const Color(0xff000000),
                                FontWeight.w400, 14.0),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  orderController.currency,
                                  style: customisedStyle(context,
                                      const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                ),
                              ),
                              Text(
                                "6.00",
                                style: customisedStyle(context,
                                    const Color(0xff000000), FontWeight.w500, 16.0),
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
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: Color(0xffE6E6E6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                "Cash",
                                style: customisedStyle(context, Color(0xff000000),
                                    FontWeight.w500, 15.0),
                              ),

                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.5,

                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  // controller: tokenController,
                                  style: customisedStyle(
                                      context, Colors.black, FontWeight.w500, 14.0),
                                  // focusNode: diningController.customerNode,
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: TextFieldDecoration.defaultTextField(
                                      hintTextStr:"Amount"),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/4,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(const Color(0xff10C103))),
                                onPressed: () {},
                                child:          Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                                  child: Text(
                                    "Full",
                                    style: customisedStyle(
                                        context,
                                        const Color(0xffffffff),
                                        FontWeight.normal,
                                        12.0),
                                  ),
                                ),),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        DividerStyle(),
                        SizedBox(height: 8,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                "Bank",
                                style: customisedStyle(context, Color(0xff000000),
                                    FontWeight.w500, 15.0),
                              ),

                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.5,

                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  // controller: tokenController,
                                  style: customisedStyle(
                                      context, Colors.black, FontWeight.w500, 14.0),
                                  // focusNode: diningController.customerNode,
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: TextFieldDecoration.defaultTextField(
                                      hintTextStr:"Amount"),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width/4,
                              child: TextButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all(const Color(0xff10C103))),
                                onPressed: () {},
                                child:          Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                                  child: Text(
                                    "Full",
                                    style: customisedStyle(
                                        context,
                                        const Color(0xffffffff),
                                        FontWeight.normal,
                                        12.0),
                                  ),
                                ),),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: Color(0xffE6E6E6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text(
                                "Discount",
                                style: customisedStyle(context, Color(0xff000000),
                                    FontWeight.w500, 15.0),
                              ),

                            ]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.5,

                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  // controller: tokenController,
                                  style: customisedStyle(
                                      context, Colors.black, FontWeight.w500, 14.0),
                                  // focusNode: diningController.customerNode,
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: TextFieldDecoration.defaultTextField(
                                      hintTextStr:"Amount"),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width/2.5,

                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
                                  // controller: tokenController,
                                  style: customisedStyle(
                                      context, Colors.black, FontWeight.w500, 14.0),
                                  // focusNode: diningController.customerNode,
                                  onEditingComplete: () {
                                    FocusScope.of(context)
                                        .requestFocus();
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: TextFieldDecoration.defaultTextField(
                                      hintTextStr:""),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),


                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),),
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
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xffDF1515))),
                    onPressed: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/close-circle.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
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
                  width: 10,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff10C103))),
                    onPressed: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/save_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
