import 'dart:convert';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';




class select_code_page extends StatefulWidget {
  @override
  _select_code_pageState createState() => _select_code_pageState();
}

class _select_code_pageState extends State<select_code_page> {


  List<String> codePageModel =[ 'CP1250', 'CP','PC858', 'KU42', 'PC850', 'OME851', 'CP3012', 'OME852', 'CP720', 'RK1048', 'WPC1253', 'CP737', 'ISO_8859-2', 'CP1258', 'CP850', 'CP775', 'ISO_8859-4', 'TCVN-3-1', 'PC2001', 'CP865', 'OME866', 'OME864', 'CP861', 'OME1001', 'CP1001', 'CP857', 'OME1255', 'PC737', 'CP3847', 'WPC1250', 'PC720', 'OME1252', 'ISO_8859-15', 'CP862', 'CP3841', 'CP437', 'OME855', 'ISO8859-7', 'TCVN-3-2', 'CP1257', 'PC3840', 'CP3041', 'CP1256', 'CP3848', 'PC3002', 'PC860', 'ISO_8859-7', 'OEM775', 'CP853', 'CP3002', 'OME772', 'OME774', 'PC3845', 'CP774', 'CP1252', 'CP1255', 'OME858', 'ISO_8859-1', 'PC3844', 'OME850', 'PC437', 'CP856', 'OME874', 'OME865', 'CP3844', 'PC3011', 'CP852', 'OEM720', 'WPC1256', 'CP863', 'CP2001', 'PC3012', 'OME737', 'CP858', 'PC3848', 'CP855', 'CP869', 'ISO_8859-3', 'CP860', 'CP3021', 'OME860', 'PC3841', 'OME869', 'PC863', 'ISO_8859-9', 'CP928', 'OME437', 'ISO_8859-5', 'CP1254', 'CP3846', 'CP1253', 'CP874', 'OME747', 'WPC1258', 'WPC1251', 'OME863', 'CP1098', 'WPC1252', 'PC866', 'PC865', 'CP3001', 'PC3843', 'PC3041', 'PC3846', 'PC1001', 'PC3021', 'CP3840', 'CP864', 'PC864', 'CP866', 'PC857', 'Unknown', 'CP772', 'ISO-8859-6', 'OXHOO-EUROPEAN', 'CP747', 'CP3845', 'PC3847', 'CP3011', 'PC3001', 'OME862', 'OME928', 'CP851', 'OME857', 'ISO_8859-8', 'CP1125', 'CP3843', 'PC852', 'CP1251', 'CP932', 'ISO_8859-6', 'Katakana', 'OME861', 'WPC1254', 'WPC1257'];
  List<String> codePageMode1 =[
    "CP1001",
    "CP1098",
    "CP1125",
    "CP1250",
    "CP1251",
    "CP1252",
    "CP1253",
    "CP1254",
    "CP1255",
    "CP1256",
    "CP1257",
    "CP1258",
    "CP2001",
    "CP3011",
    "CP3012",
    "CP3021",
    "CP3041",
    "CP3840",
    "CP3841",
    "CP3843",
    "CP3844",
    "CP3845",
    "CP3846",
    "CP3847",
    "CP3848",
    "CP437",
    "CP720",
    "CP737",
    "CP747",
    "CP772",
    "CP774",
    "CP775",
    "CP850",
    "CP851",
    "CP852",
    "CP853",
    "CP855",
    "CP856",
    "CP857",
    "CP858",
    "CP860",
    "CP861",
    "CP862",
    "CP863",
    "CP864",
    "CP865",
    "CP866",
    "CP869",
    "CP874",
    "CP928",
    "ISO-8859-6",
    "ISO_8859-1",
    "ISO_8859-15",
    "ISO_8859-2",
    "ISO_8859-3",
    "ISO_8859-4",
    "ISO_8859-5",
    "ISO_8859-7",
    "ISO_8859-8",
    "Katakana",
    "KU42",
    "OME1001",
    "OME1252",
    "OME1255",
    "OME128",
    "OME727",
    "OME737",
    "OME747",
    "OME772",
    "OME774",
    "OME775",
    "OME850",
    "OME851",
    "OME852",
    "OME855",
    "OME857",
    "OME858",
    "OME860",
    "OME861",
    "OME862",
    "OME863",
    "OME864",
    "OME865",
    "OME866",
    "OME869",
    "OME928",
    "OXHOO-EUROPEAN",
    "PC3001",
    "PC3002",
    "PC3011",
    "PC3012",
    "PC3021",
    "PC3041",
    "PC3840",
    "PC3841",
    "PC3843",
    "PC3844",
    "PC3845",
    "PC3846",
    "PC3847",
    "PC3848",
    "PC437",
    "PC720",
    "PC737",
    "PC850",
    "PC858",
    "PC865",
    "PC866",
    "TCVN-3-1",
    "TCVN-3-2",
    "Unknown",
    "WPC1250",
    "WPC1251",
    "WPC1252",
    "WPC1253",
    "WPC1254",
    "WPC1256",
    "WPC1257",
    "WPC1258",
  ];

  late List<String> filteredList;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    filteredList = codePageModel;
    searchController.addListener(() {
      filterList();
    });
  }

  void filterList() {
    setState(() {
      filteredList = codePageModel.where((codePage) => codePage.toLowerCase().contains(searchController.text.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    bool isTablet = screenWidth > defaultScreenWidth;
    return Scaffold(
      appBar: isTablet?AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:   Text(
          'Select Code Page',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 22.0),
          //style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22.0),
        ),
        backgroundColor: Colors.grey[300],
      ):AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        title:   Text(
          'Select Code Page',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
          //style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22.0),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,

          color:isTablet? Colors.grey[100]:Colors.white,
          child: Padding(
            padding: isTablet? EdgeInsets.all(20.0):EdgeInsets.only(left: 20.0,right: 20),
            child: Column(
              children: [

                Container(
                  height: MediaQuery.of(context).size.height/16,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 5 : 2,
                      // crossAxisSpacing: 4.0,
                      // mainAxisSpacing: 4.0,
                      childAspectRatio: 2.5,  // Adjust this value to change the aspect ratio
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.white70,
                        child: Center(  // Center the content inside the Card
                          child: ListTile(
                            title: Text(
                              textAlign: TextAlign.center,
                              filteredList[index],
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context, filteredList[index]);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),








              ],
            ),
          ),
        ),
      ),
    );
  }




/// new method


}

