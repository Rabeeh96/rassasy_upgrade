import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'controller/print_controller.dart';

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
  PrintSettingController printController = Get.put(PrintSettingController());

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
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Expanded(
            child: Obx(() => printController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: printController.printDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  printController
                                      .printDetailList[index].printerName,
                                  style: customisedStyle(context,
                                      Colors.black, FontWeight.w400, 14.0),
                                ),
                                Text(
                                  printController
                                      .printDetailList[index].iPAddress,
                                  style: customisedStyle(context, Colors.grey,
                                      FontWeight.normal, 12.0),
                                ),
                              ],
                            ),
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              if (widget.type == "SI") {
                                prefs.setString(
                                        'defaultIP',
                                        printController.printDetailList[index]
                                            .iPAddress) ??
                                    '';
                              } else if (widget.type == "SO") {
                                prefs.setString(
                                        'defaultOrderIP',
                                        printController.printDetailList[index]
                                            .iPAddress) ??
                                    '';
                              } else {
                                prefs.setString(
                                        'defaultOrderIP',
                                        printController.printDetailList[index]
                                            .iPAddress) ??
                                    '';
                                prefs.setString(
                                        'defaultIP',
                                        printController.printDetailList[index]
                                            .iPAddress) ??
                                    '';
                              }

                              Navigator.pop(
                                  context,
                                  printController
                                      .printDetailList[index].printerName);
                            },
                          ),
                          DividerStyle()
                        ],
                      );
                    })),
          )
        ],
      ),
    );
  }
// Future<Null> listAllPrinter() async {
//   try {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var companyID = prefs.getString('companyID') ?? '';
//     var userID = prefs.getInt("user_id");
//     var branchID = prefs.getInt('branchID') ?? 1;
//
//     var accessToken = prefs.getString('access') ?? '';
//
//     String baseUrl = BaseUrl.baseUrl;
//     final String url = '$baseUrl/posholds/printer-list/';
//
//     print(url);
//
//     Map data = {
//       "BranchID": branchID,
//       "CreatedUserID": userID,
//       "CompanyID": companyID,
//       "Type": "WF"
//     };
//     print(data);
//     print(accessToken);
//
//     //encode Map to JSON
//     var body = json.encode(data);
//     var response = await http.post(Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: body);
//     print(response.body);
//
//     Map n = json.decode(utf8.decode(response.bodyBytes));
//     var status = n["StatusCode"];
//     var responseJson = n["data"];
//     print(status);
//     if (status == 6000) {
//       setState(() {
//         printDetailList.clear();
//         for (Map user in responseJson) {
//           printDetailList.add(PrinterListModel.fromJson(user));
//         }
//         stop();
//       });
//     } else if (status == 6001) {
//       setState(() {
//         printDetailList.clear();
//
//       });
//
//       var msg = n["message"];
//       dialogBox(context, msg);
//
//       stop();
//     } else {}
//   } catch (e) {
//
//     dialogBox(context, "Some thing went wrong");
//     stop();
//
//   }
// }
}

// List<PrinterListModel> printDetailList = [];
//
// class PrinterListModel {
//   String id, printerName, iPAddress, type;
//   int printerID;
//
//   PrinterListModel(
//       {required this.id,
//         required this.printerID,
//         required this.printerName,
//         required this.iPAddress,
//         required this.type});
//
//   factory PrinterListModel.fromJson(Map<dynamic, dynamic> json) {
//     return PrinterListModel(
//       id: json['id'],
//       printerID: json['PrinterID'],
//       printerName: json['PrinterName'],
//       iPAddress: json['IPAddress'],
//       type: json['Type'],
//     );
//   }
// }
