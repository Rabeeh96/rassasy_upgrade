import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_group_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'add_product_group.dart';

class ProductGroupMobile extends StatefulWidget {
  @override
  State<ProductGroupMobile> createState() => _ProductGroupMobileState();
}

class _ProductGroupMobileState extends State<ProductGroupMobile> {
  ProductGroupController productGroupController = Get.put(ProductGroupController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productGroupController.getProductListDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
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
          'product_group'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
        ),
      ),
      body: Column(
        children: [
          dividerStyleFull(),
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
                        controller: productGroupController.searchController,
                        onChanged: (str) {
                          productGroupController.searchData(str);
                          productGroupController.productGroupLists.clear();
                          productGroupController.getProductListDetails();
                        },
                        style: customisedStyle(context, Colors.black, FontWeight.normal, 15.0),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xffFBFBFB),
                            hintText: "Search",
                            hintStyle: customisedStyle(context, const Color(0xff929292), FontWeight.normal, 15.0),
                            contentPadding: const EdgeInsets.only(left: 10.0, bottom: 10, top: 8),
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
          dividerStyleFull(),
          Expanded(
              child: RefreshIndicator(
            color: Color(0xffF25F29),
            onRefresh: () async {
              productGroupController.getProductListDetails();
            },
            child: Obx(() => productGroupController.isLoadGroups.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : productGroupController.productGroupLists.isEmpty
                    ? Center(
                        child: Text(
                        "No Groups to Show",
                        style: customisedStyleBold(context, Colors.black, FontWeight.w400, 14.0),
                      ))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.separated(
                          itemCount: productGroupController.productGroupLists.length,
                          itemBuilder: (context, index) {
                            ///swipe to delete dismissible
                            return Slidable(
                                key: ValueKey(productGroupController.productGroupLists[index]),
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
                                        bool hasPermission = await checkingPerm("Groupdelete");

                                        if (hasPermission) {
                                          bottomDialogueFunction(
                                              isDismissible: true,
                                              textMsg: "Sure want to delete",
                                              fistBtnOnPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              secondBtnPressed: () async {
                                                Get.back(); // Close the dialog
                                                productGroupController.deleteProduct(productGroupController.productGroupLists[index].uID);
                                              },
                                              secondBtnText: 'Ok',
                                              context: context);
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
                                        Get.to(CreateProductGroup(
                                          type: "Edit",
                                          uid: productGroupController.productGroupLists[index].uID,
                                        ));
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
                                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
                                    child: ListTile(
                                      title: Text(
                                        productGroupController.productGroupLists[index].groupName,
                                        style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                                      ),
                                    )));
                          },
                          separatorBuilder: (BuildContext context, int index) => dividerStyle(),
                        ))),
          )),
        ],
      ),
      bottomNavigationBar: Padding(
        padding:  EdgeInsets.only(top: 10.0, bottom:Platform.isIOS ? 25:10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffFFF6F2))),
                onPressed: () {
                  Get.to(CreateProductGroup());
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
                        'Add Group',
                        style: customisedStyle(context, const Color(0xffF25F29), FontWeight.normal, 12.0),
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
