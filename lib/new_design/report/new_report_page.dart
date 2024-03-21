import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:rassasy_new/new_design/report/preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'selectDetails/select_group.dart';
import 'selectDetails/select_product.dart';
import 'selectDetails/select_table.dart';

class ReportPageNew extends StatefulWidget {
  const ReportPageNew({Key? key}) : super(key: key);

  @override
  State<ReportPageNew> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPageNew> {
  String number = '';
  bool isSearch = false;
  bool reportType = false;

  bool isTable = false;
  bool isProduct = false;
  int type = 1;
  String title = "Select Table";
  String selectedUserName = "";
  int selectedUserID = 0;

  // String productTitle = "Select Product";
  String tableID = "";
  int productID = 0;
  int deliveryManID = 0;
  String typeHead = "";
  String head = "";
  double grandTotalAmt = 0;

  // String _date = "2033/01/01";
  // String fromDate = "2022/01/01";
  // String toDate = "2022/01/01";
  var netWorkProblem = true;
  bool isLoading = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;
  TextEditingController searchController = TextEditingController();
  TextEditingController selectUserController = TextEditingController();
  TextEditingController productReportController = TextEditingController();
  TextEditingController tableNameController = TextEditingController();
  TextEditingController searchEmployeeController = TextEditingController();

  DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");

  late ValueNotifier<DateTime> fromDateRMSNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toDateRMSNotifier = ValueNotifier(DateTime.now());

  late ValueNotifier<DateTime> fromTimeRMSNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toTimeRMSNotifier = ValueNotifier(DateTime.now());

  DateFormat timeFormatApiFormat = DateFormat('HH:mm');

  late ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());

  late ValueNotifier<DateTime> fromTimeNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toTimeNotifier = ValueNotifier(DateTime.now());

  var grandTotal = "0";
  var cashSum = "0";
  var bankSum = "0";
  var creditSum = "0";
  var totalNoOfSold = "0";

  /// print report

  // loadDataToReport() async {
  //   try {
  //     var htmlData = await returnResponseToHtml();
  //     if (htmlData[0] == 200) {
  //       var html = htmlData[1];
  //       var uriData = await webUriToPdf(htmlData[1]);
  //       if (uriData[0] == 200) {
  //
  //         var file = uriData[1];
  //         var filePath = uriData[2];
  //         // navigation to print
  //           Navigator.push(context, MaterialPageRoute(builder: (context) => PrintPreviewPage(content: html,file: file,savedPath: filePath,)),);
  //       } else {
  //
  //       }
  //     } else {
  //
  //     }
  //   } catch (e) {}
  // }
  // webUriToPdf(content) async {
  //   try {
  //     var s = DateTime.now().microsecondsSinceEpoch;
  //     var timeS = "$s";
  //     var pathPdf = '1';
  //     var path_name = "SalesReport$pathPdf$timeS.pdf";
  //
  //     var directory = await getApplicationDocumentsDirectory();
  //     var pathDetails = p.join(directory.path, path_name);
  //
  //     await WebcontentConverter.contentToPDF(
  //       duration: 0.00,
  //       content: content,
  //       savedPath: pathDetails,
  //       format: PaperFormat.a4,
  //     );
  //     if (pathDetails.isNotEmpty) {
  //      var _file = io.File(pathDetails);
  //       return [200, _file, pathDetails];
  //     } else {
  //       return [400, "", ""];
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }
  // returnResponseToHtml() async {
  //   try {
  //     var statusCode = 200;
  //       var content = HTML.returnSalesReport(reportsList);
  //
  //     if (statusCode == 200) {
  //       return [statusCode, content];
  //     } else {
  //       return [statusCode, ""];
  //     }
  //   } catch (e) {
  //     return [400, ""];
  //   }
  // }

  var content;

  var details = [];

  @override
  void initState() {
    super.initState();
    reloadDate();
    details = [];
    reportsList.clear();
    productReportLists.clear();
    tableReportLists.clear();
  }

  bool carReport = false;
  bool productReport = false;
  bool diningReport = false;
  bool onlineReport = false;
  bool rMSReport = false;
  bool saleReport = false;
  bool tableWiseReport = false;
  bool takeAwayReport = false;

  reloadDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fromDateNotifier = ValueNotifier(DateTime.now());
    toDateNotifier = ValueNotifier(DateTime.now());
    fromDateRMSNotifier = ValueNotifier(DateTime.now());
    toDateRMSNotifier = ValueNotifier(DateTime.now());
    setState(() {
      carReport = prefs.getBool('Car Report') ?? true;
      productReport = prefs.getBool('Product Report') ?? true;
      diningReport = prefs.getBool('Dining Report') ?? true;
      onlineReport = prefs.getBool('Online Report') ?? true;
      rMSReport = prefs.getBool('RMS Report') ?? true;
      saleReport = prefs.getBool('Sale Report') ?? true;
      tableWiseReport = prefs.getBool('Table Wise Report') ?? true;
      takeAwayReport = prefs.getBool('Take Away Report') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Report'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 23,
              ),
            ),
            backgroundColor: const Color(0xffF3F3F3),
            actions: <Widget>[]),
        body: Row(children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 1.5,

            ///types of report detail
            child: selectReportType(),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
              left: BorderSide(width: .6, color: Color(0xffD9D9D9)),
            )),
            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 3,
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      height: MediaQuery.of(context).size.height / 13, //height of button
                      child: Text(
                        'report_type'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                      )),

                  ///lists of report types and select tables
                  Container(
                    //    color: Colors.yellow,
                    height: MediaQuery.of(context).size.height / 1.45, //height of button

                    child: ListView(
                      //  physics: NeverScrollableScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              reloadDate();
                              reportType = true;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xffCBCBCB),
                                width: 0.5,
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 14.5,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(typeHead, style: customisedStyle(context, Color(0xff828282), FontWeight.w500, 12.0)),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                          ),
                        ),

                        reportType == true
                            ? ListView(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  saleReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              type = 1;
                                              chooseReportTypeName(type);
                                              typeHead = "Sales report";
                                              reportType = false;
                                              reportsList.clear();
                                              clearValue();
                                            },
                                            title: Text('sale_rep'.tr),
                                          ),
                                        )
                                      : Container(),
                                  tableWiseReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 6;
                                                chooseReportTypeName(type);

                                                typeHead = "TableWise report";

                                                reportType = false;
                                                reportsList.clear();
                                                tableReportLists.clear();
                                                clearValue();
                                              });
                                            },
                                            title: Text('table_wise'.tr),
                                          ),
                                        )
                                      : Container(),
                                  productReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 7;
                                                chooseReportTypeName(type);

                                                typeHead = "Product wise report";

                                                ///
                                                ///commented no use
                                                // isProduct = true;
                                                // isTable = false;
                                                reportType = false;
                                                productReportLists.clear();
                                                reportsList.clear();
                                                clearValue();
                                              });
                                            },
                                            title: Text('product_rep'.tr),
                                          ),
                                        )
                                      : Container(),
                                  rMSReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 8;
                                                chooseReportTypeName(type);
                                                typeHead = "RMS Summary";
                                                getRmsData();

                                                ///
                                                ///commented no use
                                                // isProduct = true;
                                                // isTable = false;

                                                reportType = false;
                                                productReportLists.clear();
                                                reportsList.clear();
                                                clearValue();
                                              });
                                            },
                                            title: Text('rms_rep'.tr),
                                          ),
                                        )
                                      : Container(),
                                  diningReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 2;
                                                chooseReportTypeName(type);

                                                typeHead = "Dining report";
                                                reportType = false;
                                                reportsList.clear();
                                                clearValue();
                                              });
                                            },
                                            title: const Text('Dining report'),
                                          ),
                                        )
                                      : Container(),
                                  takeAwayReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 3;
                                                chooseReportTypeName(type);
                                                typeHead = "TakeAway report";
                                                reportType = false;
                                                reportsList.clear();
                                                clearValue();
                                              });
                                            },
                                            title: Text('tak_awy_rep'.tr),
                                          ),
                                        )
                                      : Container(),
                                  carReport == true
                                      ? Card(
                                          child: ListTile(
                                            onTap: () {
                                              setState(() {
                                                type = 5;
                                                chooseReportTypeName(type);
                                                typeHead = "Car report";
                                                reportType = false;
                                                reportsList.clear();
                                                clearValue();
                                              });
                                            },
                                            title: Text('car_rep'.tr),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : const SizedBox(),

                        selectProductAndTableList(),

                        type != 8
                            ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'from'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 12.0),
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: fromDateNotifier,
                                        builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                                          return GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                                              height: MediaQuery.of(context).size.height / 15,
                                              width: MediaQuery.of(context).size.width / 7,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                    child: Icon(
                                                      Icons.calendar_today_outlined,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(dateFormat.format(fromDateNewValue),
                                                          style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0)),
                                                      Text(timeFormat.format(fromTimeNotifier.value),
                                                          style: customisedStyle(context, Color(0xff888580), FontWeight.normal, 11.0)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () {
                                              showDatePickerFunction(context, fromDateNotifier, fromTimeNotifier);
                                            },
                                          );
                                        }),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('to'.tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 12.0)),
                                      ValueListenableBuilder(
                                          valueListenable: toDateNotifier,
                                          builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                                            return GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                                                height: MediaQuery.of(context).size.height / 15,
                                                width: MediaQuery.of(context).size.width / 7,
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                                      child: Icon(
                                                        Icons.calendar_today_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(dateFormat.format(fromDateNewValue),
                                                            style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0)),
                                                        Text(timeFormat.format(toTimeNotifier.value),
                                                            style: customisedStyle(context, Color(0xff888580), FontWeight.normal, 11.0)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                showDatePickerFunction(context, toDateNotifier, toTimeNotifier);
                                              },
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              ])
                            : Container(),

