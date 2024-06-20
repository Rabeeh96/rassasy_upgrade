import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_controller.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_group_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';



class SelectCategoryMobile extends StatefulWidget {
  @override
  State<SelectCategoryMobile> createState() => _SelectTaxState();
}

class _SelectTaxState extends State<SelectCategoryMobile> {
  ProductGroupController productGroupController = Get.put(ProductGroupController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productGroupController.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'select_cat'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),
          //
          Expanded(
              child: Obx(() => productGroupController.isCategoryLoad.value
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                  : productGroupController.categoryList.isEmpty
                  ? Center(
                  child: Text(
                    "No Category",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w400, 14.0),
                  ))
                  : ListView.separated(
                itemCount: productGroupController.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, [productGroupController.categoryList[index].categoryID ,productGroupController.categoryList[index].categoryName]);

                    },
                    child: InkWell(

                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        child:    Text(
                          productGroupController
                              .categoryList[index].categoryName
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
                    DividerStyle(),
              ))),
        ],
      ),
    );
  }
}
