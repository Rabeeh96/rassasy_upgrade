import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/main.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rassasy_new/new_design/dashboard/pos/new_method/model/model_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class ViewFlavour extends StatefulWidget {
  @override
  State<ViewFlavour> createState() => _ViewFlavourState();
}

class _ViewFlavourState extends State<ViewFlavour> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllFlavours();
  }


  var networkConnection = true;
  TextEditingController searchController = TextEditingController();
  TextEditingController flavourNameController = TextEditingController();
  createFlavourApi(type,id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
        var userID = prefs.getInt('user_id') ?? 0;
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        String url = "";
        var msg = "";
        if(type =="A"){
          url = '$baseUrl/flavours/create-flavour/';
          msg ='Created';
        }
        else{
           url = '$baseUrl/flavours/edit/flavour/$id/';
           msg ='Updated';
        }


        Map data = {
          "FlavourID":flavourID,
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "FlavourName": flavourNameController.text,
          "IsActive": true,
          "BgColor": "",
        };
        print("   $data");
        //encode Map to JSON
        var body = json.encode(data);
        print("   1");
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));

        print("   ${response.body}}");

        var status = n["StatusCode"];


        if (status == 6000) {
          isEdit= false;
          stop();
          flavourNameController.clear();
          flavourList.clear();

          getAllFlavours();

        } else if (status == 6001) {
          stop();
          // var msg = n["message"]??"";
          // dialogBox(context, msg);
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

  void deleteAlert(id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: AlertDialog(
              title:   Padding(
                padding: EdgeInsets.all(0.5),
                child: Text(
                  'msg4'.tr,
                  textAlign: TextAlign.center,
                ),
              ),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {
                      Navigator.pop(context),
                      deleteFlavourApi(id),
                    },
                    child:  Text(
                      'Ok'.tr,
                      style: TextStyle(color: Colors.black),
                    )),
                TextButton(
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    child:   Text(
                      'cancel'.tr,
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          );
        });
  }


  deleteFlavourApi(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
        var userID = prefs.getInt('user_id') ?? 0;
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        String url = '$baseUrl/flavours/delete/flavour/$id/';

        

        log("   $accessToken");

        log("   $url");
        Map data = {

          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "FlavourName": flavourNameController.text,
          "IsActive": true,
          "BgColor": "",
        };
        log("   $data");
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
        if (status == 6000) {
          stop();
          flavourList.clear();
          dialogBox(context, " Delete Successfully");
          getAllFlavours();

        } else if (status == 6001) {
          stop();
          var msg = n["message"]??"";
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
  bool createPermission = false;
  List<FlavourListModel> flavourList = [];
  Future<Null> getAllFlavours() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
        stop();
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
        var userID = prefs.getInt('user_id') ?? 0;
         var branchID = prefs.getInt('branchID') ?? 1;
        createPermission = prefs.getBool("Flavoursave") ?? false;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/flavours/flavours/';
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
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);
        print(status);
        if (status == 6000) {
          stop();
          setState(() {
            flavourList.clear();

            for (Map user in responseJson) {
              flavourList.add(FlavourListModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          // var msg = n["error"]??"";
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F3F3),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Flavours",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [],
      ),
      body: networkConnection == true
          ? Row(
              children: [



                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      right: BorderSide(
                        //                   <--- right side
                        color: Color(0xffD9D9D9),
                        width: 1.0,
                      ),
                    )),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:flavourList.length!=0? ListView.builder(
                            // the number of items in the list
                            itemCount: flavourList.length,

                            // display each item of the product list
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    side: BorderSide(
                                        width: 1, color: Color(0xffDFDFDF))),
                                color: Color(0xffF3F3F3),
                                child: ListTile(
                                  onLongPress: ()async{
                                    bool hasPermission = await checkingPerm("Flavourdelete");
                                    if(hasPermission){
                                      deleteAlert(flavourList[index].id);
                                    }
                                    else{
                                      dialogBoxPermissionDenied(context);
                                    }

                                  },
                                  onTap: ()async{
                                    bool hasPermission = await checkingPerm("Flavouredit");
                                    if(hasPermission){
                                      setState(() {
                                        isEdit = true;
                                        flavourID = flavourList[index].flavourID;
                                        flavourUID = flavourList[index].id;
                                        flavourNameController.text = flavourList[index].flavourName;
                                      });
                                    }
                                    else{
                                      dialogBoxPermissionDenied(context);
                                    }

                                  },
                                  title: Text(flavourList[index].flavourName),
                                ),
                              );
                            }):Container(child: Center(child: Text("No flavour in list",style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),)),),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEdit == false?"Add Flavour":"Edit Flavour",
                            style: TextStyle(
                                color: Color(0xff717171), fontSize: 17),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height / 15,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xff858585), width: .5)),
                            child: TextField(

                              controller: flavourNameController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(6),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: .5)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: .5)),
                                hintText: "Flavour name",
                                hintStyle: TextStyle(color: Color(0xffAFAFAF)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: MediaQuery.of(context).size.height / 18,

                              decoration: BoxDecoration(

                                  borderRadius: BorderRadius.circular(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    color:Colors.red,
                                    width: MediaQuery.of(context).size.width / 7,
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isEdit = false;
                                            flavourID = 0;
                                            flavourNameController.clear();
                                          });
                                        },
                                        child: Text(
                                          'cancel'.tr,
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 7,
                                    color:Color(0xff247B00),
                                    child: TextButton(
                                        onPressed: () {
                                          if(flavourNameController.text ==""){
                                            dialogBox(context, "Enter flavour name");
                                          }
                                          else{

                                            if (isEdit == false) {
                                              if (createPermission) {
                                                createFlavourApi("A",flavourUID);
                                              } else {
                                                dialogBoxPermissionDenied(context);
                                              }
                                            } else {

                                              start(context);
                                              createFlavourApi("E",flavourUID);
                                            }


                                            // if(isEdit){
                                            //   createFlavourApi("E",flavourUID);
                                            // }
                                            // else{
                                            //   createFlavourApi("A",0);
                                            // }
                                          }
                                        },
                                        child: Text(
                                          "Save",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : noNetworkConnectionPage(),
      //  bottomNavigationBar: bottomBar(),
    );
  }


  bool isEdit = false;
  int flavourID = 0;
  String flavourUID = "";
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
              //getAllTax();
              // defaultData();
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

