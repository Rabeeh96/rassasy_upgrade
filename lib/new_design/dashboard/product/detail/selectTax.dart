import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class SelectTax extends StatefulWidget {

  String type;
  SelectTax({super.key,required this.type});
 // const SelectTax({Key? key}) : super(key: key);

  @override
  State<SelectTax> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectTax> {
  @override
  void initState() {
    super.initState();
    taxLists.clear();
    getTaxDetails();
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
            'tax_type'.tr,
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
      // body: Container(
      //     height: MediaQuery.of(context).size.height / 1, //height of button
      //     width: MediaQuery.of(context).size.width / 1.1,
      //     color: Colors.grey[100],
      //     child: ListView.builder(
      //         shrinkWrap: true,
      //         itemCount: taxLists.length,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Card(
      //               child: ListTile(
      //                 title: Text(taxLists[index].taxName),
      //                 onTap: () async {
      //                    ProductData.taxID = taxLists[index].taxID;
      //                    Navigator.pop(context, taxLists[index].taxName);
      //                 },
      //               ));
      //         })),
      body: Center(
        child: Container(

            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.grey[100],
            // color: Colors.grey[100],
            child:taxLists.isNotEmpty?Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: taxLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title:  Text(taxLists[index].taxName,style: customisedStyle(context, Colors.black, FontWeight.normal, 15.0),),
                          subtitle:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Sale %  ${roundStringWith(taxLists[index].salesPrice)}",style: customisedStyle(context, Colors.grey, FontWeight.normal, 13.0),),
                              Text("Purchase %  ${roundStringWith(taxLists[index].purchasePrice)}",style: customisedStyle(context, Colors.grey, FontWeight.normal, 13.0),),
                            ],
                          ) ,
                          onTap: () async {
                            Navigator.pop(context, [taxLists[index].taxID,taxLists[index].taxName]);
                          },
                        )
                    );
                  }
              ),
            ):Center(child: Text('no_tax'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
        ),
      ),


    );
  }

  Future<Null> getCategoryDetails() async {
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
        var priceRounding = BaseUrl.priceRounding;

        final String url = '$baseUrl/taxCategories/taxCategories/';

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": priceRounding
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
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            taxLists.clear();
            for (Map user in responseJson) {
              taxLists.add(TaxModel.fromJson(user));
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
  Future<Null> getTaxDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        stop();
    } else {
      try {
        start(context);
        String baseUrl = BaseUrl.baseUrlV11;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var priceRounding = BaseUrl.priceRounding;

        final String url = '$baseUrl/taxCategories/taxListByType/';
        var checkGst = prefs.getBool("check_GST") ?? false;
        int taxType = 1;
        if(checkGst){
          taxType=2;
        }
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": priceRounding,
          "TaxType": taxType
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
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            taxLists.clear();
            if(widget.type =="1"){
              for (Map user in responseJson) {
                taxLists.add(TaxModel.fromJson(user));
              }
            }
            else{
              var excise = n["excise_data"];
              for (Map user in excise) {
                taxLists.add(TaxModel.fromJson(user));
              }
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

List<TaxModel> searchTaxList = [];
List<TaxModel> taxLists = [];

class TaxModel {
  int taxID;
  String taxName, type, salesPrice, purchasePrice;
  bool IsDefault;

  TaxModel(
      {required this.taxName,
        required this.type,
        required this.IsDefault,

        required this.taxID,
        required this.purchasePrice,
        required this.salesPrice});

  factory TaxModel.fromJson(Map<dynamic, dynamic> json) {
    return TaxModel(
        type: json['TaxType'],
        taxName: json['TaxName'],
        taxID: json['TaxID'],
        IsDefault: json['IsDefault'],
        purchasePrice: json['PurchaseTax'].toString(),
        salesPrice: json['SalesTax'].toString());

  }
}
