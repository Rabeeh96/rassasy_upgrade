import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/tab_design/tab_pos_payment_section.dart';

import '../../../../../../global/textfield_decoration.dart';
import '../../../../../../test/dragable.dart';
import '../../../new_method/pos_list_section.dart';
import '../../controller/pos_controller.dart';
import '../../controller/tab_controller.dart';
import '../detail_page/cancel_reason_list.dart';
import '../detail_page/reservation_list.dart';
import 'draggable_list.dart';
import 'tab_pos_order_page.dart';

///image size not correct ,in bottom sheet cancel order and print
///index
class TabPosListDesign extends StatefulWidget {
  @override
  State<TabPosListDesign> createState() => _TabPosListDesignState();
}

class _TabPosListDesignState extends State<TabPosListDesign> {
  final IconController controller = Get.put(IconController());
//  final POSController diningController = Get.put(POSController());
  final POSController posController = Get.put(POSController());
  // final POSController takeAwayController = Get.put(POSController());
  // final POSController carController = Get.put(POSController());

  Color _getBackgroundColor(String? status) {
    if (status == 'Vacant') {
      return const Color(
          0xff6C757D); // Set your desired color for pending status
    } else if (status == 'Ordered') {
      return const Color(
          0xff03C1C1); // Set your desired color for completed status
    } else if (status == 'Paid') {
      return const Color(
          0xff2B952E); // Set your desired color for cancelled status
    } else if (status == 'Billed') {
      return const Color(
          0xff034FC1); // Set your desired color for cancelled status
    } else {
      return const Color(
          0xffEFEFEF); // Default color if status is not recognized
    }
  }

  var list = ['one', 'two', 'three', 'four', 'five'];

