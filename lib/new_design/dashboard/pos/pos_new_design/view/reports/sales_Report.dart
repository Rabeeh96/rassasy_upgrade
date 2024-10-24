// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/report_controller.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/salesreportModel.dart';

// class SalesReport extends StatefulWidget {
//   final SalesreportModel report;
//   const SalesReport({super.key, required this.report});

//   @override
//   State<SalesReport> createState() => _SalesReportState();
// }

// class _SalesReportState extends State<SalesReport> {
//   final ReportController salesreportController = Get.put(ReportController());

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return Obx(
//       () {
//         return Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                   color: const Color(0xFFFFFFFF),
//                   border: Border.all(color: const Color(0xFFCFCFCF)),
//                   borderRadius: const BorderRadius.all(Radius.circular(5))),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     if (salesreportController.reporttype.value ==
//                         'Sales Report') ...[
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "<Date & Time>",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Created Employee",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Employee 01",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Token No",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "1001",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Ledger Name",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Work in Customer",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Gross Amt",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "Employee 01",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Tax",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "1001",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Discount",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             "1001",
//                             style:
//                                 googleFontStyle(color: const Color(0xFF4B4B4B)),
//                           ),
//                         ],
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "<Total>",
//                             style: googleFontStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ] else
//                       ...[],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
