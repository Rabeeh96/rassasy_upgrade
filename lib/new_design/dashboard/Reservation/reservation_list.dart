import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class ReservationList extends StatefulWidget {
  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationList.clear();
    fromDateNotifier = ValueNotifier(DateTime.now());
    toDateNotifier = ValueNotifier(DateTime.now());
    viewList();
  }

  DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');
  DateFormat timeFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");




  var messageShow ="";

  late  ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  late  ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());


  late  ValueNotifier<DateTime> fromTimeNotifier = ValueNotifier(DateTime.now());
  late  ValueNotifier<DateTime> toTimeNotifier = ValueNotifier(DateTime.now());


  Future<Null> viewList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

      dialogBox(context, "Please check your network connection");
    } else {

      try {

        messageShow = "";


        SharedPreferences prefs = await SharedPreferences.getInstance();
        start(context);
        String baseUrl = BaseUrl.baseUrl;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        final String url = '$baseUrl/posholds/pos-table-reserve-list/';

        Map data = {
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "page_number": 1,
          "page_size": 40,
          "FromDate": apiDateFormat.format(fromDateNotifier.value),
          "ToDate": apiDateFormat.format(toDateNotifier.value),
          // "FromTime":timeFormatApiFormat.format(fromTimeNotifier.value),
          // "ToTime":timeFormatApiFormat.format(toTimeNotifier.value),
        };
        print(url);
        print(data);

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);


        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        print(status);


        var responseJson = n["data"];
        print(responseJson);

        if (status == 6000) {
          stop();
          setState(() {



            reservationList.clear();
            for (Map user in responseJson) {
              reservationList.add(ReservedModelClass.fromJson(user));
            }

            if(reservationList.isEmpty){
              messageShow = "No reservation on selected period";
            }


          });
        } else if (status == 6001) {
          setState(() {
            messageShow = "No reservation on selected period";
          });
          stop();
        } else {
          stop();

        }
      } catch (e) {
        stop();
        print("Error ${e.toString()}");
      }
    }
  }

  var networkConnection = true;
  TextEditingController searchController = TextEditingController();
  showDatePickerFunction(context,ValueNotifier dateNotifier,ValueNotifier timeNotifier) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width/2;
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
                    padding:
                    EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                    child:  Center(
                      child: Text(
                        'select_date'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.bold, 18.0),
                      ),
                    ),

                  ),
                ],
              ),
              CalendarDatePicker(
                onDateChanged: (selectedDate)async {
                  dateNotifier.value = selectedDate;
                  TimeOfDay? pickedTime = await showTimePicker(initialTime: TimeOfDay.now(), context: context,);
                  if (pickedTime != null) {
                   setState(() {
                     messageShow = "";
                     timeNotifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
                      viewList();
                   });
                  } else {
                    messageShow = "";
                    viewList();
                    print("Time is not selected");
                  }

                  //viewList();
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

  showDatePickerF(context,ValueNotifier dateNotifier) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width/2;
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
                    padding:
                    EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                    child:  Center(
                      child: Text(
                        'select_date'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.bold, 18.0),
                      ),
                    ),

                  ),
                ],
              ),
              CalendarDatePicker(
                onDateChanged: (selectedDate)async {
                  dateNotifier.value = selectedDate;
                  viewList();
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

  showTimePickerF(context,ValueNotifier timeNotifier) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width/2;
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
                    padding:
                    EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                    child:  Center(
                      child: Text(
                        'select_date'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.bold, 18.0),
                      ),
                    ),

                  ),
                ],
              ),
              CalendarDatePicker(
                onDateChanged: (selectedDate)async {

                  TimeOfDay? pickedTime = await showTimePicker(initialTime: TimeOfDay.now(), context: context,);
                  if (pickedTime != null) {
                    setState(() {
                      timeNotifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
                      viewList();
                    });
                  } else {
                    // viewList();
                    print("Time is not selected");
                  }

                  //viewList();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xffF8F8F8),
        appBar: AppBar(
          backgroundColor: const Color(0xffF3F3F3),
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:   [
              Text(
                'Reservation'.tr,
                style:customisedStyle(context, Colors.black, FontWeight.bold, 18.0),
              ),
            ],
          ),

        ),
        body: networkConnection == true
            ?  ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                children: [
/// old
//                   ValueListenableBuilder(
//                       valueListenable: fromDateNotifier,
//                       builder: (BuildContext ctx,DateTime fromDateNewValue, _) {
//
//                         return GestureDetector(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//
//                                 Text("From :",style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       border:
//                                       Border.all(color: const Color(0xffCBCBCB))),
//                                   height: MediaQuery.of(context).size.height / 15,
//                                   width: MediaQuery.of(context).size.width / 7,
//                                   child: Row(
//                                     children: [
//                                       SizedBox(width: 10,),
//                                       Icon(
//                                         Icons.calendar_today_outlined,
//                                         color: Colors.black,
//                                       ),
//
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                               dateFormat.format(fromDateNewValue),
//                                               style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)
//                                           ),
//                                           Text(timeFormat.format(fromTimeNotifier.value),
//                                               style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
//                                         ],
//                                       )
//
//
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: (){
//                             showDatePickerFunction(context,fromDateNotifier,fromTimeNotifier);
//                           },
//                         );
//                       }),
//                   ValueListenableBuilder(
//                       valueListenable: toDateNotifier,
//                       builder: (BuildContext ctx,DateTime fromDateNewValue, _) {
//
//                         return GestureDetector(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//
//                                 Text("To :",style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       border:
//                                       Border.all(color: const Color(0xffCBCBCB))),
//                                   height: MediaQuery.of(context).size.height / 15,
//                                   width: MediaQuery.of(context).size.width / 7,
//                                   child: Row(
//                                     children: [
//                                       SizedBox(width: 10,),
//                                       Icon(
//                                         Icons.calendar_today_outlined,
//                                         color: Colors.black,
//                                       ),
//
//                                       Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                               dateFormat.format(fromDateNewValue),
//                                               style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)
//                                           ),
//                                           Text(timeFormat.format(toTimeNotifier.value),
//                                               style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
//                                         ],
//                                       )
//
//
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                           onTap: (){
//                             showDatePickerFunction(context,toDateNotifier,toTimeNotifier);
//                           },
//                         );
//                       }),


                  /// new
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('from'.tr,style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: const Color(0xffCBCBCB))),
                         height: MediaQuery.of(context).size.height / 16,
                          width: MediaQuery.of(context).size.width / 7,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [


                                    ValueListenableBuilder(
                                        valueListenable: fromDateNotifier,
                                        builder: (BuildContext ctx,DateTime fromDateNewValue, _) {

                                          return   GestureDetector(
                                            onTap: (){
                                              showDatePickerF(context,fromDateNotifier);
                                            },
                                            child: Container(

                                           //   color: Colors.red,
                                              child: Text(
                                                  dateFormat.format(fromDateNewValue),
                                                  style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)
                                              ),
                                            ),
                                          );
                                        }),

/// time commented
//                                     ValueListenableBuilder(
//                                         valueListenable: fromTimeNotifier,
//                                         builder: (BuildContext ctx, timeNewValue, _) {
//                                           return GestureDetector(
//                                             onTap: ()async{
//
//                                               TimeOfDay? pickedTime = await showTimePicker(initialTime: TimeOfDay.now(), context: context,);
//                                               if (pickedTime != null) {
//                                                 final time = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
//                                                 final currentDateTime = DateTime.now();
//                                                 final dateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, time.hour, time.minute);
//                                                 fromTimeNotifier.value = dateTime;
//                                                 viewList();
//                                               } else {
//                                                 print("Time is not selected");
//                                               }
//                                             },
//                                             child: Container(
//                                               width: 100,
//                                           //    color: Colors.green,
//                                               child: Text(timeFormat.format(fromTimeNotifier.value),
//                                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
//                                             ),
//                                           );
//                                         }
//                                     ),



                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [

                        Text('to'.tr,style: customisedStyle(context, Colors.black, FontWeight.w800, 12.0),),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: const Color(0xffCBCBCB))),
                          height: MediaQuery.of(context).size.height / 16,
                          width: MediaQuery.of(context).size.width / 7,
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(


                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [


                                    ValueListenableBuilder(
                                        valueListenable: toDateNotifier,
                                        builder: (BuildContext ctx,DateTime toDateNewValue, _) {

                                          return   GestureDetector(
                                            onTap: (){
                                              showDatePickerF(context,toDateNotifier);
                                            },
                                            child: Container(

                                         //     color: Colors.red,
                                              child: Text(
                                                  dateFormat.format(toDateNewValue),
                                                  style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)
                                              ),
                                            ),
                                          );
                                        }),

/// time commented
                                    // ValueListenableBuilder(
                                    //     valueListenable: toTimeNotifier,
                                    //     builder: (BuildContext ctx, timeNewValue, _) {
                                    //       return GestureDetector(
                                    //         onTap: ()async{
                                    //
                                    //           TimeOfDay? pickedTime = await showTimePicker(initialTime: TimeOfDay.now(), context: context,);
                                    //           if (pickedTime != null) {
                                    //             final time = TimeOfDay(hour: pickedTime.hour, minute: pickedTime.minute);
                                    //             final currentDateTime = DateTime.now();
                                    //             final dateTime = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day, time.hour, time.minute);
                                    //             toTimeNotifier.value = dateTime;
                                    //             viewList();
                                    //           } else {
                                    //             print("Time is not selected");
                                    //           }
                                    //         },
                                    //         child: Container(
                                    //         //  height: 35,
                                    //           width: 100,
                                    //       //    color: Colors.green,
                                    //           child: Text(timeFormat.format(toTimeNotifier.value),
                                    //               style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
                                    //         ),
                                    //       );
                                    //     }
                                    // ),


                                    // Text(
                                    //     dateFormat.format(fromDateNewValue),
                                    //     style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0)
                                    // ),
                                    // Text(timeFormat.format(toTimeNotifier.value),
                                    //     style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0)),
                                  ],
                                ),
                              )


                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: reservationList.isNotEmpty?ListView.builder(
                  // the number of items in the list
                    itemCount: reservationList.length,

                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                width: MediaQuery.of(context).size.width/1.3,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children:  [

                                    Container(
                                      width: MediaQuery.of(context).size.width/4.5,
                                      child: Text(
                                        "${reservationList[index].date}   ${reservationList[index].fromTime}",
                                        style: customisedStyle(context, Color(0xff585858), FontWeight.w600, 13.0),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width/4.5,
                                      child: Text(reservationList[index].table_name,
                                        style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),
                                      ),
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width/4.5,

                                      child: Text(
                                        reservationList[index].cust_name,
                                        style: customisedStyle(context, Color(0xff585858), FontWeight.w600, 13.0),
                                      ),
                                    ),



                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width/10,
                                  height: MediaQuery.of(context).size.height/20,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: TextButton(
                                      onPressed: () async{

                                        return await btmDialogueFunction(
                                            isDismissible: true,
                                            context: context,
                                            textMsg: 'Are you sure cancel it ?',
                                            fistBtnOnPressed: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            secondBtnPressed: () async {
                                              var netWork = await checkNetwork();
                                              if (netWork) {
                                                if (!mounted) return;
                                                Navigator.of(context).pop(true);
                                                cancelReserve(reservationList[index].tableId,reservationList[index].id);
                                              } else {
                                                if (!mounted) return;
                                                dialogBox( context,"Check your network connection");
                                              }
                                            },
                                            secondBtnText: 'Yes'.tr);
                                      },
                                      child:   Text(
                                        'cancel'.tr,
                                        style: customisedStyle(context, Color(0xffffffff), FontWeight.w600, 12.0),
                                      )))
                            ],
                          ),
                        ),
                      );
                    }):Container(
                  child: Center(child: Text(messageShow,style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),)),),
              ),
            ),
          ],
        )
            : noNetworkConnectionPage(),
        //  bottomNavigationBar: bottomBar(),
      ),
    );
  }
  Future<Null> cancelReserve(String tableID, String uUID) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        final String url = '$baseUrl/posholds/pos-table-reserve-cancel/';
        print(url);
        Map data = {
          "CompanyID":companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "Table": tableID,
          "ReservationId":uUID
        };
        print(data);
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
        print(status);
        if (status == 6000) {
          var msg = n["message"];
          dialogBox(context,msg);
          viewList();
          stop();
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
          print("13");
        }
      } catch (e) {
        stop();
        print("Error${e.toString()}");
      }
    }
  }
  Widget noNetworkConnectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/warning.svg",
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              //getAllTax();
              // defaultData();
            },
            child: Text('retry'.tr,
                style: TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }
}

List<ReservedModelClass> reservationList = [];



class ReservedModelClass {
  String id, table_name, branchID,cust_name,date,fromTime,toTime,companyID,tableId;

  ReservedModelClass(
      {required this.id, required this.table_name, required this.branchID,required this.cust_name,required this.date,required this.fromTime,required this.toTime,required this.companyID,required this.tableId});

  factory ReservedModelClass.fromJson(Map<dynamic, dynamic> json) {
    return ReservedModelClass(
        id: json['id'],table_name: json['TableName'],branchID: json['BranchID'].toString(),cust_name: json['CustomerName'],
        date: json['Date'],fromTime: json['FromTime'],toTime: json['ToTime'],companyID: json['CompanyID'],tableId: json['Table']
    );
  }
}
class DateTimeHolder {
  DateTime selectedDateTime;

  DateTimeHolder(this.selectedDateTime);
}