import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
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
    getProductList('');

  }

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
            fontSize: 23,
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

                  style: customisedStyle(
                    context,
                    Colors.black,
                    FontWeight.normal,
                    12.0,
                  ),
                  onChanged: (text){
                    getProductList(text);
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

  Widget displayProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          height: MediaQuery.of(context).size.height / 1.5, //height of button
         // width: MediaQuery.of(context).size.width / 1.6,
          child: GridView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),

              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
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

                          productLists[i].productImage == ''
                              ? Container(

                            height: MediaQuery.of(context).size.height / 10, //height of button
                            width: MediaQuery.of(context).size.width / 15,
                            decoration: BoxDecoration(
                              //  color: Colors.red,
                                border: Border.all(
                                  width: .1,
                                  color: const Color(0xffC9C9C9),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                )),

                            child: SvgPicture.asset("assets/svg/Logo.svg"),
                          )
                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 15, //height of button
                              width: MediaQuery.of(context).size.width / 20,

                              decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(productLists[i].productImage), fit: BoxFit.cover),
                                  border: Border.all(
                                    width: .1,
                                    color: const Color(0xffC9C9C9),
                                  ),
                                  borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                  )),
                            ),
                          ),

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
              })),
    );
  }

  returnProductName(String val) {
    var out = val;
    if (val.length > 55) {
      out = val.substring(0, 50);
    }
    return out;
  }


  Future<Null> getProductList(search) async {



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
        final url = '$baseUrl/posholds/pos-product-list-paginated/';

        print(url);
        print(accessToken);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "PriceRounding": 2,
          "GroupID": null,
          "page_no": 1,
          "items_per_page": 20,
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
          setState(() {

            stop();
            productLists.clear();
            for (Map user in responseJson) {
              productLists.add(ProductListModel.fromJson(user));
            }

          });
        } else if (status == 6001) {

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
