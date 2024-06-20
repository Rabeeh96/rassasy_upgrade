import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/pos_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/service/pos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../global/global.dart';

class POSController extends GetxController {
  RxInt tabIndex=0.obs;
final isLoadTable=false.obs;
  POSController({int defaultIndex = 0}) : tabIndex = defaultIndex.obs;

 // var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;

  }

  @override
  void onInit() {

    tabIndex.value = 0;
    fetchAllData();
    update();
    super.onInit();
  }

  clear() {
    tableData.clear();
    onlineOrders.clear();
    takeAwayOrders.clear();
    carOrders.clear();
  }

  var selectedIndex = -1.obs;
  static final List<String> labels = ['All', 'Vacant', 'Ordered', 'Paid'];

  final ValueNotifier<int> carItemSelectedNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

  static final List<String> carItems = [
    'All',
    'Zomato',
    'Swiggy',
  ];





  final ValueNotifier<bool> isDismiss = ValueNotifier<bool>(false);

  TextEditingController customerNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController deliveryManController = TextEditingController();
  TextEditingController platformController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController grandTotalController = TextEditingController();
  late ValueNotifier<DateTime> reservationDate = ValueNotifier(DateTime.now());

  late ValueNotifier<DateTime> fromTimeNotifier = ValueNotifier(DateTime.now());
  late ValueNotifier<DateTime> toTimeNotifier = ValueNotifier(DateTime.now());
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");

  DateFormat timeFormat = DateFormat.jm();
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');
  FocusNode customerNode = FocusNode();
  FocusNode categoryNode = FocusNode();
  FocusNode saveFocusNode = FocusNode();
  final selectedItem = ''.obs;

  void selectButton(int index) {
    selectedIndex = index;
  }

  String currency = "SR";
  RxString userName = "".obs;

  final TableService _tableService = TableService();
  var tableData = <Data>[].obs;
  var fullOrderData = <Data>[].obs;
  var onlineOrders = <Online>[].obs;
  var takeAwayOrders = <TakeAway>[].obs;
  var carOrders = <Car>[].obs;
  var cancelOrder = [].obs;
  var isLoading = true.obs;

  ///this function used for getting time
  ///in hours and minute
  String returnOrderTime(String data, String status) {

    if(status !="Vacant"){
      print("----data $data   $status");
    }

    if (data == "" || status == "Vacant") {
      return "";
    }

    var t = data;
    var yy = int.parse(t.substring(0, 4));
    var month = int.parse(t.substring(5, 7));
    var da = int.parse(t.substring(8, 10));
    var hou = int.parse(t.substring(11, 13));
    var mnt = int.parse(t.substring(14, 16));
    var sec = int.parse(t.substring(17, 19));

    var startTime = DateTime(yy, month, da, hou, mnt, sec);
    var currentTime = DateTime.now();

    var difference = currentTime.difference(startTime);
    var hours = difference.inHours;
    var remainingMinutes = difference.inMinutes.remainder(60);

    ///to get time in hours and minutes
    if (difference.inHours > 0) {
      if (remainingMinutes > 0) {
        return "${hours} hour${hours > 1 ? 's' : ''} ${remainingMinutes} minute${remainingMinutes > 1 ? 's' : ''}";
      } else {
        return "${hours} hour${hours > 1 ? 's' : ''}";
      }
    } else {
      return "${remainingMinutes} minute${remainingMinutes > 1 ? 's' : ''}";
    }
  }

  ///fetch all api call
  void fetchAllData() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      currency= prefs.getString('CurrencySymbol') ?? "";
      userName.value = prefs.getString('user_name')??"";
      var fetchedData = await _tableService.fetchAllData(accessToken);

      selectedIndexNotifier.value = 0;
      log_data("${fetchedData['data']}");
      tableData.assignAll((fetchedData['data'] as List).map((json) => Data.fromJson(json)).toList());
      fullOrderData.assignAll((fetchedData['data'] as List).map((json) => Data.fromJson(json)).toList());
      onlineOrders.assignAll((fetchedData['Online'] as List).map((json) => Online.fromJson(json)).toList());
      takeAwayOrders.assignAll((fetchedData['TakeAway'] as List).map((json) => TakeAway.fromJson(json)).toList());
      carOrders.assignAll((fetchedData['Car'] as List).map((json) => Car.fromJson(json)).toList());
      cancelOrder.assignAll(fetchedData['Reasons']??[]);
    } finally {
      isLoading(false);
    }
  }
  //

  /// create table
  Future<void> createTableApi() async {
    try {
      isLoading(true);


      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0'; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;

      var accessToken = prefs.getString('access') ?? '';
      final String url = '$baseUrl/posholds/table-create/';
      var suffix = "";

      var tableName = customerNameController.text;
      var name = suffix + tableName;


      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "TableName": name,
        "IsActive": true,
        "PriceCategoryID": "",
      };

      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      print(response.body);
      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      if (status == 6000) {
        Get.back();
        fetchAllData();
        customerNameController.clear();

      } else if (status == 6001) {
        var msg = responseData["message"];
        Get.snackbar('Error', msg); // Show error message
      } else {
        // Handle other cases
      }
    } catch (e) {
      // Handle exceptions
    } finally {
      isLoading(false);
    }
  }
  /// cancel

  Future<void> cancelOrderApi({required BuildContext context,required String type,required  String tableID,required String cancelReasonId,required String orderID}) async {
    try {
      isLoading(true);


      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0'; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      bool printForCancelOrder = prefs.getBool('print_for_cancel_order') ?? false;
      var accessToken = prefs.getString('access') ?? '';



      final String url = '$baseUrl/posholds/reset-status/';
      var suffix = "";

      var tableName = customerNameController.text;
      var name = suffix + tableName;

      if (type == "TakeAway" || type == "Dining" || type == "Online" || type == "Car") {
        cancelReasonId = "";
      }

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "Type": type,
        "unqid":type=="Dining&Cancel"||type=="Dining"?tableID:orderID,
        "reason_id": cancelReasonId,
      };

      print("type  $type");
      print(data);
      //encode Map to JSON
      var body = json.encode(data);

      var response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: body,
      );

      print(response.body);
      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      if (status == 6000) {
        fetchAllData();

        /// print section commented


        print("cancelReasonId  cancelReasonId cancelReasonId  $cancelReasonId");

        if(cancelReasonId !=""){
          if (printForCancelOrder){
            printSection(
                context: context,
                id: orderID,
                isCancelled: false,
                voucherType: "SO"
            );
            // await printDetail(true);
          }
        }

        // if (orderID != "") {
        //   await ReprintKOT(orderID, true);
        // }
      }
      else if (status == 6001) {
        var msg = responseData["message"];
        Get.snackbar('Error', msg); // Show error message
      }
      else {
        // Handle other cases
      }
    } catch (e) {
      // Handle exceptions
    } finally {
      isLoading(false);
    }
  }

  var printHelperUsb = USBPrintClass();
  var printHelperIP = AppBlocs();
  var bluetoothHelper =   AppBlocsBT();



  printKOT({required String orderID,required bool  rePrint,required List cancelList,required bool isUpdate}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var printType = prefs.getString('PrintType') ?? 'Wifi';
      if (printType == 'Wifi') {
        printHelperIP.printKotPrint(orderID, rePrint, cancelList, isUpdate,false);
      }
      else {
        printHelperUsb.printKotPrint(orderID, rePrint, cancelList, isUpdate);
      }
    } catch (e) {
      print(e.toString());
    }
  }


  printSection({required BuildContext context,required String voucherType,required String id,required bool isCancelled})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var defaultIp = prefs.getString('defaultIP') ?? '';

       var printType = prefs.getString('PrintType') ?? 'Wifi';

      var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
      if (defaultIp == "") {
        popAlert(head: "Warning", message: "Please select a default printer", position: SnackPosition.TOP);

      } else {
        if (printType == 'Wifi') {
          PrintDataDetails.type = voucherType;
          PrintDataDetails.id = id;
          var ret = await printHelperIP.printDetails();
          print("==========ret $ret");
          if (ret == 2) {
            var ip = "";
            if (voucherType == "SO") {
              ip = defaultOrderIP;
            } else {
              ip = defaultIp;
            }
            printHelperIP.print_receipt(ip, context, isCancelled);
          } else {
            popAlert(head: "Error", message: "Error on loading Data ! Please try again later", position: SnackPosition.TOP);


          }
        }
        else  if (printType == 'USB'){
          PrintDataDetails.type = voucherType;
          PrintDataDetails.id = id;
          print("usb 1");
          var ret = await printHelperUsb.printDetails();
          if (ret == 2) {
            var ip = "";
            if (voucherType == "SO") {
              ip = defaultOrderIP;
            } else {
              ip = defaultIp;
            }
            printHelperUsb.printReceipt(ip, context);
          } else {
            popAlert(head: "Error", message: "Error on loading Data ! Please try again later", position: SnackPosition.TOP);


          }

        }
        else{
          PrintDataDetails.type = voucherType;
          PrintDataDetails.id = id;
          var loadData = await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
          if(loadData){
            var printStatus =await bluetoothHelper.scan(isCancelled);

            if(printStatus ==1){
              popAlert(head: "Alert", message: "Check your bluetooth connection", position: SnackPosition.TOP);
            }
            else if(printStatus ==2){
              popAlert(head: "Alert", message: "Your default printer configuration problem", position: SnackPosition.TOP);

            }
            else if(printStatus ==3){
              await bluetoothHelper.scan(isCancelled);
              // alertMessage("Try again");
            }
            else if(printStatus ==4){
              //  alertMessage("Printed successfully");
            }
          }
          else{
            popAlert(head: "Error", message: "Error on loading Data ! Please try again later", position: SnackPosition.TOP);

          }

        }



      }

  }



}

enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'msg6'.tr,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: TextStyle(color: Colors.red)),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              prefs.setBool('companySelected', false);

              // Navigator.of(context).pushAndRemoveUntil(
              //   CupertinoPageRoute(builder: (context) => LoginPageNew()),
              //       (_) => false,
              // );
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
