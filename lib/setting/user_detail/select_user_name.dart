import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../settings_page.dart';


class SelectUser extends StatefulWidget {
  const SelectUser({Key? key}) : super(key: key);

  @override
  State<SelectUser> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectUser> {
  @override
  void initState() {
    getAllUsersList();
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
            'select_employee'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[300],
         ),
      body: Container(
          height:
          MediaQuery.of(context).size.height / 1, //height of button
          width: MediaQuery.of(context).size.width / 1,
          color: Colors.grey[100],
          child:   ListView.builder(
              shrinkWrap: true,
              itemCount: usersList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: .5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ListTile(
                      onTap: () async {
                        // ProductDetail.taxID=taxTypeList[index].taxId.toString();

                        SettingsData.employeeID=usersList[index].id;

                        Navigator.pop(context, usersList[index].firstName);
                      },

                      leading: IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset('assets/svg/user.svg'),
                      ),
                      title:Text(usersList[index].firstName),
                      //const Text("<User Name> "),

                      trailing: IconButton(
                        onPressed: () {
                          ///
                        },
                        icon: SvgPicture.asset('assets/svg/arrow.svg'),
                      ),
                    ));
              }),),
    );
  }

  Future<Null> getAllUsersList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
        var branchID = BaseUrl.branchID;
        var userID = prefs.getInt("user_id");
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/employees/employees/';

        var accessToken = prefs.getString('access') ?? '';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID":userID,
          "PriceRounding":2
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
        print(accessToken);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);
        print(status);
        if (status == 6000) {
          setState(() {
            usersList.clear();
            stop();
            for (Map user in responseJson) {
              usersList.add(UserListModel.fromJson(user));
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



}


List<UserListModel> usersList=[];

class UserListModel {
  String id, firstName, lastName, ledgerName;

  UserListModel({
    required this.id, required this.ledgerName, required this.firstName, required this.lastName
  });

  factory UserListModel.fromJson(Map<dynamic, dynamic> json) {
    return UserListModel(
      id: json['id'],
      lastName: json['LastName'],
      firstName: json['FirstName'],
      ledgerName: json['LedgerName'],

    );
  }


}




















