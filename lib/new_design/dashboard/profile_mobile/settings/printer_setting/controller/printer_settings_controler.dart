import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintSettingController extends GetxController {


  ///print template

  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  RxString selectedOption="Wifi".obs;
  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var template = prefs.getString("template") ?? "template3";
    var printType = prefs.getString('PrintType') ?? "Wifi";

    if (template == "template3") {
      setTemplate(3);
      setSelectedIndex(0);
    } else {
      setTemplate(4);
      setSelectedIndex(1);
    }



    if (printType == "Wifi") {
      selectedOption.value ="Wifi";
    }

    else if (printType == "BT"){
      selectedOption.value ="BT";

    }
    else {
      selectedOption.value ="USB";
    }

    update();
  }

  RxInt selectedIndex = 0.obs;
  List<String> imagePaths = [
    'assets/png/gst.png',
    'assets/png/vat.png',
  ].obs;

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
    update();
  }

  setTemplate(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("template", "template$id");
  }
}
