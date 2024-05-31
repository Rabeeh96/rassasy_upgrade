import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../settings_page.dart';
import 'package:get/get.dart';

class SelectRoles extends StatefulWidget {
  const SelectRoles({Key? key}) : super(key: key);

  @override
  State<SelectRoles> createState() => SelectRolesState();
}

class SelectRolesState extends State<SelectRoles> {
  @override
  void initState() {
    getUsersListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'select_role'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[300],
        elevation: 0.0,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height / 1, //height of button
          width: MediaQuery.of(context).size.width / 1,
          color: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: rolesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: Key('${rolesList[index]}'),
                    background: Container(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const <Widget>[
                            Icon(Icons.delete, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    secondaryBackground: Container(),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'delete_msg'.tr,
                              style: TextStyle(fontSize: 14),
                            ),
                            content: Text(
                                'msg4'.tr,
                                style: TextStyle(fontSize: 14)),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () => {
                                        SettingsData.role_id =
                                            rolesList[index].id,
                                        Navigator.of(context).pop(),
                                        deleteAnItem()
                                      },
                                  child: Text(
                                    'dlt'.tr,
                                    style: TextStyle(color: Colors.red),
                                  )),
                              TextButton(
                                onPressed: () => {Navigator.of(context).pop()},
                                child: Text('cancel'.tr, style: TextStyle()),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    direction: rolesList.length > 1
                        ? DismissDirection.startToEnd
                        : DismissDirection.none,
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.startToEnd) {
                        print('Remove item');
                      } else {
                        print("");
                      }

                      setState(() {
                        rolesList.removeAt(index);
                      });
                    },
                    child: Card(
                        child: ListTile(
                      title: Text(rolesList[index].roleName),
                      onTap: () async {
                        print(rolesList[index].id);
                        // ProductDetail.taxID=taxTypeList[index].taxId.toString();

                        SettingsData.role_id = rolesList[index].id;
                        Navigator.pop(context, rolesList[index].roleName);
                      },

                    )));
              })),
    );
  }

  Future<Null> getUsersListApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
         var branchID = prefs.getInt('branchID') ?? 1;
        var userID = prefs.getInt("user_id");

        var accessToken = prefs.getString('access') ?? '';

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/list/pos-role/';
        print(url);
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
        print(status);
        var responseJson = n["data"];

        if (status == 6000) {
          setState(() {
            rolesList.clear();
            stop();
            for (Map user in responseJson) {
              rolesList.add(RoleListDataModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
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

  Future<Null> deleteAnItem() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);
        var role_id = SettingsData.role_id;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;

        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/delete/pos-role/$role_id/';
        print(url);

        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "BranchID": 1,
          "selecte_ids": [role_id]
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
            rolesList.clear();
            stop();
            getUsersListApi();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          print(dialogBox(context, msg));
        } else {}
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Some thing went wrong"));
          stop();
        });
      }
    }
  }
}

List<RoleListDataModel> rolesList = [];

class RoleListDataModel {
  String id, roleName;
  bool showDining, showTakeAway, showOnline, showCar, showKitchen;

  RoleListDataModel(
      {required this.id,
      required this.roleName,
      required this.showCar,
      required this.showDining,
      required this.showKitchen,
      required this.showOnline,
      required this.showTakeAway});

  factory RoleListDataModel.fromJson(Map<dynamic, dynamic> json) {
    return RoleListDataModel(
        id: json['id'],
        roleName: json['RoleName'],
        showDining: json['show_dining'],
        showKitchen: json['show_kitchen'],
        showCar: json['show_car'],
        showOnline: json['show_online'],
        showTakeAway: json['show_take_away']);
  }
}

// ProductDetail.taxID=taxTypeList[index].taxId.toString();
// Navigator.pop(context, taxTypeList[index].taxName);
