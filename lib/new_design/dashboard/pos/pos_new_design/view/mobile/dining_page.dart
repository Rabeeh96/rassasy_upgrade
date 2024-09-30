import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/dashboard/pos/barcode/barcode.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/detail_page/cancel_reason_list.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/view/detail_page/reservation_list.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';

import 'order/add_order_page.dart';
import 'payment/mobile_payment_page.dart';

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
              diningController.userName.value,
              style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 13.0),
            ),
          ),
          IconButton(
              onPressed: () {
                _asyncConfirmDialog(context);
              },
              icon: SvgPicture.asset('assets/svg/logout_mob.svg'))      ,

          IconButton(
              onPressed: () {
                BarcodeScannerClass.scanBarcode(context);
              },
              icon: SvgPicture.asset('assets/svg/logout_mob.svg'))
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Container(
           // color: Colors.green,
            height: MediaQuery.of(context).size.height / 18,
            child: ValueListenableBuilder<int>(
              valueListenable: diningController.selectedIndexNotifier,
              builder: (context, selectedIndex, child) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: POSController.labels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
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
        dividerStyleFull(),
       // DividerStyle(),
        Expanded(
            child: Obx(() => diningController.isLoading.value
                ?   const Center(child: CircularProgressIndicator(color: Color(0xffffab00),))
                : diningController.tableData.isEmpty
                    ? const Center(child: Text("No recent orders"))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: RefreshIndicator(
                          color:  Color(0xffffab00),
                          onRefresh: ()async{
                            diningController.selectedIndexNotifier.value = 0;
                            diningController.tableData.clear();
                            diningController.fetchAllData();
                            diningController.update();
                          },
                          child: ListView.separated(
                            separatorBuilder: (context, index) => dividerStyle(),
                            itemCount: diningController.tableData.length+1,
                            itemBuilder: (context, index) {
                              if (index == diningController.tableData.length) {
                                return Container();
                              }
                              return Slidable(
                                enabled: diningController.tableData[index].status != 'Vacant' ? true : false,
                                key: ValueKey(diningController.tableData[index]),

                                // The start action pane is the one at the left or the top side.
                                startActionPane: ActionPane(
                                  // A motion is a widget used to control how the pane animates.
                                  motion: const ScrollMotion(),

                                  children: [
                                    diningController.tableData[index].status == 'Ordered'&&
                                        posController.kitchen_print_perm.value?
                                    CustomSlidableAction(
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
                                    posController.print_perm.value?
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
                                    ):Container(),
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
                                        ? posController.pay_perm.value? CustomSlidableAction(
                                            onPressed: (BuildContext context) async {
                                              var resultPayment = await Get.to(MobilePaymentPage(
                                                uID: diningController.tableData[index].salesOrderID!,
                                                tableID: diningController.tableData[index].id!,
                                                responseData: "",
                                                isData: false,
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
                                          ):Container()
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
                                          var resultPayment = await Get.to(MobilePaymentPage(
                                            uID: result[2],
                                            tableID: diningController.tableData[index].id!,
                                            orderType: 0,
                                            responseData: "",
                                            isData: false,
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
                                    }
                                    else if (diningController.tableData[index].status == 'Ordered') {
                                      if(posController.dining_edit_perm.value){
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
                                          var res= await Get.to(MobilePaymentPage(
                                            uID: result[2],
                                            tableID: diningController.tableData[index].id!,
                                            orderType: 1,
                                            responseData: "",
                                            isData: false,
                                          ));

                                          diningController.tableData.clear();
                                          diningController.fetchAllData();
                                          diningController.update();
                                        }
                                        else{
                                          diningController.tableData.clear();
                                          diningController.fetchAllData();
                                          diningController.update();
                                        }
                                      }}
                                      else{
                                        dialogBoxPermissionDenied(context);
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
                                                diningController.returnOrderTime(diningController.tableData[index].orderTime!, diningController.tableData[index].status!) !=
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
                        style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w500, 14.0),
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
                  if(posController.reservation_perm.value){
                    Get.to(ReservationPage());
                  }else{
                    dialogBoxPermissionDenied(context);

                  }

                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Text(
                    'Reservations'.tr,
                    style: customisedStyle(context, const Color(0xff00775E),FontWeight.w500, 14.0),
                  ),
                )
            ),
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


}

enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: true,
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

              Navigator.pop(context);
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => EnterPinNumber()),
                    (_) => false,
              );

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
