import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/customer_controller.dart'; // Import GetStorage for SharedPreferences alternative

class TaxTreatment extends StatefulWidget {
  @override
  State<TaxTreatment> createState() => _TaxTreatmentState();
}

class _TaxTreatmentState extends State<TaxTreatment> {
  final  CustomerController customerController = Get.put(CustomerController());
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerController.checkTaxType();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Get.back(); // Use Get.back() instead of Navigator.pop(context)
          },
        ),
        titleSpacing: 0,
        title: Text(
          'tax_type'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize:18,
          ),
        ),

      ),
      body:Obx(() => ListView.separated(
        shrinkWrap: true,
        itemCount:  customerController.taxLists.length,
        itemBuilder: (BuildContext context, int index) {
          return  ListTile(
              title: Text(customerController.taxLists[index].treatmentName),
              onTap: () {
                // Update treatment selection
                //controller.checkTaxType();
                Get.back(result: [customerController.taxLists[index].treatmentValue, customerController.taxLists[index].treatmentName]);
              },
            )
         ;
        }, separatorBuilder: (BuildContext context, int index) =>dividerStyle(),
      ))
    );
  }
}

