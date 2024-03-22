

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/new_tax/RTaxCategoryController.dart';
 

class TaxCategory extends StatefulWidget {
  @override
  State<TaxCategory> createState() => _TaxCategoryState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _TaxCategoryState extends State<TaxCategory> {
  final RAddTaxControllerPage taxController = Get.put(RAddTaxControllerPage());

  String? dropdownValue = 'General';

  String? method="";

  @override
  void initState() {
    super.initState();

  //  taxController.isDataLoading.value = true;
    method= "CREATE";
    taxController.clear();
    taxController.getTaxCategoryFullList();
    // print("Method Method    $method");
    // if (method != "EDIT") {
    //   taxController.getTaxCategoryFullList();
    //   taxController.TaxTypeID.value = 1;
    // } else {
    //
    // }
    //  taxController.loadData();

  }


  loadViewDataOfTaxCategoryItem(String? id) async {


    var result = await taxController.getViewData(id: id);
    if (result[0] == null) {
      taxController.isDataLoading.value=false;
      var responseData = result[1];
      taxController.nameController.text = responseData["TaxName"];
      taxController.generalTaxController.text = responseData["Tax"].toString();

      dropdownValue = responseData["TaxType"]["TaxTypeName"];
      var company = "VAT";
      if (dropdownValue == 'General') {
        if (company == "VAT") {
          taxController.TaxTypeID.value = 1;
        } else if (company == "GST") {
          taxController.TaxTypeID.value = 2;
        }
      } else if (dropdownValue == 'Excise') {
        taxController.TaxTypeID.value = 8;
      } else {
        taxController.TaxTypeID.value = 6;
      }

      taxController.breakingPointController.text = responseData["BPValue"].toString();
      taxController.IsAmountTaxBefore.value = responseData["IsAmountTaxBefore"];
      if (responseData["IsAmountTaxBefore"] == true) {
        taxController.selectPercentageorAmount.value = 1;
      } else if (responseData["IsAmountTaxBefore"] == false) {
        taxController.selectPercentageorAmount.value = 0;
      }
      taxController.IsAmountTaxAfter.value = responseData["IsAmountTaxAfter"];
      if (responseData["IsAmountTaxAfter"] == true) {
        taxController.selectPercentageorAmount1.value = 1;
      } else if (responseData["IsAmountTaxAfter"] == false) {
        taxController.selectPercentageorAmount1.value = 0;
      }
      taxController.taxBeforeController.text = responseData["TaxBefore"].toString();
      taxController.taxAfterController.text = responseData["TaxAfter"].toString();
      taxController.update();

    }
  }
  
  @override
  Widget build(BuildContext context) {
   

    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xfff8f8f8),
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Tax',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            backgroundColor: Colors.grey[300],

        ),
        body: Obx(() {
          if (taxController.isDataLoading.value) {
            return const Center(child:CircularProgressIndicator());
          } else if(taxController.isError.value) {

            return const Center(
              child: Text('Error occured while loading data'),
            );
          } else {
            return Row(children: <Widget>[
              Form(
                key: _formKey,
                child: Expanded(
                  flex: 4,
                  child: ListView(
                   // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text("Add Tax Category",
                              style: customisedStyle(context,
                                  const Color(0xff000000), FontWeight.w400, 17.0)),
                          SizedBox(
                            height: mHeight * .05,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Name",
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w400,
                                        12.0)),
                                SizedBox(
                                  height: mHeight * .01,
                                ),
                                GetBuilder<RAddTaxControllerPage>(
                                init:RAddTaxControllerPage(),
                                  builder: (controller) {
                                    return customisedTextFormField(
                                        initialValue:
                                        controller.nameController.text,
                                        onChanged: (value) {
                                          controller.nameController.text =
                                              value;
                                        },
                                        controller: controller.nameController,
                                        readOnly: false,
                                        labelText: "",
                                        validator: (value) {
                                          if (value == null ||
                                              value
                                                  .trim()
                                                  .isEmpty) {
                                            return 'Please enter name';
                                          }
                                          return null;
                                        },
                                        onSubmitted: (value) {
                                          controller.nameController.text =
                                              value;
                                        },
                                        focusnode: null,
                                        suffixIcon: const Icon(null),
                                        maxWidth: mWidth * .25);
                                  })
                              ],
                            ),
                          ),
                          SizedBox(
                            height: mHeight * .02,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Type",
                                  style: customisedStyle(
                                      context,
                                      const Color(0xff000000),
                                      FontWeight.w400,
                                      12.0)),
                              SizedBox(
                                height: mHeight * .015,
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  // itemHeight: 53,
                                  // Adjust this value to decrease the height
                                  value: dropdownValue,
                                  iconSize: 0,
                                  // Remove the icon
                                  elevation: 5,
                                  style: const TextStyle(color: Colors.deepPurple),
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValue = value;
                                      var company = "VAT";

                                      if (dropdownValue == 'General') {
                                        taxController.breakingPointController
                                            .clear();
                                        taxController.taxBeforeController.clear();
                                        taxController.taxAfterController.clear();
                                        if (company == "VAT") {
                                          taxController.TaxTypeID.value = 1;
                                        } else if (company == "GST") {
                                          taxController.TaxTypeID.value = 2;
                                        }
                                      } else if (dropdownValue == 'Excise') {
                                        taxController.TaxTypeID.value = 8;
                                        taxController.generalTaxController.clear();
                                      } else {
                                        taxController.TaxTypeID.value = 6;
                                      }
                                    });
                                  },
                                  items: <String>['General', 'Excise']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFFDFDFD),
                                            border: Border.all(
                                              color: const Color(0xFFE7E7E7),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        height: mHeight * .1,
                                        width: mWidth * .25,
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              value,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                            // SvgPicture.asset(
                                            //   'assets/ViknBooksPro/StockManagementReport/svg/dropdown.svg',
                                            //   height: mHeight * .009,
                                            //   color: Colors.black,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: mHeight * .02,
                          ),
                          Visibility(
                            visible: dropdownValue == "Excise",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: mHeight * 0.1,
                                  // width: mWidth * .3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Breaking Point (BP)",
                                          style: customisedStyle(
                                            context,
                                            Colors.black,
                                            FontWeight.w400,
                                            12.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                customisedTextFormField(
                                  initialValue:
                                      taxController.breakingPointController.text,
                                  onChanged: (value) {
                                    taxController.breakingPointController.text =
                                        value;
                                  },
                                  readOnly: false,
                                  labelText: "",
                                  controller:
                                      taxController.breakingPointController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter value';
                                    }
                                    return null;
                                  },
                                  onSubmitted: (value) {
                                    taxController.breakingPointController.text =
                                        value;
                                  },
                                  focusnode: null,
                                  keyboardtype: TextInputType.number,
                                  suffixIcon: const Icon(null),
                                  maxWidth: mWidth * .1,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: dropdownValue == "Excise",
                            child: SizedBox(
                              height: mHeight * .025,
                            ),
                          ),
                          Visibility(
                            visible: dropdownValue == "General",
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Tax",
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w400,
                                        12.0)),
                                SizedBox(
                                  height: mHeight * .01,
                                ),
                                customisedTextFormField(
                                    initialValue:
                                        taxController.generalTaxController.text,
                                    onChanged: (value) {
                                      taxController.generalTaxController.text =
                                          value;
                                    },
                                    readOnly: false,
                                    labelText: "",
                                    controller: taxController.generalTaxController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter tax percentage';
                                      }
                                      return null;
                                    },
                                    onSubmitted: null,
                                    focusnode: null,
                                    keyboardtype: TextInputType.number,
                                    suffixIcon: const Icon(null),
                                    maxWidth: mWidth * .25),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: dropdownValue == "Excise",
                        child: Container(
                        //  height: mHeight * .25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Less than BP",
                                    style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w500,
                                      12.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: mHeight * .025,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 0.0, right: 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(

                                          width: mWidth * .25,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // border: Border.all(color:  Color(0xFFE7E7E7)
                                            // )
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: mWidth * .01,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  taxController.selectPercentageorAmount.value = 0;
                                                  taxController.IsAmountTaxBefore.value = false;

                                                  print("controller.selectPercentageorAmount.value  ${taxController.selectPercentageorAmount.value}");
                                                  print("controller.IsAmountTaxBefore.value  ${taxController.IsAmountTaxBefore.value}");

                                                },
                                                child: Obx(
                                                  () => Row(
                                                    children: [
                                                      taxController.selectPercentageorAmount
                                                                  .value ==
                                                              0
                                                          ? Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 25,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .4),
                                                            )
                                                          : Icon(
                                                        Icons
                                                                  .circle_outlined,
                                                              size: 25,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .4),
                                                            ),
                                                      SizedBox(
                                                        width: mWidth * .005,
                                                      ),
                                                      Text("Percentage",
                                                          style:
                                                              customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff000000),
                                                                  FontWeight
                                                                      .w400,
                                                                  12.0)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: mWidth * .04,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  taxController
                                                      .selectPercentageorAmount
                                                      .value = 1;
                                                  taxController.IsAmountTaxBefore
                                                      .value = true;
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Obx(
                                                    () => Row(
                                                      children: [
                                                        taxController.selectPercentageorAmount
                                                                    .value ==
                                                                1
                                                            ? Icon(
                                                          Icons.check_circle,
                                                                size: 25,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .4),
                                                              )
                                                            : Icon(
                                                          Icons
                                                              .circle_outlined,
                                                                size: 25,
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                        .4),
                                                              ),
                                                        SizedBox(
                                                          width: mWidth * .005,
                                                        ),
                                                        Text("Amount",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    const Color(
                                                                        0xff000000),
                                                                    FontWeight
                                                                        .w400,
                                                                    12.0)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: mHeight * .022,
                                  ),
                                  Obx(() {
                                    if (taxController
                                            .selectPercentageorAmount.value ==
                                        0) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tax",
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff000000),
                                                  FontWeight.w400,
                                                  12.0)),
                                          SizedBox(
                                            height: mHeight * .01,
                                          ),
                                          customisedTextFormField(
                                              initialValue: taxController
                                                  .taxBeforeController.text,
                                              onChanged: (value) {
                                                taxController.taxBeforeController
                                                    .text = value;
                                              },
                                              keyboardtype:
                                                  TextInputType.number,
                                              readOnly: false,
                                              labelText: "",
                                              controller: taxController
                                                  .taxBeforeController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Tax Percentage ';
                                                }
                                                return null;
                                              },
                                              onSubmitted: null,
                                              focusnode: null,
                                              suffixIcon: const Icon(null),
                                              maxWidth: mWidth * .25),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tax",
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff000000),
                                                  FontWeight.w400,
                                                  12.0)),
                                          SizedBox(
                                            height: mHeight * .01,
                                          ),
                                          customisedTextFormField(
                                              initialValue: taxController
                                                  .taxBeforeController.text,
                                              onChanged: (value) {
                                                taxController.taxBeforeController
                                                    .text = value;
                                              },
                                              keyboardtype:
                                                  TextInputType.number,
                                              readOnly: false,
                                              controller: taxController
                                                  .taxBeforeController,
                                              labelText: "",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Tax Amount';
                                                }
                                                return null;
                                              },
                                              onSubmitted: null,
                                              focusnode: null,
                                              suffixIcon: const Icon(null),
                                              maxWidth: mWidth * .25),
                                        ],
                                      );
                                    }
                                  }),
                                ],
                              ),
                              SizedBox(
                                width: mWidth * .05,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Greater/equal to BP",
                                    style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w500,
                                      12.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: mHeight * .025,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 0.0, right: 0.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // height: mHeight * .07,
                                          width: mWidth * .25,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            // border: Border.all(color:  Color(0xFFE7E7E7)
                                            // )
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: mWidth * .01,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  taxController
                                                      .selectPercentageorAmount1
                                                      .value = 0;
                                                  taxController.IsAmountTaxAfter
                                                      .value = false;
                                                },
                                                child: Obx(
                                                  () => Padding(
                                                    padding: const EdgeInsets.all(15.0),
                                                    child: Row(
                                                      children: [
                                                        taxController.selectPercentageorAmount1
                                                                    .value ==
                                                                0
                                                            ? Icon(
                                                          Icons.check_circle,
                                                                size: 25,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .4),
                                                              )
                                                            : Icon(
                                                          Icons
                                                              .circle_outlined,
                                                                size: 25,
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                        .4),
                                                              ),
                                                        SizedBox(
                                                          width: mWidth * .005,
                                                        ),
                                                        Text("Percentage",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    const Color(
                                                                        0xff000000),
                                                                    FontWeight
                                                                        .w400,
                                                                    12.0)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: mWidth * .04,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  taxController
                                                      .selectPercentageorAmount1
                                                      .value = 1;
                                                  taxController.IsAmountTaxAfter
                                                      .value = true;
                                                },
                                                child: Obx(
                                                  () => Row(
                                                    children: [
                                                      taxController.selectPercentageorAmount1
                                                                  .value ==
                                                              1
                                                          ? Icon(
                                                        Icons.check_circle,
                                                              size: 25,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .4),
                                                            )
                                                          : Icon(
                                                        Icons
                                                            .circle_outlined,
                                                              size: 25,
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      .4),
                                                            ),
                                                      SizedBox(
                                                        width: mWidth * .005,
                                                      ),
                                                      Text("Amount",
                                                          style:
                                                              customisedStyle(
                                                                  context,
                                                                  const Color(
                                                                      0xff000000),
                                                                  FontWeight
                                                                      .w400,
                                                                  12.0)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: mHeight * .022,
                                  ),
                                  Obx(() {
                                    if (taxController
                                            .selectPercentageorAmount1.value ==
                                        0) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tax",
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff000000),
                                                  FontWeight.w400,
                                                  12.0)),
                                          SizedBox(
                                            height: mHeight * .01,
                                          ),
                                          customisedTextFormField(
                                              initialValue: taxController
                                                  .taxAfterController.text,
                                              onChanged: (value) {
                                                taxController.taxAfterController
                                                    .text = value;
                                              },
                                              keyboardtype:
                                                  TextInputType.number,
                                              readOnly: false,
                                              labelText: "",
                                              controller:
                                                  taxController.taxAfterController,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Tax Percentage ';
                                                }
                                                return null;
                                              },
                                              onSubmitted: null,
                                              focusnode: null,
                                              suffixIcon: const Icon(null),
                                              maxWidth: mWidth * .25),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Tax",
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xff000000),
                                                  FontWeight.w400,
                                                  12.0)),
                                          SizedBox(
                                            height: mHeight * .01,
                                          ),
                                          customisedTextFormField(
                                              initialValue: taxController
                                                  .taxAfterController.text,
                                              onChanged: (value) {
                                                taxController.taxAfterController
                                                    .text = value;
                                              },
                                              keyboardtype:
                                                  TextInputType.number,
                                              readOnly: false,
                                              controller:
                                                  taxController.taxAfterController,
                                              labelText: "",
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Tax Amount';
                                                }
                                                return null;
                                              },
                                              onSubmitted: null,
                                              focusnode: null,
                                              suffixIcon: const Icon(null),
                                              maxWidth: mWidth * .25),
                                        ],
                                      );
                                    }
                                  }),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: mHeight * .02),
                        TextField(
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              taxController.taxCategoryList.value = taxController
                                  .taxCategoryList
                                  .where((taxCategory) =>
                                      taxCategory.taxName != null &&
                                      taxCategory.taxName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                            } else {
                              // If the search value is null or empty, reset the list
                              taxController.getTaxCategoryFullList();
                            }
                          },
                          decoration: InputDecoration(
                            constraints:
                                BoxConstraints(maxWidth: mWidth * .305),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                // color: Colors.grey.withOpacity(.2),
                                color: Color(0xFFE7E7E7),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintText: 'Search',
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                // color: Colors.grey.withOpacity(.2),
                                color: Color(0xFFE7E7E7),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        Obx(() {
                          if (taxController.isDataLoading.value) {
                            return Container(
                              height: mHeight * 1,
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          } else if (taxController.isError.value) {
                            return const Center(
                              child: Text('Error occured while loading data'),
                            );
                          } else {
                            return Container(
                              height: mHeight * 1,
                              // constraints: BoxConstraints(maxHeight: mHeight, minHeight: 100),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: taxController.taxCategoryList.length,
                                  itemBuilder: (context, index) {
                                    final taxCategory = taxController.taxCategoryList[index];

                                    return Dismissible(
                                      key: Key(taxCategory.id.toString()),
                                      background: Container(
                                        color: Colors.red,
                                      ),
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          // barrierDismissible: barrierDismissible,
                                          // false = user must tap button, true = tap outside dialog
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('Confirm'),
                                              content: const Text(
                                                  'Are you sure you want to delete this item?'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('CANCEL'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(false);

                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('DELETE'),
                                                  onPressed: () {
                                                    taxController.deleteTaxCategory(taxCategory.id);
                                                    Navigator.of(context).pop(false);
                                                    // Dismiss alert dialog
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                top: 5,
                                                bottom: 5),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey)),
                                              child: ListTile(
                                                  onTap: ()  {
                                                    method = "EDIT";
                                                    taxController.uID.value= taxCategory.id!;
                                                    taxController.isDataLoading.value = true;

                                                   loadViewDataOfTaxCategoryItem(taxCategory.id);
                                                   //controller.getTaxCategoryFullList();
                                                  },
                                                  contentPadding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                                                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "${taxCategory.taxName}",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500,
                                                                    12.0),
                                                          ),
                                                          Text(
                                                            "${taxCategory.taxType}",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    Colors.grey,
                                                                    FontWeight
                                                                        .w500,
                                                                    12.0),
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ///TAx value  Needed to add in the list api
                                                          Text(
                                                            // "${taxCategory.ta}",
                                                            "0.0",
                                                            style:
                                                                customisedStyle(
                                                                    context,
                                                                    Colors
                                                                        .black,
                                                                    FontWeight
                                                                        .w500,
                                                                    12.0),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                        }),
                      ],
                    ),
                  ))
            ]);
          }
        }),
        bottomNavigationBar: BottomAppBar(
            color: const Color(0xfff8f8f8),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: mWidth * .675,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25.0, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // controller.nameController.text = "455";
                            // print(controller.nameController.text);
                            taxController.isDataLoading.value = true;
                            method= "CREATE";

                            taxController.clear();
                            taxController.getTaxCategoryFullList();
                          },
                          child: SvgPicture.asset(
                            'assets/svg/delete1.svg',
                            height: mHeight * .05,
                          ),
                        ),
                        SizedBox(
                          width: mWidth * .02,
                        ),
                        GestureDetector(
                            onTap: () async {



                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, display a Snackbar.
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //    SnackBar(content: Text('Processing Data')),
                                // );
                                // print("DropdownValue: $dropdownValue");
                                // await controller.taxItemCreateFunction(
                                //     "CREATE", "");
                                print("DropdownValue: $dropdownValue");

                                print("DropdownValue: $dropdownValue");
                                if (method != "EDIT") {
                                  await taxController.taxItemCreateFunction("CREATE", "");
                                  taxController.clear();

                                } else if (method == "EDIT") {
                                  
                                    await taxController.taxItemCreateFunction("EDIT", taxController.uID.value);

                                }

                              }
                            },
                            child: InkWell(
                                child: SvgPicture.asset(
                              'assets/svg/add1.svg',
                              height: mHeight * .05,
                            ))),
                      ],
                    ),
                  ),
                ),

                const Spacer(
                  flex: 2,
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 25.0, bottom: 25),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap: () {

                                taxController.isDataLoading.value=true;
                                method = "CREATE";
                                taxController.clear();
                                dropdownValue = "General";
                                taxController.getTaxCategoryFullList();

                            },
                            child: InkWell(

                                child: SvgPicture.asset(
                              'assets/svg/addNew.svg',

                                    height: mHeight * .06,
                            )
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  TextFormField customisedTextFormField({
    TextEditingController? controller,
    // required double height,
    // required double width,
    required double maxWidth,
    required bool readOnly,
    required String? labelText,
    required String? Function(String?)? validator,
    required void Function(String)? onSubmitted,
    required FocusNode? focusnode,
    Color? inputTextColor,
    Color? containercolor,
    Widget? prefiicon,
    required Widget suffixIcon,
    TextInputType? keyboardtype,
    String? initialValue,
    Color? labelColor,
    Color? fillcolor,
    Function()? onTap,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        onTap: onTap,
        readOnly: readOnly,
        style: const TextStyle(
          color: Colors.black,
        ),
        validator: validator,
        // keyboardType: ,
        keyboardType: keyboardtype,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        // controller: ,
        textInputAction: TextInputAction.next,
        // validator: ,
        decoration: InputDecoration(
          constraints: BoxConstraints(maxWidth: maxWidth),
          filled: true,
          fillColor: Colors.white,
          labelText: labelText,
          // suffixIcon: SvgPicture.asset(
          //   'assets/ViknBooksPro/AddProduct/svg/dropdown.svg',
          // ),
          hintText: labelText,
          hintStyle: const TextStyle(
            color: Color(0xFFAEAEAE),
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: suffixIcon,
          suffixIconConstraints: const BoxConstraints(maxWidth: 50, minWidth: 50),
          labelStyle: TextStyle(
            color: labelColor ?? const Color(0xFFAEAEAE),
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Colors.grey.withOpacity(.2),
              color: Color(0xFFE7E7E7),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              // color: Colors.grey.withOpacity(.2),
              color: Color(0xFFE7E7E7),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
        ));
  }
}


class TextFieldStyle {
  static InputDecoration textFieldType(context,
      {String hintTextStr = "", String labelTextStr = ""}) {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(6),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: .5, color: Color(0xffE7E7E7)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: .5, color: Color(0xffE7E7E7)),
        ),
        labelText: labelTextStr,
        labelStyle: customisedStyle(
            context, const Color(0xffAEAEAE), FontWeight.w500, 15.0),
        hintText: hintTextStr,
        hintStyle: customisedStyle(
            context, const Color(0xffAEAEAE), FontWeight.w500, 15.0),
        filled: true,
        fillColor: const Color(0xffFDFDFD));
  }
}
