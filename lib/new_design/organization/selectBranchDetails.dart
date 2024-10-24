import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectBranch extends StatefulWidget {
  var list = [];

  SelectBranch({super.key, required this.list});
  @override
  State<SelectBranch> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectBranch> {
  @override
  void initState() {
    super.initState();
    branchList = widget.list;
    print(branchList);
  }

  List branchList = [];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    bool isTablet = screenWidth > 850;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ), //
        title: Text(
          'select_branch'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Center(
        child: Container(
            height: isTablet
                ? screenHeight / 1
                : screenHeight / 1.1, //height of button
            width: isTablet ? screenWidth / 3 : screenWidth / 1,
            color: Colors.grey[100],
            child: branchList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: branchList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                              child: ListTile(
                            title: Text(
                              branchList[index]["NickName"] ?? '',
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.normal, 14.0),
                            ),
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setInt(
                                  'branchID', branchList[index]["BranchID"]);
                              Navigator.pop(
                                  context, branchList[index]["BranchName"]);
                            },
                          ));
                        }),
                  )
                : Center(
                    child: Text(
                    'No_Cat'.tr,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w700, 14.0),
                  ))),
      ),
    );
  }
}
