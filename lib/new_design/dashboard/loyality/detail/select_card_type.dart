import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectCardType extends StatefulWidget {
  const SelectCardType({Key? key}) : super(key: key);

  @override
  State<SelectCardType> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectCardType> {
  @override
  void initState() {
    getCardType();
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
            'route'.tr,
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
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: cardTypeLists.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                      onTap: () {
                        // Data.routeID=routeLists[index].routeID;
                        //                          LoyaltyData.cardTypeUId = cardTypeLists[index].id;
                       Navigator.pop(context, cardTypeLists[index].cardName);

                      },
                      leading: const Icon(Icons.person),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cardTypeLists[index].cardName,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )),
                );
              })

             ),
    );
  }

  Future<Null> getCardType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';
        var userID = prefs.getInt('user_id') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        var companyID = prefs.getString('companyID') ?? 0;

        final String url =
            '$baseUrl/transactionTypes/transactionTypesByMasterName/';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "MasterName": "Card Network",
          "CreatedUserID": userID,
        };

        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          print(status);
          setState(() {
            cardTypeLists.clear();
            stop();

            for (Map user in responseJson) {
              cardTypeLists.add(CardTypeModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          print(status);

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

List<CardTypeModel> cardTypeLists = [];

class CardTypeModel {
  String cardName, id, transactionTypeId;

  CardTypeModel(
      {required this.cardName,
        required this.id,
        required this.transactionTypeId});

  factory CardTypeModel.fromJson(Map<dynamic, dynamic> json) {
    return CardTypeModel(
      cardName: json['Name'],
      id: json['id'],
      transactionTypeId: json['TransactionTypesID'].toString(),
    );
  }
}