  @override
  void initState() {
    /// TODO: implement initState
    super.initState();
    posController.selectedIndexNotifier.value = 0;
    posController.tableData.clear();
    posController.fetchAllData();
    posController.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
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
        title: Text(
          "Table",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
        ),
        actions: [
          IconButton(
              onPressed: () async{

                var result = await Get.to(DragTableList());
                posController.tableData.clear();
                posController.fetchAllData();
                posController.update();
              },
              icon:Text("Table Setting")),


        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE9E9E9)))),
        child: Row(
          children: [
            Flexible(
              flex: 20,
              child: Obx(() {
                // Switch between different widgets based on selectedType
                switch (controller.selectedType.value) {
                  case 'dine':
                    return fetchDiningList();
                  case 'takeout':
                    return fetchTakeAway();
                  case 'online':
                    return CustomScrollView(slivers: <Widget>[
                      SliverAppBar(
                        floating: true,
                        toolbarHeight: MediaQuery.of(context).size.height / 30,
                        pinned: true,
                        leading: const SizedBox.shrink(),
                      ),
                      SliverToBoxAdapter(
                          child: Container(
                              margin:
                                  const EdgeInsets.only(left: 25, right: 25),
                              height: MediaQuery.of(context).size.height *
                                  .77, // Adjust height as needed
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 20,
                                  childAspectRatio: 2.0,
                                ),
                                itemCount: list.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == list.length) {
                                    // Special item (e.g., Add Orders button)
                                    return DottedBorder(
                                      color: const Color(0xffC2C8D0),
                                      strokeWidth: 2,
                                      dashPattern: [8, 4],
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(12),
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {

                                          },
                                          child: const Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.add_circle_outlined,
                                                  color: Color(0xff596474),
                                                  size: 30,
                                                ),
                                                Text(
                                                  'Add Orders',
                                                  style: TextStyle(
                                                    color: Color(0xff000000),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15.0,
                                                  ),
                                                ),
                                                Text(
                                                  'Add more items to your order',
                                                  style: TextStyle(
                                                    color: Color(0xff808080),
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  // Regular item
                                  return Obx(() {
                                    return Opacity(
                                      opacity: controller.selectedIndex.value ==
                                              index
                                          ? 1
                                          : controller.selectedIndex.value ==
                                                  1000
                                              ? 1
                                              : 0.30,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectItem(index);
                                          // Open bottom sheet
                                          showCustomDialog(context: context, type: '', salesOrderID: '', orderID: '', salesMasterID: '');
                                        },
                                        child: Obx(() {
                                          // Update item appearance based on selectedIndex
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: controller.selectedIndex
                                                          .value ==
                                                      index
                                                  ? Colors
                                                      .white // Highlight selected item
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                  color: Colors.grey, width: 1),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: GridTile(
                                                footer: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: TextButton(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all<Color>(
                                                        controller.selectedIndex
                                                                    .value ==
                                                                index
                                                            ? Colors.red
                                                            : Colors.grey,
                                                      ),
                                                      shape:
                                                      WidgetStateProperty
                                                              .all(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                      ),
                                                    ),
                                                    child: const Text(
                                                      "Ordered",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                header: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Table ${list[index]}",
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                      const Text(
                                                        "12 min ago",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff828282),
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "To be paid:",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff757575),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        "RS .1323",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  });
                                },
                              )))
                    ]);
                  case 'car':
                    return fetchCarList();

                  default:
                    return const Center(
                      child: Text('Select a type'),
                    );
                }
              }),
            ),
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Color(0xffE9E9E9), width: 1)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconWithText(
                      assetName: 'assets/svg/dine.svg',
                      text: 'Dine',
                      type: 'dine', // Unique identifier for this type
                      onPressed: () {


                      },
                    ),
                    const SizedBox(height: 10),
                    IconWithText(
                      assetName: 'assets/svg/takeout_dining.svg',
                      text: 'Takeout',
                      type: 'takeout', // Unique identifier for this type
                      onPressed: () {

                      },
                    ),
                    const SizedBox(height: 10),
                    ///online commented here
                    // IconWithText(
                    //   assetName: 'assets/svg/online_img.svg',
                    //   text: 'Online',
                    //   type: 'online', // Unique identifier for this type
                    //   onPressed: () {
                    //     print('Online icon pressed');
                    //     // Add your onPressed logic here
                    //   },
                    // ),
                    // const SizedBox(height: 10),
                    IconWithText(
                      assetName: 'assets/svg/car_inmgs.svg',
                      text: 'Car',
                      type: 'car', // Unique identifier for this type
                      onPressed: () {

                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget fetchDiningList() {
    return CustomScrollView(
      slivers: <Widget>[
        ///dining list
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25, top: 20),

            height: MediaQuery.of(context).size.height *
                .73, // Specify your desired height here
            child: Obx(() => posController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffffab00),
                  ))
                : posController.tableData.isEmpty
                    ? Center(
                        child: Text(
                        "No recent orders",
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w400, 18.0),
                      ))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 20,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: posController.tableData.length + 1,
                        itemBuilder: (context, index) {
                          if (index == posController.tableData.length) {
                            return Container();
                          }
                          return GestureDetector(
                              onTap: () async {
                                controller.selectItem(index);
                                if(posController.tableData[index].status=='Vacant'){
                                  var result = await Get.to(TabPosOrderPage(
                                    orderType: 1,
                                    sectionType: "Create",
                                    uID: "",
                                    tableHead: "Order",
                                    cancelOrder: posController.cancelOrder,
                                    tableID: posController.tableData[index].id!,
                                  ));

                                  if (result != null) {
                                    if (result[1]) {
                                      var resultPayment = await Get.to(TabPaymentSection(
                                        uID: result[2],
                                        tableID: posController.tableData[index].id!,
                                        orderType: 0,
                                      ));
                                      posController.tableData.clear();
                                      posController.fetchAllData();
                                      posController.update();
                                    } else {
                                      posController.tableData.clear();
                                      posController.fetchAllData();
                                      posController.update();
                                    }
                                  }
                                  else{

                                    posController.tableData.clear();
                                    posController.fetchAllData();
                                    posController.update();
                                  }



                                }else{
                                  showCustomDialog(context: context, type: posController
                                      .tableData[index].status!, salesOrderID: posController
                                      .tableData[index].salesOrderID!, orderID: posController
                                      .tableData[index].id!,salesMasterID: posController.tableData[index].salesMasterID!);

                                }


                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.selectedIndex.value ==
                                            index
                                        ? Colors
                                            .white // Highlight selected item
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              color: _getBackgroundColor(
                                                  posController
                                                      .tableData[index].status),
                                              width: 4,
                                            ),
                                            right: const BorderSide(
                                                color: Color(0xffE9E9E9),
                                                width: 1),
                                            bottom: const BorderSide(
                                                color: Color(0xffE9E9E9),
                                                width: 1),
                                            top: const BorderSide(
                                                color: Color(0xffE9E9E9),
                                                width: 1),
                                          ),
                                        ),
                                        child: GridTile(
                                          footer: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: (_getBackgroundColor(
                                                      posController
                                                          .tableData[index]
                                                          .status))),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    posController
                                                        .tableData[index]
                                                        .status!,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          header: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  posController
                                                      .tableData[index].title!,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                                posController
                                                            .returnOrderTime(
                                                                posController
                                                                    .tableData[
                                                                        index]
                                                                    .orderTime!,
                                                                posController
                                                                    .tableData[
                                                                        index]
                                                                    .status!) !=
                                                        ""
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            posController.returnOrderTime(
                                                                posController
                                                                    .tableData[
                                                                        index]
                                                                    .orderTime!,
                                                                posController
                                                                    .tableData[
                                                                        index]
                                                                    .status!),
                                                            style: customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff828282),
                                                                FontWeight.w400,
                                                                12.0),
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                posController
                                                            .tableData[index]
                                                            .status ==
                                                        "Vacant"
                                                    ? const Text("")
                                                    : const Text(
                                                        "To be paid:",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff757575),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                posController
                                                            .tableData[index]
                                                            .status ==
                                                        "Vacant"
                                                    ? const Text("")
                                                    : Text(
                                                        "${posController.currency} ${roundStringWith(posController.tableData[index].status != "Vacant" ? posController.tableData[index].status != "Paid" ? posController.tableData[index].salesOrderGrandTotal.toString() : posController.tableData[index].salesGrandTotal.toString() : '0')}",
                                                        style: customisedStyle(
                                                            context,
                                                            Colors.black,
                                                            FontWeight.w500,
                                                            15.0),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))));
                        },
                      )),
          ),
        ),

        ///footer section of buttons reservation and add table
        SliverToBoxAdapter(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .13,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0xffE9E9E9)))),
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xffFFF6F2))),
                      onPressed: () {
                        addTable();
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add,
                            color: Color(0xffF25F29),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text(
                              'Add_Table'.tr,
                              style: customisedStyle(
                                  context,
                                  const Color(0xffF25F29),
                                  FontWeight.w500,
                                  14.0),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(const Color(0xffEFF6F5))),
                      onPressed: () {
                        if (posController.reservation_perm.value) {
                          Get.to(ReservationPage());
                        } else {
                          dialogBoxPermissionDenied(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Text(
                          'Reservations'.tr,
                          style: customisedStyle(context,
                              const Color(0xff00775E), FontWeight.w500, 14.0),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget fetchTakeAway() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          toolbarHeight: MediaQuery.of(context).size.height / 30,
          pinned: true,
          leading: const SizedBox.shrink(),
        ),
        SliverToBoxAdapter(
          child: Container(
              margin: const EdgeInsets.only(left: 25, right: 25),
              height: MediaQuery.of(context).size.height *
                  .77, // Specify your desired height here
              child: Obx(
                () => posController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Color(0xffffab00),
                      ))
                    : posController.takeAwayOrders.isEmpty
                        ? Center(
                            child: Text(
                            "No recent orders",
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 18.0),
                          ))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              childAspectRatio: 2.0,
                            ),
                            itemCount:
                                posController.takeAwayOrders.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  posController.takeAwayOrders.length) {
                                print("index -------$index");
                                return DottedBorder(
                                  color: const Color(0xffC2C8D0),
                                  // Border color
                                  strokeWidth: 2,
                                  // Border width
                                  dashPattern: [8, 4],
                                  // Length of the dash and the space between dashes
                                  borderType: BorderType.RRect,
                                  // Shape of the border, can also be BorderType.Circle
                                  radius: const Radius.circular(12),
                                  // Radius for rounded corners
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () async{

                                        var result = await Get.to(TabPosOrderPage(
                                          orderType: 2,
                                          sectionType: "Create",
                                          uID: "",
                                          tableHead: "Order",
                                          cancelOrder: posController.cancelOrder,
                                          tableID: "",
                                        ));

                                        posController.takeAwayOrders.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      },
                                      child: InkWell(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.add_circle_outlined,
                                                color: Color(0xff596474),
                                                size: 30,
                                              ),
                                              Text(
                                                'Add Orders',
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xff000000),
                                                    FontWeight.w600,
                                                    15.0),
                                              ),
                                              Text(
                                                'Add more items to your order',
                                                style: customisedStyle(
                                                    context,
                                                    const Color(0xff808080),
                                                    FontWeight.w400,
                                                    12.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                                // Or use Container() if you need more control
                              }

                              return GestureDetector(
                                  onTap: () {
                                controller.selectItem(index);

                                  showCustomDialog(context: context, type: posController.takeAwayOrders[index].status!,
                                      salesOrderID: posController.takeAwayOrders[index].salesOrderID!,
                                      orderID: '',salesMasterID: posController.takeAwayOrders[index].salesID!);




                              },
                              child: Container(
                              decoration: BoxDecoration(
                              color: controller.selectedIndex.value ==
                              index
                              ? Colors
                                  .white // Highlight selected item
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              ),
                              child:ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: _getBackgroundColor(
                                              posController
                                                  .takeAwayOrders[index]
                                                  .status!),
                                          width: 3,
                                        ),
                                        right: const BorderSide(
                                            color: Color(0xffE9E9E9), width: 1),
                                        bottom: const BorderSide(
                                            color: Color(0xffE9E9E9), width: 1),
                                        top: const BorderSide(
                                            color: Color(0xffE9E9E9), width: 1),
                                      ),
                                    ),
                                    child: GridTile(
                                      footer: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: (_getBackgroundColor(
                                                  posController
                                                      .takeAwayOrders[index]
                                                      .status))),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                posController
                                                    .takeAwayOrders[index]
                                                    .status!,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      header: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Parcel ${posController.takeAwayOrders[index].tokenNumber!}",

                                                  /// "Parcel ${index + 1} -",
                                                  style: customisedStyle(
                                                      context,
                                                      Colors.black,
                                                      FontWeight.w500,
                                                      15.0),
                                                ),
                                                Text(
                                                  posController
                                                      .returnOrderTime(
                                                          posController
                                                              .takeAwayOrders[
                                                                  index]
                                                              .orderTime!,
                                                          posController
                                                              .takeAwayOrders[
                                                                  index]
                                                              .status!),
                                                  style: customisedStyle(
                                                      context,
                                                      const Color(0xff00775E),
                                                      FontWeight.w400,
                                                      10.0),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              posController
                                                  .takeAwayOrders[index]
                                                  .customerName!,
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff828282),
                                                  FontWeight.w400,
                                                  12.0),
                                            )
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8,
                                            bottom: 8,
                                            top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Token: ",
                                                  style: customisedStyle(
                                                    context,
                                                    const Color(0xff757575),
                                                    FontWeight.w400,
                                                    10.0,
                                                  ),
                                                ),
                                                Text(
                                                  posController
                                                      .takeAwayOrders[index]
                                                      .tokenNumber!,
                                                  style: customisedStyle(
                                                      context,
                                                      Colors.black,
                                                      FontWeight.w400,
                                                      14.0),
                                                )
                                              ],
                                            ),
                                            Text(
                                              "${posController.currency} ${roundStringWith(posController.takeAwayOrders[index].salesOrderGrandTotal!)}",
                                              style: customisedStyle(
                                                  context,
                                                  Colors.black,
                                                  FontWeight.w500,
                                                  15.0),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))));
                            },
                          ),
              )),
        ),
      ],
    );
  }

  Widget fetchCarList() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          toolbarHeight: MediaQuery.of(context).size.height / 30,
          pinned: true,
          leading: const SizedBox.shrink(),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25),

            height: MediaQuery.of(context).size.height *
                .77, // Specify your desired height here
            child: Obx(() => posController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffffab00),
                  ))
                : posController.carOrders.isEmpty
                    ? Center(
                        child: Text(
                        "No recent orders",
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w400, 18.0),
                      ))
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 10,
                          childAspectRatio: 2.0,
                        ),
                        itemCount: posController.carOrders.length + 1,
                        itemBuilder: (context, index) {
                          if (index == posController.carOrders.length) {
                            // Special item (e.g., Add Orders button)
                            return DottedBorder(
                              color: const Color(0xffC2C8D0),
                              strokeWidth: 2,
                              dashPattern: [8, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async{
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 4,
                                      sectionType: "Create",
                                      uID: "",
                                      tableHead:"Order",
                                      cancelOrder:posController.cancelOrder,
                                      tableID: "",
                                    ));


                                    posController.carOrders.clear();
                                    posController.fetchAllData();
                                    posController.update();

                                    // Handle add orders or other actions
                                  },
                                  child: const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outlined,
                                          color: Color(0xff596474),
                                          size: 30,
                                        ),
                                        Text(
                                          'Add Orders',
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Text(
                                          'Add more items to your order',
                                          style: TextStyle(
                                            color: Color(0xff808080),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          // Wrap only the container with Obx to listen to changes
                          return Obx(() => Opacity(
                              opacity: controller.selectedIndex.value == index
                                  ? 1
                                  : 0.30,
                              child: GestureDetector(
                                  onTap: () {
                                    controller.selectItem(index);

                                    showCustomDialog(context: context, type: posController
                                          .carOrders[index]
                                          .status!, salesOrderID:posController.carOrders[index].salesOrderID!, orderID:'',salesMasterID: posController.carOrders[index].salesID!);




                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: controller.selectedIndex.value ==
                                              index
                                          ? Colors
                                              .white // Highlight selected item
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),

                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              left: BorderSide(
                                                color: _getBackgroundColor(
                                                    posController
                                                        .carOrders[index]
                                                        .status),
                                                width: 3,
                                              ),
                                              right: const BorderSide(
                                                  color: Color(0xffE9E9E9),
                                                  width: 1),
                                              bottom: const BorderSide(
                                                  color: Color(0xffE9E9E9),
                                                  width: 1),
                                              top: const BorderSide(
                                                  color: Color(0xffE9E9E9),
                                                  width: 1),
                                            ),
                                          ),
                                          child: GridTile(
                                            footer: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: (_getBackgroundColor(
                                                        posController
                                                            .carOrders[index]
                                                            .status))),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      posController
                                                          .carOrders[index]
                                                          .status!,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            header: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Car Order ${index + 1}",
                                                          style:
                                                              customisedStyle(
                                                                  context,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .w400,
                                                                  14.0),
                                                        ),
                                                        Text(
                                                          posController
                                                              .returnOrderTime(
                                                                  posController
                                                                      .carOrders[
                                                                          index]
                                                                      .orderTime!,
                                                                  posController
                                                                      .carOrders[
                                                                          index]
                                                                      .status!),
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff757575),
                                                              FontWeight.w400,
                                                              10.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    posController
                                                        .carOrders[index]
                                                        .customerName!,
                                                    style: customisedStyle(
                                                      context,
                                                      const Color(0xff828282),
                                                      FontWeight.w500,
                                                      12.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Token: ",
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xff757575),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                      Text(
                                                        posController
                                                            .carOrders[index]
                                                            .tokenNumber!,
                                                        style: customisedStyle(
                                                            context,
                                                            Colors.black,
                                                            FontWeight.w400,
                                                            14.0),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "${posController.currency} ${roundStringWith(posController.carOrders[index].salesOrderGrandTotal!)}",
                                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  ))));
                        })),
          ),
        ),
      ],
    );
  }

  void addTable() {
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
                    'Add_a_Table'.tr,
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
              padding: const EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: posController.customerNameController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  focusNode: posController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(posController.saveFocusNode);
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(
                      hintTextStr: 'Table_Name'.tr),
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
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xffF25F29)),
                  ),
                  onPressed: () {
                    if (posController.customerNameController.text == "") {
                      dialogBox(context, "Please enter table name");
                    } else {
                      posController.createTableApi();
                    }
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
    );
  }

  Future<void> showCustomDialog(
      {required BuildContext context, required String type, required String salesOrderID, required String orderID,required String salesMasterID}) {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      // barrierColor: Colors.transparent,
      barrierColor: Colors.grey.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {

        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .4, // Optional: Limit width if needed
              ),

              height: MediaQuery.of(context).size.height * .16,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(80),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                  type=='Ordered'|| type=='Paid'?  SelectIcon(
                      assetName: 'assets/png/image.png',
                      text: 'Print',
                      type: 'print',
                      onPressed: () {
                        posController.printSection(
                            context: context,
                            id: type == 'Ordered'
                                ? salesOrderID
                                : salesMasterID,
                            isCancelled: false,
                            voucherType: type== 'Ordered'?"SO":"SI");

                      },
                    ):Container(),
                    type=='Ordered' && posController.kitchen_print_perm.value?SelectIcon(
                      assetName: 'assets/png/image5.png',
                      text: 'KOT',
                      type: 'kot',
                      onPressed: () {

                        posController.printKOT(cancelList: [],isUpdate:false,orderID:salesOrderID,rePrint:true);

                      },
                    ): Container(),
                    type=='Ordered'?SelectIcon(
                      assetName: 'assets/png/image3.png',
                      text: 'Pay',
                      type: 'pay',
                      onPressed: () async{
                        if (posController.pay_perm.value) {
                          Navigator.pop(context);
                        var result=await  Get.to(TabPaymentSection(uID: salesOrderID,  orderType: 0,tableID: '',));

                        posController.tableData.clear();
                        posController.takeAwayOrders.clear();
                        posController.carOrders.clear();
                        posController.fetchAllData();
                        posController.update();


                          // orderController.createMethod(
                          //     tableID: widget.tableID,
                          //     tableHead: widget.tableHead,
                          //     orderID: widget.uID,
                          //     orderType: widget.orderType,
                          //     context: context,
                          //     isPayment: true,
                          //     sectionType: widget.sectionType);
                        } else {
                          dialogBoxPermissionDenied(context);
                        }

                      },
                    ):Container(),
                    type=='Ordered'||type=='Paid'? SelectIcon(
                      assetName: 'assets/png/image4.png',
                      text: 'Cancel',
                      type: 'cancel',
                      onPressed: () async {
                        ///dining order
                        if (type == 'Ordered') {
                          var result = await Get.to(CancelOrderList());
                          if (result != null) {
                            posController.cancelOrderApi(
                                context:context,
                                type: "Dining&Cancel",
                                tableID: salesOrderID,
                                cancelReasonId: result[1],
                                orderID: salesOrderID);
                          }
                        } else {
                          posController.cancelOrderApi(
                              context:context,
                              type: "Dining", tableID: orderID, cancelReasonId: "", orderID: salesOrderID);
                        }
                      },
                    ):Container(),
                    type=='Ordered'?  SelectIcon(
                      assetName: 'assets/png/image2.png',
                      text: 'Edit',
                      type: 'edit',
                      onPressed: () {
                        print('Icon 1 pressed');
                      },
                    ):Container(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }
/*   showModalBottomSheet<void>(
        context: context,
         builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
                return SingleChildScrollView();
              });
        }).then((value) {
      setState(() {
        selectedDiningIndex = 1000;
        selectedTakeAwayIndex = 1000;
        selectedOnlineIndex = 1000;
        selectedCarIndex = 1000;
      });*/
}

