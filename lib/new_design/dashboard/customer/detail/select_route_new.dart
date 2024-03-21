import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectRouteNew extends StatefulWidget {
  const SelectRouteNew({Key? key}) : super(key: key);

  @override
  State<SelectRouteNew> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectRouteNew> {
  @override
  void initState() {
    getRouteDetails();
    super.initState();
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
          title:  Text(
            'route'.tr.tr,
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
      body: Container(
          height: MediaQuery.of(context).size.height / 1, //height of button
          width: MediaQuery.of(context).size.width / 1,
          color: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: routeLists.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                      title: Text(routeLists[index].routeName),
                      onTap: () async {
                        Navigator.pop(context, [routeLists[index].routeName,routeLists[index].routeID]);
                      },
                    ));
              })),
    );
  }

  Future<Null> getRouteDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;


        String url = "$baseUrl/routes/routes/";
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
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            routeLists.clear();
            for (Map user in responseJson) {
              routeLists.add(RouteModel.fromJson(user));
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
        setState(() {
          stop();
        });
      }
    }
  }
}

List<RouteModel> routeLists = [];

class RouteModel {
  final String routeName,routeUID;
  int routeID;


  RouteModel({
    required this.routeName,
    required this.routeUID,
    required this.routeID

  });

  factory RouteModel.fromJson(Map<dynamic, dynamic> json) {
    return RouteModel(
        routeName: json['RouteName'],
       routeUID: json['id'],
      routeID: json['RouteID']

    );
  }
}
