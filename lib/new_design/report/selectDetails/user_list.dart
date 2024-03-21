import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SelectEmployee extends StatefulWidget {
  const SelectEmployee({Key? key}) : super(key: key);
  @override
  State<SelectEmployee> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectEmployee> {
  @override
  void initState() {
    super.initState();
    getRouteDetails();

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
          'select_employee'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.grey[300],

      ),
      body: Center(
        child: Container(

            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.grey[100],
            // color: Colors.grey[100],
            child:waiterLists.isNotEmpty?Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: waiterLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title: Text(waiterLists[index].name),
                          onTap: () async {
                            Navigator.pop(context, [waiterLists[index].name,waiterLists[index].employeeID]);
                          },
                        )
                    );
                  }
              ),
            ):Center(child: Text('no_emp'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
        ),
      ),
    );
  }

  Future<Null> getRouteDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

      stop();

    } else {
      try {
        String baseUrl = BaseUrl.baseUrlV11;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;


        String url = "$baseUrl/employees/employees-poslist/";

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,
        };


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
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            waiterLists.clear();
            for (Map user in responseJson) {
              waiterLists.add(EmployeeModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {

        print(e.toString());
        stop();

      }
    }
  }
}

List<EmployeeModel> waiterLists = [];

class EmployeeModel {
  final String name;
  final int employeeID;

  EmployeeModel({
    required this.name,
    required this.employeeID


  });

  factory EmployeeModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeeModel(
      name: json['FirstName'],
      employeeID: json['EmployeeID'],
    );
  }
}



