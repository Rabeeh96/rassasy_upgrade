import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';

import '../../../../../../global/global.dart';
import '../../controller/draggable_controller.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';

class DragTableList extends StatefulWidget {
  @override
  State<DragTableList> createState() => _DragTableListState();
}

class _DragTableListState extends State<DragTableList> {
  final TableListController tableListController =
      Get.put(TableListController());

  Color _getBackgroundColor(String? status) {
    if (status == 'Vacant') {
      return const Color(
          0xff6C757D); // Set your desired color for pending status
    } else if (status == 'Ordered') {
      return const Color(
          0xff03C1C1); // Set your desired color for completed status
    } else if (status == 'Paid') {
      return const Color(
          0xff2B952E); // Set your desired color for cancelled status
    } else if (status == 'Billed') {
      return const Color(
          0xff034FC1); // Set your desired color for cancelled status
    } else {
      return const Color(
          0xffEFEFEF); // Default color if status is not recognized
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tableListController.fetchTables();
  }
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    final generatedChildren = List.generate(
        tableListController.tableList.length,
            (index) => Container(
          //key: Key(tableListController.tableList[index].id.toString()),
         // height: MediaQuery.of(context).size.height / 20,


          child:GestureDetector(
              onTap: () {},
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    // color: controller.selectedIndex.value ==
                    //     index
                    //     ? Colors
                    //     .white // Highlight selected item
                    //     : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: _getBackgroundColor('Vacant'),
                              width: 4,
                            ),
                            right: const BorderSide(
                                color: Color(0xffE9E9E9), width: 1),
                            bottom: const BorderSide(
                                color: Color(0xffE9E9E9), width: 1),
                            top: const BorderSide(
                                color: Color(0xffE9E9E9), width: 1),
                          ),
                        ),
                        child: GridTile(

                          header: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tableListController.tableList[index]['TableName'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Text(
                                  tableListController.tableList[index]['Position'].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))))
        ));


    return Scaffold(
      appBar: AppBar(
        title: const Text("Table Setting"),
        actions: [
          Text(
            "No of items in a row",
            style: customisedStyle(context, Colors.black, FontWeight.w400, 18.0),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 15),
            child: Obx(() {
              return DropdownButton<int>(
                value: tableListController.selectedValue.value,
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    // Update the selected value in the controller
                    tableListController.selectedValue.value = newValue;
                  }
                },
                items: List.generate(
                  6,
                      (index) =>
                      DropdownMenuItem<int>(
                        value: index + 3,
                        child: Text((index + 3).toString()),
                      ),
                ),
              );
            })

          )],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          ///dining lis
          ReorderableBuilder(
            scrollController: _scrollController,
            enableLongPress: false,
            onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
              // for (final orderUpdateEntity in orderUpdateEntities) {
              //   final fruit = tablesLists.removeAt(orderUpdateEntity.oldIndex);
              //   tablesLists.insert(orderUpdateEntity.newIndex, fruit);
              // }
            },
            children: generatedChildren,
            builder: (children) {
              return GridView.builder(
                key: _gridViewKey,

                controller: _scrollController,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: tableListController.selectedValue.value,
                  mainAxisSpacing: 15,


                  crossAxisSpacing: 20,
                  childAspectRatio: 2.0,
                ),
                itemCount: tableListController.tableList.length,
                itemBuilder: (context, index) {
                //  return children;
                },
              );
            },
          )

          // SliverToBoxAdapter(
          //   child: Container(
          //     margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
          //
          //     height: MediaQuery.of(context)
          //         .size
          //         .height, // Specify your desired height here
          //     child: Obx(() {
          //       if (tableListController.tableList.isEmpty) {
          //         return const Center(child: CircularProgressIndicator());
          //       }
          //       return GridView.builder(
          //         gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: tableListController.selectedValue.value,
          //           mainAxisSpacing: 15,
          //           crossAxisSpacing: 20,
          //           childAspectRatio: 2.0,
          //         ),
          //         itemCount: tableListController.tableList.length,
          //         itemBuilder: (context, index) {
          //           return GestureDetector(
          //               onTap: () {},
          //               child: Container(
          //                   decoration: BoxDecoration(
          //                     color: Colors.deepOrange.shade50,
          //                     // color: controller.selectedIndex.value ==
          //                     //     index
          //                     //     ? Colors
          //                     //     .white // Highlight selected item
          //                     //     : Colors.white,
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child: ClipRRect(
          //                       borderRadius: BorderRadius.circular(8),
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                           border: Border(
          //                             left: BorderSide(
          //                               color: _getBackgroundColor('Vacant'),
          //                               width: 4,
          //                             ),
          //                             right: const BorderSide(
          //                                 color: Color(0xffE9E9E9), width: 1),
          //                             bottom: const BorderSide(
          //                                 color: Color(0xffE9E9E9), width: 1),
          //                             top: const BorderSide(
          //                                 color: Color(0xffE9E9E9), width: 1),
          //                           ),
          //                         ),
          //                         child: GridTile(
          //
          //                           header: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.start,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   tableListController.tableList[index]['TableName'],
          //                                   style: const TextStyle(
          //                                     color: Colors.black,
          //                                     fontWeight: FontWeight.w500,
          //                                     fontSize: 16.0,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.spaceBetween,
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.center,
          //                               children: [
          //                                 Text(
          //                                   tableListController.tableList[index]['Position'].toString(),
          //                                   style: const TextStyle(
          //                                     color: Colors.black,
          //                                     fontWeight: FontWeight.w500,
          //                                     fontSize: 16.0,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                       ))));
          //         },
          //       );
          //     }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
