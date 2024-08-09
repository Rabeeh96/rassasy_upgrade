import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


import 'model.dart';

class SyncScreen extends StatefulWidget {
  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final String baseUrl = "https://www.api.viknbooks.in/api/v10";
  final List<ProductListModelHive> productLists = [];
  //late Box<ProductListModel> _box;
  @override
  void initState() {
    super.initState();
    getProductListDetails1();
  }

  Future<void> getProductListDetails1() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = "5a09676a-55ef-47e3-ab02-bac62005d847";
      var branchID = 1;
      var accessToken ="eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzUxOTQ5Njg2LCJpYXQiOjE3MjA0MTM2ODYsImp0aSI6IjAxNzg3N2Q0NTM1ZjRjOWY4NzE5NTdhN2YzODZmNjM5IiwidXNlcl9pZCI6NjJ9.SaAd2ls806TXQ22kujXLcTJ7HmOifnAJNrqJ7mljzxfcR0TArsDSw5QsT_FLf5vNGk4d_rG7rnBATvI3dEgwdbJ0XKrXY8KT7ext-DA6-rZF3oQI_hOvjHr6gOuczOVKv3EZEswnM7tsByX0aSQIycIsK8PsyW-wVvx2hZ1kV-e4zWbIenZ7pVBTHrsjor1mmj42E8FFVQn49WUXHj37KUSo4qNz1VPHwvfvry-F48u-wWHG5rNU-inTL7RZ-e4rnHXEYLvpFU4v5CEV9PmqB-EknOuEC5yjSZrMlSt9TE-7ErlPaS7IzaqIXG3w0wtNcJVKzbfwdJ51_WdG6GD_-Cwu2GjWWC1a9BGXD2b7IY_uDWYBEEhgQQgF9Gzvb_wa4jx8OUqRFR7n5cr92gVZg4GbleODK6GdYt9nmbrB9Y9GdXMRhQ4saEZiYaJHUBcPgjR-wUDb5qX-p1xfC5QtbnzsXCYkOI2X5eKQHre87pd4kzDtysbgEaOBQsamjJe4xyzd8J1HNxraco0Dp2iAquEtPkaWslQFWxl2ISRGCV6w4v1E2-OQJ-oGM_i_oKRWzQ2_CO-PbmyNGt0Y0FqqCFFHT3bRMZudhWPC7WQk1DxydfetSuz_gt3dfwVdOwH1-Ohg3O8O6RYCRj7bLNenTtT-WJQYJAWyPfIO-xWT0rc";
      print("1");
      final String url = '$baseUrl/posholds/pos/product-group/list/';
      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "CreatedUserID": 371,
        "is_used_group": true
      };

      var body = json.encode(data);
      print("2");
      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );
      print("3");
      Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      var status = jsonResponse["StatusCode"];
      var responseJson = jsonResponse["data"];
      print("4");
      print("respnse $responseJson");
      print("status $status");
      if (status == 6000) {
        productLists.clear();
        print("Productlist  ");
        // Open the box outside of the loop
        var box = await Hive.openBox<ProductListModelHive>('products');
        print(box);
        for (Map<String, dynamic> item in responseJson) {
          var product = ProductListModelHive.fromJson(item);
          productLists.add(product);
          print("122");
          // Save to Hive
          await box.add(product);
        }
        print("ended");
        setState(() {});
      } else if (status == 6001) {
        var msg = jsonResponse["error"];
        print(msg);
        print("msg");
      } else {
        // Handle other statuses
      }
    } catch (e) {
      print('Error: $e');
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product list",style: TextStyle(color: Colors.black,fontSize: 14.0),),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productLists.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(productLists[i].categoryName),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
