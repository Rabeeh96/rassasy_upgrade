import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ChangeTable extends StatefulWidget {
  const ChangeTable({Key? key}) : super(key: key);
  @override
  State<ChangeTable> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ChangeTable> {
  @override
  void initState() {
    super.initState();
    tablesLists.clear();
    getTableList();

  }

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
        title:   Text(
          'choose_table'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[300],

      ),
      body: Center(
        child: tablesLists.isNotEmpty?
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: displayProductDetails(),
        ):Center(child: Text('',style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),)),
      ),
    );
  }

  Widget displayProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          height: MediaQuery.of(context).size.height / 1, //height of button
          // width: MediaQuery.of(context).size.width / 1.6,
          child: GridView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),

              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 2.3, //2.4 will workk
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: tablesLists.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, [tablesLists[i].tableName,tablesLists[i].id]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 14, //height of button
                    //    width: MediaQuery.of(context).size.width / 3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffC9C9C9),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Container(

                            height: MediaQuery.of(context).size.height / 18, //height of button
                            width: MediaQuery.of(context).size.width / 16,
                            decoration: BoxDecoration(
                              //  color: Colors.red,
                                border: Border.all(
                                  width: .1,
                                  color: const Color(0xffC9C9C9),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                )),

                            child: SvgPicture.asset("assets/svg/table.svg"),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(

                              // height: MediaQuery.of(context).size.height / 8.5, //height of button
                              width: MediaQuery.of(context).size.width / 12,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(

                                    child: Text(tablesLists[i].tableName,
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 11.5)),
                                  ),



                                ],
                              ),
                              // color: Colors.orange,
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }



  Future<Null> getTableList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/pos-table-list/';

        print(url);
        print(accessToken);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
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

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var statusTable = n["DiningStatusCode"];
        var responseJson = n["data"];
        print(status);
        pr(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            if (statusTable == 6000) {
              tablesLists.clear();

              for (Map user in responseJson) {
                TableListModel table = TableListModel.fromJson(user);
                if (table.status == 'Vacant') {
                  tablesLists.add(table);
                }
              }


            }

          });
        } else if (status == 6001) {
          stop();
          // var msg = n["error"];
          // print(dialogBox(context, msg));
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        stop();
        print("-----------${e.toString()}");
      }
    }
  }


}



List<TableListModel> tablesLists = [];

class TableListModel {
  String id, tableName,status;

  TableListModel({required this.id, required this.tableName, required this.status});

  factory TableListModel.fromJson(Map<dynamic, dynamic> json) {
    return TableListModel(
      id: json['id'],
      tableName: json['title'],
      status: json['Status'],
    );
  }
}





