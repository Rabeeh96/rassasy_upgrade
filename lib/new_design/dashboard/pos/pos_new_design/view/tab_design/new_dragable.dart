import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../global/global.dart';
import '../../controller/draggable_controller.dart';

class TableSettings extends StatefulWidget {
  const TableSettings({super.key});

  @override
  State<TableSettings> createState() => _TableSettingsState();
}

class _TableSettingsState extends State<TableSettings> {
  final DragAndDropController tableListController =
  Get.put(DragAndDropController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableListController.fetchAllData();
  }

  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "Table Setting",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
        ),
        actions:   [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Count of Row", style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0)),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xffD7D7D7), width: .5),
                              borderRadius: const BorderRadius.all(Radius.circular(8))),
                          height: MediaQuery.of(context).size.height / 23, //height of button
                          width: MediaQuery.of(context).size.width / 9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 40,
                                height: MediaQuery.of(context).size.height / 22,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (tableListController.rowCountGridView <= 1) {
                                      } else {
                                        tableListController.rowCountGridView = tableListController.rowCountGridView - 1;
                                        tableListController.rowCountController.text = "${tableListController.rowCountGridView}";
                                      }
                                    });
                                  },
                                  child: InkWell(child: SvgPicture.asset('assets/svg/minus_mob.svg')),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: Color(0xffD7D7D7), width: .5),
                                        right: BorderSide(color: Color(0xffD7D7D7), width: .5))),
                                width: MediaQuery.of(context).size.width / 20,
                                child: TextField(
                                  readOnly: true,
                                  controller: tableListController.rowCountController,
                                  textAlign: TextAlign.center,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 11.00),
                                  onChanged: (text) async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();

                                    if (text.isNotEmpty) {
                                      tableListController.rowCountGridView = int.parse(text);
                                      tableListController.groupNameFontSizeController.text = "${orderController.rowCountGridView}";
                                      prefs.setInt('count_of_row', orderController.rowCountGridView);
                                    } else {}
                                  },
                                  decoration: const InputDecoration(
                                      hintText: '0.0', isDense: true, contentPadding: EdgeInsets.all(6), border: InputBorder.none),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 40,
                                child: GestureDetector(
                                    onTap: () {
                                      if (orderController.rowCountGridView == 5) {
                                      } else {
                                        setState(() {
                                          orderController.rowCountGridView = orderController.rowCountGridView + 1;
                                          orderController.rowCountController.text = "${orderController.rowCountGridView}";
                                        });
                                      }
                                    },
                                    child: InkWell(
                                      child: Center(child: SvgPicture.asset('assets/svg/plus_mob.svg')),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                TextButton(
                  onPressed: () {
                    tableListController.heightdesc();
                  },
                  child: const Text("-"),
                ),
                Obx(
                      () => Text(
                        tableListController.tableheight.value.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    tableListController.heightinc();
                  },
                  child: const Text("+"),
                ),
              ],
            ),
          ),

          TextButton(
              onPressed: () {
                tableListController.widthdesc();
              },
              child: const Text("-")),
          Obx(
                () => Text(tableListController.tablewidth.value.toStringAsFixed(1)),
          ),
          TextButton(
              onPressed: () {
                tableListController.widthinc();
              },
              child: const Text("+")),

        ],
      ),
      body: Obx(() {
        final generatedChildren = List.generate(
            tableListController.tableMergeData.length,
                (index) => Container(
                    key: Key(tableListController.tableMergeData[index]['id'].toString()),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Color(0xffE9E9E9), width: 1),
                              right: BorderSide(color: Color(0xffE9E9E9), width: 1),
                              bottom: BorderSide(color: Color(0xffE9E9E9), width: 1),
                              top: BorderSide(color: Color(0xffE9E9E9), width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                color: tableListController.getBackgroundColor(tableListController.tableMergeData[index]["Status"]),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width * 0.02,
                                child: Center(
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: Text(
                                      tableListController.tableMergeData[index]["Status"]!,
                                      style: customisedStyle(context, Colors.white, FontWeight.w400, 14.0),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GridTile(
                                  footer: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          tableListController.tableMergeData[index]["Split_data"]!.isNotEmpty
                                              ? Padding(
                                            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                                            child: SizedBox(
                                                height: 50,
                                                child: checkWidgetNew(
                                                    splitData: tableListController.tableMergeData[index]["Split_data"])),
                                          )
                                              : Container(),
                                          // Padding(
                                          //   padding:
                                          //       const EdgeInsets.all(
                                          //           10.0),
                                          //   child: Container(
                                          //     decoration: BoxDecoration(
                                          //         borderRadius:
                                          //             BorderRadius
                                          //                 .circular(
                                          //                     4),
                                          //         color: (_getBackgroundColor(
                                          //             posController
                                          //                 .tableMergeData[
                                          //                     index]
                                          //                 .status))),
                                          //     child: Center(
                                          //       child: Padding(
                                          //         padding:
                                          //             const EdgeInsets
                                          //                 .all(8.0),
                                          //         child: Text(
                                          //           posController
                                          //               .tableMergeData[
                                          //                   index]
                                          //               .status!,
                                          //           style:
                                          //               const TextStyle(
                                          //             color: Colors
                                          //                 .white,
                                          //             fontWeight:
                                          //                 FontWeight
                                          //                     .w500,
                                          //             fontSize: 14.0,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  header: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                tableListController.tableMergeData[index]["TableName"] ?? '',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16.0,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            ),

                                              // : IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),

                                          ],
                                        ),
                                        Text(
                                          tableListController.returnOrderTime(tableListController.tableMergeData[index]["OrderTime"]!,
                                              tableListController.tableMergeData[index]["Status"]!),
                                          style: customisedStyle(context, const Color(0xff828282), FontWeight.w400, 12.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: tableListController.tableMergeData[index]["Split_data"]!.isNotEmpty
                                        ? Container()
                                        : Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        tableListController.returnOrderTime(tableListController.tableMergeData[index]["OrderTime"]!,
                                            tableListController.tableMergeData[index]["Status"]!) !=
                                            ""
                                            ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "To be paid:",
                                              style: TextStyle(
                                                color: Color(0xff757575),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10.0,
                                              ),
                                            ),
                                          ],
                                        )
                                            : Container(),
                                        tableListController.tableMergeData[index]["Status"]== "Vacant"
                                            ? const Text("")
                                            : Text(
                                          "${tableListController.currency} ${roundStringWith(tableListController.tableMergeData[index]["Status"] != "Vacant" ? tableListController.tableMergeData[index]["Status"] != "Paid" ? tableListController.tableMergeData[index]["SalesOrderGrandTotal"].toString() : tableListController.tableMergeData[index]["SalesGrandTotal"].toString() : '0')}",
                                          style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))));
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ReorderableBuilder(
            scrollController: _scrollController,
            enableLongPress: true,
            onReorder: (
                List<OrderUpdateEntity> orderUpdateEntities,
                ) {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final fruit = tableListController.tableMergeData
                    .removeAt(orderUpdateEntity.oldIndex);
                tableListController.tableMergeData
                    .insert(orderUpdateEntity.newIndex, fruit);
              }
            },
            children: generatedChildren,
            builder: (children) {
              return GridView(
                key: _gridViewKey,
                controller: _scrollController,
                gridDelegate:   SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: tableListController.tablewidth.value,
                  // crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: tableListController.tableheight.value,
                ),
                children: children,
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.red,
        onPressed: () {
          var tableDetailList = [];
          for (int i = 0; i < tableListController.tableMergeData.length; i++) {
            var dragList = {
              "id": tableListController.tableMergeData[i]["id"],
              "TableName": tableListController.tableMergeData[i]["TableName"],
              "Position": i + 1
            };
            print("darg ...$dragList");

            tableDetailList.add(dragList);

            print("Table reorder:  $tableDetailList");
            // print("Table :  ${tableListController.tableList[i]}");
          }
          tableListController.updateTables(
              type: 'Update', reOrderList: tableDetailList);

          Get.back();
        },
        label: Text(
          'Save Order',
          style: customisedStyle(context, Colors.white, FontWeight.w500, 13.3),
        ),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
        backgroundColor: const Color(0xffF25F29),
        elevation: 4.0,
        tooltip: 'Print Current Order',
      ),
    );
  }



  Widget checkWidgetNew({required splitData}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(splitData.length, (index) {
          final table = splitData[index];
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
              child: Opacity(
                opacity: .75,
                child: CircleAvatar(
                  backgroundColor: table['Status'] == "Vacant"
                      ? const Color(0xff6C757D)
                      : table['Status'] == "Paid"
                      ? const Color(0xff2B952E)
                      : table['Status'] == "Ordered"
                      ? const Color(0xff03C1C1)
                      : const Color(0xFFFFFFFF),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: customisedStyle(
                        context,
                        Colors.white,
                        FontWeight.w400,
                        13.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
