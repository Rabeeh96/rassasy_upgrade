import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';



class SelectTaxMobile extends StatefulWidget {
  String taxType;
  SelectTaxMobile({super.key,required this.taxType});
  @override
  State<SelectTaxMobile> createState() => _SelectTaxState();
}

class _SelectTaxState extends State<SelectTaxMobile> {
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.getTaxDetails(widget.taxType);
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
          'Select Tax',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),
          //
          Expanded(
              child: Obx(() => productController.isLoadingTax.value
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                  : productController.taxLists.isEmpty
                  ? Center(
                  child: Text(
                    "Tax is empty",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w400, 14.0),
                  ))
                  : ListView.separated(
                itemCount: productController.taxLists.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, [productController.taxLists[index].taxID,productController.taxLists[index].taxName]);

                    },
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                productController
                                    .taxLists[index].taxName,
                                style: customisedStyle(
                                    context,
                                    Colors.black,
                                    FontWeight.w400,
                                    14.0),
                              ),
                              Text(
                                productController
                                    .taxLists[index]
                                    .type,
                                style: customisedStyle(
                                    context,
                                    Color(0xffA5A5A5),
                                    FontWeight.w400,
                                    14.0),
                              ),
                            ]),
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
