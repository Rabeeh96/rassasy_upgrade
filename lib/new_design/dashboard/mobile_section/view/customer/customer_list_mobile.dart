import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/customer_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';

import 'add_customer.dart';

class CustomerListMobile extends StatefulWidget {
  @override
  State<CustomerListMobile> createState() => _CustomerListMobileState();
}

class _CustomerListMobileState extends State<CustomerListMobile> {
  CustomerController customerController = Get.put(CustomerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerController.getCustomerListDetails();
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
          'Customer',
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
                         controller: customerController.searchController,
                        onChanged: (str) {
                          customerController.searchData(str);

                          customerController.getCustomerListDetails();
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
          Expanded(
              child: RefreshIndicator(
            color: Color(0xffF25F29),
            onRefresh: () async {
              customerController.getCustomerListDetails();
            },
            child: Obx(() => customerController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : customerController.customerModelClass.isEmpty
                    ? Center(
                        child: Text(
                        "No Customers to Show",
                        style: customisedStyleBold(
                            context, Colors.black, FontWeight.w400, 14.0),
                      ))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.separated(
                          itemCount:
                              customerController.customerModelClass.length,
                          itemBuilder: (context, index) {
                            ///swipe to delete dismissible
                            return Slidable(
                                key: ValueKey(customerController
                                    .customerModelClass[index]),
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
                                            await checkingPerm("Groupdelete");

                                        if (hasPermission) {
                                          bottomDialogueFunction(
                                              isDismissible: true,
                                              textMsg: "Sure want to delete",
                                              fistBtnOnPressed: () {
                                                Get.back(); // Close the dialog
                                              },
                                              secondBtnPressed: () async {
                                                Get.back(); // Close the dialog
                                                // productGroupController
                                                //     .deleteProduct(
                                                //     productGroupController
                                                //         .productGroupLists[
                                                //     index]
                                                //         .uID);
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
                                        // Get.to(CreateProductGroup(
                                        //   type: "Edit",
                                        //   uid: productGroupController
                                        //       .productGroupLists[index].uID,
                                        // ));
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
                                      leading: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage: customerController
                                            .customerModelClass[index]
                                            .partyImage ==
                                            ''
                                            ? NetworkImage(
                                            'https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                            : NetworkImage(BaseUrl.imageURL +
                                            customerController
                                                .customerModelClass[index].partyImage),
                                      ),
                                      title: Text(
                                        customerController
                                            .customerModelClass[index]
                                            .customerName,
                                        style: customisedStyle(
                                            context,
                                            Colors.black,
                                            FontWeight.w400,
                                            14.0),
                                      ),
                                    )));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              DividerStyle(),
                        ))),
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
                   Get.to(AddCustomerMobile());
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
                        'Add Customer',
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
