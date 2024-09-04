import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/controller/pos_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/mobile/car_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/mobile/dining_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/mobile/take_away_page.dart';
import 'dart:io' show Platform;

import '../../controller/pos_controller.dart';
class POSMobilePage extends StatelessWidget {
  final POSController landingPageController;

  POSMobilePage() : landingPageController = Get.put(POSController(defaultIndex: 0));
  final TextStyle unselectedLabelStyle = TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 12);

  final TextStyle selectedLabelStyle = const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Container(
          decoration: const BoxDecoration(

              border: Border(top: BorderSide(color: Color(0xffE9E9E9)))),
             height: Platform.isIOS ? MediaQuery.of(context).size.height / 9:MediaQuery.of(context).size.height / 10,
          child: Center(
            child: BottomNavigationBar(
              elevation: 0.0,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              onTap: landingPageController.changeTabIndex,
              currentIndex: landingPageController.tabIndex.value,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              selectedItemColor: const Color(0xffF25F29),
              unselectedLabelStyle: unselectedLabelStyle,
              selectedLabelStyle: selectedLabelStyle,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: SvgPicture.asset(
                      "assets/svg/dine.svg",
                      color: landingPageController.tabIndex.value == 0 ? const Color(0xffF25F29) : Colors.grey,
                    ),
                  ),
                  label: 'Dining',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: SvgPicture.asset("assets/svg/takeout_dining.svg",
                        color: landingPageController.tabIndex.value == 1 ? const Color(0xffF25F29) : Colors.grey),
                  ),
                  label: 'Takeout',
                  backgroundColor: Colors.white,
                ),
                // BottomNavigationBarItem(
                //   icon: Container(
                //     margin: EdgeInsets.only(bottom: 7),
                //     child: SvgPicture.asset("assets/svg/online_img.svg",
                //         color: landingPageController.tabIndex.value == 2
                //             ? Color(0xffF25F29)
                //             : Colors.grey),
                //   ),
                //   label: 'Online',
                //   backgroundColor: Colors.white,
                // ),
                BottomNavigationBarItem(
                  icon: Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    child: SvgPicture.asset("assets/svg/car_inmgs.svg",
                        color: landingPageController.tabIndex.value == 2 ? const Color(0xffF25F29) : Colors.grey),
                  ),
                  label: 'Car',
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    POSController landingPageController = Get.put(POSController());
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              DiningPage(title: 'Dining', data: landingPageController.tableData),
              TakeAway(title: 'Takeout', data: landingPageController.takeAwayOrders),
              //      OnlinePage(title: 'Online', data: landingPageController.onlineOrders),
              CarPage(title: 'Car', data: landingPageController.carOrders),
            ],
          )),
    );
  }
}
