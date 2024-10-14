import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/tab_design/tab_pos_payment_section.dart';

import '../../../../../../global/textfield_decoration.dart';
import '../../controller/pos_controller.dart';
import '../detail_page/cancel_reason_list.dart';
import '../detail_page/platform.dart';
import '../detail_page/reservation_list.dart';
import 'draggable_list.dart';
import 'tab_pos_order_page.dart';

///image size not correct ,in bottom sheet cancel order and print
///opacity of tables when we select option to print not correct
class TabPosListDesign extends StatefulWidget {
  const TabPosListDesign({super.key});

  @override
  State<TabPosListDesign> createState() => _TabPosListDesignState();
}

class _TabPosListDesignState extends State<TabPosListDesign> {
//  final IconController controller = Get.put(IconController());

//  final POSController diningController = Get.put(POSController());
  final POSController posController = Get.put(POSController());
  String combineMessage = "";

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
    posController.tablemergeData.clear();
    posController.fullOrderData.clear();
    posController.onlineOrders.clear();
    posController.takeAwayOrders.clear();
    posController.carOrders.clear();
    posController.update();
  }

  final RxBool _isLongPressed = false.obs;
  bool iscombineclicked = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: const TextScaler.linear(1.0),
        ),
        child: Scaffold(
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
            title: Obx(() {
              return Text(
                posController.selectedType.value == "dine"
                    ? "Choose a Table"
                    : "Create Order",
                style: customisedStyle(
                    context, Colors.black, FontWeight.w500, 18.0),
              );
            }),
            actions: [
              TextButton(
                  onPressed: () =>
                      createTableSplit(context, screenSize, posController),
                  child: const Text("Create Table")),
              // TextButton(
              //     onPressed: () {
              //       _dialogBuilderQRDownload(context, screenSize, posController);
              //     },
              //     child: const Text("QR Download")),
              // TextButton(
              //     onPressed: () {
              //       _dialogBuilderQRoption(context, screenSize, posController);
              //     },
              //     child: const Text("qr option")),

              Obx(() {
                return posController.isCombine.value
                    ? TextButton(
                        onPressed: () {
                          // pr("controller.selectList");
                          if (posController.selectList.length > 1) {
                            for (int i = 0;
                                i < posController.selectList.length;
                                i++) {
                              final id = posController
                                  .tablemergeData[posController.selectList[i]]
                                  .id;
                              final name = posController
                                  .tablemergeData[posController.selectList[i]]
                                  .tableName;
                              pr(id);
                              posController.combineDatas.add(id);

                              // combineMessage = "$combineMessage & $name";
                              if (i == 0) {
                                combineMessage = name!;
                              } else {
                                combineMessage = "$combineMessage & $name";
                              }
                              log(combineMessage.toString());
                            }

                            _dialogCombine(context, screenSize, posController,
                                posController.combineDatas, combineMessage);
                          } else {
                            Get.snackbar(
                              'Alert',
                              'Please select at least 2 Table',
                            );
                          }
                        },
                        child: const Text("Combine"))
                    : Container();
              }),

              Obx(() {
                return posController.isCombine.value
                    ? TextButton(
                        onPressed: () {
                          posController.isCombine.value = false;
                          posController.selectList.clear();
                          posController.update();
                        },
                        child: const Text("Cancel Combine"))
                    : Container();
              }),

              PopupMenuButton<String>(
                icon: const Icon(Icons.settings),
                onSelected: (value) {
                  _handleMenuSelection(value);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'table',
                      child: Text('Add a Table'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'reservation',
                      child: Text('Reservation'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'platform',
                      child: Text('Platform'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Text('Table Settings'),
                    ),
                  ];
                },
              ),
              const SizedBox(
                width: 20,
              )
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
                    switch (posController.selectedType.value) {
                      case 'dine':
                        return fetchDiningList();
                      case 'takeout':
                        return fetchTakeAway();
                      case 'online':
                        return fetchOnline(context);
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
                          text: 'Dining',
                          type: 'dine', // Unique identifier for this type
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),
                        IconWithText(
                          assetName: 'assets/svg/takeout_dining.svg',
                          text: 'Takeout',
                          type: 'takeout', // Unique identifier for this type
                          onPressed: () {},
                        ),
                        const SizedBox(height: 10),

                        ///online commented here
                        IconWithText(
                          assetName: 'assets/svg/online_img.svg',
                          text: 'Online',
                          type: 'online', // Unique identifier for this type
                          onPressed: () {
                            print('Online icon pressed');
                            // Add your onPressed logic here
                          },
                        ),
                        const SizedBox(height: 10),
                        IconWithText(
                          assetName: 'assets/svg/car_inmgs.svg',
                          text: 'Car',
                          type: 'car', // Unique identifier for this type
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  CustomScrollView fetchOnline(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
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
              : posController.onlineOrders.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .20,
                          width: MediaQuery.of(context).size.width * .22,
                          child: DottedBorder(
                            color: const Color(0xffC2C8D0),
                            strokeWidth: 2,
                            dashPattern: const [8, 4],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  var result = await Get.to(TabPosOrderPage(
                                    orderType: 3,
                                    sectionType: "Create",
                                    uID: "",
                                    splitID: "",
                                    tableHead: "Order",
                                    cancelOrder: posController.cancelOrder,
                                    tableID: "",
                                  ));

                                  if (result != null) {
                                    if (result[1]) {
                                      var resultPayment =
                                          await Get.to(TabPaymentSection(
                                        uID: result[2],
                                        tableID: '',
                                        splitID: "",
                                        orderType: 3,
                                        type: '',
                                        isData: false,
                                        responseData: '',
                                      ));
                                      posController.onlineOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    } else {
                                      posController.onlineOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    }
                                  } else {
                                    posController.onlineOrders.clear();
                                    posController.fetchTOC();
                                    posController.update();
                                  }
                                },
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.0,
                      ),
                      itemCount: posController.onlineOrders.length + 1,
                      itemBuilder: (context, index) {
                        if (index == posController.onlineOrders.length) {
                          // Special item (e.g., Add Orders button)
                          return DottedBorder(
                            color: const Color(0xffC2C8D0),
                            strokeWidth: 2,
                            dashPattern: const [8, 4],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            child: Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () async {
                                  int index = 0;
                                  posController.onlineSelectItem(index);
                                  var result = await Get.to(TabPosOrderPage(
                                    orderType: 3,
                                    sectionType: "Create",
                                    uID: "",
                                    splitID: "",
                                    tableHead: "Order",
                                    cancelOrder: posController.cancelOrder,
                                    tableID: "",
                                  ));

                                  if (result != null) {
                                    if (result[1]) {
                                      var resultPayment =
                                          await Get.to(TabPaymentSection(
                                        uID: result[2],
                                        tableID: '',
                                        splitID: "",
                                        orderType: 3,
                                        type: '',
                                        isData: false,
                                        responseData: '',
                                      ));
                                      posController.onlineOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    } else {
                                      posController.onlineOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    }
                                  } else {
                                    posController.onlineOrders.clear();
                                    posController.fetchTOC();
                                    posController.update();
                                  }
                                },
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                        return GestureDetector(
                            onTap: () {
                              posController.onlineSelectItem(index);
                              showCustomDialog(
                                  context: context,
                                  status:
                                      posController.onlineOrders[index].status!,
                                  salesOrderID: posController
                                      .onlineOrders[index].salesOrderID!,
                                  orderID: '',
                                  salesMasterID: posController
                                      .onlineOrders[index].salesID!,
                                  orderType: 'online',
                                  orderTypeID: 3,
                                  index: index);
                            },
                            child: Obx(
                              () => Opacity(
                                opacity: posController
                                            .onlineselectedIndex.value ==
                                        index
                                    ? 1
                                    : posController.onlineselectedIndex.value ==
                                            1000
                                        ? 1
                                        : 0.30,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: posController
                                                .onlineselectedIndex.value ==
                                            index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.5),
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
                                                      .onlineOrders[index]
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  color: (_getBackgroundColor(
                                                      posController
                                                          .onlineOrders[index]
                                                          .status))),
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        posController
                                                            .onlineOrders[index]
                                                            .status!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
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
                                                        "Online Order ${index + 1}",
                                                        style: customisedStyle(
                                                            context,
                                                            Colors.black,
                                                            FontWeight.w400,
                                                            14.0),
                                                      ),
                                                      Text(
                                                        posController
                                                            .returnOrderTime(
                                                                posController
                                                                    .onlineOrders[
                                                                        index]
                                                                    .orderTime!,
                                                                posController
                                                                    .onlineOrders[
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
                                                      .onlineOrders[index]
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
                                                          .onlineOrders[index]
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
                                                  "${posController.currency} ${roundStringWith(posController.onlineOrders[index].salesOrderGrandTotal!)}",
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
                                      )),
                                ),
                              ),
                            ));
                      })),
        ),
      ),
    ]);
  }

  void _handleMenuSelection(String value) {
    switch (value) {
      case 'table':
        // Add your print functionality here
        return addTable();
        break;
      case 'reservation':
        return addReservation();

      case 'platform':
        return navigatePlatform();
      case 'settings':
        return navigateSettings();

      default:
        break;
    }
  }

  Future<void> createTableSplit(
      BuildContext context, Size screenSize, POSController controller) {
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: SizedBox(
            width: screenSize.width,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Create Table",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                              posController.splitcountcontroller.clear();
                              // posController.createSplitController.clear();
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF373737),
                            ))
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                ],
              ),
              content: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: screenSize.width / 4,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Create Table",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                SizedBox(
                                  width: screenSize.width / 5,
                                  child: TextFormField(
                                    controller:
                                        posController.tablenameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Table Name',
                                      hintStyle: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Color(0xFF5B5B5B)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFD9D9D9))),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFD9D9D9))),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFD9D9D9))),
                                    ),
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Please enter table name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.01),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Table Split",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.01),
                              Container(
                                width: screenSize.width * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: const Color(0xFFD9D9D9),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        width: screenSize.width * 0.04,
                                        child: TextFormField(
                                          cursorColor: Colors.black,
                                          controller: posController
                                              .splitcountcontroller,
                                          maxLength: 1,
                                          textAlign: TextAlign.center,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            counterText: '',
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                            LengthLimitingTextInputFormatter(1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (posController
                                                      .splitcountcontroller
                                                      .text
                                                      .isNotEmpty &&
                                                  int.parse(posController
                                                          .splitcountcontroller
                                                          .text) <
                                                      9) {
                                                if (posController
                                                        .splitcountcontroller
                                                        .text ==
                                                    "0") {
                                                  setState(() {
                                                    posController
                                                        .splitcountcontroller
                                                        .text = (int.parse(
                                                                posController
                                                                    .splitcountcontroller
                                                                    .text) +
                                                            2)
                                                        .toString();
                                                  });
                                                } else {
                                                  setState(() {
                                                    posController
                                                        .splitcountcontroller
                                                        .text = (int.parse(
                                                                posController
                                                                    .splitcountcontroller
                                                                    .text) +
                                                            1)
                                                        .toString();
                                                  });
                                                }
                                              }
                                            },
                                            child: const Icon(
                                                Icons.keyboard_arrow_up)),
                                        GestureDetector(
                                            onTap: () {
                                              if (posController
                                                      .splitcountcontroller
                                                      .text
                                                      .isNotEmpty &&
                                                  int.parse(posController
                                                          .splitcountcontroller
                                                          .text) >
                                                      0) {
                                                if (posController
                                                        .splitcountcontroller
                                                        .text ==
                                                    "2") {
                                                  setState(() {
                                                    posController
                                                        .splitcountcontroller
                                                        .text = (int.parse(
                                                                posController
                                                                    .splitcountcontroller
                                                                    .text) -
                                                            2)
                                                        .toString();
                                                  });
                                                } else {
                                                  setState(() {
                                                    posController
                                                        .splitcountcontroller
                                                        .text = (int.parse(
                                                                posController
                                                                    .splitcountcontroller
                                                                    .text) -
                                                            1)
                                                        .toString();
                                                  });
                                                }
                                              }
                                            },
                                            child: const Icon(
                                                Icons.keyboard_arrow_down)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF25F29),
                          minimumSize: const Size(400, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              (posController
                                      .splitcountcontroller.text.isEmpty ||
                                  (int.parse(posController
                                              .splitcountcontroller.text) ==
                                          0 ||
                                      (int.parse(posController
                                                  .splitcountcontroller.text) >
                                              1 &&
                                          int.parse(posController
                                                  .splitcountcontroller.text) <=
                                              9)))) {
                            log("Success");
                            await posController
                                .createTableSplit(posController.combineDatas);
                          } else {
                            if (posController
                                    .splitcountcontroller.text.isNotEmpty &&
                                int.parse(posController
                                        .splitcountcontroller.text) ==
                                    1) {
                              dialogBox(context, 'Split count cannot be 1');
                            } else {
                              dialogBox(context, 'Please enter valid Input');
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }

  /// qr option commented
  // Future<void> _dialogBuilderQRoption(BuildContext context, Size screenSize, POSController controller) {
  //   final formKey = GlobalKey<FormState>();
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Form(
  //         key: formKey,
  //         child: SizedBox(
  //           width: screenSize.width,
  //           child: AlertDialog(
  //             titlePadding: EdgeInsets.zero,
  //             title: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Create Table",
  //                         style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                       IconButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           icon: const Icon(
  //                             Icons.close,
  //                             color: Color(0xFF373737),
  //                           ))
  //                     ],
  //                   ),
  //                 ),
  //                 const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
  //               ],
  //             ),
  //             content: SingleChildScrollView(
  //               physics: const NeverScrollableScrollPhysics(),
  //               child: SizedBox(
  //                 width: screenSize.width / 4,
  //                 child: Column(
  //                   children: [
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text(
  //                                 "Create Table",
  //                                 style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
  //                               ),
  //                               SizedBox(height: screenSize.height * 0.01),
  //                               SizedBox(
  //                                 width: screenSize.width / 5,
  //                                 child: TextFormField(
  //                                   controller: posController.tablenameController,
  //                                   decoration: const InputDecoration(
  //                                     hintText: 'Enter Table Name',
  //                                     hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF5B5B5B)),
  //                                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                                     border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                                   ),
  //                                   validator: (value) {
  //                                     if (value == null || value.trim().isEmpty) {
  //                                       return 'Please enter table name';
  //                                     }
  //                                     return null;
  //                                   },
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                         SizedBox(width: screenSize.width * 0.01),
  //                         // const SizedBox(height: 2),
  //                         // TextFormField(
  //                         //   controller: controller.tablesplitController..text = '1',
  //                         //   decoration: const InputDecoration(
  //                         //     hintText: 'Enter the Number Split',
  //                         //     hintStyle: TextStyle(
  //                         //         fontFamily: 'Poppins',
  //                         //         fontSize: 12,
  //                         //         color: Color(0xFF5B5B5B)),
  //                         //     enabledBorder: OutlineInputBorder(
  //                         //         borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                         //     focusedBorder: OutlineInputBorder(
  //                         //         borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                         //     border: OutlineInputBorder(
  //                         //         borderSide: BorderSide(color: Color(0xFFD9D9D9))),
  //                         //   ),
  //                         //   validator: (value) {
  //                         //     if (value == null || value.trim().isEmpty) {
  //                         //       return 'Please enter table split';
  //                         //     }
  //                         //     if (num.tryParse(value) == null) {
  //                         //       return dialogBox(
  //                         //           context, 'Please enter a valid number');
  //                         //     }
  //                         //     if (value.length > 1) {
  //                         //       return 'Please enter a single digit';
  //                         //     }
  //                         //     int numValue = int.parse(value);
  //                         //     if (numValue < 1 || numValue > 9) {
  //                         //       return 'Please enter a number between 1 and 9';
  //                         //     }
  //                         //     return null;
  //                         //   },
  //                         //   inputFormatters: [
  //                         //     // FilteringTextInputFormatter.digitsOnly,
  //                         //     FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
  //                         //     LengthLimitingTextInputFormatter(1),
  //                         //   ],
  //                         // ),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             const Text(
  //                               "Table Split",
  //                               style: TextStyle(
  //                                 fontFamily: 'Poppins',
  //                               ),
  //                             ),
  //                             SizedBox(height: screenSize.height * 0.01),
  //                             Container(
  //                               width: screenSize.width * 0.07,
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(5),
  //                                 border: Border.all(color: const Color(0xFFD9D9D9)),
  //                               ),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   Center(
  //                                     child: SizedBox(
  //                                       width: screenSize.width * 0.04,
  //                                       child: TextFormField(
  //                                         cursorColor: Colors.black,
  //                                         controller: posController.splitcountcontroller,
  //                                         maxLength: 1,
  //                                         textAlign: TextAlign.center,
  //                                         decoration: const InputDecoration(
  //                                           border: InputBorder.none,
  //                                           counterText: '',
  //                                         ),
  //                                         keyboardType: TextInputType.number,
  //                                         // validator: (value) {
  //                                         //   if (value == null ||
  //                                         //       value.trim().isEmpty) {
  //                                         //     return 'Please enter table split';
  //                                         //   }
  //                                         //   if (num.tryParse(value) == null) {
  //                                         //     return 'Please enter a valid number';
  //                                         //   }
  //                                         //   if (value.length > 1) {
  //                                         //     return 'Please enter a single digit';
  //                                         //   }
  //                                         //   int numValue = int.parse(value);
  //                                         //   if (numValue < 1 || numValue > 9) {
  //                                         //     return 'Please enter a number between 1 and 9';
  //                                         //   }
  //                                         //   return null;
  //                                         // },
  //                                         inputFormatters: [
  //                                           FilteringTextInputFormatter.digitsOnly,
  //                                           FilteringTextInputFormatter.allow(RegExp(r'[1-9]')),
  //                                           LengthLimitingTextInputFormatter(1),
  //                                         ],
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Column(
  //                                     mainAxisAlignment: MainAxisAlignment.center,
  //                                     mainAxisSize: MainAxisSize.min,
  //                                     children: [
  //                                       GestureDetector(
  //                                           onTap: () {
  //                                             if (posController.splitcountcontroller.text.isNotEmpty &&
  //                                                 int.parse(posController.splitcountcontroller.text) < 9) {
  //                                               setState(() {
  //                                                 posController.splitcountcontroller.text =
  //                                                     (int.parse(posController.splitcountcontroller.text) + 1).toString();
  //                                               });
  //                                             }
  //                                           },
  //                                           child: const Icon(Icons.keyboard_arrow_up)),
  //                                       GestureDetector(
  //                                           onTap: () {
  //                                             if (posController.splitcountcontroller.text.isNotEmpty &&
  //                                                 int.parse(posController.splitcountcontroller.text) > 1) {
  //                                               setState(() {
  //                                                 posController.splitcountcontroller.text =
  //                                                     (int.parse(posController.splitcountcontroller.text) - 1).toString();
  //                                               });
  //                                             }
  //                                           },
  //                                           child: const Icon(Icons.keyboard_arrow_down)),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: screenSize.height * 0.02),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                           color: const Color(0xFFF4F6F6),
  //                           border: Border.all(width: 1, color: const Color(0xFFD9D9D9)),
  //                           borderRadius: const BorderRadius.all(Radius.circular(10))),
  //                       child: Column(
  //                         children: [
  //                           Container(
  //                             decoration: const BoxDecoration(color: Color(0xFFF4F6F6), borderRadius: BorderRadius.all(Radius.circular(10))),
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                                 children: [
  //                                   Text(
  //                                     "Table QR Code",
  //                                     style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                                   ),
  //                                   Text(
  //                                     "Operation",
  //                                     style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                           const Divider(color: Color(0xFFD9D9D9)),
  //                           Padding(
  //                             padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 Text(
  //                                   "SQA245690AIH847",
  //                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                                 ),
  //                                 const Row(
  //                                   children: [
  //                                     Icon(Icons.delete_forever_outlined),
  //                                     Icon(Icons.delete_forever_outlined),
  //                                     Icon(Icons.delete_forever_outlined),
  //                                   ],
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(height: screenSize.height * 0.02),
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFFF25F29),
  //                         minimumSize: const Size(400, 50),
  //                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
  //                       ),
  //                       child: const Text(
  //                         "Save",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       onPressed: () {
  //                         if (formKey.currentState!.validate()) {
  //                           log("Success");
  //                         } else {
  //                           dialogBox(context, 'Please enter valid Input');
  //                         }
  //                         print("object");
  //                         posController.tablenameController.clear();
  //                         posController.splitcountcontroller.clear();
  //                         Navigator.of(context).pop();
  //                       },
  //                     )
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               side: const BorderSide(color: Colors.transparent),
  //             ),
  //             backgroundColor: Colors.grey[200],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> _dialogBuilderQRDownload(BuildContext context, Size screenSize, POSController controller) {
  //   final formKey = GlobalKey<FormState>();
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Form(
  //         key: formKey,
  //         child: SizedBox(
  //           width: screenSize.width,
  //           child: AlertDialog(
  //             titlePadding: EdgeInsets.zero,
  //             title: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       const Text(
  //                         "Download QR Code",
  //                         style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
  //                       ),
  //                       IconButton(
  //                           onPressed: () {
  //                             Navigator.pop(context);
  //                           },
  //                           icon: const Icon(
  //                             Icons.close,
  //                             color: Color(0xFF373737),
  //                           ))
  //                     ],
  //                   ),
  //                 ),
  //                 const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
  //               ],
  //             ),
  //             content: SingleChildScrollView(
  //               physics: const NeverScrollableScrollPhysics(),
  //               child: SizedBox(
  //                 width: screenSize.width / 5,
  //                 child: Column(
  //                   children: [
  //                     Center(
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(
  //                             "Table QR Code:",
  //                             style: customisedStyle(context, const Color(0xFF292D32), FontWeight.w400, 12.0),
  //                           ),
  //                           Text(" SQA245690AIH847", style: customisedStyle(context, const Color(0xFF292D32), FontWeight.w500, 12.0))
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(height: screenSize.height * 0.02),
  //                     Center(
  //                       child: Column(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: <Widget>[
  //                           Container(
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.all(Radius.circular(10)),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                   color: Color(0xFFD4D4D4),
  //                                   spreadRadius: 5,
  //                                   blurRadius: 7,
  //                                   offset: Offset(0, 3),
  //                                 ),
  //                               ],
  //                             ),
  //                             child: Screenshot(
  //                               controller: posController.screenshotController,
  //                               child: QrImageView(
  //                                 data: 'https://vikncodes.com/',
  //                                 version: QrVersions.auto,
  //                                 size: 150,
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     SizedBox(height: screenSize.height * 0.02),
  //                     ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: const Color(0xFFF25F29),
  //                         minimumSize: const Size(400, 50),
  //                         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
  //                       ),
  //                       child: const Text(
  //                         "Download",
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       onPressed: () async {
  //                         if (formKey.currentState!.validate()) {
  //                           log("Success");
  //                           await posController.requestPermission();
  //                           await posController.saveQrCode();
  //                         } else {
  //                           dialogBox(context, 'Please enter valid Input');
  //                         }
  //                         print("object");
  //                         posController.tablenameController.clear();
  //                         posController.splitcountcontroller.clear();
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                     SizedBox(height: screenSize.height * 0.02),
  //                     TextButton(
  //                       onPressed: () {},
  //                       style: TextButton.styleFrom(
  //                         minimumSize: const Size(0, 0),
  //                         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //                       ),
  //                       child: Text(
  //                         "Cancel",
  //                         style: customisedStyle(context, const Color(0xFF292D32), FontWeight.w400, 14.0),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               side: const BorderSide(color: Colors.transparent),
  //             ),
  //             backgroundColor: Colors.grey[200],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> _dialogCombine(BuildContext context, Size screenSize,
      POSController controller, combineDatas, combineMessage) {
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: formKey,
          child: SizedBox(
            width: screenSize.width,
            child: AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("ICON")],
                ),
              ),
              content: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SizedBox(
                  width: screenSize.width / 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$combineMessage has orders",
                            style: customisedStyle(context,
                                const Color(0xFF292D32), FontWeight.w500, 18.0),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Text(
                            "Would you like to combine them",
                            style: customisedStyle(
                              context,
                              const Color(0xFF474747),
                              FontWeight.w400,
                              16.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF25F29),
                          minimumSize: const Size(400, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            posController.combineData(context, combineDatas);

                            Navigator.of(context).pop(); //!

                            await _dialogCombineSuccess(
                                context, screenSize, combineMessage);
                            // controller.tablenameController.clear();
                            // controller.tablesplitController.clear();
                            posController.update();
                          } else {
                            dialogBox(context, 'Please enter valid Input');
                          }

                          // controller.tablenameController.clear();
                          // controller.tablesplitController.clear();
                        },
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Cancel",
                          style: customisedStyle(context,
                              const Color(0xFF292D32), FontWeight.w400, 14.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Colors.transparent),
              ),
              backgroundColor: Colors.grey[200],
            ),
          ),
        );
      },
    );
  }

  Future<void> _dialogCombineSuccess(
      BuildContext context, Size screenSize, combineMessage) {
    final formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: screenSize.width,
          child: AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 100,
                  )
                ],
              ),
            ),
            content: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                width: screenSize.width / 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Table Combined",
                          style: customisedStyle(context,
                              const Color(0xFF292D32), FontWeight.w500, 18.0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          "$combineMessage have been successfully combined.",
                          style: customisedStyle(
                            context,
                            const Color(0xFF474747),
                            FontWeight.w400,
                            16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF25F29),
                        minimumSize: const Size(400, 50),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        // if (formKey.currentState!.validate()) {
                        log("Success");
                        posController.fetchAllData();
                        Navigator.of(context).pop(true);
                        // } else {
                        //   dialogBox(context, 'Please enter valid Input');
                        // }
                      },
                    ),
                  ],
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.transparent),
            ),
            backgroundColor: Colors.grey[200],
          ),
        );
      },
    );
  }

  // Column SplitTableComponents(
  //     BuildContext context, Size screenSize, String? status) {
  //   return Column(
  //     children: [
  //       Material(
  //         elevation: 5,
  //         shape: const CircleBorder(),
  //         child: CircleAvatar(
  //           radius: 30,
  //           backgroundColor: const Color(0xFF1E1F4E),
  //           child: SvgPicture.asset(
  //             'assets/svg/printmodal.svg',
  //             width: 30,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         "Print",
  //         style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
  //       ),
  //       SizedBox(height: screenSize.height * 0.01),
  //       Material(
  //         elevation: 5,
  //         shape: const CircleBorder(),
  //         child: CircleAvatar(
  //           radius: 30,
  //           backgroundColor: const Color(0xFFFC3636),
  //           child: SvgPicture.asset(
  //             'assets/svg/closemodal.svg',
  //             width: 30,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         "Cancel Order",
  //         style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
  //       ),
  //       SizedBox(height: screenSize.height * 0.01),
  //       Material(
  //         elevation: 5,
  //         shape: const CircleBorder(),
  //         child: CircleAvatar(
  //           radius: 30,
  //           backgroundColor: const Color(0xFF44B678),
  //           child: SvgPicture.asset(
  //             'assets/svg/dollarmodal.svg',
  //             width: 30,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         "Pay",
  //         style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
  //       ),
  //       SizedBox(height: screenSize.height * 0.01),
  //       Material(
  //         elevation: 5,
  //         shape: const CircleBorder(),
  //         child: CircleAvatar(
  //           radius: 30,
  //           backgroundColor: const Color(0xFF17A2B8),
  //           child: SvgPicture.asset(
  //             'assets/svg/kotmodal.svg',
  //             width: 30,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         "Kot",
  //         style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
  //       ),
  //       SizedBox(height: screenSize.height * 0.01),
  //       Material(
  //         elevation: 5,
  //         shape: const CircleBorder(),
  //         child: CircleAvatar(
  //           radius: 30,
  //           backgroundColor: const Color(0xFFA561E8),
  //           child: SvgPicture.asset(
  //             'assets/svg/editmodal.svg',
  //             width: 30,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         "Edit",
  //         style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
  //       ),
  //     ],
  //   );
  // }

  navigatePlatform() async {
    var result = await Get.to(const OnlinePlatforms());
  }

  addReservation() async {
    if (posController.reservation_perm.value) {
      Get.to(const ReservationPage());
    } else {
      dialogBoxPermissionDenied(context);
    }
  }

  ///not updating
  navigateSettings() async {
    var result = await Get.to(const DragTableList());
    posController.selectedIndexNotifier.value = 0;
    posController.tablemergeData.clear();
    posController.fetchAllData();
    posController.update();
  }

  Widget fetchDiningList() {
    return CustomScrollView(
      slivers: <Widget>[
        ///dining list
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
            height: MediaQuery.of(context).size.height *
                .9, // Specify your desired height here
            child: Obx(() => posController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffffab00),
                  ))
                : posController.tablemergeData.isEmpty
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
                        itemCount: posController.tablemergeData.length + 1,
                        itemBuilder: (context, index) {
                          if (index == posController.tablemergeData.length) {
                            return Container();
                          }

                          // posController.selectedIndex.value = index;
                          return GestureDetector(
                              onLongPress: () {
                                if (posController.tablemergeData[index]
                                        .splitData!.length >=
                                    2) {
                                } else {
                                  setState(() {
                                    posController
                                                .tablemergeData[index].status ==
                                            "Ordered"
                                        ? posController.isCombine.value =
                                            !posController.isCombine.value
                                        : '';
                                  });
                                }
                              },
                              //!
                              onTap: () async {
                                if (posController.isCombine.value) {
                                  dialogBox(
                                      context, 'Cancel Combine for proceed');
                                } else {
                                  if (posController.tablemergeData[index]
                                      .splitData!.isEmpty) {
                                    if (posController
                                            .tablemergeData[index].status ==
                                        'Vacant') {
                                      var result = await Get.to(TabPosOrderPage(
                                        orderType: 1,
                                        sectionType: "Create",
                                        uID: "",
                                        splitID: "",
                                        tableHead: "Order",
                                        cancelOrder: posController.cancelOrder,
                                        tableID: posController
                                            .tablemergeData[index].id!,
                                      )); // Pass the value to POS Order Page

                                      if (result != null) {
                                        if (result[1]) {
                                          var resultPayment =
                                              await Get.to(TabPaymentSection(
                                            uID: result[2],
                                            splitID: "",
                                            tableID: posController
                                                .tablemergeData[index].id!,
                                            orderType: 0,
                                            type: 'dine',
                                            isData: false,
                                            responseData: '',
                                          ));
                                          posController.tablemergeData.clear();
                                          posController.fetchAllData();
                                          posController.update();
                                        } else {
                                          posController.tablemergeData.clear();
                                          posController.fetchAllData();
                                          posController.update();
                                        }
                                      } else {
                                        posController.tablemergeData.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      }
                                    } else {
                                      if (_isLongPressed.value == false) {
                                        posController.selectItem(index);

                                        ///1000005
                                        showCustomDialog(
                                          context: context,
                                          status: posController
                                              .tablemergeData[index].status!,
                                          salesOrderID: posController
                                              .tablemergeData[index]
                                              .salesOrderID!,
                                          orderID: posController
                                              .tablemergeData[index].id!,
                                          salesMasterID: posController
                                              .tablemergeData[index]
                                              .salesMasterID!,
                                          orderType: 'dine',
                                          orderTypeID: 1,
                                          index: index,
                                        );
                                      } else {
                                        final checkeddata = index;
                                        // log("CheckedData");
                                        // log(checkeddata.toString());

                                        if (!posController.selectList
                                            .contains(index)) {
                                          posController.selectList
                                              .add(checkeddata);
                                        } else {
                                          posController.selectList
                                              .remove(checkeddata);
                                        }

                                        // print(controller.selectList);
                                      }
                                    }
                                  } else {
                                    posController.selectedsplitIndex.value =
                                        1000;
                                    posController.update();
                                    Size screenSize =
                                        MediaQuery.of(context).size;
                                    _dialogBuilderTableSplit(
                                        context,
                                        screenSize,
                                        posController
                                            .tablemergeData[index].splitData!,
                                        index);
                                  }
                                }
                              },
                              child: Obx(
                                () => Opacity(
                                  opacity:
                                      posController.selectedIndex.value == index
                                          ? 1
                                          : posController.selectedIndex.value ==
                                                  1000
                                              ? 1
                                              : 0.30,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: posController
                                                    .selectedIndex.value ==
                                                index
                                            ? Colors
                                                .white // Highlight selected item
                                            : Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: _getBackgroundColor(
                                                      posController
                                                          .tablemergeData[index]
                                                          .status),
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
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: (_getBackgroundColor(
                                                          posController
                                                              .tablemergeData[
                                                                  index]
                                                              .status))),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        posController
                                                            .tablemergeData[
                                                                index]
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
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            posController
                                                                    .tablemergeData[
                                                                        index]
                                                                    .tableName ??
                                                                '',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16.0,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Obx(
                                                          () => posController
                                                                      .isCombine
                                                                      .value &&
                                                                  posController
                                                                          .tablemergeData[
                                                                              index]
                                                                          .status ==
                                                                      "Ordered"
                                                              ? Checkbox(
                                                                  side: const BorderSide(
                                                                      width:
                                                                          1.0,
                                                                      color: Colors
                                                                          .grey),
                                                                  activeColor:
                                                                      const Color(
                                                                          0xFF03C1C1),
                                                                  checkColor:
                                                                      Colors
                                                                          .white,
                                                                  fillColor: WidgetStateProperty.all(
                                                                      const Color(
                                                                          0xFF03C1C1)),
                                                                  value: posController
                                                                      .selectList
                                                                      .contains(
                                                                          index),
                                                                  onChanged:
                                                                      (value) {
                                                                    posController
                                                                        .checkedbtn(
                                                                            index);
                                                                    log(index
                                                                        .toString());
                                                                  },
                                                                )
                                                              :
                                                              // Image.asset(
                                                              //     'assets/png/editcombine.png')
                                                              //  SvgPicture.asset(
                                                              //     'assets/svg/editcombine.svg')
                                                              IconButton(
                                                                  onPressed:
                                                                      () {},
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .edit_outlined)),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    posController.returnOrderTime(
                                                                posController
                                                                    .tablemergeData[
                                                                        index]
                                                                    .orderTime!,
                                                                posController
                                                                    .tablemergeData[
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
                                                                        .tablemergeData[
                                                                            index]
                                                                        .orderTime!,
                                                                    posController
                                                                        .tablemergeData[
                                                                            index]
                                                                        .status!),
                                                                style: customisedStyle(
                                                                    context,
                                                                    const Color(
                                                                        0xff828282),
                                                                    FontWeight
                                                                        .w400,
                                                                    12.0),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    posController
                                                                .tablemergeData[
                                                                    index]
                                                                .status ==
                                                            "Vacant"
                                                        ? const Text("")
                                                        : Text(
                                                            "${posController.currency} ${roundStringWith(posController.tablemergeData[index].status != "Vacant" ? posController.tablemergeData[index].status != "Paid" ? posController.tablemergeData[index].salesOrderGrandTotal.toString() : posController.tablemergeData[index].salesGrandTotal.toString() : '0')}",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500,
                                                                    15.0),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ))),
                                ),
                              ));
                        },
                      )),
          ),
        ),
      ],
    );
  }

  ///100002
  Future<void> _dialogBuilderTableSplit(
      BuildContext context, Size screenSize, listsplit, indexOfSelectedTable) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: AlertDialog(
                titlePadding: EdgeInsets.zero,
                title: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Table Split",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              listsplit[posController.selectedCombinedIndex
                                          .value]["Status"] ==
                                      'Vacant'
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (
                                            BuildContext context,
                                          ) {
                                            return AlertDialog(
                                              title: Text(
                                                'Confirmation',
                                                style: customisedStyle(
                                                  context,
                                                  Colors.black,
                                                  FontWeight.w500,
                                                  13.0,
                                                ),
                                              ),
                                              content: Text(
                                                'Do You Want to Combine?',
                                                style: customisedStyle(
                                                  context,
                                                  Colors.black,
                                                  FontWeight.normal,
                                                  12.0,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    Get.to(TabPosOrderPage(
                                                      orderType: 1,
                                                      sectionType: "Create",
                                                      uID: "",
                                                      splitID: "",
                                                      tableHead: "Order",
                                                      cancelOrder: posController
                                                          .cancelOrder,
                                                      tableID: posController
                                                          .tablemergeData[
                                                              posController
                                                                  .selectedCombinedIndex
                                                                  .value]
                                                          .id!,
                                                    ));
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF0E8FF),
                                        minimumSize: const Size(80, 40),
                                      ),
                                      child: Row(
                                        children: [
                                          // SvgPicture.asset(
                                          //     'assets/svg/combineicon.svg'),
                                          Text(
                                            "All Combine",
                                            style: customisedStyle(
                                                context,
                                                const Color(0xFF6F42C1),
                                                FontWeight.w400,
                                                14.0),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Color(0xFF373737),
                                  ))
                            ],
                          ),
                        ],
                      ),
                      const Divider(thickness: 1, color: Color(0xFFE0E0E0)),
                    ],
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                  width: constraints.maxWidth / 1.4,
                  height: constraints.maxHeight / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.65,
                                  width: constraints.maxWidth * 0.6,
                                  child: GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1.8,
                                    ),
                                    itemCount: listsplit.length,
                                    itemBuilder: (context, index) {
                                      return GridTile(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              setState(() {
                                                listsplit[index]["Status"] ==
                                                        "Vacant"
                                                    ? posController
                                                            .isCombine.value =
                                                        !posController
                                                            .isCombine.value
                                                    : '';
                                              });
                                            },
                                            onTap: () async {
                                              if (listsplit[index]["Status"] ==
                                                  'Vacant') {
                                                Get.back();

                                                var result = await Get.to(
                                                    TabPosOrderPage(
                                                  orderType: 1,
                                                  sectionType: "Create",
                                                  uID: "",
                                                  tableHead: "Order",
                                                  splitID: listsplit[index]
                                                      ["id"]!,
                                                  cancelOrder:
                                                      posController.cancelOrder,
                                                  tableID: posController
                                                      .tablemergeData[
                                                          indexOfSelectedTable]
                                                      .id!,
                                                )); // Pass the value to POS Order Page
                                                // posController.selectedsplitIndex
                                                //     .value = 1000;
                                                posController.update();
                                              } else {
                                                posController
                                                    .selectsplitItem(index);
                                              }
                                            },
                                            child: Obx(
                                              () => Opacity(
                                                opacity: posController
                                                            .selectedsplitIndex
                                                            .value ==
                                                        index
                                                    ? 1
                                                    : posController
                                                                .selectedsplitIndex
                                                                .value ==
                                                            1000
                                                        ? 1
                                                        : 0.30,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: posController
                                                                  .selectedsplitIndex
                                                                  .value ==
                                                              index
                                                          ? Colors
                                                              .white // Highlight selected item
                                                          : Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border(
                                                              left: BorderSide(
                                                                color: _getBackgroundColor(
                                                                    listsplit[
                                                                            index]
                                                                        [
                                                                        "Status"]),
                                                                width: 4,
                                                              ),
                                                              right: const BorderSide(
                                                                  color: Color(
                                                                      0xffE9E9E9),
                                                                  width: 1),
                                                              bottom: const BorderSide(
                                                                  color: Color(
                                                                      0xffE9E9E9),
                                                                  width: 1),
                                                              top: const BorderSide(
                                                                  color: Color(
                                                                      0xffE9E9E9),
                                                                  width: 1),
                                                            ),
                                                          ),
                                                          child: GridTile(
                                                            footer: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      10.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                4),
                                                                    color: (_getBackgroundColor(
                                                                        listsplit[index]
                                                                            [
                                                                            "Status"]))),
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Text(
                                                                      listsplit[
                                                                              index]
                                                                          [
                                                                          "Status"],
                                                                      style:
                                                                          const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            header: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          '${listsplit[index]["TableName"]} ',
                                                                          // '${listsplit[index]["TableName"]} (${index + 1})',
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontSize:
                                                                                16.0,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                      Obx(
                                                                        () => posController.isCombine.value &&
                                                                                listsplit[index]["Status"] == "Vacant"
                                                                            ? Checkbox(
                                                                                side: const BorderSide(width: 1.0, color: Colors.grey),
                                                                                activeColor: const Color(0xFF03C1C1),
                                                                                checkColor: Colors.white,
                                                                                fillColor: WidgetStateProperty.all(const Color(0xFF03C1C1)),
                                                                                value: posController.selectList.contains(index),
                                                                                onChanged: (value) {
                                                                                  posController.checkedbtn(index);
                                                                                  log(index.toString());
                                                                                },
                                                                              )
                                                                            : IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  posController.returnOrderTime(
                                                                              listsplit[index]["OrderTime"].toString(),
                                                                              listsplit[index]["Status"]) !=
                                                                          ""
                                                                      ? Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              posController.returnOrderTime(listsplit[index]["orderTime"] ?? '', listsplit[index]["orderTime"] ?? ''),
                                                                              style: customisedStyle(context, const Color(0xff828282), FontWeight.w400, 12.0),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      : Container(),
                                                                ],
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  listsplit[index]
                                                                              [
                                                                              "Status"] ==
                                                                          "Vacant"
                                                                      ? const Text(
                                                                          "")
                                                                      : const Text(
                                                                          "To be paid:",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff757575),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize:
                                                                                10.0,
                                                                          ),
                                                                        ),
                                                                  listsplit[index]
                                                                              [
                                                                              "Status"] ==
                                                                          "Vacant"
                                                                      ? const Text(
                                                                          "")
                                                                      : Text(
                                                                          "${posController.currency} ${roundStringWith(listsplit[index]["Status"] != "Vacant" ? listsplit[index]["Status"] != "Paid" ? listsplit[index]["SalesOrderGrandTotal"].toString() : listsplit[index]["SalesGrandTotal"].toString() : '0')}",
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
                                                        ))),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Obx(
                                  () => posController
                                              .selectedsplitIndex.value !=
                                          1000
                                      ? Container(
                                          height: constraints.maxHeight * 0.65,
                                          width: constraints.maxWidth * 0.07,

                                          // color: Colors.blue.shade300,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color:
                                                          Color(0xFFE0E0E0)))),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  Get.back();
                                                  await posController.printSection(
                                                      context: context,
                                                      id: listsplit[posController.selectedsplitIndex.value]
                                                                  ["Status"] ==
                                                              'Ordered'
                                                          ? listsplit[posController
                                                                  .selectedsplitIndex
                                                                  .value]
                                                              ["SalesOrderID"]
                                                          : listsplit[posController
                                                                  .selectedsplitIndex
                                                                  .value]
                                                              ["SalesMasterID"],
                                                      isCancelled: false,
                                                      voucherType:
                                                          listsplit[posController.selectedsplitIndex.value]
                                                                      ["Status"] ==
                                                                  'Ordered'
                                                              ? "SO"
                                                              : "SI");

                                                  posController
                                                      .selectedsplitIndex
                                                      .value = 1000;
                                                  posController.update();
                                                },
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      elevation: 5,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF1E1F4E),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/printer_icon_menu.svg',
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Print",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w500,
                                                          10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  Get.back();
                                                  if (listsplit[posController
                                                          .selectedsplitIndex
                                                          .value]["Status"] ==
                                                      'Ordered') {
                                                    var result = await Get.to(
                                                        const CancelOrderList());
                                                    if (result != null) {
                                                      posController.cancelOrderApi(
                                                          context: context,
                                                          type: "Dining&Cancel",
                                                          tableID: listsplit[
                                                              posController
                                                                  .selectedsplitIndex
                                                                  .value]["id"],
                                                          cancelReasonId:
                                                              result[1],
                                                          orderID: listsplit[
                                                                  posController
                                                                      .selectedsplitIndex
                                                                      .value]
                                                              ["SalesOrderID"]);
                                                    }
                                                  } else {
                                                    posController.cancelOrderApi(
                                                        context: context,
                                                        type: "Dining",
                                                        tableID: listsplit[
                                                            posController
                                                                .selectedsplitIndex
                                                                .value]["id"],
                                                        cancelReasonId: "",
                                                        orderID: listsplit[
                                                                posController
                                                                    .selectedsplitIndex
                                                                    .value]
                                                            ["SalesOrderID"]);
                                                  }
                                                  posController
                                                      .selectedsplitIndex
                                                      .value = 1000;

                                                  print("cancel split");
                                                },
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      elevation: 5,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFFC3636),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/cancel_bottom_menu.svg',
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Cancel Order",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w500,
                                                          10.0),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.01),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  // showCustomDialog(
                                                  //   context: context,
                                                  //   status: posController.tablemergeData[index].status!,
                                                  //   salesOrderID: posController.tablemergeData[index].salesOrderID!,
                                                  //   orderID: posController.tablemergeData[index].id!,
                                                  //   salesMasterID: posController.tablemergeData[index].salesMasterID!,
                                                  //   orderType: 'dine',
                                                  //   orderTypeID: 1,
                                                  //   index: index,
                                                  // );

                                                  // Get.back();
                                                  // var result = await Get.to(TabPaymentSection(
                                                  //   uID: salesOrderID,
                                                  //   orderType: orderTypeID,
                                                  //   tableID: orderID,
                                                  //   type: orderType,
                                                  //   isData: false,
                                                  //   responseData: '',
                                                  // ));

                                                  Get.back();

                                                  if (posController
                                                      .pay_perm.value) {
                                                    Get.back();
                                                    var result = await Get.to(
                                                        TabPaymentSection(
                                                      splitID: listsplit[
                                                          posController
                                                              .selectedsplitIndex
                                                              .value]["id"],
                                                      uID: listsplit[posController
                                                              .selectedsplitIndex
                                                              .value]
                                                          ["SalesOrderID"],
                                                      orderType: 1,
                                                      tableID: listsplit[
                                                          posController
                                                              .selectedsplitIndex
                                                              .value]["Table"],
                                                      type: "dine",
                                                      isData: false,
                                                      responseData: '',
                                                    ));

                                                    posController.tablemergeData
                                                        .clear();
                                                    posController
                                                        .fetchAllData();
                                                    posController.update();
                                                  } else {
                                                    dialogBoxPermissionDenied(
                                                        context);
                                                  }
                                                  posController
                                                      .selectedsplitIndex
                                                      .value = 1000;
                                                },
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      elevation: 5,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF44B678),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/pay_bottom_menu.svg',
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Pay",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w500,
                                                          10.0),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.01),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  posController.printKOT(
                                                      cancelList: [],
                                                      isUpdate: false,
                                                      orderID: listsplit[
                                                              posController
                                                                  .selectedsplitIndex
                                                                  .value]
                                                          ["SalesOrderID"],
                                                      rePrint: true);

                                                  posController
                                                      .selectedsplitIndex
                                                      .value = 1000;
                                                  posController.update();
                                                  Get.back();
                                                },
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      elevation: 5,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFF17A2B8),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/kot_bottom_menu.svg',
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Kot",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w500,
                                                          10.0),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.01),
                                                  ],
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  print("d");
                                                },
                                                child: Column(
                                                  children: [
                                                    Material(
                                                      elevation: 5,
                                                      shape:
                                                          const CircleBorder(),
                                                      child: CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            const Color(
                                                                0xFFA561E8),
                                                        child: SvgPicture.asset(
                                                          'assets/svg/edit_bottom_menu.svg',
                                                          width: 50,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "Edit",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w500,
                                                          10.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (posController
                                                          .selectedIndexsplit >=
                                                      0 &&
                                                  posController
                                                          .selectedIndexsplit <
                                                      listsplit.length) ...[
                                                if (listsplit[posController
                                                        .selectedIndexsplit
                                                        .value]["Status"] ==
                                                    "Paid") ...[
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFF1E1F4E),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/printer_icon_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Print",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFFFC3636),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/cancel_bottom_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   listsplit[posController.selectedIndexsplit.value]["Status"] == "Paid" ? "Clear" : "Cancel Order",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                ] else ...[
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFF1E1F4E),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/printer_icon_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Print",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFFFC3636),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/cancel_bottom_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Cancel Order",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFF44B678),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/pay_bottom_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Pay",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFF17A2B8),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/kot_bottom_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Kot",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                  SizedBox(
                                                      height:
                                                          screenSize.height *
                                                              0.01),
                                                  // Material(
                                                  //   elevation: 5,
                                                  //   shape: const CircleBorder(),
                                                  //   child: CircleAvatar(
                                                  //     radius: 30,
                                                  //     backgroundColor: const Color(0xFFA561E8),
                                                  //     child: SvgPicture.asset(
                                                  //       'assets/svg/edit_bottom_menu.svg',
                                                  //       width: 30,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  // Text(
                                                  //   "Edit",
                                                  //   style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0),
                                                  // ),
                                                ],
                                              ] else
                                                ...[],
                                            ],
                                          ))
                                      : Container(),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.transparent),
                ),
                backgroundColor: Colors.grey[200],
              ),
            );
          },
        );
      },
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
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .20,
                                width: MediaQuery.of(context).size.width * .22,
                                child: DottedBorder(
                                  color: const Color(0xffC2C8D0),
                                  strokeWidth: 2,
                                  dashPattern: const [8, 4],
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(12),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () async {
                                        int index = 0;
                                        posController.takeAwayselectItem(index);
                                        var result =
                                            await Get.to(TabPosOrderPage(
                                          orderType: 2,
                                          sectionType: "Create",
                                          uID: "",
                                          splitID: "",
                                          tableHead: "Order",
                                          cancelOrder:
                                              posController.cancelOrder,
                                          tableID: "",
                                        ));

                                        if (result != null) {
                                          if (result[1]) {
                                            var resultPayment =
                                                await Get.to(TabPaymentSection(
                                              uID: result[2],
                                              tableID: '',
                                              splitID: "",
                                              orderType: 2,
                                              type: '',
                                              isData: false,
                                              responseData: '',
                                            ));
                                            posController.takeAwayOrders
                                                .clear();
                                            posController.fetchTOC();
                                            posController.update();
                                          } else {
                                            posController.takeAwayOrders
                                                .clear();
                                            posController.fetchTOC();
                                            posController.update();
                                          }
                                        } else {
                                          posController.takeAwayOrders.clear();
                                          posController.fetchTOC();
                                          posController.update();
                                        }
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
                                ),
                              ),
                            ],
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                              childAspectRatio: 2.0,
                            ),
                            itemCount: posController.takeAwayOrders.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  posController.takeAwayOrders.length) {
                                print("index -------$index");
                                return DottedBorder(
                                  color: const Color(0xffC2C8D0),
                                  // Border color
                                  strokeWidth: 2,
                                  // Border width
                                  dashPattern: const [8, 4],
                                  // Length of the dash and the space between dashes
                                  borderType: BorderType.RRect,
                                  // Shape of the border, can also be BorderType.Circle
                                  radius: const Radius.circular(12),
                                  // Radius for rounded corners
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                      onTap: () async {
                                        var result =
                                            await Get.to(TabPosOrderPage(
                                          orderType: 2,
                                          sectionType: "Create",
                                          uID: "",
                                          tableHead: "Order",
                                          splitID: "",
                                          cancelOrder:
                                              posController.cancelOrder,
                                          tableID: "",
                                        ));

                                        if (result != null) {
                                          // pr("--result----$result---");
                                          // pr("-*----------------------------------------------------------");
                                          // pr("--result----${result[5]}---");
                                          // pr("-*----------------------------------------------------------");
                                          if (result[1]) {
                                            var resultPayment =
                                                await Get.to(TabPaymentSection(
                                              uID: result[2],
                                              tableID: '',
                                              orderType: 2,
                                              type: '',
                                              splitID: "",
                                              isData: true,
                                              responseData: result[5],
                                            ));
                                            posController.takeAwayOrders
                                                .clear();
                                            posController.fetchTOC();
                                            posController.update();
                                          } else {
                                            posController.takeAwayOrders
                                                .clear();
                                            posController.fetchTOC();
                                            posController.update();
                                          }
                                        } else {
                                          posController.takeAwayOrders.clear();
                                          posController.fetchTOC();
                                          posController.update();
                                        }
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
                                    posController.takeAwayselectItem(index);

                                    showCustomDialog(
                                        context: context,
                                        status: posController
                                            .takeAwayOrders[index].status!,
                                        salesOrderID: posController
                                            .takeAwayOrders[index]
                                            .salesOrderID!,
                                        orderID: '',
                                        salesMasterID: posController
                                            .takeAwayOrders[index].salesID!,
                                        orderType: 'takeaway',
                                        orderTypeID: 2,
                                        index: index);
                                  },
                                  child: Obx(
                                    () => Opacity(
                                      opacity: posController
                                                  .takeawayselectedIndex
                                                  .value ==
                                              index
                                          ? 1
                                          : posController.takeawayselectedIndex
                                                      .value ==
                                                  1000
                                              ? 1
                                              : 0.30,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: posController
                                                        .takeawayselectedIndex
                                                        .value ==
                                                    index
                                                ? Colors
                                                    .white // Highlight selected item
                                                : Colors.white.withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: _getBackgroundColor(
                                                          posController
                                                              .takeAwayOrders[
                                                                  index]
                                                              .status!),
                                                      width: 3,
                                                    ),
                                                    right: const BorderSide(
                                                        color:
                                                            Color(0xffE9E9E9),
                                                        width: 1),
                                                    bottom: const BorderSide(
                                                        color:
                                                            Color(0xffE9E9E9),
                                                        width: 1),
                                                    top: const BorderSide(
                                                        color:
                                                            Color(0xffE9E9E9),
                                                        width: 1),
                                                  ),
                                                ),
                                                child: GridTile(
                                                  footer: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: (_getBackgroundColor(
                                                              posController
                                                                  .takeAwayOrders[
                                                                      index]
                                                                  .status))),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            posController
                                                                .takeAwayOrders[
                                                                    index]
                                                                .status!,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 14.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  header: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Parcel ${posController.takeAwayOrders[index].tokenNumber!}",

                                                              /// "Parcel ${index + 1} -",
                                                              style:
                                                                  customisedStyle(
                                                                      context,
                                                                      Colors
                                                                          .black,
                                                                      FontWeight
                                                                          .w500,
                                                                      15.0),
                                                            ),
                                                            Text(
                                                              posController.returnOrderTime(
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
                                                                  const Color(
                                                                      0xff00775E),
                                                                  FontWeight
                                                                      .w400,
                                                                  10.0),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          posController
                                                              .takeAwayOrders[
                                                                  index]
                                                              .customerName!,
                                                          style: customisedStyle(
                                                              context,
                                                              const Color(
                                                                  0xff828282),
                                                              FontWeight.w400,
                                                              12.0),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 8,
                                                            bottom: 8,
                                                            top: 15),
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
                                                              "Token: ",
                                                              style:
                                                                  customisedStyle(
                                                                context,
                                                                const Color(
                                                                    0xff757575),
                                                                FontWeight.w400,
                                                                10.0,
                                                              ),
                                                            ),
                                                            Text(
                                                              posController
                                                                  .takeAwayOrders[
                                                                      index]
                                                                  .tokenNumber!,
                                                              style:
                                                                  customisedStyle(
                                                                      context,
                                                                      Colors
                                                                          .black,
                                                                      FontWeight
                                                                          .w400,
                                                                      14.0),
                                                            )
                                                          ],
                                                        ),
                                                        Text(
                                                          "${posController.currency} ${roundStringWith(posController.takeAwayOrders[index].salesOrderGrandTotal!)}",
                                                          style:
                                                              customisedStyle(
                                                                  context,
                                                                  Colors.black,
                                                                  FontWeight
                                                                      .w500,
                                                                  15.0),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ))),
                                    ),
                                  ));
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
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .20,
                            width: MediaQuery.of(context).size.width * .22,
                            child: DottedBorder(
                              color: const Color(0xffC2C8D0),
                              strokeWidth: 2,
                              dashPattern: const [8, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 4,
                                      sectionType: "Create",
                                      uID: "",
                                      splitID: "",
                                      tableHead: "Order",
                                      cancelOrder: posController.cancelOrder,
                                      tableID: "",
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        var resultPayment =
                                            await Get.to(TabPaymentSection(
                                          uID: result[2],
                                          tableID: '',
                                          orderType: 4,
                                          splitID: "",
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));
                                        posController.carOrders.clear();
                                        posController.fetchTOC();
                                        posController.update();
                                      } else {
                                        posController.carOrders.clear();
                                        posController.fetchTOC();
                                        posController.update();
                                      }
                                    } else {
                                      posController.carOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    }

                                    // var result = await Get.to(TabPosOrderPage(
                                    //   orderType: 4,
                                    //   sectionType: "Create",
                                    //   uID: "",
                                    //   tableHead: "Order",
                                    //   cancelOrder: posController.cancelOrder,
                                    //   tableID: "",
                                    // ));
                                    //
                                    // posController.carOrders.clear();
                                    // posController.fetchAllData();
                                    // posController.update();

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
                            ),
                          ),
                        ],
                      )
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
                              dashPattern: const [8, 4],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(12),
                              child: Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () async {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 4,
                                      sectionType: "Create",
                                      uID: "",
                                      splitID: "",
                                      tableHead: "Order",
                                      cancelOrder: posController.cancelOrder,
                                      tableID: "",
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        var resultPayment =
                                            await Get.to(TabPaymentSection(
                                          uID: result[2],
                                          tableID: '',
                                          orderType: 4,
                                          splitID: "",
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));
                                        posController.carOrders.clear();
                                        posController.fetchTOC();
                                        posController.update();
                                      } else {
                                        posController.carOrders.clear();
                                        posController.fetchTOC();
                                        posController.update();
                                      }
                                    } else {
                                      posController.carOrders.clear();
                                      posController.fetchTOC();
                                      posController.update();
                                    }

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
                          return GestureDetector(
                              onTap: () {
                                posController.carSelectItem(index);

                                showCustomDialog(
                                    index: index,
                                    context: context,
                                    status:
                                        posController.carOrders[index].status!,
                                    salesOrderID: posController
                                        .carOrders[index].salesOrderID!,
                                    orderID: '',
                                    salesMasterID:
                                        posController.carOrders[index].salesID!,
                                    orderType: 'car',
                                    orderTypeID: 4);
                              },
                              child: Obx(
                                () => Opacity(
                                  opacity: posController
                                              .carselectedIndex.value ==
                                          index
                                      ? 1
                                      : posController.carselectedIndex.value ==
                                              1000
                                          ? 1
                                          : 0.30,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: posController
                                                  .carselectedIndex.value ==
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
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                        )),
                                  ),
                                ),
                              ));
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
          topRight: Radius.circular(10.0),
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
              child: SizedBox(
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
              child: SizedBox(
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
                    if (posController.customerNameController.text
                        .trim()
                        .isEmpty) {
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

  // Future<void> bottom() {
  //   return showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (context) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(
  //             horizontal: MediaQuery.of(context).size.width * 0.25),
  //         child: GestureDetector(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //             decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.all(Radius.circular(50))),
  //             height: MediaQuery.of(context).size.height * 0.25,
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Material(
  //                             elevation: 5,
  //                             shape: const CircleBorder(),
  //                             child: CircleAvatar(
  //                               radius: 30,
  //                               backgroundColor: const Color(0xFF1E1F4E),
  //                               child: SvgPicture.asset(
  //                                 'assets/png/image5.png',
  //                                 width: 30,
  //                               ),
  //                             ),
  //                           ),
  //                           const Text("Print")
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Column(
  //                         children: [
  //                           Material(
  //                             elevation: 5,
  //                             shape: const CircleBorder(),
  //                             child: CircleAvatar(
  //                               radius: 30,
  //                               backgroundColor: const Color(0xFFFC3636),
  //                               child: SvgPicture.asset(
  //                                 'assets/png/image5.png',
  //                                 width: 30,
  //                               ),
  //                             ),
  //                           ),
  //                           const Text("Cancel Order")
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Column(
  //                         children: [
  //                           Material(
  //                             elevation: 5,
  //                             shape: const CircleBorder(),
  //                             child: CircleAvatar(
  //                               radius: 30,
  //                               backgroundColor: const Color(0xFF44B678),
  //                               child: SvgPicture.asset(
  //                                 'assets/png/image5.png',
  //                                 width: 30,
  //                               ),
  //                             ),
  //                           ),
  //                           const Text("Pay")
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Column(
  //                         children: [
  //                           Material(
  //                             elevation: 5,
  //                             shape: const CircleBorder(),
  //                             child: CircleAvatar(
  //                               radius: 30,
  //                               backgroundColor: const Color(0xFFA561E8),
  //                               child: SvgPicture.asset(
  //                                 'assets/png/image5.png',
  //                                 width: 30,
  //                               ),
  //                             ),
  //                           ),
  //                           const Text("Kot")
  //                         ],
  //                       ),
  //                       SizedBox(
  //                         width: MediaQuery.of(context).size.width * 0.02,
  //                       ),
  //                       Column(
  //                         children: [
  //                           Material(
  //                             elevation: 5,
  //                             shape: const CircleBorder(),
  //                             child: CircleAvatar(
  //                               radius: 30,
  //                               backgroundColor: const Color(0xFF17A2B8),
  //                               child: SvgPicture.asset(
  //                                 'assets/png/image5.png',
  //                                 width: 30,
  //                               ),
  //                             ),
  //                           ),
  //                           const Text("Edit")
  //                         ],
  //                       ),
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
  /// 100001
  Future<void> showCustomDialog({
    required BuildContext context,
    required String status,
    required String salesOrderID,
    required String orderID,
    required String orderType,
    required int orderTypeID,
    required String salesMasterID,
    required int index,
  }) {
    return showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      // barrierColor: Colors.grey.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 100),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .4,
              ),
              height: MediaQuery.of(context).size.height * .15,
              decoration: BoxDecoration(
                color: const Color(0xffffffff),
                borderRadius: BorderRadius.circular(80),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    status == 'Ordered' || status == 'Paid'
                        ? SelectIcon(
                            color: const Color(0xff1E1F4E),
                            assetName: 'assets/svg/printer_icon_menu.svg',
                            text: 'Print',
                            type: 'print',
                            onPressed: () {
                              Get.back();
                              posController.printSection(
                                  context: context,
                                  id: status == 'Ordered'
                                      ? salesOrderID
                                      : salesMasterID,
                                  isCancelled: false,
                                  voucherType:
                                      status == 'Ordered' ? "SO" : "SI");
                              posController.selectItem(index);
                            },
                          )
                        : Container(),
                    status == 'Ordered' &&
                            posController.kitchen_print_perm.value
                        ? SelectIcon(
                            color: const Color(0xffA561E8),
                            assetName: 'assets/svg/kot_bottom_menu.svg',
                            text: 'KOT',
                            type: 'kot',
                            onPressed: () {
                              Get.back();

                              posController.printKOT(
                                  cancelList: [],
                                  isUpdate: false,
                                  orderID: salesOrderID,
                                  rePrint: true);
                            },
                          )
                        : Container(),
                    status == 'Ordered'
                        ? SelectIcon(
                            color: const Color(0xff44B678),
                            assetName: 'assets/svg/pay_bottom_menu.svg',
                            text: 'Pay',
                            type: 'pay',
                            onPressed: () async {
                              if (posController.pay_perm.value) {
                                Get.back();
                                var result = await Get.to(TabPaymentSection(
                                  uID: salesOrderID,
                                  orderType: orderTypeID,
                                  splitID: "",
                                  tableID: orderID,
                                  type: orderType,
                                  isData: false,
                                  responseData: '',
                                ));

                                posController.tablemergeData.clear();
                                posController.takeAwayOrders.clear();
                                posController.onlineOrders.clear();
                                posController.carOrders.clear();
                                posController.fetchAllData();
                                posController.update();
                              } else {
                                dialogBoxPermissionDenied(context);
                              }
                            },
                          )
                        : Container(),
                    status == 'Ordered' || status == 'Paid'
                        ? SelectIcon(
                            color: const Color(0xffFC3636),
                            assetName: 'assets/svg/cancel_bottom_menu.svg',
                            text: status == 'Paid' ? 'Clear' : 'Cancel',
                            type: 'cancel',
                            onPressed: () async {
                              Get.back();
                              if (orderType == 'dine') {
                                if (status == 'Ordered') {
                                  var result =
                                      await Get.to(const CancelOrderList());
                                  if (result != null) {
                                    posController.cancelOrderApi(
                                        context: context,
                                        type: "Dining&Cancel",
                                        tableID: orderID,
                                        cancelReasonId: result[1],
                                        orderID: salesOrderID);
                                  }
                                } else {
                                  posController.cancelOrderApi(
                                      context: context,
                                      type: "Dining",
                                      tableID: orderID,
                                      cancelReasonId: "",
                                      orderID: salesOrderID);
                                }
                              } else if (orderType == 'takeaway') {
                                if (status == 'Ordered') {
                                  if (posController.print_perm.value) {
                                    var result =
                                        await Get.to(const CancelOrderList());
                                    if (result != null) {
                                      posController.cancelOrderApi(
                                          context: context,
                                          type: "Cancel",
                                          tableID: "",
                                          cancelReasonId: result[1],
                                          orderID: salesOrderID);
                                    }
                                  } else {
                                    dialogBoxPermissionDenied(context);
                                  }
                                } else {
                                  posController.cancelOrderApi(
                                      context: context,
                                      type: "TakeAway",
                                      tableID: "",
                                      cancelReasonId: "",
                                      orderID: salesOrderID);
                                }
                              } else if (orderType == 'car') {
                                if (status == 'Ordered') {
                                  if (posController.print_perm.value) {
                                    var result =
                                        await Get.to(const CancelOrderList());
                                    if (result != null) {
                                      posController.cancelOrderApi(
                                          context: context,
                                          type: "Cancel",
                                          tableID: "",
                                          cancelReasonId: result[1],
                                          orderID: salesOrderID);
                                    }
                                  } else {
                                    dialogBoxPermissionDenied(context);
                                  }
                                } else {
                                  posController.cancelOrderApi(
                                      context: context,
                                      type: "Car",
                                      tableID: "",
                                      cancelReasonId: "",
                                      orderID: salesOrderID);
                                }
                              } else if (orderType == 'online') {
                                if (status == 'Ordered') {
                                  log("orderType");
                                  pr("typedddd $orderType");
                                  if (posController.print_perm.value) {
                                    var result =
                                        await Get.to(const CancelOrderList());
                                    if (result != null) {
                                      posController.cancelOrderApi(
                                          context: context,
                                          type: "Cancel",
                                          tableID: "",
                                          cancelReasonId: result[1],
                                          orderID: salesOrderID);
                                    }
                                  } else {
                                    dialogBoxPermissionDenied(context);
                                  }
                                } else {
                                  posController.cancelOrderApi(
                                      context: context,
                                      type: "Online",
                                      tableID: "",
                                      cancelReasonId: "",
                                      orderID: salesOrderID);
                                }
                              }
                            },
                          )
                        : Container(),
                    status == 'Ordered'
                        ? SelectIcon(
                            color: const Color(0xff17A2B8),
                            assetName: 'assets/svg/edit_bottom_menu.svg',
                            text: 'Edit',
                            type: 'edit',
                            onPressed: () async {
                              Get.back();

                              if (orderType == 'dine') {
                                if (status == 'Ordered') {
                                  if (posController.dining_edit_perm.value) {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 1,
                                      sectionType: "Edit",
                                      uID: salesOrderID,
                                      tableHead: '',
                                      splitID: "",
                                      tableID: orderID,
                                      cancelOrder: const [],
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        var res =
                                            await Get.to(TabPaymentSection(
                                          uID: result[2],
                                          tableID: orderID,
                                          splitID: "",
                                          orderType: 1,
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));

                                        posController.tablemergeData.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      } else {
                                        posController.tablemergeData.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      }
                                    }
                                  } else {
                                    dialogBoxPermissionDenied(context);
                                  }
                                }
                              } else if (orderType == 'car') {
                                if (posController.car_edit_perm.value) {
                                  if (status == 'Ordered') {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 4,
                                      sectionType: "Edit",
                                      splitID: "",
                                      uID: salesOrderID,
                                      tableHead: "Parcel",
                                      tableID: "",
                                      cancelOrder: const [],
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        Get.to(TabPaymentSection(
                                          uID: result[2],
                                          splitID: "",
                                          tableID: salesOrderID,
                                          orderType: 4,
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));
                                      } else {
                                        posController.carOrders.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      }
                                    }
                                  }
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              } else if (orderType == 'takeaway') {
                                if (posController.take_away_edit_perm.value) {
                                  if (status == 'Ordered') {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 2,
                                      sectionType: "Edit",
                                      uID: salesOrderID,
                                      splitID: "",
                                      tableHead: "Parcel",
                                      tableID: "",
                                      cancelOrder: const [],
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        Get.to(TabPaymentSection(
                                          uID: result[2],
                                          splitID: "",
                                          tableID: salesOrderID,
                                          orderType: 2,
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));
                                      } else {
                                        posController.takeAwayOrders.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      }
                                    }
                                  }
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              } else if (orderType == 'online') {
                                if (posController.online_edit_perm.value) {
                                  if (status == 'Ordered') {
                                    var result = await Get.to(TabPosOrderPage(
                                      orderType: 3,
                                      sectionType: "Edit",
                                      uID: salesOrderID,
                                      splitID: "",
                                      tableHead: "Parcel",
                                      tableID: "",
                                      cancelOrder: const [],
                                    ));

                                    if (result != null) {
                                      if (result[1]) {
                                        Get.to(TabPaymentSection(
                                          uID: result[2],
                                          tableID: salesOrderID,
                                          splitID: "",
                                          orderType: 3,
                                          type: '',
                                          isData: false,
                                          responseData: '',
                                        ));
                                      } else {
                                        posController.onlineOrders.clear();
                                        posController.fetchAllData();
                                        posController.update();
                                      }
                                    }
                                  }
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              }
                            },
                          )
                        : Container(),
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
    ).then(
      (value) {
        posController.selectedIndex.value = 1000;
        posController.takeawayselectedIndex.value = 1000;
        posController.onlineselectedIndex.value = 1000;
        posController.carselectedIndex.value = 1000;
        posController.tablemodalselectedIndex.value = 1000;
        posController.selectedsplitIndex.value = 1000;
      },
    );
  }
}

class IconWithText extends StatelessWidget {
  final String assetName;
  final String text;
  final String type; // Type identifier
  final VoidCallback onPressed; // Callback for the press action

  const IconWithText({
    super.key,
    required this.assetName,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final POSController controller =
        Get.put(POSController()); // Access the GetX controller

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
  final Color color;
  final String type; // Type identifier
  final VoidCallback onPressed; // Callback for the press action

  const SelectIcon({
    super.key,
    required this.color,
    required this.assetName,
    required this.text,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final POSController controller = Get.find(); // Access the GetX controller

    return Obx(() {
      final isSelected = controller.selectedType.value == type;

      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: GestureDetector(
          onTap: () {
            controller.selectCurrentAction(type); // Update the selected type
            onPressed(); // Execute the onPressed callback
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70, // Adjust width as per your need
                height: 70, // Adjust height as per your need
                decoration: BoxDecoration(
                  color: color, // Circle color
                  shape: BoxShape.circle, // Ensures the container is a circle
                ),
                child: SvgPicture.asset(
                  assetName,
                  fit: BoxFit
                      .scaleDown, // Adjust BoxFit to your need, such as contain, cover, or fitWidth
                ),
              ),
              // Container(
              //   color: Colors.red,
              //   child: Image.asset(
              //     assetName,
              //     fit: BoxFit.fitWidth,
              //     height: MediaQuery.of(context).size.height * .12,
              //     width: MediaQuery.of(context).size.width * .060,
              //   ),
              // ),
              Container(
                //   color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    text,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 11.0),
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
