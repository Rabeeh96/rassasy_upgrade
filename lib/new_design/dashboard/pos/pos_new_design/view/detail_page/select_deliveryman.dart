import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/order_controller.dart';

class SelectDeliveryMan extends StatefulWidget {
  @override
  State<SelectDeliveryMan> createState() => _SelectDeliveryManState();
}

class _SelectDeliveryManState extends State<SelectDeliveryMan> {
  OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchUsers();
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
              'delivery_man'.tr,
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
        ),
        Expanded(
            child: Obx(() => controller.isCustomerLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.users.isEmpty
                    ? const Center(child: Text("Sales man not found"))
                    : ListView.separated(
                        separatorBuilder: (context, index) => dividerStyle(),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, [controller.users[index].userName,controller.users[index].deliveryManID]);
                            },
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            controller.users[index].userName,
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            controller.users[index].userName,
                                            style: customisedStyle(context, Color(0xff878787), FontWeight.normal, 13.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
