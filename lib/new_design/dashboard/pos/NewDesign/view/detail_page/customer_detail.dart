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
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'customer'.tr,
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
                : ListView.separated(
              separatorBuilder: (context, index) => DividerStyle(),
              itemCount: controller.customerList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                   Navigator.pop(context,[controller.customerList[index].ledgerName,controller.customerList[index].customerLedgerBalance,controller.customerList[index].ledgerID]);
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
                                  controller.customerList[index].ledgerName,
                                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  roundStringWith(controller.customerList[index].customerLedgerBalance),
                                  style: customisedStyle(context, const Color(0xff878787), FontWeight.normal, 13.0),
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
