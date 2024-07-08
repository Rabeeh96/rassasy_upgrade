import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class SelectKitchen extends StatefulWidget {
  const SelectKitchen({Key? key}) : super(key: key);

  @override
  State<SelectKitchen> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectKitchen> {
  @override
  void initState() {
    kitchenList.clear();
    listKitchenApi();
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
        title:   Text(
           'Kitchen'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
        ),
        backgroundColor: Colors.grey[300],
      ),


     body: Center(
       child: Container(

           height: MediaQuery.of(context).size.height / 1, //height of button
           width: MediaQuery.of(context).size.width / 2,
           color: Colors.grey[100],
           // color: Colors.grey[100],
           child:kitchenList.isNotEmpty?Padding(
             padding: const EdgeInsets.all (20.0),
             child: ListView.builder(
                 shrinkWrap: true,
                 itemCount: kitchenList.length,
                 itemBuilder: (BuildContext context, int index) {
                   return Card(
                       child: ListTile(
                         title:  Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(kitchenList[index].kitchenName,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),),
                             Text(kitchenList[index].ipAddress,style: customisedStyle(context, Colors.grey, FontWeight.normal, 13.0),),
                           ],
                         ),
                         onTap: () async {
                           Navigator.pop(context, [kitchenList[index].kitchenName,kitchenList[index].id]);

                         },
                       )
                   );
                 }
             ),
           ):Center(child: Text('no_kitchen'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
       ),
     ),


      // body: Container(
      //     height: MediaQuery.of(context).size.height / 1, //height of button
      //     width: MediaQuery.of(context).size.width / 1,
      //     color: Colors.grey[100],
      //     child: ListView.builder(
      //         scrollDirection: Axis.vertical,
      //         physics: ClampingScrollPhysics(),
      //         shrinkWrap: true,
      //         itemCount: kitchenList.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Card(
      //               child: ListTile(
      //             title: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Text(kitchenList[index].kitchenName,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),),
      //                 Text(kitchenList[index].ipAddress,style: customisedStyle(context, Colors.grey, FontWeight.normal, 13.0),),
      //               ],
      //             ),
      //
      //
      //             onTap: () {
      //               Navigator.pop(context, kitchenList[index].kitchenName);
      //               GroupData.kitchenID = kitchenList[index].id;
      //             },
      //           ));
      //         })),
    );
  }

  Future<Null> listKitchenApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Unable to connect. Please Check Internet Connection");
    } else {
      start(context);
      HttpOverrides.global = MyHttpOverrides();
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      final String url = '$baseUrl/posholds/list/pos-kitchen/';
      print(url);
      Map data = {
        "BranchID": branchID,
        "CreatedUserID": userID,
        "CompanyID": companyID,
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
      print("${response.statusCode}");
      print("${response.body}");

      Map n = json.decode(response.body);
      var status = n["StatusCode"];

      var responseJson = n["data"];
      print(responseJson);

      if (status == 6000) {
        stop();
        kitchenList.clear();

        setState(() {
          for (Map user in responseJson) {
            kitchenList.add(Kitchen.fromJson(user));
          }
        });
      } else if (status == 6001) {
        stop();
        var message = n["message"];
        dialogBox(context, message);
      }

      //DB Error
      else {
        stop();
        dialogBox(context, "Some Network Error please try again Later");
      }
    }
  }
}

List<Kitchen> kitchenList = [];

class Kitchen {
  final String ipAddress, kitchenName, id;
  final bool isActive;

  Kitchen({
    required this.ipAddress,
    required this.kitchenName,
    required this.isActive,
    required this.id,
  });

  factory Kitchen.fromJson(Map<dynamic, dynamic> json) {
    return Kitchen(id: json['id'], ipAddress: json['IPAddress'], kitchenName: json['KitchenName'], isActive: json['IsActive']);
  }
}