/// user filter option commented

                        //
                        // type == 8
                        //     ? Padding(
                        //         padding: const EdgeInsets.only(top: 10.0),
                        //         child: GestureDetector(
                        //           onTap: () async {
                        //             final result = await Navigator.push(
                        //               context,
                        //               MaterialPageRoute(builder: (context) => SelectEmployee()),
                        //             );
                        //             print(result);
                        //             if (result != null) {
                        //               setState(() {
                        //                 selectedUserName = result[0];
                        //                 selectedUserID = result[1];
                        //               });
                        //             } else {}
                        //           },
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //               border: Border.all(
                        //                 color: Colors.grey, // Border color
                        //                 width: 0.5, // Border width
                        //               ),
                        //               borderRadius: BorderRadius.circular(5.0), // Optional: Add rounded corners
                        //             ),
                        //             height: MediaQuery.of(context).size.height * .07,
                        //             width: MediaQuery.of(context).size.width / 8,
                        //             child: Row(
                        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //               children: [
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(left: 10.0),
                        //                   child: Text(
                        //                     selectedUserName,
                        //                     style: customisedStyle(context, Colors.black, FontWeight.normal, 12.5),
                        //                   ),
                        //                 ),
                        //                 Padding(
                        //                   padding: const EdgeInsets.only(right: 10.0),
                        //                   child: const Icon(Icons.arrow_drop_down),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       )
                        //     : Container(),

                        /// old date and time commented
                        // Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment.spaceBetween,
                        //     children: [
                        //
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(bottom: 5.0),
                        //             child: Text(
                        //               "From",
                        //               style:customisedStyle(context, Colors.black, FontWeight.w500, 12.0),
                        //             ),
                        //           ),
                        //           SizedBox(
                        //             width:
                        //                 MediaQuery.of(context).size.width / 7,
                        //             child: TextField(
                        //               keyboardType: TextInputType.number,
                        //               readOnly: true,
                        //               onTap: () {
                        //                 _selectDate(context, 1);
                        //               },
                        //               controller: fromController,
                        //
                        //               decoration: InputDecoration(
                        //                 prefixIcon: Icon(
                        //                   Icons.calendar_today,
                        //                   color: Colors.black,
                        //                 ),
                        //                 focusedBorder:
                        //                     const OutlineInputBorder(
                        //                         borderRadius:
                        //                             BorderRadius.all(
                        //                                 Radius.circular(5.0)),
                        //                         borderSide: BorderSide(
                        //                             color: Colors.grey)),
                        //                 hintText: _date,
                        //                 isDense: true,
                        //                 border: OutlineInputBorder(),
                        //                 contentPadding: EdgeInsets.all(12),
                        //
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //
                        //
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.only(bottom: 5.0),
                        //             child: Text("To",
                        //                 style:customisedStyle(context, Colors.black, FontWeight.w500, 12.0)),
                        //           ),
                        //           SizedBox(
                        //             width:
                        //                 MediaQuery.of(context).size.width / 7,
                        //             child: TextField(
                        //               keyboardType: TextInputType.number,
                        //               readOnly: true,
                        //               onTap: () {
                        //                 _selectDate(context, 2);
                        //               },
                        //               controller: toDateController,
                        //               decoration: InputDecoration(
                        //                 prefixIcon: Icon(
                        //                   Icons.calendar_today,
                        //                   color: Colors.black,
                        //                 ),
                        //                 focusedBorder:
                        //                     const OutlineInputBorder(
                        //                         borderRadius:
                        //                             BorderRadius.all(
                        //                                 Radius.circular(5.0)),
                        //                         borderSide: BorderSide(
                        //                             color: Colors.grey)),
                        //                 hintText: _date,
                        //                 isDense: true,
                        //                 contentPadding: EdgeInsets.all(12),
                        //                 border: OutlineInputBorder(),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ]),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  ///get report button
                  Padding(
                    padding: const EdgeInsets.only(left: 14, top: 8, right: 14, bottom: 8),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 16, //height of button
                      width: MediaQuery.of(context).size.width / 4,
                      child: TextButton(
                        onPressed: () async {
                          var connectivityResult = await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.none) {
                            dialogBox(context, "Unable to connect... Please check internet connection");
                          } else {
                            print("object asd$type");

                            setState(() {
                              reportsList.clear();
                              productReportLists.clear();
                              tableReportLists.clear();
                            });

                            if (type == 6) {
                              print("tableID $tableID");
                              if (tableID == "") {
                                dialogBox(context, "Please select a table");
                              } else {
                                getTableWiseReport();
                              }
                            } else if (type == 7) {
                              print("productID $productID");
                              if (productID == 0) {
                                dialogBox(context, "Please select a product");
                              } else {
                                getProductReport();
                              }
                            } else if (type == 8) {
                              getRmsData();
                            } else {
                              getReports();
                            }
                          }
                        },
                        child: Text('get_rep'.tr,
                            style: TextStyle(
                              color: Color(0xffffffff),
                            )),
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff247B00))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }

  ///list types
  selectReportType() {
    if (type == 1) {
      ///sale report
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            ///heading
            reportHeading(),

            ///list
            salesReportList(),
            const SizedBox(
              height: 10,
            ),

            Container(
              alignment: Alignment.centerRight,
              color: const Color(0xffFFFFFF),
              height: MediaQuery.of(context).size.height / 12,
              //height of button
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Row(
                    children: [
                      Text(
                        'cash1'.tr,
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
                      ),
                      Text(
                        "${roundStringWith(cashSum)}",
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'bank1'.tr,
                        style: TextStyle(color: Color(0xff004067), fontSize: 16),
                      ),
                      Text(
                        ' ${roundStringWith(bankSum)}',
                        style: TextStyle(color: Color(0xff004067), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'credit'.tr,
                        style: TextStyle(color: Color(0xffB44800), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(creditSum)}',
                        style: TextStyle(color: Color(0xffB44800), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'grand_tot'.tr,
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                      Text(
                        '${roundStringWith(grandTotal)}',
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      );
    }
    else if (type == 2) {
      ///dining
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            ///heading
            reportHeading(),
            diningReportList(),
            const SizedBox(
              height: 10,
            ),

            Container(
              alignment: Alignment.centerRight,
              color: const Color(0xffFFFFFF),

              height: MediaQuery.of(context).size.height / 12,
              //height of button
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Row(
                    children: [
                      Text(
                        'cash1'.tr,
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(cashSum)}',
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'bank1'.tr,
                        style: TextStyle(color: Color(0xff004067), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(bankSum)}',
                        style: TextStyle(color: Color(0xff004067), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'credit'.tr,
                        style: TextStyle(color: Color(0xffB44800), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(creditSum)}',
                        style: TextStyle(color: Color(0xffB44800), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'grand_tot'.tr,
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                      Text(
                        '${roundStringWith(grandTotal)}',
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      );
    }
    else if (type == 3) {
      ///take away
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            /// heading
            reportHeading(),
            takeAwayList(),
            const SizedBox(
              height: 10,
            ),

            Container(
              alignment: Alignment.centerRight,
              color: const Color(0xffFFFFFF),

              height: MediaQuery.of(context).size.height / 12,
              //height of button
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Row(
                    children: [
                      Text(
                        'cash1'.tr,
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(cashSum)}',
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'bank1'.tr,
                        style: TextStyle(color: Color(0xff004067), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(bankSum)}',
                        style: TextStyle(color: Color(0xff004067), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'credit'.tr,
                        style: TextStyle(color: Color(0xffB44800), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(creditSum)}',
                        style: TextStyle(color: Color(0xffB44800), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'grand_tot'.tr,
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                      Text(
                        '${roundStringWith(grandTotal)}',
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      );
    }
    else if (type == 4) {
      ///online
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            ///heading
            reportHeading(),

            ///table
            onlineList(),
            const SizedBox(
              height: 10,
            ),

            Container(
              alignment: Alignment.centerRight,
              color: const Color(0xffFFFFFF),
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  Row(
                    children: [
                      Text(
                        'cash1'.tr,
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(cashSum)}',
                        style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'bank1'.tr,
                        style: TextStyle(color: Color(0xff004067), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(bankSum)}',
                        style: TextStyle(color: Color(0xff004067), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'credit'.tr,
                        style: TextStyle(color: Color(0xffB44800), fontSize: 16),
                      ),
                      Text(
                        '${roundStringWith(creditSum)}',
                        style: TextStyle(color: Color(0xffB44800), fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'grand_tot'.tr,
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                      Text(
                        '${roundStringWith(grandTotal)}',
                        style: TextStyle(color: Color(0xff000000), fontSize: 20),
                      ),
                    ],
                  )
                ]),
              ),
            )
          ],
        ),
      );
    }
    else if (type == 5) {
      ///car wise report
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            reportHeading(),
            carWiseTableDetail(),
            const SizedBox(
              height: 10,
            ),
            carWiseReportSaleAmountDetail()
          ],
        ),
      );
    }
    else if (type == 6) {
      ///table wise
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            reportHeading(),
            tableDetailList(),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: const Color(0xffFFFFFF),
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 1,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Row(
                  children: [
                    Text(
                      'cash1'.tr,
                      style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
                    ),
                    Text(
                      '${roundStringWith(cashSum)}',
                      style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'bank1'.tr,
                      style: TextStyle(color: Color(0xff004067), fontSize: 16),
                    ),
                    Text(
                      '${roundStringWith(bankSum)}',
                      style: TextStyle(color: Color(0xff004067), fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'credit'.tr,
                      style: TextStyle(color: Color(0xffB44800), fontSize: 16),
                    ),
                    Text(
                      '${roundStringWith(creditSum)}',
                      style: TextStyle(color: Color(0xffB44800), fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'grand_tot'.tr,
                      style: TextStyle(color: Color(0xff000000), fontSize: 20),
                    ),
                    Text(
                      '${roundStringWith(grandTotal)}',
                      style: TextStyle(color: Color(0xff000000), fontSize: 20),
                    ),
                  ],
                )
              ]),
            )
          ],
        ),
      );
    }
    else if (type == 7) {
      ///product wise
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(
          children: [
            reportHeading(),
            productWiseReportTable(),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerRight,
              color: const Color(0xffFFFFFF),

              height: MediaQuery.of(context).size.height / 12,
              //height of button
              width: MediaQuery.of(context).size.width / 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Row(
                    children: [
                      Text(
                        'total_sld'.tr,
                        style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 16.0),
                      ),
                      Text(
                        ' ${roundStringWith(totalNoOfSold)}',
                        style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 18.0),
                        //   style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'grand_tot'.tr,
                        style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 16.0),
                        //style: TextStyle(color: Color(0xff000000), fontSize: 16),
                      ),
                      Text(
                        ' ${roundStringWith(grandTotal.toString())}',
                        style: customisedStyle(context, Color(0xff000000), FontWeight.w600, 18.0),
                      ),
                    ],
                  ),
                ]),
              ),
            )
          ],
        ),
      );
    }
    else if (type == 8) {
      return Container(
        height: MediaQuery.of(context).size.height / 1, //height of button
        width: MediaQuery.of(context).size.width / 1.5,
        child: ListView(children: [
          ///heading
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 0),
            child: Container(
              height: MediaQuery.of(context).size.height / 12, //height of button
              width: MediaQuery.of(context).size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Daily_sum'.tr, style: customisedStyleBold(context, Colors.black, FontWeight.w500, 18.0), textAlign: TextAlign.left),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 6,
                        ),

                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'from'.tr,
                                style: customisedStyle(context, Colors.black, FontWeight.w500, 12.0),
                              ),
                              ValueListenableBuilder(
                                  valueListenable: fromDateNotifier,
                                  builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                                        // height: MediaQuery.of(context).size.height / 16,
                                        //    width: MediaQuery.of(context).size.width / 8,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(dateFormat.format(fromDateNewValue),
                                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 11.0)),
                                                  Text(timeFormat.format(fromTimeNotifier.value),
                                                      style: customisedStyle(context, Color(0xff888580), FontWeight.normal, 10.0)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        showDatePickerFunction(context, fromDateNotifier, fromTimeNotifier);
                                      },
                                    );
                                  }),
                            ],
                          ),
                          SizedBox(
                            width: 25,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('to'.tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 12.0)),
                              ValueListenableBuilder(
                                  valueListenable: toDateNotifier,
                                  builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                                        //  height: MediaQuery.of(context).size.height / 15,
                                        //    width: MediaQuery.of(context).size.width / 9,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                                              child: Icon(
                                                Icons.calendar_today_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(dateFormat.format(fromDateNewValue),
                                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 11.0)),
                                                  Text(timeFormat.format(toTimeNotifier.value),
                                                      style: customisedStyle(context, Color(0xff888580), FontWeight.normal, 10.0)),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        showDatePickerFunction(context, toDateNotifier, toTimeNotifier);
                                      },
                                    );
                                  }),
                            ],
                          ),
                        ]),

                        // ValueListenableBuilder(
                        //     valueListenable: fromDateNotifier,
                        //     builder: (BuildContext ctx, fromDateNewValue, _) {
                        //       return ElevatedButton(
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: Colors.black,
                        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        //             minimumSize: const Size(150, 40),
                        //           ),
                        //           onPressed: () {
                        //             showDate(context, fromDateNotifier);
                        //           },
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               Padding(
                        //                 padding: const EdgeInsets.only(left: 8.0, right: 8),
                        //                 child: Icon(Icons.calendar_month, color: Colors.white),
                        //               ),
                        //               Text(
                        //                 dateFormat.format(fromDateNotifier.value),
                        //                 style: const TextStyle(color: Colors.white, fontSize: 12),
                        //               ),
                        //             ],
                        //           ));
                        //     }),

                        /// old design

                        /// export  section commented
                        // SizedBox(
                        //   width: MediaQuery.of(context).size.width / 10,
                        //   height: MediaQuery.of(context).size.height / 18, //height of button
                        //
                        //   child: TextButton(
                        //     onPressed: () {
                        //       print("Export");
                        //     },
                        //
                        //     ///https://www.syncfusion.com/blogs/post/introducing-excel-library-for-flutter.aspx
                        //     ///Create a simple Excel file in a Flutter application
                        //     child: const Text("Export",
                        //         style: TextStyle(
                        //           color: Color(0xffffffff),
                        //         )),
                        //     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff000000))),
                        //   ),
                        // ),
                        //
                        // const SizedBox(
                        //   width: 10,
                        // ),
                        SizedBox(
                          width: 10,
                        ),

                        /// print
                    SizedBox(
                          height: MediaQuery.of(context).size.height / 18, //height of button
                          width: MediaQuery.of(context).size.width / 10,
                          child: TextButton(
                            onPressed: () {
                                var heading;

                                print("details");


                                generateRmsHtml();


                                // var printType = typeHead;
                                //   if (printType == "Product report") {
                                //     heading = "$typeHead from";
                                //     // PrintPreview.heading = "$typeHead from $fromDate to $toDate of $productTitle";
                                //   } else if (printType == "TableWise report") {
                                //     heading = "$typeHead from ";
                                //   } else {
                                //     heading = "$typeHead from ";
                                //   }
                                //
                                //   print(typeHead);
                                //   _navigatePrinter(context, heading, details, printType);
                                //

                            },
                            child: const Text("Print",
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                )),
                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff00428E))),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          ///list
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.3, //height of button
              width: MediaQuery.of(context).size.width / 1.1,
              child: ListView(
//  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ///
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5, //height of button

                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 19,
                            decoration: BoxDecoration(color: const Color(0xffFFFFFF), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffFFFFFF),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Text(
                                        'particular'.tr,
                                        style: customisedStyleBold(context, const Color(0xff717171), FontWeight.normal, 16.0),
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      'CASH'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.normal, 16.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      'BANK'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.normal, 16.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      'CREDIT'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.normal, 16.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//         height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xff434343), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xff434343),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'opn_blns'.tr,
                                            style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(openingBalanceTotal),
                                            style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(openingBalanceCash),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(openingBalanceBank),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      "",
                                      // roundStringWith(openingBalanceCredit),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0), textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//      height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'sales_invoice'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(salesInvoiceBalance),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(salesInvoiceCash),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(salesInvoiceBank),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(salesInvoiceCredit),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//  height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'sales_return'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(saleReturnBalance),
                                            style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(saleReturnCash),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(saleReturnBank),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(saleReturnCredit),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//   height: MediaQuery.of(context).size.height / 17,
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Purchase_Invoice'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(purchaseInvoiceBalance),
                                            style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(purchaseInvoiceCash),
                                      style: customisedStyleBold(context, Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(purchaseInvoiceBank),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(purchaseInvoiceCredit),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Expenses'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(expenseBalance),
                                            style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(expenseCash),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(expenseBank),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(expenseCredit),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//                height: MediaQuery.of(context).size.height / 17,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Receipts'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(receipt),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(receiptCash),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(receiptBank),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      '',
                                      // roundStringWith(receiptCredit),
                                      style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.w500, 12.0), textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//   height: MediaQuery.of(context).size.height / 17,
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'payment'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(payment),
                                            style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(paymentCash),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(paymentBank),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      '',
                                      // roundStringWith(paymentCredit),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0), textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//     height: MediaQuery.of(context).size.height / 17,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Journals'.tr,
                                            style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(journalsBalance),
                                            style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(journalsCash),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(journalsBank),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      '',
                                      // roundStringWith(journalsCredit),
                                      style: customisedStyleBold(context, const Color(0xffB70404), FontWeight.w500, 12.0), textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
//    height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xff434343), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xff434343),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'closing_balance'.tr,
                                            style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(closingBalance),
                                            style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(closingBalanceCash),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      roundStringWith(closingBalanceBank),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Text(
                                      '',
                                      // roundStringWith(closingBalanceCredit),
                                      style: customisedStyleBold(context, const Color(0xffffffff), FontWeight.w500, 12.0), textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 4.9, //height of button

                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 10.1,
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'sales_summary'.tr,
                                    style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Gross'.tr,
                                                style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                              ),
                                              Text(
                                                roundStringWith(sIGrossAmount),
                                                style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          )),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'disc'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sIDiscountAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "VAT",
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sITaxAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sITotalAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 10.1,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'sale_return_sum'.tr,
                                    style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context).size.width / 4,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Gross'.tr,
                                                style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                              ),
                                              Text(
                                                roundStringWith(sRGrossAmount),
                                                style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          )),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'disc'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sRDiscountAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "VAT",
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sRTaxAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width / 8,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(sRTotalAmount),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 5.5, //height of button

                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height / 23,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 6),
                                child: Text(
                                  'Effective_Sale'.tr,
                                  style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                                ),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total'.tr,
                                            style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(effectiveTotal),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'sale_invo'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(effectiveNoSales),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'sale_return'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(effectiveNo_sales_return),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Effective_Sale1'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(effectiveNo_effective),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(color: const Color(0xffffffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffffffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'CASH'.tr,
                                            style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(effectiveCash_sale),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'BANK'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(effective_bank_sale),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CREDIT'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(effective_credit),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "",
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          "",
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3.15,
                          decoration: BoxDecoration(color: const Color(0xffFffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                          child: Card(
                            color: const Color(0xffFffff),
                            elevation: 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Purchase'.tr,
                                  style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Purchase_Invoice'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(purchaseInvoiceTotalAmount),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    )),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Purchase_Return'.tr,
                                            style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(purchaseReturnTotalAmount),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 3.15,
                          decoration: BoxDecoration(color: const Color(0xffFffff), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                          child: Card(
                            color: const Color(0xffFffff),
                            elevation: 0.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expenses'.tr,
                                  style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(expenseTotal),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9, //height of button
                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0, top: 7, bottom: 7),
                            child: Text(
                              'sale_byt_type'.tr,
                              style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                            ),
                          ),
                          Container(
// height: MediaQuery.of(context).size.height / 17,
                            decoration: BoxDecoration(color: const Color(0xffF5F5F5), border: Border.all(color: const Color(0xffE2E2E2), width: .5)),
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 6,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Dining'.tr,
                                            style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                          ),
                                          Text(
                                            roundStringWith(dineSAleAmount),
                                            style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Take_awy'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(takeAwaySAleAmount),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Car'.tr,
                                          style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        ),
                                        Text(
                                          roundStringWith(carSaleAmount),
                                          style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 9, //height of button

                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              top: 7,
                            ),
                            child: Text(
                              'Order_Detailed'.tr,
                              style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 15,
                            child: Card(
                              color: const Color(0xffF5F5F5),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width / 4.8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffF5F5F5),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'order'.tr,
                                                style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                              ),
                                              Text(
                                                roundStringWith(orderTotal),
                                                style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'amount'.tr,
                                                style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                                textAlign: TextAlign.right,
                                              ),
                                              Text(
                                                roundStringWith(orderAmount),
                                                style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFfffff),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Cancelled'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              roundStringWith(cancelledOrder),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'amount'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                            Text(
                                              roundStringWith(cancelOrderAmount),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 4.8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF5F5F5),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Pending'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(pendingOrder),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'amount'.tr,
                                              style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                            ),
                                            Text(
                                              roundStringWith(pendingAmounts),
                                              style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              top: 7,
                            ),
                            child: Text(
                              'ord_emp'.tr,
                              style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                            ),
                          ),
                          Container(
                            color: const Color(0xffFfffff),
                            height: MediaQuery.of(context).size.height / 20,
                            child: Card(
                              color: const Color(0xffFfffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFfffff),
                                    ),
                                    child: Text(
                                      'Employee'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'order'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'amount'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      '#Cancelled'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'amount'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'Pending'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'amount'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          /// nashid
                          ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 2000, minHeight: 10),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: empListsList.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      color: const Color(0xffF5F5F5),
                                      height: MediaQuery.of(context).size.height / 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            child: Text(
                                              empListsList[i].empName,
                                              style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].sales),
                                              style: customisedStyleBold(context, const Color(0xff007D15), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].sale_amount),
                                              style: customisedStyleBold(context, const Color(0xff007D15), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].cancelled),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].cancelled_amount),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].pending),
                                              style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(empListsList[i].pending_amount),
                                              style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffE2E2E2),
                          )),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 6.0,
                              top: 7,
                            ),
                            child: Text(
                              'sales_emp'.tr,
                              style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                            ),
                          ),
                          Container(
                            color: const Color(0xffFfffff),
                            height: MediaQuery.of(context).size.height / 20,
                            child: Card(
                              color: const Color(0xffFfffff),
                              elevation: 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFfffff),
                                    ),
                                    child: Text(
                                      'Employee'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'Sales'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'amount'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      '#Return'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 12,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Text(
                                      'amount'.tr,
                                      style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 6,
                                    decoration: const BoxDecoration(color: Colors.white
//color: const Color(0xffF5F5F5),
                                        ),
                                    child: Center(
                                      child: Text(
                                        'Effective_Sale'.tr,
                                        style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 2000, minHeight: 10),
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: saleEmpModelList.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      color: const Color(0xffF5F5F5),
                                      height: MediaQuery.of(context).size.height / 20,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width / 8,
                                            child: Text(
                                              saleEmpModelList[i].emplyee_name,
                                              style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(saleEmpModelList[i].sales),
                                              style: customisedStyleBold(context, const Color(0xff007D15), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(saleEmpModelList[i].sale_amount),
                                              style: customisedStyleBold(context, const Color(0xff007D15), FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(saleEmployeeReturn),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: Text(
                                              roundStringWith(saleEmpModelList[i].return_amount),
                                              style: customisedStyleBold(context, Colors.red, FontWeight.w500, 12.0),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width / 6,
                                            child: Center(
                                              child: Text(
                                                roundStringWith(saleEmpModelList[i].effective_sale),
                                                style: customisedStyleBold(context, const Color(0xff000000), FontWeight.w500, 12.0),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    /// delivery details commented
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xffffffff),
                    //       borderRadius: BorderRadius.circular(8.0),
                    //       border: Border.all(
                    //         color: const Color(0xffE2E2E2),
                    //       )),
                    //   child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(
                    //         left: 6.0,
                    //         top: 7,
                    //       ),
                    //       child: Text(
                    //         'Delivery Details',
                    //         style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                    //       ),
                    //     ),
                    //     Container(
                    //       height: MediaQuery.of(context).size.height / 9,
                    //       child: GridView.builder(
                    //           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    //               maxCrossAxisExtent: 200, childAspectRatio: 4 / 3, crossAxisSpacing: 20, mainAxisSpacing: 20),
                    //           itemCount: 8,
                    //           itemBuilder: (BuildContext ctx, index) {
                    //             return Padding(
                    //               padding: const EdgeInsets.all(6.0),
                    //               child: Container(
                    //                 height: MediaQuery.of(context).size.height / 16,
                    //                 width: MediaQuery.of(context).size.width / 4,
                    //                 decoration: BoxDecoration(
                    //                     color: const Color(0xffF5F5F5),
                    //                     borderRadius: BorderRadius.circular(6.0),
                    //                     border: Border.all(
                    //                       color: const Color(0xffE2E2E2),
                    //                     )),
                    //                 child: Card(
                    //                   color: const Color(0xffF5F5F5),
                    //                   elevation: 0.0,
                    //                   child: Column(
                    //                     mainAxisAlignment: MainAxisAlignment.start,
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(
                    //                           left: 6.0,
                    //                           top: 7,
                    //                         ),
                    //                         child: Text(
                    //                           'Savad',
                    //                           style: customisedStyleBold(context, Colors.black, FontWeight.w500, 13.0),
                    //                         ),
                    //                       ),
                    //                       Padding(
                    //                         padding: const EdgeInsets.only(left: 6.0),
                    //                         child: Row(
                    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                           children: [
                    //                             Column(
                    //                               mainAxisAlignment: MainAxisAlignment.start,
                    //                               crossAxisAlignment: CrossAxisAlignment.start,
                    //                               children: [
                    //                                 Text(
                    //                                   "#Orders",
                    //                                   style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                    //                                 ),
                    //                                 Text(
                    //                                   "0.00",
                    //                                   style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                             Column(
                    //                               mainAxisAlignment: MainAxisAlignment.start,
                    //                               crossAxisAlignment: CrossAxisAlignment.start,
                    //                               children: [
                    //                                 Text(
                    //                                   "Amount",
                    //                                   style: customisedStyleBold(context, const Color(0xff717171), FontWeight.w500, 12.0),
                    //                                 ),
                    //                                 Text(
                    //                                   "0.00",
                    //                                   style: customisedStyleBold(context, const Color(0xff007A1C), FontWeight.normal, 10.0),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //             );
                    //           }),
                    //     )
                    //   ]),
                    // )
                  ]),
            ),
          ),
        ]),
      );






      /// old
//    return Container(
//         height: MediaQuery.of(context).size.height / 1, //height of button
//         width: MediaQuery.of(context).size.width / 1.5,
//         child: ListView(
//             children: [
//               ///heading
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 12, top: 0, right: 12, bottom: 0),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height /
//                       12, //height of button
//                   width: MediaQuery.of(context).size.width / 1.1,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text("Daily Summary",
//                           style: customisedStyleBold(
//                               context, Colors.black, FontWeight.w500, 18.0),
//                           textAlign: TextAlign.left),
//                       Padding(
//                         padding: const EdgeInsets.only(
//                             left: 10, top: 0, right: 10, bottom: 0),
//                         child: Row(
//                           children: [
//                             // GestureDetector(
//                             //   child:
//                             //   SvgPicture.asset('assets/svg/export.svg'),
//                             // ),
//                             // const SizedBox(
//                             //   width: 6,
//                             // ),
//                             // GestureDetector(
//                             //   child: SvgPicture.asset('assets/svg/print_pdf.svg',color: Colors.blueAccent,width: 20,height: 20,),
//                             // ),
//                             const SizedBox(
//                               width: 6,
//                             ),
//
//                             ValueListenableBuilder(
//                                 valueListenable: fromDateNotifier,
//                                 builder: (BuildContext ctx, fromDateNewValue, _) {
//                                   //    dateNewValue = apiDateFormat.format(dateTime).toString();
//
//                                   return ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.black,
//                                         // minimumSize: const Size.fromHeight(30),
//                                         shape: RoundedRectangleBorder(
//                                             borderRadius: BorderRadius.circular(10.0)),
//                                         minimumSize: const Size(150, 40),
//                                       ),
//                                       onPressed: () {
//                                       showDate(context, fromDateNotifier);
//
//                                       },
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.only(left: 8.0,right: 8),
//                                             child: Icon(Icons.calendar_month,color: Colors.white),
//                                           ),
//
//                                           Text(
//                                             dateFormat.format(fromDateNotifier.value),
//                                             style: const TextStyle(color: Colors.white,fontSize: 12),
//                                           ),
//                                         ],
//                                       ));
//                                 }),
//                            /// old design
//                             // SizedBox(
//                             //   height: MediaQuery.of(context).size.height /18, //height of button
//                             //   width: MediaQuery.of(context).size.width / 10,
//                             //   child: TextButton(
//                             //     onPressed: () {},
//                             //     style: ButtonStyle(
//                             //         shape: MaterialStateProperty.all<
//                             //             RoundedRectangleBorder>(
//                             //             RoundedRectangleBorder(
//                             //               borderRadius:
//                             //               BorderRadius.circular(9.0),
//                             //             )),
//                             //         backgroundColor:
//                             //         MaterialStateProperty.all(
//                             //             const Color(0xff232323))),
//                             //     child: ValueListenableBuilder(
//                             //         valueListenable: fromDateNotifier,
//                             //         builder: (BuildContext ctx, toDateNewValue, _) {
//                             //           //    dateNewValue = apiDateFormat.format(dateTime).toString();
//                             //
//                             //           return GestureDetector(
//                             //             onTap: ()async {
//                             //             await showDate(context, fromDateNotifier);
//                             //
//                             //                  //await getRmsData();
//                             //               //   showDatePickerFunction(context, toDateNotifier);
//                             //             },
//                             //             child: Container(
//                             //               alignment: Alignment.center,
//                             //
//                             //               width: MediaQuery.of(context).size.width / 5,
//                             //               child: Text(
//                             //                 dateFormat.format(fromDateNotifier.value),
//                             //                 style: const TextStyle(color: Colors.white),
//                             //               ),
//                             //             ),
//                             //           );
//                             //         }),
//                             //   ),
//                             // ),
//
//                             /// export & print section commented
//                             // SizedBox(
//                             //   width: MediaQuery.of(context).size.width / 10,
//                             //   height: MediaQuery.of(context).size.height /
//                             //       18, //height of button
//                             //
//                             //   child: TextButton(
//                             //     onPressed: () {
//                             //       print("Export");
//                             //     },
//                             //     ///https://www.syncfusion.com/blogs/post/introducing-excel-library-for-flutter.aspx
//                             //     ///Create a simple Excel file in a Flutter application
//                             //     child: const Text("Export",
//                             //         style: TextStyle(
//                             //           color: Color(0xffffffff),
//                             //         )),
//                             //     style: ButtonStyle(
//                             //         backgroundColor: MaterialStateProperty.all(
//                             //             const Color(0xff000000))),
//                             //   ),
//                             // ),
//
//                             // const SizedBox(
//                             //   width: 10,
//                             // ),
//                             // SizedBox(
//                             //   height: MediaQuery.of(context).size.height / 18, //height of button
//                             //   width: MediaQuery.of(context).size.width / 10,
//                             //   child: TextButton(
//                             //     onPressed: () {
//                             //
//                             //       if(PrintPreview.details ==null){
//                             //         dialogBox(context, "You have nothing to print");
//                             //       }
//                             //
//                             //       else{
//                             //
//                             //         if(PrintPreview.details.isEmpty){
//                             //           dialogBox(context, "You have nothing to print");
//                             //         }
//                             //         else{
//                             //           PrintPreview.printType = typeHead;
//                             //           if(PrintPreview.printType=="Product report" ){
//                             //             PrintPreview.heading = "$typeHead from $fromDate to $toDate of $productTitle";
//                             //           }
//                             //           else if(PrintPreview.printType=="TableWise report"){
//                             //             PrintPreview.heading = "$typeHead from $fromDate to $toDate of $title";
//                             //           }
//                             //           else{
//                             //             PrintPreview.heading = "$typeHead from $fromDate to $toDate";
//                             //           }
//                             //
//                             //           print(typeHead);
//                             //           _navigatePrinter(context);
//                             //         }
//                             //       }
//                             //
//                             //     },
//                             //     child: const Text("Print",
//                             //         style: TextStyle(
//                             //           color: Color(0xffffffff),
//                             //         )),
//                             //     style: ButtonStyle(
//                             //         backgroundColor: MaterialStateProperty.all(
//                             //             const Color(0xff00428E))),
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               ///list
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 8, top: 0, right: 10, bottom: 0),
//                 child: Container(
//                   height: MediaQuery.of(context).size.height /
//                       1.3, //height of button
//                   width: MediaQuery.of(context).size.width / 1.1,
//                   child: ListView(
//                   //  physics: NeverScrollableScrollPhysics(),
//                       children: [
//                     Container(
//                       height: MediaQuery.of(context).size.height /
//                           1.5, //height of button
//
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: ListView(
//                         physics: NeverScrollableScrollPhysics(),
//                         children: [
//                           Container(
//                             height: MediaQuery.of(context).size.height / 19,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffFFFFFF),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffFFFFFF),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Text(
//                                         "PARTICULARS",
//                                         style: customisedStyleBold(
//                                             context,
//                                             const Color(0xff717171),
//                                             FontWeight.normal,
//                                             16.0),
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       "CASH ",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.normal,
//                                           16.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       "BANK  ",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.normal,
//                                           16.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       "CREDIT  ",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.normal,
//                                           16.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                    //         height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xff434343),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xff434343),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Opening Balance",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffffffff),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(openingBalanceTotal)  ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffffffff),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(openingBalanceCash)  ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(openingBalanceBank),
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(openingBalanceCredit),
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                       //      height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Sales Invoice",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(salesInvoice)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(salesInvoiceCash)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(salesInvoiceBank),
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(salesInvoiceCredit) ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                           //  height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Sales Return",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(saleReturn)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffB70404),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(saleReturnCash)  ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(saleReturnBank)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(saleReturnCredit)  ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                          //   height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Purchase Invoice",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(purchaseInvoice)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffB70404),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(purchaseInvoiceCash)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(purchaseInvoiceBank)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(purchaseInvoiceCredit)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                         //    height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Purchase Return",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             purchaseReturn ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       purchaseReturnCash,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       purchaseReturnBank,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       purchaseReturnCredit   ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                        //     height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Expenses",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(expense),
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffB70404),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(expenseCash)     ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(expenseBank)    ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(expenseCredit)    ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//             //                height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Receipts",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(receipt)  ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(receiptCash)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(receiptBank)  ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(receiptCredit)   ,
//
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff007A1C),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                          //   height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Payment",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(payment)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffB70404),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith( paymentCash)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(  paymentBank)
//                                       ,
//
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(paymentCredit),
//
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                        //     height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Journals",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(journals)
//
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffB70404),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           journalsCash)
//
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           journalsBank)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           journalsCredit)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffB70404),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                         //    height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xff434343),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xff434343),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Closing Balance",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffffffff),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(
//                                                 closingBalance)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xffffffff),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           closingBalanceCash)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           closingBalanceBank)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Text(
//                                       roundStringWith(
//                                           closingBalanceCredit)
//                                       ,
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xffffffff),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height /
//                           4.9, //height of button
//
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             height: MediaQuery.of(context).size.height / 10.1,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Sales Invoice Summary',
//                                     style: customisedStyleBold(context,
//                                         Colors.black, FontWeight.w500, 13.0),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                           width: MediaQuery.of(context)
//                                               .size
//                                               .width /
//                                               4,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Gross",
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff717171),
//                                                     FontWeight.w500,
//                                                     12.0),
//                                               ),
//                                               Text(
//                                                 roundStringWith(
//                                                     sIGrossAmount)
//                                                 ,
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff007A1C),
//                                                     FontWeight.normal,
//                                                     10.0),
//                                               ),
//                                             ],
//                                           )),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Discount",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(sIDiscountAmount)
//                                               ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "VAT",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(sITaxAmount)
//                                               ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith( sITotalAmount)                                                ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: MediaQuery.of(context).size.height / 10.1,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Sales Return Summary',
//                                     style: customisedStyleBold(context,
//                                         Colors.black, FontWeight.w500, 13.0),
//                                   ),
//                                   Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Container(
//                                           width: MediaQuery.of(context)
//                                               .size
//                                               .width /
//                                               4,
//                                           child: Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Gross",
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff717171),
//                                                     FontWeight.w500,
//                                                     12.0),
//                                               ),
//                                               Text(
//                                                 roundStringWith(sRGrossAmount)
//                                                 ,
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff007A1C),
//                                                     FontWeight.normal,
//                                                     10.0),
//                                               ),
//                                             ],
//                                           )),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Discount",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(sRDiscountAmount)
//                                               ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "VAT",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(sRTaxAmount)
//                                               ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Container(
//                                         width: MediaQuery.of(context)
//                                             .size
//                                             .width /
//                                             8,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(sRTotalAmount)
//                                               ,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height /
//                           5.5, //height of button
//
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               height: MediaQuery.of(context).size.height / 23,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 8.0, bottom: 8, left: 6),
//                                 child: Text(
//                                   'Effective Sale',
//                                   style: customisedStyleBold(context,
//                                       Colors.black, FontWeight.w500, 13.0),
//                                 ),
//                               )),
//                           Container(
//                             height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Total",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff717171),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(eSTotalAmount)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "#Sales Invoice",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith(eSSalesInvoice)
//                                           ,
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "#Sales Return",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith(eSSaleReturn)
//                                           ,
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "#Effective Sale",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith( effectiveSale)
//                                           ,
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Container(
//                             height: MediaQuery.of(context).size.height / 15,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffffffff),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffffffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "CASH",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff717171),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith( eSCashAmount)
//                                             ,
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "BANK",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith(eSBankAmount)
//                                           ,
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "CREDIT",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith( eSCreditAmount)
//                                           ,
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           "",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.height / 10,
//                           width: MediaQuery.of(context).size.width / 3.15,
//                           decoration: BoxDecoration(
//                               color: const Color(0xffFffff),
//                               border: Border.all(
//                                   color: const Color(0xffE2E2E2), width: .5)),
//                           child: Card(
//                             color: const Color(0xffFffff),
//                             elevation: 0.0,
//                             child: Column(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceEvenly,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Purchase",
//                                   style: customisedStyleBold(
//                                       context,
//                                       const Color(0xff000000),
//                                       FontWeight.w500,
//                                       12.0),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Purchase Invoice",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(  purchaseInvoiceAmount),
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         )),
//                                     Container(
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Purchase Return",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff717171),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(purchaseReturnAmount),
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Container(
//                           height: MediaQuery.of(context).size.height / 10,
//                           width: MediaQuery.of(context).size.width / 3.15,
//                           decoration: BoxDecoration(
//                               color: const Color(0xffFffff),
//                               border: Border.all(
//                                   color: const Color(0xffE2E2E2), width: .5)),
//                           child: Card(
//                             color: const Color(0xffFffff),
//                             elevation: 0.0,
//                             child: Column(
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceEvenly,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Expenses",
//                                   style: customisedStyleBold(
//                                       context,
//                                       const Color(0xff000000),
//                                       FontWeight.w500,
//                                       12.0),
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Container(
//                                         child: Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(expenseTotal),
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         )),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height /
//                           9, //height of button
//
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 6.0, top: 7, bottom: 7),
//                             child: Text(
//                               'Sale By Type',
//                               style: customisedStyleBold(context,
//                                   Colors.black, FontWeight.w500, 13.0),
//                             ),
//                           ),
//                           Container(
//                            // height: MediaQuery.of(context).size.height / 17,
//                             decoration: BoxDecoration(
//                                 color: const Color(0xffF5F5F5),
//                                 border: Border.all(
//                                     color: const Color(0xffE2E2E2),
//                                     width: .5)),
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           6,
//                                       child: Column(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Dining",
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff717171),
//                                                 FontWeight.w500,
//                                                 12.0),
//                                           ),
//                                           Text(
//                                             roundStringWith(  dineSAleAmount),
//                                             style: customisedStyleBold(
//                                                 context,
//                                                 const Color(0xff007A1C),
//                                                 FontWeight.normal,
//                                                 10.0),
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 6,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Take away",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith(takeAwaySAleAmount),
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 6,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Car",
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff717171),
//                                               FontWeight.w500,
//                                               12.0),
//                                         ),
//                                         Text(
//                                           roundStringWith(carSaleAmount),
//                                           style: customisedStyleBold(
//                                               context,
//                                               const Color(0xff007A1C),
//                                               FontWeight.normal,
//                                               10.0),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       height: MediaQuery.of(context).size.height /
//                           9, //height of button
//
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 6.0,
//                               top: 7,
//                             ),
//                             child: Text(
//                               'Order Detailed',
//                               style: customisedStyleBold(context,
//                                   Colors.black, FontWeight.w500, 13.0),
//                             ),
//                           ),
//                           Container(
//                             height: MediaQuery.of(context).size.height / 15,
//                             child: Card(
//                               color: const Color(0xffF5F5F5),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                       width:
//                                       MediaQuery.of(context).size.width /
//                                           4.8,
//                                       decoration: const BoxDecoration(
//                                         color: Color(0xffF5F5F5),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "#Orders",
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff717171),
//                                                     FontWeight.w500,
//                                                     12.0),
//                                               ),
//                                               Text(
//                                                 roundStringWith( orderTotal),
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff007A1C),
//                                                     FontWeight.normal,
//                                                     10.0),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 "Amount",
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff717171),
//                                                     FontWeight.w500,
//                                                     12.0),
//                                               ),
//                                               Text(
//                                                 roundStringWith(orderAmount),
//                                                 style: customisedStyleBold(
//                                                     context,
//                                                     const Color(0xff007A1C),
//                                                     FontWeight.normal,
//                                                     10.0),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       )),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         4.8,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xffFfffff),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Cancelled",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(
//                                                   cancelledOrder),
//
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Amount",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith( cancelOrderAmount),
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         4.8,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xffF5F5F5),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                       children: [
//                                         Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Pending ",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith(
//                                                   pendingOrder),
//
//
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Amount",
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff717171),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                             Text(
//                                               roundStringWith( pendingAmounts),
//
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007A1C),
//                                                   FontWeight.normal,
//                                                   10.0),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 6.0,
//                               top: 7,
//                             ),
//                             child: Text(
//                               'Order By Employee',
//                               style: customisedStyleBold(context,
//                                   Colors.black, FontWeight.w500, 13.0),
//                             ),
//                           ),
//                           Container(
//                             color: const Color(0xffFfffff),
//                             height: MediaQuery.of(context).size.height / 20,
//                             child: Card(
//                               color: const Color(0xffFfffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xffFfffff),
//                                     ),
//                                     child: Text(
//                                       "Employee",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "#Orders",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Amount",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "#Cancelled",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Amount",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Pending ",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Amount",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           /// nashid
//                           ConstrainedBox(
//                               constraints: BoxConstraints(maxHeight: 2000, minHeight: 10),
//                               child: ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: empListsList.length,
//                                   itemBuilder: (context, i) {
//                                     return Container(
//                                       color: const Color(0xffF5F5F5),
//                                       height: MediaQuery.of(context)
//                                           .size
//                                           .height /
//                                           20,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 8,
//                                             child: Text(
//                                               empListsList[i].empName,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff000000),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               employeeOrder,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007D15),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               employeeAmount,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007D15),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               empListsList[i].cancelled,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               empListsList[i].cancelled_amount,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               empListsList[i].pending,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff000000),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               empListsList[i].pending_amount,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff000000),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }))
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                           color: const Color(0xffffffff),
//                           borderRadius: BorderRadius.circular(8.0),
//                           border: Border.all(
//                             color: const Color(0xffE2E2E2),
//                           )),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                               left: 6.0,
//                               top: 7,
//                             ),
//                             child: Text(
//                               'Sales By Employee',
//                               style: customisedStyleBold(context,
//                                   Colors.black, FontWeight.w500, 13.0),
//                             ),
//                           ),
//                           Container(
//                             color: const Color(0xffFfffff),
//                             height: MediaQuery.of(context).size.height / 20,
//                             child: Card(
//                               color: const Color(0xffFfffff),
//                               elevation: 0.0,
//                               child: Row(
//                                 mainAxisAlignment:
//                                 MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     decoration: const BoxDecoration(
//                                       color: Color(0xffFfffff),
//                                     ),
//                                     child: Text(
//                                       "Employee",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Sales",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Amount",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "#Return",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width /
//                                         12,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Amount",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                   Container(
//                                     width:
//                                     MediaQuery.of(context).size.width / 8,
//                                     decoration: const BoxDecoration(
//                                         color: Colors.white
//                                       //color: const Color(0xffF5F5F5),
//                                     ),
//                                     child: Text(
//                                       "Effective Sale ",
//                                       style: customisedStyleBold(
//                                           context,
//                                           const Color(0xff717171),
//                                           FontWeight.w500,
//                                           12.0),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           ConstrainedBox(
//                               constraints: BoxConstraints(maxHeight: 2000, minHeight: 10),
//                               child: ListView.builder(
//                                   physics: NeverScrollableScrollPhysics(),
//                                   shrinkWrap: true,
//                                   itemCount: saleEmpModelList.length,
//                                   itemBuilder: (context, i) {
//                                     return Container(
//                                       color: const Color(0xffF5F5F5),
//                                       height: MediaQuery.of(context)
//                                           .size
//                                           .height /
//                                           20,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 8,
//                                             child: Text(
//                                               saleEmpModelList[i].emplyee_name,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff000000),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               saleEmpModelList[i].sales,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007D15),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               saleEmpModelList[i].sale_amount,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff007D15),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               saleEmployeeReturn,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 12,
//                                             child: Text(
//                                               saleEmpModelList[i].return_amount,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   Colors.red,
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                 .size
//                                                 .width /
//                                                 8,
//                                             child: Text(
//                                               saleEmpModelList[i].effective_sale,
//                                               style: customisedStyleBold(
//                                                   context,
//                                                   const Color(0xff000000),
//                                                   FontWeight.w500,
//                                                   12.0),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }))
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//
//                 /// delivery details commented
//                     // Container(
//                     //   decoration: BoxDecoration(
//                     //       color: const Color(0xffffffff),
//                     //       borderRadius: BorderRadius.circular(8.0),
//                     //       border: Border.all(
//                     //         color: const Color(0xffE2E2E2),
//                     //       )),
//                     //   child: Column(
//                     //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     //       crossAxisAlignment: CrossAxisAlignment.start,
//                     //       children: [
//                     //         Padding(
//                     //           padding: const EdgeInsets.only(
//                     //             left: 6.0,
//                     //             top: 7,
//                     //           ),
//                     //           child: Text(
//                     //             'Delivery Details',
//                     //             style: customisedStyleBold(context,
//                     //                 Colors.black, FontWeight.w500, 13.0),
//                     //           ),
//                     //         ),
//                     //         Container(
//                     //           height: MediaQuery.of(context).size.height / 9,
//                     //           child: GridView.builder(
//                     //               gridDelegate:
//                     //               const SliverGridDelegateWithMaxCrossAxisExtent(
//                     //                   maxCrossAxisExtent: 200,
//                     //                   childAspectRatio: 4 / 3,
//                     //                   crossAxisSpacing: 20,
//                     //                   mainAxisSpacing: 20),
//                     //               itemCount: 8,
//                     //               itemBuilder: (BuildContext ctx, index) {
//                     //                 return Padding(
//                     //                   padding: const EdgeInsets.all(6.0),
//                     //                   child: Container(
//                     //                     height: MediaQuery.of(context)
//                     //                         .size
//                     //                         .height /
//                     //                         16,
//                     //                     width: MediaQuery.of(context)
//                     //                         .size
//                     //                         .width /
//                     //                         4,
//                     //                     decoration: BoxDecoration(
//                     //                         color: const Color(0xffF5F5F5),
//                     //                         borderRadius:
//                     //                         BorderRadius.circular(6.0),
//                     //                         border: Border.all(
//                     //                           color: const Color(0xffE2E2E2),
//                     //                         )),
//                     //                     child: Card(
//                     //                       color: const Color(0xffF5F5F5),
//                     //                       elevation: 0.0,
//                     //                       child: Column(
//                     //                         mainAxisAlignment:
//                     //                         MainAxisAlignment.start,
//                     //                         crossAxisAlignment:
//                     //                         CrossAxisAlignment.start,
//                     //                         children: [
//                     //                           Padding(
//                     //                             padding:
//                     //                             const EdgeInsets.only(
//                     //                               left: 6.0,
//                     //                               top: 7,
//                     //                             ),
//                     //                             child: Text(
//                     //                               'Savad',
//                     //                               style: customisedStyleBold(
//                     //                                   context,
//                     //                                   Colors.black,
//                     //                                   FontWeight.w500,
//                     //                                   13.0),
//                     //                             ),
//                     //                           ),
//                     //                           Padding(
//                     //                             padding:
//                     //                             const EdgeInsets.only(
//                     //                                 left: 6.0),
//                     //                             child: Row(
//                     //                               mainAxisAlignment:
//                     //                               MainAxisAlignment
//                     //                                   .spaceBetween,
//                     //                               children: [
//                     //                                 Column(
//                     //                                   mainAxisAlignment:
//                     //                                   MainAxisAlignment
//                     //                                       .start,
//                     //                                   crossAxisAlignment:
//                     //                                   CrossAxisAlignment
//                     //                                       .start,
//                     //                                   children: [
//                     //                                     Text(
//                     //                                       "#Orders",
//                     //                                       style: customisedStyleBold(
//                     //                                           context,
//                     //                                           const Color(
//                     //                                               0xff717171),
//                     //                                           FontWeight.w500,
//                     //                                           12.0),
//                     //                                     ),
//                     //                                     Text(
//                     //                                       "0.00",
//                     //                                       style: customisedStyleBold(
//                     //                                           context,
//                     //                                           const Color(
//                     //                                               0xff007A1C),
//                     //                                           FontWeight
//                     //                                               .normal,
//                     //                                           10.0),
//                     //                                     ),
//                     //                                   ],
//                     //                                 ),
//                     //                                 Column(
//                     //                                   mainAxisAlignment:
//                     //                                   MainAxisAlignment
//                     //                                       .start,
//                     //                                   crossAxisAlignment:
//                     //                                   CrossAxisAlignment
//                     //                                       .start,
//                     //                                   children: [
//                     //                                     Text(
//                     //                                       "Amount",
//                     //                                       style: customisedStyleBold(
//                     //                                           context,
//                     //                                           const Color(
//                     //                                               0xff717171),
//                     //                                           FontWeight.w500,
//                     //                                           12.0),
//                     //                                     ),
//                     //                                     Text(
//                     //                                       "0.00",
//                     //                                       style: customisedStyleBold(
//                     //                                           context,
//                     //                                           const Color(
//                     //                                               0xff007A1C),
//                     //                                           FontWeight
//                     //                                               .normal,
//                     //                                           10.0),
//                     //                                     ),
//                     //                                   ],
//                     //                                 ),
//                     //                               ],
//                     //                             ),
//                     //                           ),
//                     //                         ],
//                     //                       ),
//                     //                     ),
//                     //                   ),
//                     //                 );
//                     //               }),
//                     //         )
//                     //       ]),
//                     // )
//
//
//
//                   ]),
//                 ),
//               ),
//             ]),
//       );
    }
  }



  generateRmsHtml(){


    var orderDetails = """
 
    </tr>
    <tr class='hedding '>
    <th class='head '>Employee</th>
    <th class='head' style='background-color: gray' >Orders</th>
    <th class='head' style='background-color: gray' >Amount</th>
    <th class='head' style='background-color: #666666' >Cancelled</th>
    <th class='head' style='background-color: #666666' >Amount</th>
    <th class='head'  >Pending</th>
    <th class='head'  >Amount</th>
    </tr>

    
    """;

//empListsList
// saleEmpModelList

    for (var i = 0; i < empListsList.length; i++) {
      orderDetails += """
      
     <tr>
    <td class="center sm">${empListsList[i].empName}</td>
    <td class="center sm">${roundStringWith(empListsList[i].sales)}</td>
    <td class="center sm">${roundStringWith(empListsList[i].sale_amount)}</td>
    <td class="center sm">${roundStringWith(empListsList[i].cancelled)}</td>
    <td class="center sm">${roundStringWith(empListsList[i].cancelled_amount)}</td>
    <td class="center sm">${roundStringWith(empListsList[i].pending)}</td>
    <td class="center sm">${roundStringWith(empListsList[i].pending_amount)}</td>
    </tr>"""
      ;
    }

    var invoiceDetails = """
     </tr>
    <tr class='hedding '>
    <th class='head '>Employee</th>
    <th class='head' style='background-color: gray' >Orders</th>
    <th class='head' style='background-color: gray' >Amount</th>
    <th class='head' style='background-color: #666666' >Cancelled</th>
    <th class='head' style='background-color: #666666' >Amount</th>
    <th class='head'  >Effective sale</th>

    </tr>
    """;

    for (var i = 0; i < saleEmpModelList.length; i++) {

      invoiceDetails += """
      
     <tr>
    <td class="center sm">${saleEmpModelList[i].emplyee_name}</td>
    <td class="center sm">${roundStringWith(saleEmpModelList[i].sales)}</td>
    <td class="center sm">${roundStringWith(saleEmpModelList[i].sale_amount)}</td>
    <td class="center sm">${roundStringWith(saleEmpModelList[i].returns)}</td>
    <td class="center sm">${roundStringWith(saleEmpModelList[i].return_amount)}</td>
    <td class="center sm">${roundStringWith(saleEmpModelList[i].effective_sale)}</td>
   
    </tr>"""
      ;
    }

    var htmlString=
"""  <html>
    <head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" />
    <style>
    body{
    font-family:Poppins, sans-serif;
    /*font-style:poppins;*/
    }
    table {
    /*font-family: arial, sans-serif;*/
    border-collapse: collapse;
    width: 100%;
    }

    td, th {
    /*border: 1px solid #dddddd;*/
    text-align: left;
    padding: 8px;
    }
    th.company {
    width: 35%
    }
        .bd{
    border: 1px solid #dddddd;
    }

    td.right-align {
    text-align: right
    }
    tr.hedding{
    background-color:#434343;
    border-radius:12px;

    }
    th.head{
    color:#FFFFFF;
    opacity: 1;
    text-align:center;
    font-size:15px;
    }
    td.sm {
    font-size:12px;
    font-weight:500;
    line-height:15px;
    font-style:poppins;
    border: 1px solid #dddddd;
    }
        .top_head{
    font-weight:400;
    font-size:13px;
    text-align:center;
    }
        .wd-25{
    width: 25%;
    }
        .wd-100{
    width: 100%;
    }
        .center{
    text-align:center;
    }

    </style>
    </head>
    <body>

    <h2>Daily Summary</h2>

    <table>
    <tr>
    <th class='top_head' >PARTICILARS</th>
    <th class='top_head'>CASH</th>
    <th class='top_head'>BANK</th>
    <th class='top_head'>CREDIT</th>
    <th class='top_head'>TOTAL</th>
    </tr>

    <tr class='hedding'>
    <th class='head'>Opening Balance</th>
    <th class="head">${roundStringWith(openingBalanceCash)} </th>
    <th class='head'>${roundStringWith(openingBalanceBank)}</th>
    <th class='head'>${roundStringWith(openingBalanceCredit)}</th>
    <th class='head'>${roundStringWith(openingBalanceTotal)}</th>
    </tr>

    <tr>
    <td class="sm">Sales Invoice</td>
    <td class="right-align sm">${roundStringWith(salesInvoiceCash)}</td>
    <td class="right-align sm">${roundStringWith(salesInvoiceBank)}</td>
    <td class="right-align sm">${roundStringWith(salesInvoiceCredit)}</td>
    <td class="right-align sm">${roundStringWith(salesInvoiceBalance)}</td>
    </tr>
    <tr>
    <td class="sm">Sales Return</td>
    <td class="right-align sm">${roundStringWith(saleReturnCash)}</td>
    <td class="right-align sm">${roundStringWith(saleReturnBank)}</td>
    <td class="right-align sm">${roundStringWith(saleReturnCredit)}</td>
    <td class="right-align sm">${roundStringWith(saleReturnBalance)}</td>
    </tr>
    <tr>
    <td class="sm">Purchase Invoice</td>
    <td class="right-align sm">${roundStringWith(purchaseInvoiceCash)}</td>
    <td class="right-align sm">${roundStringWith(purchaseInvoiceBank)}</td>
    <td class="right-align sm">${roundStringWith(purchaseInvoiceCredit)}</td>
    <td class="right-align sm">${roundStringWith(purchaseInvoiceBalance)}</td>
    </tr>
    <tr>
    <td class="sm">Purchase Return</td>
    <td class="right-align sm">${roundStringWith(purchaseReturnCash)}</td>
    <td class="right-align sm">${roundStringWith(purchaseReturnBank)}</td>
    <td class="right-align sm">${roundStringWith(purchaseReturnCredit)}</td>
    <td class="right-align sm">${roundStringWith(purchaseReturnBalance)}</td>
    </tr>
    <tr>
    <td class="sm">Expense</td>
    <td class="right-align sm">${roundStringWith(expenseCash)}</td>
    <td class="right-align sm">${roundStringWith(expenseBank)}</td>
    <td class="right-align sm">${roundStringWith(expenseCredit)}</td>
    <td class="right-align sm">${roundStringWith(expenseBalance)}</td>
    </tr>
    <tr>
    <td class="sm">Receipts</td>
    <td class="right-align sm">${roundStringWith(receiptCash)}</td>
    <td class="right-align sm">${roundStringWith(receiptBank)}</td>
    <td class="right-align sm"> ''</td>
    <td class="right-align sm">${roundStringWith(receipt)}</td>
    </tr>
    <tr>
    <td class="sm">Payments</td>
    <td class="right-align sm">${roundStringWith(paymentCash)}</td>
    <td class="right-align sm">${roundStringWith(paymentBank)}</td>
    <td class="right-align sm">''</td>
    <td class="right-align sm">${roundStringWith(payment)}</td>
    </tr>
    <tr>
    <td class="sm">Journal</td>
    <td class="right-align sm">${roundStringWith(journalsCash)}</td>
    <td class="right-align sm">${roundStringWith(journalsBank)}</td>
    <td class="right-align sm">''</td>
    <td class="right-align sm">${roundStringWith(journalsBalance)}</td>
    </tr>
    <tr class='hedding'>
    <th class='head'>Closing Balance</th>
    <th class="head">${roundStringWith(closingBalanceCash)} </th>
    <th class='head'>${roundStringWith(closingBalanceBank)}</th>
    <th class='head'>${roundStringWith(closingBalanceCredit)}</th>
    <th class='head'>${roundStringWith(closingBalance)}</th>
    </tr>
    </table>
    <!----------------------------->
    <br>
    <table>
    <tr>
    <td colspan='4'>Sales Invoice Summary</td>
    </tr>
    <tr class='hedding'>
    <th class='head wd-25'>Gross</th>
    <th class="head wd-25"> Discount </th>
    <th class='head wd-25'>Vat</th>
    <th class='head wd-25'>Total</th>
    </tr>
    <tr>
    
    <td class="center sm">${roundStringWith(sIGrossAmount)}</td>
    <td class="center sm">${roundStringWith(sIDiscountAmount)}</td>
    <td class="center sm">${roundStringWith(sITaxAmount)}</td>
    <td class="center sm">${roundStringWith(sITotalAmount)}</td>
    </tr>
    <tr><td></td></tr>
    <tr>
    <td colspan='4'>Sales Return Summary</td>
    </tr>
    <tr class='hedding'>
    <th class='head wd-25'>Gross</th>
    <th class="head wd-25"> Discount </th>
    <th class='head wd-25'>Vat</th>
    <th class='head wd-25'>Total</th>
    </tr>
    <tr>
    <td class="center sm">${roundStringWith(sRGrossAmount)}</td>
    <td class="center sm">${roundStringWith(sRDiscountAmount)}</td>
    <td class="center sm">${roundStringWith(sRTaxAmount)}</td>
    <td class="center sm">${roundStringWith(sRTotalAmount)}</td>
    </tr>

    <tr><td></td></tr>
    <tr>
    <td colspan='4'>Effective Sale</td>
    </tr>
    <tr class='hedding'>
    <th class='head wd-25'>Total</th>
    <th class="head wd-25"> Sales Invoice </th>
    <th class='head wd-25'>Sales Return</th>
    <th class='head wd-25'>Effective Sale</th>
    </tr>
    <tr>

    <td class="center sm">${roundStringWith(effectiveTotal)}</td>
    <td class="center sm">${roundStringWith(effectiveNoSales)}</td>
    <td class="center sm">${roundStringWith(effectiveNo_sales_return)}</td>
    <td class="center sm">${roundStringWith(effectiveNo_effective)}</td>
    </tr>
    <tr class='hedding'>
    <th class='head wd-25'>Cash</th>
    <th class="head wd-25"> Bank </th>
    <th class='head wd-25'>Credit</th>
    </tr>
    <tr>
    <td class="center sm">${roundStringWith(effectiveCash_sale)}</td>
    <td class="center sm">${roundStringWith(effective_bank_sale)}</td>
    <td class="center sm">${roundStringWith(effective_credit)}</td>
    </tr>
    <!--------------->
    <tr><td></td></tr>
    <tr>
    <td colspan='4'></td>
    </tr>
    <tr class='hedding'>
    <th class='head wd-25'>Purchase Invoice</th>
    <th class="head wd-25"> Purchase Return </th>
    <th class='head' colspan='2'>Expense</th>
    </tr>
    <tr>
    <td class="center sm">${roundStringWith(purchaseInvoiceTotalAmount)}</td>
    <td class="center sm">${roundStringWith(purchaseReturnTotalAmount)}</td>
    <td class="center sm" colspan='2'>${roundStringWith(expenseTotal)}</td>
    </tr>
    </table>

    <!--------------->
    <br>
    <table>
    <tr>
    <td colspan='4'>Sales By Type</td>
    </tr>
    <tr class='hedding '>
    <th class='head '>Dining</th>
    <th class="head ">Take Away</th>
    <th class='head' >Car</th>
    </tr>
    <tr>
    <td class="center sm">${roundStringWith(dineSAleAmount)}</td>
    <td class="center sm">${roundStringWith(takeAwaySAleAmount)}</td>
    <td class="center sm">${roundStringWith(carSaleAmount)}</td>
    </tr>
    </table>

    <!--------------->
    <br>
    <table>
    <tr>
    <td colspan='4'>Order Details</td>
    </tr>
    <tr class='hedding '>
    <th class='head '>Orders</th>
    <th class="head ">Amount</th>
    <th class='head' style='background-color: gray' >Cancelled</th>
    <th class='head' style='background-color: gray' >Amount</th>
    <th class='head' style='background-color: #575656' >Pending</th>
    <th class='head' style='background-color: #575656' >Amount</th>
    </tr>
    <tr>
    <td class="center sm">${roundStringWith(orderTotal)}</td>
    <td class="center sm">${roundStringWith(orderAmount)}</td>
    <td class="center sm">${roundStringWith(cancelledOrder)}</td>
    <td class="center sm">${roundStringWith(cancelOrderAmount)}</td>
    <td class="center sm">${roundStringWith(pendingOrder)}</td>
    <td class="center sm">${roundStringWith(pendingAmounts)}</td>
    </tr>
    </table>

    <!--------------->
    
    <br>
    <table>
    <tr>
    <td colspan='4'>Order By Employee</td>
    
    $orderDetails
    <tr><td></td></tr>
    <tr>
    <td colspan='4'>Sales By Employee</td>
    </tr>
    
    $invoiceDetails
  
    </table>


    </body>
    </html>""";

    log("message  $htmlString");

    _navigatePrinter(context, "RMS report ", details, "RMS Report",htmlString);

  }
  /// rms report
  String openingBalanceTotal = "0.0";
  String openingBalanceCredit = "0.0";
  String openingBalanceCash = "0.0";
  String openingBalanceBank = "0.0";
  String salesInvoiceBalance = "0.0";
  String salesInvoiceCash = "0.0";
  String salesInvoiceBank = "0.0";
  String salesInvoiceCredit = "0.0";
  String saleReturnBalance = "0.0";
  String saleReturnCredit = "0.0";
  String saleReturnCash = "0.0";
  String saleReturnBank = "0.0";

  String purchaseInvoiceBalance = "0.0";
  String purchaseInvoiceBank = "0.0";
  String purchaseInvoiceCash = "0.0";
  String purchaseInvoiceCredit = "0.0";

  String purchaseReturnBalance = "0.0";
  String purchaseReturnCash = "0.0";
  String purchaseReturnCredit = "0.0";
  String purchaseReturnBank = "0.0";

  String payment = "0.0";
  String paymentCredit = "0.0";
  String paymentCash = "0.0";
  String paymentBank = "0.0";
  String receipt = "0.0";
  String receiptCredit = "0.0";
  String receiptCash = "0.0";
  String receiptBank = "0.0";
  String expenseBalance = "0.0";
  String expenseCredit = "0.0";
  String expenseCash = "0.0";
  String expenseBank = "0.0";

  String journalsBalance = "0.0";
  String journalsCash = "0.0";
  String journalsBank = "0.0";
  String journalsCredit = "0.0";
  String closingBalance = "0.0";
  String closingBalanceCash = "0.0";
  String closingBalanceCredit = "0.0";
  String closingBalanceBank = "0.0";
  String sIGrossAmount = "0.0";
  String sIDiscountAmount = "0.0";
  String sITotalAmount = "0.0";
  String sITaxAmount = "0.0";
  String sRGrossAmount = "0.0";
  String sRDiscountAmount = "0.0";
  String sRTotalAmount = "0.0";
  String sRTaxAmount = "0.0";

  String effectiveNoSales = "0.00";
  String effectiveNo_sales_return = "0.00";
  String effectiveNo_effective = "0.00";
  String effectiveTotal = "0.00";
  String effectiveCash_sale = "0.00";
  String effective_bank_sale = "0.00";
  String effective_credit = "0.00";

  // String eSSalesInvoice = "0.0";
  // String eSTotalAmount = "0.0";
  // String eSBankAmount = "0.0";
  // String eSCreditAmount = "0.0";
  // String eSCashAmount = "0.0";
  String purchaseInvoiceTotalAmount = "0.0";
  String purchaseReturnTotalAmount = "0.0";
  String expenseTotal = "0.0";
  String carSaleAmount = "0.0";
  String dineSAleAmount = "0.0";
  String takeAwaySAleAmount = "0.0";
  String employeePendingAmt = "0.0";
  String employeePending = "0.0";
  String employeeCancelAmount = "0.0";
  String employeeCancel = "0.0";
  String employeeAmount = "0.0";

  String saleEmployee = "0.0";
  String saleEmployeeAmount = "0.0";
  String saleEmployeeReturn = "0.0";
  String saleEmployeeAmount2 = "0.0";
  String saleEmployeeEffectiveSAle = "0.0";
  String pendingAmounts = "0.0";
  String pendingOrder = "0.0";
  String cancelOrderAmount = "0.0";
  String cancelledOrder = "0.0";
  String orderAmount = "0.0";
  String orderTotal = "0.0";

  /// rms api data
  Future<Null> getRmsData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String baseUrl = BaseUrl.baseUrlV11;

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        // if(employeeId !=0){
        //
        //
        // }
        final url = '$baseUrl/posholds/daily-summary/';
        Map data = {
          "CompanyID": companyID,
          "BranchID": 1,
          "Date": apiDateFormat.format(fromDateNotifier.value),
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          "FromTime": timeFormatApiFormat.format(fromTimeNotifier.value),
          "ToTime": timeFormatApiFormat.format(toTimeNotifier.value),
        };

        print(data);
        print(url);

        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.statusCode);
        print(response.body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var openingBalanceResponse = n["opening_balance"];
        var closingBalanceResponse = n["closing_balance"];
        var saleAmountResponse = n["sales_amount"];
        var sales_return_amount = n["sales_return_amount"];
        var purchaseResponseTotal = n["total_purchase"];
        var expenseResponse = n["expenses_amount"];
        var receiptResponse = n["receipts_amount"];
        var paymentResponse = n["payments_amount"];
        var journalResponse = n["journal_amount"];
        var saleInvoiceSummaryResponse = n["sales_invoice_summary"];
        var saleReturnInvoiceSummaryResponse = n["sales_return_invoice_summary"];

        var effectiveSaleResponse = n['effective_sales'];
        var purchase_amountResponse = n['purchase_amount'];
        var purchaseReturnAmountResponse = n['purchase_return_amount'];
        var saleByTypeResponse = n['sales_by_type'];
        var orderDetailResponse = n['order_details'];
        var oderByEmpResponse = n['order_by_emplyees'];
        var saleByEmpResponse = n['sales_by_emplyees'];

        if (status == 6000) {
          stop();
          setState(() {
            empListsList.clear();
            saleEmpModelList.clear();
            openingBalanceBank = openingBalanceResponse['bank_opening_balance'].toString();
            openingBalanceCash = openingBalanceResponse['cash_opening_balance'].toString();
            openingBalanceTotal = openingBalanceResponse['total'].toString();
            closingBalance = closingBalanceResponse['total'].toString();
            closingBalanceBank = closingBalanceResponse['bank_closing_balance'].toString();
            closingBalanceCash = closingBalanceResponse['cash_closing_balance'].toString();

            salesInvoiceBalance = saleAmountResponse['total'].toString();
            salesInvoiceCash = saleAmountResponse['cash_sale'].toString();
            salesInvoiceBank = saleAmountResponse['bank_sale'].toString();
            salesInvoiceCredit = saleAmountResponse['credit_sale'].toString();

            saleReturnBalance = sales_return_amount['total'].toString();
            saleReturnCredit = sales_return_amount['credit_sale_return'].toString();
            saleReturnCash = sales_return_amount['cash_sale_return'].toString();
            saleReturnBank = sales_return_amount['bank_sale_return'].toString();

            purchaseInvoiceTotalAmount = purchaseResponseTotal['total_purchase_invoice'].toString();
            purchaseReturnTotalAmount = purchaseResponseTotal['total_purchase_return'].toString();

            purchaseInvoiceBalance = purchase_amountResponse['total'].toString();
            purchaseInvoiceBank = purchase_amountResponse['bank_purchase'].toString();
            purchaseInvoiceCash = purchase_amountResponse['cash_purchase'].toString();
            purchaseInvoiceCredit = purchase_amountResponse['credit_purchase'].toString();

            purchaseReturnBalance = purchaseReturnAmountResponse['total'].toString();
            purchaseReturnCash = purchaseReturnAmountResponse['cash_purchase_return'].toString();
            purchaseReturnBank = purchaseReturnAmountResponse['bank_purchase_return'].toString();
            purchaseReturnCredit = purchaseReturnAmountResponse['credit_purchase_return'].toString();

            expenseBalance = expenseResponse['total'].toString();
            expenseBank = expenseResponse['bank_expense'].toString();
            expenseCash = expenseResponse['cash_expense'].toString();
            expenseCredit = expenseResponse['credit_expense'].toString();

            receipt = receiptResponse['total'].toString();
            receiptBank = receiptResponse['bank_receipts'].toString();
            receiptCash = receiptResponse['cash_receipts'].toString();
            receiptCredit = receiptResponse['credit_expense'].toString();

            payment = paymentResponse['total'].toString();
            paymentBank = paymentResponse['bank_payments'].toString();
            paymentCash = paymentResponse['cash_payments'].toString();
            paymentCredit = paymentResponse['cash_payments'].toString();

            journalsBalance = journalResponse['total'].toString();
            journalsBank = journalResponse['bank_journal'].toString();
            journalsCash = journalResponse['cash_journal'].toString();

            sIGrossAmount = saleInvoiceSummaryResponse['gross'].toString();
            sIDiscountAmount = saleInvoiceSummaryResponse['discount'].toString();
            sITaxAmount = saleInvoiceSummaryResponse['tax'].toString();
            sITotalAmount = saleInvoiceSummaryResponse['total'].toString();
            sRDiscountAmount = saleReturnInvoiceSummaryResponse['discount'].toString();
            sRGrossAmount = saleReturnInvoiceSummaryResponse['gross'].toString();
            sRTaxAmount = saleReturnInvoiceSummaryResponse['tax'].toString();
            sRTotalAmount = saleReturnInvoiceSummaryResponse['total'].toString();

            effectiveNoSales = effectiveSaleResponse['no_sales'].toString();
            effectiveNo_sales_return = effectiveSaleResponse['no_sales_return'].toString();
            effectiveNo_effective = effectiveSaleResponse['no_effective'].toString();
            effectiveTotal = effectiveSaleResponse['total'].toString();
            effectiveCash_sale = effectiveSaleResponse['effective_cash_sale'].toString();
            effective_bank_sale = effectiveSaleResponse['effective_bank_sale'].toString();
            effective_credit = effectiveSaleResponse['effective_credit'].toString();

            expenseTotal = n['total_expense'].toString();
            dineSAleAmount = saleByTypeResponse['dining_sales'].toString();
            takeAwaySAleAmount = saleByTypeResponse['take_away_sales'].toString();
            carSaleAmount = saleByTypeResponse['car_sales'].toString();
            pendingAmounts = orderDetailResponse['pending_amount'].toString();
            pendingOrder = orderDetailResponse['pending'].toString();
            cancelOrderAmount = orderDetailResponse['cancelled_amount'].toString();
            cancelledOrder = orderDetailResponse['cancelled'].toString();
            orderAmount = orderDetailResponse['orders_amount'].toString();
            orderTotal = orderDetailResponse['orders'].toString();

            for (Map user in oderByEmpResponse) {
              empListsList.add(EmployeeModel.fromJson(user));
            }

            for (Map user in saleByEmpResponse) {
              saleEmpModelList.add(SaleEmployModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        dialogBox(context, "Something went wrong");
        stop();
      }
    }
  }

  ///sales report heading
  Widget reportHeading() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 0, right: 12, bottom: 0),
      child: Container(
        height: MediaQuery.of(context).size.height / 12, //height of button
        width: MediaQuery.of(context).size.width / 1.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(typeHead,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
              child: Row(
                children: [
                  /// export & print section commented
                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 10,
                  //   height: MediaQuery.of(context).size.height /
                  //       18, //height of button
                  //
                  //   child: TextButton(
                  //     onPressed: () {
                  //       print("Export");
                  //     },
                  //     ///https://www.syncfusion.com/blogs/post/introducing-excel-library-for-flutter.aspx
                  //     ///Create a simple Excel file in a Flutter application
                  //     child: const Text("Export",
                  //         style: TextStyle(
                  //           color: Color(0xffffffff),
                  //         )),
                  //     style: ButtonStyle(
                  //         backgroundColor: MaterialStateProperty.all(
                  //             const Color(0xff000000))),
                  //   ),
                  // ),

                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18, //height of button
                    width: MediaQuery.of(context).size.width / 10,
                    child: TextButton(
                      onPressed: () {
                        if (details.isEmpty) {
                          dialogBox(context, "You have nothing to print");
                        } else {
                          var heading = '';
                          if (details.isEmpty) {
                            dialogBox(context, "You have nothing to print");
                          } else {
                            var printType = typeHead;
                            if (printType == "Product report") {
                              heading = "$typeHead from";
                              // PrintPreview.heading = "$typeHead from $fromDate to $toDate of $productTitle";
                            } else if (printType == "TableWise report") {
                              heading = "$typeHead from ";
                            } else {
                              heading = "$typeHead from ";
                            }

                            print(typeHead);
                            _navigatePrinter(context, heading, details, printType,"");
                          }
                        }
                      },
                      child: const Text("Print",
                          style: TextStyle(
                            color: Color(0xffffffff),
                          )),
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff00428E))),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///sales report list
  Widget salesReportList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: reportsList.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reportsList.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].voucherNo, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(reportsList[index].date, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 12.0)),
                                //    style: TextStyle(color: Color(0xff585858)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                reportsList[index].tableName != ""
                                    ? Text(reportsList[index].tableName, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0))
                                    : SizedBox(),
                                Text(reportsList[index].custName, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 12.0)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('total'.tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0)),
                                //     style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(reportsList[index].total, style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0)),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///dining list
  Widget diningReportList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: reportsList.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reportsList.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].voucherNo, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                // style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(reportsList[index].date, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 12.0)),
                                //   style: TextStyle(color: Color(0xff585858)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].tableName, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                Text(reportsList[index].custName, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 12.0)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('total'.tr, style: customisedStyle(context, Color(0xff585858), FontWeight.w600, 15.0)),
                                Text(roundStringWith(reportsList[index].total),
                                    style: customisedStyle(context, Color(0xff585858), FontWeight.w600, 15.0)),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///take away list
  Widget takeAwayList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: reportsList.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reportsList.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].voucherNo, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(reportsList[index].date, style: customisedStyle(context, Color(0xff585858), FontWeight.w500, 12.0)),
                                //   style: TextStyle(color: Color(0xff585858)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                reportsList[index].tableName == ""
                                    ? Container()
                                    : Text(reportsList[index].tableName, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                //    style: TextStyle(fontWeight: FontWeight.w500)),
                                Text(reportsList[index].custName, style: customisedStyle(context, Color(0xff585858), FontWeight.w500, 12.0)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('total'.tr, style: customisedStyle(context, Colors.black, FontWeight.w600, 15.0)),
                                Text(reportsList[index].total, style: customisedStyle(context, Colors.black, FontWeight.w600, 15.0)),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///online list
  Widget onlineList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: reportsList.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reportsList.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].voucherNo, style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  reportsList[index].date,
                                  style: TextStyle(color: Color(0xff585858)),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                reportsList[index].tableName == ""
                                    ? Container()
                                    : Text(reportsList[index].tableName, style: TextStyle(fontWeight: FontWeight.w500)),
                                Text(reportsList[index].custName, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff585858))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('total'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(reportsList[index].total, style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///list of car report
  Widget carWiseTableDetail() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: reportsList.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: reportsList.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(reportsList[index].voucherNo, style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  reportsList[index].date,
                                  style: TextStyle(color: Color(0xff585858)),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                reportsList[index].tableName == ""
                                    ? Container()
                                    : Text(reportsList[index].tableName, style: TextStyle(fontWeight: FontWeight.w500)),
                                Text(reportsList[index].custName, style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff585858))),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('total'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(reportsList[index].total, style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///car wise report total,sale
  Widget carWiseReportSaleAmountDetail() {
    return Container(
      alignment: Alignment.centerRight,
      color: const Color(0xffFFFFFF),
      height: MediaQuery.of(context).size.height / 14,
      width: MediaQuery.of(context).size.width / 1,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 0, right: 12, bottom: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Row(
            children: [
              Text(
                'cash1'.tr,
                style: TextStyle(color: Color(0xff0C4000), fontSize: 16),
              ),
              Text(
                '${roundStringWith(cashSum)}',
                style: TextStyle(color: Color(0xff0C4000), fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'bank1'.tr,
                style: TextStyle(color: Color(0xff004067), fontSize: 16),
              ),
              Text(
                '${roundStringWith(bankSum)}',
                style: TextStyle(color: Color(0xff004067), fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'credit'.tr,
                style: TextStyle(color: Color(0xffB44800), fontSize: 16),
              ),
              Text(
                '${roundStringWith(creditSum)}',
                style: TextStyle(color: Color(0xffB44800), fontSize: 20),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'grand_tot'.tr,
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
              Text(
                '${roundStringWith(grandTotal.toString())}',
                style: TextStyle(color: Color(0xff000000), fontSize: 20),
              ),
            ],
          )
        ]),
      ),
    );
  }

  ///table wise report list view
  Widget tableDetailList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: tableReportLists.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: tableReportLists.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(tableReportLists[index].voucherNo, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(tableReportLists[index].tokenNumber, style: customisedStyle(context, Color(0xff585858), FontWeight.w500, 12.0))
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(tableReportLists[index].tableName, style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                Text(tableReportLists[index].custName, style: customisedStyle(context, Color(0xff585858), FontWeight.w500, 12.0))
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Total " + roundStringWith(tableReportLists[index].total),
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0)),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///product wise report list
  Widget productWiseReportTable() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0, right: 10, bottom: 0),
      child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.4, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: productReportLists.isEmpty
              ? Center(
                  child: ListTile(
                  title: Center(child: Text('no_data'.tr)),
                ))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productReportLists.length,
                  itemExtent: MediaQuery.of(context).size.height / 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xffCFCFCF)), borderRadius: BorderRadius.circular(5.0)),
                        title: Container(
                          //  height: MediaQuery.of(context).size.height/18,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(productReportLists[index].date, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 14.0)),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Product'.tr, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 14.0)
                                        // style: TextStyle(color: Color(0xff585858)),
                                        ),
                                    Text(productReportLists[index].productName,
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 13.50)),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Price'.tr, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 14.0)),
                                    Text(roundStringWith(productReportLists[index].rate),
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.50)),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('no_sold'.tr, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 14.0)),
                                    Row(
                                      children: [
                                        Text(roundStringWith(productReportLists[index].noOfSold),
                                            style: customisedStyle(context, Colors.black, FontWeight.w500, 15.50)),
                                        Text(" ${productReportLists[index].unitName}",
                                            style: customisedStyle(context, Colors.blueGrey, FontWeight.w400, 12.50)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Total'.tr, style: customisedStyle(context, Color(0xff585858), FontWeight.normal, 14.0)),
                                    Text(roundStringWith(productReportLists[index].grandTotal),
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.50)),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    );
                  })),
    );
  }

  ///table ,product ,select

  ///select product and table
  selectProductAndTableList() {
    if (type == 1) {
      return Column();
    } else if (type == 2) {
      return Column();
    } else if (type == 3) {
      return Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          //   child: TypeAheadField<Map<String, dynamic>>(
          //     textFieldConfiguration: TextFieldConfiguration(
          //       style: customisedStyle(
          //         context,
          //         Colors.black,
          //         FontWeight.normal,
          //         12.0,
          //       ),
          //       onTap: () {
          //         searchEmployeeController.clear();
          //       },
          //       controller: searchEmployeeController,
          //       textInputAction: TextInputAction.done,
          //       decoration: InputDecoration(
          //         suffixIcon: IconButton(
          //           onPressed: () {
          //             // searchController.clear();
          //             // productsLists.clear();
          //             // pageNumber = 1;
          //             // firstTime = 1;
          //             // getProductLists();
          //             // setState(() {
          //             //   ///turn back to list tile
          //             //   isSearch=false;
          //             // });
          //           },
          //           icon: Icon(
          //             Icons.arrow_drop_down,
          //             color: Colors.black,
          //           ),
          //         ),
          //         contentPadding: EdgeInsets.all(8),
          //         hintText: 'delivery_man'.tr,
          //         border: OutlineInputBorder(),
          //       ),
          //     ),
          //     suggestionsCallback: (pattern) async {
          //       List<Map<String, dynamic>> data = [];
          //       var response = await returnDeliveryManList(context: context, name: pattern);
          //       if (response[0] == 6000) {
          //         data = (response[1] as List).cast<Map<String, dynamic>>();
          //       } else {}
          //
          //       print("2");
          //       print("_____________________data $data");
          //       if (data.isEmpty) {}
          //       return data;
          //     },
          //     itemBuilder: (context, itemData) {
          //       return Column(
          //         children: [
          //           ListTile(
          //             tileColor: Colors.white,
          //             title: Text(
          //               itemData['UserName'].toString(),
          //               style: customisedStyle(context, Color(0xff0E5E05), FontWeight.normal, 12.0),
          //             ),
          //             subtitle: Text(
          //               itemData['RoleName'] ?? '',
          //               style: customisedStyle(
          //                 context,
          //                 Colors.black,
          //                 FontWeight.normal,
          //                 12.0,
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          //             child: Divider(color: Color(0xffDCDCDC)),
          //           ),
          //         ],
          //       );
          //     },
          //     onSuggestionSelected: (selectedItemData) {
          //       searchEmployeeController.text = selectedItemData["UserName"];
          //       deliveryManID = selectedItemData["EmployeeID"];
          //       print(deliveryManID);
          //     },
          //     noItemsFoundBuilder: (context) {
          //       return ListTile(
          //         title: Text(
          //           'no_item_found'.tr,
          //           style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      );
    } else if (type == 4) {
      return Column();
    } else if (type == 5) {
      return Column();
    } else if (type == 6) {
      ///table list view
      return ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Text('select_table'.tr,
                // style: TextStyle(fontWeight: FontWeight.w800),
                style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
          ),

          GestureDetector(
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectTable()),
              );
              if (result != null) {
                setState(() {
                  tableID = result[1];
                  title = result[0];
                });
              } else {}
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Border color
                  width: 0.5, // Border width
                ),
                borderRadius: BorderRadius.circular(5.0), // Optional: Add rounded corners
              ),
              height: MediaQuery.of(context).size.height * .07,
              width: MediaQuery.of(context).size.width / 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      title,
                      style: customisedStyle(context, Colors.black, FontWeight.normal, 13.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: const Icon(Icons.arrow_drop_down),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          //tbl list api
        ],
      );
    } else if (type == 7) {
      return ListView(
        ///product list view
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              color: Color(0xffffffff),
              height: MediaQuery.of(context).size.height / 14.5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        print("__________________________");
                        setState(() {
                          productReportController.clear();
                          productType = true;
                          print(productType);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height * .07,
                        width: MediaQuery.of(context).size.width / 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                child: SvgPicture.asset(
                              "assets/svg/checkmark-filled.svg",
                              height: 20,
                              color: productType ? Colors.green : Colors.grey,
                            )),

                            // Container(
                            //
                            //   child: isProductGroup
                            //       ? SvgPicture.asset(
                            //     "assets/svg/checkmark-filled_selected.svg",height: 20,
                            //   )
                            //       : SvgPicture.asset(
                            //     "assets/svg/checkmark-filled.svg",height: 20,),
                            // ),
                            Container(
                              child: Text('Product'.tr, style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0)),
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("__________________________");
                        setState(() {
                          productReportController.clear();
                          productType = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        height: MediaQuery.of(context).size.height * .07,
                        width: MediaQuery.of(context).size.width / 7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                child: SvgPicture.asset(
                              "assets/svg/checkmark-filled.svg",
                              height: 20,
                              color: productType ? Colors.grey : Colors.green,
                            )),
                            // Container(
                            //   //   color: Colors.yellow,
                            //   child: isProductGroup
                            //       ? SvgPicture.asset(
                            //     "assets/svg/checkmark-filled.svg",height: 20,
                            //   )
                            //       : SvgPicture.asset(
                            //     "assets/svg/checkmark-filled_selected.svg",height: 20),
                            // ),
                            Container(
                              child: Text('product_group'.tr, style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0)),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Text(
              productType ? "Select Product" : "Select Group",
              style: customisedStyle(
                context,
                Colors.black,
                FontWeight.w500,
                14.0,
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: isSearch == true
          //       ? TextField(
          //           onChanged: (text) {
          //             setState(() {
          //               charLength = text.length;
          //               _searchProducts(text);
          //             });
          //           },
          //     autofocus: true,
          //           controller: searchController,
          //           decoration: InputDecoration(
          //
          //             suffixIcon: IconButton(
          //               onPressed: () {
          //                 searchController.clear();
          //                 productsLists.clear();
          //                 pageNumber = 1;
          //                 firstTime = 1;
          //                   getProductLists();
          //                 setState(() {
          //                   ///turn back to list tile
          //                   isSearch=false;
          //                 });
          //               },
          //               icon: Icon(
          //                 Icons.cancel,
          //                 color: Colors.black,
          //               ),
          //             ),
          //             contentPadding: EdgeInsets.all(8),
          //             hintText: 'Search',
          //             border: OutlineInputBorder(),
          //           ),
          //         )
          //       : ListTile(
          //           shape: RoundedRectangleBorder(
          //               side: const BorderSide(color: Color(0xffCBCBCB)),
          //               borderRadius: BorderRadius.circular(5.0)),
          //           onTap: () {
          //             setState(() {
          //               selectProductTable = true;
          //               getProductLists();
          //             });
          //           },
          //           title: Text(productTitle,style: TextStyle(color: returnColor(productTitle)),),
          //           trailing: IconButton(
          //             onPressed: () {
          //               setState(() {
          //                 isSearch = true;
          //               });
          //             },
          //             icon: const Icon(Icons.search),
          //           )),
          // ),

          TextFormField(
            readOnly: true,
            style: customisedStyle(
              context,
              Colors.black,
              FontWeight.normal,
              12.0,
            ),
            onTap: () async {
              print(productType);
              var result;
              if (productType) {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectProduct()),
                );
              } else {
                result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectGroup()),
                );
              }

              if (result != null) {
                productReportController.text = result[0];
                productID = result[1];
                tableID = "";
              } else {}
            },
            controller: productReportController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  // searchController.clear();
                  // productsLists.clear();
                  // pageNumber = 1;
                  // firstTime = 1;
                  // getProductLists();
                  // setState(() {
                  //   ///turn back to list tile
                  //   isSearch=false;
                  // });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: 'search'.tr,
              border: OutlineInputBorder(),
            ),
          ),

          SizedBox(
            height: 10,
          ),
        ],
      );
    } else if (type == 8) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// commented
          // Text(
          //   "Employee",
          //   style: customisedStyleBold(context,
          //       Colors.black, FontWeight.w500, 13.0),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0,bottom: 10),
          //   child: Container(
          //     // width: MediaQuery.of(context).size.width / 5.5,
          //     child:
          //       TextField(
          //         style: TextStyle(fontSize: 12),
          //         readOnly: true,
          //         onTap: () async {
          //
          //           var result = await Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => SelectEmployee()),
          //           );
          //
          //           print(result);
          //
          //           if (result != null) {
          //             employeeController.text = result[0];
          //             setState(() {
          //               employeeId = result[1];
          //             });
          //
          //
          //           } else {}
          //         },
          //         controller: employeeController,
          //         // focusNode: routesFcNode,
          //         // onEditingComplete: () {
          //         //   FocusScope.of(context).requestFocus(crNoFcNode);
          //         // },
          //         keyboardType: TextInputType.number,
          //         textCapitalization: TextCapitalization.words,
          //         decoration: TextFieldDecoration.rectangleTextFieldIcon(
          //             hintTextStr: ""),
          //       )
          //   ),
          // ),
        ],
      );
    }
  }

  TextEditingController employeeController = TextEditingController();
  TextEditingController userController = TextEditingController();
  var employeeId = 0;
  bool productType = true;

  returnDeliveryManList({context, required name}) async {
    final response;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String baseUrl = BaseUrl.baseUrlV11;
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;

      final url = '$baseUrl/posholds/list/pos-users/';

      print(url);
      print(accessToken);

      Map data = {"CompanyID": companyID, "BranchID": branchID, "PriceRounding": 2, "search": name, "CreatedUserID": userID, "is_deliveryman": true};
      print(data);

      print(data);

      var body = json.encode(data);
      print(url);
      print(accessToken);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      Map n = json.decode(utf8.decode(response.bodyBytes));
      print(response.body);

      var status = n["StatusCode"];
      var responseJson = n["data"];
      print("_________res from api $responseJson");
      return [status, responseJson];
    } catch (e) {
      print(e.toString());
      return [500, "Error"];
    }
  }

  ///get report types
  chooseReportTypeName(int type) {
    if (type == 1) {
      head = 'SalesReport';
    } else if (type == 2) {
      head = 'DiningReport';
    } else if (type == 3) {
      head = 'TakeAwayReport';
    } else if (type == 4) {
      head = 'OnlineReport';
    } else if (type == 5) {
      head = 'CarReport';
    } else if (type == 6) {
      head = 'TableWiseReport';
    } else if (type == 7) {
      head = 'ProductReport';
    } else if (type == 8) {
      head = 'RMS Summary';
    }
  }

  clearValue() {
    print("ads clear called  ");

    setState(() {
      productReportController.clear();
      details = [];
      productID = 0;
      tableID = "";
      title = "";
      grandTotal = "0";
      cashSum = "0";
      bankSum = "0";
      creditSum = "0";
      totalNoOfSold = "0";
    });
  }

  ///get report

  Future<Null> getReports() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = BaseUrl.branchID;
        var userID = prefs.getInt('user_id') ?? 0;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/rassassy-reports/';
        print(url);
        print(accessToken);

        bool isDeliveryMan = false;
        if (type == 3) {
          isDeliveryMan = true;
        }
        var data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": BaseUrl.priceRounding,
          "ReportType": head,
          "filterVal": tableID,
          "DeliveryManID": deliveryManID,
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          "FromTime":timeFormatApiFormat.format(fromTimeNotifier.value),
          "ToTime":timeFormatApiFormat.format(toTimeNotifier.value),
          "CreatedUserID": userID,
        };

        ///filterVal table id in table wise report,product id in productwise id

        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        var responseJson1 = n["sum_values"];
        if (status == 6000) {
          setState(() {
           // productID = 0;
           // tableID = "";

            reportsList.clear();
            stop();

            for (Map user in responseJson) {
              reportsList.add(ReportModel.fromJson(user));
            }

            details = n["data"];
            grandTotal = responseJson1['GrandTotal_sum'].toString();
            cashSum = responseJson1['Cash_sum'].toString();
            bankSum = responseJson1['Bank_sum'].toString();
            creditSum = responseJson1['Credit_sum'].toString();
          });
        } else if (status == 6001) {
          setState(() {
            reportsList.clear();
            grandTotal = "0";
            cashSum = "0";
            bankSum = "0";
            creditSum = "0";
          });

          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  ///product report
  Future<Null> getProductReport() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = BaseUrl.branchID;
        var userID = prefs.getInt('user_id') ?? 0;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/rassassy-reports/';
        print(url);
        print(productID);

        ///filterVal table id in table wise report,product id in productwise id
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": BaseUrl.priceRounding,
          "ReportType": "ProductReport",
          "filterVal": [productID],
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          "FromTime":timeFormatApiFormat.format(fromTimeNotifier.value),
          "ToTime":timeFormatApiFormat.format(toTimeNotifier.value),
          "CreatedUserID": userID,
          "is_productgroup": !productType
        };

        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print(response.body);
        print(body);
        print(accessToken);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        var responseJson1 = n["sum_values"];

        if (status == 6000) {
          setState(() {
           // productID = 0;
            productReportLists.clear();
            details = n["data"];
            stop();

            for (Map user in responseJson) {
              productReportLists.add(ProductReport.fromJson(user));
            }

            grandTotal = responseJson1['GrandTotal_sum'].toString();
            totalNoOfSold = responseJson1['sold_sum'].toString();
            // getProductGrandTotal();
          });
        } else if (status == 6001) {
          setState(() {
            grandTotal = "0";
            totalNoOfSold = "0";
            productReportLists.clear();
          });
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {

          stop();

      }
    }
  }

  ///table wise report
  Future<Null> getTableWiseReport() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = BaseUrl.branchID;
        var userID = prefs.getInt('user_id') ?? 0;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/rassassy-reports/';
        print(url);
        print(tableID);
        print(accessToken);

        ///filterVal table id in table wise report,product id in productwise id
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": BaseUrl.priceRounding,
          "ReportType": "TableWiseReport",
          "filterVal": tableID,
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          "FromTime":timeFormatApiFormat.format(fromTimeNotifier.value),
          "ToTime":timeFormatApiFormat.format(toTimeNotifier.value),
          "CreatedUserID": userID
        };

        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print(response.body);
        print(body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        var responseJson1 = n["sum_values"];

        if (status == 6000) {
          setState(() {
           // tableID = "";
            stop();
            details = n["data"];
            tableReportLists.clear();

            for (Map user in responseJson) {
              tableReportLists.add(TableReport.fromJson(user));
            }

            grandTotal = responseJson1['GrandTotal_sum'].toString();
            cashSum = responseJson1['Cash_sum'].toString();
            bankSum = responseJson1['Bank_sum'].toString();
            creditSum = responseJson1['Credit_sum'].toString();
          });
        } else if (status == 6001) {
          setState(() {
            tableReportLists.clear();
            print("grand total is not zero");
            grandTotal = "0";
            cashSum = "0";
            bankSum = "0";
            creditSum = "0";
            print(grandTotal);
            print(cashSum);
            print(bankSum);
            print(creditSum);
          });
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  showDatePickerFunction(context, ValueNotifier dateNotifier, ValueNotifier timeNotifier) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width / 2;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          width: mWidth * .98,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                    child: Center(
                      child: Text(
                        'select_date'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.bold, 18.0),
                      ),
                    ),
                  ),
                ],
              ),
              CalendarDatePicker(
                onDateChanged: (selectedDate) async {
                  dateNotifier.value = selectedDate;

                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );
                  if (pickedTime != null) {
                    setState(() {
                      timeNotifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
                    });
                  } else {}

                  Navigator.pop(context);
                },
                initialDate: DateTime.now(),
                firstDate: DateTime.now().add(
                  const Duration(days: -100000000),
                ),
                lastDate: DateTime.now().add(const Duration(days: 6570)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// convert to pdf
  _navigatePrinter(BuildContext context, heading, details, printType,html) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PreviewPage(
                heading: head,
                details: details,
                printType: printType,
               html: html,
              )),
    );
    print(result);
    if (result == null) {
    } else {}
  }

  void dispose() {
    super.dispose();
    stop();
  }
}

