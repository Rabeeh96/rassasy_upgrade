import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/order/order_detail_page.dart';
import 'package:popover/popover.dart';

import 'product_detail_page.dart';
import 'search_items.dart';

class OrderCreatePage extends StatefulWidget {
  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage> {
  OrderController orderController = Get.put(OrderController());
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
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 16.0),
                        ),
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: orderController.isVegNotifier,
                        builder: (context, isVegValue, child) {
                          return GestureDetector(
                            onTap: () {
                              orderController. isVegNotifier.value = !isVegValue; // Toggle the value
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
                                      color: isVegValue
                                          ? const Color(0xff00775E)
                                          : const Color(0xffDF1515),
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 8, top: 8),
                child: Text("Shwarma"),
              ),
            ],
          ),

          //   diningController.selectedIndexNotifier.value =
          // index;
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: orderController.selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        orderController.selectedIndexNotifier.value = index;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 20,
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
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ProductDetailPage(
                                      image:
                                          'https://picsum.photos/250?image=9',
                                      name: "Shwarama plate Mexican",
                                      isColor: orderController.isVegNotifier.value,
                                      total: '909.00',
                                    ));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/veg_mob.svg",
                                        color:
                                            orderController.isVegNotifier.value == true
                                                ? const Color(0xff00775E)
                                                : const Color(0xffDF1515),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, top: 8),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
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
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              orderController.currency,
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xffA5A5A5),
                                                  FontWeight.w400,
                                                  13.0),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                "909.00",
                                                style: customisedStyle(
                                                    context,
                                                    Colors.black,
                                                    FontWeight.w400,
                                                    15.0),
                                              ),
                                            ),
                                            //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Check if the current index is the selected index and the additem is true
                                if (selectedIndex == index &&
                                    orderController.isAddItem.value)
                                  Container(
                                    height: MediaQuery.of(context).size.height /
                                        8.5,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // Set border radius to make the Container round
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            // Clip image to match the rounded corners of the Container
                                            child: Image.network(
                                              'https://picsum.photos/250?image=9',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            decoration: const BoxDecoration(
                                              color: Color(0xffF25F29),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                // Match the bottom left and right corners of the Container
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: ValueListenableBuilder(
                                              valueListenable: _counter,
                                              builder:
                                                  (context, int value, child) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0, right: 3),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (value > 1) {
                                                            _counter.value--;
                                                          }
                                                        },
                                                        child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text(
                                                        '$value',
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          _counter.value++;
                                                        },
                                                        child: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                else
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      Container(
                                        height: MediaQuery.of(context).size.height / 9,
                                        width: MediaQuery.of(context).size.width / 4,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                'https://picsum.photos/250?image=9',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            // Other widgets inside the container, if any
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 70,

                                        child: GestureDetector(
                                          onTap: () {
                                            print("gjhdfghdf");
                                            orderController.isAddItem.value = true;
                                            orderController.isOrderCreate.value = true;
                                          },
                                          child: SizedBox(
                                            height: MediaQuery.of(context).size.height / 30,
                                            width: MediaQuery.of(context).size.width / 6,
                                            child: DecoratedBox(
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(color: Color(0xffF25F29)),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Add',
                                                  style: TextStyle(
                                                    color: Color(0xffF25F29),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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
      bottomNavigationBar: SizedBox(
        height:orderController.isOrderCreate.value==true?MediaQuery.of(context).size.height /5.9 :MediaQuery.of(context).size.height / 11,
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
                    Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height / 25,
                      width: MediaQuery.of(context).size.height / 3.5,
                      child: ValueListenableBuilder<int>(
                        valueListenable: orderController.selectedIndexNotifier,
                        builder: (context, selectedIndex, child) {
                          return Obx(() =>

                          orderController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : orderController.flavourList.isEmpty
                              ? Center(child: const Text("Flavours Not Found!"))
                              :

                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orderController.flavourList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  orderController.selectedIndexNotifier.value =
                                      index; // Update the selected index
                                },
                                child: Container(
                                  /// width: MediaQuery.of(context).size.width / 5,
                                  decoration: BoxDecoration(
                                    color: selectedIndex == index
                                        ? const Color(0xffF5F5F5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12.0, right: 12),
                                      child: Text(
                                        orderController.flavourList[index].flavourName,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ));
                        },
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          print("here ebte");
                          showPopover(

                            context: context,
                            bodyBuilder: (context) =>  ListItems(),
                            onPop: () => print('Popover was popped! here'),
                            direction: PopoverDirection.top,
                            width: 200,
                            height: 400,
                            arrowHeight: 15,
                            arrowWidth: 30,
                          );
                          print("here ");

                        },
                        child: SvgPicture.asset("assets/svg/menu_mob.svg")
                    )
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
            // orderController.isItemAdded.value==true?GestureDetector(
            //   onTap: () {
            //     Get.to(OrderDetailPage());
            //   },
            //   child: Container(
            //     height: MediaQuery.of(context).size.height / 12,
            //     decoration: const BoxDecoration(color: Color(0xff00775E)),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(left: 8.0, right: 8),
            //           child: Text(
            //             '2 Items Added',
            //             style: customisedStyle(context, const Color(0xffFfffff),
            //                 FontWeight.normal, 16.0),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(left: 8.0, right: 8),
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 '${orderController.currency} ',
            //                 style: customisedStyle(context,
            //                     const Color(0xffFfffff), FontWeight.w500, 16.0),
            //               ),
            //               Text(
            //                 '18.00',
            //                 style: customisedStyle(context,
            //                     const Color(0xffFfffff), FontWeight.w500, 18.0),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ):Container()
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
                          context, Color(0xff8C8C8C), FontWeight.w400, 14.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      orderController.currency,
                      style: customisedStyle(
                          context, Color(0xff8C8C8C), FontWeight.w400, 15.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text("00.0",
                        style: customisedStyle(
                            context, Color(0xff000000), FontWeight.w500, 15.0)),
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