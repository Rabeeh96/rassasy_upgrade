import 'dart:io';
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/main.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import '../dashboard/dashboard.dart';
import 'create/organization_profile_pg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'selectBranchDetails.dart';

class OrganizationList extends StatefulWidget {
  @override
  State<OrganizationList> createState() => _OrganizationDetailState();
}

class _OrganizationDetailState extends State<OrganizationList> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  FocusNode userNameFcNode = FocusNode();

  FocusNode passwordFcNode = FocusNode();

  FocusNode saveFCNode = FocusNode();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getCompanyListDetails();
    });
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  ///alert icon not working
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/png/coverpage.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.6,
              height: MediaQuery.of(context).size.height / 1.3,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/svg/logoimg.svg',
                      ),
                    ),
                  ),

                  /// create section commented
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 6, right: 20, left: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         'create_new_org'.tr,
                  //         style: TextStyle(fontWeight: FontWeight.w800),
                  //       ),
                  //       Container(
                  //         width: MediaQuery.of(context).size.width / 10,
                  //         height: MediaQuery.of(context).size.height / 17,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(5),
                  //           gradient: LinearGradient(
                  //             colors: <Color>[
                  //               Color(0xFFEE4709),
                  //               Color(0xFFF68522),
                  //             ],
                  //           ),
                  //         ),
                  //         child: TextButton(
                  //           style: TextButton.styleFrom(
                  //             foregroundColor: Colors.white,
                  //             textStyle: const TextStyle(fontSize: 14),
                  //           ),
                  //           onPressed: () {
                  //             clearAll();
                  //             OrgData.firstSection = true;
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) =>
                  //                       CreateOrganisationProfile()),
                  //             );
                  //           },
                  //           child:  Text('create'.tr),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),



                Column(
              //      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    /// create section commented

                      // Padding(
                      //   padding: const EdgeInsets.only(left: 20),
                      //   child: Text(
                      //     'or'.tr,
                      //     style: TextStyle(fontWeight: FontWeight.w800),
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 6, left: 20, right: 20, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'select_org'.tr,
                              style: TextStyle(fontWeight: FontWeight.w800),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: SvgPicture.asset('assets/svg/refresh.svg'),
                                  onPressed: () {
                                    companyList.clear();
                                    getCompanyListDetails();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.login_outlined),
                                  onPressed: () async {
                                    final Future<ConfirmAction?> action =
                                    await _asyncConfirmDialog(context);

                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xffF6F6F6),
                              ),
                              //  color: Colors.red,

                              height: MediaQuery.of(context).size.height / 2,
                              child: companyList.isNotEmpty ?
                              ListView.builder(
                                  itemCount: companyList.length,
                                  itemBuilder: (BuildContext context, int index) {



                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        child: ListTile(
                                            leading: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.grey[300],
                                              backgroundImage: companyList[index]
                                                  .image ==
                                                  ''
                                                  ? NetworkImage(
                                                  'https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                                  : NetworkImage(
                                                  companyList[index].image),
                                            ),
                                            trailing: Container(
                                              width: 100,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                  Color(0xff303030),
                                                  textStyle:
                                                  const TextStyle(fontSize: 10),
                                                ),
                                                onPressed: () async {





                                                  var expire =checkExpire(companyList[index].expiryDate);
                                                  if(expire){
                                                    dialogBox(context, "${companyList[index].companyName} Expired! Please Contact us(+91 95775 00400 | +966 53 313 4959 | +971 52295 6284)to continue");
                                                  }
                                                  else{

                                                    var branchDetails=companyList[index].branchList??[];

                                                    print("branchDetails  $branchDetails");

                                                    if(branchDetails.isEmpty){
                                                      await defaultDataInitial(context:context);

                                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                                      prefs.setString('companyName', companyList[index].companyName);
                                                      prefs.setString('companyType', companyList[index].companyType);
                                                      prefs.setString('expiryDate', companyList[index].expiryDate);
                                                      prefs.setString('permission', companyList[index].permission);
                                                      prefs.setString('edition', companyList[index].permission);
                                                      prefs.setBool('isPosUser', companyList[index].isPosUser);
                                                      prefs.setString('companyID', companyList[index].id);
                                                      prefs.setBool('companySelected', true);
                                                      prefs.setInt('branchID',1);

                                                     await Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext context) =>
                                                              const EnterPinNumber()));
                                                    }
                                                    else{

                                                      var result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBranch(list: branchDetails)),);
                                                      if(result !=null){
                                                        await defaultDataInitial(context:context);
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        prefs.setString('companyName', companyList[index].companyName);
                                                        prefs.setString('companyType', companyList[index].companyType);
                                                        prefs.setString('expiryDate', companyList[index].expiryDate);
                                                        prefs.setString('permission', companyList[index].permission);
                                                        prefs.setString('edition', companyList[index].permission);
                                                        prefs.setBool('isPosUser', companyList[index].isPosUser);
                                                        prefs.setString('companyID', companyList[index].id);
                                                        prefs.setBool('companySelected', true);
                                                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EnterPinNumber()));
                                                      }
                                                      else{
                                                        dialogBox(context, "Select branch, before go to next step");
                                                      }


                                                    }





                                                    // if(companyList[index].isPosUser){
                                                    //
                                                    //   Navigator.pushReplacement(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //           builder: (BuildContext context) =>
                                                    //           const EnterPinNumber()));
                                                    //
                                                    // }
                                                    // else{
                                                    //
                                                    //   userTypeData();
                                                    //
                                                    // }
                                                  }



                                                },
                                                child: Text(
                                                  'join'.tr,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                                companyList[index].companyName,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12)),


                                        ),
                                      ),
                                    );
                                  }):
                              Image.asset('assets/png/EmptyCompany.png')))
                    ],
                  )


                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> userTypeData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {

          start(context);


        SharedPreferences prefs = await SharedPreferences.getInstance();
        var branchID = prefs.getInt('branchID') ?? 1;
        var companyID = '5a09676a-55ef-47e3-ab02-bac62005d847';
        String baseUrl = BaseUrl.baseUrlV11;
        var token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NzgxMzA0LCJpYXQiOjE3MDMyNDUzMDQsImp0aSI6IjcyM2MwZGMyZmZhOTRmNzFiY2I0MDEyMDAxY2EyOGFjIiwidXNlcl9pZCI6NjJ9.ZsX4x_rO1F-VViRujriEfT8yTlX9qT4VjbKoHK9ACIfGvktTEgOORdkcYBYn4tsKFSlsc0sqcMgkLYdhcY4H_t8ew2Gtq98cXmUqQZsaD4Xqm5U56IdYmSnx-lc2gwv1mCb8wPhhHRFsbo98hmGXvzO_PMv3zRrqAjfi6kahTvJRmgbU_hXX34FNDVkKhW8WnAC-66deZPoJINIjycP8ZkB6kbD4aZ66O8M2OttQ8Eg_ppAqw1bIOwiaiJ2we2191vBSfpj-Fe3RsIX3z5jIN8tOwxrVvBBNCb75kD9aU8x4qXDqb6PpCOlqDaMBFas4ZNqJfWzXewSw_Fw4Ww7dUBCM9uUV7fYLdaeDaLw_lEkzxpHsiF5jP6ylACg2ioGLaB7M7mLHszPLq3WKemAmdrqGyTG74wNJYuYdlwOG-KOx4RvZDKKWjJrzWEiRBsqgJRKrT5VSRjx-jbv3jvDvaXlVqvV1SK30urPu0xZ3DfL7qsPiB3ic-HKUrvKxf8QcVAPh3YykVx-qewPwxzxzuwUEBCtFYTYQUF-0cp2j8Eo1dx3J50YYoM6mT2uXHNhI2N8zuYXdmnZRXdnC-KM8ikS8WnXKwTjz8uAuW5OrH2ApN8q0JCs43AeGQItR2-_w6xDsyMtowwopu26vPRezoIHkb9FMi067zHAZ20b9Xq0';
        var roleID =   '3607ed89-e1bf-4810-87d2-d3a6ae4d6ded';
        final String url = '$baseUrl/posholds/list-detail/pos-role/';
        print(url);
        Map data = {"CompanyID": companyID, "Role_id": roleID, "BranchID": branchID};
        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        print(token);
        var status = n["StatusCode"];
        var userRollData = n["data"] ?? [];
        if (status == 6000) {
          for (var i = 0; i < userRollData.length; i++) {
            if (userRollData[i]["Key"] == "other" || userRollData[i]["Key"] == "report") {
              prefs.setBool(userRollData[i]["Name"], userRollData[i]["Value"]);
            } else {
              prefs.setBool(userRollData[i]["Name"] + userRollData[i]["Key"], userRollData[i]["Value"]);
            }
          }
          Future.delayed(Duration(seconds: 2), () {
            stop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DashboardNew()));
          });


        }
        else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {

        stop();
      }
    }
  }



  clearAll() {
    OrgData.orgName = '';
    OrgData.fromOrgDateAPI = '';
    OrgData.fromOrgDate = '';
    OrgData.toOrgDateAPI = '';
    OrgData.toOrgDate = '';
    OrgData.registrationNumber = '';
    OrgData.phone = '';
    OrgData.email = '';
    OrgData.imgFile;
    OrgData.imageSelected = false;
    OrgData.firstSection = true;
    OrgData.secondSection = true;
    OrgData.thirdSection = true;

    OrgData.countryID = '';
    OrgData.countryName = '';
    OrgData.stateID = '';
    OrgData.stateCode = '';
    OrgData.stateName = '';
    OrgData.city = '';
    OrgData.postalCode = '';
    OrgData.buildName = '';
    OrgData.landMark = '';
    OrgData.taxNumber = '';
    OrgData.taxShow = false;
    OrgData.isZetka = false;
  }

  Future<Null> getCompanyListDetails() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

      dialogBox(context, 'no_network'.tr);
      stop();

    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrlV11;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/users/companies/';

        print(accessToken);
        print(url);


        Map data = {"userId": userID,"is_rassasy":true};
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
        print(response.statusCode);
        print(response.body);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          setState(() {
            companyList.clear();
            stop();
            for(Map user in responseJson) {
              companyList.add(CompanyListDataModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"]??"";
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        print(e.toString());

          stop();

      }
    }
  }
}

