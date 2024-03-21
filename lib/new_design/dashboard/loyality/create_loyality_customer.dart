import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../global/textfield_decoration.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/global/global.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_switch/flutter_switch.dart';

import '../pos/detail/select_cardtype.dart';

///tax type not set
class LoyaltyCustomer extends StatefulWidget {
  @override
  State<LoyaltyCustomer> createState() => _LoyaltyCustomerState();
}

class _LoyaltyCustomerState extends State<LoyaltyCustomer> {
  TextEditingController nameController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController cardTypeController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  FocusNode nameFcNode = FocusNode();
  FocusNode customerFcNode = FocusNode();
  FocusNode phoneFcNode = FocusNode();
  FocusNode locationFcNode = FocusNode();
  FocusNode cardTypeFcNode = FocusNode();
  FocusNode cardNoFcNode = FocusNode();
  FocusNode saveFcNode = FocusNode();
  bool loyaltyStatus = false;
  bool isAddLoyalty = false;
  bool editLoyalty = false;
  bool networkConnection = true;
  bool isCardType = false;
  bool showCustomer = false;
  var loyalty = "";

  var netWorkProblem = true;
  bool isLoading = false;
  bool isCategory = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;
  int listType = 1;
  String cardTypeUID = "y";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoyaltyCustomer();

