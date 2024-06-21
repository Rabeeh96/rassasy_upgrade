// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/global/textfield_decoration.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/order_controller.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/payment_controller.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/pos_controller.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/order/product_detail_page.dart';
//
// class PaymentSection extends StatefulWidget {
//
//   final bool isPayment;
//   final String uID, tableID, sectionType, tableHead;
//   final int orderType;
//   const PaymentSection({super.key,
//     required this.isPayment,
//     required this.uID,
//     required this.tableID,
//     required this.sectionType,
//     required this.tableHead,
//     required this.orderType,
//
//
//   });
//
//   @override
//   State<PaymentSection> createState() => _PaymentSectionState();
// }
//
// class _PaymentSectionState extends State<PaymentSection> {
//   POSPaymentController paymentController = Get.put(POSPaymentController());
//   OrderController orderController = Get.put(OrderController());
//
//
//   var selectedItem = '';
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(widget.isPayment){
//       paymentController.getOrderDetails(uID: widget.uID);
//     }
//
//   }
// /// here we handle two cases , one is kart and second is payment
//   @override
//   Widget build(BuildContext context) {
//     return widget.isPayment?
//         /// payment section
//     Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 0,
//         elevation: 0,
//         title:   Text(
//           'payment'.tr,
//           style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
//
//         ),
//       ),
//       body: SingleChildScrollView(child: Column(
//         children: [
//           Container(
//             height: 1,
//             color: const Color(0xffE9E9E9),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: const Color(0xffE6E6E6))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding:  EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'customer'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Text(
//                             paymentController.paymentCustomerSelection.text??"",
//                             style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0),
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.black,
//                             size: 15,
//                           )
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'ph_no'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Text(
//                             paymentController.customerPhoneSelection.text??"",
//                             style: customisedStyle(context, const Color(0xff000000),
//                                 FontWeight.w500, 15.0),
//                           ),
//
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'balance1'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Text(
//                                   paymentController.currency,
//                                   style: customisedStyle(context,
//                                       const Color(0xff8C8C8C), FontWeight.w400, 14.0),
//                                 ),
//                               ),
//                               Text(
//                                 "6.00",
//                                 style: customisedStyle(context,
//                                     const Color(0xff000000), FontWeight.w500, 16.0),
//                               ),
//                             ],
//                           ),
//                           const Text(
//                             "",
//                           ),
//                         ]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: const Color(0xffE6E6E6))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Deliveryman'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Text(
//                             "Savad",
//                             style: customisedStyle(context, const Color(0xff000000),
//                                 FontWeight.w500, 15.0),
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.black,
//                             size: 15,
//                           )
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Platform'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Text(
//                             "Zomato(online)",
//                             style: customisedStyle(context, const Color(0xff000000),
//                                 FontWeight.w500, 15.0),
//                           ),
//                           const Icon(
//                             Icons.arrow_forward_ios,
//                             color: Colors.black,
//                             size: 15,
//                           )
//                         ]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: const Color(0xffE6E6E6))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'to_be_paid'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Text(
//                                   paymentController.currency,
//                                   style: customisedStyle(context,
//                                       const Color(0xff8C8C8C), FontWeight.w400, 14.0),
//                                 ),
//                               ),
//                               Text(
//                                 "6.00",
//                                 style: customisedStyle(context,
//                                     const Color(0xff000000), FontWeight.w500, 16.0),
//                               ),
//                             ],
//                           ),
//
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'total_tax'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Text(
//                                   paymentController.currency,
//                                   style: customisedStyle(context,
//                                       const Color(0xff8C8C8C), FontWeight.w400, 14.0),
//                                 ),
//                               ),
//                               Text(
//                                 "6.00",
//                                 style: customisedStyle(context,
//                                     const Color(0xff000000), FontWeight.w500, 16.0),
//                               ),
//                             ],
//                           ),
//
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'net_total'.tr,
//                             style: customisedStyle(context, const Color(0xff8C8C8C),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Text(
//                                   paymentController.currency,
//                                   style: customisedStyle(context,
//                                       const Color(0xff8C8C8C), FontWeight.w400, 14.0),
//                                 ),
//                               ),
//                               Text(
//                                 "6.00",
//                                 style: customisedStyle(context,
//                                     const Color(0xff000000), FontWeight.w500, 16.0),
//                               ),
//                             ],
//                           ),
//
//                         ]),
//                   ),
//                   DividerStyle(),
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'grand_total'.tr,
//                             style: customisedStyle(context, const Color(0xff000000),
//                                 FontWeight.w400, 14.0),
//                           ),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8.0),
//                                 child: Text(
//                                   paymentController.currency,
//                                   style: customisedStyle(context,
//                                       const Color(0xff8C8C8C), FontWeight.w400, 14.0),
//                                 ),
//                               ),
//                               Text(
//                                 "6.00",
//                                 style: customisedStyle(context,
//                                     const Color(0xff000000), FontWeight.w500, 16.0),
//                               ),
//                             ],
//                           ),
//
//                         ]),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: Color(0xffE6E6E6))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       children: [
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//
//                               Text(
//                                 'cash'.tr,
//                                 style: customisedStyle(context, Color(0xff000000),
//                                     FontWeight.w500, 15.0),
//                               ),
//
//                             ]),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width/2.5,
//
//                                 child: TextField(
//                                   textCapitalization: TextCapitalization.words,
//                                   // controller: tokenController,
//                                   style: customisedStyle(
//                                       context, Colors.black, FontWeight.w500, 14.0),
//                                   // focusNode: diningController.customerNode,
//                                   onEditingComplete: () {
//                                     FocusScope.of(context)
//                                         .requestFocus();
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   decoration: TextFieldDecoration.defaultTextField(
//                                       hintTextStr:'amount'.tr),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width/4,
//                               child: TextButton(
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all(const Color(0xff10C103))),
//                                 onPressed: () {},
//                                 child:          Padding(
//                                   padding: const EdgeInsets.only(left: 12.0, right: 12),
//                                   child: Text(
//                                     'Full'.tr,
//                                     style: customisedStyle(
//                                         context,
//                                         const Color(0xffffffff),
//                                         FontWeight.normal,
//                                         12.0),
//                                   ),
//                                 ),),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8,),
//                         DividerStyle(),
//                         SizedBox(height: 8,),
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//
//                               Text(
//                                 'bank'.tr,
//                                 style: customisedStyle(context, Color(0xff000000),
//                                     FontWeight.w500, 15.0),
//                               ),
//
//                             ]),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width/2.5,
//
//                                 child: TextField(
//                                   textCapitalization: TextCapitalization.words,
//                                   // controller: tokenController,
//                                   style: customisedStyle(
//                                       context, Colors.black, FontWeight.w500, 14.0),
//                                   // focusNode: diningController.customerNode,
//                                   onEditingComplete: () {
//                                     FocusScope.of(context)
//                                         .requestFocus();
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   decoration: TextFieldDecoration.defaultTextField(
//                                       hintTextStr:'amount'.tr),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width/4,
//                               child: TextButton(
//                                 style: ButtonStyle(
//                                     backgroundColor:
//                                     MaterialStateProperty.all(const Color(0xff10C103))),
//                                 onPressed: () {},
//                                 child:          Padding(
//                                   padding: const EdgeInsets.only(left: 12.0, right: 12),
//                                   child: Text(
//                                     'Full'.tr,
//                                     style: customisedStyle(
//                                         context,
//                                         const Color(0xffffffff),
//                                         FontWeight.normal,
//                                         12.0),
//                                   ),
//                                 ),),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(left: 20.0, right: 20),
//             child: Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(11),
//                   border: Border.all(color: Color(0xffE6E6E6))),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       children: [
//                         Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//
//                               Text(
//                                 'Discount'.tr,
//                                 style: customisedStyle(context, Color(0xff000000),
//                                     FontWeight.w500, 15.0),
//                               ),
//
//                             ]),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width/2.5,
//
//                                 child: TextField(
//                                   textCapitalization: TextCapitalization.words,
//                                   // controller: tokenController,
//                                   style: customisedStyle(
//                                       context, Colors.black, FontWeight.w500, 14.0),
//                                   // focusNode: diningController.customerNode,
//                                   onEditingComplete: () {
//                                     FocusScope.of(context)
//                                         .requestFocus();
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   decoration: TextFieldDecoration.defaultTextField(
//                                       hintTextStr:'amount'.tr),
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 18.0),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width/2.5,
//
//                                 child: TextField(
//                                   textCapitalization: TextCapitalization.words,
//                                   // controller: tokenController,
//                                   style: customisedStyle(
//                                       context, Colors.black, FontWeight.w500, 14.0),
//                                   // focusNode: diningController.customerNode,
//                                   onEditingComplete: () {
//                                     FocusScope.of(context)
//                                         .requestFocus();
//                                   },
//                                   keyboardType: TextInputType.text,
//                                   decoration: TextFieldDecoration.defaultTextField(
//                                       hintTextStr:""),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8,),
//
//
//                       ],
//                     ),
//                   ),
//
//
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),),
//       bottomNavigationBar: Container(
//         decoration: const BoxDecoration(
//           border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
//         ),
//         height: MediaQuery.of(context).size.height / 10,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(const Color(0xffDF1515))),
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: Row(
//                       children: [
//                         SvgPicture.asset("assets/svg/close-circle.svg"),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 12.0, right: 12),
//                           child: Text(
//                             'cancel'.tr,
//                             style: customisedStyle(
//                                 context,
//                                 const Color(0xffffffff),
//                                 FontWeight.normal,
//                                 12.0),
//                           ),
//                         ),
//                       ],
//                     )),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 TextButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(const Color(0xff10C103))),
//                     onPressed: () {
//                       //  Navigator.popUntil(context, (route) => route.isFirst);
//                       Navigator.popUntil(context, ModalRoute.withName('/posPage'));
//
//                     },
//                     child: Row(
//                       children: [
//                         SvgPicture.asset('assets/svg/save_mob.svg'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 8.0, right: 8),
//                           child: Text(
//                             'Save'.tr,
//                             style: customisedStyle(
//                                 context,
//                                 const Color(0xffffffff),
//                                 FontWeight.normal,
//                                 12.0),
//                           ),
//                         )
//                       ],
//                     )),
//               ],
//             )
//           ],
//         ),
//       ),
//     ):
//         /// kart section
//
//
//     Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 0,
//         elevation: 0,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Table_Order'.tr,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500),
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   'Table_Order'.tr,
//                   style: TextStyle(
//                       color: Color(0xff585858),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400),
//                 ),
//                 Obx(() => Text(
//                   orderController.tokenNumber.value,
//                   style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400),
//                 )),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 6.0),
//             child: IconButton(
//                 onPressed: () {
//                   orderController.deliveryManController.clear();
//                   orderController.customerNameController.clear();
//                 //  addDetails();
//                 },
//                 icon: SvgPicture.asset('assets/svg/Info_mob.svg')),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             height: 1,
//             color: const Color(0xffE9E9E9),
//           ),
//           SearchFieldWidgetNew(
//             autoFocus: false,
//             mHeight: MediaQuery.of(context).size.height / 18,
//             hintText: 'search'.tr,
//             controller: orderController.searchController,
//             onChanged: (quary) async {},
//           ),
//           DividerStyle(),
//           Obx(
//                 () => Expanded(
//                 child: ListView.separated(
//                   separatorBuilder: (context, index) => DividerStyle(),
//                   itemCount: orderController.orderItemList.length,
//                   itemBuilder: (context, index) {
//                     return Dismissible(
//                       key: Key(orderController.orderItemList[index]["unq_id"]
//                           .toString()),
//                       direction: DismissDirection.endToStart,
//                       onDismissed: (direction) {
//                         // Remove the item from your data source.
//                         ///  orderController.deleteOrderItem(index: index);
//                       },
//                       background: Container(
//                         color: Colors.red,
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         alignment: AlignmentDirectional.centerEnd,
//                         child: const Icon(
//                           Icons.delete,
//                           color: Colors.white,
//                         ),
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           Get.to(ProductDetailPage(
//                             index: index,
//                             image: "",
//                           ));
//                         },
//                         child: InkWell(
//                           child: Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 15.0, right: 5, top: 10, bottom: 10),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.check_circle,
//                                     color: Color(0xffF25F29)),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: [
//                                         SvgPicture.asset("assets/svg/veg_mob.svg"),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                               right: 10.0, top: 0, left: 10),
//                                           child: Container(
//                                             width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.35,
//                                             child: Text(
//                                               orderController.orderItemList[index]
//                                               ["ProductName"] ??
//                                                   'sdsd',
//                                               style: customisedStyle(
//                                                   context,
//                                                   Colors.black,
//                                                   FontWeight.w400,
//                                                   15.0),
//                                               maxLines: 3,
//                                               overflow: TextOverflow.ellipsis,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     orderController.orderItemList[index]
//                                     ["Description"] !=
//                                         ""
//                                         ? Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 20.0, right: 5),
//                                       child: Text(
//                                         orderController.orderItemList[index]
//                                         ["Description"],
//                                         style: customisedStyle(
//                                             context,
//                                             const Color(0xffF25F29),
//                                             FontWeight.w400,
//                                             13.0),
//                                       ),
//                                     )
//                                         : Container(),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 10.0),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.center,
//                                         children: [
//                                           orderController.orderItemList[index]
//                                           ["Flavour_Name"] !=
//                                               ""
//                                               ? Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 20.0, right: 5),
//                                             child: Text(
//                                               orderController.orderItemList[
//                                               index]
//                                               ["Flavour_Name"] ??
//                                                   "",
//                                               style: customisedStyle(
//                                                   context,
//                                                   const Color(0xffF25F29),
//                                                   FontWeight.w400,
//                                                   13.0),
//                                             ),
//                                           )
//                                               : Container(),
//                                           GestureDetector(
//                                             onTap: () {},
//                                             child: Container(
//                                               height: MediaQuery.of(context)
//                                                   .size
//                                                   .height /
//                                                   32,
//                                               decoration: BoxDecoration(
//                                                 color: orderController
//                                                     .returnIconStatus(
//                                                     orderController
//                                                         .orderItemList[
//                                                     index]["Status"]),
//                                                 borderRadius:
//                                                 BorderRadius.circular(30),
//                                               ),
//                                               child: Center(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.only(
//                                                       left: 10.0, right: 10),
//                                                   child: Text(
//                                                     orderController
//                                                         .orderItemList[index]
//                                                     ["Status"],
//                                                     style: const TextStyle(
//                                                         fontSize: 11,
//                                                         color: Colors.white),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           orderController.currency.value,
//                                           style: customisedStyle(
//                                               context,
//                                               const Color(0xffA5A5A5),
//                                               FontWeight.w400,
//                                               14.0),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(left: 3.0),
//                                           child: Text(
//                                             roundStringWith(orderController
//                                                 .orderItemList[index]["NetAmount"]
//                                                 .toString()),
//                                             style: customisedStyle(
//                                                 context,
//                                                 const Color(0xff000000),
//                                                 FontWeight.w500,
//                                                 16.0),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                       crossAxisAlignment: CrossAxisAlignment.center,
//                                       children: <Widget>[
//                                         IconButton(
//                                           icon: SvgPicture.asset(
//                                               "assets/svg/minus_mob.svg"),
//                                           onPressed: () {
//                                             orderController.updateQty(
//                                                 index: index, type: 0);
//                                           },
//                                         ),
//                                         Container(
//                                           height:
//                                           MediaQuery.of(context).size.height /
//                                               21,
//                                           width:
//                                           MediaQuery.of(context).size.width / 7,
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                               BorderRadius.circular(8),
//                                               border: Border.all(
//                                                   color: const Color(0xffE7E7E7))),
//                                           child: Center(
//                                             child: Text(
//                                               roundStringWith(orderController
//                                                   .orderItemList[index]["Qty"]
//                                                   .toString()),
//                                               style: const TextStyle(
//                                                 fontSize: 15,
//                                                 color: Colors.black,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         IconButton(
//                                           icon: SvgPicture.asset(
//                                               "assets/svg/plus_mob.svg"),
//                                           onPressed: () {
//                                             orderController.updateQty(
//                                                 index: index, type: 1);
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 )),
//           )
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: MediaQuery.of(context).size.height / 8,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             /// status chnageing commented
//             // Row(
//             //   mainAxisAlignment: MainAxisAlignment.center,
//             //   crossAxisAlignment: CrossAxisAlignment.center,
//             //   children: [
//             //     TextButton(
//             //         style: ButtonStyle(
//             //             backgroundColor:
//             //             MaterialStateProperty.all(const Color(0xffEEF5FF))),
//             //         onPressed: () {},
//             //         child: Padding(
//             //           padding: const EdgeInsets.only(left: 5.0, right: 5),
//             //           child: Text(
//             //             "TakeAway",
//             //             style: customisedStyle(
//             //                 context,
//             //                 const Color(0xff034FC1),
//             //                 FontWeight.normal,
//             //                 12.0),
//             //           ),
//             //         ),),
//             //     const SizedBox(
//             //       width: 7,
//             //     ),
//             //     TextButton(
//             //         style: ButtonStyle(
//             //             backgroundColor:
//             //             MaterialStateProperty.all(const Color(0xffF0F0F0))),
//             //         onPressed: () {},
//             //         child:  Padding(
//             //           padding: const EdgeInsets.only(left: 5.0, right: 5),
//             //           child: Text(
//             //             'Delivered',
//             //             style: customisedStyle(
//             //                 context,
//             //                 const Color(0xff000000),
//             //                 FontWeight.normal,
//             //                 12.0),
//             //           ),
//             //         )),
//             //     const SizedBox(
//             //       width: 7,
//             //     ),
//             //     TextButton(
//             //         style: ButtonStyle(
//             //             backgroundColor:
//             //             MaterialStateProperty.all(const Color(0xffFFF6F2))),
//             //         onPressed: () {
//             //           Get.back();
//             //         },
//             //         child: Row(
//             //           children: [
//             //             const Icon(Icons.add,color: Color(0xffF25F29),),
//             //             Padding(
//             //               padding: const EdgeInsets.only(left: 5.0, right: 5),
//             //               child: Text(
//             //                 'Items',
//             //                 style: customisedStyle(
//             //                     context,
//             //                     const Color(0xffF25F29),
//             //                     FontWeight.normal,
//             //                     12.0),
//             //               ),
//             //             )
//             //           ],
//             //         )),
//             //   ],
//             // ),
//             // const SizedBox(
//             //   height: 9,
//             // ),
//             Container(
//               height: 1,
//               color: const Color(0xffE9E9E9),
//             ),
//             const SizedBox(
//               height: 8,
//             ),
//             Obx(
//                   () => Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Text(
//                       'to_be_paid'.tr,
//                       style: customisedStyle(context, const Color(0xff9E9E9E),
//                           FontWeight.w400, 17.0),
//                     ),
//                   ),
//                   Text(
//                     orderController.currency.value,
//                     style: customisedStyle(context, const Color(0xff000000),
//                         FontWeight.w400, 16.0),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 3.0),
//                     child: Text(
//                       roundStringWith(orderController.totalNetP.toString()),
//                       style: customisedStyle(context, const Color(0xff000000),
//                           FontWeight.w500, 18.0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(
//               height: 8,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(const Color(0xffDF1515))),
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: Row(
//                       children: [
//                         SvgPicture.asset("assets/svg/close-circle.svg"),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0, right: 5),
//                           child: Text(
//                             'cancel'.tr,
//                             style: customisedStyle(
//                                 context,
//                                 const Color(0xffffffff),
//                                 FontWeight.normal,
//                                 12.0),
//                           ),
//                         ),
//                       ],
//                     )),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 TextButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(const Color(0xff10C103))),
//                     onPressed: () async {
//                       orderController.createMethod(tableID: widget.tableID,tableHead: widget.tableHead,orderType: widget.orderType,context: context,isPayment: false);
//                     },
//
//                     child: Row(
//                       children: [
//                         SvgPicture.asset('assets/svg/save_mob.svg'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0, right: 5),
//                           child: Text(
//                             'Save'.tr,
//                             style: customisedStyle(
//                                 context,
//                                 const Color(0xffffffff),
//                                 FontWeight.normal,
//                                 12.0),
//                           ),
//                         )
//                       ],
//                     )),
//                 const SizedBox(
//                   width: 7,
//                 ),
//                 TextButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                         MaterialStateProperty.all(const Color(0xff00775E))),
//                     onPressed: () {
//                       orderController.createMethod(tableID: widget.tableID,tableHead: widget.tableHead,orderType: widget.orderType,context: context,isPayment: true);
//                     },
//                     child: Row(
//                       children: [
//                         SvgPicture.asset('assets/svg/payment_mob.svg'),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 5.0, right: 5),
//                           child: Text(
//                             'payment'.tr,
//                             style: customisedStyle(
//                                 context,
//                                 const Color(0xffffffff),
//                                 FontWeight.normal,
//                                 12.0),
//                           ),
//                         )
//                       ],
//                     )),
//               ],
//             ),
//           ],
//         ),
//       ),
//     )
//     ;
//   }
// }
