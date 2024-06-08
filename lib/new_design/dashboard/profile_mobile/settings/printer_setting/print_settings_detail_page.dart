import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/printer_setting/select_code_page.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'controller/print_controller.dart';
import 'printer_select_page.dart';
import 'select_capabilities.dart';

class PrinterSettingsDetailPageMobile extends StatefulWidget {
  @override
  State<PrinterSettingsDetailPageMobile> createState() =>
      _PrinterSettingsDetailPageMobileState();
}

class _PrinterSettingsDetailPageMobileState
    extends State<PrinterSettingsDetailPageMobile> {
  PrintSettingController printController = Get.put(PrintSettingController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    printController.loadData();
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
          'printer_set'.tr,
          style: TextStyle(color: Color(0xff000000), fontSize: 20),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Save'.tr,
                style: customisedStyle(
                    context, Color(0xffF25F29), FontWeight.w400, 14.0),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    var result = await Get.to(DetailPage(
                      type: 'SI',
                    ));



                    if (result != null) {
                      printController.salesInvoiceController.text = result;
                    } else {}
                  },
                  textCapitalization: TextCapitalization.words,
                  controller: printController.salesInvoiceController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  //  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextFieldIcon(
                      hintTextStr: 'Sales Invoice'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: Container(
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    var result = await Get.to(DetailPage(
                      type: 'SO',
                    ));

                    if (result != null) {
                      printController.salesOrderController.text = result;
                    } else {}
                  },

                  textCapitalization: TextCapitalization.words,
                  controller: printController.salesOrderController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  //  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextFieldIcon(
                      hintTextStr: 'Sales Order'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      var result = await Get.to(DetailPage(
                        type: '',
                      ));

                      if (result != null) {
                        printController.salesInvoiceController.text = result;
                        printController.salesOrderController.text = result;
                      } else {}
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xffFFF6F2))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8,
                      ),
                      child: Text(
                        "Set Default",
                        style: customisedStyleBold(
                            context, Color(0xffF25F29), FontWeight.w500, 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, bottom: 15),
                  child: Text(
                    "Select Capabilities",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w500, 14.0),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    var result = await Get.to(SelectCapabilitiesMob());

                    print(result);

                    if (result != null) {
                      printController.selectCapabilitiesController.text = result;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('default_capabilities',result);
                    } else {}
                  },

                  textCapitalization: TextCapitalization.words,
                  controller: printController.selectCapabilitiesController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  //  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration:
                      TextFieldDecoration.defaultTextFieldIcon(hintTextStr: ''),
                ),
              ),
            ),
            DividerStyle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.only(left: 20.0, top: 10, bottom: 15),
                  child: Text(
                    "Select Code page",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w500, 14.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Container(
                child: TextField(
                  readOnly: true,
                  onTap: () async {
                    var result = await Get.to(SelectCodePage());


                    if (result != null) {
                      printController.selectCodepageController.text = result;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('default_code_page',result);
                    } else {

                    }
                  },

                  textCapitalization: TextCapitalization.words,
                  controller: printController.selectCodepageController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  //  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration:
                      TextFieldDecoration.defaultTextFieldIcon(hintTextStr: ''),
                ),
              ),
            ),
            DividerStyle(),

            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15, top: 15, bottom: 5),
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
                      child: Text('Highlighted Token No',
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: printController.isHighlightedToken,
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
                              printController.isHighlightedToken.value = val;
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('hilightTokenNumber', val);

                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DividerStyle(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15, top: 5, bottom: 5),
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
                      child: Text('Payment Details',
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: printController.isPaymentDetail,
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
                              printController.isPaymentDetail.value = val;
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('paymentDetailsInPrint', val);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DividerStyle(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 15, top: 5, bottom: 5),
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
                      child: Text('Company Details Alignments',
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w500, 14.0)),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: MediaQuery.of(context).size.height /
                          18, //height of button
                      width: MediaQuery.of(context).size.width / 7,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: printController.isCompanyDetail,
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
                              printController.isCompanyDetail.value = val;
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setBool('headerAlignment', val);


                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DividerStyle(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 20, bottom: 15),
                  child: Text(
                    "Terms & Conditions",
                    style: customisedStyleBold(
                        context, Colors.black, FontWeight.w500, 14.0),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                controller: printController.termsAndConditionController,
                style: customisedStyle(
                    context, Colors.black, FontWeight.w500, 14.0),
                onChanged: (text)async{

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('printTermsAndCondition', text);

                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus();
                },
                keyboardType: TextInputType.text,
                maxLines: 6,
                minLines: 1,
                decoration:
                    TextFieldDecoration.defaultTextField(hintTextStr: ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
