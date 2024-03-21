import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SelectGroup extends StatefulWidget {
  const SelectGroup({Key? key}) : super(key: key);
  @override
  State<SelectGroup> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectGroup> {
  @override
  void initState() {
    super.initState();
    getCategoryDetails();

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
          'select_a_product_grp'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.grey[300],

      ),
      body: Center(
        child: categoryLists.isNotEmpty?
        displayProductDetails():Center(child: Text('no_emp'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),)),
      ),
    );
  }

  Widget displayProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          height: MediaQuery.of(context).size.height / 1.5, //height of button
          // width: MediaQuery.of(context).size.width / 1.6,
          child: GridView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),

              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 2.3, //2.4 will workk
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: categoryLists.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, [categoryLists[i].groupName,categoryLists[i].productGroupId]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 15, //height of button
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffC9C9C9),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [


                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(

                              // height: MediaQuery.of(context).size.height / 8.5, //height of button
                              width: MediaQuery.of(context).size.width / 6.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(

                                    child: Text(categoryLists[i].groupName,
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 11.5)),
                                  ),


                                ],
                              ),
                              // color: Colors.orange,
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }



  getCategoryDetails() async {
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





        String url = "$baseUrl/posholds/pos/product-group/list/";
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
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
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            categoryLists.clear();
            for (Map user in responseJson) {
              categoryLists.add(CategoryListModel.fromJson(user));
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


List<CategoryListModel> categoryLists = [];

class CategoryListModel {
  final String categoryId, groupName;
  final int productGroupId;

  CategoryListModel({
    required this.groupName,
    required this.productGroupId,
    required this.categoryId,
  });

  factory CategoryListModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryListModel(
        groupName: json['GroupName'],
        productGroupId: json['ProductGroupID'],
        categoryId: json['id']);
  }
}