class IconWithText extends StatelessWidget {
  final String assetName;
  final String text;
  final String type; // Type identifier
  final VoidCallback onPressed; // Callback for the press action

  IconWithText({
    required this.assetName,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final IconController controller =
        Get.put(IconController()); // Access the GetX controller

    return Obx(() {
      Color iconColor = controller.getColor(type);
      return GestureDetector(
        onTap: () {
          controller.selectType(type); // Update the selected type
          onPressed(); // Execute the onPressed callback
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetName,
              color: iconColor, // Apply color to the icon
              height: 24, // Adjust the size as needed
              width: 24,
            ),
            const SizedBox(height: 8), // Space between icon and text
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: iconColor, // Apply color to the text
              ),
            ),
          ],
        ),
      );
    });
  }
}

class SelectIcon extends StatelessWidget {
  final String assetName;
  final String text;
  final String type; // Type identifier
  final VoidCallback onPressed; // Callback for the press action

  SelectIcon({
    required this.assetName,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final IconController controller = Get.find(); // Access the GetX controller

    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: GestureDetector(
          onTap: () {
            controller.selectCurrentAction(type); // Update the selected type
            onPressed(); // Execute the onPressed callback
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                assetName,
                fit: BoxFit.fitWidth,
                height: MediaQuery.of(context).size.height * .10,
                width: MediaQuery.of(context).size.width * .060,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    text,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 13.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
