import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/printer_settings_controler.dart';
import 'print_settings_detail_page.dart';

class PrinterSettingsMobilePage extends StatefulWidget {
  @override
  State<PrinterSettingsMobilePage> createState() => _PrinterSettingsMobilePageState();
}

class _PrinterSettingsMobilePageState extends State<PrinterSettingsMobilePage> {
  // Initialize it with the default selected index
  PrintSettingController printSettingController = Get.put(PrintSettingController());
  String _selectedOption="Wifi"; // Declare _selectedOption as a nullable String

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "select_printer_type".tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                ),
                DropdownButton<String>(
                  hint: const Text('Select an option'),
                  value: _selectedOption,
                  onChanged: (String? newValue) async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _selectedOption = newValue!;

                      prefs.setString("PrintType", newValue);
                      if(_selectedOption=="Wifi"||_selectedOption=="USB"){
                        printSettingController.selectedIndex.value=0;
                      }

                   });
                  },
                  items: <String>['Wifi', 'USB', 'BT'].map<DropdownMenuItem<String>>(
                        (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            value,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0, right: 15),
          //   child: Container(
          //     height: MediaQuery.of(context).size.height / 17, //height of button
          //     // child: paidList(),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           alignment: Alignment.centerLeft,
          //           height: MediaQuery.of(context).size.height / 18, //height of button
          //           width: MediaQuery.of(context).size.width / 1.5,
          //           child: Text('enable_wifi'.tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
          //         ),
          //         Container(
          //           alignment: Alignment.centerRight,
          //           height: MediaQuery.of(context).size.height / 18, //height of button
          //           width: MediaQuery.of(context).size.width / 7,
          //           child: ValueListenableBuilder<bool>(
          //             valueListenable: printSettingController.isEnableWifiPrinter,
          //             builder: (context, value, child) {
          //               return FlutterSwitch(
          //                 width: 40.0,
          //                 height: 20.0,
          //                 valueFontSize: 30.0,
          //                 toggleSize: 15.0,
          //                 value: value,
          //                 borderRadius: 20.0,
          //                 padding: 1.0,
          //                 activeColor: const Color(0xffF25F29),
          //                 activeTextColor: Colors.green,
          //                 toggleColor: const Color(0xffffffff),
          //                 inactiveTextColor: Color(0xffffffff),
          //                 inactiveColor: const Color(0xffD9D9D9),
          //                 onToggle: (val) async {
          //                   SharedPreferences prefs = await SharedPreferences.getInstance();
          //                   printSettingController.isEnableWifiPrinter.value = val;
          //                   if (val == true) {
          //                     prefs.setString("PrintType", "Wifi");
          //
          //                   } else {
          //                     printSettingController.isEnableWifiPrinter.value=true;
          //                     popAlert(head: "Alert", message: "Currently wifi printer is support",   position: SnackPosition.TOP);
          //                  //   prefs.setString("PrintType", "USB");
          //                   }
          //                 },
          //               );
          //             },
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'select_a_template'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                      ),
                      SvgPicture.asset("assets/svg/settinhs_mobile.svg")
                    ],
                  ),
                ),
              )),
          dividerStyle(),
          const SizedBox(
            height: 20,
          ),
          _selectedOption=="BT"?Expanded(child: GestureDetector(
            onTap: () async {
              printSettingController.selectedIndex.value=1;
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("template", "template1");
            },
            child: Padding(
                padding:  EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
                child:Obx(() => Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEBEBEB),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: printSettingController.selectedIndex.value == 1 ? Colors.red : Colors.transparent,
                    ),
                  ),
                  child: Image.asset("assets/png/gst.png"),
                ),)
            ),
          )):  Expanded(
            child: Obx(() => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: printSettingController.imagePaths.length,
              itemBuilder: (context, index) {
                String imagePath = printSettingController.imagePaths[index];
                return GestureDetector(
                  onTap: () {
                    printSettingController.setSelectedIndex(index);
                    if (index == 0) {
                      printSettingController.setTemplate(3);
                    } else {
                      printSettingController.setTemplate(4);
                    }

                  },
                  child: Padding(
                      padding:  EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
                      child:Obx(() => Container(
                        decoration: BoxDecoration(
                          color: Color(0xffEBEBEB),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: printSettingController.selectedIndex.value == index ? Colors.red : Colors.transparent,
                          ),
                        ),
                        child: Image.asset(imagePath),
                      ),)
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
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Color(0xffF1F1F1))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xffF25F29),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8, top: 5, bottom: 5),
                      child: Text(
                        'select_a_template'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
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
