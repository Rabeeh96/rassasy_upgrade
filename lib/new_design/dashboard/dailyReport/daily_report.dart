import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DailyReport extends StatefulWidget {
  const DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => DailyReportSection();
}

class DailyReportSection extends State<DailyReport> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fromDateNotifier = ValueNotifier(DateTime.now());
    toDateNotifier = ValueNotifier(DateTime.now());
  }

  DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');

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
        var userName = prefs.getString('user_name') ?? "";
        // if(employeeId !=0){
        //
        //
        // }
        final url = '$baseUrl/posholds/daily-report/';
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          "FromTime": timeFormatApiFormat.format(fromDateNotifier.value),
          "ToTime": timeFormatApiFormat.format(toDateNotifier.value),
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

        if (status == 6000) {

          Map<String, dynamic> salesOrder = n["sales_order"];
          Map<String, dynamic> orderDetails = n["order_details"];
          Map<String, dynamic> saleByType = n["sales_by_type"];
          Map<String, dynamic> effectiveSale = n["effective_sale"];
          Map<String, dynamic> totalRevenue = n["total_revenue"];

          stop();
          printDetail(
            userName: userName,
            fromTime: "",
              effectiveSale: effectiveSale,
            orderDetails: orderDetails,
            saleByType: saleByType,
            salesOrder: salesOrder,
            totalRevenue: totalRevenue
          );
        } else if (status == 6001) {
          stop();
        } else if (status == 6002) {
          stop();
        } else {}
      } catch (e) {
        dialogBox(context, "${e.toString()}");
        stop();
      }
    }
  }

  late ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ), //
        title: Text(
          'Daily Report',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Container(
        //  height: MediaQuery.of(context).size.height / 10,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: fromDateNotifier,
                  builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                    return GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'from'.tr,
                              style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                              height: MediaQuery.of(context).size.height / 15,
                              width: MediaQuery.of(context).size.width / 7,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.black,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(dateFormat.format(fromDateNewValue), style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)),

                                      //  Text("12.00", style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        showDatePickerFunction(context, fromDateNotifier);
                      },
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: ValueListenableBuilder(
                    valueListenable: toDateNotifier,
                    builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'to'.tr,
                                style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(border: Border.all(color: const Color(0xffCBCBCB))),
                                height: MediaQuery.of(context).size.height / 15,
                                width: MediaQuery.of(context).size.width / 7,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.black,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(dateFormat.format(fromDateNewValue),
                                            style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)),
                                        //  Text("12.00", style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          showDatePickerFunction(context, toDateNotifier);
                        },
                      );
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    getRmsData();
                  },
                  child: Text(
                    "Generate Report",
                    style: customisedStyle(context, Colors.red, FontWeight.w500, 15.0),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  var printHelperUsb = USBPrintClass();
  var printHelperIP = AppBlocs();

  printDetail({
    required fromTime,
    required userName,
    required effectiveSale,
    required orderDetails,
    required saleByType,
    required salesOrder,
    required totalRevenue,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    if (defaultIp == "") {
      dialogBox(context, "Please select a printer");
    } else {
      if (printType == 'Wifi') {
        //     {"StatusCode":6000,"message":"Success","sales_order":{"gross_amount":0,"discount":0,"total_tax":0},
        // "order_details":{"orders":0,"orders_amount":0,"cancelled":0,"cancelled_amount":0},
        // "sales_by_type":{"dining_sales":0,"take_away_sales":0,"car_sales":0,"online_sales":0},
        // "effective_sale":{"gross":0.0,"discount":0.0,"tax":0.0,"total":0.0},"total_revenue":{"cash":0,"bank":0,"credit":0}}

        var ret = 2;
        if (ret == 2) {
          printHelperIP.print_report(
              printerIp: defaultIp,
              reportTypeR: "daily_report",
              ctx: context,
              detailsR: "",
              dateR: "",
              totalBankR: "",
              totalCashR: "",
              totalCreditR: "",
              totalGrandR: "",
              totalRevenue: totalRevenue,
              salesOrder: salesOrder,
              saleByType: saleByType,
              orderDetails: orderDetails,
              effectiveSale: effectiveSale,
              fromTime:fromTime,
              userName: userName);
        } else {
          dialogBox(context, 'Please try again later');
        }
        //
      } else {
        var ret = await printHelperUsb.printDetails();
        if (ret == 2) {
          var ip = "";

          /// printHelperUsb.printDailyReport(defaultIp, context);
        } else {
          dialogBox(context, 'Please try again later');
        }
      }
    }
  }

  DateFormat dateFormat = DateFormat("dd/MM/yyy");

  showDatePickerFunction(context, ValueNotifier dateNotifier) {
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
                onDateChanged: (selectedDate) {
                  dateNotifier.value = selectedDate;
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
}