    getCardType();
    getCustomerList();
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
          children:  [
            Text(
              'loyalty_cust'.tr,
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
          ? loyaltyDetailPage()
          : noNetworkConnectionPage(),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget loyaltyDetailPage() {
    return Row(
      children: [
        isAddLoyalty == false ? loyaltyRefreshPage() : createLoyalty(),

        ///search
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF8F8F8)),
          ),
          width: MediaQuery.of(context).size.width / 3,
          child: ListView(
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              loyaltyCustLists.clear();
                              pageNumber = 1;
                              firstTime = 1;
                              getLoyaltyCustomer();
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          disabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, right: 10, bottom: 10),
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Color(0xff000000), fontSize: 14),
                          hintText: 'search'.tr,
                          fillColor: const Color(0xffffffff)),
                    ),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: loyaltyCustomerList()

                  //  selectListType(),
                   ),
                      // Container(
                  // height: MediaQuery.of(context).size.height / 1.3,
                  // child: isCardType == true
                  //     ? cardTypeList()
                  //     : loyaltyCustomerList()
                  //
                  // //  selectListType(),
                  // ),
            ],
          ),
        )
      ],
    );
  }

  ///this for changing customer list
  selectListType() {
    if (listType == 1) {
      return loyaltyCustomerList();
    } else if (listType == 2) {
      return customersListDetail();
    }
  }


  Widget loyaltyCustomerList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: loyaltyCustLists.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key('${loyaltyCustLists[index]}'),
              background: Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[
                      Icon(Icons.delete, color: Colors.white),
                    ],
                  ),
                ),
              ),
              secondaryBackground: Container(),
              confirmDismiss: (DismissDirection direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'delete_msg'.tr,
                        style: TextStyle(fontSize: 14),
                      ),
                      content: Text(
                          'msg4'.tr,
                          style: TextStyle(fontSize: 14)),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () => {
                                  LoyaltyData.uID = loyaltyCustLists[index].id,
                                  Navigator.pop(context),
                                  deleteAnItem()
                                },
                            child: Text(
                              'dlt'.tr,
                              style: TextStyle(color: Colors.red),
                            )),
                        TextButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          child: Text('cancel'.tr, style: TextStyle()),
                        ),
                      ],
                    );
                  },
                );
              },
              direction: loyaltyCustLists.length > 1
                  ? DismissDirection.startToEnd
                  : DismissDirection.none,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  print('Remove item');
                } else {
                  print("");
                }

                setState(() {
                  loyaltyCustLists.removeAt(index);
                });
              },
              child: Card(
                child: ListTile(
                    onTap: () {
                      LoyaltyData.uID = loyaltyCustLists[index].id;
                      editLoyalty = true;

                      setState(() {
                        getLoyaltySingleView();
                        isAddLoyalty = true;
                      });
                    },
                    leading: const Icon(Icons.person),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loyaltyCustLists[index].custName,
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          loyaltyCustLists[index].phone,
                          style: TextStyle(fontSize: 15),
                        ),
                        // Text(taxLists[index].type),
                      ],
                    )),
              ),
            );
          }),
    );
  }

  Widget customersListDetail() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: customersLists.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                  onTap: () {
                    setState(() {
                      customerNameController.text =
                          customersLists[index].firstName;
                      //   cardNumberController.text = cardTypeLists[index].transactionTypeId;
                      //   showCustomer = false;
                      //
                    });
                    // customerID = customersLists[index].id;
                  },
                  leading: const Icon(Icons.person),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customersLists[index].firstName,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  )),
            );
          }),
    );
  }

  Widget createLoyalty() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Center(
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 3.7,
            height: MediaQuery.of(context).size.height / 1,
            child: ListView(
              shrinkWrap: true,
              children: [
                nameField(),

                ///customer commented here
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Container(
                //       width: MediaQuery.of(context).size.width / 7,
                //       child: const Text(
                //         "Customer:",
                //         style: TextStyle(fontSize: 15),
                //       ),
                //     ),
                //     Container(
                //       width: MediaQuery.of(context).size.width / 3.5,
                //       child: Padding(
                //         padding: const EdgeInsets.only(bottom: 10),
                //         child: TextField(
                //           readOnly: true,
                //           onTap: () {
                //             setState(() {
                //               listType = 2;
                //             });
                //           },
                //           controller: customerNameController,
                //           focusNode: customerFcNode,
                //           onEditingComplete: () {
                //             FocusScope.of(context)
                //                 .requestFocus(phoneFcNode);
                //           },
                //           keyboardType: TextInputType.text,
                //           textCapitalization: TextCapitalization.words,
                //           decoration:
                //               TextFieldDecoration.rectangleTextField(
                //                   hintTextStr: ''),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                phoneNumberField(),
                locationField(),

                ///select here for card type
                cardTypeField()
                ,
                cardNumberField(),
                statusSwitch(),
                cancelAndSaveButton()
              ],
            )),
      ),
    );
  }

  Widget nameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 7,
            child:  Text(
              'name'.tr,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(fontSize: 12),
                controller: nameController,
                focusNode: nameFcNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(customerFcNode);
                },
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                decoration: TextFieldDecoration.productField(hintTextStr: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child:  Text(
            'phone1'.tr,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                // for below version 2 use this
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              // for version 2 and greater youcan also use this
              style: TextStyle(fontSize: 12),
              controller: phoneController,
              focusNode: phoneFcNode,

              onEditingComplete: () {
                FocusScope.of(context).requestFocus(locationFcNode);
              },
              //   keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.productField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget locationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child:   Text(
            'loc'.tr,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: locationController,
              focusNode: locationFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(cardTypeFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget cardTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child:   Text(
            'card_type'.tr,
            style: TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          child: TextField(
            style: TextStyle(fontSize: 12),
            readOnly: true,
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectCardType()),
              );


              if (result != null) {
                setState(() {
                  cardTypeController.text = result;
                });
              } else {}


            },
            controller: cardTypeController,
            focusNode: cardTypeFcNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(cardNoFcNode);
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            decoration:
            TextFieldDecoration.rectangleTextFieldIcon(hintTextStr: ''),

          )


        )
