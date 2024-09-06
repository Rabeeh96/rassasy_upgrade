import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/entities/order_update_entity.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableSettings extends StatefulWidget {
  const TableSettings({Key? key}) : super(key: key);

  @override
  _TableSettingsState createState() => _TableSettingsState();
}

class _TableSettingsState extends State<TableSettings> {
  final _scrollController = ScrollController();
  final _gridViewKey = GlobalKey();

  // final tableDetails = [
  //
  // ];//

  int selectedValue = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tablesLists.clear();
    getTableList();
  }

  @override
  Widget build(BuildContext context) {
    final generatedChildren = List.generate(
        tablesLists.length,
        (index) => Container(
              key: Key(tablesLists[index].id.toString()),
              height: MediaQuery.of(context).size.height / 20,

              //height of button
              //    width: MediaQuery.of(context).size.width / 3,
              decoration: BoxDecoration(
                  color: const Color(0xff4f4644),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffC9C9C9),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(
                          5.0) //                 <--- border radius here
                      )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height /
                        18, //height of button
                    width: MediaQuery.of(context).size.width / 16,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: .1,
                          color: const Color(0xffC9C9C9),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(
                                5.0) //                 <--- border radius here
                            )),

                    child: SvgPicture.asset("assets/svg/table.svg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      // height: MediaQuery.of(context).size.height / 8.5, //height of button
                      width: MediaQuery.of(context).size.width / 12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(tablesLists[index].tableName.toString(),
                                style: customisedStyle(context, Colors.white,
                                    FontWeight.w800, 18.0)),
                          ),
                        ],
                      ),
                      // color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ));

    return Scaffold(
      appBar: AppBar(
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
        //
        title: const Text(
          'Table arrangement',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 23,
          ),
        ),
        backgroundColor: Colors.grey[300],
        actions: [
          Text(
            "No of items in a row",
            style:
                customisedStyle(context, Colors.black, FontWeight.w400, 18.0),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 15),
            child: DropdownButton<int>(
              value: selectedValue,
              onChanged: (int? newValue) {
                setState(() {
                  selectedValue = newValue!;
                });
              },
              items: List.generate(
                4,
                (index) => DropdownMenuItem<int>(
                  value: index + 3,
                  child: Text((index + 3).toString()),
                ),
              ),
            ),
          )
        ],
      ),
      body: tablesLists.isNotEmpty
          ? ReorderableBuilder(
              scrollController: _scrollController,
              enableLongPress: false,
              onReorder: (List<OrderUpdateEntity> orderUpdateEntities) {
                for (final orderUpdateEntity in orderUpdateEntities) {
                  final fruit =
                      tablesLists.removeAt(orderUpdateEntity.oldIndex);
                  tablesLists.insert(orderUpdateEntity.newIndex, fruit);
                }
              },
              children: generatedChildren,
              builder: (children) {
                return GridView(
                  key: _gridViewKey,
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: selectedValue,
                    childAspectRatio: 2.5, //2.4 will workk
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  children: children,
                );
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(tablesLists);
        },
        label: Text(
          'Save Order',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 13.3),
        ),
        icon: Icon(Icons.save),
        backgroundColor: Colors.grey,
        elevation: 4.0,
        tooltip: 'Print Current Order',
      ),
      // floatingActionButton: FloatingActionButton(
      //
      //   onPressed: () {
      //     print(tablesLists);
      //   },
      //   child: Icon(Icons.save),
      // ),
    );
  }

  Future<Null> getTableList() async {
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
        final url = '$baseUrl/posholds/table-list/';

        print(url);
        print(accessToken);

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
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

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            tablesLists.clear();
            for (Map user in responseJson) {
              tablesLists.add(TableListModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          // var msg = n["error"];
          // print(dialogBox(context, msg));
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        stop();
      }
    }
  }
}

List<TableListModel> tablesLists = [];

class TableListModel {
  String id, tableName;

  TableListModel({required this.id, required this.tableName});

  factory TableListModel.fromJson(Map<dynamic, dynamic> json) {
    return TableListModel(
      id: json['id'],
      tableName: json['TableName'],
    );
  }
}
