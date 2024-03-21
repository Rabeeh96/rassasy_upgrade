import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/new_design/dashboard/customer/detail/select_tax_new.dart';
import '../../../global/textfield_decoration.dart';
import 'package:rassasy_new/global/global.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'detail/select_route_new.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class AddCustomerNew extends StatefulWidget {
  @override
  State<AddCustomerNew> createState() => _AddCustomerNewState();
}

class _AddCustomerNewState extends State<AddCustomerNew> {
  String dropdownvalue = 'DR';
  var items = [
    'DR',
    'CR',
  ];

  TextEditingController searchController = TextEditingController();
  String asterisk = '*';
  Color red = Colors.red;
  String dropdownvalue1 = 'Item 1';
  var itemsList = categoryLists.length;
  var netWorkProblem = true;
  bool isLoading = false;
  bool isTreatment = false;
  bool isCategory = false;
  var pageNumber = 1;
  var firstTime = 1;

  var treatmentID = "";
  var priceCategoryId = 1;
  var routeId = 1;
  String categoryName = "Price Category1";
  String priceCategoryName = "Standard";
  String routeName = "Primary Route";
  String _date = "2022-07-21";
  String as_on_date_api = "2022-07-21";
  TextEditingController customerNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController balanceController = TextEditingController()
    ..text = "0.00";
  TextEditingController dateController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController workPhoneController = TextEditingController();
  TextEditingController webUrlController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController creditPeriodController = TextEditingController()
    ..text = "0";
  TextEditingController priceCategoryController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController vatNumberController = TextEditingController();
  TextEditingController creditLimitController = TextEditingController()
    ..text = "0.00";
  TextEditingController routesController = TextEditingController();
  TextEditingController crNoController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accNameController = TextEditingController();
  TextEditingController accNoController = TextEditingController();
  TextEditingController ibanIfscController = TextEditingController();
  TextEditingController treatmentController = TextEditingController();

  FocusNode customerNameFcNode = FocusNode();
  FocusNode treatmentNode = FocusNode();
  FocusNode displayFcNode = FocusNode();
  FocusNode balanceFcNode = FocusNode();
  FocusNode dateFcNode = FocusNode();
  FocusNode emailFcNode = FocusNode();
  FocusNode workPhoneFcNode = FocusNode();
  FocusNode webUrlFcNode = FocusNode();
  FocusNode addressFcNode = FocusNode();
  FocusNode creditLimitFcNode = FocusNode();
  FocusNode priceCategoryFcNode = FocusNode();
  FocusNode panNoFcNode = FocusNode();
  FocusNode vatNoFcNode = FocusNode();
  FocusNode creditPeriodFcNode = FocusNode();
  FocusNode routesFcNode = FocusNode();
  FocusNode crNoFcNode = FocusNode();
  FocusNode bankNameNode = FocusNode();
  FocusNode acc_nameFcNode = FocusNode();
  FocusNode acc_NoFcNode = FocusNode();
  FocusNode iban_ifsc_FcNode = FocusNode();
  bool isCustomer = false;
  bool isEdit = false;
  bool networkConnection = true;

