import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../settings_page.dart';



class SelectPrinter extends StatefulWidget {
  const SelectPrinter({Key? key}) : super(key: key);

  @override
  State<SelectPrinter> createState() => SelectPrinterState();
}

class SelectPrinterState extends State<SelectPrinter> {
  @override
  void initState() {
    listAllPrinter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ), //
          title:   Text(
            'select_printer'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[300],
          actions: <Widget>[
            IconButton(
                icon: SvgPicture.asset('assets/svg/sidemenu.svg'),
                onPressed: () {}),
          ]),


        body: Center(
            child: Container(

              height: MediaQuery.of(context).size.height / 1, //height of button
              width: MediaQuery.of(context).size.width / 3,
              color: Colors.grey[100],
              // color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all (20.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: printDetailList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                            title:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(printDetailList[index].printerName,style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),),
                                Text(printDetailList[index].iPAddress,style: customisedStyle(context, Colors.grey, FontWeight.normal, 12.0),),
                              ],
                            ),
                            onTap: () async {

                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              if(SettingsData.defaultPrinterType =="1"){
                                prefs.setString('defaultIP',printDetailList[index].iPAddress) ?? '';
                              }
                              else if (SettingsData.defaultPrinterType =="2"){
                                prefs.setString('defaultOrderIP',printDetailList[index].iPAddress) ?? '';
                              }
                              else{
                                prefs.setString('defaultOrderIP',printDetailList[index].iPAddress) ?? '';
                                prefs.setString('defaultIP',printDetailList[index].iPAddress) ?? '';
                              }


                              Navigator.pop(context, printDetailList[index].printerName);
                            },
                          )
                      );
                    }
                ),
              ),))
///old
      // body: Container(
      //     height:
      //     MediaQuery.of(context).size.height / 1, //height of button
      //     width: MediaQuery.of(context).size.width / 1,
      //     color: Colors.grey[100],
      //     child: ListView.builder(
      //         shrinkWrap: true,
      //         itemCount: printDetailList.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Card(
      //               child: ListTile(
      //                 title: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                   Text(printDetailList[index].printerName),
      //                   Text(printDetailList[index].iPAddress)
      //
      //                 ],),
      //
      //                 onTap: () async {
      //                   SharedPreferences prefs = await SharedPreferences.getInstance();
      //
      //                    if(SettingsData.defaultPrinterType =="1"){
      //                     prefs.setString('defaultIP',printDetailList[index].iPAddress) ?? '';
      //                    }
      //                   else if (SettingsData.defaultPrinterType =="2"){
      //                     prefs.setString('defaultOrderIP',printDetailList[index].iPAddress) ?? '';
      //                    }
      //                   else{
      //                    prefs.setString('defaultOrderIP',printDetailList[index].iPAddress) ?? '';
      //                    prefs.setString('defaultIP',printDetailList[index].iPAddress) ?? '';
      //                    }
      //
      //
      //
      //                   Navigator.pop(context, printDetailList[index].printerName);
      //                 },
      //               ));
      //         })),
    );
  }

  Future<Null> listAllPrinter() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';

        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/printer-list/';

        print(url);

        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "Type": "WF"
        };
        print(data);
        print(accessToken);

        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        if (status == 6000) {
          setState(() {
            printDetailList.clear();
            for (Map user in responseJson) {
              printDetailList.add(PrinterListModel.fromJson(user));
            }
            stop();
          });
        } else if (status == 6001) {
          setState(() {
            printDetailList.clear();

          });

          var msg = n["message"];
          dialogBox(context, msg);

          stop();
        } else {}
      } catch (e) {

          dialogBox(context, "Some thing went wrong");
          stop();

      }
    }
  }



}


List<PrinterListModel> printDetailList = [];

class PrinterListModel {
  String id, printerName, iPAddress, type;
  int printerID;

  PrinterListModel(
      {required this.id,
        required this.printerID,
        required this.printerName,
        required this.iPAddress,
        required this.type});

  factory PrinterListModel.fromJson(Map<dynamic, dynamic> json) {
    return PrinterListModel(
      id: json['id'],
      printerID: json['PrinterID'],
      printerName: json['PrinterName'],
      iPAddress: json['IPAddress'],
      type: json['Type'],
    );
  }
}