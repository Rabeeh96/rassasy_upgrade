// import 'dart:convert';
// import 'package:flutter/material.dart' hide Image;
// import 'package:flutter/services.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:get/get.dart';
//
//
//
//
// class SelectCodePage extends StatefulWidget {
//   @override
//   _SelectCodePageState createState() => _SelectCodePageState();
// }
//
// class _SelectCodePageState extends State<SelectCodePage> {
//
//
//
//
//   List<String> codePageModel=[ 'CP1250', 'PC858', 'KU42', 'PC850', 'OME851', 'CP3012', 'OME852', 'CP720', 'RK1048', 'WPC1253', 'CP737', 'ISO_8859-2', 'CP1258', 'CP850', 'CP775', 'ISO_8859-4', 'TCVN-3-1', 'PC2001', 'CP865', 'OME866', 'OME864', 'CP861', 'OME1001', 'CP1001', 'CP857', 'OME1255', 'PC737', 'CP3847', 'WPC1250', 'PC720', 'OME1252', 'ISO_8859-15', 'CP862', 'CP3841', 'CP437', 'OME855', 'ISO8859-7', 'TCVN-3-2', 'CP1257', 'PC3840', 'CP3041', 'CP1256', 'CP3848', 'PC3002', 'PC860', 'ISO_8859-7', 'OEM775', 'CP853', 'CP3002', 'OME772', 'OME774', 'PC3845', 'CP774', 'CP1252', 'CP1255', 'OME858', 'ISO_8859-1', 'PC3844', 'OME850', 'PC437', 'CP856', 'OME874', 'OME865', 'CP3844', 'PC3011', 'CP852', 'OEM720', 'WPC1256', 'CP863', 'CP2001', 'PC3012', 'OME737', 'CP858', 'PC3848', 'CP855', 'CP869', 'ISO_8859-3', 'CP860', 'CP3021', 'OME860', 'PC3841', 'OME869', 'PC863', 'ISO_8859-9', 'CP928', 'OME437', 'ISO_8859-5', 'CP1254', 'CP3846', 'CP1253', 'CP874', 'OME747', 'WPC1258', 'WPC1251', 'OME863', 'CP1098', 'WPC1252', 'PC866', 'PC865', 'CP3001', 'PC3843', 'PC3041', 'PC3846', 'PC1001', 'PC3021', 'CP3840', 'CP864', 'PC864', 'CP866', 'PC857', 'Unknown', 'CP772', 'ISO-8859-6', 'OXHOO-EUROPEAN', 'CP747', 'CP3845', 'PC3847', 'CP3011', 'PC3001', 'OME862', 'OME928', 'CP851', 'OME857', 'ISO_8859-8', 'CP1125', 'CP3843', 'PC852', 'CP1251', 'CP932', 'ISO_8859-6', 'Katakana', 'OME861', 'WPC1254', 'WPC1257'];
//
//
//   late List<String> filteredList;
//   late TextEditingController searchController;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     filteredList = codePageModel;
//     searchController.addListener(() {
//       filterList();
//     });
//   }
//
//   void filterList() {
//     setState(() {
//       filteredList = codePageModel.where((codePage) => codePage.toLowerCase().contains(searchController.text.toLowerCase())).toList();
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'Select Capability',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 20.0),
//         ),
//         backgroundColor: Colors.grey[300],
//       ),
//       body: Center(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width / 3,
//           color: Colors.grey[100],
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: searchController,
//                   decoration: InputDecoration(
//                     labelText: 'Search',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: filteredList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(
//                             filteredList[index],
//                             style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14.0),
//                           ),
//                           onTap: () {
//                             Navigator.pop(context, filteredList[index]);
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
//
// /// new method
//
//
// }
//
