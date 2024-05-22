import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/reservation_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final List<String> buttonLabels = [
    'Button 1',
    'Button 2',
    'Button 3',
    'Button 4'
  ];
  final List<Color> buttonColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];
  final ReservationController reservationController =
      Get.put(ReservationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationController.reservations.clear();
    reservationController.update();
    reservationController.fetchReservations(
        reservationController.apiDateFormat
            .format(reservationController.fromDateNotifier.value),
        reservationController.apiDateFormat
            .format(reservationController.toDateNotifier.value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reservations'.tr,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 12),
          child: Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: reservationController.fromDateNotifier,
                builder: (BuildContext ctx, fromDateNewValue, _) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: Color(0xffFFF6F2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        showDatePickerFunction(
                            context, reservationController.fromDateNotifier);
                        reservationController.fetchReservations(
                            reservationController.apiDateFormat.format(
                                reservationController.fromDateNotifier.value),
                            reservationController.apiDateFormat.format(
                                reservationController.toDateNotifier.value));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/svg/calendar_new.svg"),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              reservationController.dateFormat
                                  .format(fromDateNewValue),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ));
                }),
            SizedBox(
              width: 8,
            ),
            ValueListenableBuilder(
                valueListenable: reservationController.toDateNotifier,
                builder: (BuildContext ctx, toDateNewValue, _) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        backgroundColor: Color(0xffFFF6F2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        showDatePickerFunction(
                            context, reservationController.toDateNotifier);
                        reservationController.fetchReservations(
                            reservationController.apiDateFormat.format(
                                reservationController.fromDateNotifier.value),
                            reservationController.apiDateFormat.format(
                                reservationController.toDateNotifier.value));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/svg/calendar_new.svg"),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              reservationController.dateFormat
                                  .format(toDateNewValue),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ));
                }),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, bottom: 10),
          child: Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
        ),
        Expanded(
            child:Obx(() => reservationController.isLoading.value
    ? const Center(child: CircularProgressIndicator())
        : reservationController.reservations.isEmpty
    ? const Text("No recent orders")
        :  ListView.builder(
          itemCount: reservationController.reservations.length,
          itemBuilder: (context, index) {
            return  Slidable(

              endActionPane: ActionPane(
                motion: const ScrollMotion(),

                children: [
                  // CustomSlidableAction(
                  //   flex: 2,
                  //   // An action can be bigger than the others.
                  //   //  flex: 2,
                  //   onPressed: (BuildContext context) async {
                  //
                  //
                  //   },
                  //   //onPressed: doNothing,
                  //   backgroundColor:Colors.transparent,
                  //   foregroundColor: Colors.transparent,
                  //   child: Icon(Icons.clear),
                  //
                  // ),
                  CustomSlidableAction(
                    flex: 2,
                    // An action can be bigger than the others.
                    //  flex: 2,
                    onPressed: (BuildContext context) async {


                    },
                    //onPressed: doNothing,
                    backgroundColor: const Color(0xFFDF1515),
                    foregroundColor: Colors.white,
                    child: Icon(Icons.clear),

                  ),


                ],
              ),

              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 5, bottom: 5),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    reservationController
                                        .reservations[index].customerName!,
                                    style: customisedStyle(context, Colors.black,
                                        FontWeight.w400, 15.0),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    reservationController
                                        .reservations[index].tableName!,
                                    style: customisedStyle(context,
                                        Color(0xff00775E), FontWeight.w400, 15.0),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  reservationController.reservations[index].date!,
                                  style: customisedStyle(context,
                                      Color(0xffF25F29), FontWeight.w400, 13.0),
                                ),
                                Text(
                                  "${reservationController.reservations[index].fromTime!} - ${reservationController.reservations[index].toTime!}",
                                  style: customisedStyle(context,
                                      Color(0xffAEAEAE), FontWeight.w500, 15.0),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      DividerStyle()
                    ],
                  ),
                ),
              ),
            );



          },
        ))

        )]),
    );
  }

