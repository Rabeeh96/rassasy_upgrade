import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/reservation_controller.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../profile_mobile/settings/online_platforms/model/online_platfom_list_model.dart';

class SelectTableReservation extends StatefulWidget {
  SelectTableReservation({super.key});

  @override
  State<SelectTableReservation> createState() => _SelectTableReservationState();
}

class _SelectTableReservationState extends State<SelectTableReservation> {
  ReservationController reservationController = Get.put(ReservationController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservationController.fetchTable();
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
              'choose_table'.tr,
              style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
      body: Column(children: [

        DividerStyle(),
        SizedBox(height: 20,),
        // Expanded(
        //     child: Obx(() =>
        //         reservationController.isLoading.value?
        //         const Center(child: CircularProgressIndicator()):
        //         reservationController.tableData.isEmpty
        //             ? const Center(child: Text("Table not found"))
        //             : ListView.separated(
        //
        //           separatorBuilder: (context, index) => DividerStyle(),
        //           itemCount: reservationController.tableData.length,
        //           itemBuilder: (context, index) {
        //             return GestureDetector(
        //               onTap: () {
        //
        //
        //                 print("----${reservationController.tableData[index].tableName}");
        //
        //             //    Navigator.pop(context);
        //               },
        //               child: InkWell(
        //                 child: Padding(
        //                   padding: const EdgeInsets.only(left: 15.0, right: 15, top: 18, bottom: 18),
        //                   child: Padding(
        //                     padding:   const EdgeInsets.only(right: 8.0),
        //                     child: Text(
        //                       reservationController.tableData[index]["title"]??"",
        //                       style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             );
        //           },
        //         )
        //     )
        //
        //
        // ),


        Expanded(
          child: Obx(
            () => reservationController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : reservationController.tableData.isEmpty
                    ? const Center(child: Text("Table not found"))
                    : GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Number of columns in the grid
                          crossAxisSpacing: 10.0, // Spacing between columns
                          mainAxisSpacing: 10.0, // Spacing between rows
                          childAspectRatio: 2, // Aspect ratio of each grid item
                        ),
                        itemCount: reservationController.tableData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context,[reservationController.tableData[index]["title"],reservationController.tableData[index]["id"],]);
                            },
                            child: InkWell(
                              child: Container(
                                  height: MediaQuery.of(context).size.height / 14, //height of button
                                  //    width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xffC9C9C9),
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                      )),

                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 5.0),
                                        child: Container(

                                          height: MediaQuery.of(context).size.height / 18, //height of button
                                          width: MediaQuery.of(context).size.width / 16,
                                          decoration: BoxDecoration(
                                            //  color: Colors.red,
                                              border: Border.all(
                                                width: .1,
                                                color: const Color(0xffC9C9C9),
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                              )),

                                          child: SvgPicture.asset("assets/svg/table.svg"),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          reservationController.tableData[index]["title"] ?? "",
                                          style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        )
      ]),
    );
  }
}
