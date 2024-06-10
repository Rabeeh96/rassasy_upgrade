import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/cancel_reason_list.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/reservation_list.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'order/add_order_page.dart';
import 'payment/payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiningPage extends StatefulWidget {
  final String title;
  final List<dynamic> data;

  const DiningPage({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  State<DiningPage> createState() => _DiningPageState();
}

class _DiningPageState extends State<DiningPage> {
  final POSController diningController = Get.put(POSController());
  final POSController posController = Get.put(POSController());
  ///this func used to get the colors
  ///to change back color of status showing in list
  Color _getBackgroundColor(String? status) {
    if (status == 'Vacant') {
      return const Color(0xffEFEFEF); // Set your desired color for pending status
    } else if (status == 'Ordered') {
      return const Color(0xff03C1C1); // Set your desired color for completed status
    } else if (status == 'Paid') {
      return const Color(0xff10C103); // Set your desired color for cancelled status
    } else if (status == 'Billed') {
      return const Color(0xff034FC1); // Set your desired color for cancelled status
    } else {
      return const Color(0xffEFEFEF); // Default color if status is not recognized
    }
  }

  @override
  void initState() {
    /// TODO: implement initState
    super.initState();
    diningController.selectedIndexNotifier.value = 0;
    diningController.tableData.clear();
    diningController.fetchAllData();
    diningController.update();
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dining'.tr,
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Text(
              'Manager'.tr,
              style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 13.0),
            ),
          ),
          IconButton(
              onPressed: () {
                _asyncConfirmDialog(context);
              },
              icon: SvgPicture.asset('assets/svg/logout_mob.svg'))
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 19,
            child: ValueListenableBuilder<int>(
              valueListenable: diningController.selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: POSController.labels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          diningController.selectedIndexNotifier.value = index; // Update the selected index

                          if(index ==0){
                            diningController.tableData.clear();
                            diningController.tableData.assignAll(diningController.fullOrderData);

                          }
                          else if(index ==1){
                            diningController.tableData.clear();
                            diningController.tableData.value = diningController.fullOrderData.where((data) => data.status == "Vacant").toList();

                          }
                          else if(index ==2){
                            diningController.tableData.clear();
                            diningController.tableData.value = diningController.fullOrderData.where((data) => data.status == "Ordered").toList();
                          }
                          else{
                            diningController.tableData.clear();
                            diningController.tableData.value = diningController.fullOrderData.where((data) => data.status == "Paid").toList();

                          }

                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          decoration: BoxDecoration(
                            color: selectedIndex == index ? const Color(0xffF25F29) : const Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                              child: Text(
                                POSController.labels[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selectedIndex == index ? Colors.white : Colors.grey,
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
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        //   child: Container(
        //     height: 1,
        //     color: const Color(0xffE9E9E9),
        //   ),
        // ),
        DividerStyle(),
        Expanded(
            child: Obx(() => diningController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : diningController.tableData.isEmpty
                    ? const Center(child: Text("No recent orders"))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: RefreshIndicator(
                          onRefresh: ()async{
                            diningController.selectedIndexNotifier.value = 0;
                            diningController.tableData.clear();
                            diningController.fetchAllData();
                            diningController.update();
                          },
                          child: ListView.separated(
                            separatorBuilder: (context, index) => DividerStyle(),
                            itemCount: diningController.tableData.length,
                            itemBuilder: (context, index) {
                              return Slidable(
                                enabled: diningController.tableData[index].status != 'Vacant' ? true : false,
                                key: ValueKey(diningController.tableData[index]),

                                // The start action pane is the one at the left or the top side.
                                startActionPane: ActionPane(
                                  // A motion is a widget used to control how the pane animates.
                                  motion: const ScrollMotion(),

                                  children: [
                                    diningController.tableData[index].status == 'Ordered'?  CustomSlidableAction(
                                      flex: 1,
                                      onPressed: (BuildContext context) async {
                                        posController.printKOT(cancelList: [],isUpdate:false,orderID:diningController.tableData[index].salesOrderID!,rePrint:true);
                                      },
                                      backgroundColor: const Color(0xFF00775E),
                                      foregroundColor: Colors.green,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/kot_print.svg',
                                            height: 25,
                                            width: 25,
                                            //
                                          ),
                                          Text("Kot", style: customisedStyleBold(context, Colors.white, FontWeight.w400, 12.0))
                                        ],
                                      ),
                                    ):Container(),
                                    CustomSlidableAction(
                                      flex: 1,
                                      onPressed: (BuildContext context) async {
                                        diningController.printSection(
                                            context: context,
                                            id: diningController.tableData[index].status == 'Ordered'
                                                ? diningController.tableData[index].salesOrderID!
                                                : diningController.tableData[index].salesMasterID!,
                                            isCancelled: false,
                                            voucherType: diningController.tableData[index].status == 'Ordered'?"SO":"SI");
                                      },
                                      backgroundColor: const Color(0xFF034FC1),
                                      foregroundColor: Colors.green,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/svg/print.svg',
                                            height: 23,
                                            width: 23,
                                            //
                                          ),
                                          Text(
                                            "Print",
                                            style: customisedStyle(context, Colors.white, FontWeight.w400, 12.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                endActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    CustomSlidableAction(
                                      onPressed: (BuildContext context) async {


                                        if (diningController.tableData[index].status == 'Ordered') {
                                          var result = await Get.to(CancelOrderList());
                                          if (result != null) {
                                            diningController.cancelOrderApi(
                                                context:context,
                                                type: "Dining&Cancel",
                                                tableID: diningController.tableData[index].id!,
                                                cancelReasonId: result[1],
                                                orderID: diningController.tableData[index].salesOrderID!);
                                          }
                                        } else {
                                          diningController.cancelOrderApi(
                                              context:context,
                                              type: "Dining", tableID: diningController.tableData[index].id!, cancelReasonId: "", orderID: diningController.tableData[index].salesOrderID!);
                                        }
                                      },
                                      backgroundColor: const Color(0xFFFC3636),
                                      foregroundColor: Colors.green,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [



                                          const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            diningController.tableData[index].status == 'Ordered' ? "Cancel" : "Clear",
                                            style: customisedStyle(context, Colors.white, FontWeight.w400, 10.0),
                                          )
                                        ],
                                      ),
                                    ),

                                    diningController.tableData[index].status == 'Ordered'
                                        ? CustomSlidableAction(
                                            onPressed: (BuildContext context) async {
                                              var resultPayment = await Get.to(PaymentPage(
                                                uID: diningController.tableData[index].salesOrderID!,
                                                tableID: diningController.tableData[index].id!,
                                                orderType: 0,
                                              ));

                                              diningController.tableData.clear();
                                              diningController.fetchAllData();
                                              diningController.update();
                                            },
                                            backgroundColor: const Color(0xFF10C103),
                                            foregroundColor: Colors.green,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const Icon(

                                                  Icons.check,
                                                  color: Colors.white,

                                                ),
                                                Text(
                                                  "Pay",
                                                  style: customisedStyle(context, Colors.white, FontWeight.w400, 10.0),
                                                )
                                              ],
                                            ),
                                          )
                                        : Container(),

                                    ///kot commented here
                                    // CustomSlidableAction(
                                    //
                                    //   onPressed: (BuildContext context) async {},
                                    //   backgroundColor: const Color(0xFF0C98FF),
                                    //   foregroundColor: Colors.green,
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     crossAxisAlignment: CrossAxisAlignment.center,
                                    //     children: [
                                    //       SvgPicture.asset("assets/svg/edit_new.svg"),
                                    //       Text("KOT",style: customisedStyle(context, Colors.white, FontWeight.w400, 10.0),)
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),

                                child: GestureDetector(
                                  onTap: () async {
                                    if (diningController.tableData[index].status == 'Vacant') {
                                      var result = await Get.to(OrderCreateView(
                                        orderType: 1,
                                        sectionType: "Create",
                                        uID: "",
                                        tableHead: "Order",
                                        cancelOrder: diningController.cancelOrder,
                                        tableID: diningController.tableData[index].id!,
                                      ));

                                      if (result != null) {
                                        if (result[1]) {
                                          var resultPayment = await Get.to(PaymentPage(
                                            uID: result[2],
                                            tableID: diningController.tableData[index].id!,
                                            orderType: 0,
                                          ));
                                          diningController.tableData.clear();
                                          diningController.fetchAllData();
                                          diningController.update();
                                        } else {
                                          diningController.tableData.clear();
                                          diningController.fetchAllData();
                                          diningController.update();
                                        }
                                      }
                                    } else if (diningController.tableData[index].status == 'Ordered') {
                                      var result = await Get.to(OrderCreateView(
                                        orderType: 1,
                                        sectionType: "Edit",
                                        uID: diningController.tableData[index].salesOrderID!,
                                        tableHead: diningController.tableData[index].title!,
                                        tableID: diningController.tableData[index].id!,
                                        cancelOrder: diningController.cancelOrder,
                                      ));

                                      if (result != null) {
                                        if (result[1]) {
                                          Get.to(PaymentPage(
                                            uID: result[2],
                                            tableID: diningController.tableData[index].id!,
                                            orderType: 1,
                                          ));
                                        }
                                      }
                                    } else {}
                                  },
                                  child: InkWell(
                                    child: Padding(
                                        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 15, bottom: 15),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Text(
                                                        diningController.tableData[index].title!,
                                                        style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: MediaQuery.of(context).size.height / 32,
                                                      decoration: BoxDecoration(
                                                        color: _getBackgroundColor(diningController.tableData[index].status!),
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                                                          child: Text(
                                                            diningController.tableData[index].status!,
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    diningController.tableData[index].status == "Vacant" ? Colors.black : Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                diningController.returnOrderTime(
                                                            diningController.tableData[index].orderTime!, diningController.tableData[index].status!) !=
                                                        ""
                                                    ? Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            diningController.returnOrderTime(diningController.tableData[index].orderTime!,
                                                                diningController.tableData[index].status!),
                                                            style: customisedStyle(context, const Color(0xff00775E), FontWeight.w400, 13.0),
                                                          ),
                                                          //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                            Text(
                                              "${diningController.currency} ${roundStringWith(diningController.tableData[index].status != "Vacant" ? diningController.tableData[index].status != "Paid" ? diningController.tableData[index].salesOrderGrandTotal.toString() : diningController.tableData[index].salesGrandTotal.toString() : '0')}",
                                              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                          ),
                        ))))
      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffFFF6F2))),
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
                        style: customisedStyle(context, const Color(0xffF25F29), FontWeight.normal, 12.0),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffEFF6F5))),
                onPressed: () {
                  Get.to(ReservationPage());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Text(
                    'Reservations'.tr,
                    style: customisedStyle(context, const Color(0xff00775E), FontWeight.normal, 12.0),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  ///add table option working not complete
  void addTable() {
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
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
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
                  controller: diningController.customerNameController,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(diningController.saveFocusNode);
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'Table_Name'.tr),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 5),
              child: Container(
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(const Color(0xffF25F29)),
                  ),
                  onPressed: () {
                    if (diningController.customerNameController.text == "") {
                      dialogBox(context, "Please enter table name");
                    } else {
                      diningController.createTableApi();
                    }
                  },
                  child: Text(
                    'save'.tr,
                    style: customisedStyle(context, Colors.white, FontWeight.normal, 12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///add reservation bottom sheet currently not using here
  void addReservationTable() {
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
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'reserve_a_table'.tr,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
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
                    controller: diningController.customerNameController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    focusNode: diningController.customerNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(diningController.saveFocusNode);
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.defaultTextField(hintTextStr: 'customer'.tr),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Color(0xffE6E6E6))),
                  height: MediaQuery.of(context).size.height / 4.5,
                  child: Column(
                    children: [
                      ValueListenableBuilder(
                          valueListenable: diningController.reservationDate,
                          builder: (BuildContext ctx, DateTime dateNewValue, _) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  //  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.height / 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Date'.tr,
                                          style: customisedStyle(context, Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            diningController.dateFormat.format(dateNewValue),
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                          ),
                                        ),
                                        SvgPicture.asset("assets/svg/Icon.svg")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDatePickerFunction(context, diningController.reservationDate);
                              },
                            );
                          }),
                      DividerStyle(),
                      ValueListenableBuilder(
                          valueListenable: diningController.fromTimeNotifier,
                          builder: (BuildContext ctx, timeNewValue, _) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  //  width: MediaQuery.of(context).size.width / 3,
                                  height: MediaQuery.of(context).size.height / 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'from'.tr,
                                          style: customisedStyle(context, Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: Text(
                                            diningController.timeFormat.format(diningController.fromTimeNotifier.value),
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                          ),
                                        ),
                                        SvgPicture.asset("assets/svg/Icon.svg")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.fromDateTime(diningController.fromTimeNotifier.value),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  final time = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
                                  final currentDateTime = diningController.fromTimeNotifier.value;
                                  final dateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, time.hour, time.minute);
                                  diningController.fromTimeNotifier.value = dateTime;
                                  // viewList();
                                } else {
                                  print("Time is not selected");
                                }
                              },
                            );
                          }),
                      DividerStyle(),
                      ValueListenableBuilder(
                          valueListenable: diningController.toTimeNotifier,
                          builder: (BuildContext ctx, timeNewValue, _) {
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.all(
                                  8.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  height: MediaQuery.of(context).size.height / 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'to'.tr,
                                          style: customisedStyle(context, Color(0xff8C8C8C), FontWeight.w400, 14.0),
                                        ),
                                        Text(
                                          diningController.timeFormat.format(diningController.toTimeNotifier.value),
                                          style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                        ),
                                        SvgPicture.asset("assets/svg/Icon.svg")
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                TimeOfDay? pickedTime = await showTimePicker(
                                  initialTime: TimeOfDay.fromDateTime(diningController.toTimeNotifier.value),
                                  context: context,
                                );
                                if (pickedTime != null) {
                                  final time = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
                                  final currentDateTime = diningController.toTimeNotifier.value;
                                  final dateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, time.hour, time.minute);
                                  diningController.toTimeNotifier.value = dateTime;
                                  // viewList();
                                } else {
                                  print("Time is not selected");
                                }
                              },
                            );
                          }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 16, top: 16),
                child: Container(
                  height: MediaQuery.of(context).size.height / 17,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(const Color(0xffF25F29)),
                    ),
                    onPressed: () {
                      // Do something with the text

                      Get.back(); // Close the bottom sheet
                    },
                    child: Text(
                      'save'.tr,
                      style: customisedStyle(context, Colors.white, FontWeight.normal, 12.0),
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

  ///here is the options to edit ,print,pay options bottomsheet
  void optionsPage() {
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
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Options'.tr,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
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
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/edit_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Edit',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/Icon.svg")
                  ],
                ),
              ),
              DividerStyle(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/print_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Print',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/Icon.svg")
                  ],
                ),
              ),
              DividerStyle(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/cancel_order_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Cancel Order',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/Icon.svg")
                  ],
                ),
              ),
              DividerStyle(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/pay_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Pay',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/Icon.svg")
                  ],
                ),
              ),
              DividerStyle(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/reserve_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            'Reserve',
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset("assets/svg/Icon.svg")
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
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
