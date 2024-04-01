
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class SelectBranch extends StatefulWidget {

  var list=[];

  SelectBranch({super.key, required this.list });
  @override
  State<SelectBranch> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectBranch> {
  @override
  void initState() {
    super.initState();
    categoryLists=widget.list;
    print(categoryLists);
  }


  List categoryLists = [];


  @override
  Widget build(BuildContext context) {
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
        ), //
        title:   Text(
          'select_branch'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w600, 20.0),
        ),
        backgroundColor: Colors.grey[300],
      ),

      body: Center(
        child: Container(
            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.grey[100],
            // color: Colors.grey[100],
            child:categoryLists.isNotEmpty?Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categoryLists.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title:  Text(categoryLists[index]["BranchName"],style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),),
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setInt('branchID',categoryLists[index]["BranchID"]);
                            Navigator.pop(context, categoryLists[index]["BranchName"]);
                          },
                        )
                    );
                  }
              ),
            ):Center(child: Text('No_Cat'.tr,style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),))
        ),
      ),
    );
  }


}

