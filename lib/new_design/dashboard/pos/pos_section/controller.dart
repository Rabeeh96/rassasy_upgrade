import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var showImage = true.obs; // Observable boolean for showing image

  // Observable font sizes
  var productFontSize = 12.0.obs;
  var descriptionFontSize = 12.0.obs;
  var unitNameFontSize = 12.0.obs;
  var rateFontSize = 12.0.obs;
  var buttonsFontSize = 13.0.obs;
  var labelHeight = 15.0.obs;

  // Observable dimensions
  var widthOFTable = 5.0.obs;
  var heightOFTable = 1.6.obs;
  var rowCountGridView = 4.obs;
  TextEditingController productFontSizeController = TextEditingController()..text="12.0";
  TextEditingController descriptionFontSizeController = TextEditingController();
  TextEditingController unitNameFontSizeController = TextEditingController();
  TextEditingController rateFontSizeController = TextEditingController();
  TextEditingController buttonsFontSizeController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController heightController = TextEditingController()..text="1.6";
  TextEditingController enableAddProductController = TextEditingController();
  TextEditingController numberKeyController = TextEditingController();
  TextEditingController buttonHeightController = TextEditingController();
  // Methods to update settings
  void updateProductFontSize(double value) {
    productFontSize.value = value;
  }

  void updateDescriptionFontSize(double value) {
    descriptionFontSize.value = value;
  }

  void updateUnitNameFontSize(double value) {
    unitNameFontSize.value = value;
  }

  void updateRateFontSize(double value) {
    rateFontSize.value = value;
  }

  void updateButtonsFontSize(double value) {
    buttonsFontSize.value = value;
  }

  void updateWidthOFTable(double value) {
    widthOFTable.value = value;
  }

  void updateHeightOFTable(double value) {
    heightOFTable.value = value;
  }

  void updateRowCountGridView(int value) {
    rowCountGridView.value = value;
  }
}
