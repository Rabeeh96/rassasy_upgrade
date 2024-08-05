import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/test_page/usb_test_page.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/test_page/print_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'controller/detailed_print_controlle.dart';

class DetailPage extends StatefulWidget {
  String? type;

  DetailPage({
    super.key,
    required this.type,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailedPrintSettingController printController = Get.put(DetailedPrintSettingController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printController.listAllPrinter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'select_printer'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),
          Expanded(
            child: Obx(() => printController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => dividerStyle(),
                    shrinkWrap: true,
                    itemCount: printController.printDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              printController.printDetailList[index].printerName,
                              style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                            ),
                            Text(
                              printController.printDetailList[index].iPAddress,
                              style: customisedStyle(context, Colors.grey, FontWeight.normal, 12.0),
                            ),
                          ],
                        ),
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          if (widget.type == "SI") {
                            prefs.setString('defaultIP', printController.printDetailList[index].iPAddress) ?? '';
                          } else if (widget.type == "SO") {
                            prefs.setString('defaultOrderIP', printController.printDetailList[index].iPAddress) ?? '';
                          } else {
                            prefs.setString('defaultOrderIP', printController.printDetailList[index].iPAddress) ?? '';
                            prefs.setString('defaultIP', printController.printDetailList[index].iPAddress) ?? '';
                          }

                          Navigator.pop(context, printController.printDetailList[index].iPAddress);
                        },
                      );
                    })),
          )
        ],
      ),
    );
  }

}

