import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
  import 'package:rassasy_new/new_design/organization/list_organization.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class SelectOrgCountry extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectOrgCountryState();
}

class _SelectOrgCountryState extends State<SelectOrgCountry> {
  Future<Null> posFunctions() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
        networkConnection = false;
        print('default data');
      });
    } else {
      setState(() {
        networkConnection = true;
        getCountryDetails();
      });
    }
  }

  Future<Null> getCountryDetails() async {
    try {
      start(context);
      String baseUrl = BaseUrl.baseUrl;
      final url = '$baseUrl/countries/countries/';

      print(url);
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

      Map n = json.decode(response.body);
      var status = n["StatusCode"];

      var responseJson = n["data"];
      print(responseJson);
      var message = n["message"];

      if (status == 6000) {
        stop();
        setState(() {
          for (Map aq in responseJson) {
            _countryDetails.add(CountryData.fromJson(aq));
          }
        });
      } else if (status == 6001) {
        stop();
      }

      //DB Error
      else {}
    } catch (e) {
      stop();
      print(e);
    }
  }


  @override
  void dispose() {
    super.dispose();
    stop();
  }

  @override
  void initState() {
    _countryDetails.clear();
    super.initState();
    posFunctions();
  }
  bool networkConnection = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff3f3f3),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back, color: Colors.black)),
        title:   Text(
          'choose_country'.tr,
          style: TextStyle(fontSize: 17, color: Colors.black),
        ),
        elevation: 0.0,
      ),
      body: networkConnection == true
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemExtent: MediaQuery.of(context).size.height / 14,
                  itemCount: _countryDetails.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                            title: Text(
                              _countryDetails[index].countryName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              _countryDetails[index].taxtype.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            onTap: () async {
                              OrgData.countryID = _countryDetails[index].countryID;

                              Navigator.pop(
                                  context, _countryDetails[index].countryName);
                            }));
                  },
                ),
              ),
            )
          : noNetworkConnectionPage(),
    );
  }

  Widget noNetworkConnectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/warning.svg",
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              posFunctions();
            },
            child: Text('retry'.tr,
                style: TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }
}

List<CountryData> _countryDetails = [];

class CountryData {
  final String countryName,
      countryID,
      countryCode,
      isdCode,
      currencyName,
      change,
      symbol,
      fractionUnit,
      symbolUnicode,
      taxtype;

  CountryData({
    required this.countryID,
    required this.countryName,
    required this.countryCode,
    required this.isdCode,
    required this.currencyName,
    required this.change,
    required this.symbol,
    required this.fractionUnit,
    required this.symbolUnicode,
    required this.taxtype,
  });

  factory CountryData.fromJson(Map<dynamic, dynamic> json) {
    return CountryData(
      countryName: json['Country_Name'],
      countryID: json['id'],
      countryCode: json['CountryCode'],
      isdCode: json['ISD_Code'],
      fractionUnit: json['FractionalUnits'],
      change: json['Change'],
      taxtype: json['Tax_Type'],
      symbolUnicode: json['CurrencySymbolUnicode'],
      currencyName: json['Currency_Name'],
      symbol: json['Symbol'],
    );
  }
}
