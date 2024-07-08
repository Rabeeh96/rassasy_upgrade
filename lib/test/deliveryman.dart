import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class WaiterApi extends StatefulWidget {
  @override
  State<WaiterApi> createState() => _ReportPageState();
}
////////
class _ReportPageState extends State<WaiterApi> {
  bool isShow = false;
  TextEditingController deliveryName = TextEditingController();

  asd(){

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF3F3F3),
          title:   Text(
            'Waiter'.tr,
            style: const TextStyle(color: Color(0xff0000000)),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Header',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.010,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.green,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.yellow,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.3,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    'Footer',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: isShow == true
            ? Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                  child: const Icon(Icons.clear,color: Colors.black,),
                  onTap: () {
                    setState(() {
                      deliveryName.clear();
                    });
                  }
                  ),
              GestureDetector(
                  child: const Icon(Icons.save,color: Colors.black),
                  onTap: () {
                    createWaiter();
                    setState(() {
                      isShow = false;
                    });
                  }
                  ),
            ],
          ),
        )
            : GestureDetector(
            child: const Icon(Icons.add,color: Colors.black,),
            onTap: () {
              setState(() {
                isShow = true;
              });
            }
            )
    );
  }
  Future<Null> viewList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

    } else {
      print("8888");

      try {
        print("1");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("2");

        var userID = 62;
        var accessToken =
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3MTM2ODI3LCJpYXQiOjE2ODU2MDA4MjcsImp0aSI6ImNiYmU1NjEzMGFjNjRkNjlhZGQ3MGVjNTQyOGU2YjQ1IiwidXNlcl9pZCI6NjJ9.NKIUe-F_IyTvmkLDo1Q7CYxAzIHLXem4qyhHAf50GQrboGi9kDpVnuCfyAmFAuEVEwmGKfzGxrmUZkeNSZISLyYq7jp5ifKL_tCkSj79kEKHL9Qp_x_98UoK4iZeytoLsWsSPZwSrc_I1UpogR36hs9RWs2rpN_nYrxHrabLUY6eTrd1uShl02xy6OHVuzBfP6bXt1kGUAMiENG58bYAieHGfI-ACxfGl9lPeLerOIAJjSBcWuoGk4uP2q9o7SX2PZvJFrt73wGpMXxUr4QFZiEdeIP6eDkgY8_4yzzXVMbPGiI5Gko1QIO-ylwJhWL3FJzgB60dkGksvzOoLtApdbVJL4vZa_M55jyRqRaExSx9SS7uEEy-laGib1CKa0Vu_YrRhzT8ucofn2obk-fSIhg4BrtOAF-0i0govPyzzLQ0S9wBPcmxDb85e-fJ5Ja28NBZ3bdEec5isJxryW5KgwNZk7h4PRRVzQpF3viobnNx4utkbLCfbs5-Ipm5sBbWBq0f5vzaWLheoFp60Bxg6YMY6ob7-2FzjB6BESNW379bL3zG1MWmxnu7fhe7kbL4cyLz8IqZlvzf5dupdrP0SwjP5jkGDFKLsEvg2ymMvMHFJXzGlTf8-UZUC_oe0Kv_vkgZQgvWrOveY5JKBBMfcfYgiW1pYFg93Zf5iaKRPpE";
        var companyID = "5a09676a-55ef-47e3-ab02-bac62005d847";
        var branchID = 1;
        print("3");

        String baseUrl = "https://www.api.viknbooks.tk/api/v10/posholds";
        print("4");

        final String url = '$baseUrl/list-pos-hold-staff/';
        print("5");
        print("$url");

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "staff_type": "1"
        };
        print("6");

        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print("7");

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        print(status);
        print("8");

        var responseJson = n["data"];
        print(responseJson);
        print("9");

        print(status);
        if (status == 6000) {
          setState(() {
            waiterModelClass.clear();
            print("10");

            for (Map user in responseJson) {
              waiterModelClass.add(WaiterModelClass.fromJson(user));
            }
            print("11");
          });
        } else if (status == 6001) {
          print("12");

          // var msg = n["error"];
          // dialogBox(context, msg);
        }
        //DB Error
        else {
          print("13");
        }
      } catch (e) {
        print("Error");
      }
    }
  }
  Future<Null> deleteAnItem(var id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

    } else {
      try {

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = 62;
        var accessToken =
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3MTM2ODI3LCJpYXQiOjE2ODU2MDA4MjcsImp0aSI6ImNiYmU1NjEzMGFjNjRkNjlhZGQ3MGVjNTQyOGU2YjQ1IiwidXNlcl9pZCI6NjJ9.NKIUe-F_IyTvmkLDo1Q7CYxAzIHLXem4qyhHAf50GQrboGi9kDpVnuCfyAmFAuEVEwmGKfzGxrmUZkeNSZISLyYq7jp5ifKL_tCkSj79kEKHL9Qp_x_98UoK4iZeytoLsWsSPZwSrc_I1UpogR36hs9RWs2rpN_nYrxHrabLUY6eTrd1uShl02xy6OHVuzBfP6bXt1kGUAMiENG58bYAieHGfI-ACxfGl9lPeLerOIAJjSBcWuoGk4uP2q9o7SX2PZvJFrt73wGpMXxUr4QFZiEdeIP6eDkgY8_4yzzXVMbPGiI5Gko1QIO-ylwJhWL3FJzgB60dkGksvzOoLtApdbVJL4vZa_M55jyRqRaExSx9SS7uEEy-laGib1CKa0Vu_YrRhzT8ucofn2obk-fSIhg4BrtOAF-0i0govPyzzLQ0S9wBPcmxDb85e-fJ5Ja28NBZ3bdEec5isJxryW5KgwNZk7h4PRRVzQpF3viobnNx4utkbLCfbs5-Ipm5sBbWBq0f5vzaWLheoFp60Bxg6YMY6ob7-2FzjB6BESNW379bL3zG1MWmxnu7fhe7kbL4cyLz8IqZlvzf5dupdrP0SwjP5jkGDFKLsEvg2ymMvMHFJXzGlTf8-UZUC_oe0Kv_vkgZQgvWrOveY5JKBBMfcfYgiW1pYFg93Zf5iaKRPpE";
        var companyID = "5a09676a-55ef-47e3-ab02-bac62005d847";
        var branchID = 1;
        String baseUrl = "https://www.api.viknbooks.tk/api/v10/posholds";
        print("4");

    //       

        final String url = '$baseUrl/delete-pos-hold-staff/';
        print(url);

        Map data = {

          "id": id,
          "CompanyID": "5a09676a-55ef-47e3-ab02-bac62005d847",
          "CreatedUserID": 62,
          "staff_type": "1",
          "BranchID": 1
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
        var status = n["StatusCode"]; //6000 status or messege is here
        var msgs = n["message"];

        print(msgs);
        print(response.body);

        print(status);
        if (status == 6000) {
          setState(() {
            waiterModelClass.clear();
            viewList();
          });
        } else if (status == 6001) {

          var msg = n["message"];
        } else {}
      } catch (e) {
        print("error");
      }
    }
  }
  Future<Null> createWaiter() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

    } else {
      try {
        //start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userID =62;
        var accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzE3MTM2ODI3LCJpYXQiOjE2ODU2MDA4MjcsImp0aSI6ImNiYmU1NjEzMGFjNjRkNjlhZGQ3MGVjNTQyOGU2YjQ1IiwidXNlcl9pZCI6NjJ9.NKIUe-F_IyTvmkLDo1Q7CYxAzIHLXem4qyhHAf50GQrboGi9kDpVnuCfyAmFAuEVEwmGKfzGxrmUZkeNSZISLyYq7jp5ifKL_tCkSj79kEKHL9Qp_x_98UoK4iZeytoLsWsSPZwSrc_I1UpogR36hs9RWs2rpN_nYrxHrabLUY6eTrd1uShl02xy6OHVuzBfP6bXt1kGUAMiENG58bYAieHGfI-ACxfGl9lPeLerOIAJjSBcWuoGk4uP2q9o7SX2PZvJFrt73wGpMXxUr4QFZiEdeIP6eDkgY8_4yzzXVMbPGiI5Gko1QIO-ylwJhWL3FJzgB60dkGksvzOoLtApdbVJL4vZa_M55jyRqRaExSx9SS7uEEy-laGib1CKa0Vu_YrRhzT8ucofn2obk-fSIhg4BrtOAF-0i0govPyzzLQ0S9wBPcmxDb85e-fJ5Ja28NBZ3bdEec5isJxryW5KgwNZk7h4PRRVzQpF3viobnNx4utkbLCfbs5-Ipm5sBbWBq0f5vzaWLheoFp60Bxg6YMY6ob7-2FzjB6BESNW379bL3zG1MWmxnu7fhe7kbL4cyLz8IqZlvzf5dupdrP0SwjP5jkGDFKLsEvg2ymMvMHFJXzGlTf8-UZUC_oe0Kv_vkgZQgvWrOveY5JKBBMfcfYgiW1pYFg93Zf5iaKRPpE";
        var companyID = "5a09676a-55ef-47e3-ab02-bac62005d847";
        var branchID = 1;

        String baseUrl = "https://www.api.viknbooks.tk/api/v10/posholds";

        var taxType = 6;
        final String url = '$baseUrl/create-pos-hold-staff/';


        print(url);

        Map data = {
          "id": "",
          "CompanyID": "5a09676a-55ef-47e3-ab02-bac62005d847",
          "CreatedUserID": 62,
          "staff_type":"1",
          "BranchID": 1,
          "name": deliveryName.text
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {
          setState(() {

            ///
            ///
            ///
          });
        } else if (status == 6001) {
          // stop();
        } else {}
      } catch (e) {
        print("error");
      }
    }
  }


}

List<WaiterModelClass> waiterModelClass = [];

class WaiterModelClass {
  String id, staff_type, name;

  WaiterModelClass(
      {required this.id, required this.staff_type, required this.name});

  factory WaiterModelClass.fromJson(Map<dynamic, dynamic> json) {
    return WaiterModelClass(
        id: json['id'], staff_type: json['staff_type'], name: json['name']);
  }
}