import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/new_method/model/model_class.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SelectPaymentCustomer extends StatefulWidget {
  const SelectPaymentCustomer({Key? key}) : super(key: key);

  @override
  State<SelectPaymentCustomer> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectPaymentCustomer> {
  @override
  void initState() {
    super.initState();
    getCustomersLists();
  }
  TextEditingController searchController = TextEditingController();
  var netWorkProblem = true;
  bool isLoading = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;
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
            'select_customer'.tr,
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
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 11,
            color: const Color(0xffFFFFFF),

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    charLength = text.length;
                    _searchData(text);
                  });
                },

                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),

                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      customersLists.clear();
                      pageNumber = 1;
                      firstTime = 1;
                      getCustomersLists();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'search'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          Container(
              height: MediaQuery.of(context).size.height / 1.2, //height of button
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.grey[100],
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:customersLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title: Text(customersLists[index].custName),
                          onTap: () async {
                            PaymentData.ledgerID = customersLists[index].ledgerID;
                            Navigator.pop(context, [customersLists[index].custName,customersLists[index].ledgerID]);
                          },
                        ));
                  })),
        ],
      ),
    );
  }
  Future<Null> getCustomersLists() async {
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
        final String url = '$baseUrl/posholds/pos-ledgerListByID/';

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "PriceRounding": 2,
          "load_data": true,
          "type_invoice": "SalesInvoice",
          "ledger_name": "",
          "length": ""
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
        log('----${response.body}');
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          setState(() {
            customersLists.clear();
            stop();
            for (Map user in responseJson) {
              customersLists.add(CustomerModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          // var msg = n["error"];
          // dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        stop();
      }
    }
  }
  Future _searchData(string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var companyID = prefs.getString('companyID') ?? '';
    var userID = prefs.getInt('user_id') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    if (string == '') {
      pageNumber = 1;
      customersLists.clear();
      firstTime = 1;
      getCustomersLists();
    }
    else if (string.length > 2) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(
            context, "Unable to connect. Please Check Internet Connection")
            .currentState
            .showSnackBar(const SnackBar(
          content:
          Text("Unable to connect. Please Check Internet Connection"),
          duration: Duration(seconds: 2),
        ));
      } else {
        try {
          Map data = {
            "BranchID": branchID,
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "PriceRounding": BaseUrl.priceRounding,
            "load_data": false,
            "type_invoice": "SalesInvoice",
            "ledger_name": searchController.text,
            "length": 3
          };
          String baseUrl = BaseUrl.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('access') ?? '';
          final String url = "$baseUrl/posholds/pos-ledgerListByID/";
          print(data);
          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $token',
              },
              body: body);
          print("${response.statusCode}");
          print("${response.body}");
          Map n = json.decode(utf8.decode(response.bodyBytes));
          var status = n["StatusCode"];
          var responseJson = n["data"];
          var message = n["message"];
          print(responseJson);
          if (status == 6000) {
            customersLists.clear();

            setState(() {
              netWorkProblem = true;
              customersLists.clear();
              isLoading = false;
            });

            setState(() {
              for (Map user in responseJson) {
                customersLists.add(CustomerModel.fromJson(user));
              }
            });
          } else if (status == 6001) {
            setState(() {
              netWorkProblem = true;
              isLoading = false;
            });

            dialogBox(
                context, "Some Network Error please try again Later")
                .currentState
                .showSnackBar(SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 1),
            ));
          } else {
            dialogBox(
                context, "Some Network Error please try again Later")
                .currentState
                .showSnackBar(const SnackBar(
              content: Text('Some Network Error please try again Later'),
              duration: Duration(seconds: 1),
            ));
          }
        } catch (e) {
          setState(() {
            netWorkProblem = false;
            isLoading = false;
          });

          print(e);
        }
      }

      /// call function
      return;
    } else {}
  }


}
List<CustomerModel> customersLists = [];

class CustomerModel {
  int ledgerID;
  String custName;
  CustomerModel(
      {required this.custName, required this.ledgerID, });

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    return CustomerModel(
      custName: json['LedgerName'],
      ledgerID: json['LedgerID'],
    );
  }
}