  bool imageSelect = false;
  File? imgFile;
  final imgPicker = ImagePicker();

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      imageSelect = true;
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      imageSelect = true;
    });
    Navigator.of(context).pop();
  }

  Widget displayImage() {
    return GestureDetector(
      onTap: () {
        showOptionsDialog(context);
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
                  Padding(padding: EdgeInsets.all(10)),
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

  loadImage(image) async {
    try {
      final file = await getFileFromNetworkImage(image);
      setState(() {
        imageSelect = true;
        imgFile = file;
        print("Image file load image");
        print(imgFile);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerList();
    getPriceCategoryList();
    var date = DateTime.now();
    final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    as_on_date_api = formatter1.format(date);

    DateTime dt = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(dt);
    _date = '$formatted';

    defaultValues();
  }

  defaultValues() {
    priceCategoryController..text = 'Standard';
    routesController..text = 'Primary Route';
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
              'customer'.tr,
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
          ? customerDetailPage()
          : noNetworkConnectionPage(),
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget customerDetailPage() {
    return Row(
      children: [
        isCustomer == false ? refreshCustomer() : customerAddPage(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF8F8F8)),
          ),
          width: MediaQuery.of(context).size.width / 3,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 11,
                color: const Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: searchController,
                      onChanged: (text) {
                        _searchData(text);
                      },
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();
                              customersLists.clear();
                              pageNumber = 1;
                              firstTime = 1;
                              getCustomerList();
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
                          fillColor: const Color(0xffffffff))),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.4,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: customersLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key('${customersLists[index]}'),
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
                          bool hasPermission =
                              await checkingPerm("Customerdelete");

                          if (hasPermission) {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    'delete_msg'.tr,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  content: Text('msg4'.tr,
                                      style: TextStyle(fontSize: 14)),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => {
                                              Data.custID =
                                                  customersLists[index].id,
                                              Navigator.of(context).pop(),
                                              deleteAnItem()
                                            },
                                        child: Text(
                                          'dlt'.tr,
                                          style: TextStyle(color: Colors.red),
                                        )),
                                    TextButton(
                                      onPressed: () =>
                                          {Navigator.of(context).pop()},
                                      child:
                                          Text('cancel'.tr, style: TextStyle()),
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
                        direction: customersLists.length > 1
                            ? DismissDirection.startToEnd
                            : DismissDirection.none,
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.startToEnd) {
                            print('Remove item');
                          } else {
                            print("");
                          }

                          setState(() {
                            customersLists.removeAt(index);
                          });
                        },
                        child: Card(
                          child: ListTile(
                            onTap: () async {
                              var perm = await checkingPerm("Customeredit");
                              print(perm);
                              if (perm) {
                                isEdit = true;
                                setState(() {
                                  Data.custID = customersLists[index].id;
                                  getSingleView(customersLists[index].id);
                                  isCustomer = true;
                                });
                              } else {
                                dialogBoxPermissionDenied(context);
                              }
                            },
                            leading: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: customersLists[index]
                                          .partyImage ==
                                      ''
                                  ? NetworkImage(
                                      'https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                  : NetworkImage(BaseUrl.imageURL +
                                      customersLists[index].partyImage),
                            ),
                            title: Text(
                              customersLists[index].partyName == ""
                                  ? customersLists[index].customerName
                                  : customersLists[index].partyName,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
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
              print("something");
              getCustomerList();
              print("111");
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

  clearData() {
    addressController.clear();
    customerNameController.clear();
    emailController.clear();
    workPhoneController.clear();
    balanceController.clear();
    displayNameController.clear();
    priceCategoryController.clear();
    panNoController.clear();
    routesController.clear();
    crNoController.clear();
    bankNameController.clear();
    accNameController.clear();
    accNoController.clear();
    ibanIfscController.clear();
    webUrlController.clear();
    dateController.clear();
    treatmentController.clear();
    creditPeriodController.text = "0";
    creditLimitController.text = "0.00";
  }

  Widget bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: isCustomer == true
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
                                isCustomer = false;
                                defaultValues();
                                imageSelect = false;
                              });
                              clearData();
                              defaultValues();

                              isEdit = false;
                            }),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 16,
                        height: MediaQuery.of(context).size.height / 12,
                        child: IconButton(
                            icon: SvgPicture.asset('assets/svg/add1.svg'),
                            onPressed: () {
                              print(addressController.text);

                              if (customerNameController.text.trim() == '' ||
                                  customerNameController.text == '' &&
                                      creditLimitController.text == '' &&
                                      treatmentController.text == '' &&
                                      dateController.text == '' &&
                                      creditPeriodController.text == '') {
                                dialogBox(
                                    context, "Please fill mandatory fields");
                              } else {
                                var taxValidation = vatNumberValidation(
                                    vatNumberController.text, treatmentID);
                                print(taxValidation);

                                if (taxValidation) {
                                  if (isEdit == false) {
                                    if (createPermission) {
                                      start(context);
                                      createCustomer();
                                    } else {
                                      dialogBoxPermissionDenied(context);
                                    }
                                  } else {
                                    start(context);
                                    editCustomer();
                                  }
                                } else {
                                  dialogBox(context,
                                      "Invalid Tax number. Please check and enter a valid VAT number.");
                                }
                              }
                            }),
                      )
                    ],
                  ),
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
                                isEdit = false;
                                defaultValues();
                              });
                              clearData();

                              imageSelect = false;

                              defaultValues();
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

  vatNumberValidation(String taxNumber, String treatment) {
    if (treatment != '0') {
      return true;
    }

    if (taxNumber.length == 15) {
      if (taxNumber[0] == "3" && taxNumber[14] == "3") {
        return true;
      } else {
        return false;
      }
    } else {
      print("abc");
      return false;
    }
  }

  gstValidation(String str) {
    // if (str.length == 15) {
    //   var num = '';
    //   num = str[0] + str[1];
    //   if (num == CustomerData.stateCode) {
    //     var num1 = isNumericUsing_tryParse(str[12]);
    //     if (num1) {
    //       if (str[12] != '0') {
    //         if (str[13] == 'Z') {
    //           print("1");
    //           return true;
    //         } else {
    //           print("2");
    //           return false;
    //         }
    //       } else {
    //         print("3");
    //         return false;
    //       }
    //     } else {
    //       print("4");
    //       return false;
    //     }
    //   } else {
    //     print("5");
    //     return false;
    //   }
    // } else {
    //   print("6");
    //   return false;
    // }
  }

  Widget customerAddPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: isEdit == true
                ? Text(
                    'Edit Customer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  )
                : Text(
                    'Add Customer',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
          ),
          customerAndDisplayName(),
          balanceAndDate(),
          personalDetails(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  shrinkWrap: true,
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 20),
                  ),
                  creditPeriod(),
                  priceCategory(),
                  panNumberField(),
                  creditLimitField(),
                  routeField(),
                  crNumberField(),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 9,
                          child: const Text(
                            "Treatment:",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 5.5,
                          child: TextField(
                            readOnly: true,
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectTaxNew()),
                              );

                              if (result != null) {
                                treatmentController.text = result[1];
                                treatmentID = result[0];
                              }

                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // bool? gstType=prefs.getBool("check_GST");
                              // bool? vatType=prefs.getBool("checkVat");
                              // if(taxType==true){
                              //   var result = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => SelectTaxNew()),
                              //   );
                              //   if (result != null) {
                              //     setState(() {
                              //       treatmentController.text = result;
                              //     });
                              //   } else {}
                              //
                              //   vatType==false;
                              // }else if(taxType==false){
                              //   gstType==false;
                              //   var result = await Navigator.push(
                              //     context,
                              //     MaterialPageRoute(builder: (context) => SelectTaxNew()),
                              //   );
                              //   if (result != null) {
                              //     setState(() {
                              //       treatmentController.text = result;
                              //     });
                              //   } else {}
                              // }else{
                              //   dialogBox(context, "No Treatment");
                              //
                              // }
                            },
                            style: customisedStyle(
                                context, Colors.black, FontWeight.normal, 12.0),
                            controller: treatmentController,
                            focusNode: treatmentNode,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(bankNameNode);
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration:
                                TextFieldDecoration.rectangleTextFieldIcon(
                                    hintTextStr: ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 9,
                        child: const Text(
                          "Tax No:",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 5.5,
                        child: TextField(
                          style: TextStyle(fontSize: 12),
                          controller: vatNumberController,
                          focusNode: vatNoFcNode,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(panNoFcNode);
                          },
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          decoration: TextFieldDecoration.rectangleTextField(
                              hintTextStr: ''),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bank Details",
                    style: TextStyle(fontSize: 19),
                  ),
                  bankNameField(),
                  accountNameField(),
                  accountNumberField(),
                  ibanIfscCodeField(),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget refreshCustomer() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: MediaQuery.of(context).size.height / 2,
            child: ListView(
              children: [
                SvgPicture.asset('assets/svg/refreshcustomer.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 10, bottom: 10),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 12,
                    child: Text(
                      'Select a customer',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 12,
                    child: Text(
                      'or'.tr,
                      style: TextStyle(fontSize: 20, color: Color(0xff949494)),
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
              isCustomer = true;
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
              const Text(
                'Add Customer',
                style: const TextStyle(color: Color(0xffffffff)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customerAndDisplayName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 8,
                child: const Text(
                  "Customer name:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 7,
                child: TextField(
                  style: TextStyle(fontSize: 12),
                  onChanged: (content) {
                    displayNameController.text = customerNameController.text;
                  },
                  controller: customerNameController,
                  focusNode: customerNameFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(displayFcNode);
                  },
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: TextFieldDecoration.customerMandatoryField(
                      hintTextStr: ''),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 8,
                child: const Text(
                  "Display name:",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 5,
                child: TextField(
                  style: TextStyle(fontSize: 12),
                  onTap: () {},
                  controller: displayNameController,
                  focusNode: displayFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(balanceFcNode);
                  },
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration:
                      TextFieldDecoration.rectangleTextField(hintTextStr: ''),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget balanceAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 8,
              child: const Text(
                "Balance:",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 11,
                    child: TextField(
                      style: TextStyle(fontSize: 12),
                      controller: balanceController,
                      focusNode: balanceFcNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(dateFcNode);
                      },
                      keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,8}')),
                      ],
                      textCapitalization: TextCapitalization.words,
                      decoration: TextFieldDecoration.customerMandatoryField(
                          hintTextStr: ''),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 16,
                    width: MediaQuery.of(context).size.width / 20,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Color(0xffD9D9D9))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: DropdownButton(
                        // Initial Value
                        value: dropdownvalue,
                        underline: Container(color: Colors.transparent),

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: items.map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 8,
              child: const Text(
                "As on:",
                style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 5,
              child: TextField(
                style: TextStyle(fontSize: 12),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                controller: dateController,
                focusNode: dateFcNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(emailFcNode);
                },
                keyboardType: TextInputType.text,
                decoration:
                    TextFieldDecoration.customerDateField(hintTextStr: _date),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget creditPeriod() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "Credit Period:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: creditPeriodController,
              focusNode: creditPeriodFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(priceCategoryFcNode);
              },
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
              ],
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget priceCategory() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "Price Category:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextField(
                    style: TextStyle(fontSize: 12),
                    onTap: () {
                      setState(() {
                        isCategory = true;
                      });
                    },
                    readOnly: true,
                    controller: priceCategoryController,
                    focusNode: priceCategoryFcNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(panNoFcNode);
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: isCategory == false
                            ? IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isCategory = true;
                                  });
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isCategory = false;
                                  });
                                }),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffC9C9C9))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffC9C9C9))),
                        disabledBorder: const OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Color(0xffC9C9C9))),
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, right: 10, bottom: 10),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color(0xff000000), fontSize: 14),
                        hintText: priceCategoryName,
                        fillColor: const Color(0xffffffff))),
                isCategory == true
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: categoryLists.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  priceCategoryId = categoryLists[index].catId;
                                  priceCategoryController.text =
                                      categoryLists[index].priceCategoryName;

                                  isCategory = false;
                                });
                              },
                              title: Text(
                                categoryLists[index].priceCategoryName,
                              ),
                            ),
                          );
                        })
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget panNumberField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "PAN No:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: panNoController,
              focusNode: panNoFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(creditLimitFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget creditLimitField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "Credit Limit:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: creditLimitController,
              focusNode: creditLimitFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(routesFcNode);
              },
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
              ],
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget routeField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "Routes:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: customisedStyle(
                  context, Colors.black, FontWeight.normal, 12.0),
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectRouteNew()),
                );

                print(result);

                if (result != null) {
                  setState(() {
                    routesController.text = result;
                  });
                } else {}
              },
              controller: routesController,
              focusNode: routesFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(crNoFcNode);
              },
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextFieldIcon(
                  hintTextStr: routeName),
            ),
          ),
        ],
      ),
    );
  }

  Widget crNumberField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 9,
            child: const Text(
              "CR No:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: crNoController,
              focusNode: crNoFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(treatmentNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget bankNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 8.5,
            child: const Text(
              "Bank Name:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: bankNameController,
              focusNode: bankNameNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(acc_nameFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget accountNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 8.5,
            child: const Text(
              "Account Name:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: accNameController,
              focusNode: acc_nameFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(acc_NoFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget accountNumberField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 8.5,
            child: const Text(
              "Account No:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: accNoController,
              focusNode: acc_NoFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(iban_ifsc_FcNode);
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget ibanIfscCodeField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 8.5,
            child: const Text(
              "IBAN/IFSC Code:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),

              controller: ibanIfscController,
              focusNode: iban_ifsc_FcNode,
              // onEditingComplete: () {
              //   FocusScope.of(context)
              //       .requestFocus(iban_ifsc_FcNode);
              // },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  // Widget photoAddField() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         color: const Color(0xffffffff),
  //         border: Border.all(
  //           color: const Color(0xffC5C5C5),
  //           width: 1,
  //         ),
  //         borderRadius: const BorderRadius.all(const Radius.circular(2))),
  //     height: MediaQuery.of(context).size.height / 4.8,
  //     width: MediaQuery.of(context).size.width / 11,
  //   );
  // }
  //
  //

  Widget photoWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xffD5D5D5)),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(2))),
        height: MediaQuery.of(context).size.height / 5,
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
    );
  }

  Widget emailField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 11,
            child: const Text(
              "Email:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: emailController,
              focusNode: emailFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(workPhoneFcNode);
              },
              keyboardType: TextInputType.emailAddress,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget workPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 11,
            child: const Text(
              "Work Phone:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: workPhoneController,
              focusNode: workPhoneFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(webUrlFcNode);
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget websiteField() {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 11,
            child: const Text(
              "Website Url:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: webUrlController,
              focusNode: webUrlFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(addressFcNode);
              },
              keyboardType: TextInputType.url,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 14,
            child: const Text(
              "Address:",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 5.5,
            child: TextField(
              style: TextStyle(fontSize: 12),
              controller: addressController,
              focusNode: addressFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(creditPeriodFcNode);
              },
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
              textCapitalization: TextCapitalization.words,
              decoration:
                  TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget personalDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 10),
      child: Container(
        height: MediaQuery.of(context).size.height / 3.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 8,
              ),
              child: Text(
                'Photo',
                style: TextStyle(fontSize: 15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                photoWidget(),
                Column(
                  children: [
                    emailField(),
                    workPhoneField(),
                    websiteField(),
                  ],
                ),
                addressField(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool createPermission = true;
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
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        createPermission = prefs.getBool("Customersave") ?? true;
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/customer-list/';
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
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          stop();

          setState(() {
            networkConnection = true;
            customersLists.clear();
            for (Map user in responseJson) {
              customersLists.add(CustomerModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          networkConnection = true;
          stop();
        } else {
          stop();
        }
      } catch (e) {
        stop();
        dialogBox(context, "Check your network connection");
        print(e.toString());
      }
    }
  }

  ///customer create

  createCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        double creditLimit = 1;
        double openingBalance = 0;
        print('2');
        if (creditLimitController.text == '') {
          creditLimit = 1;
        } else {
          creditLimit = double.parse(creditLimitController.text);
        }

        if (balanceController.text == '') {
          openingBalance = 0;
        } else {
          openingBalance = double.parse(balanceController.text);
        }

        String baseUrl = BaseUrl.baseUrl;

        final url = '$baseUrl/posholds/customer-create/';
        print(url);
        var headers = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));
        print(url);
        print(
            "${as_on_date_api}......................................................");
        request.fields.addAll({
          "BranchID": branchID.toString(),
          "CreatedUserID": userID.toString(),
          "CompanyID": companyID.toString(),
          "Email": emailController.text,
          "Address": addressController.text,
          "CustomerName": customerNameController.text,
          "DisplayName": displayNameController.text,
          "OpeningBalance": openingBalance.toString(),
          "CrOrDr": dropdownvalue,
          "as_on_date": as_on_date_api,
          "WorkPhone": workPhoneController.text,
          "WebURL": webUrlController.text,
          "CreditPeriod": creditPeriodController.text,
          "PriceCategoryID": priceCategoryId.toString(),
          "PanNumber": panNoController.text,
          "CreditLimit": creditLimit.toString(),
          "RouteID": routeId.toString(),
          "CRNo": crNoController.text,
          "BankName": bankNameController.text,
          "AccountName": accNameController.text,
          "AccountNo": accNoController.text,
          "IBANOrIFSCCode1": ibanIfscController.text,
          "VATNumber": vatNumberController.text,
          "VAT_Treatment": treatmentID
        });

        if (imageSelect) {
          request.files.add(
              await http.MultipartFile.fromPath('PartyImage', imgFile!.path));
        }

        request.headers.addAll(headers);
        //  http.StreamedResponse response = await request.send();
        final streamResponse = await request.send();
        final response = await http.Response.fromStream(streamResponse);
        print(response.headers);
        print(response.body);
        print(response.statusCode);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        if (status == 6000) {
          setState(() {
            clearData();
            imageSelect = false;

            customersLists.clear();
            stop();
            isCustomer = false;
            defaultValues();
            print("datess createe");
            print(as_on_date_api);
            print(_date);
            getCustomerList();
            print('7');
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);

          stop();
        }
      } catch (e) {
        dialogBox(context, "Some thing went wrong");
        stop();
      }
    }
  }

  editCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        String baseUrl = BaseUrl.baseUrl;

        var customerId = Data.custID;

        final url = '$baseUrl/posholds/edit/customer/$customerId/';

        var headers = {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        };
        var request = http.MultipartRequest('POST', Uri.parse(url));

        request.fields.addAll({
          "BranchID": branchID.toString(),
          "CreatedUserID": userID.toString(),
          "CompanyID": companyID.toString(),
          "Email": emailController.text,
          "Address": addressController.text,
          "CustomerName": customerNameController.text,
          "DisplayName": displayNameController.text,
          "OpeningBalance": balanceController.text,
          "CrOrDr": dropdownvalue,
          "as_on_date": as_on_date_api,
          "WorkPhone": workPhoneController.text,
          "WebURL": webUrlController.text,
          "CreditPeriod": creditPeriodController.text,
          "PriceCategoryID": priceCategoryId.toString(),
          "PanNumber": panNoController.text,
          "CreditLimit": creditLimitController.text,
          "RouteID": routeId.toString(),
          "CRNo": crNoController.text,
          "BankName": bankNameController.text,
          "AccountName": accNameController.text,
          "AccountNo": accNoController.text,
          "IBANOrIFSCCode1": ibanIfscController.text,
          "VATNumber": vatNumberController.text,
          "VAT_Treatment": treatmentID
        });

        if (imageSelect) {
          request.files.add(
              await http.MultipartFile.fromPath('PartyImage', imgFile!.path));
        }
        print("image select");
        print(imageSelect);
        print(imgFile);

        request.headers.addAll(headers);
        final streamResponse = await request.send();
        final response = await http.Response.fromStream(streamResponse);
        print(response.headers);
        print(response.body);
        print(response.statusCode);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        if (status == 6000) {
          setState(() {
            clearData();

            customersLists.clear();
            defaultValues();
            stop();
            isEdit = false;
            isCustomer = false;
            getCustomerList();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        dialogBox(context, "Some thing went wrong");
        stop();
      }
    }
  }

  Future<Null> getSingleView(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;
        bool? gstType = prefs.getBool("check_GST");
        bool? vatType = prefs.getBool("checkVat");
        final url = '$baseUrl/posholds/single/customer/$id/';
        print(url);

        Map data = {
          "CompanyID": companyID,
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

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          stop();
          setState(() {
            imageSelect = false;
            addressController.text = responseJson['Address1'];
            as_on_date_api = responseJson['as_on_date'];
            customerNameController.text = responseJson['FirstName'] ?? '';
            webUrlController.text = responseJson['WebURL'] ?? '';
            creditPeriodController.text =
                responseJson['CreditPeriod'].toString();
            panNoController.text = responseJson['PanNumber'] ?? '';
            bankNameController.text = responseJson['BankName1'] ?? '';
            accNameController.text = responseJson['AccountName1'] ?? '';
            accNoController.text = responseJson['AccountNo1'] ?? '';
            ibanIfscController.text = responseJson['IBANOrIFSCCode1'];
            priceCategoryController.text = responseJson['PriceCategoryName'];
            workPhoneController.text = responseJson['PhoneNumber'] ?? '';
            emailController.text = responseJson['Email'] ?? '';
            crNoController.text = responseJson['CRNo'] ?? '';
            displayNameController.text = responseJson['DisplayName'] ?? '';
            balanceController.text =
                roundStringWith(responseJson['OpeningBalance']) ?? '';
            routesController.text = responseJson['RouteName'] ?? '';
            creditLimitController.text =
                roundStringWith(responseJson['CreditLimit']) ?? '';
            priceCategoryId = responseJson['PriceCategoryID'];
            routeId = responseJson['RouteID'];

            if (gstType!) {
              treatmentController.text =
                  findGstTreatment(responseJson['GST_Treatment']);
            }

            if (vatType!) {
              treatmentController.text =
                  findVatTreatment(responseJson['VAT_Treatment']);
            }

            var partyImage = responseJson["PartyImage"] ?? '';

            if (partyImage == '') {
            } else {
              var imgData = BaseUrl.imageURL + partyImage;
              print('---imageData-----$imgData');

              if (imgData == '') {
              } else {
                loadImage(imgData);
              }
            }
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
        dialogBox(context, "Some thing went wrong");
        print(e.toString());
        stop();
      }
    }
  }

  Future<Null> deleteAnItem() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        var custId = Data.custID;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;

        String baseUrl = BaseUrl.baseUrl;
        final String url = '$baseUrl/posholds/delete/customer/$custId/';
        print(url);

        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "BranchID": 1
        };
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
            customersLists.clear();
            clearData();
            isEdit = false;
            stop();
            getCustomerList();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          print(dialogBox(context, msg));
        } else {}
      } catch (e) {
        dialogBox(context, "Some thing went wrong ${e.toString()}");
        stop();
      }
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    // DatePicker.showDatePicker(context,
    //     // theme: const DatePickerTheme(
    //     //   containerHeight: 200.0,
    //     // ),
    //     showTitleActions: true,
    //     minTime: DateTime(2000, 01, 01),
    //     maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
    //   print('confirm $date');
    //   _date = '${date.year} - ${date.month} - ${date.day}';
    //
    //   setState(() {
    //     final DateFormat formatter = DateFormat('dd-MM-yyyy');
    //     final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    //     final String formatted = formatter.format(date);
    //     print(formatted);
    //     _date = '$formatted';
    //
    //     as_on_date_api = formatter1.format(date);
    //     dateController.text = _date;
    //   });
    // }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future _searchData(String searchVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userID = prefs.getInt('user_id') ?? 0;
    var accessToken = prefs.getString('access') ?? '';
    var companyID = prefs.getString('companyID') ?? 0;
    var branchID = prefs.getInt('branchID') ?? 1;

    if (searchVal == '') {
      pageNumber = 1;
      customersLists.clear();
      firstTime = 1;
      getCustomerList();
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(
            context, "Unable to connect. Please Check Internet Connection");
      } else {
        try {
          Map data = {
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "BranchID": BaseUrl.branchID,
            "PriceRounding": 2,
            "product_name": searchVal,
            "length": searchVal.length,
            "PartyType": "customer"
          };
          String baseUrl = BaseUrl.baseUrl;
          final String url = "$baseUrl/parties/search/party-list/";
          print(data);
          print(url);
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
    }
  }

  Future<Null> getPriceCategoryList() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your network connection");
      stop();
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        print('1');
        String baseUrl = BaseUrl.baseUrl;

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        final url = '$baseUrl/priceCategories/priceCategories/';
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
            categoryLists.clear();
            stop();
            for (Map user in responseJson) {
              categoryLists.add(CategoryModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        } else {
          stop();
        }
      } catch (e) {
        print(dialogBox(context, "Check your network connection"));
        stop();
      }
    }
  }

  findGstTreatment(treatment) {
    if (treatment == "0") {
      return "Registered Business - Regular";
    } else if (treatment == "1") {
      return "Registered Business - Composition";
    } else if (treatment == "2") {
      return "Unregistered Business";
    } else if (treatment == "3") {
      return "Consumer";
    } else if (treatment == "4") {
      return "Overseas";
    } else if (treatment == "5") {
      return "Special Economic Zone";
    } else {
      return "Deemed Export";
    }
  }

  findVatTreatment(String id) {
    if (id == "0") {
      return "Business to Business(B2B)";
    } else if (id == "1") {
      return "Business to Customer(B2C)";
    } else if (id == "2") {
      return "Export";
    } else {
      return "";
    }
  }
}

