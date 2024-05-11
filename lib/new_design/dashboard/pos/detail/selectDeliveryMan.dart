import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SelectPaymentDeliveryMan extends StatefulWidget {
  const SelectPaymentDeliveryMan({Key? key}) : super(key: key);
  @override
  State<SelectPaymentDeliveryMan> createState() => DeliveryManState();
}

class DeliveryManState extends State<SelectPaymentDeliveryMan> {
  @override
  void initState() {
    super.initState();
    getEmployeeDetails();
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
          'delivery_man'.tr,
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
            child:employeeList.isNotEmpty?
            Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: employeeList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title: Text(employeeList[index].name),
                          onTap: () async {
                            Navigator.pop(context, [employeeList[index].name,employeeList[index].employeeID]);
                          },
                        )
                    );
                  }
              ),
            ):Center(child: Text(".......",style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
        ),
      ),
    );
  }

  Future<Null> getEmployeeDetails() async {
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

        String url = "$baseUrl/posholds/list/pos-users/";
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,"search":"",
          "is_deliveryman":true
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
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
             stop();

             employeeList.clear();
            for (Map user in responseJson) {
              employeeList.add(EmployeeModel.fromJson(user));
            }



          });
        } else if (status == 6001) {
          stop();

          dialogBox(context, "No Data");
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
List<EmployeeModel> employeeList = [];




class EmployeeModel {
  final String name;
  final int employeeID;


  EmployeeModel({
    required this.name,
    required this.employeeID,

  });

  factory EmployeeModel.fromJson(Map<dynamic, dynamic> json) {
    return EmployeeModel(
      name: json['UserName'],
      employeeID: json['EmployeeID'],

    );
  }
}





