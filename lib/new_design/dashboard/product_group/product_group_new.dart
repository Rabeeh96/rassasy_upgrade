///delete alert
import 'dart:convert';
import 'package:get/get.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';

import '../../../global/textfield_decoration.dart';
import 'detail/select_product_group_kitchen.dart';

class AddProductGroup extends StatefulWidget {
  const AddProductGroup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AddProductGroupState();
}

class AddProductGroupState extends State<AddProductGroup> {
  TextEditingController productNameController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  TextEditingController kitchenController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  FocusNode productNameFocusNode = FocusNode();
  FocusNode selectKitchenFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode kitchenFocusNode = FocusNode();
  FocusNode saveIconFocusNode = FocusNode();
  FocusNode submitFcNode = FocusNode();

  var kitchenID = "";
  bool editProduct = false;
  var netWorkProblem = true;
  bool isLoading = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;
  bool isProductGroup = false;
  bool isNetwork = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
              ),
              title: Text(
                'product_group'.tr,
                style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
              ),
              backgroundColor: const Color(0xffF3F3F3),
              actions: <Widget>[]),
          body: isNetwork == true ? productGroupDetail() : noNetworkConnectionDetail(),
          bottomNavigationBar: bottomBar(),
        ));
  }

  /// not internet detail view page
  Widget noNetworkConnectionDetail() {
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isNetwork = true;
              });
            },
            child: Text('retry'.tr,
                style: TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }

  ///product page
  Widget productGroupDetail() {
    return Row(children: <Widget>[
      isProductGroup == false
          ? refreshProductGroup()
          : Container(
              height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.height / 1,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      editProduct == true
                          ? Padding(
                              padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 30),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'edit_product_grp'.tr,
                                  textAlign: TextAlign.start,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 12,
                                child: Text(
                                  'add_product_grp'.tr,
                                  textAlign: TextAlign.start,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                                ),
                              ),
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Text(
                                  'grp_name'.tr,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                style: customisedStyle(context, Colors.black, FontWeight.normal, 12.0),
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                focusNode: productNameFocusNode,
                                controller: productNameController,
                                onEditingComplete: () {
                                  FocusScope.of(context).requestFocus(selectKitchenFocusNode);
                                },
                                decoration: TextFieldDecoration.productField(
                                  hintTextStr: '',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 5, right: 5, bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 10,
                                  child: Text(
                                   'select_kitchen'.tr,
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: TextField(
                                  focusNode: selectKitchenFocusNode,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                  readOnly: true,
                                  onTap: () async {
                                    var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SelectKitchen()),
                                    );

                                    if (result != null) {
                                      kitchenController.text = result[0];
                                      kitchenID = result[1];

                                    } else {}
                                  },
                                  controller: kitchenController,
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(descriptionFocusNode);
                                  },
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {}),
                                      enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffC9C9C9))),
                                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                                      disabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffC9C9C9))),
                                      contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                                      filled: true,
                                      hintStyle: customisedStyle(context, Colors.grey, FontWeight.w500, 14.0),
                                      hintText: "",
                                      fillColor: const Color(0xffffffff)),
                                ),
                              )
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 10,
                                child: Text(
                                  'des'.tr,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child: TextField(
                                style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                focusNode: descriptionFocusNode,
                                onEditingComplete: () {
                                  FocusScope.of(context).requestFocus(saveIconFocusNode);
                                },
                                controller: descriptionController,
                                maxLines: 4,
                                decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffF8F8F8)),
        ),
        width: MediaQuery.of(context).size.width / 3,
        child: ListView(controller: _scrollController, children: [
          Container(
            height: MediaQuery.of(context).size.height / 11,
            color: const Color(0xffFFFFFF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                onChanged: (text) {
                  _searchData(text);
                },
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  suffixIcon: IconButton(
                    onPressed: () {

                      searchController.clear();
                      productLists.clear();
                      pageNumber = 1;
                      firstTime = 1;
                      getProductListDetails();
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                  ),
                  hintText: 'search'.tr,
                  hintStyle: customisedStyle(context, Colors.grey, FontWeight.w500, 14.0),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          displayProductGroupList()
        ]),
      )
    ]);
  }

  Widget refreshProductGroup() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(alignment: Alignment.center, children: [
        Container(

            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 1.7,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    'assets/svg/group.svg',
                    height: 250,
                    width: 100,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('select_a_product_grp'.tr, style: customisedStyle(context, Colors.black, FontWeight.w400, 18.0)),
                ),
                Container(

                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('or'.tr, style: customisedStyle(context, Color(0xff949494), FontWeight.w400, 18.0)),
                ),
                addButton(),
              ],
            ))
      ]),
    );
  }

  Widget addButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 100, right: 100),
      child: GestureDetector(
        onTap: () {
          if (createPermission) {
            setState(() {
              isProductGroup = true;
            });
          } else {
            dialogBoxPermissionDenied(context);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 8,
          height: MediaQuery.of(context).size.height / 13,
        //  color: Colors.red,
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
                decoration: BoxDecoration(border: Border.all(color: const Color(0xffffffff)), shape: BoxShape.circle),
                height: MediaQuery.of(context).size.height / 22,
                width: MediaQuery.of(context).size.width / 22,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              Text('add_product_grp'.tr, style: customisedStyle(context, Color(0xffffffff), FontWeight.w400, 15.0)),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: isProductGroup == true
          ? Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 16,
                          height: MediaQuery.of(context).size.height / 12,
                          child: IconButton(
                              icon: SvgPicture.asset('assets/svg/delete1.svg'),
                              onPressed: () {
                                setState(() {
                                  isProductGroup = false;
                                  editProduct = false;
                                });
                                productNameController.clear();
                                kitchenController.clear();
                                descriptionController.clear();
                              }),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 16,
                            height: MediaQuery.of(context).size.height / 12,
                            child: IconButton(
                              icon: SvgPicture.asset('assets/svg/add1.svg'),
                              onPressed: () async {
                                if (productNameController.text.trim() == '' || productNameController.text == '') {
                                  dialogBox(context, "Please enter mandatory fields");
                                } else {
                                  if (editProduct == false) {
                                    if (createPermission) {
                                      start(context);
                                      createProductGroup();
                                    } else {
                                      dialogBoxPermissionDenied(context);
                                    }
                                  } else {
                                    start(context);

                                    editProductGroup();
                                  }
                                }
                              },
                            ))
                      ],
                    )),
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
                              editProduct = false;
                            });
                            productNameController.clear();
                            kitchenController.clear();
                            descriptionController.clear();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          : Row(),
    );
  }

  ///add and delete button
  Widget addAndDelete() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.5, //height of button
      width: MediaQuery.of(context).size.width / 1.5,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 15,
            child: IconButton(
                onPressed: () {
                  productNameController.clear();
                  kitchenController.clear();
                  descriptionController.clear();
                  editProduct = false;
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset(
                  'assets/svg/delete.svg',
                ),
                iconSize: 40),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 11, //height of button
            width: MediaQuery.of(context).size.width / 15,

            child: IconButton(
                onPressed: () async {
                  if (RegExp(r"\s").hasMatch(productNameController.text) || productNameController.text == '') {
                    dialogBox(context, "Please enter mandatory fields");
                  } else {
                    start(context);
                    editProduct == true ? editProductGroup() : createProductGroup();
                  }
                },
                icon: SvgPicture.asset('assets/svg/add.svg'),
                focusNode: saveIconFocusNode,
                iconSize: 40),
          )
        ],
      ),
    );
  }

  ///list product group
  Widget displayProductGroupList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4, //height of button
      width: MediaQuery.of(context).size.width / 2.4,

      child: ListView.builder(
          shrinkWrap: true,
          itemCount: productLists.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key('${productLists[index]}'),
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

                bool hasPermission = await checkingPerm("Groupdelete");

                if (hasPermission) {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'delete_msg'.tr,
                          style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                        ),
                        content: Text(
                          'msg4'.tr,
                          style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => {


                                GroupData.uID = productLists[index].productId,
                                Navigator.pop(context),
                                deleteProduct(productLists[index].productId, context)
                              },
                              child: Text(
                                'dlt'.tr,
                                style: customisedStyle(context, Colors.red, FontWeight.w500, 13.0),
                              )),
                          TextButton(
                            onPressed: () => {Navigator.of(context).pop()},
                            child: Text(
                              'cancel'.tr,
                              style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                } else {
                  dialogBoxPermissionDenied(context);
                  return false; // Pe
                }

              },
              direction: productLists.length > 1 ? DismissDirection.startToEnd : DismissDirection.none,
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                } else {}

                setState(() {
                  productLists.removeAt(index);
                });
              },
              child: Card(
                  child: ListTile(
                onTap: () async {
                  var perm = await checkingPerm("Groupedit");
                  print(perm);
                  if (perm) {
                    productNameController.clear();
                    descriptionController.clear();
                    kitchenController.clear();

                    GroupData.uID = productLists[index].productId;
                    getProductGroupSingleView(productLists[index].productId);
                    editProduct = true;
                    setState(() {
                      getProductGroupSingleView(productLists[index].productId);
                      isProductGroup = true;
                    });
                  } else {
                    dialogBoxPermissionDenied(context);
                  }
                },
                title: Text(
                  productLists[index].groupName,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                ),
              )),
            );
          }),
    );
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      kitchenList.clear();
      productLists.clear();
      getProductListDetails();
    });
  }

  bool createPermission = true;


  ///product group list api
  Future<Null> getProductListDetails() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/pos/product-group/list/';
          createPermission = prefs.getBool("Groupsave")??true;
          kitchenID ="";

        // var perm = await checkingPerm("Groupview");
        // print(perm);
        // if (perm) {
        //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddProductGroup()));
        // } else {
        //   dialogBoxPermissionDenied(context);
        // }

        Map data = {"CompanyID": companyID, "BranchID": branchID};

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
        if (status == 6000) {
          setState(() {
            isNetwork = true;
            productLists.clear();
            stop();

            for (Map user in responseJson) {
              productLists.add(ProductListModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          isNetwork = true;
          var msg = n["error"];
          dialogBox(context, msg);
        } else {
          stop();
        }
      } catch (e) {
        setState(() {
          isNetwork = false;
          stop();
        });
      }
    }
  }

  ///create product group api
  Future<Null> createProductGroup() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';

        final String url = "$baseUrl/productGroups/create-productGroup/";
        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "CategoryID": 1,
          "IsActive": true,
          "GroupName": productNameController.text,
          "Notes": descriptionController.text,
          "kitchen": kitchenID,
        };
        print(data);
        print(accessToken);

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
          setState(() {
            isNetwork = true;
            kitchenID = "";
            clearData();
            stop();
            getProductListDetails();
          });
        } else if (status == 6001) {
          isNetwork = true;

          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          isNetwork = false;

          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///product group single view
  Future<Null> getProductGroupSingleView(productId) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt('user_id') ?? 0;

        var accessToken = prefs.getString('access') ?? '';
        String baseUrl = BaseUrl.baseUrl;

        final url = '$baseUrl/productGroups/view/productGroup/$productId/';
        Map data = {"CompanyID": companyID, "BranchID": 1, "CreatedUserID": userID};

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

        if (status == 6000) {
          setState(() {
            stop();
            productNameController.text = responseJson['GroupName'];
            kitchenController.text = responseJson['KitchenName'];
            descriptionController.text = responseJson['Notes'];
            kitchenID = responseJson['KitchenID'];
            GroupData.catID = responseJson['CategoryID'];
            GroupData.uID = responseJson['id'];
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        } else {
          stop();
        }
      } catch (e) {

          stop();

      }
    }
  }

  clearData() {
    productNameController.clear();
    kitchenController.clear();
    descriptionController.clear();
    productLists.clear();
  }

  ///edit product group api
  Future<Null> editProductGroup() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
        var userID = prefs.getInt("user_id");
         var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';
        var groupID = GroupData.uID;

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/productGroups/edit/productGroup/$groupID/';
        Map data = {
          "GroupName": productNameController.text,
          "CategoryID": 1,
          "Notes": descriptionController.text,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "kitchen": kitchenID
        };
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
          isNetwork = true;

          setState(() {
             kitchenID="";
            clearData();
            editProduct = false;
            stop();
            getProductListDetails();
            FocusScope.of(context).requestFocus(saveIconFocusNode);
          });
        } else if (status == 6001) {
          isNetwork = true;

          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          isNetwork = false;

          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }

  ///delete product group
  deleteProduct(id, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? '';
         var branchID = prefs.getInt('branchID') ?? 1;
        var userID = prefs.getInt("user_id");
        var productId = id;

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/productGroups/delete/productGroup/$productId/';

        /// data
        Map data = {
          "BranchID": branchID,
          "CreatedUserID": userID,
          "CompanyID": companyID,
        };

        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"]; //6000 status or messege is here

        if (status == 6000) {
          setState(() {
            productLists.clear();
            clearData();
            editProduct = false;
            stop();
            getProductListDetails();
          });
        } else if (status == 6001) {
          stop();
          dialogBox(context, "You Cant Delete this Product Group,this ProductGroupID is using somewhere");
        } else {}
      } catch (e) {
        stop();
      }
    }
  }

  ///search product group
  Future _searchData(String string) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyID = prefs.getString('companyID') ?? '';
    var userID = prefs.getInt('user_id') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;
    if (string == '') {
      pageNumber = 1;
      productLists.clear();
      firstTime = 1;
      getProductListDetails();
    } else if (string.length > 1) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(context, "Unable to connect.Please Check Internet Connection");
      } else {
        try {
          Map data = {
            "BranchID": branchID,
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "PriceRounding": BaseUrl.priceRounding,
            "product_name": string,
            "length": string.length
          };
          String baseUrl = BaseUrl.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('access') ?? '';
          final String url = "$baseUrl/productGroups/search-productGroup-list/";
          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $token',
              },
              body: body);
          Map n = json.decode(utf8.decode(response.bodyBytes));
          var status = n["StatusCode"];
          var responseJson = n["data"];
          var message = n["message"];
          if (status == 6000) {
            productLists.clear();

            netWorkProblem = true;
            productLists.clear();
            isLoading = false;
            setState(() {
              for (Map user in responseJson) {
                productLists.add(ProductListModel.fromJson(user));
              }
            });
          } else if (status == 6001) {
            setState(() {
              netWorkProblem = true;
              isLoading = false;
            });

            dialogBox(context, "Some Network Error please try again Later");
          } else {
            dialogBox(context, "Some Network Error please try again Later");
          }
        } catch (e) {
          setState(() {
            netWorkProblem = false;
            isLoading = false;
          });
        }
      }

      /// call function
      return;
    } else {}
  }
}

List<ProductListModel> productLists = [];

class ProductListModel {
  final String productId, groupName;
  final int productGroupId;

  ProductListModel({required this.groupName, required this.productGroupId, required this.productId});

  factory ProductListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductListModel(groupName: json['GroupName'], productGroupId: json['ProductGroupID'], productId: json['id']);
  }
}

List<Kitchen> kitchenList = [];

class Kitchen {
  final String ipAddress, kitchenName, id;
  final bool isActive;

  Kitchen({
    required this.ipAddress,
    required this.kitchenName,
    required this.isActive,
    required this.id,
  });

  factory Kitchen.fromJson(Map<dynamic, dynamic> json) {
    return Kitchen(id: json['id'], ipAddress: json['IPAddress'], kitchenName: json['KitchenName'], isActive: json['IsActive']);
  }
}

///product group id ,kitchen id cat id
class GroupData {
  static String uID = '';

  static int catID = 0;
 // static String kitchenID = "";
}
