import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/flavour_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'dart:io' show Platform;
class FlavourListMobile extends StatefulWidget {
  @override
  State<FlavourListMobile> createState() => _FlavourListMobileState();
}

class _FlavourListMobileState extends State<FlavourListMobile> {
  FlavourController flavourController = Get.put(FlavourController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flavourController.fetchFlavours();
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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Flavour'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
        ),
      ),
      body: Column(
        children: [
          dividerStyleFull(),
          SizedBox(height: 20,),
          // Container(
          //     margin: const EdgeInsets.only(
          //       left: 15,
          //       right: 10,
          //     ),
          //     height: MediaQuery.of(context).size.height * .055,
          //     child: Row(
          //       children: <Widget>[
          //         Expanded(
          //           child: TextField(
          //               autofocus: false,
          //               textCapitalization: TextCapitalization.words,
          //               controller: flavourController.searchController,
          //               onChanged: (str) {
          //                 // flavourController.searchData(str);
          //                 // flavourController.customerModelClass.clear();
          //                 flavourController.fetchFlavours();
          //               },
          //               style: customisedStyle(
          //                   context, Colors.black, FontWeight.normal, 15.0),
          //               decoration: InputDecoration(
          //                   filled: true,
          //                   fillColor: Color(0xffFBFBFB),
          //                   hintText: "Search",
          //                   hintStyle: customisedStyle(
          //                       context,
          //                       const Color(0xff929292),
          //                       FontWeight.normal,
          //                       15.0),
          //                   contentPadding: const EdgeInsets.only(
          //                       left: 10.0, bottom: 10, top: 8),
          //                   border: InputBorder.none)),
          //         ),
          //         IconButton(
          //           icon: SvgPicture.asset(
          //             'assets/svg/search-normal.svg',
          //             color: Color(0xffB4B4B4),
          //             width: MediaQuery.of(context).size.width * .02,
          //             height: MediaQuery.of(context).size.height * .02,
          //           ),
          //           onPressed: () {
          //             //Get.to(SearchItems());
          //           },
          //         ),
          //       ],
          //     )),
          // DividerStyle(),
          Expanded(
              child: RefreshIndicator(
            color: Color(0xffF25F29),
            onRefresh: () async {
              flavourController.fetchFlavours();
            },
            child: Obx(() => flavourController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : flavourController.flavourList.isEmpty
                    ? Center(
                        child: Text(
                        "No Flavours to Show",
                        style: customisedStyleBold(
                            context, Colors.black, FontWeight.w400, 14.0),
                      ))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.separated(
                          itemCount: flavourController.flavourList.length,
                          itemBuilder: (context, index) {
                            ///swipe to delete dismissible
                            return Slidable(
                                key: ValueKey(
                                    flavourController.flavourList[index]),
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
                                        bool hasPermission =
                                            await checkingPerm("Flavourdelete");

                                        if (hasPermission) {
                                          bottomDialogueFunction(
                                              isDismissible: true,
                                              textMsg: "Sure want to delete",
                                              fistBtnOnPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              secondBtnPressed: () async {
                                                flavourController
                                                    .deleteFlavourApi(
                                                    flavourController
                                                        .flavourList[
                                                    index]
                                                        .id);
                                              },
                                              secondBtnText: 'Ok',
                                              context: context);
                                        } else {
                                          dialogBoxPermissionDenied(
                                              context); // Assuming this function also uses Get.dialog
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
                                        bool hasPermission =
                                            await checkingPerm("Flavouredit");
                                        if (hasPermission) {
                                          setState(() {
                                            flavourController.isEdit.value =
                                                true;
                                            flavourController.flavourID.value =
                                                flavourController
                                                    .flavourList[index]
                                                    .flavourID;
                                            flavourController.flavourUID.value =
                                                flavourController
                                                    .flavourList[index].id;
                                            flavourController.flavourName.text =
                                                flavourController
                                                    .flavourList[index]
                                                    .flavourName;
                                            addFlavour();
                                          });
                                        } else {
                                          dialogBoxPermissionDenied(context);
                                        }
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
                                        flavourController
                                            .flavourList[index].flavourName,
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
                  addFlavour();
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
                        'Add Flavour',
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

  void addFlavour() {
    Get.bottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          // Set border radius to the top left corner
          topRight: Radius.circular(
              10.0), // Set border radius to the top right corner
        ),
      ),
      backgroundColor: Colors.white,
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Flavour',
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            dividerStyleFull(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: flavourController.flavourName,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w400, 14.0),
                  // focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(
                      hintTextStr: 'Flavour Name'),
                ),
              ),
            ),
            Padding(
              padding:   EdgeInsets.only(
                  left: 20.0, right: 20, bottom:Platform.isIOS ? 25:16, top: 5),
              child: Container(
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffF25F29)),
                  ),
                  onPressed: () {
                    if (flavourController.flavourName.text == "") {
                      dialogBox(context, "Please enter flavour name");
                    } else {
                      if (flavourController.isEdit.value) {
                        flavourController.createFlavour(
                            "Edit", flavourController.flavourUID.value);
                      } else {
                        flavourController.createFlavour("Create", "0");
                      }
                    }
                  },
                  child: Text(
                    'save'.tr,
                    style: customisedStyle(
                        context, Colors.white, FontWeight.w400, 15.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
