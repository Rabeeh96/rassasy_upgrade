// import 'package:flutter/material.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/dashboard/profile_mobile/settings/printer_setting/controller/detailed_print_controlle.dart';
// import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
// import 'package:get/get.dart';
//
//
// class SelectCodePage extends StatefulWidget {
//
//   @override
//   State<SelectCodePage> createState() => _SelectCodePageState();
// }
//
// class _SelectCodePageState extends State<SelectCodePage> {
//   DetailedPrintSettingController codePageController = Get.put(DetailedPrintSettingController());
//
// //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 0,
//         title: Text(
//           'select_codepage'.tr,
//           style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 1),
//               child: Container(
//                 height: 1,
//                 color: const Color(0xffE9E9E9),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0, right: 8),
//               child: ListView.separated(
//                   separatorBuilder: (context, index) => DividerStyle(),
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: codePageController.codepage.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return ListTile(
//                       title: Text(codePageController.codepage[index],style: customisedStyleBold(context, Colors.black, FontWeight.w400, 14.0),),
//                       onTap: ()  {
//
//
//                         Navigator.pop(
//                             context,
//                             codePageController.codepage[index]);
//                       },
//                     );
//                   }),
//             ),
//             SizedBox(height: 20,)
//           ],
//         ),
//       ),
//     );
//   }
//
// }
//
