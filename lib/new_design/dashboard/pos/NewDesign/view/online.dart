import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/online_platforms/controller/online_platform_controller.dart';

class OnlinePage extends StatefulWidget {
  final String title;
  final List<dynamic> data;

  const OnlinePage({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  State<OnlinePage> createState() => _OnlinePageState();
}

class _OnlinePageState extends State<OnlinePage> {

  final POSController onlineController = Get.put(POSController());
  OnlinePlatformController onlinePlatformController =
      Get.put(OnlinePlatformController());

  Color _getBackgroundColor(String? status) {
    if (status == 'Vacant') {
      return Color(0xffEFEFEF); // Set your desired color for pending status
    } else if (status == 'Ordered') {
      return Color(0xff03C1C1); // Set your desired color for completed status
    } else if (status == 'Paid') {
      return Color(0xff10C103); // Set your desired color for cancelled status
    } else if (status == 'Billed') {
      return Color(0xff034FC1); // Set your desired color for cancelled status
    } else {
      return Color(0xffEFEFEF); // Default color if status is not recognized
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    onlineController.carOrders.clear();
    onlineController.fetchAllData();
    onlineController.update();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            'Online'.tr,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          actions: [
            GestureDetector(
              child: Text(
                'Manager'.tr,
                style: customisedStyle(
                    context, Color(0xffF25F29), FontWeight.w400, 13.0),
              ),
            ),
            IconButton(
                onPressed: () {_asyncConfirmDialog(context);},
                icon: SvgPicture.asset('assets/svg/logout_mob.svg'))
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 19,
              child: ValueListenableBuilder<int>(
                valueListenable: onlineController.carItemSelectedNotifier,
                builder: (context, selectedIndex, child) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: onlinePlatformController.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            onlineController.carItemSelectedNotifier.value =
                                index; // Update the selected index
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 5,
                            decoration: BoxDecoration(
                              color: selectedIndex == index
                                  ? const Color(0xffF25F29)
                                  : const Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  onlinePlatformController
                                      .dataList[index].name!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selectedIndex == index
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Expanded(
              child: Obx(() => onlineController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : onlineController.onlineOrders.isEmpty
                      ? Center(child: const Text("No recent orders"))
                      : ListView.builder(
                          itemCount: onlineController.carOrders.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15, top: 5, bottom: 5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Text(
                                                      "Order ${index + 1} ",
                                                      style: customisedStyle(
                                                          context,
                                                          Colors.black,
                                                          FontWeight.w400,
                                                          15.0),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              32,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: _getBackgroundColor(
                                                                onlineController
                                                                    .takeAwayOrders[
                                                                        index]
                                                                    .status!),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10),
                                                              child: Text(
                                                                onlineController
                                                                    .takeAwayOrders[
                                                                        index]
                                                                    .status!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: onlineController.takeAwayOrders[index].status ==
                                                                            "Vacant"
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8.0),
                                                        child: GestureDetector(
                                                          onTap: () {},
                                                          child: Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                32,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xffEFEFEF),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10),
                                                                child: Text(
                                                                  POSController
                                                                      .carItems[1],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Text(
                                                      onlineController
                                                          .takeAwayOrders[index]
                                                          .customerName!,
                                                      style: customisedStyle(
                                                          context,
                                                          Color(0xffA0A0A0),
                                                          FontWeight.w400,
                                                          13.0),
                                                    ),
                                                  ),
                                                  Text(
                                                    onlineController
                                                        .returnOrderTime(
                                                            onlineController
                                                                .takeAwayOrders[
                                                                    index]
                                                                .orderTime!,
                                                            onlineController
                                                                .takeAwayOrders[
                                                                    index]
                                                                .status!),
                                                    style: customisedStyle(
                                                        context,
                                                        const Color(0xff00775E),
                                                        FontWeight.w400,
                                                        13.0),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Text(
                                            roundStringWith(onlineController
                                                .takeAwayOrders[index]
                                                .salesOrderGrandTotal!),
                                            style: customisedStyle(
                                                context,
                                                Colors.black,
                                                FontWeight.w500,
                                                15.0),
                                          )
                                        ],
                                      ),
                                    ),
                                    DividerStyle()
                                  ],
                                ),
                              ),
                            );
                          },
                        )))
        ]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffFFF6F2))),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: Color(0xffF25F29),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Text(
                          'Add_Order'.tr,
                          style: customisedStyle(context,
                              const Color(0xffF25F29), FontWeight.normal, 12.0),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        )
    );
  }

  void addCategory() {
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
                    "Add a Category",
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
                  controller: onlineController.categoryNameController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  focusNode: onlineController.categoryNode,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(onlineController.saveFocusNode);
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(
                      hintTextStr: 'Category Name'),
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
    );
  }
}
enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'msg6'.tr,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: TextStyle(color: Colors.red)),
            onPressed: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.setBool('isLoggedIn', false);
              // prefs.setBool('companySelected', false);

              // Navigator.of(context).pushAndRemoveUntil(
              //   CupertinoPageRoute(builder: (context) => LoginPageNew()),
              //       (_) => false,
              // );
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
