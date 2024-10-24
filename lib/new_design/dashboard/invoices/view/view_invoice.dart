import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/invoices/controller/invoice_controller.dart';
import 'package:rassasy_new/new_design/dashboard/invoices/view/preview_page.dart';

class ViewInvoice extends StatefulWidget {
  const ViewInvoice({super.key});

  @override
  State<ViewInvoice> createState() => _ViewInvoiceState();
}

class _ViewInvoiceState extends State<ViewInvoice> {
  final InvoiceController invoiceController = Get.put(InvoiceController());
  @override
  var messageShow = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceController.invoiceList.clear();
    fromDateNotifier = ValueNotifier(DateTime.now());
    toDateNotifier = ValueNotifier(DateTime.now());
    invoiceController.viewList();
  }

  DateFormat apiDateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");

  late ValueNotifier<DateTime> fromDateNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toDateNotifier = ValueNotifier(DateTime.now());

  // Future<Null> viewList() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     dialogBox(context, "Please check your network connection");
  //   } else {
  //     try {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       start(context);
  //       String baseUrl = BaseUrl.baseUrl;
  //       var userID = prefs.getInt('user_id') ?? 0;
  //       var accessToken = prefs.getString('access') ?? '';
  //       // pr(accessToken);
  //       var companyID = prefs.getString('companyID') ?? 0;
  //       var branchID = prefs.getInt('branchID') ?? 1;

  //       final String url = '$baseUrl/posholds/list-pos-hold-invoices/';
  //       String selectedType = invoiceController.selectedPosValue.value;
  //       String searchinvoice = invoiceController.searchValue.value;
  //       pr("radioselect $selectedType");
  //       Map data = {
  //         "CompanyID": companyID,
  //         "CreatedUserID": userID,
  //         "BranchID": branchID,
  //         "page_number": pageNumber,
  //         "page_size": itemPerPage,
  //         "from_date": apiDateFormat.format(fromDateNotifier.value),
  //         "to_date": apiDateFormat.format(toDateNotifier.value),
  //         "Type": selectedType,
  //         "search": searchinvoice,
  //       };
  //       print(url);
  //       print(data);

  //       var body = json.encode(data);
  //       var response = await http.post(Uri.parse(url),
  //           headers: {
  //             "Content-Type": "application/json",
  //             'Authorization': 'Bearer $accessToken',
  //           },
  //           body: body);

  //       Map n = json.decode(utf8.decode(response.bodyBytes));
  //       var status = n["StatusCode"];
  //       print(status);

  //       var responseJson = n["data"];
  //       print(response.body);

  //       if (status == 6000) {
  //         if (firstTime == 1) {
  //           invoiceList.clear();
  //           stop();
  //         }
  //         isLoading = false;
  //         stop();
  //         setState(() {
  //           messageShow = "";

  //           for (Map user in responseJson) {
  //             invoiceList.add(InvoiceModelClass.fromJson(user));
  //           }
  //           if (invoiceList.isEmpty) {
  //             messageShow = "No sale during these period";
  //           }
  //         });
  //       } else if (status == 6001) {
  //         if (firstTime == 1) {
  //           stop();
  //         }
  //         isLoading = false;
  //         messageShow = "No sale during these period";
  //         stop();
  //       } else {
  //         if (firstTime == 1) {
  //           stop();
  //         }
  //         isLoading = false;
  //         stop();
  //       }
  //     } catch (e) {
  //       if (firstTime == 1) {
  //         stop();
  //       }
  //       isLoading = false;
  //       stop();
  //       print("Error ${e.toString()}");
  //     }
  //   }
  // }

  var networkConnection = true;

  showDatePickerFunction(context, ValueNotifier dateNotifier) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width / 2;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: SizedBox(
          width: mWidth * .98,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                    child: Center(
                      child: Text(
                        'select_date'.tr,
                        style: customisedStyle(
                            context, Colors.black, FontWeight.bold, 18.0),
                      ),
                    ),
                  ),
                ],
              ),
              CalendarDatePicker(
                onDateChanged: (selectedDate) {
                  messageShow = "";
                  dateNotifier.value = selectedDate;
                  invoiceController.viewList();
                  Navigator.pop(context);
                },
                initialDate: DateTime.now(),
                firstDate: DateTime.now().add(
                  const Duration(days: -100000000),
                ),
                lastDate: DateTime.now().add(const Duration(days: 6570)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        body: networkConnection == true
            ? SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              //!Left
                              SizedBox(
                                width: constraints.maxWidth * 0.7,
                                height: constraints.maxHeight * 1,
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    icon: const Icon(
                                                      Icons.arrow_back,
                                                      color: Colors.black,
                                                    )),
                                                SizedBox(
                                                    width: screenSize.width *
                                                        0.01),
                                                Text(
                                                  'Invoices'.tr,
                                                  style: googleFontStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        thickness: 1,
                                        color: Color(0xFFDEDEDE),
                                      ),
                                      SizedBox(
                                          height: screenSize.height * 0.01),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: NotificationListener<
                                                  ScrollNotification>(
                                                onNotification:
                                                    (ScrollNotification
                                                        scrollInfo) {
                                                  print(
                                                      "-**********************1");
                                                  if (!isLoading &&
                                                      scrollInfo
                                                              .metrics.pixels ==
                                                          scrollInfo.metrics
                                                              .maxScrollExtent) {
                                                    print(
                                                        "-**********************");
                                                    pageNumber = pageNumber + 1;
                                                    firstTime = 10;
                                                    invoiceController
                                                        .viewList();
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                  }
                                                  return true;
                                                },
                                                child: RefreshIndicator(
                                                    color: Colors.blue,
                                                    onRefresh: () async {
                                                      pageNumber = 1;
                                                      invoiceController
                                                          .invoiceList
                                                          .clear();
                                                      invoiceController
                                                          .viewList();
                                                    },
                                                    child: Obx(
                                                      () => ListView.builder(
                                                          itemCount:
                                                              invoiceController
                                                                  .invoiceList
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  var result =
                                                                      await Get.to(
                                                                          InvoiceDetailPage(
                                                                    MasterUID: invoiceController
                                                                        .invoiceList[
                                                                            index]
                                                                        .salesMasterID,
                                                                    detailID: invoiceController
                                                                        .invoiceList[
                                                                            index]
                                                                        .saleOrderID,
                                                                    masterType:
                                                                        'SI',
                                                                  ));

                                                                  if (result !=
                                                                      null) {
                                                                    pageNumber =
                                                                        1;
                                                                    invoiceController
                                                                        .invoiceList
                                                                        .clear();
                                                                    invoiceController
                                                                        .viewList();
                                                                  }
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              10.0,
                                                                          vertical:
                                                                              4.0),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                const Color(0xFFFFFFFF),
                                                                            border: Border.all(color: const Color(0xFFCFCFCF)),
                                                                            borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    invoiceController.invoiceList[index].voucherNo,
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    invoiceController.invoiceList[index].salesData["VoucherNo"],
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    invoiceController.invoiceList[index].salesData["Date"],
                                                                                    style: googleFontStyle(color: const Color(0xFF4B4B4B)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'token_no'.tr,
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    invoiceController.invoiceList[index].tokenNo,
                                                                                    style: googleFontStyle(color: const Color(0xFF4B4B4B)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'customer'.tr,
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    invoiceController.invoiceList[index].custName,
                                                                                    style: googleFontStyle(color: const Color(0xFF4B4B4B)),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Total",
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  Text(
                                                                                    roundStringWith(invoiceController.invoiceList[index].salesData["GrandTotal"].toString()),
                                                                                    style: googleFontStyle(fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ));
                                                          }),
                                                    )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //!Right
                              Column(
                                children: [
                                  Container(
                                    height: constraints.maxHeight * 0.1,
                                    width: constraints.maxWidth -
                                        (constraints.maxWidth * 0.7),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF6F8FE),
                                      border: Border(
                                        left: BorderSide(
                                          width: 2,
                                          color: Color(0xFFDFE1E7),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                              onPressed: () {},
                                              icon:
                                                  const Icon(Icons.more_vert)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: constraints.maxHeight * 0.9,
                                        width: constraints.maxWidth -
                                            (constraints.maxWidth * 0.7),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFF6F8FE),
                                          border: Border(
                                            left: BorderSide(
                                              width: 2,
                                              color: Color(0xFFDFE1E7),
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 8,
                                              bottom: 25),
                                          child: Container(
                                            color: const Color(0xFFF6F8FE),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: TextField(
                                                        onChanged: (value) {
                                                          invoiceController
                                                              .invoiceList
                                                              .clear();
                                                          invoiceController
                                                              .searchValue
                                                              .value = value;
                                                          invoiceController
                                                              .viewList();
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                                prefixIcon:
                                                                    Icon(
                                                                  Icons.search,
                                                                  color: Color(
                                                                      0xFF292D32),
                                                                ),
                                                                border:
                                                                    OutlineInputBorder(),
                                                                enabledBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xFFDEDEDE),
                                                                      width:
                                                                          1.0),
                                                                ),
                                                                focusedBorder:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Color(
                                                                          0xFFDEDEDE),
                                                                      width:
                                                                          1.0),
                                                                ),
                                                                hintText:
                                                                    "Search"),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.03),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        ValueListenableBuilder(
                                                          valueListenable:
                                                              fromDateNotifier,
                                                          builder: (BuildContext
                                                                  ctx,
                                                              DateTime
                                                                  fromDateNewValue,
                                                              _) {
                                                            return Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "From",
                                                                    style: googleFontStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                      height: screenSize
                                                                              .height *
                                                                          0.01),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFFD1EFFF),
                                                                      minimumSize:
                                                                          const Size(
                                                                              100,
                                                                              40),
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.zero,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      showDatePickerFunction(
                                                                          context,
                                                                          fromDateNotifier);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .calendar_today_outlined,
                                                                          color:
                                                                              Color(0xFF2B3F6C),
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              screenSize.width * 0.002,
                                                                        ),
                                                                        Text(
                                                                          dateFormat
                                                                              .format(fromDateNewValue),
                                                                          style:
                                                                              googleFontStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              screenSize.width *
                                                                  0.01,
                                                        ),
                                                        ValueListenableBuilder(
                                                          valueListenable:
                                                              toDateNotifier,
                                                          builder: (BuildContext
                                                                  ctx,
                                                              DateTime
                                                                  fromDateNewValue,
                                                              _) {
                                                            return Expanded(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "To",
                                                                    style: googleFontStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                      height: screenSize
                                                                              .height *
                                                                          0.01),
                                                                  ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.zero,
                                                                      ),
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0xFFD1EFFF),
                                                                      minimumSize:
                                                                          const Size(
                                                                              100,
                                                                              40),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      showDatePickerFunction(
                                                                          context,
                                                                          toDateNotifier);
                                                                    },
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .calendar_today_outlined,
                                                                          color:
                                                                              Color(0xFF2B3F6C),
                                                                          size:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              screenSize.width * 0.002,
                                                                        ),
                                                                        Text(
                                                                          dateFormat
                                                                              .format(fromDateNewValue),
                                                                          style:
                                                                              googleFontStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.02),
                                                    Text(
                                                      "Order Type",
                                                      style: googleFontStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            screenSize.height *
                                                                0.01),
                                                    Obx(
                                                      () => Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color(
                                                                0xFFFFFFFF),
                                                            border: Border.all(
                                                              color: const Color(
                                                                  0xFFDEDEDE),
                                                              width: 1,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width: screenSize.width *
                                                                            0.07,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: const Color(0xFF00428E),
                                                                              value: '',
                                                                              groupValue: invoiceController.selectedPosValue.value,
                                                                              onChanged: (value) {
                                                                                invoiceController.invoiceList.clear();
                                                                                invoiceController.updateValue(value.toString());
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              "All",
                                                                              style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width: screenSize.width *
                                                                            0.07,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: const Color(0xFF00428E),
                                                                              value: 'Dining',
                                                                              groupValue: invoiceController.selectedPosValue.value,
                                                                              onChanged: (value) {
                                                                                invoiceController.invoiceList.clear();
                                                                                invoiceController.updateValue(value.toString());
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              "Dining",
                                                                              style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          SizedBox(
                                                                        width: screenSize.width *
                                                                            0.07,
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Radio(
                                                                              activeColor: const Color(0xFF00428E),
                                                                              value: 'TakeAway',
                                                                              groupValue: invoiceController.selectedPosValue.value,
                                                                              onChanged: (value) {
                                                                                invoiceController.invoiceList.clear();
                                                                                invoiceController.updateValue(value.toString());
                                                                              },
                                                                            ),
                                                                            Text(
                                                                              "Takeout",
                                                                              style: customisedStyle(context, Colors.black, FontWeight.w700, 12.0),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: screenSize
                                                                              .width *
                                                                          0.08,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Radio(
                                                                            activeColor:
                                                                                const Color(0xFF00428E),
                                                                            value:
                                                                                'Order',
                                                                            groupValue:
                                                                                invoiceController.selectedPosValue.value,
                                                                            onChanged:
                                                                                (value) {
                                                                              invoiceController.invoiceList.clear();
                                                                              invoiceController.updateValue(value.toString());
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            "Order",
                                                                            style: customisedStyle(
                                                                                context,
                                                                                Colors.black,
                                                                                FontWeight.w700,
                                                                                12.0),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: screenSize
                                                                              .width *
                                                                          0.08,
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Radio(
                                                                            activeColor:
                                                                                const Color(0xFF00428E),
                                                                            value:
                                                                                'Car',
                                                                            groupValue:
                                                                                invoiceController.selectedPosValue.value,
                                                                            onChanged:
                                                                                (value) {
                                                                              invoiceController.invoiceList.clear();
                                                                              invoiceController.updateValue(value.toString());
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            "Car",
                                                                            style: customisedStyle(
                                                                                context,
                                                                                Colors.black,
                                                                                FontWeight.w700,
                                                                                12.0),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            : noNetworkConnectionPage(),
      ),
    );
  }

  bool isLoading = false;
  var pageNumber = 1;
  var itemPerPage = 10;
  var firstTime = 1;
  var listLength = 1;
  Uint8List? resizedImageBytes;

  // void _resizeImage() async {
  //   print(
  //       "Date ---------1   ---------1   ---------1    ${DateTime.now().second} ");

  //   var id = "9eee65e7-d6f7-4ece-b0dc-5341a33365e6";
  //   var arabicImageBytes =
  //       await printHelperNew.printDetails(id: id, type: "SI", context: context);

  //   print(
  //       "Date ---------4   ---------4   ---------4    ${DateTime.now().second} ");
  //   // Step 1: Decode and resize the image using the image package

  //   print(
  //       "Date ---------5   ---------5   ---------5    ${DateTime.now().second} ");

  //   pr("--------------${arabicImageBytes.runtimeType}---------$arabicImageBytes");

  //   final Img.Image? image = Img.decodeImage(arabicImageBytes);

  //   print(
  //       "Date ---------6   ---------6   ---------6    ${DateTime.now().second} ");
  //   final Img.Image resizedImage = Img.copyResize(image!, width: 570);
  //   print(
  //       "Date ---------7   ---------7   ---------7    ${DateTime.now().second} ");
  //   // Step 2: Convert the Img.Image back to Uint8List
  //   resizedImageBytes = Uint8List.fromList(Img.encodePng(resizedImage));
  //   print(
  //       "Date ---------8   ---------8   ---------8    ${DateTime.now().second} ");
  //   // Trigger a rebuild to display the resized image
  //   setState(() {});
  // }

  //
  // var printHelperNew = USBPrintClassTest();
  // var printHelperUsb = USBPrintClass();
  // var printHelperIP = AppBlocs();
  // var bluetoothHelper = AppBlocsBT();
  // var wifiNewMethod = WifiPrintClassTest();

  // printDetail(id, voucherType) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var defaultIp = prefs.getString('defaultIP') ?? '';
  //   var printType = prefs.getString('PrintType') ?? 'Wifi';
  //   var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
  //   var temp = prefs.getString("template") ?? "template4";
  //   if (defaultIp == "") {
  //     popAlert(
  //         head: "Error",
  //         message: "Please select a printer",
  //         position: SnackPosition.TOP);
  //   } else {
  //     if (printType == 'Wifi') {
  //       if (temp == "template5") {
  //         var ip = "";
  //         if (PrintDataDetails.type == "SO") {
  //           ip = defaultOrderIP;
  //         } else {
  //           ip = defaultIp;
  //         }

  //         print("temp  $temp");
  //         wifiNewMethod.printDetails(
  //             id: id,
  //             type: voucherType,
  //             context: context,
  //             ipAddress: ip,
  //             isCancelled: false,
  //             orderSection: false);
  //       } else {
  //         var ret = await printHelperIP.printDetails();
  //         if (ret == 2) {
  //           var ip = "";
  //           if (PrintDataDetails.type == "SO") {
  //             ip = defaultOrderIP;
  //           } else {
  //             ip = defaultIp;
  //           }
  //           printHelperIP.print_receipt(ip, context, false, false);
  //         } else {
  //           popAlert(
  //               head: "Error",
  //               message: "Please try again later",
  //               position: SnackPosition.TOP);
  //         }
  //       }
  //     } else if (printType == 'USB') {
  //       if (temp == "template5") {
  //         print(
  //             "Date ---------step 1   ---------   ---------     ${DateTime.now().second} ");
  //         printHelperNew.printDetails(
  //             id: id, type: voucherType, context: context);
  //       } else {
  //         var ret = await printHelperUsb.printDetails();
  //         if (ret == 2) {
  //           var ip = "";
  //           if (PrintDataDetails.type == "SO") {
  //             ip = defaultOrderIP;
  //           } else {
  //             ip = defaultIp;
  //           }
  //           printHelperUsb.printReceipt(ip, context);
  //         } else {
  //           popAlert(
  //               head: "Error",
  //               message: "Please try again later",
  //               position: SnackPosition.TOP);
  //         }
  //       }

  //       /// commented
  //     } else {
  //       var loadData =
  //           await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
  //       // handlePrint(context);

  //       if (loadData) {
  //         var printStatus = await bluetoothHelper.scan(false);
  //         if (printStatus == 1) {
  //           dialogBox(context, "Check your bluetooth connection");
  //         } else if (printStatus == 2) {
  //           dialogBox(context, "Your default printer configuration problem");
  //         } else if (printStatus == 3) {
  //           await bluetoothHelper.scan(false);
  //           // alertMessage("Try again");
  //         } else if (printStatus == 4) {
  //           //  alertMessage("Printed successfully");
  //         }
  //       } else {
  //         dialogBox(context, "Try again");
  //       }
  //     }
  //   }
  // }

  // Future<void> handlePrint(BuildContext context) async {
  //   var bluetoothHelper = BluetoothHelperNew();
  //   var printStatus = await bluetoothHelper.scan();

  //   switch (printStatus) {
  //     case 1:
  //       dialogBox(context, "Check your bluetooth connection");
  //       break;
  //     case 2:
  //       dialogBox(context, "Your default printer configuration problem");
  //       break;
  //     case 3:
  //       await bluetoothHelper.scan();
  //       // alertMessage("Try again");
  //       break;
  //     case 4:
  //       // alertMessage("Printed successfully");
  //       break;
  //   }
  // }

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
          const SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              //getAllTax();
              // defaultData();
            },
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xffEE830C))),
            child: Text('retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
