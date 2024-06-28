import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/flavour_controller.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/tax_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'dart:io' show Platform;
import 'add_tax_mobile.dart';

class TaxListMobile extends StatefulWidget {
  @override
  State<TaxListMobile> createState() => _TaxListMobileState();
}

class _TaxListMobileState extends State<TaxListMobile> {
  TaxController taxController = Get.put(TaxController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taxController.fetchTax();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Tax',
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
              height: MediaQuery
                  .of(context)
                  .size
                  .height * .055,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                        autofocus: false,
                        textCapitalization: TextCapitalization.words,
                        controller: taxController.searchController,
                        onChanged: (str) {
                          taxController.onSearchTextChanged(str);
                          taxController.searchTaxList.clear();
                          taxController.taxLists.clear();
                          taxController.fetchTax();
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
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * .02,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * .02,
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
                   taxController.fetchTax();
                },
                child: Obx(() =>
                taxController.isLoading.value
                    ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF25F29),
                    ))
                    : taxController.taxLists.isEmpty
                    ? Center(
                    child: Text(
                      "No Tax to Show",
                      style: customisedStyleBold(
                          context, Colors.black, FontWeight.w400, 14.0),
                    ))
                    : SlidableAutoCloseBehavior(
                    closeWhenOpened: true,
                    child: ListView.separated(
                      itemCount: taxController.taxLists.length,
                      itemBuilder: (context, index) {
                        ///swipe to delete dismissible
                        return Slidable(
                            key: ValueKey(
                                taxController.taxLists[index]),
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

                                    // bool hasPermission =
                                    // await checkingPerm("Flavourdelete");
                                    //
                                    // if (hasPermission) {
                                      bottomDialogueFunction(
                                          isDismissible: true,
                                          textMsg: "Sure want to delete",
                                          fistBtnOnPressed: () {
                                            Get.back(); // Close the dialog
                                          },
                                          secondBtnPressed: () async {
                                            taxController
                                                .deleteTax(
                                                taxController
                                                    .searchTaxList[
                                                index]
                                                    .id);
                                            taxController.fetchTax();
                                            Get.back();
                                          },
                                          secondBtnText: 'Ok',
                                          context: context);
                                    // } else {
                                    //   dialogBoxPermissionDenied(
                                    //       context); // Assuming this function also uses Get.dialog
                                    // }
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
print("entetr");

                                    taxController.isEdit.value =
                                    true;
print("1");
                                    taxController.taxUid.value =
                                        taxController
                                            .taxLists[index].id;print("2");
                                    taxController.taxNameController.text =
                                        taxController
                                            .taxLists[index]
                                            .taxName;print("3");
                                    taxController.salesPercentageController.text =
                                        taxController
                                            .taxLists[index]
                                            .salesPrice;print("4");
                                    taxController.purchasePercentageController.text =
                                        taxController
                                            .taxLists[index]
                                            .purchasePrice;print("5");
                                            Get.to(AddTaxMobile());


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
                                  left: 10.0,
                                  right: 10,
                                ),
                                child: ListTile(
                                  title: Text(
                                    taxController
                                        .taxLists[index].taxName,
                                    style: customisedStyle(
                                        context,
                                        Colors.black,
                                        FontWeight.w400,
                                        14.0),
                                  ),
                                )));
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          dividerStyle(),
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
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(const Color(0xffFFF6F2))),
                onPressed: () {
                  Get.to(AddTaxMobile());
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
                        'Add Tax',
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