// void addReservationTable() {
//   Get.bottomSheet(
//     isDismissible: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(10.0),
//         // Set border radius to the top left corner
//         topRight: Radius.circular(
//             10.0), // Set border radius to the top right corner
//       ),
//     ),
//     backgroundColor: Colors.white,
//     Container(
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'reserve_a_table'.tr,
//                     style: customisedStyle(
//                         context, Colors.black, FontWeight.w500, 14.0),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       icon: const Icon(
//                         Icons.clear,
//                         color: Colors.black,
//                       ))
//                 ],
//               ),
//             ),
//             Container(
//               height: 1,
//               color: const Color(0xffE9E9E9),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 width: MediaQuery.of(context).size.width / 4,
//                 child: TextField(
//                   textCapitalization: TextCapitalization.words,
//                   controller: diningController.customerNameController,
//                   style: customisedStyle(
//                       context, Colors.black, FontWeight.w500, 14.0),
//                   focusNode: diningController.customerNode,
//                   onEditingComplete: () {
//                     FocusScope.of(context)
//                         .requestFocus(diningController.saveFocusNode);
//                   },
//                   keyboardType: TextInputType.text,
//                   decoration: TextFieldDecoration.defaultTextField(
//                       hintTextStr: 'customer'.tr),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16),
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Color(0xffE6E6E6))),
//                 height: MediaQuery.of(context).size.height / 4.5,
//                 child: Column(
//                   children: [
//                     ValueListenableBuilder(
//                         valueListenable: diningController.reservationDate,
//                         builder:
//                             (BuildContext ctx, DateTime dateNewValue, _) {
//                           return GestureDetector(
//                             child: Padding(
//                               padding: const EdgeInsets.all(
//                                 8.0,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 //  width: MediaQuery.of(context).size.width / 3,
//                                 height:
//                                 MediaQuery.of(context).size.height / 20,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Date'.tr,
//                                         style: customisedStyle(
//                                             context,
//                                             Color(0xff8C8C8C),
//                                             FontWeight.w400,
//                                             14.0),
//                                       ),
//                                       Padding(
//                                         padding:
//                                         const EdgeInsets.only(right: 8.0),
//                                         child: Text(
//                                           diningController.dateFormat
//                                               .format(dateNewValue),
//                                           style: customisedStyle(
//                                               context,
//                                               Colors.black,
//                                               FontWeight.w400,
//                                               14.0),
//                                         ),
//                                       ),
//                                       SvgPicture.asset("assets/svg/Icon.svg")
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             onTap: () {
//                               showDatePickerFunction(
//                                   context, diningController.reservationDate);
//                             },
//                           );
//                         }),
//                     DividerStyle(),
//                     ValueListenableBuilder(
//                         valueListenable: diningController.fromTimeNotifier,
//                         builder: (BuildContext ctx, timeNewValue, _) {
//                           return GestureDetector(
//                             child: Padding(
//                               padding: const EdgeInsets.all(
//                                 8.0,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 //  width: MediaQuery.of(context).size.width / 3,
//                                 height:
//                                 MediaQuery.of(context).size.height / 20,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'from'.tr,
//                                         style: customisedStyle(
//                                             context,
//                                             Color(0xff8C8C8C),
//                                             FontWeight.w400,
//                                             14.0),
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(right: 20.0),
//                                         child: Text(
//                                           diningController.timeFormat.format(
//                                               diningController
//                                                   .fromTimeNotifier.value),
//                                           style: customisedStyle(
//                                               context,
//                                               Colors.black,
//                                               FontWeight.w400,
//                                               14.0),
//                                         ),
//                                       ),
//                                       SvgPicture.asset("assets/svg/Icon.svg")
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             onTap: () async {
//                               TimeOfDay? pickedTime = await showTimePicker(
//                                 initialTime: TimeOfDay.now(),
//                                 context: context,
//                               );
//                               if (pickedTime != null) {
//                                 final time = TimeOfDay(
//                                     hour: pickedTime.hour,
//                                     minute: pickedTime.minute);
//                                 final currentDateTime =diningController.fromTimeNotifier.value;
//                                 final dateTime = DateTime(
//                                     currentDateTime.year,
//                                     currentDateTime.month,
//                                     currentDateTime.day,
//                                     time.hour,
//                                     time.minute);
//                                 diningController.fromTimeNotifier.value =
//                                     dateTime;
//                                 // viewList();
//                               } else {
//                                 print("Time is not selected");
//                               }
//                             },
//                           );
//                         }),
//                     DividerStyle(),
//                     ValueListenableBuilder(
//                         valueListenable: diningController.toTimeNotifier,
//                         builder: (BuildContext ctx, timeNewValue, _) {
//                           return GestureDetector(
//                             child: Padding(
//                               padding: const EdgeInsets.all(
//                                 8.0,
//                               ),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: Colors.transparent,
//                                     width: 2,
//                                   ),
//                                 ),
//                                 height:
//                                 MediaQuery.of(context).size.height / 20,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'to'.tr,
//                                         style: customisedStyle(
//                                             context,
//                                             Color(0xff8C8C8C),
//                                             FontWeight.w400,
//                                             14.0),
//                                       ),
//                                       Text(
//                                         diningController.timeFormat.format(
//                                             diningController
//                                                 .toTimeNotifier.value),
//                                         style: customisedStyle(
//                                             context,
//                                             Colors.black,
//                                             FontWeight.w400,
//                                             14.0),
//                                       ),
//                                       SvgPicture.asset("assets/svg/Icon.svg")
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             onTap: () async {
//                               TimeOfDay? pickedTime = await showTimePicker(
//                                 initialTime: TimeOfDay.now(),
//                                 context: context,
//                               );
//                               if (pickedTime != null) {
//                                 final time = TimeOfDay(
//                                     hour: pickedTime.hour,
//                                     minute: pickedTime.minute);
//                                 final currentDateTime =  diningController.toTimeNotifier.value;
//                                 final dateTime = DateTime(
//                                     currentDateTime.year,
//                                     currentDateTime.month,
//                                     currentDateTime.day,
//                                     time.hour,
//                                     time.minute);
//                                 diningController.toTimeNotifier.value =
//                                     dateTime;
//                                 // viewList();
//                               } else {
//                                 print("Time is not selected");
//                               }
//                             },
//                           );
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 16.0, right: 16, bottom: 16, top: 16),
//               child: Container(
//                 height: MediaQuery.of(context).size.height / 17,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             8.0), // Adjust the radius as needed
//                       ),
//                     ),
//                     backgroundColor:
//                     MaterialStateProperty.all(const Color(0xffF25F29)),
//                   ),
//                   onPressed: () {
//                     // Do something with the text
//
//                     Get.back(); // Close the bottom sheet
//                   },
//                   child: Text(
//                     'save'.tr,
//                     style: customisedStyle(
//                         context, Colors.white, FontWeight.normal, 12.0),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
}
