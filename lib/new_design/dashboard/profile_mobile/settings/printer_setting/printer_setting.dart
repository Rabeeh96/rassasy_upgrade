import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/printer_setting/controller/print_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'print_settings_detail_page.dart';

class PrinterSettingsMobilePage extends StatefulWidget {
  @override
  State<PrinterSettingsMobilePage> createState() =>
      _PrinterSettingsMobilePageState();
}

class _PrinterSettingsMobilePageState extends State<PrinterSettingsMobilePage> {
  ValueNotifier<bool> isEnablewifiPrinter = ValueNotifier<bool>(false);

  // Initialize it with the default selected index
  PrintSettingController printSettingController =
      Get.put(PrintSettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: Text(
          'printer_set'.tr,
          style: TextStyle(color: Color(0xff000000), fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15),
            child: Container(
              height:
                  MediaQuery.of(context).size.height / 17, //height of button
              // child: paidList(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height /
                        18, //height of button
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text('enable_wifi'.tr,
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w500, 14.0)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: MediaQuery.of(context).size.height /
                        18, //height of button
                    width: MediaQuery.of(context).size.width / 7,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isEnablewifiPrinter,
                      builder: (context, value, child) {
                        return FlutterSwitch(
                          width: 40.0,
                          height: 20.0,
                          valueFontSize: 30.0,
                          toggleSize: 15.0,
                          value: value,
                          borderRadius: 20.0,
                          padding: 1.0,
                          activeColor: const Color(0xffF25F29),
                          activeTextColor: Colors.green,
                          toggleColor: const Color(0xffffffff),
                          inactiveTextColor: Color(0xffffffff),
                          inactiveColor: const Color(0xffD9D9D9),
                          onToggle: (val) async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            isEnablewifiPrinter.value = val;

                            if (val == true) {
                              prefs.setString("PrintType", "Wifi");
                            } else {
                              prefs.setString("PrintType", "USB");
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                top: 12,
                bottom: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(PrinterSettingsDetailPageMobile());
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'select_a_template'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 16.0),
                    ),
                    SvgPicture.asset("assets/svg/settinhs_mobile.svg")
                  ],
                ),
              )),
          DividerStyle(),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: printSettingController.imagePaths.length,
                  itemBuilder: (context, index) {
                    String imagePath = printSettingController.imagePaths[index];
                    print("Rebuilding Obx");
                    print(
                        "imagePaths length: ${printSettingController.imagePaths.length}");
                    return GestureDetector(
                      onTap: () {
                        printSettingController.setSelectedIndex(index);

                        print("ind$index");


                        if (index == 0) {
                          printSettingController.setTemplate(3);
                        } else {
                          printSettingController.setTemplate(4);
                        }

                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffEBEBEB),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                                  printSettingController.selectedIndex.value ==
                                          index
                                      ? Colors.red
                                      : Colors.transparent,
                            ),
                          ),
                          child: Image.asset(imagePath),
                        ),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.height / 12,
        child: Column(
          children: [
            DividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xffF1F1F1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xffF25F29),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 5, bottom: 5),
                      child: Text(
                        'select_a_template'.tr,
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w400, 14.0),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
