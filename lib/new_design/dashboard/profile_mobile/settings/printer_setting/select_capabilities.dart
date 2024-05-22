import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/printer_setting/controller/print_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:get/get.dart';


class SelectCapabilitiesMob extends StatefulWidget {


  @override
  State<SelectCapabilitiesMob> createState() => _SelectCapabilitiesMobState();
}

class _SelectCapabilitiesMobState extends State<SelectCapabilitiesMob> {
  PrintSettingController capabilitiesController = Get.put(PrintSettingController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          'select_capability'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Expanded(
                child: Obx(() => capabilitiesController.isLoading.value
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF25F29),
                    ))
                    : ListView.builder(
                    shrinkWrap: true,
                    itemCount: capabilitiesController.printerModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(capabilitiesController.printerModels[index],style: customisedStyleBold(context, Colors.black, FontWeight.w400, 14.0),),
                            onTap: ()  {


                              Navigator.pop(
                                  context,
                                  capabilitiesController.printerModels[index]);
                            },
                          ),
                          DividerStyle()
                        ],
                      );
                    })),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

}

