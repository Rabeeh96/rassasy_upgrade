import 'package:get/get.dart';
import 'package:flutter/material.dart';

class IconController extends GetxController {
  // Map to track selected states for each type
  var selectedType = 'dine'.obs;

  void selectType(String type) {
    selectedType.value = type; // Set the selected type
  }

  Color getColor(String type) {
    return selectedType.value == type ? Color(0xffF25F29) : Colors.grey;
  }

  var selectedActionType = 'print'.obs;

  // Method to update the selected type
  void selectCurrentAction(String type) {
    selectedActionType.value = type;
  }


  var selectedIndex = Rx<int?>(null);

  // void selectItem(int index) {
  //   selectedIndex.value = index;
  //   // Show an alert dialog with the selected item index
  //
  // }
  void selectItem(int index) {
    selectedIndex.value = index;

    // Open the bottom sheet after selecting an item


  }

  // var isBottomSheetOpen = RxBool(false);
  //
  // void openBottomSheet() {
  //   isBottomSheetOpen.value = true;
  // }
  //
  // void closeBottomSheet() {
  //   selectedIndex.value=1000;
  //
  // }
}