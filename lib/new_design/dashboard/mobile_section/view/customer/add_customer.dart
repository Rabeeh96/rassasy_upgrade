import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class AddCustomerMobile extends StatefulWidget{
  @override
  State<AddCustomerMobile> createState() => _AddCustomerMobileState();
}

class _AddCustomerMobileState extends State<AddCustomerMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Customer',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {

                  // if (productController.productNameController.text.isEmpty ||
                  //     productController.salesPriceController.text.isEmpty ||
                  //     productController.purchasePriceController.text.isEmpty ||
                  //     productController.groupController.text.isEmpty) {
                  //   Get.snackbar('Error', "Please fill in all required fields");
                  //
                  //
                  // }else{
                  //   if(widget.type=="Edit"){
                  //     print("ghdfdhfhghf");
                  //     productController.editProduct(widget.uid!);
                  //   }
                  //   else{
                  //     if(productController.createPermission){
                  //       productController.createProduct();
                  //     }else{
                  //       Get.snackbar('Error', "Permission Denied");
                  //     }
                  //   }
                  //
                  //
                  // }
                },
                icon: Text(
                  'Save'.tr,
                  style: customisedStyle(
                      context, Color(0xffF25F29), FontWeight.w400, 14.0),
                )),
          )
        ],
      ),
      body: ListView(
        children: [
          DividerStyle(),
          SizedBox(
            height: 15,
          ),
        ],
      ),

    );
  }
}