List<CompanyListDataModel> companyList = [];

class CompanyListDataModel {
  final bool isPosUser;
  final String id,
      companyName,
      companyType,
      expiryDate,
      permission,
      edition,
      image;

  var branchList = [];
  CompanyListDataModel(
      {required this.id,
      required this.image,
      required this.companyType,
      required this.companyName,
      required this.isPosUser,
      required this.edition,
      required this.branchList,
      required this.expiryDate,
      required this.permission});

  factory CompanyListDataModel.fromJson(Map<dynamic, dynamic> json) {
    return CompanyListDataModel(
      id: json['id'],
      permission: json['Permission']??"",
      companyType: json['company_type'],
      edition: json['Edition'],
      expiryDate: json['ExpiryDate'],
      companyName: json['CompanyName'],
      isPosUser: json['IsPosUser'],
      branchList: json['Branches']??[],
      image: json['CompanyLogo']??"",
    );
  }



}

enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'msg6'.tr,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: TextStyle(color: Colors.red)),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              prefs.setBool('companySelected', false);

              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => LoginPageNew()),
                (_) => false,
              );
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}

class OrgData {
  static String orgName = '';
  static String fromOrgDateAPI = '';
  static String fromOrgDate = '';
  static String toOrgDateAPI = '';
  static String toOrgDate = '';
  static String registrationNumber = '';
  static String phone = '';
  static String email = '';
  static File? imgFile;
  static bool? imageSelected = false;
  static bool? firstSection = true;
  static bool? secondSection = true;
  static bool? thirdSection = true;

  static String countryID = '';
  static String countryName = '';
  static String stateID = '';
  static String stateCode = '';
  static String stateName = '';
  static String city = '';
  static String postalCode = '';
  static String buildName = '';
  static String landMark = '';

  static String taxNumber = '';
  static bool taxShow = false;
  static bool isZetka = false;
}