List<EmployeeModel> empListsList = [];

class EmployeeModel {
  String empName, sales, sale_amount, cancelled, cancelled_amount, pending, pending_amount;

  EmployeeModel({
    required this.empName,
    required this.sale_amount,
    required this.sales,
    required this.cancelled,
    required this.cancelled_amount,
    required this.pending,
    required this.pending_amount,
  });

  factory EmployeeModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeeModel(
        empName: json['emplyee_name'],
        sales: json['sales'].toString(),
        sale_amount: json['sale_amount'].toString(),
        cancelled: json['cancelled'].toString(),
        pending: json['pending'].toString(),
        cancelled_amount: json['cancelled_amount'].toString(),
        pending_amount: json['pending_amount'].toString());
  }
}

List<SaleEmployModel> saleEmpModelList = [];

class SaleEmployModel {
  String emplyee_name, sales, sale_amount, returns, return_amount, effective_sale;

  SaleEmployModel({
    required this.emplyee_name,
    required this.sale_amount,
    required this.sales,
    required this.returns,
    required this.return_amount,
    required this.effective_sale,
  });

  factory SaleEmployModel.fromJson(Map<dynamic, dynamic> json) {
    return SaleEmployModel(
        emplyee_name: json['emplyee_name'],
        sales: json['sales'].toString(),
        sale_amount: json['sale_amount'].toString(),
        returns: json['returns'].toString(),
        effective_sale: json['effective_sale'].toString(),
        return_amount: json['return_amount'].toString());
  }
}

