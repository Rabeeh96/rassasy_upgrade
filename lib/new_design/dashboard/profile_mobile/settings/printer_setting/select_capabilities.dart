import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/printer_setting/controller/detailed_print_controlle.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:get/get.dart';

class SelectCapabilitiesMob extends StatefulWidget {
  @override
  State<SelectCapabilitiesMob> createState() => _SelectCapabilitiesMobState();
}

class _SelectCapabilitiesMobState extends State<SelectCapabilitiesMob> {
  DetailedPrintSettingController capabilitiesController = Get.put(DetailedPrintSettingController());

//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'select_capability'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: ListView(

        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 1),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: capabilitiesController.printerModels.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          capabilitiesController.printerModels[index],
                          style: customisedStyleBold(context, Colors.black, FontWeight.w400, 14.0),
                        ),
                        onTap: () {
                          Navigator.pop(context, capabilitiesController.printerModels[index]);
                        },
                      ),
                      dividerStyle()
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
