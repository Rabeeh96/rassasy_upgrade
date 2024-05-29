import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
class CustomerDetailPage extends StatefulWidget{
  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  OrderController controller=Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchCustomers();
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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer',
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),

      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only( bottom: 12),
          child: Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
        ),

        Expanded(
            child: Obx(() => controller.isLoadingValue.value
                ? const Center(child: CircularProgressIndicator())
                : controller.customerList.isEmpty
                ? const Center(child: Text("Customers not found"))
                : ListView.builder(
              itemCount: controller.customerList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                   // controller.customerNameController.text =controller.customerList[index].userName;
                   Navigator.pop(context,[controller.customerList[index].userName]);

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
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
                                      controller.customerList[index].userName,
                                      style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      controller.customerList[index].openingBalance,
                                      style: customisedStyle(context, Color(0xff878787), FontWeight.normal, 13.0),
                                    ),
                                  ),
                                ],
                              ),

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
    );
  }
}
