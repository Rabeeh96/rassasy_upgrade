import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/invoice_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';

class InvoiceListMobile extends StatefulWidget {
  @override
  State<InvoiceListMobile> createState() => _InvoiceListMobileState();
}

class _InvoiceListMobileState extends State<InvoiceListMobile> {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // invoiceController.viewList(fromDate: invoiceController.apiDateFormat.format(invoiceController.fromDateNotifier.value), toDate: invoiceController.apiDateFormat.format(invoiceController.fromDateNotifier.value));
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
          'Invoice',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Column(
        children: [
          DividerStyle(),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                  valueListenable: invoiceController.fromDateNotifier,
                  builder: (BuildContext ctx, DateTime fromDateNewValue, _) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xffCBCBCB))),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),
                              Text(
                                  invoiceController.dateFormat
                                      .format(fromDateNewValue),
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w700, 12.0)),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showDatePickerFunction(
                            context, invoiceController.fromDateNotifier);
                        print(
                            "invoiceController.fromDateNotifier ${invoiceController.fromDateNotifier}");
                        print("c ${fromDateNewValue}");
                        print(
                            "c ${invoiceController.apiDateFormat.format(fromDateNewValue)}");
                        invoiceController.viewList(
                            fromDate: invoiceController.apiDateFormat
                                .format(fromDateNewValue),
                            toDate: invoiceController.apiDateFormat.format(
                                invoiceController.toDateNotifier.value));
                      },
                    );
                  }),
              SizedBox(
                width: 20,
              ),
              ValueListenableBuilder(
                  valueListenable: invoiceController.toDateNotifier,
                  builder: (BuildContext ctx, DateTime toDateNewValue, _) {
                    return GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(color: const Color(0xffCBCBCB))),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.black,
                              ),
                              Text(
                                  invoiceController.dateFormat
                                      .format(toDateNewValue),
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w700, 12.0)),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showDatePickerFunction(
                            context, invoiceController.toDateNotifier);
                        invoiceController.viewList(
                            fromDate: invoiceController.apiDateFormat.format(
                                invoiceController.fromDateNotifier.value),
                            toDate: invoiceController.apiDateFormat
                                .format(toDateNewValue));
                      },
                    );
                  }),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          DividerStyle(),
          Expanded(
              child: RefreshIndicator(
            color: Color(0xffF25F29),
            onRefresh: () async {
              invoiceController.viewList(
                  fromDate: invoiceController.apiDateFormat
                      .format(invoiceController.fromDateNotifier.value),
                  toDate: invoiceController.apiDateFormat
                      .format(invoiceController.fromDateNotifier.value));
            },
            child: Obx(() => invoiceController.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF25F29),
                  ))
                : invoiceController.invoiceList.isEmpty
                    ? Center(
                        child: Text(
                        "No invoices",
                        style: customisedStyleBold(
                            context, Colors.black, FontWeight.w400, 14.0),
                      ))
                    : SlidableAutoCloseBehavior(
                        closeWhenOpened: true,
                        child: ListView.separated(
                          itemCount: invoiceController.invoiceList.length,
                          itemBuilder: (context, index) {
                            ///swipe to delete dismissible
                            return Slidable(
                                key: ValueKey(
                                    invoiceController.invoiceList[index]),
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
                                        invoiceController.printDetail(
                                            type: "SO");
                                      },
                                      // onPressed: doNothing ,
                                      backgroundColor: Colors.blueAccent,
                                      foregroundColor: Colors.white,
                                      icon: Icons.print,
                                      label: 'Print',
                                    ),
                                  ],
                                ),

                                // The end action pane is the one at the right or the bottom side.

                                // The child of the Slidable is what the user sees when the
                                // component is not dragged.
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      top: 10,
                                      bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              invoiceController
                                                  .invoiceList[index].voucherNo,
                                              style: customisedStyle(
                                                  context,
                                                  Color(0xffA5A5A5),
                                                  FontWeight.w400,
                                                  14.0),
                                            ),
                                            Text(
                                              invoiceController
                                                  .invoiceList[index].custName,
                                              style: customisedStyle(
                                                  context,
                                                  Color(0xff000000),
                                                  FontWeight.w400,
                                                  14.0),
                                            ),
                                          ]),
                                      Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'token_no'.tr,
                                                  style: customisedStyle(
                                                      context,
                                                      Color(0xff9A9A9A),
                                                      FontWeight.w600,
                                                      12.0),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    invoiceController
                                                        .invoiceList[index]
                                                        .tokenNo,
                                                    style: customisedStyle(
                                                        context,
                                                        Color(0xffA5A5A5),
                                                        FontWeight.w400,
                                                        14.0),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "${invoiceController.currency} ${roundStringWith(invoiceController.invoiceList[index].netTotal)}",
                                              style: customisedStyle(
                                                  context,
                                                  Color(0xff000000),
                                                  FontWeight.w400,
                                                  14.0),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              DividerStyle(),
                        ))),
          )),
        ],
      ),
    );
  }
}
