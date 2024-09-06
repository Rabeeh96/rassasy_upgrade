import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/product/detail/selectTax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SelectProduct extends StatefulWidget {
  const SelectProduct({Key? key}) : super(key: key);
  @override
  State<SelectProduct> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectProduct> {
  @override
  void initState() {
    super.initState();
    productLists.clear();
    getProductList(true,'');

  }
TextEditingController searchController =TextEditingController();
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
          'select_product'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.grey[300],

      ),
      body: Center(
        child: productLists.isNotEmpty?
        ListView(
          children: [
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0,right: 20.0,left: 10.0),
                child: TextFormField(
                  controller: searchController,

                  style: customisedStyle(
                    context,
                    Colors.black,
                    FontWeight.normal,
                    12.0,
                  ),
                  onChanged: (text){
                    getProductList(true,text);
                  },


                  //  controller: productReportController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        // searchController.clear();
                        // productsLists.clear();
                        // pageNumber = 1;
                        // firstTime = 1;
                        // getProductLists();
                        // setState(() {
                        //   ///turn back to list tile
                        //   isSearch=false;
                        // });
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(8),
                    hintText: 'search'.tr,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            displayProductDetails(),

          ],
        ):Center(child: Text('',style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),)),
      ),
    );
  }
  bool isLoading = false;
  var pageNumber = 1;
  var itemPerPage = 40;
  var firstTime = 1;
  var listLength = 0;

  Widget displayProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          height: MediaQuery.of(context).size.height / 1.5, //height of button
         // width: MediaQuery.of(context).size.width / 1.6,
          child:   Column(
            children: [
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!isLoading && scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      if (searchController.text == '') {


                        if(productLists.length < listLength){
                          pageNumber = pageNumber + 1;
                          getProductList(false,'');
                          setState(() {
                            isLoading = true;
                          });
                        }
                        else{

                        }

                      } else {
                        return true;
                      }
                    }
                    return true;
                  },
                  child: productLists.isEmpty
                      ? Center(child: const Text(''))
                      : Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child:RefreshIndicator(
                        color: Colors.blue,
                        onRefresh: () async {
                          pageNumber=1;
                          productLists.clear();
                          getProductList(true,'');
                        },
                        child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),

                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              childAspectRatio: 3.5, //2.4 will workk
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                              // crossAxisCount: 5,
                              // childAspectRatio: 2.3, //2.4 will workk
                              // crossAxisSpacing: 5,
                              // mainAxisSpacing: 5,
                            ),
                            itemCount: productLists.length,
                            itemBuilder: (BuildContext context, int i) {
                              return GestureDetector(
                                onTap: () async {
                                  Navigator.pop(context, [productLists[i].productName,productLists[i].productID]);
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height / 9, //height of button
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
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(

                                      // height: MediaQuery.of(context).size.height / 8.5, //height of button
                                      width: MediaQuery.of(context).size.width / 7,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ConstrainedBox(constraints: BoxConstraints(maxWidth: 350),child:
                                          Container(

                                            child: Text(returnProductName(productLists[i].productName),
                                              style: customisedStyle(context, Colors.black, FontWeight.w500, 11.5),softWrap: true,maxLines: 3,),
                                          ),),
                                          SizedBox(

                                            child: Text(returnProductName(productLists[i].defaultUnitName),
                                                style: customisedStyle(context, Colors.blueGrey, FontWeight.w500, 11.0)),
                                          ),


                                        ],
                                      ),
                                      // color: Colors.orange,
                                    ),
                                  ),
                                ),
                              );
                            })),
                  ),

                  /// with scrollable
                  // child: SlidableAutoCloseBehavior(
                  //     closeWhenOpened: true,
                  //     child: salesInvoiceLists.isEmpty
                  //         ?Center(child: const Text('No item'))
                  //         :ListView.builder(
                  //         padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 180),
                  //         shrinkWrap: true,
                  //         itemCount: salesInvoiceLists.length,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           return Slidable(
                  //             key: ValueKey(salesInvoiceLists[index]),
                  //             startActionPane: ActionPane(
                  //               motion: const ScrollMotion(),
                  //
                  //               // All actions are defined in the children parameter.
                  //               children: [
                  //                 // A LiableAction can have an icon and/or a label.
                  //                 SlidableAction(
                  //                   onPressed:
                  //                       (BuildContext context) async {
                  //                     // var perm = await checkingPerm(
                  //                     //     "Sales Invoicedelete");
                  //                     // print(perm);
                  //                     // if (perm) {
                  //                     //   SaleInvoiceDet.uid =
                  //                     //       salesInvoiceLists[index]
                  //                     //           .invoiceUID;
                  //                     //
                  //                     //   showAlertBox(
                  //                     //       salesInvoiceLists[index]
                  //                     //           .invoiceUID);
                  //                     // } else {
                  //                     //   dialogBoxNoPermission(context);
                  //                     // }
                  //                   },
                  //                   // onPressed: doNothing ,
                  //                   backgroundColor:
                  //                   const Color(0xFFFE4A49),
                  //                   foregroundColor: Colors.white,
                  //                   icon: Icons.delete,
                  //
                  //                   label: 'Delete',
                  //                 ),
                  //               ],
                  //             ),
                  //
                  //             // The end action pane is the one at the right or the bottom side.
                  //             endActionPane: ActionPane(
                  //               motion: const ScrollMotion(),
                  //               children: [
                  //                 SlidableAction(
                  //                   // An action can be bigger than the others.
                  //                   onPressed: (BuildContext context) async {
                  //                     // var perm = await checkingPerm(
                  //                     //     "Sales Invoiceprint");
                  //                     // print(perm);
                  //                     // if (perm) {
                  //                     //   _navigatePrinterA4(
                  //                     //       context,
                  //                     //       salesInvoiceLists[index]
                  //                     //           .invoiceUID);
                  //                     // } else {
                  //                     //   dialogBoxNoPermission(context);
                  //                     // }
                  //                   },
                  //                   //onPressed: doNothing,
                  //                   backgroundColor:
                  //                   const Color(0xFF3761B5),
                  //                   foregroundColor: Colors.white,
                  //                   icon: Icons.print,
                  //                   label: 'Print',
                  //                 ),
                  //                 SlidableAction(
                  //                   // An action can be bigger than the others.
                  //                   onPressed: (BuildContext context) async {
                  //                     // var perm = await checkingPerm(
                  //                     //     "Sales Invoiceedit");
                  //                     // print(perm);
                  //                     // if (perm) {
                  //                     //   SalesInvoiceMasterData.isEdit =
                  //                     //   true;
                  //                     //   SalesInvoiceMasterData.uniqueID =
                  //                     //       salesInvoiceLists[index]
                  //                     //           .invoiceUID;
                  //                     //   _navigateAddItem(context);
                  //                     // } else {
                  //                     //   dialogBoxNoPermission(context);
                  //                     // }
                  //                   },
                  //                   //onPressed: doNothing,
                  //                   backgroundColor:
                  //                   const Color(0xFF7BC043),
                  //                   foregroundColor: Colors.white,
                  //                   icon: Icons.edit,
                  //                   label: "Edit",
                  //                 ),
                  //               ],
                  //             ),
                  //
                  //             // The child of the Slidable is what the user sees when the
                  //             // component is not dragged.
                  //             child: Column(
                  //               children: [
                  //                 Padding(
                  //                   padding: const EdgeInsets.only(left: 25.0,right: 25,top: 15,bottom: 15),
                  //                   child: SizedBox(
                  //                     //  height: MediaQuery.of(context).size.height / 15,
                  //                       child: Row(
                  //                         mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                         children: [
                  //                           Column(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                             crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                             children: [
                  //                               RichText(
                  //                                 text: TextSpan(
                  //                                   //  style: TextStyle(color: Colors.black, fontSize: 36),
                  //
                  //                                   children: <TextSpan>[
                  //                                     TextSpan(
                  //                                         text: '#',
                  //                                         style: customisedStyle(
                  //                                             context,
                  //                                             const Color(0xff7d7d7d),
                  //                                             FontWeight.w400,
                  //                                             12.0)),
                  //                                     TextSpan(
                  //                                         text: salesInvoiceLists[index].voucherNo,
                  //                                         style: customisedStyle(
                  //                                             context,
                  //                                             themeChangeController
                  //                                                 .isDarkMode
                  //                                                 .value
                  //                                                 ? Colors.white
                  //                                                 : Colors.black,
                  //                                             FontWeight.w400,
                  //                                             12.0)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                               Text(
                  //                                 salesInvoiceLists[index].ledgerName,
                  //                                 style: customisedStyle(
                  //                                     context,
                  //                                     themeChangeController
                  //                                         .isDarkMode.value
                  //                                         ? const Color(0xffE8E8E8)
                  //                                         : const Color(0xff1C3347),
                  //                                     FontWeight.w400,
                  //                                     14.0),
                  //                               )
                  //                             ],
                  //                           ),
                  //                           Column(
                  //                             mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                             crossAxisAlignment:
                  //                             CrossAxisAlignment.end,
                  //                             children: [
                  //                               Text(
                  //                                 "Pending",
                  //                                 style: customisedStyle(
                  //                                     context,
                  //                                     const Color(0xffE81C1C),
                  //                                     FontWeight.w400,
                  //                                     13.0),
                  //                               ),
                  //                               RichText(
                  //                                 text: TextSpan(
                  //                                   style: TextStyle(
                  //                                       color: themeChangeController
                  //                                           .isDarkMode.value
                  //                                           ? Colors.black
                  //                                           : Colors.white,
                  //                                       fontSize: 36),
                  //                                   children: <TextSpan>[
                  //                                     TextSpan(
                  //                                         text: '$currency.  ',
                  //                                         style: customisedStyle(
                  //                                             context,
                  //                                             const Color(0xff8F8F8F),
                  //                                             FontWeight.w400,
                  //                                             12.0)),
                  //                                     TextSpan(
                  //                                         text: roundStringWith(salesInvoiceLists[index].grandTotal),
                  //                                         style: customisedStyle(
                  //                                             context,
                  //                                             themeChangeController
                  //                                                 .isDarkMode
                  //                                                 .value
                  //                                                 ? Colors.white
                  //                                                 : Colors.black,
                  //                                             FontWeight.w400,
                  //                                             14.0)),
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             ],
                  //                           )
                  //                         ],
                  //                       )),
                  //                 ),
                  //                 DividerStyle(),
                  //               ],
                  //             ),
                  //           );
                  //         })
                  // ),
                ),
              )
            ],
          ),








      ),
    );
  }
  Widget displayProductDetails1() {
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
              itemCount: productLists.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, [productLists[i].productName,productLists[i].productID]);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 9, //height of button
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

                          // productLists[i].productImage == ''
                          //     ? Container(
                          //
                          //   height: MediaQuery.of(context).size.height / 10, //height of button
                          //   width: MediaQuery.of(context).size.width / 15,
                          //   decoration: BoxDecoration(
                          //     //  color: Colors.red,
                          //       border: Border.all(
                          //         width: .1,
                          //         color: const Color(0xffC9C9C9),
                          //       ),
                          //       borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                          //       )),
                          //
                          //   child: SvgPicture.asset("assets/svg/Logo.svg"),
                          // )
                          //     : Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height / 15, //height of button
                          //     width: MediaQuery.of(context).size.width / 20,
                          //
                          //     decoration: BoxDecoration(
                          //         image: DecorationImage(image: NetworkImage(productLists[i].productImage), fit: BoxFit.cover),
                          //         border: Border.all(
                          //           width: .1,
                          //           color: const Color(0xffC9C9C9),
                          //         ),
                          //         borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                          //         )),
                          //   ),
                          // ),

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

                                    child: Text(returnProductName(productLists[i].productName),
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 11.5)),
                                  ),
                       SizedBox(

                                    child: Text(returnProductName(productLists[i].defaultUnitName),
                                        style: customisedStyle(context, Colors.blueGrey, FontWeight.w500, 11.5)),
                                  ),


                                  // SizedBox(
                                  //   //  height: MediaQuery.of(context).size.height /                                   24, //height of button
                                  //   // width: MediaQuery.of(context).size.width / 11,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     // crossAxisAlignment: CrossAxisAlignment.center,
                                  //     children: [
                                  //       Text("currency ${roundStringWith(productLists[i].defaultSalesPrice)}",
                                  //           //'Rs.95 ',
                                  //           style: customisedStyle(context, Colors.blueGrey, FontWeight.w500, 12.0)),
                                  //       // Container(
                                  //       //   height: MediaQuery.of(context).size.height / 42,
                                  //       //   child: SvgPicture.asset(returnVegOrNonVeg(productLists[i].vegOrNonVeg)),
                                  //       // )
                                  //     ],
                                  //   ),
                                  // ),
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
              })

      ),
    );
  }

  returnProductName(String val) {
    var out = val;
    if (val.length > 55) {
      out = val.substring(0, 50);
    }
    return out;
  }


  Future<Null> getProductList(loader,search) async {



    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        stop();

    } else {
      try {
        if(loader){
          start(context);
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;


        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/posholds/pos-product-list-paginated/';

        print(url);
        print(accessToken);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": 2,
          "GroupID": null,
          "page_no": pageNumber,
          "items_per_page": itemPerPage,
          "search": search
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
          listLength = n["count"]??0;
          if(loader){
            stop();
            productLists.clear();
          }
          isLoading = false;
          setState(() {



            for (Map user in responseJson) {
              productLists.add(ProductListModel.fromJson(user));
            }

          });


        } else if (status == 6001) {
          setState(() {
            productLists.clear();
          });
          if(loader){
            stop();
          }
          isLoading = false;


        }
        //DB Error
        else {
          if(loader){
            stop();
          }
        }
      } catch (e) {
        if(loader){
          stop();
        }
        setState(() {
          isLoading = false;
        });

      }
    }
  }
}



List<ProductListModel> productLists = [];

class ProductListModel {
  int productID;
  String productName, defaultUnitName, id, productImage, productImage2, productImage3, defaultSalesPrice;

  ProductListModel(
      {required this.productName,
        required this.defaultSalesPrice,
        required this.productImage,
        required this.defaultUnitName,
        required this.productID,
        required this.productImage3,
        required this.productImage2,
        required this.id});

  factory ProductListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductListModel(
      defaultUnitName: json['DefaultUnitName'],
      defaultSalesPrice: json['DefaultSalesPrice'].toString(),
      productName: json['ProductName'],
      id: json['id'],
      productID: json['ProductID'],
      productImage: json['ProductImage'] ?? '',
      productImage2: json['ProductImage2'] ?? '',
      productImage3: json['ProductImage3'] ?? '',
    );
  }
}
