import 'package:flutter/material.dart';
 import 'package:rassasy_new/new_design/organization/create/organization_address_detail_pg.dart';
import '../../../global/textfield_decoration.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../list_organization.dart';
import 'organization_profile_pg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class CreateOrganisationAddress extends StatefulWidget {
  @override
  State<CreateOrganisationAddress> createState() =>
      _CreateOrganisationAddressState();
}

class _CreateOrganisationAddressState extends State<CreateOrganisationAddress> {
  TextEditingController taxNumberController = TextEditingController();

  FocusNode panFcNode = FocusNode();
  FocusNode taxNode = FocusNode();
  FocusNode saveFcNode = FocusNode();

  FocusNode tanFcNode = FocusNode();

  FocusNode tdsCircleFcNode = FocusNode();

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadData();
    });
  }

  loadData() {
    taxNumberController.text = OrgData.taxNumber;

    setState(() {
      taxShow = OrgData.taxShow;

      isZedka = OrgData.isZetka;

      if (OrgData.countryID == "94e4ce66-26cc-4851-af1e-ecc068e80224") {
        taxType = "vat";
        headCheckBox = "VAT Registered";
      } else if (OrgData.countryID == "30f8c506-e27a-476c-8950-b40a6461bf61") {
        taxType = "gst";
        headCheckBox = "GST Registered";
      } else {
        taxType = "vat";
        headCheckBox = "VAT Registered";
      }
    });
  }

  var taxType = "";

  var headCheckBox = '';
  var taxShow = false;
  var isZedka = false;

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
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 1.4,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 21,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      child:   Text(
                        'create_org'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 26),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Card(
                    elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      child: Container(
                        height: 36,
                        width:  36,
                        decoration: const BoxDecoration(
                          color: Color(0xffffffff),
                          shape: BoxShape.circle,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: const Text(
                                '1',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                          onTap: () {
                            OrgData.taxNumber = taxNumberController.text;
                            OrgData.taxShow = taxShow;
                            OrgData.isZetka = isZedka;
                            OrgData.firstSection = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateOrganisationProfile()),
                            );
                          },
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xffF68522),
                            height: 36,
                          ),
                        ),
                        GestureDetector(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Container(
                              height: 36,
                              width:  36,
                              decoration: const BoxDecoration(
                                color: Color(0xffffffff),
                                shape: BoxShape.circle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: const Text(
                                      '2',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            OrgData.taxNumber = taxNumberController.text;
                            OrgData.taxShow = taxShow;
                            OrgData.isZetka = isZedka;
                            OrgData.firstSection = false;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateOrganisation()),
                            );
                          },
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xffF68522),
                            height: 36,
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Container(
                            height: 36,
                            width:  36,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFFEE4709),
                                  Color(0xFFF68522),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text(
                                    '3',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        // Card(
                        //   elevation: 10,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(200),
                        //   ),
                        //   child:  SvgPicture.asset('assets/svg/taxdetail3.svg'),
                        // ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 21,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      child:   Text(
                        'tax_details'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xff7A7A7A)),
                      ),
                    ),
                  ),




                  Card(
                    elevation: 0.0,
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(1))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [





                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 4,
                                    child:Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                           // color: Colors.red,
                                            height: 25,
                                          //  width: MediaQuery.of(context).size.width / 20,
                                            child: Transform.scale(
                                              scale: 1,
                                              child: Checkbox(
                                                value: taxShow,
                                                onChanged: (value) {
                                                  setState(() {
                                                    taxShow = value!;
                                                  });

                                                },
                                                activeColor: Colors.black12,
                                                checkColor: Colors.black,
                                                tristate: false,
                                                hoverColor: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                          Container(
                                              child: Text(
                                                headCheckBox,
                                                style: TextStyle(color: Colors.black),
                                              )),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          taxShow == true
                              ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, right: 8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('tax_no'.tr),
                                  ),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 4,
                                    child: TextField(
                                      controller: taxNumberController,
                                      focusNode: tdsCircleFcNode,
                                      onEditingComplete: () {
                                        FocusScope.of(context).requestFocus(saveFcNode);
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization: TextCapitalization.words,
                                      decoration: TextFieldDecoration.textFieldDecor(
                                          hintTextStr: ''),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),



                  OrgData.countryID == "94e4ce66-26cc-4851-af1e-ecc068e80224"
                      ? Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width / 4,
                            child:Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    height: 25,
                                    //  width: MediaQuery.of(context).size.width / 20,
                                    child: Transform.scale(
                                      scale: 1,
                                      child: Checkbox(
                                        value: isZedka,
                                        onChanged: (value) {
                                          setState(() {
                                            isZedka = value!;
                                          });

                                        },
                                        activeColor: Colors.black12,
                                        checkColor: Colors.black,
                                        tristate: false,
                                        hoverColor: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: Text(
                                        'zatca'.tr,
                                        style: TextStyle(color: Colors.black),
                                      )),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container(),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 100, right: 100, top: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:  Text(
                                'cancel'.tr,
                                style: TextStyle(color: Color(0xff8D0000)),
                              )
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 10,
                            height: MediaQuery.of(context).size.height / 17,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24)),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF358501),
                                  Color(0xFF7AAB0C),
                                ],
                              ),
                            ),
                            child: TextButton(
                              focusNode: saveFcNode,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () {
                                if (taxShow) {
                                  if (taxNumberController.text == '') {
                                    dialogBox(
                                        context, "Please enter tax number");
                                  } else {
                                    bool validNumber = false;

                                    if (OrgData.countryID ==
                                        "30f8c506-e27a-476c-8950-b40a6461bf61") {
                                      validNumber = gstValidation(
                                          taxNumberController.text);
                                    } else {
                                      validNumber = vatNumberValidation(
                                          taxNumberController.text);
                                    }


                                    if (validNumber) {
                                      _startImageUploading();
                                      //   createOrganizationApi();
                                    } else {
                                      dialogBox(context, 'Invalid tax number');
                                    }
                                  }
                                } else {
                                  taxNumberController.text = "";


                             _startImageUploading();
                                  //  createOrganizationApi();
                                }
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children:   [
                                  Text('save'.tr),
                                  Icon(Icons.check)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  vatNumberValidation(String str) {
    //343245552522223

    if (str.length == 15) {
      if (str[0] == "3" && str[14] == "3") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // It should be 15 characters long.
  // The first 2 characters should be a number.
  // The next 10 characters should be the PAN number of the taxpayer.
  // The 13th character (entity code) should be a number from 1-9 or an alphabet.
  // The 14th character should be Z.
  // The 15th character should be an alphabet or a number.
  gstValidation(String str) {
    //32AAACC4175D1Z7
    if (str.length == 15) {
      var num = '';
      num = str[0] + str[1];
      if (num == OrgData.stateCode) {
        var num1 = isNumericUsing_tryParse(str[12]);
        if (num1) {
          if (str[12] != '0') {
            if (str[13] == 'Z') {
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isNumericUsing_tryParse(String string) {
    final number = num.tryParse(string);
    if (number == null) {
      return false;
    }

    return true;
  }

  void _startImageUploading() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
       dialogBox(context, 'no_network'.tr);
      });
    } else {


      if (OrgData.imageSelected == false) {

        createOrganizationApi();
      }
      else {

        await _uploadImage();

      }
    }

  }

  Future<Null> _uploadImage() async {

    try{
      start(context);
    print('1');
    var vatNumber='';
    var gstNumber='';
    var isVatString = "false";
    var isGstString = "false";
    var isVatRegString = "false";
    var isZetkaS = "false";

    var isGst = false;
    var isVat = false;

    if (taxShow) {
      if (OrgData.countryID == "30f8c506-e27a-476c-8950-b40a6461bf61") {
        gstNumber = taxNumberController.text;
        isGst = true;
        isGstString = "true";
      } else {
        vatNumber = taxNumberController.text;
        isVatString = "true";
        isVat = true;
      }
    } else {
      vatNumber = "";
      gstNumber = "";
      isZetkaS = "false";
      isZedka = false;
    }


      print('2');
    SharedPreferences prefs = await SharedPreferences.getInstance();
// update state
    setState(() {
      _isUploading = true;
    });
    String baseUrl = BaseUrl.baseUrl;
    var userID = prefs.getInt('user_id') ?? 0;
      print('-------------------------$userID');
    String id = userID.toString();
    final String url = '$baseUrl/companySettings/create/companySettingsCreate/';

    var accessToken = prefs.getString('access') ?? '';
    final mimeTypeData = lookupMimeType(OrgData.imgFile!.path, headerBytes: [0xFF, 0xD8])!.split('/');
    final imageUploadRequest = http.MultipartRequest('POST', Uri.parse(url));
    imageUploadRequest.headers['Authorization'] = "Bearer $accessToken";
    imageUploadRequest.headers['Content-Type'] = "application/json";
    final file = await http.MultipartFile.fromPath(
      'CompanyLogo',
      OrgData.imgFile!.path,
    );
    imageUploadRequest.fields['CompanyLogo'] = mimeTypeData[1];
    imageUploadRequest.fields['UpdatedUserID'] = id;
    imageUploadRequest.fields['owner'] = id;
    imageUploadRequest.fields['CreatedUserID'] = id;
    imageUploadRequest.fields['CompanyName'] = OrgData.orgName;
    imageUploadRequest.fields['State'] = OrgData.stateID;
    imageUploadRequest.fields['Country'] = OrgData.countryID;
    imageUploadRequest.fields['GSTNumber'] = vatNumber;
    imageUploadRequest.fields['VATNumber'] = gstNumber;
    imageUploadRequest.fields['FromDate'] = OrgData.fromOrgDateAPI;
    imageUploadRequest.fields['ToDate'] = OrgData.toOrgDateAPI;
    imageUploadRequest.fields['business_type'] = "c067b77d-1056-4eb8-9769-0733a29a0e9f";
    imageUploadRequest.fields['is_vat'] = isVatString;
    imageUploadRequest.fields['is_gst'] = isGstString;
    imageUploadRequest.fields['Edition'] = "Standard";
    imageUploadRequest.fields['is_registeredGst'] = isGstString;
    imageUploadRequest.fields['is_registeredVat'] = isVatRegString;
    imageUploadRequest.fields['Email'] = OrgData.email;
    imageUploadRequest.fields['Phone'] = OrgData.phone;
    imageUploadRequest.fields['Address1'] = OrgData.buildName;
    imageUploadRequest.fields['Address2'] = OrgData.landMark;
    imageUploadRequest.fields['EnableZatca'] = isZetkaS;
    imageUploadRequest.fields['City'] = OrgData.city;
    imageUploadRequest.fields['PostalCode'] = OrgData.postalCode;
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    print(response.headers);
    print(response.body);
    print(response.statusCode);
    Map n = json.decode(utf8.decode(response.bodyBytes));

      print('7');
      var status = n["StatusCode"];
      print('8');
      if (status == 6000) {
        setState(() {
          OrgData.firstSection = true;
          clearAll();
          print('9');
          stop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => OrganizationList()),
          );
          print('10');
        });
      } else if (status == 6001) {
        var message = n['message'];
        dialogBox(context, message);
        print('11');
        stop();
      } else {}
    } catch (e) {
      print(e.toString());
      setState(() {
        stop();
        dialogBox(context, "Something went wrong");
      });
    }
  }

  void _resetState() {
    setState(() {
      _isUploading = false;
    });
  }

  Future<Null> createOrganizationApi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        print('1');
        String baseUrl = BaseUrl.baseUrl;
        //  var companyID = "715cb1a8-b7a2-490e-9936-d86af70b199f";
        //  var userID = BaseUrl.userID;
        //   var branchID = prefs.getInt('branchID') ?? 1;
        // var token=BaseUrl.accessToken;
        var userID = prefs.getInt('user_id') ?? 0;
        print(userID);
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        print('2');
        final String url =
            "$baseUrl/companySettings/create/companySettingsCreate/";
        print(url);
        print('3');

        var vatNumber = "";
        var gstNumber = "";
        var isGst = false;
        var isVat = false;

        if (taxShow) {
          if (OrgData.countryID == "30f8c506-e27a-476c-8950-b40a6461bf61") {
            gstNumber = taxNumberController.text;
            isGst = true;
          } else {
            vatNumber = taxNumberController.text;
            isVat = true;
          }
        } else {
          vatNumber = "";
          gstNumber = "";
          isZedka = false;
        }

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CompanyLogo": "",
          "UpdatedUserID": userID,
          "owner": userID,
          "CreatedUserID": userID,
          "CompanyName": OrgData.orgName,
          "State": OrgData.stateID,
          "Country": OrgData.countryID,
          "GSTNumber": gstNumber,
          "VATNumber": vatNumber,
          "FromDate": OrgData.fromOrgDateAPI,
          "ToDate": OrgData.toOrgDateAPI,
          "business_type": "c067b77d-1056-4eb8-9769-0733a29a0e9f",
          "is_registeredVat": isVat,
          "is_vat": isVat,
          "is_gst": isGst,
          "is_registeredGst": isGst,
          "Edition": "Standard",
          "Email": OrgData.email,
          "Phone": OrgData.phone,
          "Address1": OrgData.buildName,
          "Address2": OrgData.landMark,
          "City": OrgData.city,
          "PostalCode": OrgData.postalCode,
          "EnableZatca": isZedka
        };
        print('4');
        print(data);
        print('5');
        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print('6');
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        print('7');
        var status = n["StatusCode"];
        print('8');
        if (status == 6000) {
          setState(() {
            OrgData.firstSection = true;
            clearAll();
            print('9');
            stop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrganizationList()),
            );
            print('10');
          });
        } else if (status == 6001) {
          var message = n['message'];
          dialogBox(context, message);

          print('11');
          stop();
        } else {}
      } catch (e) {
        setState(() {
          print('12');
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }
}
