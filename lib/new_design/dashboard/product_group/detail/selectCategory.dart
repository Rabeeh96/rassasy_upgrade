import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/new_design/dashboard/product/create_products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class SelectCategory extends StatefulWidget {
  const SelectCategory({Key? key}) : super(key: key);

  @override
  State<SelectCategory> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectCategory> {
  @override
  void initState() {
    getCategoryDetails();
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
          'Category'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
        ),
        backgroundColor: Colors.grey[300],
      )
      ,

      body: Center(
        child: Container(

            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 2,
            color: Colors.grey[100],
            // color: Colors.grey[100],
            child:categoryLists.isNotEmpty?Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title:  Text(categoryLists[index].categoryName,style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),),
                          onTap: () async {

                            Navigator.pop(context, [categoryLists[index].categoryName,categoryLists[index].categoryID]);
                          },
                        )
                    );
                  }
              ),
            ):Center(child: Text('No_Cat'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
        ),
      ),
    );
  }

  Future<Null> getCategoryDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

      stop();

    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;

        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;



        String url = "$baseUrl/productCategories/productCategories/";
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID

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
        print(response.body);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            categoryLists.clear();
            for (Map user in responseJson) {
              categoryLists.add(ProductCategoryModel.fromJson(user));
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
        print("e   ${e.toString()}");
          stop();

      }
    }
  }
}

List<ProductCategoryModel> categoryLists = [];


class ProductCategoryModel {

  int categoryID;
  String uuid, categoryName, notes;

  ProductCategoryModel({
    required this.uuid,
    required this.categoryID,
    required this.notes,
    required this.categoryName,
  });

  factory ProductCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductCategoryModel(
      uuid: json['id'],
      categoryID: json['ProductCategoryID'],
      notes: json['Notes']??"",
      categoryName: json['ProductCategoryName'],
    );
  }
}

