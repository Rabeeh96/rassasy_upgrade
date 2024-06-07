import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';

import 'print_settings_detail_page.dart';

class PrinterSettingsMobilePage extends StatefulWidget {
  @override
  State<PrinterSettingsMobilePage> createState() =>
      _PrinterSettingsMobilePageState();
}

class _PrinterSettingsMobilePageState extends State<PrinterSettingsMobilePage> {
  ValueNotifier<bool> isEnablewifiPrinter = ValueNotifier<bool>(false);

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
        title:  Text(
          'printer_set'.tr,
          style: TextStyle(color: Color(0xff000000), fontSize:20),
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
                          onToggle: (val) {
                            isEnablewifiPrinter.value = val;
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
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                   // width: MediaQuery.of(context).size.width / 1.3,
                    child: Image.asset('assets/png/gst.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  //  width: MediaQuery.of(context).size.width / 1.3,
                    child: Image.asset('assets/png/vat.png'),
                  ),
                ),
              ],
            ),
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
