
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import '../../list_organization.dart';
import 'package:get/get.dart';


class SelectOrgState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectOrgStateState();
}

class _SelectOrgStateState extends State<SelectOrgState> {
  Future<Null> getStateDetails() async {



    try {
      var countryId = OrgData.countryID;
      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/states/country-states/$countryId/';

      print(url);
      //encode Map to JSON
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("${response.statusCode}");
      print("${response.body}");
      Map n = json.decode(utf8.decode(response.bodyBytes));


    //  Map n = json.decode(response.bodyBytes);
      var status = n["StatusCode"];

      var responseJson = n["data"];
      print(responseJson);

      if (status == 6000) {
        setState(() {
          for (Map user in responseJson) {
            stateDetail.add(StateData.fromJson(user));
          }
        });
      } else if (status == 6001) {
      }

      //DB Error
      else {}
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    stateDetail.clear();
    super.initState();

    getStateDetails();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff3f3f3),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back,color: Colors.black)),
        title:   Text(
          'choose_state'.tr,
          style: TextStyle( fontSize: 17,color: Colors.black),
        ),

        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemExtent: MediaQuery.of(context).size.height / 14,
            itemCount: stateDetail.length,
            itemBuilder: (context, index) {
              return Card(
                  child:  ListTile(

                      title: Text(
                        stateDetail[index].stateName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        stateDetail[index].stateType,
                        style: const TextStyle(
                          fontSize: 14, ),
                      ),
                      onTap: () async {


                        OrgData.stateID=stateDetail[index].stateID;
                        OrgData.stateCode=stateDetail[index].stateCode??'';
                        // print("OrganisationCountry.state_id");

                        Navigator.pop(context,  stateDetail[index].stateName);
                      })
              );
            },
          ),
        ),
      ),
    );
  }
}

List<StateData> stateDetail = [];

class StateData {
  final String stateName, stateID,  stateType,countryName,country,stateCode;



  StateData({
    required this.countryName,
    required this.stateCode,
    required this.country,
    required this.stateID,
    required this.stateName,
    required this.stateType,



  });

  factory StateData.fromJson(Map<dynamic, dynamic> json) {
    return StateData(
      countryName: json['Country_Name'],
      stateCode: json['State_Code']??'',
      stateType: json['State_Type'],
      stateName: json['Name'],
      stateID: json['id'],
      country: json['Country'],


    );
  }
}
