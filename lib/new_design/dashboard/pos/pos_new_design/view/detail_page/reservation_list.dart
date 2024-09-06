import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/reservation_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'select_table.dart';

class ReservationPage extends StatefulWidget {
  ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final ReservationController reservationController = Get.put(ReservationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    reservationController.reservations.clear();
    reservationController.update();
    reservationController.fetchReservations(reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value), reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
    reservationDate = ValueNotifier(DateTime.now());
    timeNotifierFromTime = ValueNotifier(DateTime.now());
    timeNotifierToTime = ValueNotifier(DateTime.now());

  }
  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');
  late ValueNotifier<DateTime> reservationDate;
  late ValueNotifier<DateTime> timeNotifierFromTime;
  late ValueNotifier<DateTime> timeNotifierToTime;
  TextEditingController tableNameController = TextEditingController();
  TextEditingController reservationCustomerNameController = TextEditingController();

  var tableID = "";
  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white60,
          title: const Text("Reserve For Later"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                _buildTextField(
                  context,
                  "Select Table",
                  tableNameController,
                  readOnly: true,
                  onTap: () async {
                    var result = await Get.to(SelectTableReservation());
                    if (result != null) {
                      tableID = result[1];
                      tableNameController.text = result[0];

                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  context,
                  "Customer name",
                  reservationCustomerNameController,
                ),
                const SizedBox(height: 8),
                _buildDateSelector(context, reservationDate),
                const SizedBox(height: 8),
                _buildTimeSelector(context, "From", timeNotifierFromTime),
                const SizedBox(height: 8),
                _buildTimeSelector(context, "To", timeNotifierToTime),
                const SizedBox(height: 8),
                _buildButton(
                  context,
                  "Reserve",
                  Colors.white,
                  Color(0xffF25F29),
                      () {
                    if (reservationCustomerNameController.text.isEmpty) {
                      popAlertWithColor(
                        head: "Alert",
                        message: 'Please enter customer name',
                        position: SnackPosition.TOP,
                        backGroundColor: Colors.red,
                        forGroundColor: Colors.white,
                      );
                    } else {
                      reservationController.createReservation(
                        tableID,
                        reservationCustomerNameController.text,
                        apiDateFormat.format(reservationDate.value),
                        timeFormatApiFormat.format(timeNotifierFromTime.value),
                        timeFormatApiFormat.format(timeNotifierToTime.value),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildButton(
                  context,
                  'Cancel',
                  Colors.black,
                  Colors.transparent,
                      () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {});
  }

  Widget _buildTextField(
      BuildContext context,
      String hintText,
      TextEditingController controller, {
        bool readOnly = false,
        VoidCallback? onTap,
      }) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      child: TextField(
        style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9)),
          ),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9)),
          ),
          contentPadding: const EdgeInsets.only(
            left: 20,
            top: 10,
            right: 10,
            bottom: 10,
          ),
          filled: true,
          hintStyle: customisedStyle(
            context,
            const Color(0xff858585),
            FontWeight.w400,
            14.0,
          ),
          hintText: hintText,
          fillColor: const Color(0xffffffff),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      BuildContext context, ValueNotifier<DateTime> reservationDate) {
    return ValueListenableBuilder(
      valueListenable: reservationDate,
      builder: (BuildContext ctx, DateTime dateNewValue, _) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  Date",
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    DateFormat.yMd().format(dateNewValue),
                    style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            showDatePickerFunction(context, reservationDate);
          },
        );
      },
    );
  }

  Widget _buildTimeSelector(
      BuildContext context, String label, ValueNotifier<DateTime> timeNotifier) {
    return ValueListenableBuilder(
      valueListenable: timeNotifier,
      builder: (BuildContext ctx, DateTime dateNewValue, _) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "  $label",
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    DateFormat.jm().format(dateNewValue),
                    style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              initialTime: TimeOfDay.now(),
              context: context,
            );
            if (pickedTime != null) {
              timeNotifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
            } else {
              print("Time is not selected");
            }
          },
        );
      },
    );
  }

  Widget _buildButton(
      BuildContext context,
      String text,
      Color textColor,
      Color buttonColor,
      VoidCallback onPressed,
      ) {
    return Container(
      height: MediaQuery.of(context).size.height / 18,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
  // showPopup(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //           backgroundColor: Colors.grey,
  //           title: const Text("Reserve For Later"),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: [
  //                 Container(
  //                 //  width: MediaQuery.of(context).size.width / 4,
  //                   height: MediaQuery.of(context).size.height / 20,
  //                   child: TextField(
  //                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
  //                     controller: tableNameController,
  //                     //  focusNode: nameFcNode,
  //                    readOnly: true,
  //                     onTap: ()async{
  //                       var result =  await Get.to(SelectTableReservation());
  //                       if(result!=null){
  //                         tableID = result[1];
  //                         tableNameController.text = result[0];
  //                         showPopup(context);
  //                       }
  //                     },
  //                     decoration: InputDecoration(
  //                         enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
  //                         filled: true,
  //                         suffixStyle: const TextStyle(
  //                           color: Colors.red,
  //                         ),
  //                         hintStyle: customisedStyle(context, const Color(0xff858585), FontWeight.w400, 14.0),
  //                         hintText: "Select Table",
  //                         fillColor: const Color(0xffffffff)),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //
  //                 Container(
  //                //   width: MediaQuery.of(context).size.width / 4,
  //                   height: MediaQuery.of(context).size.height / 20,
  //                   child: TextField(
  //                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
  //                     controller: reservationCustomerNameController,
  //                     //  focusNode: nameFcNode,
  //                     keyboardType: TextInputType.text,
  //                     textCapitalization: TextCapitalization.words,
  //                     decoration: InputDecoration(
  //                         enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
  //                         contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
  //                         filled: true,
  //                         suffixStyle: const TextStyle(
  //                           color: Colors.red,
  //                         ),
  //                         hintStyle: customisedStyle(context, const Color(0xff858585), FontWeight.w400, 14.0),
  //                         hintText: "Customer name",
  //                         fillColor: const Color(0xffffffff)),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //
  //                 ValueListenableBuilder(
  //                     valueListenable: reservationDate,
  //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
  //                       return GestureDetector(
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             border: Border.all(
  //                               color: Colors.white,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           width: MediaQuery.of(context).size.width / 3,
  //                           height: MediaQuery.of(context).size.height / 20,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "  Date",
  //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 8.0),
  //                                 child: Text(
  //                                   dateFormat.format(dateNewValue),
  //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () {
  //                           showDatePickerFunction(context, reservationDate);
  //                         },
  //                       );
  //                     }),
  //                 // timeNotifierFromDate
  //                 // timeNotifierToDate
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //                 ValueListenableBuilder(
  //                     valueListenable: timeNotifierFromTime,
  //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
  //                       return GestureDetector(
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             border: Border.all(
  //                               color: Colors.white,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           width: MediaQuery.of(context).size.width / 3,
  //                           height: MediaQuery.of(context).size.height / 20,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "  From",
  //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 8.0),
  //                                 child: Text(
  //                                   timeFormat.format(dateNewValue),
  //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () async {
  //                           TimeOfDay? pickedTime = await showTimePicker(
  //                             initialTime: TimeOfDay.now(),
  //                             context: context,
  //                           );
  //                           if (pickedTime != null) {
  //                             timeNotifierFromTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
  //                           } else {
  //                             print("Time is not selected");
  //                           }
  //                         },
  //                       );
  //                     }),
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //
  //                 ValueListenableBuilder(
  //                     valueListenable: timeNotifierToTime,
  //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
  //                       return GestureDetector(
  //                         child: Container(
  //                           decoration: BoxDecoration(
  //                             color: Colors.white,
  //                             border: Border.all(
  //                               color: Colors.white,
  //                               width: 2,
  //                             ),
  //                           ),
  //                           width: MediaQuery.of(context).size.width / 3,
  //                           height: MediaQuery.of(context).size.height / 20,
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 "  To",
  //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
  //                               ),
  //                               Padding(
  //                                 padding: const EdgeInsets.only(right: 8.0),
  //                                 child: Text(
  //                                   timeFormat.format(dateNewValue),
  //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
  //                                 ),
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                         onTap: () async {
  //                           TimeOfDay? pickedTime = await showTimePicker(
  //                             initialTime: TimeOfDay.now(),
  //                             context: context,
  //                           );
  //                           if (pickedTime != null) {
  //                             timeNotifierToTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
  //                           } else {
  //                             print("Time is not selected");
  //                           }
  //                         },
  //                       );
  //                     }),
  //
  //                 const SizedBox(
  //                   height: 8,
  //                 ),
  //                 Container(
  //                   height: MediaQuery.of(context).size.height / 18,
  //                   decoration: BoxDecoration(color: const Color(0xffF25F29), borderRadius: BorderRadius.circular(4)),
  //                   child: TextButton(
  //                     onPressed: () {
  //                       if (reservationCustomerNameController.text == "") {
  //                         popAlertWithColor(head: "Alert", message:  'Please enter customer name',  position: SnackPosition.TOP,backGroundColor: Colors.red,forGroundColor: Colors.white);
  //
  //                       } else {
  //                         reservationController.createReservation(tableID,reservationCustomerNameController.text,apiDateFormat.format(reservationDate.value),
  //                           timeFormatApiFormat.format(timeNotifierFromTime.value),
  //                           timeFormatApiFormat.format(timeNotifierToTime.value),
  //                         );
  //
  //                      //   reserveTable(reservationCustomerNameController.text, tableID);
  //                       }
  //                     },
  //                     child: const Text(
  //                       "Reserve",
  //                       style: TextStyle(color: Colors.white),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 Container(
  //                   height: MediaQuery.of(context).size.height / 18,
  //                   decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
  //                   child: TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       'cancel'.tr,
  //                       style: const TextStyle(color: Colors.black),
  //                     ),
  //                   ),
  //                 ),
  //                 // Other text fields and buttons
  //               ],
  //             ),
  //           ));
  //     },
  //   ).then((value) {
  //
  //   });
  // }
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
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
         Padding(
           padding: const EdgeInsets.only(right: 15.0),
           child: IconButton(onPressed: (){
             showPopup(context);
           }, icon: Icon(Icons.add,color: Colors.blue,)),
         )
        ],
      ),
      body: Column(children: [
       dividerStyle(),
        SizedBox(height: 15,),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        showDatePickerFunction(context, reservationController.fromDateNotifier);
                        reservationController.fetchReservations(
                            reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value),
                            reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/svg/calendar_new.svg"),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              reservationController.dateFormat.format(fromDateNewValue),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        showDatePickerFunction(context, reservationController.toDateNotifier);
                        reservationController.fetchReservations(
                            reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value),
                            reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/svg/calendar_new.svg"),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              reservationController.dateFormat.format(toDateNewValue),
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
            child: Obx(() => reservationController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : reservationController.reservations.isEmpty
                    ? const Center(child: Text("No recent Reservation"))
                    : ListView.builder(
                        itemCount: reservationController.reservations.length,
                        itemBuilder: (context, index) {
                          return Slidable(
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
                                  onPressed: (BuildContext context) async {},
                                  //onPressed: doNothing,
                                  backgroundColor: const Color(0xFFDF1515),
                                  foregroundColor: Colors.white,
                                  child: Icon(Icons.clear),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
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
                                                  reservationController.reservations[index].customerName!,
                                                  style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                  reservationController.reservations[index].tableName!,
                                                  style: customisedStyle(context, Color(0xff00775E), FontWeight.w400, 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:CrossAxisAlignment.end ,
                                            children: [
                                              Text(
                                                reservationController.reservations[index].date!,
                                                style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 13.0),
                                              ),
                                              Text(
                                                "${reservationController.reservations[index].fromTime!} - ${reservationController.reservations[index].toTime!}",
                                                style: customisedStyle(context, Color(0xffAEAEAE), FontWeight.w500, 15.0),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    dividerStyle()
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )))
      ]),
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
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/reservation_controller.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:intl/intl.dart';
// import 'select_table.dart';
//
// class ReservationPage extends StatefulWidget {
//   ReservationPage({super.key});
//
//   @override
//   State<ReservationPage> createState() => _ReservationPageState();
// }
//
// class _ReservationPageState extends State<ReservationPage> {
//   final ReservationController reservationController = Get.put(ReservationController());
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     reservationController.reservations.clear();
//     reservationController.update();
//     reservationController.fetchReservations(reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value), reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
//     reservationDate = ValueNotifier(DateTime.now());
//     timeNotifierFromTime = ValueNotifier(DateTime.now());
//     timeNotifierToTime = ValueNotifier(DateTime.now());
//
//   }
//   DateTime dateTime = DateTime.now();
//   DateFormat dateFormat = DateFormat("dd/MM/yyy");
//   DateFormat apiDateFormat = DateFormat("y-M-d");
//   DateFormat timeFormat = DateFormat.jm();
//   DateFormat timeFormatApiFormat = DateFormat('HH:mm');
//   late ValueNotifier<DateTime> reservationDate;
//   late ValueNotifier<DateTime> timeNotifierFromTime;
//   late ValueNotifier<DateTime> timeNotifierToTime;
//   TextEditingController tableNameController = TextEditingController();
//   TextEditingController reservationCustomerNameController = TextEditingController();
//
//   var tableID = "";
//   void showPopup(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey,
//           title: const Text("Reserve For Later"),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 _buildTextField(
//                   context,
//                   "Select Table",
//                   tableNameController,
//                   readOnly: true,
//                   onTap: () async {
//                     var result = await Get.to(SelectTableReservation());
//                     if (result != null) {
//                       tableID = result[1];
//                       tableNameController.text = result[0];
//
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 _buildTextField(
//                   context,
//                   "Customer name",
//                   reservationCustomerNameController,
//                 ),
//                 const SizedBox(height: 8),
//                 _buildDateSelector(context, reservationDate),
//                 const SizedBox(height: 8),
//                 _buildTimeSelector(context, "From", timeNotifierFromTime),
//                 const SizedBox(height: 8),
//                 _buildTimeSelector(context, "To", timeNotifierToTime),
//                 const SizedBox(height: 8),
//                 _buildButton(
//                   context,
//                   "Reserve",
//                   Colors.white,
//                   Color(0xffF25F29),
//                       () {
//                     if (reservationCustomerNameController.text.isEmpty) {
//                       popAlertWithColor(
//                         head: "Alert",
//                         message: 'Please enter customer name',
//                         position: SnackPosition.TOP,
//                         backGroundColor: Colors.red,
//                         forGroundColor: Colors.white,
//                       );
//                     } else {
//                       reservationController.createReservation(
//                         tableID,
//                         reservationCustomerNameController.text,
//                         apiDateFormat.format(reservationDate.value),
//                         timeFormatApiFormat.format(timeNotifierFromTime.value),
//                         timeFormatApiFormat.format(timeNotifierToTime.value),
//                       );
//                     }
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 _buildButton(
//                   context,
//                   'Cancel',
//                   Colors.black,
//                   Colors.transparent,
//                       () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ).then((value) {});
//   }
//
//   Widget _buildTextField(
//       BuildContext context,
//       String hintText,
//       TextEditingController controller, {
//         bool readOnly = false,
//         VoidCallback? onTap,
//       }) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 20,
//       child: TextField(
//         style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//         controller: controller,
//         readOnly: readOnly,
//         onTap: onTap,
//         decoration: InputDecoration(
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xffC9C9C9)),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xffC9C9C9)),
//           ),
//           disabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Color(0xffC9C9C9)),
//           ),
//           contentPadding: const EdgeInsets.only(
//             left: 20,
//             top: 10,
//             right: 10,
//             bottom: 10,
//           ),
//           filled: true,
//           hintStyle: customisedStyle(
//             context,
//             const Color(0xff858585),
//             FontWeight.w400,
//             14.0,
//           ),
//           hintText: hintText,
//           fillColor: const Color(0xffffffff),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDateSelector(
//       BuildContext context, ValueNotifier<DateTime> reservationDate) {
//     return ValueListenableBuilder(
//       valueListenable: reservationDate,
//       builder: (BuildContext ctx, DateTime dateNewValue, _) {
//         return GestureDetector(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height / 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "  Date",
//                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Text(
//                     DateFormat.yMd().format(dateNewValue),
//                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           onTap: () {
//             showDatePickerFunction(context, reservationDate);
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildTimeSelector(
//       BuildContext context, String label, ValueNotifier<DateTime> timeNotifier) {
//     return ValueListenableBuilder(
//       valueListenable: timeNotifier,
//       builder: (BuildContext ctx, DateTime dateNewValue, _) {
//         return GestureDetector(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.white, width: 2),
//             ),
//             width: MediaQuery.of(context).size.width / 3,
//             height: MediaQuery.of(context).size.height / 20,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "  $label",
//                   style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: Text(
//                     DateFormat.jm().format(dateNewValue),
//                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           onTap: () async {
//             TimeOfDay? pickedTime = await showTimePicker(
//               initialTime: TimeOfDay.now(),
//               context: context,
//             );
//             if (pickedTime != null) {
//               timeNotifier.value = DateFormat.jm().parse(pickedTime.format(context).toString());
//             } else {
//               print("Time is not selected");
//             }
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildButton(
//       BuildContext context,
//       String text,
//       Color textColor,
//       Color buttonColor,
//       VoidCallback onPressed,
//       ) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 18,
//       decoration: BoxDecoration(
//         color: buttonColor,
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: TextButton(
//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(color: textColor),
//         ),
//       ),
//     );
//   }
//   // showPopup(BuildContext context) {
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //           backgroundColor: Colors.grey,
//   //           title: const Text("Reserve For Later"),
//   //           content: SingleChildScrollView(
//   //             child: ListBody(
//   //               children: [
//   //                 Container(
//   //                 //  width: MediaQuery.of(context).size.width / 4,
//   //                   height: MediaQuery.of(context).size.height / 20,
//   //                   child: TextField(
//   //                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//   //                     controller: tableNameController,
//   //                     //  focusNode: nameFcNode,
//   //                    readOnly: true,
//   //                     onTap: ()async{
//   //                       var result =  await Get.to(SelectTableReservation());
//   //                       if(result!=null){
//   //                         tableID = result[1];
//   //                         tableNameController.text = result[0];
//   //                         showPopup(context);
//   //                       }
//   //                     },
//   //                     decoration: InputDecoration(
//   //                         enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//   //                         filled: true,
//   //                         suffixStyle: const TextStyle(
//   //                           color: Colors.red,
//   //                         ),
//   //                         hintStyle: customisedStyle(context, const Color(0xff858585), FontWeight.w400, 14.0),
//   //                         hintText: "Select Table",
//   //                         fillColor: const Color(0xffffffff)),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //
//   //                 Container(
//   //                //   width: MediaQuery.of(context).size.width / 4,
//   //                   height: MediaQuery.of(context).size.height / 20,
//   //                   child: TextField(
//   //                     style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//   //                     controller: reservationCustomerNameController,
//   //                     //  focusNode: nameFcNode,
//   //                     keyboardType: TextInputType.text,
//   //                     textCapitalization: TextCapitalization.words,
//   //                     decoration: InputDecoration(
//   //                         enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
//   //                         contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//   //                         filled: true,
//   //                         suffixStyle: const TextStyle(
//   //                           color: Colors.red,
//   //                         ),
//   //                         hintStyle: customisedStyle(context, const Color(0xff858585), FontWeight.w400, 14.0),
//   //                         hintText: "Customer name",
//   //                         fillColor: const Color(0xffffffff)),
//   //                   ),
//   //                 ),
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //
//   //                 ValueListenableBuilder(
//   //                     valueListenable: reservationDate,
//   //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
//   //                       return GestureDetector(
//   //                         child: Container(
//   //                           decoration: BoxDecoration(
//   //                             color: Colors.white,
//   //                             border: Border.all(
//   //                               color: Colors.white,
//   //                               width: 2,
//   //                             ),
//   //                           ),
//   //                           width: MediaQuery.of(context).size.width / 3,
//   //                           height: MediaQuery.of(context).size.height / 20,
//   //                           child: Row(
//   //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                             children: [
//   //                               Text(
//   //                                 "  Date",
//   //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//   //                               ),
//   //                               Padding(
//   //                                 padding: const EdgeInsets.only(right: 8.0),
//   //                                 child: Text(
//   //                                   dateFormat.format(dateNewValue),
//   //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//   //                                 ),
//   //                               )
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         onTap: () {
//   //                           showDatePickerFunction(context, reservationDate);
//   //                         },
//   //                       );
//   //                     }),
//   //                 // timeNotifierFromDate
//   //                 // timeNotifierToDate
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //                 ValueListenableBuilder(
//   //                     valueListenable: timeNotifierFromTime,
//   //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
//   //                       return GestureDetector(
//   //                         child: Container(
//   //                           decoration: BoxDecoration(
//   //                             color: Colors.white,
//   //                             border: Border.all(
//   //                               color: Colors.white,
//   //                               width: 2,
//   //                             ),
//   //                           ),
//   //                           width: MediaQuery.of(context).size.width / 3,
//   //                           height: MediaQuery.of(context).size.height / 20,
//   //                           child: Row(
//   //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                             children: [
//   //                               Text(
//   //                                 "  From",
//   //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//   //                               ),
//   //                               Padding(
//   //                                 padding: const EdgeInsets.only(right: 8.0),
//   //                                 child: Text(
//   //                                   timeFormat.format(dateNewValue),
//   //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//   //                                 ),
//   //                               )
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         onTap: () async {
//   //                           TimeOfDay? pickedTime = await showTimePicker(
//   //                             initialTime: TimeOfDay.now(),
//   //                             context: context,
//   //                           );
//   //                           if (pickedTime != null) {
//   //                             timeNotifierFromTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
//   //                           } else {
//   //                             print("Time is not selected");
//   //                           }
//   //                         },
//   //                       );
//   //                     }),
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //
//   //                 ValueListenableBuilder(
//   //                     valueListenable: timeNotifierToTime,
//   //                     builder: (BuildContext ctx, DateTime dateNewValue, _) {
//   //                       return GestureDetector(
//   //                         child: Container(
//   //                           decoration: BoxDecoration(
//   //                             color: Colors.white,
//   //                             border: Border.all(
//   //                               color: Colors.white,
//   //                               width: 2,
//   //                             ),
//   //                           ),
//   //                           width: MediaQuery.of(context).size.width / 3,
//   //                           height: MediaQuery.of(context).size.height / 20,
//   //                           child: Row(
//   //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                             children: [
//   //                               Text(
//   //                                 "  To",
//   //                                 style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),
//   //                               ),
//   //                               Padding(
//   //                                 padding: const EdgeInsets.only(right: 8.0),
//   //                                 child: Text(
//   //                                   timeFormat.format(dateNewValue),
//   //                                   style: customisedStyle(context, Colors.grey, FontWeight.w400, 14.0),
//   //                                 ),
//   //                               )
//   //                             ],
//   //                           ),
//   //                         ),
//   //                         onTap: () async {
//   //                           TimeOfDay? pickedTime = await showTimePicker(
//   //                             initialTime: TimeOfDay.now(),
//   //                             context: context,
//   //                           );
//   //                           if (pickedTime != null) {
//   //                             timeNotifierToTime.value = DateFormat.jm().parse(pickedTime.format(context).toString());
//   //                           } else {
//   //                             print("Time is not selected");
//   //                           }
//   //                         },
//   //                       );
//   //                     }),
//   //
//   //                 const SizedBox(
//   //                   height: 8,
//   //                 ),
//   //                 Container(
//   //                   height: MediaQuery.of(context).size.height / 18,
//   //                   decoration: BoxDecoration(color: const Color(0xffF25F29), borderRadius: BorderRadius.circular(4)),
//   //                   child: TextButton(
//   //                     onPressed: () {
//   //                       if (reservationCustomerNameController.text == "") {
//   //                         popAlertWithColor(head: "Alert", message:  'Please enter customer name',  position: SnackPosition.TOP,backGroundColor: Colors.red,forGroundColor: Colors.white);
//   //
//   //                       } else {
//   //                         reservationController.createReservation(tableID,reservationCustomerNameController.text,apiDateFormat.format(reservationDate.value),
//   //                           timeFormatApiFormat.format(timeNotifierFromTime.value),
//   //                           timeFormatApiFormat.format(timeNotifierToTime.value),
//   //                         );
//   //
//   //                      //   reserveTable(reservationCustomerNameController.text, tableID);
//   //                       }
//   //                     },
//   //                     child: const Text(
//   //                       "Reserve",
//   //                       style: TextStyle(color: Colors.white),
//   //                     ),
//   //                   ),
//   //                 ),
//   //
//   //                 Container(
//   //                   height: MediaQuery.of(context).size.height / 18,
//   //                   decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(4)),
//   //                   child: TextButton(
//   //                     onPressed: () {
//   //                       Navigator.pop(context);
//   //                     },
//   //                     child: Text(
//   //                       'cancel'.tr,
//   //                       style: const TextStyle(color: Colors.black),
//   //                     ),
//   //                   ),
//   //                 ),
//   //                 // Other text fields and buttons
//   //               ],
//   //             ),
//   //           ));
//   //     },
//   //   ).then((value) {
//   //
//   //   });
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
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
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Reservations'.tr,
//               style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//         actions: [
//           // ElevatedButton(
//           //     onPressed: () async{
//           //       showPopup(context);
//           //     },
//           //     child: Text("Reservation"))
//         ],
//       ),
//       body: Column(children: [
//         Padding(
//           padding: const EdgeInsets.only(top: 10.0, bottom: 12),
//           child: Container(
//             height: 1,
//             color: const Color(0xffE9E9E9),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ValueListenableBuilder(
//                 valueListenable: reservationController.fromDateNotifier,
//                 builder: (BuildContext ctx, fromDateNewValue, _) {
//                   return ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         backgroundColor: Color(0xffFFF6F2),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
//                         minimumSize: const Size(150, 40),
//                       ),
//                       onPressed: () {
//                         showDatePickerFunction(context, reservationController.fromDateNotifier);
//                         reservationController.fetchReservations(
//                             reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value),
//                             reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
//                       },
//                       child: Row(
//                         children: [
//                           SvgPicture.asset("assets/svg/calendar_new.svg"),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text(
//                               reservationController.dateFormat.format(fromDateNewValue),
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ));
//                 }),
//             SizedBox(
//               width: 8,
//             ),
//             ValueListenableBuilder(
//                 valueListenable: reservationController.toDateNotifier,
//                 builder: (BuildContext ctx, toDateNewValue, _) {
//                   return ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         elevation: 0.0,
//                         backgroundColor: Color(0xffFFF6F2),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
//                         minimumSize: const Size(150, 40),
//                       ),
//                       onPressed: () {
//                         showDatePickerFunction(context, reservationController.toDateNotifier);
//                         reservationController.fetchReservations(
//                             reservationController.apiDateFormat.format(reservationController.fromDateNotifier.value),
//                             reservationController.apiDateFormat.format(reservationController.toDateNotifier.value));
//                       },
//                       child: Row(
//                         children: [
//                           SvgPicture.asset("assets/svg/calendar_new.svg"),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: Text(
//                               reservationController.dateFormat.format(toDateNewValue),
//                               style: const TextStyle(color: Colors.black),
//                             ),
//                           ),
//                         ],
//                       ));
//                 }),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 15.0, bottom: 10),
//           child: Container(
//             height: 1,
//             color: const Color(0xffE9E9E9),
//           ),
//         ),
//         Expanded(
//             child: Obx(() => reservationController.isLoading.value
//                 ? const Center(child: CircularProgressIndicator())
//                 : reservationController.reservations.isEmpty
//                     ? const Center(child: Text("No recent Reservation"))
//                     : ListView.builder(
//                         itemCount: reservationController.reservations.length,
//                         itemBuilder: (context, index) {
//                           return Slidable(
//                             endActionPane: ActionPane(
//                               motion: const ScrollMotion(),
//                               children: [
//                                 // CustomSlidableAction(
//                                 //   flex: 2,
//                                 //   // An action can be bigger than the others.
//                                 //   //  flex: 2,
//                                 //   onPressed: (BuildContext context) async {
//                                 //
//                                 //
//                                 //   },
//                                 //   //onPressed: doNothing,
//                                 //   backgroundColor:Colors.transparent,
//                                 //   foregroundColor: Colors.transparent,
//                                 //   child: Icon(Icons.clear),
//                                 //
//                                 // ),
//                                 CustomSlidableAction(
//                                   flex: 2,
//                                   // An action can be bigger than the others.
//                                   //  flex: 2,
//                                   onPressed: (BuildContext context) async {},
//                                   //onPressed: doNothing,
//                                   backgroundColor: const Color(0xFFDF1515),
//                                   foregroundColor: Colors.white,
//                                   child: Icon(Icons.clear),
//                                 ),
//                               ],
//                             ),
//                             child: GestureDetector(
//                               child: Padding(
//                                 padding: const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
//                                 child: Column(
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(bottom: 12),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           Column(
//                                             mainAxisAlignment: MainAxisAlignment.start,
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Padding(
//                                                 padding: const EdgeInsets.only(right: 8.0),
//                                                 child: Text(
//                                                   reservationController.reservations[index].customerName!,
//                                                   style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(right: 8.0),
//                                                 child: Text(
//                                                   reservationController.reservations[index].tableName!,
//                                                   style: customisedStyle(context, Color(0xff00775E), FontWeight.w400, 15.0),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Column(
//                                             crossAxisAlignment:CrossAxisAlignment.end ,
//                                             children: [
//                                               Text(
//                                                 reservationController.reservations[index].date!,
//                                                 style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 13.0),
//                                               ),
//                                               Text(
//                                                 "${reservationController.reservations[index].fromTime!} - ${reservationController.reservations[index].toTime!}",
//                                                 style: customisedStyle(context, Color(0xffAEAEAE), FontWeight.w500, 15.0),
//                                               ),
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     dividerStyle()
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       )))
//       ]),
//     );
//   }
//
// // void addReservationTable() {
// //   Get.bottomSheet(
// //     isDismissible: true,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.only(
// //         topLeft: Radius.circular(10.0),
// //         // Set border radius to the top left corner
// //         topRight: Radius.circular(
// //             10.0), // Set border radius to the top right corner
// //       ),
// //     ),
// //     backgroundColor: Colors.white,
// //     Container(
// //       child: SingleChildScrollView(
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   Text(
// //                     'reserve_a_table'.tr,
// //                     style: customisedStyle(
// //                         context, Colors.black, FontWeight.w500, 14.0),
// //                   ),
// //                   IconButton(
// //                       onPressed: () {
// //                         Get.back();
// //                       },
// //                       icon: const Icon(
// //                         Icons.clear,
// //                         color: Colors.black,
// //                       ))
// //                 ],
// //               ),
// //             ),
// //             Container(
// //               height: 1,
// //               color: const Color(0xffE9E9E9),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.all(16),
// //               child: Container(
// //                 width: MediaQuery.of(context).size.width / 4,
// //                 child: TextField(
// //                   textCapitalization: TextCapitalization.words,
// //                   controller: diningController.customerNameController,
// //                   style: customisedStyle(
// //                       context, Colors.black, FontWeight.w500, 14.0),
// //                   focusNode: diningController.customerNode,
// //                   onEditingComplete: () {
// //                     FocusScope.of(context)
// //                         .requestFocus(diningController.saveFocusNode);
// //                   },
// //                   keyboardType: TextInputType.text,
// //                   decoration: TextFieldDecoration.defaultTextField(
// //                       hintTextStr: 'customer'.tr),
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(left: 16.0, right: 16),
// //               child: Container(
// //                 decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(10),
// //                     border: Border.all(color: Color(0xffE6E6E6))),
// //                 height: MediaQuery.of(context).size.height / 4.5,
// //                 child: Column(
// //                   children: [
// //                     ValueListenableBuilder(
// //                         valueListenable: diningController.reservationDate,
// //                         builder:
// //                             (BuildContext ctx, DateTime dateNewValue, _) {
// //                           return GestureDetector(
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(
// //                                 8.0,
// //                               ),
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(
// //                                     color: Colors.transparent,
// //                                     width: 2,
// //                                   ),
// //                                 ),
// //                                 //  width: MediaQuery.of(context).size.width / 3,
// //                                 height:
// //                                 MediaQuery.of(context).size.height / 20,
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
// //                                   child: Row(
// //                                     mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                     children: [
// //                                       Text(
// //                                         'Date'.tr,
// //                                         style: customisedStyle(
// //                                             context,
// //                                             Color(0xff8C8C8C),
// //                                             FontWeight.w400,
// //                                             14.0),
// //                                       ),
// //                                       Padding(
// //                                         padding:
// //                                         const EdgeInsets.only(right: 8.0),
// //                                         child: Text(
// //                                           diningController.dateFormat
// //                                               .format(dateNewValue),
// //                                           style: customisedStyle(
// //                                               context,
// //                                               Colors.black,
// //                                               FontWeight.w400,
// //                                               14.0),
// //                                         ),
// //                                       ),
// //                                       SvgPicture.asset("assets/svg/Icon.svg")
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             onTap: () {
// //                               showDatePickerFunction(
// //                                   context, diningController.reservationDate);
// //                             },
// //                           );
// //                         }),
// //                     DividerStyle(),
// //                     ValueListenableBuilder(
// //                         valueListenable: diningController.fromTimeNotifier,
// //                         builder: (BuildContext ctx, timeNewValue, _) {
// //                           return GestureDetector(
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(
// //                                 8.0,
// //                               ),
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(
// //                                     color: Colors.transparent,
// //                                     width: 2,
// //                                   ),
// //                                 ),
// //                                 //  width: MediaQuery.of(context).size.width / 3,
// //                                 height:
// //                                 MediaQuery.of(context).size.height / 20,
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
// //                                   child: Row(
// //                                     mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                     children: [
// //                                       Text(
// //                                         'from'.tr,
// //                                         style: customisedStyle(
// //                                             context,
// //                                             Color(0xff8C8C8C),
// //                                             FontWeight.w400,
// //                                             14.0),
// //                                       ),
// //                                       Padding(
// //                                         padding: const EdgeInsets.only(right: 20.0),
// //                                         child: Text(
// //                                           diningController.timeFormat.format(
// //                                               diningController
// //                                                   .fromTimeNotifier.value),
// //                                           style: customisedStyle(
// //                                               context,
// //                                               Colors.black,
// //                                               FontWeight.w400,
// //                                               14.0),
// //                                         ),
// //                                       ),
// //                                       SvgPicture.asset("assets/svg/Icon.svg")
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             onTap: () async {
// //                               TimeOfDay? pickedTime = await showTimePicker(
// //                                 initialTime: TimeOfDay.now(),
// //                                 context: context,
// //                               );
// //                               if (pickedTime != null) {
// //                                 final time = TimeOfDay(
// //                                     hour: pickedTime.hour,
// //                                     minute: pickedTime.minute);
// //                                 final currentDateTime =diningController.fromTimeNotifier.value;
// //                                 final dateTime = DateTime(
// //                                     currentDateTime.year,
// //                                     currentDateTime.month,
// //                                     currentDateTime.day,
// //                                     time.hour,
// //                                     time.minute);
// //                                 diningController.fromTimeNotifier.value =
// //                                     dateTime;
// //                                 // viewList();
// //                               } else {
// //                                 print("Time is not selected");
// //                               }
// //                             },
// //                           );
// //                         }),
// //                     DividerStyle(),
// //                     ValueListenableBuilder(
// //                         valueListenable: diningController.toTimeNotifier,
// //                         builder: (BuildContext ctx, timeNewValue, _) {
// //                           return GestureDetector(
// //                             child: Padding(
// //                               padding: const EdgeInsets.all(
// //                                 8.0,
// //                               ),
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   border: Border.all(
// //                                     color: Colors.transparent,
// //                                     width: 2,
// //                                   ),
// //                                 ),
// //                                 height:
// //                                 MediaQuery.of(context).size.height / 20,
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(left: 5.0,right: 5),
// //                                   child: Row(
// //                                     mainAxisAlignment:
// //                                     MainAxisAlignment.spaceBetween,
// //                                     children: [
// //                                       Text(
// //                                         'to'.tr,
// //                                         style: customisedStyle(
// //                                             context,
// //                                             Color(0xff8C8C8C),
// //                                             FontWeight.w400,
// //                                             14.0),
// //                                       ),
// //                                       Text(
// //                                         diningController.timeFormat.format(
// //                                             diningController
// //                                                 .toTimeNotifier.value),
// //                                         style: customisedStyle(
// //                                             context,
// //                                             Colors.black,
// //                                             FontWeight.w400,
// //                                             14.0),
// //                                       ),
// //                                       SvgPicture.asset("assets/svg/Icon.svg")
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                             onTap: () async {
// //                               TimeOfDay? pickedTime = await showTimePicker(
// //                                 initialTime: TimeOfDay.now(),
// //                                 context: context,
// //                               );
// //                               if (pickedTime != null) {
// //                                 final time = TimeOfDay(
// //                                     hour: pickedTime.hour,
// //                                     minute: pickedTime.minute);
// //                                 final currentDateTime =  diningController.toTimeNotifier.value;
// //                                 final dateTime = DateTime(
// //                                     currentDateTime.year,
// //                                     currentDateTime.month,
// //                                     currentDateTime.day,
// //                                     time.hour,
// //                                     time.minute);
// //                                 diningController.toTimeNotifier.value =
// //                                     dateTime;
// //                                 // viewList();
// //                               } else {
// //                                 print("Time is not selected");
// //                               }
// //                             },
// //                           );
// //                         }),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             Padding(
// //               padding: const EdgeInsets.only(
// //                   left: 16.0, right: 16, bottom: 16, top: 16),
// //               child: Container(
// //                 height: MediaQuery.of(context).size.height / 17,
// //                 child: ElevatedButton(
// //                   style: ButtonStyle(
// //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
// //                       RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(
// //                             8.0), // Adjust the radius as needed
// //                       ),
// //                     ),
// //                     backgroundColor:
// //                     MaterialStateProperty.all(const Color(0xffF25F29)),
// //                   ),
// //                   onPressed: () {
// //                     // Do something with the text
// //
// //                     Get.back(); // Close the bottom sheet
// //                   },
// //                   child: Text(
// //                     'save'.tr,
// //                     style: customisedStyle(
// //                         context, Colors.white, FontWeight.normal, 12.0),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     ),
// //   );
// // }
// }
