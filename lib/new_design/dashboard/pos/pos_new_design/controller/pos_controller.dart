import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/customisation_template/customisation_template.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/mergeModel.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/pos_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/service/pos_service.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/global.dart';

class POSController extends GetxController {
  RxInt tabIndex = 0.obs;
  final isLoadTable = false.obs;
  final isLoadDine = false.obs;
  final isLoadTakeaway = false.obs;
  final isLoadCar = false.obs;

  POSController({int defaultIndex = 0}) : tabIndex = defaultIndex.obs;


  Timer? timer;



  // var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }


  checkPermissionForSave(value) {
    final permissions = {
      1: dining_create_perm.value,
      2: take_away_create_perm.value,
      3: online_create_perm.value,
      4: car_create_perm.value
    };
    return permissions[value] ?? false;
  }

  @override
  void onInit() {
    tabIndex.value = 0;
    // fetchAllData();
   // fetchTOC();
    ReloadAllData();
    update();
    super.onInit();
  }

  clear() {
    tableMergeData.clear();
    onlineOrders.clear();
    takeAwayOrders.clear();
    carOrders.clear();
  }

  // var selectedIndex = -1.obs;
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
  TextEditingController tablenameController = TextEditingController();
  TextEditingController splitcountcontroller = TextEditingController(text: '0');
  // TextEditingController tablesplitController = TextEditingController();
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

  String currency = "SR";
  RxString userName = "".obs;
  RxInt selectedIndexSplit = RxInt(-1);
  final TableService _tableService = TableService();
  var tableData = <Data>[].obs;
  var tableMergeData = <MergeData>[].obs;
  var fullOrderData = <Data>[].obs;
  var onlineOrders = <Online>[].obs;
  var takeAwayOrders = <TakeAway>[].obs;
  var carOrders = <Car>[].obs;
  var cancelOrder = [].obs;
  var isLoading = true.obs;

  var  fullDataList = [].obs;


