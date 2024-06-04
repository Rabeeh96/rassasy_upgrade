import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class SelectCountry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  Future<Null> getCountryDetails() async {
    try {
      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/countries/countries/';

      print(url);

      //encode Map to JSON//
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      print("${response.statusCode}");
      print("${response.body}");

      Map n = json.decode(response.body);
      var status = n["StatusCode"];

      var responseJson = n["data"];
      print(responseJson);
      var message = n["message"];
//
      if (status == 6000) {
        setState(() {
          for (Map aq in responseJson) {
            _countryDetails.add(CountryData.fromJson(aq));
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
    _countryDetails.clear();
    super.initState();
    getCountryDetails();
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
          'choose_a_country'.tr,
          style: TextStyle( fontSize: 17,color: Colors.black),
        ),

        elevation: 0.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemExtent: MediaQuery.of(context).size.height / 14,
            itemCount: _countryDetails.length,
            itemBuilder: (context, index) {
              return Card(
                  child:  ListTile(

                      title: Text(
                        _countryDetails[index].countryName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text(
                        _countryDetails[index].currencyName,
                        style: const TextStyle(
                          fontSize: 14, ),
                      ),
                      onTap: () async {

                        UserCreation.selectCountry =  _countryDetails[index].countryID;
                        UserCreation.isd_code=_countryDetails[index].isdCode;
                        Navigator.pop(context,  _countryDetails[index].countryName);
                      })
              );
            },
          ),
        ),
      ),
    );
  }
}

List<CountryData> _countryDetails = [];

class CountryData {
  final String countryName, countryID,
      countryCode, isdCode,
      currencyName,
      symbol,
      taxtype;



  CountryData({required this.countryID,
    required this.countryName,
    required this.countryCode,
    required this.isdCode,
    required this.currencyName,
    required this.symbol,
    required this.taxtype,


  });

  factory CountryData.fromJson(Map<dynamic, dynamic> json) {
    return CountryData(
      countryName: json['Country_Name'],
      countryID: json['id'],
      countryCode: json['CountryCode'],
      isdCode: json['ISD_Code'],
      taxtype: json['Tax_Type'],
      currencyName: json['Currency_Name'],
      symbol: json['Symbol'],





    );
  }
}

class UserCreation {
  static bool? verifyMail;
  static String selectCountry = '';
  static String isd_code='';
}