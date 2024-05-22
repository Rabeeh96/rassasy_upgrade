import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/add_printer/printer_list.dart';

import 'general_setting/general_setting.dart';
import 'online_platforms/list_online_platforms.dart';
import 'printer_setting/printer_setting.dart';

class SettingsMobilePage extends StatefulWidget {
  @override
  State<SettingsMobilePage> createState() => _SettingsMobilePageState();
}

class _SettingsMobilePageState extends State<SettingsMobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: Text(
          'Settings',
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
          GestureDetector(
            onTap: () {
              Get.to(GeneralSettingsMobile());
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/settings-2.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'General Settings',
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 16.0),
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          DividerStyle(),
          GestureDetector(
            onTap: () {
              Get.to(PrinterSettingsMobilePage());
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/printer_mob.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Printer Settings',
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 16.0),
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          DividerStyle(),
          GestureDetector(
            onTap: () {
              Get.to(PrinterList());
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/Add printer.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Add Printer',
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 16.0),
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          DividerStyle(),
          GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/svg/tools-kitchen.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Kitchen Settings',
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 16.0),
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          DividerStyle(),
          GestureDetector(
            onTap: () {
              Get.to(OnlinePlatform());
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                            "assets/svg/takeout_dining_mobile.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Online Platforms',
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w400, 16.0),
                          ),
                        )
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
          ),
          DividerStyle(),
        ],
      ),
    );
  }
}
