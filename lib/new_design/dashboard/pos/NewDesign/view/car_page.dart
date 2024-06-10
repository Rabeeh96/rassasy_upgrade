import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/view/detail_page/cancel_reason_list.dart';
import 'order/add_order_page.dart';
import 'payment/payment_page.dart';

class CarPage extends StatefulWidget {
  final String title;
  final List<dynamic> data;

  const CarPage({Key? key, required this.title, required this.data}) : super(key: key);

  @override
  State<CarPage> createState() => _TakeAwayState();
}

class _TakeAwayState extends State<CarPage> {
  final POSController carController = Get.put(POSController());
  final POSController posController = Get.put(POSController());
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
    // TODO: implement initState
    super.initState();
    carController.carOrders.clear();
    carController.fetchAllData();
    carController.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'Car'.tr,
          style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            child: Text(
              'Manager'.tr,
              style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 13.0),
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


        DividerStyle(),

        Expanded(
            child: Obx(() => carController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : carController.carOrders.isEmpty
                ? const Center(child: Text("No recent orders"))
                : SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: RefreshIndicator(
                  onRefresh: () async {
                    carController.tableData.clear();
                    carController.fetchAllData();
                    carController.update();
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) => DividerStyle(),
                    itemCount: carController.carOrders.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: ValueKey(carController.carOrders[index]),

                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          children: [
                            carController.carOrders[index].status == 'Ordered'?  CustomSlidableAction(
                              flex: 1,
                              onPressed: (BuildContext context) async {
                                posController.printKOT(cancelList: [],isUpdate:false,orderID:carController.carOrders[index].salesOrderID!,rePrint:true);
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
                                  Text("Kot", style: customisedStyle(context, Colors.white, FontWeight.w400, 12.0))
                                ],
                              ),
                            ):Container(),
                            CustomSlidableAction(
                              flex: 1,
                              onPressed: (BuildContext context) async {


                                carController.printSection(
                                    context: context,
                                    id: carController.carOrders[index].status == 'Ordered'
                                        ? carController.carOrders[index].salesOrderID!
                                        : carController.carOrders[index].salesID!,
                                    isCancelled: false,
                                    voucherType: carController.carOrders[index].status == 'Ordered'?"SO":"SI");

                              },
                              backgroundColor: const Color(0xFF034FC1),
                              foregroundColor: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/print.svg', //
                                  ),
                                  Text(
                                    "Print",
                                    style: customisedStyle(context, Colors.white, FontWeight.w400, 10.0),
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
                                if(carController.carOrders[index].status == 'Ordered'){
                                  var result = await Get.to(CancelOrderList());
                                  if(result !=null){
                                    carController.cancelOrderApi(context:context,type: "Cancel", tableID: "", cancelReasonId: result[1], orderID: carController.carOrders[index].salesOrderID!);
                                  }
                                }
                                else{
                                  carController.cancelOrderApi(context:context,type: "Car", tableID: "", cancelReasonId: "", orderID:carController.carOrders[index].salesOrderID!);
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
                                    carController.carOrders[index].status == 'Ordered'?"Cancel":"Clear",
                                    style: customisedStyle(context, Colors.white, FontWeight.w400, 10.0),
                                  )
                                ],
                              ),
                            ),
                            CustomSlidableAction(
                              onPressed: (BuildContext context) async {
                                var resultPayment = await Get.to(PaymentPage(
                                  uID: carController.carOrders[index].salesOrderID!,
                                  tableID: "",
                                  orderType: 2,
                                ));

                                carController.carOrders.clear();
                                carController.fetchAllData();
                                carController.update();
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
                            ),


                          ],
                        ),

                        child: GestureDetector(
                          onTap: () async {
                            // if (carController.takeAwayOrders[index].status == 'Ordered') {
                            //   var result = await Get.to(OrderCreateView(
                            //     orderType: 2,
                            //     sectionType: "Edit",
                            //     uID: takeAwayController.carOrders[index].salesOrderID!,
                            //     tableHead: "Parcel",
                            //     tableID: "",
                            //   ));
                            //
                            //   if (result != null) {
                            //     if (result[1]) {
                            //       Get.to(PaymentPage(
                            //         uID: result[2],
                            //         tableID: takeAwayController.carOrders[index].salesOrderID!,
                            //         orderType: 2,
                            //       ));
                            //     }
                            //   }
                            // }
                          },
                          child: InkWell(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15,top: 15,left: 15,right: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Car Order ${index + 1} -",
                                                  style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                                ),
                                                Text(
                                                  " #",
                                                  style: customisedStyle(context, const Color(0xff9B9B9B), FontWeight.w400, 14.0),
                                                ),
                                                Text(
                                                  "Token ${carController.carOrders[index].tokenNumber!}",
                                                  style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {

                                            },
                                            child: Container(
                                              height: MediaQuery.of(context).size.height / 32,
                                              decoration: BoxDecoration(
                                                color: _getBackgroundColor(carController.carOrders[index].status!),
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                  child: Text(
                                                    carController.carOrders[index].status!,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: carController.carOrders[index].status == "Vacant" ? Colors.black : Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8.0),
                                            child: Text(
                                              carController.carOrders[index].customerName!,
                                              style: customisedStyle(context, const Color(0xffA0A0A0), FontWeight.w400, 13.0),
                                            ),
                                          ),
                                          Text(
                                            carController.returnOrderTime(
                                                carController.carOrders[index].orderTime!, carController.carOrders[index].status!),
                                            style: customisedStyle(context, const Color(0xff00775E), FontWeight.w400, 13.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    roundStringWith(carController.carOrders[index].salesOrderGrandTotal!),
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )))),



      ]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffFFF6F2))),
                onPressed: () async{
                  var result = await Get.to(OrderCreateView(
                    orderType: 4,
                    sectionType: "Create",
                    uID: "",
                    tableHead: "Order",
                    tableID: "",
                    cancelOrder: carController.cancelOrder,
                  )
                  );

                  if (result != null) {
                    if (result[1]) {
                      var resultPayment = await Get.to(PaymentPage(
                        uID: result[2],
                        tableID: "",
                        orderType: 4,
                      ));
                      carController.carOrders.clear();
                      carController.fetchAllData();
                      carController.update();
                    }
                    else {
                      carController.carOrders.clear();
                      carController.fetchAllData();
                      carController.update();
                    }
                  }
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
                        'Add_Takeaway'.tr,
                        style: customisedStyle(context, const Color(0xffF25F29), FontWeight.normal, 12.0),
                      ),
                    )
                  ],
                )),
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
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: const TextStyle(color: Colors.red)),
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
            child: const Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
