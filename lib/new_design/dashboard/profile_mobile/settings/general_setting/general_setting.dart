import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/general_setting/controller/general_settings_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingsMobile extends StatefulWidget {
  @override
  State<GeneralSettingsMobile> createState() => _GeneralSettingsMobileState();
}

class _GeneralSettingsMobileState extends State<GeneralSettingsMobile> {
  GeneralController generalController = Get.put(GeneralController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generalController.loadData();
    generalController.fetchSettings();
  }

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
          'gen_setting'.tr,
          style: TextStyle(color: Color(0xff000000), fontSize: 20),
        ),
        // actions: [
        //   GestureDetector(
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 15.0),
        //       child: Text(
        //         'Save'.tr,
        //         style: customisedStyle(
        //             context, Color(0xffF25F29), FontWeight.w400, 14.0),
        //       ),
        //     ),
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('auto_focus'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.isAutoFocus,
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
                              generalController.isAutoFocus.value = val;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('autoFocusField', val);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('arabic'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.isArabic,
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
                              generalController.isArabic.value = val;

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              Locale? currentLocale = Get.locale;
                              if (currentLocale.toString() == "ar") {
                                prefs.setBool('isArabic', false);
                                Get.updateLocale(const Locale('en', 'US'));
                              } else {
                                prefs.setBool('isArabic', true);
                                Get.updateLocale(const Locale('ar'));
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
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('open_drawer'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.isDrawerOpenNotifier,
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
                              generalController.isDrawerOpenNotifier.value =
                                  val;

                              generalController.switchStatus("OpenDrawer",
                                  generalController.isDrawerOpenNotifier.value);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('qty_increment'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.isQuantityIncrement,
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
                              generalController.isQuantityIncrement.value = val;

                              generalController.updateList(
                                apiKeyValue: "IsQuantityIncrement",
                                apiData: val,
                                sharedPreferenceKey: "qtyIncrement",
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('show_invoice'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.isShowInvoice,
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
                              generalController.isShowInvoice.value = val;
                              generalController.updateList(
                                  apiKeyValue: "IsShowInvoice",
                                  apiData: val,
                                  sharedPreferenceKey: "AutoClear");
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                    MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('clear_table_after'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.tableClearAfterPayment,
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
                              generalController.tableClearAfterPayment.value = val;
                              generalController.updateList(
                                  apiKeyValue: "IsClearTableAfterPayment",
                                  apiData: val,
                                  sharedPreferenceKey:
                                      "tableClearAfterPayment");
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('direct_order_option'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.directOrderOption,
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

                              generalController.directOrderOption.value = val;

                              generalController.switchStatus("directOrderOption", generalController.directOrderOption.value);




                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                height:
                MediaQuery.of(context).size.height / 15, //height of button
                // child: paidList(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Text('sync_method'.tr,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: generalController.synMethod,
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
                              generalController.synMethod.value = val;
                              generalController.switchStatus("synMethod", generalController.synMethod.value);

                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('initial_token'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                        // Only allow digits (numbers)
                      ],
                   //  textAlign: TextAlign.right,
                      controller: generalController.tokenController,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                      // focusNode: diningController.customerNode,
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(generalController.initialTokenNode);
                        var val = "0";
                        if (generalController.tokenController.text != "") {
                          val = generalController.tokenController.text;
                        }

                        generalController.updateList(
                            apiKeyValue: "InitialTokenNo",
                            apiData: val,
                            sharedPreferenceKey: '');
                      },
                      decoration: TextFieldDecoration.defaultTextField(
                          hintTextStr: "#"),
                    ),
                  ),
                ],
              ),
            ),
            dividerStyle(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 15, bottom: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('com_hr'.tr,
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: MediaQuery.of(context).size.height / 17,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xffe9e9e9)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ValueListenableBuilder<String>(
                                valueListenable: generalController.compensationHourNotifier,
                                builder: (context, value, child) {
                                  return DropdownButton<String>(
                                    value: value,
                                    underline: Container(),
                                    icon: SizedBox.shrink(),
                                    items: generalController.dropdownValues.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          "$value Hour",
                                          style: customisedStyle(
                                            context,
                                            const Color(0xff000000),
                                            FontWeight.normal,
                                            15.0,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      generalController.compensationHour = newValue!;
                                      generalController.compensationHourNotifier.value = newValue; // Update the ValueNotifier
                                      generalController.updateList(
                                        apiKeyValue: 'CompensationHour',
                                        apiData: newValue,
                                        sharedPreferenceKey: 'CompensationHour',
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: const Color(0xff000000),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )


                ],
              ),
            ),
            SizedBox(height: 8,),



      ],
        ),
      ),
    );
  }
}
