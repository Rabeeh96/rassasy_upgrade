import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';

import 'add_product_mobile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class ProductListMobile extends StatefulWidget {
  @override
  State<ProductListMobile> createState() => _ProductListMobileState();
}

class _ProductListMobileState extends State<ProductListMobile> {
  ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productController.fetchProducts('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
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
          'Products'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),
          Container(
              margin: const EdgeInsets.only(
                left: 15,
                right: 10,
              ),
              height: MediaQuery.of(context).size.height * .055,

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        controller: productController.searchController,
                        onChanged: (str) {
                          productController.fetchProducts(str);
                        },
                        style: customisedStyle(
                            context, Colors.black, FontWeight.normal, 15.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffFBFBFB),
                            hintText: "Search",
                            hintStyle: customisedStyle(
                                context,
                                const Color(0xff929292),
                                FontWeight.normal,
                                15.0),
                            contentPadding: const EdgeInsets.only(
                                left: 10.0, bottom: 10, top: 8),
                            border: InputBorder.none)),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/svg/search-normal.svg',
                      color: Color(0xffB4B4B4),
                      width: MediaQuery.of(context).size.width * .02,
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    onPressed: () {
                      //Get.to(SearchItems());
                    },
                  ),
                ],
              )),
          DividerStyle(),
          //
          Expanded(
              child: RefreshIndicator(
            color: Color(0xffF25F29),
            onRefresh: () async {
              // Implement the logic to refresh data here
              productController
                  .fetchProducts(''); // Assuming you pass the token here
            },
            child: Obx(() => productController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : productController.products.isEmpty
                    ? Center(
                        child: Text(
                        "No Products to Show",
                        style: customisedStyleBold(
                            context, Colors.black, FontWeight.w400, 14.0),
                      ))
                    :


            SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.separated(
                  itemCount:  productController.products.length,
                  itemBuilder: (context, index) {
                    ///swipe to delete dismissible
                    return Slidable(
                        key: ValueKey( productController.products[index]),
                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),
                          // A pane can dismiss the Slidable.
                          // All actions are defined in the children parameter.
                          children: [
                            // A LiableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext context) async {
                                print("eerte");
                                bool hasPermission = await checkingPerm("Productdelete");

                                if (hasPermission) {
                                  bottomDialogueFunction(
                                      isDismissible: true,
                                      textMsg: "Sure want to delete",
                                      fistBtnOnPressed: () {
                                        Get.back(); // Close the dialog
                                      },
                                      secondBtnPressed: () async {
                                        Get.back(); // Close the dialog
                                        productController.deleteProduct(productController.products[index].id);
                                      },
                                      secondBtnText: 'Ok', context: context
                                  );
                                } else {
                                  dialogBoxPermissionDenied(context); // Assuming this function also uses Get.dialog
                                }
                              },
                              // onPressed: doNothing ,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),
                          // A pane can dismiss the Slidable.
                          // All actions are defined in the children parameter.
                          children: [
                            // A LiableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext context) async {
                                Get.to(CreateProductMobile(type: "Edit",uid:productController.products[index].id ,));
                              },
                              // onPressed: doNothing ,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        // The end action pane is the one at the right or the bottom side.


                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height /
                                        14,
                                    width: MediaQuery.of(context)
                                        .size
                                        .width /
                                        7,
                                    child: ClipRRect(
                                      child: productController
                                          .products[index]
                                          .productImage
                                          .isEmpty
                                          ? SvgPicture.asset(
                                          "assets/svg/no_image.svg")
                                          : Image.network(
                                          productController
                                              .products[index]
                                              .productImage),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productController
                                              .products[index]
                                              .productName,
                                          style: customisedStyle(
                                              context,
                                              Colors.black,
                                              FontWeight.w400,
                                              14.0),
                                        ),
                                        Text(
                                          productController
                                              .products[index]
                                              .defaultUnitName,
                                          style: customisedStyle(
                                              context,
                                              Color(0xffA5A5A5),
                                              FontWeight.w400,
                                              14.0),
                                        ),
                                      ]),
                                ],
                              ),
                              Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 5.0),
                                    child: Text(
                                      "SR",
                                      style: customisedStyle(
                                          context,
                                          Color(0xffA5A5A5),
                                          FontWeight.w400,
                                          15.0),
                                    ),
                                  ),
                                  Text(
                                    roundStringWith(productController.products[index]
                                        .defaultSalesPrice),
                                    style: customisedStyle(
                                        context,
                                        Color(0xff000000),
                                        FontWeight.w500,
                                        15.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                    );
                  }, separatorBuilder: (BuildContext context, int index) =>
                    DividerStyle(),
                ))



            ),
          )),

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffFFF6F2))),
                onPressed: () {
                  Get.to(CreateProductMobile());
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Color(0xffF25F29),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Text(
                        'Add_Product'.tr,
                        style: customisedStyle(context, const Color(0xffF25F29),
                            FontWeight.normal, 12.0),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