  ///this function used for getting time
  ///in hours and minute
  String returnOrderTime(String data, String status) {

    if (status != "Vacant") {

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
        return "$hours hour${hours > 1 ? 's' : ''} $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}";
      } else {
        return "$hours hour${hours > 1 ? 's' : ''}";
      }
    } else {
      return "$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}";
    }
  }

  refreshTableData(){
    tableMergeData.clear();
    fetchAllData();
    update();
  }

  refreshTOC(){
    onlineOrders.clear();
    takeAwayOrders.clear();
    carOrders.clear();
    fetchTOC();
    update();
  }


  ///fetch all api call
    fetchAllData() async {
    try {
      isLoading(true);
      update();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      currency = prefs.getString('CurrencySymbol') ?? "";
      userName.value = prefs.getString('user_name') ?? "";

      rowCountGridView.value = prefs.getInt('count_of_row_pos') ?? 2;
      heightOfITem.value = prefs.getDouble('height_of_item_pos') ?? 12.0;

      rowCountGridViewSplit.value = prefs.getInt('count_of_row_pos_split') ?? 2;
      heightOfITemSplit.value = prefs.getDouble('height_of_item_pos_split') ?? 12.0;


      var fetchedData = await _tableService.fetchAllData(accessToken);
      print(fetchedData);
      selectedIndexNotifier.value = 0;
      tableMergeData.assignAll((fetchedData['data'] as List).map((json) => MergeData.fromJson(json)).toList());
      fullDataList.value = fetchedData['data']??[];

      print("fullDataListfullDataList${fullDataList.length}");

      pr(tableMergeData.length.toString());
    } finally {

      isLoading(false);
    }
  }
    fetchAllDataWithoutLoading() async {
    try {

      update();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      currency = prefs.getString('CurrencySymbol') ?? "";
      userName.value = prefs.getString('user_name') ?? "";
      var fetchedData = await _tableService.fetchAllData(accessToken);
      print(fetchedData);
      selectedIndexNotifier.value = 0;
      tableMergeData.assignAll((fetchedData['data'] as List).map((json) => MergeData.fromJson(json)).toList());

      fullDataList.value = fetchedData['data']??[];
      print("fullDataListfullDataList${fullDataList.length}");
      pr(tableMergeData.length.toString());
    } finally {

    }
  }




  ///fetch takeaway,online,car api call
  void fetchTOC() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userID = prefs.getInt('user_id') ?? 0;
      var accessToken = prefs.getString('access') ?? '';
      currency = prefs.getString('CurrencySymbol') ?? "";
      userName.value = prefs.getString('user_name') ?? "";
      var fetchedTOCData = await _tableService.fetchTOC(accessToken);
      print('-**-/-$fetchedTOCData');
      selectedIndexNotifier.value = 0;
      print("--------1");

      if(fetchedTOCData['TakeAwayStatusCode'] ==6000){
        takeAwayOrders.assignAll((fetchedTOCData['TakeAway'] as List).map((json) => TakeAway.fromJson(json)).toList());
        print("--------1");
      }


      if(fetchedTOCData['OnlineStatusCode'] ==6000){
        onlineOrders.assignAll((fetchedTOCData['Online'] as List).map((json) => Online.fromJson(json)).toList());
        print("--------1");
      }


      if(fetchedTOCData['CarStatusCode'] ==6000){
        carOrders.assignAll((fetchedTOCData['Car'] as List).map((json) => Car.fromJson(json)).toList());
        print("--------1");
      }




      // takeAwayOrders.assignAll((fetchedTOCData['TakeAway'] as List).map((json) => TakeAway.fromJson(json)).toList());
      // print("--------1");
      // carOrders.assignAll((fetchedTOCData['Car'] as List).map((json) => Car.fromJson(json)).toList());
      // print("--------1");
      cancelOrder.assignAll(fetchedTOCData['Reasons'] ?? []);
      print("--------1");
    } finally {
      isLoading(false);
    }
  }

  // void mergeData(List combineDatas) async {
  //   try {
  //     isLoading(true);
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var userID = prefs.getInt('user_id') ?? 0;
  //     var accessToken = prefs.getString('access') ?? '';
  //     currency = prefs.getString('CurrencySymbol') ?? "";
  //     userName.value = prefs.getString('user_name') ?? "";
  //     var fetchedmergeData = await _tableService.mergeData(combineDatas);
  //     selectedIndexNotifier.value = 0;
  //     tablemergeData.assignAll(
  //         (fetchedmergeData).map((json) => MergeData.fromJson(json)).toList());

  //     pr(tablemergeData.length.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }
    combineDataFunction(BuildContext context, List combineDatas) async {
    try {
      isLoading(true);
      final fetchedmergeData = await _tableService.mergeData(combineDatas);
      isLoading(false);

      if(fetchedmergeData){
        selectedIndexNotifier.value = 0;
        return [true];
      }
      else{
        return [false,""];
      }

    } catch (e) {
      isLoading(false);
      return [false,e.toString()];
      print('Error: $e');
    }
  }
  /// split merge
   mergeSplitTable(combineData) async {
    try {
      isLoading(true);
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? ''; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      String url = '$baseUrl/posholds/split-tables/${combineData[0]}/merge/';
      print("url$url");
      combineData.removeAt(0);
      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "table_ids": combineData,
      };
      print("data $data");
      var body = json.encode(data);

      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      log("merge response");
      pr(response.body);

      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      if (status == 6000) {
        return [true];
        // Get.back();
        // fetchAllData();
      } else if (status == 6001) {
        var msg = responseData["message"]??"";
        return [false,msg];
      }
      else if (status == 6002) {
        var msg = responseData["error"]??responseData["message"]??"Something went wrong";
        return [false,msg];
      }

      else {
        return [false,"Something went wrong"];

      }
    } catch (e) {
      return [false,"${e.toString()}"];
      // Handle exceptions
    } finally {
      isLoading(false);
    }
  }

  /// create Split table
  Future<void> createTableSplit() async {
    try {
      isLoading(true);
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? ''; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/posholds/split-tables/create/';

      var tablename = tablenameController.text;
      log(tablename.toString());
      var tablesplitCount = splitcountcontroller.text;
      log(tablesplitCount.toString());
      log("ddddd");
      // var check = combineDatas[0];
      // log("checkhhhhhhh==========================");
      // log("combinedata $check");

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "num_tables": tablesplitCount,
        "TableName": tablename,
        "PriceCategoryID": 1,
        "IsActive": true,
      };
      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      log("merge response");
      pr(response.body);

      Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      if (status == 6000) {
        Get.back();
        tablenameController.clear();
        splitcountcontroller.text = "0";
        fetchAllData();
      } else if (status == 6001) {
        var msg = responseData["message"];
        Get.snackbar('Error', msg); // Show error message
      }
      // final addsplit = jsonDecode(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //
      //   log("Add Split Successfull");
      //   fetchAllData();
      //
      //   // return addsplit.values.toList();
      // }
      else {
        throw Exception('Failed to load table data');
      }
    } catch (e) {
      // Handle exceptions
    } finally {
      isLoading(false);
    }
  }
  allCombinedTable(tableID) async {
    try {
      isLoading(true);
      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? ''; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      // http://192.168.1.91:8002/api/v10/posholds/tables/?CompanyID=5a09676a-55ef-47e3-ab02-bac62005d847&BranchID=1&AllCombined=False&get_combine_table_ID=6f6cbbb7-451d-4986-b6d7-450e15a273bc
      final String url = '$baseUrl/posholds/tables/?CompanyID=$companyID&branchID=$branchID&AllCombined=True&get_combine_table_ID=$tableID';
      print("-----url$url");
      var response = await http.get(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          );
      log("merge response");
      pr(response.body);

      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];
      print(response.body);
      if (status == 6000) {
        return true;
      }
      else if (status == 6001) {
        var msg = responseData["message"];
        Get.snackbar('Error', msg);
        return false;
      }
      else{
        return false;
      }
    } catch (e) {
      return false;
      // Handle exceptions
    } finally {
      isLoading(false);

    }
  }

   swapTableFunction({required String fromTableID,required List fromSplitTableList,required String toTableID,required String toSplitTableID}) async {
    try {
      isLoading(true);

      pr("fromTableID $fromTableID");
      pr("fromSplitTableList $fromSplitTableList");
      pr("toTableID $toTableID");
      pr("toSplitTableID $toSplitTableID");

      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? ''; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      final String url = '$baseUrl/posholds/pos_table/swap_order/';
      Map<String, dynamic> data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "fromtable": [
            {
              "From_Main_Table": fromTableID,
              "From_Split_Tables":fromSplitTableList
            }
          ],
        "To_Main_Table": toTableID,
        "To_Split_Table": toSplitTableID
      };

      pr("data$data");
      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      log("merge response");
      pr(response.body);

      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      pr("----------${status}");
      if (status == 6000) {
        pr("-----------11");
        isLoading(false);
        return true;
         // Get.back();
        // tablenameController.clear();
        // splitcountcontroller.text = "0";
        // fetchAllData();
      } else if (status == 6001) {
        isLoading(false);
        var msg = responseData["message"]??responseData["error"]??"";
        Get.snackbar('Error', msg);
        return false;// Show error message
      }

      // final addsplit = jsonDecode(response.body);
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //
      //   log("Add Split Successfull");
      //   fetchAllData();
      //
      //   // return addsplit.values.toList();
      // }
      else {
        isLoading(false);
        pr("-----------12");

        throw Exception('Failed to load table data');
      }
    } catch (e) {
      isLoading(false);
      pr("-----------1");
      return false;
      // Handle exceptions
    }
  }


  /// create table
  Future<void> createTableApi() async {
    try {
      isLoading(true);

      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? ''; // Change to string
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
      Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
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

  Future<void> cancelOrderApi(
      {required BuildContext context,
      required String type,
      required String tableID,
      required String cancelReasonId,
      required String orderID,
      required String splitUID
      }) async {
    try {
      isLoading(true);

      String baseUrl = BaseUrl.baseUrl;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var companyID = prefs.getString('companyID') ?? '0'; // Change to string
      var branchID = prefs.getInt('branchID') ?? 1;
      bool printForCancelOrder =
          prefs.getBool('print_for_cancel_order') ?? false;
      var accessToken = prefs.getString('access') ?? '';

      final String url = '$baseUrl/posholds/reset-status/';
      var suffix = "";

      var tableName = customerNameController.text;
      var name = suffix + tableName;

      if (type == "TakeAway" ||
          type == "Dining" ||
          type == "Online" ||
          type == "Car") {
        cancelReasonId = "";
      }

      Map<String, dynamic> data = {
        "CompanyID": companyID,
        "BranchID": branchID,
        "Type": type,
        "split_table_id":splitUID,
        "unqid": type == "Dining&Cancel" || type == "Dining" ? tableID : orderID,
        "reason_id": cancelReasonId,
      };

      print("url  $url");
      print("type  $type");
      print("token  $accessToken");
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
      Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      var status = responseData["StatusCode"];

      if (status == 6000) {
        pr(type);


        if (type != "Cancel") {
          fetchAllData();
        } else {
          fetchTOC();
        }

        /// print section commented

        if (cancelReasonId != "") {
          if (printForCancelOrder) {
            printSection(
                context: context,
                id: orderID,
                isCancelled: false,
                voucherType: "SO");
            // await printDetail(true);
          }
        }

        // if (orderID != "") {
        //   await ReprintKOT(orderID, true);
        // }
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

  var printHelperUsb = USBPrintClass();
  var printHelperIP = AppBlocs();
  var bluetoothHelper = AppBlocsBT();
  var wifiNewMethod = WifiPrintClassTest();

  printKOT(
      {required String orderID,
      required bool rePrint,
      required List cancelList,
      required bool isUpdate}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var printType = prefs.getString('PrintType') ?? 'Wifi';
      if (printType == 'Wifi') {
        printHelperIP.printKotPrint(
            orderID, rePrint, cancelList, isUpdate, false);
      } else if (printType == 'BT') {
        bluetoothHelper.bluetoothPrintKOT(
            orderID, rePrint, cancelList, isUpdate, isUpdate);
      } else {
        printHelperUsb.printKotPrint(orderID, rePrint, cancelList, isUpdate);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  printSection(
      {required BuildContext context,
      required String voucherType,
      required String id,
      required bool isCancelled}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var temp = prefs.getString("template") ?? "template4";
    var printType = prefs.getString('PrintType') ?? 'Wifi';

    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
    if (defaultIp == "") {
      popAlert(
          head: "Warning",
          message: "Please select a default printer",
          position: SnackPosition.TOP);
    } else {
      if (printType == 'Wifi') {
        if (temp == "template5") {
          var ip = "";
          if (PrintDataDetails.type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }

          await wifiNewMethod.printDetails(
              id: id,
              type: voucherType,
              context: context,
              ipAddress: ip,
              isCancelled: false,
              orderSection: true);
        } else {
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
            printHelperIP.print_receipt(ip, context, isCancelled, false);
          } else {
            popAlert(
                head: "Error",
                message: "Error on loading Data ! Please try again later",
                position: SnackPosition.TOP);
          }
        }
      } else if (printType == 'USB') {
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
          popAlert(
              head: "Error",
              message: "Error on loading Data ! Please try again later",
              position: SnackPosition.TOP);
        }
      } else {
        PrintDataDetails.type = voucherType;
        PrintDataDetails.id = id;
        var loadData =
            await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
        if (loadData) {
          var printStatus = await bluetoothHelper.scan(isCancelled);

          if (printStatus == 1) {
            popAlert(
                head: "Alert",
                message: "Check your bluetooth connection",
                position: SnackPosition.TOP);
          } else if (printStatus == 2) {
            popAlert(
                head: "Alert",
                message: "Your default printer configuration problem",
                position: SnackPosition.TOP);
          } else if (printStatus == 3) {
            await bluetoothHelper.scan(isCancelled);
            // alertMessage("Try again");
          } else if (printStatus == 4) {
            //  alertMessage("Printed successfully");
          }
        } else {
          popAlert(
              head: "Error",
              message: "Error on loading Data ! Please try again later",
              position: SnackPosition.TOP);
        }
      }
    }
  }

  var dining_view_perm = false.obs;
  var reservation_view_perm = false.obs;
  var directOrderOption = false.obs;
  var take_away_view_perm = false.obs;
  var car_view_perm = false.obs;

  var dining_create_perm = false.obs;
  var take_away_create_perm = false.obs;
  var online_create_perm = false.obs;
  var car_create_perm = false.obs;

  var dining_edit_perm = false.obs;
  var take_away_edit_perm = false.obs;
  var car_edit_perm = false.obs;
  var online_edit_perm = false.obs;

  var dining_delete_perm = false.obs;
  var take_away_delete_perm = false.obs;
  var car_delete_perm = false.obs;

  var print_perm = false.obs;
  var cancel_order_perm = false.obs;
  var pay_perm = false.obs;
  var reservation_perm = false.obs;
  var kitchen_print_perm = false.obs;
  var remove_table_perm = false.obs;
  var convert_type_perm = false.obs;
  var rowCountGridView = 2.obs;
  var heightOfITem = 12.0.obs;

   var rowCountGridViewSplit = 2.obs;
   var heightOfITemSplit = 12.0.obs;




  ReloadAllData() async {
    print("----------------------------------------------------------------1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isCombine.value=false;
    isCombineSplit.value=false;
    selectList.clear();
    rowCountGridView.value = prefs.getInt('count_of_row_pos') ?? 2;
    heightOfITem.value = prefs.getDouble('height_of_item_pos') ?? 12.0;

    rowCountGridViewSplit.value = prefs.getInt('count_of_row_pos_split') ?? 2;
    heightOfITemSplit.value = prefs.getDouble('height_of_item_pos_split') ?? 12.0;



    print("-------------------19920 ${rowCountGridView.value} ${heightOfITem.value} ");

    dining_view_perm.value = prefs.getBool('Diningview') ?? true;
    reservation_view_perm.value = prefs.getBool('View Reservation') ?? true;
    directOrderOption.value = prefs.getBool('directOrderOption') ?? false;
    take_away_view_perm.value = prefs.getBool('Take awayview') ?? true;
    car_view_perm.value = prefs.getBool('Carview') ?? true;

    dining_create_perm.value = prefs.getBool('Diningsave') ?? true;
    take_away_create_perm.value = prefs.getBool('Take awaysave') ?? true;
    car_create_perm.value = prefs.getBool('Carsave') ?? true;
    online_create_perm.value = prefs.getBool('Onlinesave') ?? true;

    dining_edit_perm.value = prefs.getBool('Diningedit') ?? true;
    take_away_edit_perm.value = prefs.getBool('Take awayedit') ?? true;
    car_edit_perm.value = prefs.getBool('Caredit') ?? true;
    online_edit_perm.value = prefs.getBool('Onlineedit') ?? true;

    bool kotPrint = prefs.getBool("KOT") ?? false;

    dining_delete_perm.value = prefs.getBool('Diningdelete') ?? true;
    take_away_delete_perm.value = prefs.getBool('Take awaydelete') ?? true;
    car_delete_perm.value = prefs.getBool('Cardelete') ?? true;

    print("----------------------------------------------------------------2");
    cancel_order_perm.value = prefs.getBool('Cancel Order') ?? true;
    pay_perm.value = prefs.getBool('Payment') ?? true;

    pr("pay_perm   pay_perm  ${pay_perm.value}");

    kitchen_print_perm.value = prefs.getBool('KOT Print') ?? true;
    pr("kitchen_print_perm   kitchen_print_perm  ${kitchen_print_perm.value}");
    if (kotPrint == false) {
      kitchen_print_perm.value = false;
    }

    print_perm.value = prefs.getBool('Re-Print') ?? true;
    reservation_perm.value = prefs.getBool('Reserve Table') ?? true;
    remove_table_perm.value = false;
    convert_type_perm.value = false;
    update();
  }

  var selectedType = 'dine'.obs;

  void selectType(String type) {
    selectedType.value = type; // Set the selected type
  }

  Color getColor(String type) {
    return selectedType.value == type ? const Color(0xffF25F29) : Colors.grey;
  }

  var selectedActionType = 'print'.obs;

  // Method to update the selected type
  void selectCurrentAction(String type) {
    selectedActionType.value = type;
  }

  var selectedIndex = Rx<int?>(1000);
  var selectedsplitIndex = Rx<int?>(1000);
  var takeawayselectedIndex = Rx<int?>(1000);
  var onlineselectedIndex = Rx<int?>(1000);
  var carselectedIndex = Rx<int?>(1000);
  var tablemodalselectedIndex = Rx<int?>(1000);

//  var selectedIndexcombine = Rx<int?>(0);
  void selectItem(int index) {
    selectedIndex.value = index;
  }

  void selectsplitItem(int index) {
    selectedsplitIndex.value = index;
    log(selectedsplitIndex.value.toString());
  }

//    startApiCall();
  // @override
  // void dispose() {
  //   posController.timer?.cancel(); // Cancel the timer when the widget is disposed
  //   super.dispose();
  // }
  //
  // void startApiCall() {
  //
  //
  //
  //   posController.timer = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     pr("posController.selectedsplitIndex.value ${posController.selectedsplitIndex.value}posController.isCombine.value   ${posController.isCombine.value}  posController.isCombineSplit.value ${posController.isCombineSplit.value}");
  //     if (posController.isCombine.value==false&&posController.isCombineSplit.value==false &&posController.selectedsplitIndex.value ==1000) {
  //       pr("-----------------------------------------------${posController.selectedType.value} not dine");
  //       if(posController.selectedType.value =="dine"){
  //         posController.fetchAllDataWithoutLoading();
  //       }
  //       else{
  //         pr("//////////////// not dine");
  //       }
  //     }
  //     else{
  //
  //     }
  //
  //
  //
  //   });
  //
  //
  // }


  void takeAwayselectItem(int index) {
    takeawayselectedIndex.value = index;
  }

  void onlineSelectItem(int index) {
    onlineselectedIndex.value = index;
  }

  void carSelectItem(int index) {
    carselectedIndex.value = index;
  }

  void tableModalSelectItem(int index) {
    tablemodalselectedIndex.value = index;
  }

  // final isChecked = false.obs;
  RxBool isChecked = RxBool(false);

  // List<int> selectList = [];
  RxList<int> selectList = RxList<int>();



  // RxList<int> combineDatas = <int>[].obs;
  RxBool isCombine = false.obs;
  RxBool isCombineSplit = false.obs;
  // final tableData = [].obs;
  final selectedCombinedIndex = 0.obs;

  bool indexContain(int index) {
    final datalist = selectList.contains(index);
    log("ok");
    log(datalist.toString());
    return datalist;
  }

  var tableheight = 2.0.obs;
  var tablewidth = 4.obs;

  checkedbtn(int index) {
    final datalist = selectList.contains(index);
    if (datalist) {
      selectList.remove(index);
    } else {
      selectList.add(index);
    }
  }

  final screenshotController = ScreenshotController();
  Future<void> requestPermission() async {
    await Permission.storage.request();
  }

  Future<void> saveQrCode() async {
    try {
      var time = DateTime.now().millisecondsSinceEpoch.toString();
      String pathName = "$time + qr_code.png";
      final directory = await getDownloadsDirectory();
      final file = File('${directory!.path}/$pathName');

      final uiImg = await screenshotController.capture();

      await file.writeAsBytes(uiImg!);
      log("QR code saved to ${file.path}");
    } catch (e) {
      log("Error saving QR code: $e");
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
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: const TextStyle(color: Colors.red)),
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
            child: const Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:rassasy_new/Print/bluetoothPrint.dart';
// import 'package:rassasy_new/global/customclass.dart';
// import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
// import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
// import 'package:rassasy_new/new_design/back_ground_print/wifi_print/back_ground_print_wifi.dart';
// import 'package:rassasy_new/new_design/back_ground_print/wifi_print/customisation_template/customisation_template.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/model/pos_list_model.dart';
// import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/service/pos_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../../../global/global.dart';

// class POSController extends GetxController {
//   RxInt tabIndex = 0.obs;
//   final isLoadTable = false.obs;
//   final isLoadDine = false.obs;
//   final isLoadTakeaway = false.obs;
//   final isLoadCar = false.obs;

//   POSController({int defaultIndex = 0}) : tabIndex = defaultIndex.obs;

//   // var tabIndex = 0.obs;

//   void changeTabIndex(int index) {
//     tabIndex.value = index;
//   }

//   checkPermissionForSave(value) {
//     final permissions = {
//       1: dining_create_perm.value,
//       2: take_away_create_perm.value,
//       3: online_create_perm.value,
//       4: car_create_perm.value
//     };
//     return permissions[value] ?? false;
//   }

//   @override
//   void onInit()void onInit() {
//     tabIndex.value = 0;
//     fetchAllData();
//     ReloadAllData();
//     update();
//     super.onInit();
//   }

//   clear() {
//     tablemergeData.clear();
//     onlineOrders.clear();
//     takeAwayOrders.clear();
//     carOrders.clear();
//   }

//   var selectedIndex = -1.obs;
//   static final List<String> labels = ['All', 'Vacant', 'Ordered', 'Paid'];

//   final ValueNotifier<int> carItemSelectedNotifier = ValueNotifier<int>(0);
//   final ValueNotifier<int> selectedIndexNotifier = ValueNotifier<int>(0);

//   static final List<String> carItems = [
//     'All',
//     'Zomato',
//     'Swiggy',
//   ];

//   final ValueNotifier<bool> isDismiss = ValueNotifier<bool>(false);

//   TextEditingController customerNameController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();
//   TextEditingController deliveryManController = TextEditingController();
//   TextEditingController platformController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   TextEditingController categoryNameController = TextEditingController();
//   TextEditingController grandTotalController = TextEditingController();
//   late ValueNotifier<DateTime> reservationDate = ValueNotifier(DateTime.now());

//   late ValueNotifier<DateTime> fromTimeNotifier = ValueNotifier(DateTime.now());
//   late ValueNotifier<DateTime> toTimeNotifier = ValueNotifier(DateTime.now());
//   DateFormat dateFormat = DateFormat("dd/MM/yyy");
//   DateFormat apiDateFormat = DateFormat("y-M-d");

//   DateFormat timeFormat = DateFormat.jm();
//   DateFormat timeFormatApiFormat = DateFormat('HH:mm');
//   FocusNode customerNode = FocusNode();
//   FocusNode categoryNode = FocusNode();
//   FocusNode saveFocusNode = FocusNode();
//   final selectedItem = ''.obs;

//   void selectButton(int index) {
//     selectedIndex = index;
//   }

//   String currency = "SR";
//   RxString userName = "".obs;
//   RxInt selectedIndexsplit = RxInt(-1);
//   final TableService _tableService = TableService();
//   var tablemergeData = <Data>[].obs;
//   var fullOrderData = <Data>[].obs;
//   var onlineOrders = <Online>[].obs;
//   var takeAwayOrders = <TakeAway>[].obs;
//   var carOrders = <Car>[].obs;
//   var cancelOrder = [].obs;
//   var isLoading = true.obs;

//   ///this function used for getting time
//   ///in hours and minute
//   String returnOrderTime(String data, String status) {
//     if (status != "Vacant") {
//       print("----data $data   $status");
//     }

//     if (data == "" || status == "Vacant") {
//       return "";
//     }

//     var t = data;
//     var yy = int.parse(t.substring(0, 4));
//     var month = int.parse(t.substring(5, 7));
//     var da = int.parse(t.substring(8, 10));
//     var hou = int.parse(t.substring(11, 13));
//     var mnt = int.parse(t.substring(14, 16));
//     var sec = int.parse(t.substring(17, 19));

//     var startTime = DateTime(yy, month, da, hou, mnt, sec);
//     var currentTime = DateTime.now();

//     var difference = currentTime.difference(startTime);
//     var hours = difference.inHours;
//     var remainingMinutes = difference.inMinutes.remainder(60);

//     ///to get time in hours and minutes
//     if (difference.inHours > 0) {
//       if (remainingMinutes > 0) {
//         return "$hours hour${hours > 1 ? 's' : ''} $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}";
//       } else {
//         return "$hours hour${hours > 1 ? 's' : ''}";
//       }
//     } else {
//       return "$remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}";
//     }
//   }

//   ///fetch all api call
//   void fetchAllData() async {
//     try {
//       isLoading(true);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var userID = prefs.getInt('user_id') ?? 0;
//       var accessToken = prefs.getString('access') ?? '';
//       currency = prefs.getString('CurrencySymbol') ?? "";
//       userName.value = prefs.getString('user_name') ?? "";
//       var fetchedData = await _tableService.fetchAllData(accessToken);

//       selectedIndexNotifier.value = 0;
//       tablemergeData.assignAll((fetchedData['data'] as List)
//           .map((json) => Data.fromJson(json))
//           .toList());

//       fullOrderData.assignAll((fetchedData['data'] as List)
//           .map((json) => Data.fromJson(json))
//           .toList());
//       onlineOrders.assignAll((fetchedData['Online'] as List)
//           .map((json) => Online.fromJson(json))
//           .toList());
//       takeAwayOrders.assignAll((fetchedData['TakeAway'] as List)
//           .map((json) => TakeAway.fromJson(json))
//           .toList());
//       carOrders.assignAll((fetchedData['Car'] as List)
//           .map((json) => Car.fromJson(json))
//           .toList());
//       cancelOrder.assignAll(fetchedData['Reasons'] ?? []);
//     } finally {
//       isLoading(false);
//     }
//   }

//   //

//   /// create table
//   Future<void> createTableApi() async {
//     try {
//       isLoading(true);

//       String baseUrl = BaseUrl.baseUrl;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var companyID = prefs.getString('companyID') ?? ''; // Change to string
//       var branchID = prefs.getInt('branchID') ?? 1;

//       var accessToken = prefs.getString('access') ?? '';
//       final String url = '$baseUrl/posholds/table-create/';
//       var suffix = "";

//       var tableName = customerNameController.text;
//       var name = suffix + tableName;

//       Map<String, dynamic> data = {
//         "CompanyID": companyID,
//         "BranchID": branchID,
//         "TableName": name,
//         "IsActive": true,
//         "PriceCategoryID": "",
//       };

//       //encode Map to JSON
//       var body = json.encode(data);

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: body,
//       );

//       print(response.body);
//       Map<String, dynamic> responseData =
//           json.decode(utf8.decode(response.bodyBytes));
//       var status = responseData["StatusCode"];

//       if (status == 6000) {
//         Get.back();
//         fetchAllData();
//         customerNameController.clear();
//       } else if (status == 6001) {
//         var msg = responseData["message"];
//         Get.snackbar('Error', msg); // Show error message
//       } else {
//         // Handle other cases
//       }
//     } catch (e) {
//       // Handle exceptions
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// cancel

//   Future<void> cancelOrderApi(
//       {required BuildContext context,
//       required String type,
//       required String tableID,
//       required String cancelReasonId,
//       required String orderID}) async {
//     try {
//       isLoading(true);

//       String baseUrl = BaseUrl.baseUrl;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var companyID = prefs.getString('companyID') ?? '0'; // Change to string
//       var branchID = prefs.getInt('branchID') ?? 1;
//       bool printForCancelOrder =
//           prefs.getBool('print_for_cancel_order') ?? false;
//       var accessToken = prefs.getString('access') ?? '';

//       final String url = '$baseUrl/posholds/reset-status/';
//       var suffix = "";

//       var tableName = customerNameController.text;
//       var name = suffix + tableName;

//       if (type == "TakeAway" ||
//           type == "Dining" ||
//           type == "Online" ||
//           type == "Car") {
//         cancelReasonId = "";
//       }

//       Map<String, dynamic> data = {
//         "CompanyID": companyID,
//         "BranchID": branchID,
//         "Type": type,
//         "unqid":
//             type == "Dining&Cancel" || type == "Dining" ? tableID : orderID,
//         "reason_id": cancelReasonId,
//       };

//       print("url  $url");
//       print("type  $type");
//       print("token  $accessToken");
//       print(data);
//       //encode Map to JSON
//       var body = json.encode(data);

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: body,
//       );

//       print(response.body);
//       Map<String, dynamic> responseData =
//           json.decode(utf8.decode(response.bodyBytes));
//       var status = responseData["StatusCode"];

//       if (status == 6000) {
//         fetchAllData();

//         /// print section commented

//         if (cancelReasonId != "") {
//           if (printForCancelOrder) {
//             printSection(
//                 context: context,
//                 id: orderID,
//                 isCancelled: false,
//                 voucherType: "SO");
//             // await printDetail(true);
//           }
//         }

//         // if (orderID != "") {
//         //   await ReprintKOT(orderID, true);
//         // }
//       } else if (status == 6001) {
//         var msg = responseData["message"];
//         Get.snackbar('Error', msg); // Show error message
//       } else {
//         // Handle other cases
//       }
//     } catch (e) {
//       // Handle exceptions
//     } finally {
//       isLoading(false);
//     }
//   }

//   var printHelperUsb = USBPrintClass();
//   var printHelperIP = AppBlocs();
//   var bluetoothHelper = AppBlocsBT();
//   var wifiNewMethod = WifiPrintClassTest();

//   printKOT(
//       {required String orderID,
//       required bool rePrint,
//       required List cancelList,
//       required bool isUpdate}) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var printType = prefs.getString('PrintType') ?? 'Wifi';
//       if (printType == 'Wifi') {
//         printHelperIP.printKotPrint(
//             orderID, rePrint, cancelList, isUpdate, false);
//       } else if (printType == 'BT') {
//         bluetoothHelper.bluetoothPrintKOT(
//             orderID, rePrint, cancelList, isUpdate, isUpdate);
//       } else {
//         printHelperUsb.printKotPrint(orderID, rePrint, cancelList, isUpdate);
//       }
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   printSection(
//       {required BuildContext context,
//       required String voucherType,
//       required String id,
//       required bool isCancelled}) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var defaultIp = prefs.getString('defaultIP') ?? '';
//     var temp = prefs.getString("template") ?? "template4";
//     var printType = prefs.getString('PrintType') ?? 'Wifi';

//     var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';
//     if (defaultIp == "") {
//       popAlert(
//           head: "Warning",
//           message: "Please select a default printer",
//           position: SnackPosition.TOP);
//     } else {
//       if (printType == 'Wifi') {
//         if (temp == "template5") {
//           var ip = "";
//           if (PrintDataDetails.type == "SO") {
//             ip = defaultOrderIP;
//           } else {
//             ip = defaultIp;
//           }

//           await wifiNewMethod.printDetails(
//               id: id,
//               type: voucherType,
//               context: context,
//               ipAddress: ip,
//               isCancelled: false,
//               orderSection: true);
//         } else {
//           PrintDataDetails.type = voucherType;
//           PrintDataDetails.id = id;
//           var ret = await printHelperIP.printDetails();
//           print("==========ret $ret");
//           if (ret == 2) {
//             var ip = "";
//             if (voucherType == "SO") {
//               ip = defaultOrderIP;
//             } else {
//               ip = defaultIp;
//             }
//             printHelperIP.print_receipt(ip, context, isCancelled, false);
//           } else {
//             popAlert(
//                 head: "Error",
//                 message: "Error on loading Data ! Please try again later",
//                 position: SnackPosition.TOP);
//           }
//         }
//       } else if (printType == 'USB') {
//         PrintDataDetails.type = voucherType;
//         PrintDataDetails.id = id;
//         print("usb 1");
//         var ret = await printHelperUsb.printDetails();
//         if (ret == 2) {
//           var ip = "";
//           if (voucherType == "SO") {
//             ip = defaultOrderIP;
//           } else {
//             ip = defaultIp;
//           }
//           printHelperUsb.printReceipt(ip, context);
//         } else {
//           popAlert(
//               head: "Error",
//               message: "Error on loading Data ! Please try again later",
//               position: SnackPosition.TOP);
//         }
//       } else {
//         PrintDataDetails.type = voucherType;
//         PrintDataDetails.id = id;
//         var loadData =
//             await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
//         if (loadData) {
//           var printStatus = await bluetoothHelper.scan(isCancelled);

//           if (printStatus == 1) {
//             popAlert(
//                 head: "Alert",
//                 message: "Check your bluetooth connection",
//                 position: SnackPosition.TOP);
//           } else if (printStatus == 2) {
//             popAlert(
//                 head: "Alert",
//                 message: "Your default printer configuration problem",
//                 position: SnackPosition.TOP);
//           } else if (printStatus == 3) {
//             await bluetoothHelper.scan(isCancelled);
//             // alertMessage("Try again");
//           } else if (printStatus == 4) {
//             //  alertMessage("Printed successfully");
//           }
//         } else {
//           popAlert(
//               head: "Error",
//               message: "Error on loading Data ! Please try again later",
//               position: SnackPosition.TOP);
//         }
//       }
//     }
//   }

//   var dining_view_perm = false.obs;
//   var reservation_view_perm = false.obs;
//   var directOrderOption = false.obs;
//   var take_away_view_perm = false.obs;
//   var car_view_perm = false.obs;

//   var dining_create_perm = false.obs;
//   var take_away_create_perm = false.obs;
//   var online_create_perm = false.obs;
//   var car_create_perm = false.obs;

//   var dining_edit_perm = false.obs;
//   var take_away_edit_perm = false.obs;
//   var car_edit_perm = false.obs;
//   var online_edit_perm = false.obs;

//   var dining_delete_perm = false.obs;
//   var take_away_delete_perm = false.obs;
//   var car_delete_perm = false.obs;

//   var print_perm = false.obs;
//   var cancel_order_perm = false.obs;
//   var pay_perm = false.obs;
//   var reservation_perm = false.obs;
//   var kitchen_print_perm = false.obs;
//   var remove_table_perm = false.obs;
//   var convert_type_perm = false.obs;

//   ReloadAllData() async {
//     print("----------------------------------------------------------------1");
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     dining_view_perm.value = prefs.getBool('Diningview') ?? true;
//     reservation_view_perm.value = prefs.getBool('View Reservation') ?? true;
//     directOrderOption.value = prefs.getBool('directOrderOption') ?? false;
//     take_away_view_perm.value = prefs.getBool('Take awayview') ?? true;
//     car_view_perm.value = prefs.getBool('Carview') ?? true;

//     dining_create_perm.value = prefs.getBool('Diningsave') ?? true;
//     take_away_create_perm.value = prefs.getBool('Take awaysave') ?? true;
//     car_create_perm.value = prefs.getBool('Carsave') ?? true;
//     online_create_perm.value = prefs.getBool('Onlinesave') ?? true;

//     dining_edit_perm.value = prefs.getBool('Diningedit') ?? true;
//     take_away_edit_perm.value = prefs.getBool('Take awayedit') ?? true;
//     car_edit_perm.value = prefs.getBool('Caredit') ?? true;
//     online_edit_perm.value = prefs.getBool('Onlineedit') ?? true;

//     bool kotPrint = prefs.getBool("KOT") ?? false;

//     dining_delete_perm.value = prefs.getBool('Diningdelete') ?? true;
//     take_away_delete_perm.value = prefs.getBool('Take awaydelete') ?? true;
//     car_delete_perm.value = prefs.getBool('Cardelete') ?? true;

//     print("----------------------------------------------------------------2");
//     cancel_order_perm.value = prefs.getBool('Cancel Order') ?? true;
//     pay_perm.value = prefs.getBool('Payment') ?? true;

//     pr("pay_perm   pay_perm  ${pay_perm.value}");

//     kitchen_print_perm.value = prefs.getBool('KOT Print') ?? true;
//     pr("kitchen_print_perm   kitchen_print_perm  ${kitchen_print_perm.value}");
//     if (kotPrint == false) {
//       kitchen_print_perm.value = false;
//     }

//     print_perm.value = prefs.getBool('Re-Print') ?? true;
//     reservation_perm.value = prefs.getBool('Reserve Table') ?? true;
//     remove_table_perm.value = false;
//     convert_type_perm.value = false;
//   }
// }

// enum ConfirmAction { cancel, accept }

// Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
//   return showDialog<ConfirmAction>(
//     context: context,
//     barrierDismissible: false,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//           'msg6'.tr,
//           style: const TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Yes'.tr, style: const TextStyle(color: Colors.red)),
//             onPressed: () async {
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.setBool('isLoggedIn', false);
//               prefs.setBool('companySelected', false);

//               // Navigator.of(context).pushAndRemoveUntil(
//               //   CupertinoPageRoute(builder: (context) => LoginPageNew()),
//               //       (_) => false,
//               // );
//             },
//           ),
//           TextButton(
//             child: const Text('No', style: TextStyle(color: Colors.black)),
//             onPressed: () {
//               Navigator.of(context).pop(ConfirmAction.cancel);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }