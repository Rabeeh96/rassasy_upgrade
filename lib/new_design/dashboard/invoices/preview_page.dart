import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/invoices/invoice_controller_a.dart';

import '../../../Print/bluetoothPrint.dart';

class InvoiceDetailPage extends StatefulWidget {
  InvoiceDetailPage(
      {super.key,
      required this.MasterUID,
      required this.masterType,
      required this.detailID});

  String? MasterUID, masterType, detailID;

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  InvoiceControllerA invoiceControllerA = Get.put(InvoiceControllerA());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceControllerA.getSingleSalesDetails(widget.MasterUID!);
  }

  void _showSelectableListDialog(BuildContext context) {
    final invoiceControllerA = Get.find<InvoiceControllerA>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Return Sale",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              content: SizedBox(
                width: 400,
                height: MediaQuery.of(context).size.height * 0.42,
                child: Obx(() {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Select/Deselect All ',
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.normal, 13.0),
                            ),
                            Checkbox(
                              value: invoiceControllerA.isSelectInvoice.value,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  invoiceControllerA.isSelectInvoice.value =
                                      value;
                                  if (value) {
                                    invoiceControllerA.selectAll();
                                  } else {
                                    invoiceControllerA.deselectAll();
                                  }
                                  setState(
                                      () {}); // Force rebuild of the dialog
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: invoiceControllerA.itemTableList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = invoiceControllerA.itemTableList[index];
                          final isSelected =
                              invoiceControllerA.selectedItems[index] ?? false;
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                // color: Color(0xffc9cc9),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25.0, right: 25, top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item["ProductName"],
                                            style: const TextStyle(
                                              color: Color(0xff0A9EF3),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          Text(
                                            "${item["Qty"]}",
                                            style: const TextStyle(
                                              color: Color(0xffa1a1a1),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) {
                                        invoiceControllerA.toggleSelection(
                                            index, value ?? false);
                                        final selectedItems = invoiceControllerA
                                            .getSelectedItems();
                                        List<int> listOfID = [];
                                        print(
                                            "selectedItems   ${selectedItems}");

                                        for (var item in selectedItems) {
                                          print(
                                              "selectedItems   ${selectedItems}");

                                          print(
                                              'Selected Item - ID: ${item['id']},  mstr ${item['SalesDetailsID']} Name: ${item['ProductName']}');
                                          print(
                                              "DetailId   ${item['SalesDetailsID']}");
                                          listOfID.add(item['SalesDetailsID']);

                                          print(".................");
                                          print(listOfID);
                                          print("............");
                                        }
                                        invoiceControllerA.salesDetailIds
                                            .clear();
                                        invoiceControllerA.salesDetailIds
                                            .addAll(listOfID);

                                        ///
                                        print(
                                            "invoiceControllerA.salesDetailIds...");
                                        print(
                                            invoiceControllerA.salesDetailIds);

                                        setState(
                                            () {}); // Force rebuild of the dialog
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            dividerStyle(),
                      ))
                    ],
                  );
                }),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                    print( "invoiceControllerA.salesDetailIds :  ${invoiceControllerA.salesDetailIds}");
                    invoiceControllerA.createSalesReturn(context);

                  },
                  child: Text(
                    'OK',
                    style: customisedStyle(
                        context, Colors.deepOrange, FontWeight.normal, 13.0),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: customisedStyle(
                        context, Colors.deepOrange, FontWeight.normal, 13.0),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Container(
          color: Color(0xfff1f1f1),
          width: MediaQuery.of(context).size.width / 3,
          child: Obx(() {
            if (invoiceControllerA.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (invoiceControllerA.errorMessage.isNotEmpty) {
              return Center(child: Text(invoiceControllerA.errorMessage.value));
            }
            return ListView(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                /// retuen commented

                Padding(
                  padding: const EdgeInsets.only(right: 23.0, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          child: SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            _showSelectableListDialog(context);
                          },
                          child: Text(
                            'Return',
                            style: customisedStyle(
                                context, Colors.white, FontWeight.w500, 11.0),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 23.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          child: SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0347A1)),
                          onPressed: () {
                            PrintDataDetails.type = "SI";
                            PrintDataDetails.id = widget.MasterUID!;
                            invoiceControllerA.printDetail(
                                widget.MasterUID!, "SI");
                          },
                          child: Text(
                            'print'.tr,
                            style: customisedStyle(
                                context, Colors.white, FontWeight.w500, 11.0),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25),
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Customer Name',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w400, 13.5),
                            ),
                            Text(
                              invoiceControllerA.customerName.value,
                              style: customisedStyle(
                                  context,
                                  const Color(0xff000000),
                                  FontWeight.w400,
                                  16.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Balance',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w400, 13.5),
                            ),
                            RichText(
                              text: TextSpan(
                                //  style: TextStyle(color: Colors.black, fontSize: 36),

                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          "${invoiceControllerA.grand_total.value}",
                                      style: customisedStyle(context,
                                          Colors.black, FontWeight.w400, 16.0)),
                                  TextSpan(
                                      text: invoiceControllerA.currency,
                                      style: customisedStyle(
                                          context,
                                          const Color(0xff7d7d7d),
                                          FontWeight.w400,
                                          13.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice No',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w400, 13.5),
                            ),
                            Text(
                              '# ${invoiceControllerA.voucherNo}',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w400, 14.0),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Invoice Date',
                              style: customisedStyle(
                                  context, Colors.black, FontWeight.w400, 13.5),
                            ),
                            Text(
                              invoiceControllerA.dateText.value,
                              style: customisedStyle(
                                  context,
                                  const Color(0xffA1A1A1),
                                  FontWeight.w400,
                                  14.0),
                            )
                          ],
                        ),
                        invoiceControllerA.place_of_supply.value.isEmpty
                            ? Container()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Place',
                                    style: customisedStyle(context,
                                        Colors.black, FontWeight.w400, 13.5),
                                  ),
                                  Text(
                                    invoiceControllerA.place_of_supply.value,
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff000000),
                                        FontWeight.w400,
                                        14.0),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                dividerStyle(),
                const SizedBox(height: 10),

                ///constraint box remove container hgt
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 20000, minHeight: 30),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: invoiceControllerA.itemTableList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        //  height: MediaQuery.of(context).size.height / 13,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: (index % 2 == 0)
                                  ? [
                                      const Color(0xffE6E6E6),
                                      const Color(0xffE6E6E6)
                                    ]
                                  : [
                                      const Color(0xffffffff),
                                      const Color(0xffffffff)
                                    ]),
                          //   borderRadius: BorderRadius.circular(12.0), // Optional: Add border radius for rounded corners
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25, top: 15, bottom: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 5,
                                    // color: Colors.red,
                                    child: Text(
                                      invoiceControllerA.itemTableList[index]
                                          ["ProductName"],
                                      style: customisedStyle(
                                          context,
                                          const Color(0xff0A9EF3),
                                          FontWeight.w400,
                                          14.0),
                                    ),
                                  ),
                                  //  Container(
                                  // //   color: Colors.green,
                                  //    //width:MediaQuery.of(context).size.width/10,
                                  //    child: Text(
                                  //      "${roundStringWith(invoiceControllerA.itemTableList[index]["UnitPrice"].toString())}   ${invoiceControllerA.currency}",
                                  //      style: customisedStyle(
                                  //          context,
                                  //          const Color(0xff0000000),
                                  //          FontWeight.w400,
                                  //          14.0),
                                  //    ),
                                  //  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        roundStringWith(invoiceControllerA
                                            .itemTableList[index]["Qty"]
                                            .toString()),
                                        style: customisedStyle(
                                            context,
                                            const Color(0xffa1a1a1),
                                            FontWeight.w400,
                                            12.0),
                                      ),
                                      Text(
                                        " * ",
                                        style: customisedStyle(
                                            context,
                                            const Color(0xffa1a1a1),
                                            FontWeight.w400,
                                            14.0),
                                      ),
                                      Text(
                                        "${roundStringWith(invoiceControllerA.itemTableList[index]["UnitPrice"].toString())}",
                                        style: customisedStyle(
                                            context,
                                            const Color(0xffa1a1a1),
                                            FontWeight.w400,
                                            14.0),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${invoiceControllerA.itemTableList[index]["NetAmount"].toString()} ${invoiceControllerA.currency}",
                                    style: customisedStyle(
                                        context,
                                        const Color(0xff0000000),
                                        FontWeight.w400,
                                        14.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                dividerStyle(),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gross Amount",
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0)),
                              Text("Total Tax",
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0)),
                              Text('Discount:',
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 14.0)),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Grand Total",
                                style: TextStyle(
                                    color: Color(0xff1A9C01),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(width: 60),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${roundStringWith(invoiceControllerA.gross_amount.value)} ${invoiceControllerA.currency}",
                                style: customisedStyle(
                                    context,
                                    const Color(0xffA1A1A1),
                                    FontWeight.w400,
                                    15.0),
                              ),
                              Text(
                                "${roundStringWith(invoiceControllerA.total_tax.value)} ${invoiceControllerA.currency}",
                                style: customisedStyle(
                                    context,
                                    const Color(0xffA1A1A1),
                                    FontWeight.w400,
                                    15.0),
                              ),
                              Text(
                                "${roundStringWith(invoiceControllerA.discount_amount.value)} ${invoiceControllerA.currency}",
                                style: customisedStyle(
                                    context,
                                    const Color(0xffA1A1A1),
                                    FontWeight.w400,
                                    15.0),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${roundStringWith(invoiceControllerA.grand_total.value)} ${invoiceControllerA.currency}',
                                style: const TextStyle(
                                    color: Color(0xff1A9C01),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }
}
