import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/order_controller.dart';

class SelectProductGroup extends StatefulWidget {
  @override
  State<SelectProductGroup> createState() => _SelectProductGroupState();
}

class _SelectProductGroupState extends State<SelectProductGroup> {
  OrderController posController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              'product_group'.tr,
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(children: [
        dividerStyle(),
        Expanded(
            child: Obx(() =>
            posController.groupList.isEmpty
                ? const Center(child: Text("Group not found"))
                : ListView.separated(
              separatorBuilder: (context, index) => dividerStyle(),
              itemCount: posController.groupList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, [posController.groupList[index].groupName,posController.groupList[index].groupID,index]);
                  },
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 18),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          posController.groupList[index].groupName,
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
