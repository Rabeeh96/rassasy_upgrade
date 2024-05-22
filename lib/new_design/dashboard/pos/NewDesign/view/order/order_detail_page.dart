import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/payment/payment_page.dart';

import 'product_detail_page.dart';
import 'search_items.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  POSController orderController = Get.put(POSController());
  var selectedItem = '';
  final ValueNotifier<int> _counter = ValueNotifier<int>(1);
  Color _getBackgroundColor(String? status) {
    if (status == 'Pending') {
      return Color(0xffECAC08); // Set your desired color for pending status
    } else if (status == 'Delivered') {
      return Color(0xff000000); // Set your desired color for completed status
    } else if (status == 'Takeaway') {
      return Color(0xff034FC1); // Set your desired color for cancelled status
    } else {
      return Color(0xffECAC08); // Default color if status is not recognized
    }
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Table Order',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Table Order',
                  style: TextStyle(
                      color: Color(0xff585858),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Token No',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
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
          SearchFieldWidgetNew(
            autoFocus: false,
            mHeight: MediaQuery.of(context).size.height / 18,
            hintText: 'Search',
            controller: orderController.searchController,
            onChanged: (quary) async {},
          ),
          DividerStyle(),


          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: orderController.selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return ListView.builder(
                  itemCount:5,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        orderController.selectedIndexNotifier.value = index;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                          right:5,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle,color: Color(0xffF25F29),),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ProductDetailPage(
                                      image:
                                          'https://picsum.photos/250?image=9',
                                      name: "Shwarama plate Mexican",
                                      isColor: orderController.isVeg.value,
                                      total: '909.00',
                                    ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/svg/veg_mob.svg",
                                            color:
                                            orderController.isVeg.value == true
                                                ? const Color(0xff00775E)
                                                : const Color(0xffDF1515),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0, top: 8),
                                            child: Container(

                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: Text(
                                                "Shwarama plate Mexican",
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0,right: 5),
                                              child: Text(
                                                "Extra spicy",
                                                style: customisedStyle(
                                                    context,
                                                    Color(0xffF25F29),
                                                    FontWeight.w400,
                                                    13.0),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {

                                              },
                                              child: Container(
                                                height: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height /
                                                    32,
                                                decoration:
                                                BoxDecoration(
                                                  color: _getBackgroundColor(
                                                      'Delivery'),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(30),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        left: 10.0,
                                                        right: 10),
                                                    child: Text(
                                                     "Delivery",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                        color: Colors.white
                                                          ),
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
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          orderController.currency,
                                          style: customisedStyle(
                                              context, const Color(0xffA5A5A5), FontWeight.w400, 14.0),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            " 0.00",
                                            style: customisedStyle(
                                                context, const Color(0xff000000), FontWeight.w500, 16.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                      valueListenable: _counter,
                                      builder: (context, int value, child) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            IconButton(
                                              icon: SvgPicture.asset("assets/svg/minus_mob.svg"),

                                              onPressed: () {
                                                if (value > 1) {
                                                  _counter.value--;
                                                }
                                              },
                                            ),
                                            Container(
                                              height: MediaQuery.of(context).size.height/21,
                                              width: MediaQuery.of(context).size.width/7,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  border: Border.all(color: Color(0xffE7E7E7))
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$value',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: SvgPicture.asset("assets/svg/plus_mob.svg"),


                                              onPressed: () {
                                                _counter.value++;
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            DividerStyle()
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),


        ],
      ),
      bottomNavigationBar: Container(

        height: MediaQuery.of(context).size.height / 5,
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
                        MaterialStateProperty.all(const Color(0xffEEF5FF))),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Text(
                        "TakeAway",
                        style: customisedStyle(
                            context,
                            const Color(0xff034FC1),
                            FontWeight.normal,
                            12.0),
                      ),
                    ),),
                const SizedBox(
                  width: 7,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xffF0F0F0))),
                    onPressed: () {},
                    child:  Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Text(
                        'Delivered',
                        style: customisedStyle(
                            context,
                            const Color(0xff000000),
                            FontWeight.normal,
                            12.0),
                      ),
                    )),
                const SizedBox(
                  width: 7,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xffFFF6F2))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.add,color: Color(0xffF25F29),),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5),
                          child: Text(
                            'Items',
                            style: customisedStyle(
                                context,
                                const Color(0xffF25F29),
                                FontWeight.normal,
                                12.0),
                          ),
                        )
                      ],
                    )),
              ],
            ),
            const SizedBox(
              height: 9,
            ),
            Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "To be paid",
                    style: customisedStyle(
                        context, const Color(0xff9E9E9E), FontWeight.w400, 17.0),
                  ),
                ),
                Text(
                  orderController.currency,
                  style: customisedStyle(
                      context, const Color(0xff000000), FontWeight.w400, 16.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: Text(
                    " 0.00",
                    style: customisedStyle(
                        context, const Color(0xff000000), FontWeight.w500, 18.0),
                  ),
                ),
              ],
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
                    onPressed: () {},
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
                    onPressed: () {},
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
                      Get.to(PaymentPage());
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
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.customerNameController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextField(
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
                      style: customisedStyle(
                          context, const Color(0xff8C8C8C), FontWeight.w400, 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      orderController.currency,
                      style: customisedStyle(
                          context, const Color(0xff8C8C8C), FontWeight.w400, 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("00.0",
                        style: customisedStyle(
                            context, const Color(0xff000000), FontWeight.w500, 15.0)),
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
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
                    keyboardType: TextInputType.text,
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
                    textCapitalization: TextCapitalization.words,
                    controller: orderController.deliveryManController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
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
                    controller: orderController.platformController,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus();
                    },
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
