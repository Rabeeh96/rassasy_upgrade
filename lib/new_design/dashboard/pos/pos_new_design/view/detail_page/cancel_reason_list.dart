import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
 import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/pos_controller.dart';

class CancelOrderList extends StatefulWidget {
  const CancelOrderList({super.key});

  @override
  State<CancelOrderList> createState() => _CancelOrderListState();
}

class _CancelOrderListState extends State<CancelOrderList> {
  POSController posController = Get.put(POSController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(posController.cancelOrder);
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
              'Cancel_order'.tr,
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(children: [
        dividerStyle(),
        Expanded(
            child: Obx(() =>
            posController.cancelOrder.isEmpty
                ? const Center(child: Text("Cancel Reasons not found"))
                : ListView.separated(
              separatorBuilder: (context, index) => dividerStyle(),
              itemCount: posController.cancelOrder.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, [posController.cancelOrder[index]["Reason"],posController.cancelOrder[index]["id"]]);
                  },
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          posController.cancelOrder[index]["Reason"],
                          style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )))
      ]),
    );
  }
}
