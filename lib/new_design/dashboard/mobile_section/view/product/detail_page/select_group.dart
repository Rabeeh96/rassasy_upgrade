import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';



class SelectGroupMobile extends StatefulWidget {
  @override
  State<SelectGroupMobile> createState() => _SelectTaxState();
}

class _SelectTaxState extends State<SelectGroupMobile> {
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.getGroupLists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
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
          'Select Group',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
        ),
      ),
      body: Column(
        children: [
          dividerStyleFull(),
          //
          Expanded(
              child: Obx(() => productController.isGroupLoading.value
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                  : productController.categoryLists.isEmpty
                  ? Center(
                  child: Text(
                    "No Groups to Show",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w400, 14.0),
                  ))
                  : ListView.separated(
                itemCount: productController.categoryLists.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, [productController.categoryLists[index].productGroupId ,productController.categoryLists[index].groupName]);

                    },
                    child: InkWell(

                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 15, bottom: 15),
                        child:    Text(
                          productController
                              .categoryLists[index].groupName
                          ,
                          style: customisedStyle(
                              context,
                              Colors.black,
                              FontWeight.w400,
                              14.0),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    dividerStyle(),
              ))),
        ],
      ),
    );
  }
}