List<ReportModel> reportsList = [];

class ReportModel {
  String id, voucherNo, date, custName, tableName, total;

  ReportModel({required this.id, required this.tableName, required this.voucherNo, required this.date, required this.custName, required this.total});

  factory ReportModel.fromJson(Map<dynamic, dynamic> json) {
    return ReportModel(
      id: json['id'],
      voucherNo: json['VoucherNo'],
      date: json['Date'],
      custName: json['CustomerName'],
      tableName: json['TableName'] ?? '',
      total: json['GrandTotal'].toString(),
    );
  }
}

List<TableReport> tableReportLists = [];

class TableReport {
  String id, voucherNo, date, tokenNumber, custName, tableName, total, dateTime;

  TableReport(
      {required this.id,
      required this.tableName,
      required this.voucherNo,
      required this.date,
      required this.tokenNumber,
      required this.custName,
      required this.total,
      required this.dateTime});

  factory TableReport.fromJson(Map<dynamic, dynamic> json) {
    return TableReport(
        id: json['id'],
        voucherNo: json['VoucherNo'].toString(),
        tokenNumber: json['TokenNumber'].toString(),
        date: json['Date'],
        custName: json['CustomerName'] ?? '',
        tableName: json['TableName'] ?? '',
        total: json['GrandTotal'].toString(),
        dateTime: json['OrderTime'] ?? '');
  }
}

List<ProductReport> productReportLists = [];

class ProductReport {
  String
      //voucherNo,
      date,
      productName,
      rate,
      grandTotalSum,
      unitName,
      soldSum,
      noOfSold,
      grandTotal;

  ProductReport(
      {required this.productName,
      //   required this.voucherNo,
      required this.date,
      required this.rate,
      required this.grandTotalSum,
      required this.unitName,
      required this.soldSum,
      required this.noOfSold,
      required this.grandTotal});

  factory ProductReport.fromJson(Map<dynamic, dynamic> json) {
    return ProductReport(
        //  voucherNo: json['index'],
        date: json['date'],
        productName: json['ProductName'] ?? '',
        unitName: json['UnitName'] ?? '',
        rate: json['rate'].toString(),
        grandTotalSum: json['GrandTotal_sum'].toString(),
        soldSum: json['sold_sum'].toString(),
        noOfSold: json['noOfSold'].toString(),
        grandTotal: json['GrandTotal'].toString());
  }
}
