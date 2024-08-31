import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/reservation_controller.dart';
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
        surfaceTintColor: Colors.transparent,
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
        dividerStyle(),
        SizedBox(height: 20,),
        Container(
          height:  MediaQuery.of(context).size.height *.88,
          child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
                    height:  MediaQuery.of(context).size.height *.88,
                    child: Obx(() => reservationController.isLoading.value
                        ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffffab00),
                        ))
                        : reservationController.tableData.isEmpty
                        ? Center(
                        child: Text(
                          "No recent orders",
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w400, 18.0),
                        ))
                        : GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 20,
                        childAspectRatio: 2.0,
                        mainAxisExtent: 100
                      ),
                      itemCount: reservationController.tableData.length,
                      itemBuilder: (context, index) {

                        return GestureDetector(
                            onTap: () {
                              Navigator.pop(context,[reservationController.tableData[index]["title"],reservationController.tableData[index]["id"],]);
                            },

                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey,
                                        width: 4,
                                      ),
                                      right: BorderSide(
                                          color: Color(0xffE9E9E9),
                                          width: 1),
                                      bottom: BorderSide(
                                          color: Color(0xffE9E9E9),
                                          width: 1),
                                      top: BorderSide(
                                          color: Color(0xffE9E9E9),
                                          width: 1),
                                    ),
                                  ),
                                  child: GridTile(

                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(

                                            height: MediaQuery.of(context).size.height / 18, //height of button
                                            width: MediaQuery.of(context).size.width / 20,
                                            decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: .1,
                                                  color: const Color(0xffC9C9C9),
                                                ),
                                                borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                                )),
                                            child: SvgPicture.asset("assets/svg/table.svg"),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            reservationController.tableData[index]["title"] ?? "",
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )));
                      },
                    )),
                  ),
                ),
              ]),
        )
    ]),
    );
  }
}
