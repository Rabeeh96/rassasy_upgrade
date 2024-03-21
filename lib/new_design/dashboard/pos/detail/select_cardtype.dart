import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/global.dart';
 import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../loyality/create_loyality_customer.dart';

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
  bool networkConnection = true;

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
            'card_type1'.tr,
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
          width: MediaQuery.of(context).size.width / 1.1,
          color: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: cardTypeLists.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                      onTap: () async {
                        LoyaltyData.cardTypeUId=cardTypeLists[index].id;
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
              })),
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

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;


        final String url =
            '$baseUrl/transactionTypes/transactionTypesByMasterName/';

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

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          setState(() {
            cardTypeLists.clear();
            stop();

            for (Map user in responseJson) {
              cardTypeLists.add(CardTypeModel.fromJson(user));
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
