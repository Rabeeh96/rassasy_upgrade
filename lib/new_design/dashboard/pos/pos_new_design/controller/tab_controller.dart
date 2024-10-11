import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

//class IconController extends GetxController {
  // TextEditingController tablenameController = TextEditingController();
  // TextEditingController tablesplitController = TextEditingController();
  // TextEditingController splitcountcontroller = TextEditingController(text: '1');
  // Map to track selected states for each type
//   var selectedType = 'dine'.obs;

//   void selectType(String type) {
//     selectedType.value = type; // Set the selected type
//   }

//   Color getColor(String type) {
//     return selectedType.value == type ? const Color(0xffF25F29) : Colors.grey;
//   }

//   var selectedActionType = 'print'.obs;

//   // Method to update the selected type
//   void selectCurrentAction(String type) {
//     selectedActionType.value = type;
//   }

//   var selectedIndex = Rx<int?>(1000);
//   var selectedsplitIndex = Rx<int?>(1000);
//   var takeawayselectedIndex = Rx<int?>(1000);
//   var onlineselectedIndex = Rx<int?>(1000);
//   var carselectedIndex = Rx<int?>(1000);
//   var tablemodalselectedIndex = Rx<int?>(1000);

// //  var selectedIndexcombine = Rx<int?>(0);
//   void selectItem(int index) {
//     selectedIndex.value = index;
//   }

//   void selectsplitItem(int index) {
//     selectedsplitIndex.value = index;
//   }

//   void takeAwayselectItem(int index) {
//     takeawayselectedIndex.value = index;
//   }

//   void onlineSelectItem(int index) {
//     onlineselectedIndex.value = index;
//   }

//   void carSelectItem(int index) {
//     carselectedIndex.value = index;
//   }

//   void tableModalSelectItem(int index) {
//     tablemodalselectedIndex.value = index;
//   }

//   // final isChecked = false.obs;
//   RxBool isChecked = RxBool(false);

//   // List<int> selectList = [];
//   RxList<int> selectList = RxList<int>();

//   List combineDatas = [];

//   // RxList<int> combineDatas = <int>[].obs;
//   RxBool isCombine = false.obs;
//   final tableData = [].obs;
//   final selectedCombinedIndex = 0.obs;

//   bool indexContain(int index) {
//     final datalist = selectList.contains(index);
//     log("ok");
//     log(datalist.toString());
//     return datalist;
//   }

//   checkedbtn(int index) {
//     final datalist = selectList.contains(index);
//     if (datalist) {
//       selectList.remove(index);
//     } else {
//       selectList.add(index);
//     }
//   }

//   final screenshotController = ScreenshotController();
//   Future<void> requestPermission() async {
//     await Permission.storage.request();
//   }

//   Future<void> saveQrCode() async {
//     try {
//       var time = DateTime.now().millisecondsSinceEpoch.toString();
//       String pathName = "$time + qr_code.png";
//       final directory = await getDownloadsDirectory();
//       final file = File('${directory!.path}/$pathName');

//       final uiImg = await screenshotController.capture();

//       await file.writeAsBytes(uiImg!);
//       log("QR code saved to ${file.path}");
//     } catch (e) {
//       log("Error saving QR code: $e");
//     }
//   }
// }
