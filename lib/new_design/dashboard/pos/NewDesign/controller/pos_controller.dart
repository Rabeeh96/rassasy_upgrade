import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/model/pos_list_model.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/service/pos_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class POSController extends GetxController {
  RxInt tabIndex=0.obs;

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


  static final List<String> menuItem = ['Shawarma', 'Soup', 'Dumplings', 'Pasta', 'Beaverage'];

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

  final TableService _tableService = TableService();
  var tableData = <Data>[].obs;
  var onlineOrders = <Online>[].obs;
  var takeAwayOrders = <TakeAway>[].obs;
  var carOrders = <Car>[].obs;
  var isLoading = true.obs;

  ///this function used for getting time
  ///in hours and minute
  String returnOrderTime(String data, String status) {
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
      var fetchedData = await _tableService.fetchAllData(accessToken);

      tableData.assignAll((fetchedData['data'] as List).map((json) => Data.fromJson(json)).toList());
      onlineOrders.assignAll((fetchedData['Online'] as List).map((json) => Online.fromJson(json)).toList());
      takeAwayOrders.assignAll((fetchedData['TakeAway'] as List).map((json) => TakeAway.fromJson(json)).toList());
      carOrders.assignAll((fetchedData['Car'] as List).map((json) => Car.fromJson(json)).toList());
    } finally {
      isLoading(false);
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
