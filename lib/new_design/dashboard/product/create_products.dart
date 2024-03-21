import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/new_design/dashboard/product/detail/select_category_new.dart';
import '../../../global/textfield_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'detail/selectTax.dart';
import 'package:get/get.dart';

class CreateProductNew extends StatefulWidget {
  @override
  State<CreateProductNew> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<CreateProductNew> {
  String categoryName = "Primary Group";
  String taxName = "None";
  int categoryUId = 1;
  bool edit = false;

  bool? gstType;
  bool? vatType;
  Color color2 = Colors.orange;
  Color color1 = Colors.transparent;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController salesPriceController = TextEditingController();
  TextEditingController purchasePriceController = TextEditingController();
  TextEditingController taxController = TextEditingController();
  TextEditingController exciseTaxController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  FocusNode nameFCNode = FocusNode();
  FocusNode descriptionFcNode = FocusNode();
  FocusNode categoryFcNode = FocusNode();
  FocusNode priceFcNode = FocusNode();
  FocusNode purchasePriceFcNode = FocusNode();
  FocusNode taxFCNode = FocusNode();
  FocusNode saveFcNode = FocusNode();


  bool addNewProduct = false;
  bool networkConnection = true;
  var categoryID = 1;
  var netWorkProblem = true;
  bool isLoading = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;

  bool imageSelect = false;
  bool imageSelect2 = false;
  bool imageSelect3 = false;

  File? imgFile;
  File? imgFile2;
  File? imgFile3;

  final imgPicker = ImagePicker();
  int type = 1;

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('cam'.tr),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  GestureDetector(
                    child: Text(
                      'gall'.tr,
                    ),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (type == 1) {
        imgFile = File(imgCamera!.path);
        imageSelect = true;
      } else if (type == 2) {
        imgFile2 = File(imgCamera!.path);
        imageSelect2 = true;
      } else if (type == 3) {
        imgFile3 = File(imgCamera!.path);
        imageSelect3 = true;
      }
      print("camera");
      print(imgFile);
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    print('1');
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    print('2');
    print('3');

    setState(() {
      if (type == 1) {
        imgFile = File(imgGallery!.path);
        imageSelect = true;
      } else if (type == 2) {
        imgFile2 = File(imgGallery!.path);
        imageSelect2 = true;
      } else if (type == 3) {
        imgFile3 = File(imgGallery!.path);
        imageSelect3 = true;
      }
      print("gallery");
      print(imgFile);
    });

    Navigator.of(context).pop();
  }

  Widget displayImage() {
    return GestureDetector(
      onTap: () {
        setState(() {
          type = 1;
          showOptionsDialog(context);
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        width: MediaQuery.of(context).size.width / 20,
        child: imgFile == null
            ? Text('msg5'.tr)
            : Image.file(
                imgFile!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget displayImage2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          type = 2;
          showOptionsDialog(context);
        });
      },
      child: Container(
          height: MediaQuery.of(context).size.height / 7,
          width: MediaQuery.of(context).size.width / 12,
          child: imgFile2 == null
              ? Text('msg5'.tr)
              : Image.file(
                  imgFile2!,
                  fit: BoxFit.cover,
                )),
    );
  }

  Widget displayImage3() {
    return GestureDetector(
      onTap: () {
        setState(() {
          type = 3;
          showOptionsDialog(context);
        });
      },
      child: Container(
          height: MediaQuery.of(context).size.height / 7,
          width: MediaQuery.of(context).size.width / 12,
          child: imgFile3 == null
              ? Text('msg5'.tr)
              : Image.file(
                  imgFile3!,
                  fit: BoxFit.cover,
                )),
    );
  }

  var defaultTaxId = 1;
  var defaultTaxName = "None";

  Future<Null> getDefaultTax() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
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

        Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "PriceRounding": priceRounding};

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
            taxLists.clear();
            for (Map user in responseJson) {
              taxLists.add(TaxModel.fromJson(user));
            }
            searchTaxList = taxLists.where((i) => i.IsDefault == true).toList();

            defaultTaxId = searchTaxList[0].taxID;
            defaultTaxName = searchTaxList[0].taxName;
          });
        } else if (status == 6001) {
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {}
      } catch (e) {}
    }
  }

  Future<Null> convertToArabic(String dataa) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

    } else {
      try {

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();


         var token = prefs.getString('access') ?? '';
        print(token);
        final String url = "$baseUrl/translate/translate/";
        print(url);
        Map data = {
          "keyword":dataa,
          "language": "ar"
        };
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
        var myDataString = utf8.decode(response.bodyBytes);
        ///obtain json from string
        Map n= jsonDecode(myDataString);
        var status = n["StatusCode"];
        var arabic = n["data"];
        if (status == 6000) {
      //    setState(() {

            descriptionController.text = arabic;
       //   });
        }else {


            dialogBox(context,'Try again ');



        }
      }
      catch (e) {

        print('Error In Loading');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productLists.clear();
    Future.delayed(Duration(seconds: 0), () async {
      await getProductList();
      await getDefaultTax();
      await defaultValue();
    });
  }
  int ProductTaxID =0;
  int ProductExciseTaxID =0;
  defaultValue() {
    ProductData.catID = 1;
    ProductTaxID = defaultTaxId;
    ProductExciseTaxID = defaultTaxId;
    categoryController..text = 'Primary Group';
    taxController..text = defaultTaxName;
    exciseTaxController..text = defaultTaxName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xffF3F3F3),
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
          children: [
            Text(
              'Product'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
            ),
          ],
        ),
        actions: [],
      ),
      body: networkConnection == true ? productDetailPage() : noNetworkConnectionPage(),
      bottomNavigationBar: bottomBar(),
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              getProductList();
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

  Widget productDetailPage() {
    return Row(
      children: [
        addNewProduct == false ? productAddPage() : createProductPage(),
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
                    controller: searchController,
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    onChanged: (text) {
                      _searchData(text);
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                            productLists.clear();
                            pageNumber = 1;
                            firstTime = 1;
                            getProductList();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                        disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                        contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                        filled: true,
                        hintStyle: customisedStyle(context, Colors.grey, FontWeight.w500, 14.0),
                        hintText: 'search'.tr,
                        fillColor: const Color(0xffffffff)),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.4,
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
                            bool hasPermission = await checkingPerm("Productdelete");

                            if (hasPermission) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'delete_msg'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                    ),
                                    content: Text('msg4'.tr,
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0)),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () =>
                                              {
                                                ProductData.productID = productLists[index].id,
                                                Navigator.of(context).pop(), deleteAnItem()
                                              },
                                          child: Text(
                                            'dlt'.tr,
                                            style: customisedStyle(context, Colors.red, FontWeight.w500, 14.0),
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
                              print('Remove item');
                            } else {
                              print("");
                            }

                            setState(() {
                              productLists.removeAt(index);
                            });
                          },
                          child: Card(
                            child: ListTile(
                                onTap: () async {
                                  bool hasPermission = await checkingPerm("Productedit");

                                  if (hasPermission) {
                                    ProductData.productID = productLists[index].id;
                                    edit = true;
                                    setState(() {
                                      nameController.clear();
                                      salesPriceController.clear();
                                      purchasePriceController.clear();
                                      descriptionController.clear();
                                      categoryController.clear();
                                      taxController.clear();
                                      exciseTaxController.clear();
                                      isInclusiveNotifier.value = false;
                                      getProductSingleView();
                                      addNewProduct = true;
                                    });
                                  } else {
                                    dialogBoxPermissionDenied(context);
                                  }
                                },
                                leading: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: productLists[index].productImage == ''
                                      ? NetworkImage('https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                      : NetworkImage(productLists[index].productImage),
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productLists[index].productName,
                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                    ),
                                    Text(productLists[index].defaultUnitName, style: TextStyle(color: Color(0xff565656), fontSize: 14)),
                                  ],
                                )),
                          ));
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }

  ///create page
  Widget createProductPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 1.8,
            height: MediaQuery.of(context).size.height / 1.4,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 21,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 4,
                    child: edit == true
                        ? Text(
                            'edit_product'.tr,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                          )
                        : Text(
                            'add_product'.tr,
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, right: 120, top: 8, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Color(0xffD5D5D5)), color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(2))),
                          height: MediaQuery.of(context).size.height / 8,
                          width: MediaQuery.of(context).size.width / 12,
                          child: imageSelect == true
                              ? displayImage()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            type = 1;
                                            showOptionsDialog(context);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      /// commented multiple product option
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 5, right: 5),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Color(0xffD5D5D5)),
                      //         color: Colors.white,
                      //         borderRadius:
                      //         BorderRadius.all(Radius.circular(2))),
                      //     height: MediaQuery.of(context).size.height / 8,
                      //     width: MediaQuery.of(context).size.width / 12,
                      //     child: imageSelect2 == true
                      //         ? displayImage2()
                      //         : Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Container(
                      //           decoration: const BoxDecoration(
                      //             shape: BoxShape.circle,
                      //           ),
                      //           height:
                      //           MediaQuery.of(context).size.height /
                      //               20,
                      //           width: MediaQuery.of(context).size.width /
                      //               20,
                      //           child: IconButton(
                      //             onPressed: () {
                      //               setState(() {
                      //                 showOptionsDialog(context);
                      //                 type = 2;
                      //               });
                      //
                      //
                      //             },
                      //             icon: Icon(
                      //               Icons.add,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 5, right: 5),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //         border: Border.all(color: Color(0xffD5D5D5)),
                      //         color: Colors.white,
                      //         borderRadius:
                      //         BorderRadius.all(Radius.circular(2))),
                      //     height: MediaQuery.of(context).size.height / 8,
                      //     width: MediaQuery.of(context).size.width / 12,
                      //     child: imageSelect3 == true
                      //         ? displayImage3()
                      //         : Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Container(
                      //           decoration: const BoxDecoration(
                      //             shape: BoxShape.circle,
                      //           ),
                      //           height:
                      //           MediaQuery.of(context).size.height /
                      //               20,
                      //           width: MediaQuery.of(context).size.width /
                      //               20,
                      //           child: IconButton(
                      //             onPressed: () {
                      //               setState(() {
                      //                 showOptionsDialog(context);
                      //
                      //                 type = 3;
                      //               });
                      //
                      //             },
                      //             icon: Icon(
                      //               Icons.add,
                      //               color: Colors.grey,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                chooseVegOrNon(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.9,
                      child: Column(
                        children: [
                          nameField(),
                          descriptionField(),
                          selectTaxField(),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.9,
                      child: Column(
                        children: [
                          selectCategory(),
                          priceField(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 12, bottom: 8),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: Text(
                                    'pur_Price'.tr,
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 4,
                                child: TextField(
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                                  controller: purchasePriceController,
                                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                  ],

                                  onTap: () => purchasePriceController.selection =
                                      TextSelection(baseOffset: 0, extentOffset: purchasePriceController.value.text.length),
                                  focusNode: purchasePriceFcNode,
                                  onEditingComplete: () {
                                    FocusScope.of(context).requestFocus(taxFCNode);
                                  },

                                  decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///refresh image
  Widget productAddPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: MediaQuery.of(context).size.height / 1.9,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svg/refreshproducts.svg'),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        'select_product'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 23.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 12,
                    child: Text(
                      'or'.tr,
                      style: customisedStyle(context, Color(0xff949494), FontWeight.w500, 23.0),
                    ),
                  ),
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


          if (createPermission) {
            setState(() {
              addNewProduct = true;
            });
          } else {
            dialogBoxPermissionDenied(context);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 6,
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
                decoration: BoxDecoration(border: Border.all(color: const Color(0xffffffff)), shape: BoxShape.circle),
                height: MediaQuery.of(context).size.height / 22,
                width: MediaQuery.of(context).size.width / 20,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              Text(
                'add_product'.tr,
                style: customisedStyle(context, Colors.white, FontWeight.w500, 20.0),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool veg = false;

  Widget chooseVegOrNon() {
    return Padding(
      padding: const EdgeInsets.only(left: 120, right: 120, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: Container(
              height: MediaQuery.of(context).size.height / 16,
              width: MediaQuery.of(context).size.width / 8.5,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: color1,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          veg = true;
                          color1 = Colors.orange;
                          color2 = Colors.transparent;
                        });
                      },
                      icon: SvgPicture.asset('assets/svg/veg.svg')),
                   Text('veg'.tr)
                ],
              ),
            ),
            onTap: () {
              setState(() {
                veg = true;
                color1 = Colors.orange;
                color2 = Colors.transparent;
              });
            },
          ),
          GestureDetector(
              child: Container(
                  // padding:EdgeInsets.only(right: 2.0),
                  height: MediaQuery.of(context).size.height / 16,
                  width: MediaQuery.of(context).size.width / 8.5,
                  //color: Colors.white,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: color2,
                      width: 2,
                    ),
                  ),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            color2 = Colors.orange;
                            color1 = Colors.transparent;
                            veg = false;
                          });
                        },
                        icon: SvgPicture.asset('assets/svg/nonveg.svg')),
                     Text('non_veg'.tr)
                  ])),
              onTap: () {
                setState(() {
                  color2 = Colors.orange;
                  color1 = Colors.transparent;
                  veg = false;
                });
              }),
        ],
      ),
    );
  }

  Widget nameField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Text(
              'name'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            textCapitalization: TextCapitalization.words,
            controller: nameController,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
            focusNode: nameFCNode,
            onEditingComplete: () {
              if(nameController.text !=""){
                convertToArabic(nameController.text);
              }
              FocusScope.of(context).requestFocus(saveFcNode);
            },
            keyboardType: TextInputType.text,
            decoration: TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
          ),
        ),
      ],
    );
  }

  Widget descriptionField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Text(
              'description'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
            controller: descriptionController,
            focusNode: descriptionFcNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(priceFcNode);
            },
            // keyboardType: TextInputType.multiline,
            decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
          ),
        ),
      ],
    );
  }

  Widget selectCategory() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Text(
              'Group'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
            onTap: () async {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SelectCategoryNew()),
              );

              print(result);

              if (result != null) {
                categoryController.text = result;
              }
            },
            readOnly: true,
            controller: categoryController,
            focusNode: categoryFcNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(priceFcNode);
            },
            keyboardType: TextInputType.text,
            decoration: TextFieldDecoration.rectangleTextFieldIcon(hintTextStr: ""),
          ),
        ),
      ],
    );
  }

  Widget priceField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8),
          child: Container(
            width: MediaQuery.of(context).size.width / 6,
            child: Text(
              'sales_price'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          child: TextField(
            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
            controller: salesPriceController,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
            ],
            onTap: () => salesPriceController.selection = TextSelection(baseOffset: 0, extentOffset: salesPriceController.value.text.length),
            focusNode: priceFcNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(purchasePriceFcNode);
            },
            decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
          ),
        ),
      ],
    );
  }
  final ValueNotifier<bool> isInclusiveNotifier = ValueNotifier(false);
  Widget selectTaxField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
              child: Container(
                // width: MediaQuery.of(context).size.width / 9,
                child: Text(
                  'tax'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
                ),
              ),
            ),

            /// commented inclusive
            // Padding(
            //   padding: const EdgeInsets.only(right: 8),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Container(
            //         alignment: Alignment.center,
            //         height: MediaQuery.of(context).size.width / 45,
            //         child: Checkbox(
            //           checkColor: Colors.green,
            //           activeColor: Colors.red,
            //           side: BorderSide(
            //               color: Color(0xffACACAC)
            //           ),
            //           fillColor: MaterialStateProperty.all<Color>(
            //               Color(0xffffffff)),
            //           value: isTaxInclude,
            //           onChanged: (value) {
            //             setState(() {
            //               isTaxInclude = value!;
            //             });
            //           },
            //         ),
            //       ),
            //       Container(
            //           alignment: Alignment.center,
            //           height:
            //           MediaQuery.of(context).size.width / 44,
            //           child: Text('Tax Inclusive'))
            //     ],
            //   ),
            // )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
           // color: Colors.red,
            width: MediaQuery.of(context).size.width / 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 6.5,
                  child: TextField(
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    readOnly: true,
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectTax(type: "1",)),
                      );

                      if (result != null) {
                        ProductTaxID   = result[0];
                        taxController.text = result[1];
                      }
                    },
                    controller: taxController,
                    focusNode: taxFCNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(saveFcNode);
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.rectangleTextFieldIcon(hintTextStr: ""),
                  ),
                ),
                Container(
                //  height: MediaQuery.of(context).size.height / 18,
                  // decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), border: Border.all(color: const Color(0xffDEDEDE), width: .5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        'Inclusive'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
                      ),
                      SizedBox(width: 3,),
                      ValueListenableBuilder(
                          valueListenable: isInclusiveNotifier,
                          builder: (BuildContext context, bool zakathIsOnValue, _) {
                            return FlutterSwitch(
                              width: 40.0,
                              height: 24.0,
                              valueFontSize: 20.0,
                              toggleSize: 14.0,
                              value: isInclusiveNotifier.value,
                              borderRadius: 20.0,
                              padding: 1.0,
                              activeColor: const Color(0xff9974EF),
                              activeTextColor: Colors.green,
                              inactiveTextColor: Colors.grey,
                              inactiveColor: Colors.grey,
                              onToggle: (val) async {
                                isInclusiveNotifier.value = !isInclusiveNotifier.value;
                              },
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 8, left: 4),
          child: Container(
            // width: MediaQuery.of(context).size.width / 9,
            child: Text(
              'excise_tax'.tr,
              style: customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Container(
            // color: Colors.red,
            width: MediaQuery.of(context).size.width / 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 6.5,
                  child: TextField(
                    style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                    readOnly: true,
                    onTap: () async {
                      var result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SelectTax(type: "2",)),
                      );

                      if (result != null) {
                        ProductExciseTaxID   = result[0];
                        exciseTaxController.text = result[1];

                      }

                    },
                    controller: exciseTaxController,
                    focusNode: taxFCNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(saveFcNode);
                    },
                    keyboardType: TextInputType.text,
                    decoration: TextFieldDecoration.rectangleTextFieldIcon(hintTextStr: ""),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  ///bottom buttons
  Widget bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: addNewProduct == true
          ? Row(
              children: [
                deleteAndAddButton(),
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
                              isInclusiveNotifier.value = false;
                              setState(() {
                                imageSelect = false;
                                imageSelect2 = false;
                                imageSelect3 = false;
                                edit = false;
                              });
                              nameController.clear();
                              descriptionController.clear();
                              categoryController.clear();
                              salesPriceController.clear();
                              purchasePriceController.clear();
                              taxController.clear();
                              exciseTaxController.clear();
                              defaultValue();
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

  Widget deleteAndAddButton() {
    return Container(
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
                    edit = false;
                    addNewProduct = false;
                    imageSelect = false;
                    imageSelect2 = false;
                    imageSelect3 = false;
                  });

                  nameController.clear();
                  descriptionController.clear();
                  categoryController.clear();
                  salesPriceController.clear();
                  purchasePriceController.clear();
                  taxController.clear();
                  defaultValue();
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 16,
            height: MediaQuery.of(context).size.height / 12,
            child: IconButton(
                focusNode: saveFcNode,
                icon: SvgPicture.asset('assets/svg/add1.svg'),
                onPressed: () {
                  /// commented for upload image in product
                  if (nameController.text.trim() == '' ||
                      nameController.text == '' ||
                      categoryController.text == '' ||
                      salesPriceController.text == '' ||
                      purchasePriceController.text == '' ||
                      taxController.text == '' ||      exciseTaxController.text == '' ||
                      ProductTaxID == '' ||
                      ProductData.catID == '') {
                    dialogBox(context, "Please fill mandatory fields");
                  } else {
                    if (edit == false) {
                      if (createPermission) {
                        start(context);
                        createProduct();
                      } else {
                        dialogBoxPermissionDenied(context);
                      }
                    } else {
                      start(context);
                      editProduct();
                    }
                  }
                }),
          )
        ],
      ),
    );
  }

  /// search product from list
  Future _searchData(String searchVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var companyID = prefs.getString('companyID') ?? '';
    var userID = prefs.getInt('user_id') ?? 0;

    if (searchVal == '') {
      pageNumber = 1;
      productLists.clear();
      firstTime = 1;
      getProductList();
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(context, "Unable to connect. Please Check Internet Connection");
      } else {
        try {
          String baseUrl = BaseUrl.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('access') ?? '';
          var companyID = prefs.getString('companyID') ?? 0;
          var branchID = prefs.getInt('branchID') ?? 1;
          final url = '$baseUrl/posholds/pos-product-list-paginated/';
          print(url);

          Map data = {
            "CompanyID": companyID,
            "BranchID": branchID,
            "PriceRounding": 2,
            "GroupID": null,
            "page_no": 1,
            "items_per_page": 20,
            "search": searchVal
          };
          print(data);



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
            productLists.clear();

            setState(() {
              netWorkProblem = true;
              productLists.clear();
              isLoading = false;
            });

            setState(() {
              for (Map user in responseJson) {
                productLists.add(ProductListModel.fromJson(user));
              }
            });
          } else if (status == 6001) {
            setState(() {
              productLists.clear();
              netWorkProblem = true;
              isLoading = false;
            });

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
    }
  }

  Future _searchDatai(String searchVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var companyID = prefs.getString('companyID') ?? '';
    var userID = prefs.getInt('user_id') ?? 0;

    if (searchVal == '') {
      pageNumber = 1;
      productLists.clear();
      firstTime = 1;
      getProductList();
    } else if (searchVal.length > 2) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(context, "Unable to connect. Please Check Internet Connection");
      } else {
        try {
          Map data = {
            "BranchID": BaseUrl.branchID,
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "PriceRounding": BaseUrl.priceRounding,
            "product_name": searchVal,
            "length": searchVal.length,
            "type": ""
          };
          String baseUrl = BaseUrl.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('access') ?? '';
          final String url = "$baseUrl/products/search-product-list/";
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
            productLists.clear();

            setState(() {
              netWorkProblem = true;
              productLists.clear();
              isLoading = false;
            });

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

          print(e);
        }
      }

      /// call function
      return;
    } else {}
  }

  bool createPermission = true;

  ///list products
  Future<Null> getProductList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
        networkConnection = false;
      });
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        createPermission = prefs.getBool("Productsave") ?? true;
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/pos-product-list-paginated/';

        print(url);
        print(accessToken);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": 2,
          "GroupID": null,
          "page_no": 1,
          "items_per_page": 40,
          "search": ""
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
            networkConnection = true;
            stop();
            productLists.clear();
            for (Map user in responseJson) {
              productLists.add(ProductListModel.fromJson(user));
            }

          });
        } else if (status == 6001) {
          networkConnection = true;
          stop();
          // var msg = n["error"];
          // print(dialogBox(context, msg));
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

  // Future<Null> getProductList() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     setState(() {
  //       stop();
  //       networkConnection = false;
  //     });
  //   } else {
  //     try {
  //       start(context);
  //
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       var userID = prefs.getInt('user_id') ?? 0;
  //       var accessToken = prefs.getString('access') ?? '';
  //       var companyID = prefs.getString('companyID') ?? 0;
  //       var branchID = prefs.getInt('branchID') ?? 1;
  //
  //       String baseUrl = BaseUrl.baseUrl;
  //       final url = '$baseUrl/posholds/pos-product-list/';
  //
  //       print(url);
  //       print(accessToken);
  //
  //       Map data = {
  //         "CompanyID": companyID,
  //         "BranchID": branchID,
  //         "PriceRounding": 2,
  //         "GroupID": null,
  //         "type": ""
  //       };
  //       print(data);
  //
  //       //encode Map to JSON
  //       var body = json.encode(data);
  //
  //       var response = await http.post(Uri.parse(url),
  //           headers: {
  //             "Content-Type": "application/json",
  //             'Authorization': 'Bearer $accessToken',
  //           },
  //           body: body);
  //
  //       Map n = json.decode(utf8.decode(response.bodyBytes));
  //       var status = n["StatusCode"];
  //       var responseJson = n["data"];
  //       print(status);
  //       print(responseJson);
  //       if (status == 6000) {
  //         setState(() {
  //           networkConnection = true;
  //           stop();
  //           productLists.clear();
  //           for (Map user in responseJson) {
  //             productLists.add(ProductListModel.fromJson(user));
  //           }
  //
  //           print('--length  ${productLists.length}');
  //         });
  //       } else if (status == 6001) {
  //         networkConnection = true;
  //
  //         stop();
  //         // var msg = n["error"];
  //         // print(dialogBox(context, msg));
  //       }
  //       //DB Error
  //       else {
  //         stop();
  //       }
  //     } catch (e) {
  //       setState(() {
  //         print(dialogBox(context, "${e.toString()}Something Error"));
  //
  //         stop();
  //       });
  //     }
  //   }
  // }

  ///create products

  void _startImageUploading() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        dialogBox(context, 'no_network'.tr);
      });
    } else {
      // edit == true ? editProduct() : createProductApi();
      //
      // if (OrgData.imageSelected == false) {
      //   createOrganizationApi();
      // }
      // else {
      //
      //   await _uploadImage();
      //
      // }
    }
  }

  clearData() {
    nameController.clear();
    descriptionController.clear();
    categoryController.clear();
    salesPriceController.clear();
    purchasePriceController.clear();
    taxController.clear();
    exciseTaxController.clear();
  }

  createProduct() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? '0';
        var branchID = prefs.getInt('branchID') ?? 1;

        var type = "";
        veg == true ? type = "veg" : type = "Non-veg";

        var categoryID = ProductData.catID.toString();
        var tax_ID = ProductTaxID.toString();
        var exTax_ID = ProductExciseTaxID.toString();

        var price = "0.00";

        if (salesPriceController.text.isNotEmpty) {
          print("Condition");
          price = salesPriceController.text;
        }
        var purchasePrice = "0.00";

        if (purchasePriceController.text.isNotEmpty) {
          purchasePrice = purchasePriceController.text;
        }

        print("1");
        var val = 'False';
        isInclusiveNotifier.value == true ? val = 'True' : val = 'False';
        print("2");
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/product-create/';
        print(url);
        print("3");
        var headers = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        };
        print("4");
        var request = http.MultipartRequest('POST', Uri.parse(url));
        print("5   $val");
        request.fields.addAll({
          "SalesPrice": price,
          "PurchasePrice": purchasePriceController.text,
          "BranchID": branchID.toString(),
          "CreatedUserID": userID.toString(),
          "CompanyID": companyID,
          "VegOrNonVeg": type,
          "ProductName": nameController.text,
          "ProductGroupID": categoryID,
          "Description": descriptionController.text,
          "Price": purchasePrice,
          "TaxID": tax_ID,
          "is_inclusive": val,
          "ExciseTaxID": exTax_ID,
        });

        print("6");

        print(request.fields);
        if (imageSelect) {
          request.files.add(await http.MultipartFile.fromPath('productImage1', imgFile!.path));
        }
        if (imageSelect2) {
          request.files.add(await http.MultipartFile.fromPath('productImage2', imgFile2!.path));
        }
        if (imageSelect3) {
          request.files.add(await http.MultipartFile.fromPath('productImage3', imgFile3!.path));
        }

        request.headers.addAll(headers);
        print(request.headers);
        print(headers);
        print("hh");

        final streamResponse = await request.send();
        final response = await http.Response.fromStream(streamResponse);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        if (status == 6000) {
          setState(() {
            imageSelect = false;
            imageSelect2 = false;
            imageSelect3 = false;
            Colors.orange;
            Colors.transparent;
            veg = false;
            var msg = n["message"];
            isInclusiveNotifier.value = false;
            addNewProduct = false;
            stop();
            clearData();
            defaultValue();
            getProductList();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        dialogBox(context, "Something went wrong");
        stop();
      }
    }
  }
  void dispose() {
    super.dispose();
    stop();
  }
  editProduct() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? '0';
        var branchID = prefs.getInt('branchID') ?? 1;

        var type = "";
        veg == true ? type = "veg" : type = "Non-veg";
        var categoryID = ProductData.catID.toString();
        var tax_ID = ProductTaxID.toString();
        var exTax_ID = ProductExciseTaxID.toString();
        var productUID = ProductData.productID;

        var val = 'False';
        isInclusiveNotifier.value == true ? val = 'True' : val = 'False';
        var price = "0.00";

        if (salesPriceController.text.isNotEmpty) {
          print("Condition");
          price = salesPriceController.text;
        }
        var purchasePrice = "0.00";

        if (purchasePriceController.text.isNotEmpty) {
          purchasePrice = purchasePriceController.text;
        }

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/edit/product/$productUID/';

        var headers = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        };
        print("5   $val");
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.fields.addAll({
          "SalesPrice": price,
          "PurchasePrice": purchasePriceController.text,
          "BranchID": branchID.toString(),
          "CreatedUserID": userID.toString(),
          "CompanyID": companyID,
          "VegOrNonVeg": type,
          "ProductName": nameController.text,
          "ProductGroupID": categoryID,
          "Description": descriptionController.text,
          "Price": purchasePrice,
          "TaxID": tax_ID,
          "is_inclusive": val,
          "ExciseTaxID": exTax_ID,
        });

        print(request.fields);
        if (imageSelect) {
          request.files.add(await http.MultipartFile.fromPath('productImage1', imgFile!.path));
        }
        if (imageSelect2) {
          request.files.add(await http.MultipartFile.fromPath('productImage2', imgFile2!.path));
        }
        if (imageSelect3) {
          request.files.add(await http.MultipartFile.fromPath('productImage3', imgFile3!.path));
        }
        request.headers.addAll(headers);
        final streamResponse = await request.send();
        final response = await http.Response.fromStream(streamResponse);
        Map n = json.decode(utf8.decode(response.bodyBytes));

        var status = n["StatusCode"];
        if (status == 6000) {
          isInclusiveNotifier.value = false;
          setState(() {
            Colors.orange;
            Colors.transparent;
            veg = false;
            imageSelect = false;
            imageSelect2 = false;
            imageSelect3 = false;
            var msg = n["message"];
            dialogBox(context, msg);
            addNewProduct = false;
            stop();
            clearData();
            edit = false;
            defaultValue();
            getProductList();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        dialogBox(context, "Some thing went wrong${e.toString()}");
        stop();
      }
    }
  }

  ///single view
  Future<Null> getProductSingleView() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your internet connection");
    } else {
      try {
        print("1");
        start(context);
        print("2");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        var productUID = ProductData.productID;
        print("3");
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/single/product/$productUID/';
        print(url);
        Map data = {
          "CompanyID": companyID,
        };
        print("4");
        print(data);
        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print("5   $accessToken");
        print(response.statusCode);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);

        print("6");
        print(responseJson);
        if (status == 6000) {


          setState(() {

            imageSelect2 = false;
            imageSelect = false;
            imageSelect3 = false;

            var checkVat = prefs.getBool("checkVat") ?? false;
            var checkGst = prefs.getBool("check_GST") ?? false;

            if (checkVat == true) {
              ProductTaxID = responseJson['VatID'];
              taxController.text = responseJson['VAT_TaxName'];
              exciseTaxController.text = responseJson['VAT_TaxName'];
              ProductExciseTaxID = responseJson['VatID'];

              var exciseData = responseJson["ExciseTaxData"]??"";
              if(exciseData !=""){
                exciseTaxController.text = exciseData["TaxName"]??"";
                ProductExciseTaxID = exciseData["TaxID"]??6;
              }
            }

            if (checkGst == true) {

              ProductTaxID = responseJson['GST_ID'];
              taxController.text = responseJson['GST_TaxName'];

            }

            stop();
            ProductData.catID = responseJson['ProductGroupID'];


            isInclusiveNotifier.value = responseJson['is_inclusive'];
            nameController.text = responseJson['ProductName'];
            salesPriceController.text = responseJson['DefaultSalesPrice'].toString();
            purchasePriceController.text = responseJson['DefaultPurchasePrice'].toString();
            descriptionController.text = responseJson['Description'];
            categoryController.text = responseJson['GroupName'];


            var imgData = responseJson["ProductImage"] ?? '';
            var imgData2 = responseJson["ProductImage2"] ?? '';
            var imgData3 = responseJson["ProductImage3"] ?? '';

            if (imgData == '') {
            } else {
              loadImage(imgData, 1);
            }
            if (imgData2 == '') {
            } else {
              loadImage(imgData2, 2);
            }

            if (imgData3 == '') {
            } else {
              loadImage(imgData3, 3);
            }



            stop();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"]??"";
           dialogBox(context, msg.toString());
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

  loadImage(image, type) async {
    try {
      final file = await getFileFromNetworkImage(image);
      setState(() {
        if (type == 1) {
          imageSelect = true;
          imgFile = file;
        } else if (type == 2) {
          imageSelect2 = true;
          imgFile2 = file;
        } else {
          imageSelect3 = true;
          imgFile3 = file;
        }
      });
    } catch (e) {}
  }

  Future<File> getFileFromNetworkImage(String imageUrl) async {
    var response = await http.get(Uri.parse(imageUrl));
    final documentDirectory = await getApplicationDocumentsDirectory();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    File file = File(p.join(documentDirectory.path, '$fileName.png'));
    file.writeAsBytes(response.bodyBytes);
    return file;
  }

  ///delete product
  Future<Null> deleteAnItem() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        stop();

    } else {
      try {
        start(context);
        var productUID = ProductData.productID;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/delete/product/$productUID/';
        print(url);

        Map data = {"CreatedUserID": userID, "CompanyID": companyID, "BranchID": 1};
        print(data);

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
            productLists.clear();

            edit = false;
            stop();
            getProductList();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          print(dialogBox(context, msg));
        } else {}
      } catch (e) {

          print(dialogBox(context, "Some thing went wrong"));
          stop();

      }
    }
  }
}

List<ProductListModel> productLists = [];

class ProductListModel {
  String productName, defaultUnitName, id, productImage, productImage2, productImage3, defaultSalesPrice;

  ProductListModel(
      {required this.productName,
      required this.defaultSalesPrice,
      required this.productImage,
      required this.defaultUnitName,
      required this.productImage3,
      required this.productImage2,
      required this.id});

  factory ProductListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductListModel(
      defaultUnitName: json['DefaultUnitName'],
      defaultSalesPrice: json['DefaultSalesPrice'].toString(),
      productName: json['ProductName'],
      id: json['id'],
      productImage: json['ProductImage'] ?? '',
      productImage2: json['ProductImage2'] ?? '',
      productImage3: json['ProductImage3'] ?? '',
    );
  }
}

class ProductData {
  static int catID = 1;
  static String productID = '';
}

///orgg
