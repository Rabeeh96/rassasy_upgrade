import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';

import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/add_printer/controller/printer_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
class PrinterList extends StatefulWidget {
  @override
  State<PrinterList> createState() => _PrinterListState();
}

class _PrinterListState extends State<PrinterList> {
  final AddPrinterController printerController =
      Get.put(AddPrinterController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printerController.listAllPrinter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          titleSpacing: 0,
          title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Printers'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
            ],
          ),
        ),
        body: Column(children: [
          Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
          Expanded(
              child: Obx(() => printerController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color(0xffF25F29),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: printerController.printDetailList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            print("herer");
                            bottomDialogueFunction(
                                isDismissible: true,
                                context: context,
                                textMsg: "Sure want to delete",
                                fistBtnOnPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                                secondBtnPressed: () async {
                                  printerController.deletePrinter(printerController.printDetailList[index].id);
                                },
                                secondBtnText: 'Ok');

                          },
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () async {  bottomDialogueFunction(
                                    isDismissible: true,
                                    context: context,
                                    textMsg: "Sure want to delete",
                                    fistBtnOnPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    secondBtnPressed: () async {
                                      printerController.deletePrinter(printerController.printDetailList[index].id);
                                      Navigator.of(context).pop(true);
                                    },
                                    secondBtnText: 'Ok');
                                },
                                leading:  SvgPicture.asset(returnPrinterListIcon( printerController.printDetailList[index].type),
                                ),

                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      printerController
                                          .printDetailList[index].printerName,
                                      style: customisedStyle(context,
                                          Colors.black, FontWeight.w400, 15.0),
                                    ),
                                    Text(
                                      printerController
                                          .printDetailList[index].iPAddress,
                                      style: customisedStyle(context,
                                          Colors.grey, FontWeight.w400, 14.0),
                                    ),
                                  ],
                                ),

                              ),
                              dividerStyle()
                            ],
                          ),
                        );
                      })))
        ]),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffFFF6F2))),
                  onPressed: () {
                    addPrinter();
                  },
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add,
                        color: Color(0xffF25F29),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Text(
                          'add_print'.tr,
                          style: customisedStyle(context,
                              const Color(0xffF25F29), FontWeight.normal, 12.0),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
  returnPrinterListIcon(type) {
    if (type == "WF") {
      return "assets/svg/wifi.svg";
    } else if (type == "BT") {
      return "assets/svg/bluetooth.svg";
    } else {
      return "assets/svg/usb.svg";
    }
  }
  void deleteAlert(id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: AlertDialog(
              title: Padding(
                padding: const EdgeInsets.all(0.5),
                child: Text(
                  'msg4'.tr,
                  textAlign: TextAlign.center,
                ),
              ),
              content: Text(""),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                          printerController.deletePrinter(id)
                        },
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () => {
                          Navigator.pop(context),
                        },
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(color: Colors.black),
                    )),
              ],
            ),
          );
        });
  }

  void addPrinter() {
    Get.bottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          // Set border radius to the top left corner
          topRight: Radius.circular(
              10.0), // Set border radius to the top right corner
        ),
      ),
      backgroundColor: Colors.white,
      Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add Printers',
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: printerController.printerName,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  // focusNode: diningController.customerNode,
                  onEditingComplete: () {},
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(
                      hintTextStr: 'Printer Name'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'IP Address',
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 14.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: printerController.ip1,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  // focusNode: diningController.customerNode,
                  onEditingComplete: () {},
                  keyboardType: TextInputType.text,
                  decoration:
                      TextFieldDecoration.defaultTextField(hintTextStr: ''),
                ),
              ),

              ///ip textfield commented here
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width/6.5,
              //         child: TextField(
              //           textCapitalization: TextCapitalization.words,
              //           controller: printerController.ip1,
              //           style: customisedStyle(
              //               context, Colors.black, FontWeight.w500, 14.0),
              //           // focusNode: diningController.customerNode,
              //           onEditingComplete: () {
              //
              //           },
              //           keyboardType: TextInputType.text,
              //           decoration: TextFieldDecoration.defaultTextField(
              //               hintTextStr: ''),
              //         ),
              //       ),
              //     ),Text(":"),
              //     Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width/6.5,
              //         child: TextField(
              //           textCapitalization: TextCapitalization.words,
              //           controller: printerController.ip2,
              //           style: customisedStyle(
              //               context, Colors.black, FontWeight.w500, 14.0),
              //           // focusNode: diningController.customerNode,
              //           onEditingComplete: () {
              //
              //           },
              //           keyboardType: TextInputType.text,
              //           decoration: TextFieldDecoration.defaultTextField(
              //               hintTextStr: ''),
              //         ),
              //       ),
              //     ),Text(":"),
              //     Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width/6.5,
              //         child: TextField(
              //           textCapitalization: TextCapitalization.words,
              //           controller: printerController.ip3,
              //           style: customisedStyle(
              //               context, Colors.black, FontWeight.w500, 14.0),
              //           // focusNode: diningController.customerNode,
              //           onEditingComplete: () {
              //
              //           },
              //           keyboardType: TextInputType.text,
              //           decoration: TextFieldDecoration.defaultTextField(
              //               hintTextStr: ''),
              //         ),
              //       ),
              //     ),Text(":"),
              //     Padding(
              //       padding: const EdgeInsets.all(16),
              //       child: Container(
              //         width: MediaQuery.of(context).size.width/6.5,
              //         child: TextField(
              //           textCapitalization: TextCapitalization.words,
              //           controller: printerController.ip4,
              //           style: customisedStyle(
              //               context, Colors.black, FontWeight.w500, 14.0),
              //           // focusNode: diningController.customerNode,
              //           onEditingComplete: () {
              //
              //           },
              //           keyboardType: TextInputType.text,
              //           decoration: TextFieldDecoration.defaultTextField(
              //               hintTextStr: ''),
              //         ),
              //       ),
              //     ),
              //
              //   ],
              // ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 17,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffF25F29)),
                    ),
                    onPressed: () {
                      printerController.createPrinterApi("USB");
                      printerController.listAllPrinter();
                    },
                    child: Text(
                      'save'.tr,
                      style: customisedStyle(
                          context, Colors.white, FontWeight.normal, 12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