List<CustomerModel> customersLists = [];

class CustomerModel {
  String firstName,
      lastName,
      customerName,
      partyName,
      id,
      phone,
      email_api,
      address_api,
      partyImage;

  CustomerModel(
      {required this.firstName,
      required this.phone,
      required this.lastName,
      required this.customerName,
      required this.id,
      required this.partyName,
      required this.email_api,
      required this.partyImage,
      required this.address_api});

  factory CustomerModel.fromJson(Map<dynamic, dynamic> json) {
    return CustomerModel(
        lastName: json['LastName'] ?? '',
        phone: json['PhoneNumber'] ?? '',
        firstName: json['FirstName'] ?? '',
        partyImage: json['PartyImage'] ?? '',
        customerName: json['CustomerName'] ?? '',
        partyName: json['PartyName'] ?? '',
        id: json['id'],
        email_api: json['Email'] ?? '',
        address_api: json['Address1'] ?? '');
  }
}

List<CategoryModel> categoryLists = [];

class CategoryModel {
  String priceCategoryName, id;
  int catId;

  CategoryModel({
    required this.priceCategoryName,
    required this.id,
    required this.catId,
  });

  factory CategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return CategoryModel(
        priceCategoryName: json['PriceCategoryName'] ?? '',
        id: json['id'],
        catId: json['PriceCategoryID']);
  }
}

class Data {
  static String custID = '';
  // static int routeID = 0;
  static int priceCatId = 0;
}