,
///card type selection from list
        // Container(
        //   width: MediaQuery.of(context).size.width / 3.5,
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom: 10),
        //     child: TextField(
        //       style: TextStyle(fontSize: 12),
        //       readOnly: true,
        //       onTap: () {
        //         setState(() {
        //           isCardType = true;
        //           //  listType = 3;
        //         });
        //       },
        //       controller: cardTypeController,
        //       focusNode: cardTypeFcNode,
        //       onEditingComplete: () {
        //         FocusScope.of(context).requestFocus(cardNoFcNode);
        //       },
        //       keyboardType: TextInputType.text,
        //       textCapitalization: TextCapitalization.words,
        //       decoration:
        //           TextFieldDecoration.rectangleTextField(hintTextStr: ''),
        //     ),
        //   ),
        // ),
      ],
    );
  }



  Widget cardNumberField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 7,
            child:   Text(
              'card_no'.tr,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 3.5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                style: TextStyle(fontSize: 12),
                controller: cardNumberController,
                focusNode: cardNoFcNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(saveFcNode);
                },
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  // for below version 2 use this
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  // for version 2 and greater youcan also use this
                  FilteringTextInputFormatter.digitsOnly
                ],
                textCapitalization: TextCapitalization.words,
                decoration:
                    TextFieldDecoration.rectangleTextField(hintTextStr: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusSwitch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Row(
        children: [
          Padding(
            padding:  EdgeInsets.only(right: 15),
            child: Text('Status'.tr),
          ),
          FlutterSwitch(
            width: 40.0,

            height: 20.0,

            valueFontSize: 30.0,

            toggleSize: 15.0,

            value: loyaltyStatus,

            borderRadius: 20.0,

            padding: 1.0,

            activeColor: const Color(0xff009253),

            inactiveToggleColor: const Color(0xff606060),

            inactiveColor: const Color(0xffDEDEDE),

            // showOnOff: true,

            onToggle: (val) {
              setState(() {
                loyaltyStatus = val;
              });
            },
          )
        ],
      ),
    );
  }

  Widget cancelAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 18,
          width: MediaQuery.of(context).size.width / 8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffFF0000),
            ),
            child:  Text(
              'cancel'.tr,
              style: TextStyle(color: Color(0xffFFFFFF)),
            ),
            onPressed: () {
              print("kkkkkkkkkkkkkkkkkkk");
              setState(() {
               isAddLoyalty = false;
                print(loyaltyCustLists.length);
                print("hererrere");
              });

             editLoyalty = false;
              clearData();

            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 18,
          width: MediaQuery.of(context).size.width / 8,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff12AA07),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xffFFFFFF)),
              ),
              onPressed: () {
                if (nameController.text == '' ||
                    nameController.text.trim() == '' ||
                    phoneController.text == '') {


                  // setState(() {
                  //   if (phoneController.text == '') {
                  //     dialogBox(context, 'Please enter a valid phone number');
                  //   } else {
                  //     String leng = phoneController.text;
                  //     if (leng.length > 9) {
                  //       dialogBox(context, 'Please enter a valid phone number');
                  //     }
                  //   }
                  // });

                  dialogBox(context, 'Please fill mandatory field');
                } else {
                  setState(() {
                    if (phoneController.text == '') {
                      dialogBox(context, 'Please enter a valid phone number');
                    } else {
                      String leng = phoneController.text;
                      if (leng.length < 9) {
                        dialogBox(context, 'Please enter a valid phone number');
                      } else {
                        editLoyalty == true
                            ? editLoyaltyCustomer()
                            : createLoyaltyCustomer();
                      }
                    }
                  });
                }
              }),
        )
      ],
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

  ///loyalty refresh image page
  Widget loyaltyRefreshPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: MediaQuery.of(context).size.height / 1.8,
            child: ListView(
              children: [
                SvgPicture.asset(
                  'assets/svg/refreshloyality.svg',
                  height: 220,
                  width: 100,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        'msg_loylty'.tr,
                        style: TextStyle(fontSize: 25),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        'or'.tr,
                        style:
                            TextStyle(fontSize: 20, color: Color(0xff949494)),
                      )),
                ),
                addButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget addButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 150, right: 150, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isAddLoyalty = true;
            editLoyalty = false;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 7,
          height: MediaQuery.of(context).size.height / 13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            gradient: const LinearGradient(
              colors: <Color>[
                Color(0xFFEE4709),
                Color(0xFFF68522),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffffffff)),
                    shape: BoxShape.circle),
                height: MediaQuery.of(context).size.height / 22,
                width: MediaQuery.of(context).size.width / 22,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
                Text(
                'add_loyalty'.tr,
                style: const TextStyle(color: Color(0xffffffff)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: isAddLoyalty == true
          ? Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 16,
                        height: MediaQuery.of(context).size.height / 12,
                        child: IconButton(
                            icon: SvgPicture.asset('assets/svg/addNew.svg'),
                            onPressed: () {
                              setState(() {
                                editLoyalty = false;
                              });
                              cardTypeController.clear();
                              cardNumberController.clear();
                              nameController.clear();
                              phoneController.clear();
                              locationController.clear();
                              customerNameController.clear();
                            }),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Row(),
    );
  }

  ///loyalty customer create
  Future<Null> createLoyaltyCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        print("cardTypeID------$cardTypeUID");
        final String url =
            '$baseUrl/posholds/rassassy/create_loyality_customer/';
        String loyaltyType = "";
        loyaltyStatus == true ? loyaltyType = "true" : loyaltyType = "false";
        print(loyaltyType);
        print('1111111111111111');
        print(url);

        ///card type,stats,status name
        Map data = {
          ///

          // CompanyID
          // CreatedUserID
          // BranchID
          // Phone
          // Name
          // Location
          // CardTypeID
          // CardTypeName
          // CardNumber
          // CardStatusID
          // CardStatusName
          // AccountLedgerID
          ///
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "Phone": phoneController.text,
          "Name": nameController.text,
          "Location": locationController.text,
          "CardTypeName": cardTypeController.text,
          "CardNumber": cardNumberController.text,
          "CardTypeID": LoyaltyData.cardTypeUId,
          "CardStatusID": "",
          "CardStatusName": loyaltyType
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {
          setState(() {
            loyaltyCustLists.clear();
            customersLists.clear();
            clearData();
            cardTypeLists.clear();

            stop();
            listType = 1;
            isAddLoyalty = false;
            getLoyaltyCustomer();
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///card type list
  Future<Null> getCardType() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';
        var userID = prefs.getInt('user_id') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        var companyID = prefs.getString('companyID') ?? 0;

        final String url =
            '$baseUrl/transactionTypes/transactionTypesByMasterName/';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "MasterName": "Card Network",
          "CreatedUserID": userID,
        };

        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          print(status);
          setState(() {
            cardTypeLists.clear();
            stop();

            for (Map user in responseJson) {
              cardTypeLists.add(CardTypeModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          print(status);

          stop();
          var msg = n["message"];
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

  ///list loyalty customer
  Future<Null> getLoyaltyCustomer() async {
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

        final String url = '$baseUrl/posholds/rassassy/list_loyality_customer/';
        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
        };
        print(data);
        print(accessToken);

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
        if (status == 6000) {
          setState(() {
            loyaltyCustLists.clear();

            stop();

            for (Map user in responseJson) {
              loyaltyCustLists.add(LoyaltyCustModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
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

  ///single vieww
  Future<Null> getLoyaltySingleView() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        var uID = LoyaltyData.uID;

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/rassassy-view/loyaltyCustomer/$uID/';
        print(url);
        Map data = {"CompanyID": companyID, "CreatedUserID": userID};

        print(data);
        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.statusCode);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();

            LoyaltyData.uID = responseJson['id'];
            nameController.text = responseJson['FirstName'];
            phoneController.text = responseJson['MobileNo'];
            locationController.text = responseJson['Address1'];
            customerNameController.text = responseJson['CustomerName'];
            cardTypeController.text = responseJson['CardTypeName'];
            cardNumberController.text = responseJson['CardNumber'];
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          print(dialogBox(context, msg));
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

  clearData() {
    cardTypeController.clear();
    cardNumberController.clear();
    nameController.clear();
    phoneController.clear();
    locationController.clear();
    customerNameController.clear();
  }

  ///edit loyalty customer
  Future<Null> editLoyaltyCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);
        print('1');
        var uID = LoyaltyData.uID;
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        print('2');
        String baseUrl = BaseUrl.baseUrl;
        print('3');
        final String url =
            '$baseUrl/posholds/rassassy-edit/loyaltyCustomer/$uID/';
        String loyaltyType = "";
        loyaltyStatus == true ? loyaltyType = "true" : loyaltyType = "false";

        print(url);
        Map data = {
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "Phone": phoneController.text,
          "Name": nameController.text,
          "Location": locationController.text,
          "CardTypeName": cardTypeController.text,
          "CardNumber": cardNumberController.text,
          "CardTypeID": "",
          "CardStatusID": "",
          "CardStatusName": loyaltyType
        };
        print(data);
        print('6');
        //encode Map to JSON
        var body = json.encode(data);
        print('7');
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        print('8');
        print(status);
        if (status == 6000) {
          print('9');
          setState(() {
            loyaltyCustLists.clear();

            clearData();
            stop();
            isAddLoyalty = false;
            listType = 1;

            getLoyaltyCustomer();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          print(dialogBox(context, msg));
          print('10');
          stop();
        } else {}
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Some thing went wrong"));
          stop();
        });
      }
    }
  }

  Future<Null> deleteAnItem() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);
        print("1");
        var uID = LoyaltyData.uID;
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        print("2");

        String baseUrl = BaseUrl.baseUrl;
        print("3");

        final String url =
            '$baseUrl/posholds/rassassy-delete/loyaltyCustomer/$uID/';
        print("5");

        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
        };
        print(data);
        print("6");

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here
        var msgs = n["message"];
        print(msgs);
        print(response.body);

        print(status);
        if (status == 6000) {
          setState(() {

            loyaltyCustLists.clear();
            clearData();
            stop();
            getLoyaltyCustomer();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  Future _searchData(string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;

    if (string == '') {
      pageNumber = 1;
      loyaltyCustLists.clear();
      firstTime = 1;
      getLoyaltyCustomer();
    } else if (string.length > 2) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(
            context, "Unable to connect. Please Check Internet Connection");
      } else {
        try {
          Map data = {
            "SearchVal": searchController.text,
            "CompanyID": companyID,
            "BranchID": branchID,
          };
          String baseUrl = BaseUrl.baseUrl;
          final String url =
              "$baseUrl/posholds/rassassy/search_loyality_customer/";
          print(data);
          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $accessToken',
              },
              body: body);
          print("${response.statusCode}");
          print("${response.body}");
          Map n = json.decode(utf8.decode(response.bodyBytes));
          var status = n["StatusCode"];
          var responseJson = n["data"];
          print(responseJson);
          if (status == 6000) {
            loyaltyCustLists.clear();

            setState(() {
              netWorkProblem = true;
              loyaltyCustLists.clear();
              isLoading = false;
            });

            setState(() {
              for (Map user in responseJson) {
                loyaltyCustLists.add(LoyaltyCustModel.fromJson(user));
              }
            });
          } else if (status == 6001) {
            setState(() {
              netWorkProblem = true;
              isLoading = false;
            });

            dialogBox(context, "");
          } else {
            dialogBox(context, "Some Network Error please try again Later");
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

  ///customer list
  Future<Null> getCustomerList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        networkConnection = false;
        dialogBox(context, "Check your network connection");
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/customer-list/';
        print(url);
        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          setState(() {
            networkConnection = true;

            customersLists.clear();
            stop();
            for (Map user in responseJson) {
              customersLists.add(CustomerModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          networkConnection = true;
          stop();
          // var msg = n["error"];
          // print(dialogBox(context, msg));
        } else {
          stop();
        }
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Check your network connection"));
          stop();
        });
      }
    }
  }
}

List<CardTypeModel> cardTypeLists = [];

class CardTypeModel {
  String cardName, id, transactionTypeId;

  CardTypeModel(
      {required this.cardName,
      required this.id,
      required this.transactionTypeId});

  factory CardTypeModel.fromJson(Map<dynamic, dynamic> json) {
    return CardTypeModel(
      cardName: json['Name'],
      id: json['id'],
      transactionTypeId: json['TransactionTypesID'].toString(),
    );
  }
}

List<LoyaltyCustModel> loyaltyCustLists = [];

class LoyaltyCustModel {
  String custName, id, phone;

  LoyaltyCustModel(
      {required this.custName, required this.id, required this.phone});

  factory LoyaltyCustModel.fromJson(Map<dynamic, dynamic> json) {
    return LoyaltyCustModel(
      custName: json['FirstName'],
      id: json['id'],
      phone: json['MobileNo'],
    );
  }
}

List<CustomerModel> customersLists = [];

class CustomerModel {
  String firstName, lastName, id, phone, email, address;

  CustomerModel(
      {required this.firstName,
      required this.phone,
      required this.lastName,
      required this.id,
      required this.email,
      required this.address});

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    return CustomerModel(
        lastName: json['LastName'] ?? '',
        phone: json['PhoneNumber'] ?? '',
        firstName: json['FirstName'] ?? '',
        id: json['id'],
        email: json['Email'] ?? '',
        address: json['Address1'] ?? '');
  }
}

class LoyaltyData {
  static String uID = '';
  static String cardTypeUId = '';
}

///customer commented
///customer not added in api
