import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/customer_controller.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_controller.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_group_controller.dart';
import 'package:rassasy_new/new_design/dashboard/product/detail/select_category_new.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:rassasy_new/new_design/report/selectDetails/select_group.dart';



class SelectRouteMobile extends StatefulWidget {
  @override
  State<SelectRouteMobile> createState() => _SelectTaxState();
}

class _SelectTaxState extends State<SelectRouteMobile> {
  CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerController.getRouteList();
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
          "Select Routes",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),

          Expanded(
              child: Obx(() => customerController.isRouteLoad.value
                  ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                  : customerController. routeList.isEmpty
                  ? Center(
                  child: Text(
                    "No Routes",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w400, 14.0),
                  ))
                  : ListView.separated(
                itemCount:  customerController.routeList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.pop(context, [customerController. routeList[index].routeUID ,customerController. routeList[index].routeName]);

                    },
                    child: InkWell(

                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10, bottom: 10),
                        child:    Text(
                          customerController
                              .routeList[index].routeName
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
