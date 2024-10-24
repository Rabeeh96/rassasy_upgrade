import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:get/get.dart';

import '../../../../../../global/global.dart';
import '../../controller/draggable_controller.dart';

class DragTableList extends StatefulWidget {
  const DragTableList({super.key});

  @override
  State<DragTableList> createState() => _DragTableListState();
}

class _DragTableListState extends State<DragTableList> {
  final DragAndDropController tableListController =
      Get.put(DragAndDropController());

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
        actions: const [],
      ),
      body: Obx(() {
        final generatedChildren = List.generate(
            tableListController.tableList.length,
            (index) => Container(
                color: Colors.white,
                key: Key(tableListController.tableList[index]['id'].toString()),
                // height: MediaQuery.of(context).size.height / 20,

                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                    border: Border(
                      left: BorderSide(
                        color: Color(0xff03C1C1),
                        width: 5,
                      ),

                      // right: BorderSide(
                      //     color: Color(0xffE9E9E9), width: 1),
                      // bottom: BorderSide(
                      //     color: Color(0xffE9E9E9), width: 1),
                      // top: BorderSide(
                      //     color: Color(0xffE9E9E9), width: 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      tableListController.tableList[index]['TableName']
                          .toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )));
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ReorderableBuilder(
            scrollController: _scrollController,
            enableLongPress: true,
            onReorder: (
              List<OrderUpdateEntity> orderUpdateEntities,
            ) {
              for (final orderUpdateEntity in orderUpdateEntities) {
                final fruit = tableListController.tableList
                    .removeAt(orderUpdateEntity.oldIndex);
                tableListController.tableList
                    .insert(orderUpdateEntity.newIndex, fruit);
              }
            },
            children: generatedChildren,
            builder: (children) {
              return GridView(
                key: _gridViewKey,
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 20,
                  childAspectRatio: 3.0,
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
          for (int i = 0; i < tableListController.tableList.length; i++) {
            var dragList = {
              "id": tableListController.tableList[i]['id'],
              "TableName": tableListController.tableList[i]['TableName'],
              "Position": i + 1
            };
            print("darg ...$dragList");

            tableDetailList.add(dragList);

            print("Table reorder:  $tableDetailList");
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
}
