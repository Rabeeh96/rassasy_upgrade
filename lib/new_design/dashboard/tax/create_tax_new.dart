import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../global/textfield_decoration.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/global/global.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

///tax type not set
///

class AddTax extends StatefulWidget {
  @override
  State<AddTax> createState() => _AddTaxState();
}

class _AddTaxState extends State<AddTax> {
  TextEditingController taxNameController = TextEditingController();
  TextEditingController salesPercentController = TextEditingController();
  TextEditingController purchasePercentController = TextEditingController();
  FocusNode taxNameFcNode = FocusNode();
  FocusNode salesFcNode = FocusNode();
  FocusNode purchaseFcNode = FocusNode();
  FocusNode saveFCNode = FocusNode();
  TextEditingController controller = TextEditingController();

  bool isAddTax = false;
  bool editTax = false;
  bool networkConnection = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTax();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F3F3),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
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
              'tax'.tr,
              style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: networkConnection == true ? taxDetailPage() : noNetworkConnectionPage(),
      bottomNavigationBar: bottomBar(),
    );
  }

  onSearchTextChanged(String text) async {
    searchTaxList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    taxLists.forEach((userDetail) {
      if (userDetail.taxName.toLowerCase().contains(text.toLowerCase())) searchTaxList.add(userDetail);
    });

    setState(() {});
  }

  Widget taxDetailPage() {
    return Row(
      children: [
        isAddTax == false ? taxAddPage() : createTaxPage(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffF8F8F8)),
          ),
          width: MediaQuery.of(context).size.width / 3,
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 11,
                color: const Color(0xffFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    onChanged: onSearchTextChanged,
                    decoration: TextFieldDecoration.searchField(hintTextStr: 'search'.tr),
                  ),
                ),
              ),

              //
              // ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: taxLists.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Dismissible(
              //         key: Key('${taxLists[index]}'),
              //         background: Container(
              //           color: Colors.red,
              //           child: Padding(
              //             padding: const EdgeInsets.all(15),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: const <Widget>[
              //                 Icon(Icons.delete, color: Colors.white),
              //               ],
              //             ),
              //           ),
              //         ),
              //         secondaryBackground: Container(),
              //         confirmDismiss: (DismissDirection direction) async {
              //           return await showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 title: Text(
              //                   'delete_msg'.tr,
              //                   style: TextStyle(fontSize: 14),
              //                 ),
              //                 content: Text(
              //                     'msg4'.tr,
              //                     style: TextStyle(fontSize: 14)),
              //                 actions: <Widget>[
              //                   TextButton(
              //                       onPressed: () => {
              //                             TaxData.taxUid = taxLists[index].id,
              //                             Navigator.of(context).pop(),
              //                             deleteAnItem()
              //                           },
              //                       child: Text(
              //                         "Delete",
              //                         style: TextStyle(color: Colors.red),
              //                       )),
              //                   TextButton(
              //                     onPressed: () =>
              //                         {Navigator.of(context).pop()},
              //                     child: Text("Cancel", style: TextStyle()),
              //                   ),
              //                 ],
              //               );
              //             },
              //           );
              //         },
              //         direction: taxLists.length > 1
              //             ? DismissDirection.startToEnd
              //             : DismissDirection.none,
              //         onDismissed: (DismissDirection direction) {
              //           if (direction == DismissDirection.endToStart) {
              //             print('Remove item');
              //           } else {
              //             print("");
              //           }
              //
              //           setState(() {
              //             taxLists.removeAt(index);
              //           });
              //         },
              //         child: Card(
              //           child: ListTile(
              //               onTap: () {
              //                 TaxData.taxUid = taxLists[index].id;
              //                 editTax = true;
              //                 setState(() {
              //                   getSingleView();
              //                   isAddTax = true;
              //                 });
              //               },
              //               title: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         taxLists[index].taxName,
              //                         style: TextStyle(
              //                             fontSize: 15,
              //                             color: Color(0xff000000),
              //                             fontWeight: FontWeight.w600),
              //                       ),
              //                       Text(
              //                         taxLists[index].salesPrice,
              //                         style: TextStyle(
              //                             fontSize: 13,
              //                             color: Color(0xff565656)),
              //                       ),
              //                     ],
              //                   ),
              //                   Text(
              //                     taxLists[index].purchasePrice,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Color(0xff565656)),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       );
              //     }),
              Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: searchTaxList.isNotEmpty || controller.text.isNotEmpty
                    ? searchTaxList.isEmpty
                        ? const NoItemFound()
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: searchTaxList.length,
                            itemBuilder: (BuildContext context, i) {
                              return Dismissible(
                                key: Key('${searchTaxList[i]}'),
                                background: Container(
                                  color: Colors.red,
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(Icons.delete, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(),
                                confirmDismiss: (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'delete_msg'.tr,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        content: Text('msg4'.tr, style: const TextStyle(fontSize: 14)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => {TaxData.taxUid = searchTaxList[i].id, Navigator.of(context).pop(), deleteAnItem()},
                                              child: Text(
                                                'dlt'.tr,
                                                style: const TextStyle(color: Colors.red),
                                              )),
                                          TextButton(
                                            onPressed: () => {Navigator.of(context).pop()},
                                            child: Text('cancel'.tr, style: const TextStyle()),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: searchTaxList.length > 0 ? DismissDirection.startToEnd : DismissDirection.none,
                                onDismissed: (DismissDirection direction) {
                                  if (direction == DismissDirection.endToStart) {
                                    print('Remove item');
                                  } else {
                                    print("");
                                  }

                                  setState(() {
                                    searchTaxList.removeAt(i);
                                  });
                                },
                                child: Card(
                                  child: ListTile(
                                      onTap: () {
                                        TaxData.taxUid = searchTaxList[i].id;
                                        editTax = true;
                                        setState(() {
                                          getSingleView();
                                          isAddTax = true;
                                        });
                                      },
                                      title: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                searchTaxList[i].taxName,
                                                style: const TextStyle(fontSize: 15, color: Color(0xff000000), fontWeight: FontWeight.w600),
                                              ),
                                              Text(
                                                searchTaxList[i].salesPrice,
                                                style: const TextStyle(fontSize: 13, color: Color(0xff565656)),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            searchTaxList[i].purchasePrice,
                                            style: const TextStyle(fontSize: 13, color: Color(0xff565656)),
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            })
                    : taxLists.isEmpty
                        ? const NoData()
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: taxLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Dismissible(
                                key: Key('${taxLists[index]}'),
                                background: Container(
                                  color: Colors.red,
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(Icons.delete, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(),
                                confirmDismiss: (DismissDirection direction) async {
                                  return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'delete_msg'.tr,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        content: Text('msg4'.tr, style: const TextStyle(fontSize: 14)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => {TaxData.taxUid = taxLists[index].id, Navigator.of(context).pop(), deleteAnItem()},
                                              child: Text(
                                                'dlt'.tr,
                                                style: const TextStyle(color: Colors.red),
                                              )),
                                          TextButton(
                                            onPressed: () => {Navigator.of(context).pop()},
                                            child: Text('cancel'.tr, style: const TextStyle()),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                direction: taxLists.length > 0 ? DismissDirection.startToEnd : DismissDirection.none,
                                onDismissed: (DismissDirection direction) {
                                  if (direction == DismissDirection.endToStart) {
                                    print('Remove item');
                                  } else {
                                    print("");
                                  }

                                  setState(() {
                                    taxLists.removeAt(index);
                                  });
                                },
                                child: Card(
                                  child: ListTile(
                                      onTap: () {
                                        TaxData.taxUid = taxLists[index].id;
                                        editTax = true;
                                        setState(() {
                                          getSingleView();
                                          isAddTax = true;
                                        });
                                      },
                                      title: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            taxLists[index].taxName,
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 12.5),

                                            // style: TextStyle(
                                            //     fontSize: 15,
                                            //     color: Color(0xff000000),
                                            //     fontWeight: FontWeight.w400),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                taxLists[index].purchasePrice,
                                                style: const TextStyle(fontSize: 13, color: Color(0xff565656)),
                                              ),
                                              Text(
                                                taxLists[index].salesPrice,
                                                style: customisedStyle(context, const Color(0xff565656), FontWeight.w400, 10.5),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            }),
              )
              // searchTaxList.length != 0 || controller.text.isNotEmpty
              //      ? searchTaxList.isEmpty
              //      ?  NoItemFound()
              //      :  ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: searchTaxList.length,
              //     itemBuilder: (BuildContext context, i) {
              //       return Dismissible(
              //         key: Key('${searchTaxList[i]}'),
              //         background: Container(
              //           color: Colors.red,
              //           child: Padding(
              //             padding: const EdgeInsets.all(15),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: const <Widget>[
              //                 Icon(Icons.delete, color: Colors.white),
              //               ],
              //             ),
              //           ),
              //         ),
              //         secondaryBackground: Container(),
              //         confirmDismiss: (DismissDirection direction) async {
              //           return await showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 title: Text(
              //                   'delete_msg'.tr,
              //                   style: TextStyle(fontSize: 14),
              //                 ),
              //                 content: Text(
              //                     'msg4'.tr,
              //                     style: TextStyle(fontSize: 14)),
              //                 actions: <Widget>[
              //                   TextButton(
              //                       onPressed: () => {
              //                         TaxData.taxUid = searchTaxList[i].id,
              //                         Navigator.of(context).pop(),
              //                         deleteAnItem()
              //                       },
              //                       child: Text(
              //                         "Delete",
              //                         style: TextStyle(color: Colors.red),
              //                       )),
              //                   TextButton(
              //                     onPressed: () =>
              //                     {Navigator.of(context).pop()},
              //                     child: Text("Cancel", style: TextStyle()),
              //                   ),
              //                 ],
              //               );
              //             },
              //           );
              //         },
              //         direction: searchTaxList.length > 0
              //             ? DismissDirection.startToEnd
              //             : DismissDirection.none,
              //         onDismissed: (DismissDirection direction) {
              //           if (direction == DismissDirection.endToStart) {
              //             print('Remove item');
              //           } else {
              //             print("");
              //           }
              //
              //           setState(() {
              //             searchTaxList.removeAt(i);
              //           });
              //         },
              //         child: Card(
              //           child: ListTile(
              //               onTap: () {
              //                 TaxData.taxUid = searchTaxList[i].id;
              //                 editTax = true;
              //                 setState(() {
              //                   getSingleView();
              //                   isAddTax = true;
              //                 });
              //               },
              //               title: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         searchTaxList[i].taxName,
              //                         style: TextStyle(
              //                             fontSize: 15,
              //                             color: Color(0xff000000),
              //                             fontWeight: FontWeight.w600),
              //                       ),
              //                       Text(
              //                         searchTaxList[i].salesPrice,
              //                         style: TextStyle(
              //                             fontSize: 13,
              //                             color: Color(0xff565656)),
              //                       ),
              //                     ],
              //                   ),
              //                   Text(
              //                     searchTaxList[i].purchasePrice,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Color(0xff565656)),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       );
              //     })
              //      : taxLists.isEmpty
              //      ? NoData()
              //      :  ListView.builder(
              //     scrollDirection: Axis.vertical,
              //
              //     physics: const AlwaysScrollableScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: taxLists.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Dismissible(
              //         key: Key('${taxLists[index]}'),
              //         background: Container(
              //           color: Colors.red,
              //           child: Padding(
              //             padding: const EdgeInsets.all(15),
              //             child: Row(
              //               mainAxisAlignment: MainAxisAlignment.end,
              //               children: const <Widget>[
              //                 Icon(Icons.delete, color: Colors.white),
              //               ],
              //             ),
              //           ),
              //         ),
              //         secondaryBackground: Container(),
              //         confirmDismiss: (DismissDirection direction) async {
              //           return await showDialog(
              //             context: context,
              //             builder: (BuildContext context) {
              //               return AlertDialog(
              //                 title: Text(
              //                   'delete_msg'.tr,
              //                   style: TextStyle(fontSize: 14),
              //                 ),
              //                 content: Text(
              //                     'msg4'.tr,
              //                     style: TextStyle(fontSize: 14)),
              //                 actions: <Widget>[
              //                   TextButton(
              //                       onPressed: () => {
              //                         TaxData.taxUid = taxLists[index].id,
              //                         Navigator.of(context).pop(),
              //                         deleteAnItem()
              //                       },
              //                       child: Text(
              //                         "Delete",
              //                         style: TextStyle(color: Colors.red),
              //                       )),
              //                   TextButton(
              //                     onPressed: () =>
              //                     {Navigator.of(context).pop()},
              //                     child: Text("Cancel", style: TextStyle()),
              //                   ),
              //                 ],
              //               );
              //             },
              //           );
              //         },
              //         direction: taxLists.length > 0
              //             ? DismissDirection.startToEnd
              //             : DismissDirection.none,
              //         onDismissed: (DismissDirection direction) {
              //           if (direction == DismissDirection.endToStart) {
              //             print('Remove item');
              //           } else {
              //             print("");
              //           }
              //
              //           setState(() {
              //             taxLists.removeAt(index);
              //           });
              //         },
              //         child: Card(
              //           child: ListTile(
              //               onTap: () {
              //                 TaxData.taxUid = taxLists[index].id;
              //                 editTax = true;
              //                 setState(() {
              //                   getSingleView();
              //                   isAddTax = true;
              //                 });
              //               },
              //               title: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text(
              //                         taxLists[index].taxName,
              //                         style: TextStyle(
              //                             fontSize: 15,
              //                             color: Color(0xff000000),
              //                             fontWeight: FontWeight.w600),
              //                       ),
              //                       Text(
              //                         taxLists[index].salesPrice,
              //                         style: TextStyle(
              //                             fontSize: 13,
              //                             color: Color(0xff565656)),
              //                       ),
              //                     ],
              //                   ),
              //                   Text(
              //                     taxLists[index].purchasePrice,
              //                     style: TextStyle(
              //                         fontSize: 13, color: Color(0xff565656)),
              //                   ),
              //                 ],
              //               )),
              //         ),
              //       );
              //     }),
            ],
          ),
        )
      ],
    );
  }

  Widget createTaxPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 2.4,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: editTax == true
                          ? Text(
                              'edit_tax'.tr,
                              style: const TextStyle(fontSize: 20),
                            )
                          : Text(
                              'add_tax'.tr,
                              style: const TextStyle(fontSize: 20),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'tax_name'.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextField(
                            controller: taxNameController,
                            focusNode: taxNameFcNode,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(salesFcNode);
                            },
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'sale_percent'.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextField(
                            controller: salesPercentController,
                            focusNode: salesFcNode,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(purchaseFcNode);
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                            ],
                            textCapitalization: TextCapitalization.words,
                            decoration: TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 5,
                          child: Text(
                            'purchase_percent'.tr,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 4,
                          child: TextField(
                            controller: purchasePercentController,
                            focusNode: purchaseFcNode,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(saveFCNode);
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                            ],
                            textCapitalization: TextCapitalization.words,
                            decoration: TextFieldDecoration.customerMandatoryField(hintTextStr: ''),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ],
      ),
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
          const SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              getAllTax();
              // defaultData();
            },
            child: Text('retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }

  Widget taxAddPage() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            height: MediaQuery.of(context).size.height / 1.9,
            child: ListView(
              children: [
                SvgPicture.asset('assets/svg/tax_refersh.svg'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        'select_tax'.tr,
                        style: const TextStyle(fontSize: 25),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 12,
                      child: Text(
                        'or'.tr,
                        style: const TextStyle(fontSize: 20, color: Color(0xff949494)),
                      )),
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
          setState(() {
            isAddTax = true;
            editTax = false;
            clearData();
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 7,
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
                decoration: BoxDecoration(border: Border.all(color: const Color(0xffffffff)), shape: BoxShape.circle),
                height: MediaQuery.of(context).size.height / 22,
                width: MediaQuery.of(context).size.width / 22,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              Text(
                'add_tax'.tr,
                style: const TextStyle(color: Color(0xffffffff)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: MediaQuery.of(context).size.height / 12,
      child: isAddTax == true
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
                                  isAddTax = false;
                                });
                                editTax = false;
                                clearData();
                              }),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 16,
                          height: MediaQuery.of(context).size.height / 12,
                          child: IconButton(
                              focusNode: saveFCNode,
                              icon: SvgPicture.asset('assets/svg/add1.svg'),
                              onPressed: () {
                                if (taxNameController.text.trim() == '' ||
                                    salesPercentController.text == ' ' ||
                                    purchasePercentController.text == '') {
                                  dialogBox(context, 'Please fill mandatory field');
                                } else {
                                  editTax == true ? editTaxDetail() : createTax();
                                }
                              }),
                        )
                      ],
                    )),
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
                                editTax = false;
                              });
                              clearData();
                            }),
                      )
                    ],
                  ),
                ),
              ],
            )
          : const Row(),
    );
  }

  ///to clear the fields
  clearData() {
    taxNameController.clear();
    salesPercentController.clear();
    purchasePercentController.clear();
  }

  ///list tax
  Future<Null> getAllTax() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        networkConnection = false;
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

        String baseUrl = BaseUrl.baseUrl;

        var priceRounding = BaseUrl.priceRounding;

        final String url = '$baseUrl/taxCategories/taxCategories/';

        Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "PriceRounding": priceRounding};
        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        print(status);

        var responseJson = n["data"];
        print(responseJson);

        print(status);
        if (status == 6000) {
          setState(() {
            taxLists.clear();

            stop();
            networkConnection = true;
            for (Map user in responseJson) {
              taxLists.add(TaxModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          networkConnection = true;
          stop();
          // var msg = n["error"];
          // dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  ///create new tax
  Future<Null> createTax() async {
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

        var taxType = 6;

        var checkVat = prefs.getBool("checkVat") ?? false;

        var checkGst = prefs.getBool("check_GST") ?? false;

        if (checkVat == true) {
          taxType = 1;
        } else if (checkGst == true) {
          taxType = 2;
        } else {
          taxType = 6;
        }

        final String url = '$baseUrl/taxCategories/create-taxCategory/';

        print(url);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
          "TaxName": taxNameController.text,
          "SalesTax": salesPercentController.text,
          "PurchaseTax": purchasePercentController.text,
          "TaxType": taxType,
          "Inclusive": false
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

        if (status == 6000) {
          setState(() {
            taxLists.clear();
            taxNameController.clear();
            salesPercentController.clear();
            purchasePercentController.clear();
            stop();
            isAddTax = false;
            getAllTax();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);
          stop();
        } else {}
      } catch (e) {
        dialogBox(context, "Some thing went wrong");
        stop();
      }
    }
  }

  ///single view of tax
  Future<Null> getSingleView() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
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
        String baseUrl = BaseUrl.baseUrl;

        var uID = TaxData.taxUid;
        print(uID);
        print("uid");
        var priceRounding = BaseUrl.priceRounding;

        final url = '$baseUrl/taxCategories/view/taxCategory/$uID/';
        print(url);
        Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID, "PriceRounding": priceRounding};

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
        if (status == 6000) {
          setState(() {
            stop();
            taxNameController.text = responseJson['TaxName'];
            purchasePercentController.text = responseJson['PurchaseTax'];
            salesPercentController.text = responseJson['SalesTax'];
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"];
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  ///edit tax detail
  Future<Null> editTaxDetail() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
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
        String baseUrl = BaseUrl.baseUrl;

        var uID = TaxData.taxUid;
        final url = '$baseUrl/taxCategories/edit/taxCategory/$uID/';

        print(url);

        Map data = {
          "CreatedUserID": userID,
          "CompanyID": companyID,
          "BranchID": branchID,
          "TaxName": taxNameController.text,
          "SalesTax": salesPercentController.text,
          "PurchaseTax": purchasePercentController.text,
          "TaxType": 2,
          "Inclusive": false
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
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        print(status);
        if (status == 6000) {
          setState(() {
            taxLists.clear();
            stop();
            isAddTax = false;
            getAllTax();
          });
        } else if (status == 6001) {
          var msg = n["message"];
          print(dialogBox(context, msg));

          stop();
        } else {}
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Some thing went wrong"));
          stop();
        });
      }
    }
  }

  ///delete tax
  Future<Null> deleteAnItem() async {
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
        var uID = TaxData.taxUid;
        final String url = '$baseUrl/taxCategories/delete/taxCategory/$uID/';
        print(url);

        Map data = {"CreatedUserID": userID, "CompanyID": companyID, "BranchID": branchID};
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
            controller.clear();
            searchTaxList.clear();
            editTax = false;
            clearData();
            taxLists.clear();
            stop();
            FocusScope.of(context).requestFocus(saveFCNode);
            getAllTax();
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"];
          dialogBox(context, msg);
        } else {}
      } catch (e) {
        setState(() {
          dialogBox(context, "Some thing went wrong");
          stop();
        });
      }
    }
  }
}

List<TaxModel> searchTaxList = [];
List<TaxModel> taxLists = [];

class TaxModel {
  String taxName, type, id, salesPrice, purchasePrice;

  TaxModel({required this.taxName, required this.type, required this.id, required this.purchasePrice, required this.salesPrice});

  factory TaxModel.fromJson(Map<dynamic, dynamic> json) {
    return TaxModel(
        type: json['TaxType'],
        taxName: json['TaxName'],
        id: json['id'],
        purchasePrice: json['PurchaseTax'].toString(),
        salesPrice: json['SalesTax'].toString());
  }
}

class TaxData {
  static String taxUid = '';
}
