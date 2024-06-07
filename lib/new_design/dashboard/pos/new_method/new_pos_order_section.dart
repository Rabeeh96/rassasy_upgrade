import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/printClass.dart';
import 'package:rassasy_new/new_design/back_ground_print/back_ground_print_wifi.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/back_ground_print_bt.dart';
import 'package:rassasy_new/new_design/dashboard/pos/barcode/barcode.dart';
import 'package:rassasy_new/new_design/dashboard/pos/detail/selectDeliveryMan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import 'package:intl/intl.dart';
// import 'package:pos_printer_manager/pos_printer_manager.dart';
import '../detail/select_cardtype.dart';
import '../detail/selected_customer.dart';
import 'model/model_class.dart';
import 'package:get/get.dart';

import 'model/roundFunc.dart';

class POSOrderSection extends StatefulWidget {
  String UUID, tableID, sectionType, tableHead;
  int orderType;

  POSOrderSection({super.key, required this.tableID, required this.tableHead, required this.UUID, required this.sectionType, required this.orderType,});

  @override
  State<POSOrderSection> createState() => _POSOrderSectionState();
}

class _POSOrderSectionState extends State<POSOrderSection> {
  Color borderColor = const Color(0xffB8B8B8);

  /// scroll controller declaration

  ScrollController productController = ScrollController();
  ScrollController categoryController = ScrollController();
  ScrollController flavourController = ScrollController();

  /// text edit  controller declaration

  TextEditingController nameController = TextEditingController();
  TextEditingController reservationCustomerNameController = TextEditingController();
  TextEditingController loyaltyPhoneNumber = TextEditingController();
  TextEditingController loyaltyCustomerNameController = TextEditingController();
  TextEditingController loyaltyPhoneController = TextEditingController();
  TextEditingController loyaltyLocationController = TextEditingController();
  TextEditingController loyltyCardTypeController = TextEditingController();
  TextEditingController loyaltyCardNumberController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController autoBarcodeController = TextEditingController();
  TextEditingController paymentCustomerSelection = TextEditingController();
  TextEditingController deliveryManSelection = TextEditingController();

  TextEditingController phoneNumberController = TextEditingController()..text = "";
  TextEditingController customerNameController = TextEditingController()..text = "walk in customer";
  TextEditingController detailDescriptionController = TextEditingController()..text = "walk in customer";
  TextEditingController flavourNameController = TextEditingController();
  TextEditingController tokenNumberController = TextEditingController();

  /// master
  TextEditingController discountAmountController = TextEditingController()..text = "0.0";
  TextEditingController discountPerController = TextEditingController()..text = "0.0";
  TextEditingController cashReceivedController = TextEditingController()..text = "0.0";
  TextEditingController bankReceivedController = TextEditingController()..text = "0.0";

  /// detail controllerb
  TextEditingController unitPriceDetailController = TextEditingController();
  TextEditingController qtyDetailController = TextEditingController();


  TextEditingController tableNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController cardNoController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  /// focus node declare

  FocusNode custNameHeaderFcNode = FocusNode();
  FocusNode phoneNoHeaderFcNode = FocusNode();
  FocusNode nameFcNode = FocusNode();
  FocusNode loyaltyPhoneFcNode = FocusNode();
  FocusNode phoneFcNode = FocusNode();
  FocusNode locationFcNode = FocusNode();
  FocusNode cardTypeFcNode = FocusNode();
  FocusNode cardNoFcNode = FocusNode();
  FocusNode saveFcNode = FocusNode();
  FocusNode customerFcNode = FocusNode();

  final nameNode = FocusNode();
  final phoneNode = FocusNode();
  final okAlertButton = FocusNode();
  final submitFocusButton = FocusNode();

  FocusNode suffixFcNode = FocusNode();
  FocusNode name = FocusNode();
  FocusNode noFcNode = FocusNode();
  FocusNode amountFcNode = FocusNode();
  FocusNode cardType = FocusNode();
  FocusNode cardNo = FocusNode();
  FocusNode discountFcNode = FocusNode();
  FocusNode cashReceivedFcNode = FocusNode();

  bool loyaltyStatus = false;
  bool isAddLoyalty = false;
  bool editLoyalty = false;
  bool networkConnection = true;
  bool showCardType = false;
  var netWorkProblem = true;
  bool isLoading = false;
  bool isCategory = false;
  var pageNumber = 1;
  var firstTime = 1;
  late int charLength;

  var dateOnly;
  bool editProductItem = false;
  bool hide_payment = false;
  int detailIdEdit = 0;

  var mainPageIndex = 1;
  var mainPageIndexIcon = 1;
  var order = 1;

  int deliveryManID = 1;

  bool veg = false;

  String currency = "SR";

  int cardTypeId = 0;
  int ledgerID = 1;
  int loyaltyCustomerID = 0;

  // String salesOrderID = "";

  /// onchange

  String user_name = "";
  var printAfterPayment = false;

  bool autoFocusField = false;
  bool isGst = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      posFunctions();

    });
  }
  bool isComplimentory=false;

  changeVal(val) {
    if (val == 1) {
      mainPageIndexIcon = 1;
    } else if (val == 2) {
      mainPageIndexIcon = 2;
    } else if (val == 3) {
      mainPageIndexIcon = 3;
    } else {
      mainPageIndexIcon = 4;
    }
  }

  Future<Null> posFunctions() async {

    start(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    productSearchNotifier = ValueNotifier(2);
    productList.clear();
    flavourList.clear();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
        networkConnection = false;
      });
    } else {
      changeVal(widget.orderType);
       printAfterPayment = prefs.getBool("printAfterPayment") ?? false;
       currency = prefs.getString('CurrencySymbol') ?? "";
       isGst = prefs.getBool("check_GST") ?? false;
       ledgerID = prefs.getInt("Cash_Account") ?? 1;
       isComplimentory = prefs.getBool("complimentary_bill") ?? false;

       networkConnection = true;
      if (widget.sectionType == "Create") {
        mainPageIndex = 7;
      } else if (widget.sectionType == "Edit") {
        mainPageIndex = 7;
        await getOrderDetails(widget.UUID);
      } else {
        mainPageIndex = 6;
        listItemDetails(widget.UUID);
      }
      if (widget.sectionType != "Payment") {
        await getCategoryListDetail();
        await loadCard();
      }
    }
  }

  final double _width = 520;

  void _animateToIndex(int index) {

    categoryController.animateTo(
      index * _width,
      duration: const Duration(milliseconds: 10),
      curve: Curves.fastOutSlowIn,
    );
  }

  bool IsSelectPos = false;
  String waiterNameInitial = "";
  bool diningStatusPermission = false;
  bool carStatusPermission = false;
  bool onlineStatusPermission = false;
  bool takeawayStatusPermission = false;
  bool kotLoad = false;
  var _selectedIndex = 1000;

  // var selectedIndexFlavour = 1000;
  var parsingJson = [];
  List<PassingDetails> orderDetTable = [];
  List<PassingDetails> itemListPayment = [];
  var deletedList = [];
  var productName;

  ///

  var item_status;
  var unique_id;
  var detailID;
  var unitName;
  int productId = 0;
  int actualProductTaxID = 0;
  int productID = 0;
  int branchID = 0;
  int salesDetailsID = 0;
  int productTaxID = 0;
  int createdUserID = 0;
  int priceListID = 0;

  var productTaxName = "";
  var flavourID = "";
  var flavourName = "";
  var salesPrice = "";
  var purchasePrice = "";
  var id = "";
  var freeQty = "";
  var rateWithTax = 0.0;
  var costPerPrice = "";
  var discountPer = "";
  var taxType = "";
  var taxID;
  var discountAmount = 0.0;
  var percentageDiscount = 0.0;
  var taxableAmountPost = 0.0;

  var grossAmount = "";
  var vatPer = 0.0;
  var quantity = 1.0;
  var vatAmount = 0.0;
  var netAmount = 0.0;

  var sGSTPer = 0.0;
  var sGSTAmount = 0.0;
  var cGSTPer = 0.0;
  var cGSTAmount = 0.0;
  var iGSTPer = 0.0;
  var iGSTAmount = 0.0;
  var totalTax = 0.0;
  var dataBase = "";
  var taxableAmount = "";
  var addDiscPer = "";
  var addDiscAmt = "";
  var gstPer = 0.0;
  var gstAmount = 0.0;
  bool isInclusive = false;
  var unitPriceRounded = 0.0;
  var quantityRounded = 0.0;
  var netAmountRounded = 0.0;
  var actualProductTaxName = "";

//  var descriptionD = "";

  var unitPriceAmountWR = "0.00";
  var inclusiveUnitPriceAmountWR = "0.00";
  var grossAmountWR = "0.00";

  double exciseTaxAmount = 0.0;
  /// Excise tax
  int exciseTaxID = 0;
  var exciseTaxName = "";
  var BPValue = "";
  var exciseTaxBefore = "";
  var isAmountTaxBefore = false;
  var isAmountTaxAfter = false;
  var isExciseProduct = false;
  var exciseTaxAfter = "";

  Future<bool> _onWillPop() async {
    print("____________ its calle");
    if (orderDetTable.length > 1) {
      return (
          await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xff415369),
                title: Text("Are you sure?".tr, style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
                content: Text("There are unsaved changes are you sure ou want to leave this page".tr,
                    style: customisedStyle(context, Colors.white, FontWeight.normal, 12.0)),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("No".tr, style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text("Yes".tr, style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
                  ),
                ],
              );
            },
          )) ??
          false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        body: networkConnection == true ? posDetailPage() : noNetworkConnectionPage(),
      ),
    );
  }

  Widget posDetailPage() {
    return Row(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 1, //height of button
          width: MediaQuery.of(context).size.width / 1.1,
          child: selectOrderType(mainPageIndex),
        ),
        Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height / 1, //height of button
        //  width: MediaQuery.of(context).size.width / 11,
          child: orderTypeDetailScreen(),
        )
      ],
    );
  }

  Widget noNetworkConnectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/warning.svg",
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              posFunctions();
            },
            child: Text('retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }

  /// main Page
  selectOrderType(int index) {
    if (index == 6) {
      return paymentMethod();
    } else if (index == 7) {
      return posDetailScreen();
    }
  }

  /// dining section

  DateTime dateTime = DateTime.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyy");
  DateFormat apiDateFormat = DateFormat("y-M-d");
  DateFormat timeFormat = DateFormat.jm();
  DateFormat timeFormatApiFormat = DateFormat('HH:mm');

  void dispose() {
    super.dispose();
    stop();
  }

  convertStringToDouble(var amt) {
    var a = "$amt";
    var rtn = double.parse(a);
    return rtn;
  }

  Future<Null> getOrderDetails(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Unable to connect. Please Check Internet Connection");
    } else {
      try {
        print("_________________________________________________________________its called");
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;

        final String url = '$baseUrl/posholds/view-pos/salesOrder/${widget.UUID}/';
        print(url);
        Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
        print(data);
        print(accessToken);
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var message = n["message"]??"";
        var responseJson = n["data"];

        if (status == 6000) {
          setState(() {
            print("_________________________________________________________________1");
            // "LedgerID": 1,
            // "LedgerName": "walk in customer",
            //

            ledgerID = responseJson["LedgerID"];
            totalNetP = convertStringToDouble(responseJson["NetTotal"]);

            totalTaxMP = convertStringToDouble(responseJson["TotalTax"]);
            totalGrossP = convertStringToDouble(responseJson["TotalGrossAmt"]);
            vatAmountTotalP = convertStringToDouble(responseJson["VATAmount"]);
            cGstAmountTotalP = convertStringToDouble(responseJson["CGSTAmount"]);
            sGstAmountTotalP = convertStringToDouble(responseJson["SGSTAmount"]);
            iGstAmountTotalP = convertStringToDouble(responseJson["IGSTAmount"]);
            iGstAmountTotalP = convertStringToDouble(responseJson["IGSTAmount"]);
            dateOnly = responseJson["Date"];
            tokenNumber = responseJson["TokenNumber"];
            phoneNumberController.text = responseJson["Phone"];
            customerNameController.text = responseJson["CustomerName"];
            print("_________________________________________________________________12");
            var checkVat = prefs.getBool("checkVat") ?? false;
            var checkGst = prefs.getBool("check_GST") ?? false;

            if (checkVat == true) {
              taxType = "VAT";
            }

            if (checkGst == true) {
              taxType = "GST Intra-state B2C";
            }

            parsingJson.clear();
            orderDetTable.clear();

            var details = responseJson["SalesOrderDetails"];

            for (var i = 0; i < details.length; i++) {

              var det = transformData(details[i]);
              log("-------------------------------------------------------$det-----------------------------------");
              parsingJson.add(det);
            }
            getLoyaltyCustomer();
            listData();
            stop();
          });
        } else if (status == 6001) {
          stop();
          dialogBox(context, message);
        }

        //DB Error
        else {
          stop();
          dialogBox(context, "Some Network Error please try again Later");
        }
      } catch (e) {
        print("-------${e.toString()}");
        stop();
      }
    }
  }
  transformData(values) {

    if(values["ExciseTaxData"]!=null&&values["ExciseTaxData"]!=""){
      Map<String, dynamic> data = values;

        final exciseTaxData = Map<String, dynamic>.from(data['ExciseTaxData']);
        final iTaxBefore = exciseTaxData['TaxBefore'].toString();
        final isAmountTaxBefore = exciseTaxData['IsAmountTaxBefore'];
        final taxAfter = exciseTaxData['TaxAfter'].toString();
        final isAmountTaxAfter = exciseTaxData['IsAmountTaxAfter'];
        final TaxID = exciseTaxData['TaxID'];
        final TaxName = exciseTaxData['TaxName'];
        final BPValue = exciseTaxData['BPValue'].toString();
        print("----TotalTaxRounded------${values["TotalTaxRounded"]}");
        print("----ExciseTax------${values["ExciseTax"]}");
        print("----VATAmount------${values["VATAmount"]}");


        double totalTax= double.parse(values["VATAmount"].toString())+double.parse(values["ExciseTax"].toString());
      print("----totalTax------$totalTax");
        // Remove ExciseTaxData from data
        data.remove('ExciseTaxData');
        data['ExciseTaxID'] = TaxID;
        data['BPValue'] = BPValue;
        data['ExciseTaxName'] = TaxName;
        data['ExciseTaxBefore'] = iTaxBefore;
        data['IsAmountTaxBefore'] = isAmountTaxBefore;
        data['ExciseTaxAfter'] = taxAfter;
        data['IsAmountTaxAfter'] = isAmountTaxAfter;
        data['IsExciseProduct'] = true;
        data['TotalTaxRounded'] = totalTax.toString();



      return data;
    }
    return values;

  }

  Future<Null> listItemDetails(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Unable to connect. Please Check Internet Connection");
    } else {
      try {
        print("____________________________1");
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        user_name = prefs.getString('user_name')!;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        print("____________________________1");
        final String url = '$baseUrl/posholds/view-pos/salesOrder/$id/';
        print(url);
        Map data = {"BranchID": branchID, "CompanyID": companyID, "CreatedUserID": userID, "PriceRounding": 2};
        print(data);
        var body = json.encode(data);
        print("____________________________1");
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var message = n["message"]??"";
        var responseJson = n["data"];

        if (status == 6000) {
          setState(() {
            var parsingJsonItem = [];
            parsingJsonItem.clear();
            print("____________________________1");
            itemListPayment.clear();
            cashReceivedController.text = "0.00";
            bankReceivedController.text = "0.00";
            discountPerController.text = "0.00";
            discountAmountController.text = "0.00";
            var details = responseJson["SalesOrderDetails"];

            for (var i = 0; i < details.length; i++) {
              parsingJsonItem.add(details[i]);
            }
            print("____________________________12");
            for (Map user in parsingJsonItem) {
              itemListPayment.add(PassingDetails.fromJson(user));
            }

            print("____________________________15");

            grandTotalAmount = responseJson["GrandTotal"].toString();
            totalTaxP = responseJson["TotalTax"].toString();
            vatAmountTotalP = double.parse(responseJson["VATAmount"].toString());
            exciseAmountTotalP = double.parse(responseJson["ExciseTaxAmount"].toString());
            netTotal = responseJson["NetTotal"].toString();
            ledgerID = responseJson["LedgerID"];
            paymentCustomerSelection.text = responseJson["CustomerName"];

            cashReceived = 0.0;
            bankReceived = 0.0;
            balance = 0.0;
            totalDiscount = "0.0";
            date = dateOnly;
            roundOff = "0.0";

            calculationOnPayment();
            stop();
          });
        } else if (status == 6001) {
          stop();
          dialogBox(context, message);
        }

        //DB Error
        else {
          stop();
          dialogBox(context, "Some Network Error please try again Later");
        }
      } catch (e) {
        stop();
      }
    }
  }

  listData() {
    setState(() {
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
      totalAmount();
    });
  }
  var printHelperUsb =  USBPrintClass();
  var printHelper =   AppBlocs();
  var bluetoothHelper =   AppBlocsBT();

  printDetail(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var defaultIp = prefs.getString('defaultIP') ?? '';
    var printType = prefs.getString('PrintType') ?? 'Wifi';
    var defaultOrderIP = prefs.getString('defaultOrderIP') ?? '';

    if (defaultIp == "") {
      dialogBox(context, "Please select a default printer");
    } else {
      if (printType == 'Wifi') {
        var ret = await printHelper.printDetails();
        if (ret == 2) {
          var ip = "";
          if (PrintDataDetails.type == "SO") {
            ip = defaultOrderIP;
          }
          else {
            ip = defaultIp;
          }
          printHelper.print_receipt(ip, context,false);
        } else {
          dialogBox(context, 'Please try again later');
        }
      } else {

        print("usb 1");
        var ret = await printHelperUsb.printDetails();
        if (ret == 2) {
          var ip = "";
          if (PrintDataDetails.type == "SO") {
            ip = defaultOrderIP;
          } else {
            ip = defaultIp;
          }
          printHelperUsb.printReceipt(ip, context);
        } else {
          dialogBox(context, 'Please try again later');
        }
        /// commented bluetooth print option
        // var loadData = await bluetoothHelper.bluetoothPrintOrderAndInvoice(context);
        // if (loadData) {
        //   var printStatus = await bluetoothHelper.scan();
        //
        //   if (printStatus == 1) {
        //     dialogBox(context, "Check your bluetooth connection");
        //   } else if (printStatus == 2) {
        //     dialogBox(context, "Your default printer configuration problem");
        //   } else if (printStatus == 3) {
        //     await bluetoothHelper.scan();
        //     // alertMessage("Try again");
        //   } else if (printStatus == 4) {
        //     //  alertMessage("Printed successfully");
        //   }
        // } else {
        //   dialogBox(context, "Try again");
        // }
      }
    }
  }


  printKOT(orderID, rePrint, cancelList, bool isUpdate) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var printType = prefs.getString('PrintType') ?? 'Wifi';
      if (printType == 'Wifi') {
        printHelper.printKotPrint(orderID, rePrint, cancelList, isUpdate,false);
      } else {
        printHelperUsb.printKotPrint(orderID, rePrint, cancelList, isUpdate);
        /// commented bluetooth
        // print("_____________________123123123123");
        // bluetoothHelper.bluetoothPrintKOT(context, false, orderID);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  addCashReceived(val) {
    var cash = 0.00;
    if (cashReceivedController.text == "") {
    } else {
      cash = double.parse(cashReceivedController.text);
    }
    var amount = double.parse(val) + cash;
    cashReceivedController.text = "$amount";
    calculationOnPayment();
  }

  Widget paymentMethod() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          //  color: Colors.green,
          height: MediaQuery.of(context).size.height / 1.1,
          //height of button
          width: MediaQuery.of(context).size.width / 1.7,
          decoration: BoxDecoration(color: const Color(0xffF8F8F8), border: Border.all(color: Colors.grey, width: .2)),
          child: ListView(
            children: [
              // Container(
              //  color: Colors.red,
              //   height: MediaQuery.of(context).size.height / 15,
              //  // width: MediaQuery.of(context).size.width / 1.7,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //
              //
              //
              //       /// select delivery man option commented
              //
              //
              //       Container(
              //         width: MediaQuery.of(context).size.width / 5,
              //         height: MediaQuery.of(context).size.height / 20,
              //         child: TextField(
              //           style: TextStyle(fontSize: 12),
              //           readOnly: true,
              //           onTap: () async {
              //             var result = await Navigator.push(
              //               context,
              //               MaterialPageRoute(builder: (context) => SelectPaymentDeliveryMan()),
              //             );
              //
              //             if (result != null) {
              //               deliveryManID = result[1];
              //               deliveryManSelection.text = result[0];
              //             }
              //           },
              //           controller: deliveryManSelection,
              //           focusNode: customerFcNode,
              //           onEditingComplete: () {},
              //           keyboardType: TextInputType.text,
              //           textCapitalization: TextCapitalization.words,
              //           decoration: InputDecoration(
              //               suffixIcon: Icon(
              //                 Icons.keyboard_arrow_down,
              //                 color: Colors.black,
              //               ),
              //               enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              //               focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEEEEEE))),
              //               disabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              //               contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              //               filled: true,
              //               hintStyle: const TextStyle(color: Color(0xff858585), fontSize: 14),
              //               hintText: "Select Delivery man",
              //               fillColor: const Color(0xffEEEEEE)),
              //           // decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: 'Select Delivery man',),
              //         ),
              //       ),
              //       // Padding(
              //       //   padding: const EdgeInsets.only(left: 28.0),
              //       //   child: Container(
              //       //   //  color: Colors.red,
              //       //     width: MediaQuery.of(context).size.width / 5,
              //       //     height: MediaQuery.of(context).size.height / 20,
              //       //     child: Center(
              //       //       child: TextField(
              //       //         style: TextStyle(fontSize: 12),
              //       //         readOnly: true,
              //       //         onTap: () async {
              //       //           var result = await Navigator.push(
              //       //             context,
              //       //             MaterialPageRoute(builder: (context) => SelectPaymentDeliveryMan()),
              //       //           );
              //       //
              //       //           if (result != null) {
              //       //             deliveryManID = result[1];
              //       //             deliveryManSelection.text = result[0];
              //       //           }
              //       //         },
              //       //         controller: deliveryManSelection,
              //       //         focusNode: customerFcNode,
              //       //         onEditingComplete: () {},
              //       //         keyboardType: TextInputType.text,
              //       //         textCapitalization: TextCapitalization.words,
              //       //         decoration: InputDecoration(
              //       //             suffixIcon: Icon(
              //       //               Icons.keyboard_arrow_down,
              //       //               color: Colors.black,
              //       //             ),
              //       //             enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              //       //             focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEEEEEE))),
              //       //             disabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
              //       //             contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              //       //             filled: true,
              //       //             hintStyle: const TextStyle(color: Color(0xff858585), fontSize: 14),
              //       //             hintText: "Select Delivery man",
              //       //             fillColor: const Color(0xffEEEEEE)),
              //       //         // decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: 'Select Delivery man',),
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ),
              //       /// loyalty commented
              //       // Row(
              //       //   children: [
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         displayLoyaltyListBox(context);
              //       //       },
              //       //       child: Padding(
              //       //         padding: const EdgeInsets.only(bottom: 10),
              //       //         child: Container(
              //       //           color: Colors.red,
              //       //         //  height: MediaQuery.of(context).size.height / 16, //height of button
              //       //           width: MediaQuery.of(context).size.width / 6,
              //       //           child: TextButton(
              //       //             style: TextButton.styleFrom(
              //       //               foregroundColor: const Color(0xffFFFFFF), backgroundColor: const Color(0xff172026), // Background Color
              //       //             ),
              //       //             onPressed: () {
              //       //               displayLoyaltyListBox(context);
              //       //             },
              //       //             child: Row(
              //       //               mainAxisAlignment: MainAxisAlignment.center,
              //       //               children: [
              //       //                 IconButton(
              //       //                   icon: SvgPicture.asset('assets/svg/person.svg'),
              //       //                   iconSize: 40,
              //       //                   onPressed: () {
              //       //                     displayLoyaltyListBox(context);
              //       //                   },
              //       //                 ),
              //       //                 Text(
              //       //                   'Add Customer',
              //       //                   style: customisedStyle(context, Colors.white, FontWeight.w400, 12.00),
              //       //                 )
              //       //               ],
              //       //             ),
              //       //           ),
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     GestureDetector(
              //       //       onTap: () {
              //       //         displayLoyalityAlertBox(context);
              //       //       },
              //       //       child: Padding(
              //       //         padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
              //       //         child: SizedBox(
              //       //           height: MediaQuery.of(context).size.height / 16, //height of button
              //       //           width: MediaQuery.of(context).size.width / 26,
              //       //           child: TextButton(
              //       //             style: TextButton.styleFrom(
              //       //               primary: const Color(0xffFFFFFF),
              //       //               backgroundColor: const Color(0xff172026), // Background Color
              //       //             ),
              //       //             onPressed: () {
              //       //               displayLoyalityAlertBox(context);
              //       //             },
              //       //             child: Icon(Icons.add),
              //       //           ),
              //       //         ),
              //       //       ),
              //       //     ),
              //       //   ],
              //       // )
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  //height of button
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    //        borderRadius: BorderRadius.all(Radius.circular(4.0)),

                    // color: const Color(0xffFFFFFF),
                    //       border: Border.all(color: Colors.grey, width: .2)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'payment'.tr,
                                style: customisedStyle(context, Colors.black, FontWeight.w700, 20.00),
                              ),
                            ),
                          ],
                        ),
                        widget.orderType == 2
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 5,
                                    height: MediaQuery.of(context).size.height / 20,
                                    child: TextField(
                                      style: const TextStyle(fontSize: 12),
                                      readOnly: true,
                                      onTap: () async {
                                        var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const SelectPaymentDeliveryMan()),
                                        );

                                        if (result != null) {
                                          deliveryManID = result[1];
                                          deliveryManSelection.text = result[0];
                                        }
                                      },
                                      controller: deliveryManSelection,
                                      focusNode: customerFcNode,
                                      onEditingComplete: () {},
                                      keyboardType: TextInputType.text,

                                      textCapitalization: TextCapitalization.words,
                                      decoration: InputDecoration(
                                          suffixIcon: const Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.black,
                                          ),
                                          enabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
                                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffEEEEEE))),
                                          disabledBorder: const OutlineInputBorder(borderSide: const BorderSide(color: Color(0xffEEEEEE))),
                                          contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                                          filled: true,
                                          hintStyle: const TextStyle(color: Color(0xff858585), fontSize: 14),
                                          hintText: 'select_delivery_man'.tr,
                                          fillColor: const Color(0xffFFFFFF)),
                                      // decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: 'Select Delivery man',),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height / 14,
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: const BorderRadius.all(Radius.circular(4.0)), border: Border.all(color: Colors.grey, width: .2)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Text(
                                'select_customer'.tr,
                                style: customisedStyle(context, Colors.black, FontWeight.bold, 15.00),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 5.5,
                              height: MediaQuery.of(context).size.height / 20,
                              child: TextField(
                                style: const TextStyle(fontSize: 12),
                                readOnly: true,
                                onTap: () async {
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SelectPaymentCustomer()),
                                  );

                                  print(result);

                                  if (result != null) {
                                    paymentCustomerSelection.text = result[0];
                                    ledgerID = result[1];
                                    print(ledgerID);
                                  }
                                },
                                controller: paymentCustomerSelection,
                                focusNode: customerFcNode,
                                onEditingComplete: () {},
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                decoration: TextFieldDecoration.rectangleTextFieldIconFillColor(hintTextStr: ''),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8),
                                child: Text(
                                  'balance'.tr,
                                  style: customisedStyle(context, const Color(0xff808080), FontWeight.bold, 15.00),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text(
                                  currency + "  " + roundStringWith(balance.toString()),
                                  style: customisedStyle(context, const Color(0xff808080), FontWeight.bold, 15.00),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: Container(
               //   height: MediaQuery.of(context).size.height / 5.5,
                  //height of button
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                      color: const Color(0xffEFEFEF),
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      border: Border.all(color: const Color(0xffefefef), width: .2)),

                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 100),
                              child: Text(
                                'to_be_paid'.tr,
                                style: customisedStyle(context, Colors.black, FontWeight.w700, 13.00),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 0),
                              child: Text(
                                currency + "  " + roundStringWith(grandTotalAmount),
                                style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                              ),
                            ),
                          ],
                        ),


                        exciseAmountTotalP>0?    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'total_vat'.tr,
                              style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                roundStringWith(vatAmountTotalP.toString()),
                                style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                              ),
                            ),
                          ],
                        ):Container() ,




                        exciseAmountTotalP>0? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'excise_tax'.tr,
                              style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                roundStringWith(exciseAmountTotalP.toString()),
                                style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                              ),
                            ),
                          ],
                        ):Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'total_tax'.tr,
                              style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                roundStringWith(totalTaxP),
                                style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'net_total'.tr,
                              style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                roundStringWith(netTotal),
                                style: customisedStyle(context, const Color(0xff000000), FontWeight.bold, 13.00),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'grand_total'.tr,
                              style: customisedStyle(context, const Color(0xff0A9800), FontWeight.bold, 15.00),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                roundStringWith(grandTotalAmount),
                                style: customisedStyle(context, const Color(0xff0A9800), FontWeight.bold, 15.00),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ///total tax commented white bg color
              // Container(
              //   padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),
              //
              //   height: MediaQuery.of(context).size.height / 6,
              //   //height of button
              //   width: MediaQuery.of(context).size.width / 1.8,
              //
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             'Total tax',
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 15),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 8),
              //             child: Text(
              //               roundStringWith(totalTaxP),
              //               style: const TextStyle(
              //                   color: Colors.black,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 15),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             "Net total",
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 15),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 8),
              //             child: Text(
              //               roundStringWith(netTotal),
              //               style: const TextStyle(
              //                   color: Colors.black,
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 15),
              //             ),
              //           ),
              //         ],
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           const Text(
              //             "Grand total",
              //             style: TextStyle(
              //                 color: Color(0xff0A9800),
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 17),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(top: 8),
              //             child: Text(
              //               roundStringWith(grandTotalAmount),
              //               style: const TextStyle(
              //                   color: Color(0xff0A9800),
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 17),
              //             ),
              //           ),
              //         ],
              //       ),
              //
              //       /// balance commented
              //       // Padding(
              //       //   padding: const EdgeInsets.only(top: 10),
              //       //   child: Row(
              //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       //     children: [
              //       //       const Text(
              //       //         "Balance",
              //       //         style: TextStyle(
              //       //             color: Colors.black,
              //       //             fontWeight: FontWeight.w500,
              //       //             fontSize: 15),
              //       //       ),
              //       //       Padding(
              //       //         padding: const EdgeInsets.only(top: 8),
              //       //         child: Text(
              //       //           roundStringWith(balance.toString()),
              //       //           style: const TextStyle(
              //       //               color: Colors.black,
              //       //               fontWeight: FontWeight.w500,
              //       //               fontSize: 15),
              //       //         ),
              //       //       ),
              //       //     ],
              //       //   ),
              //       // ),
              //     ],
              //   ),
              //   decoration: BoxDecoration(
              //
              //      color: const Color(0xffFFFFFF),
              //       border: Border.all(color: Colors.grey, width: .2)),
              // ),

              Padding(
                padding: const EdgeInsets.only(left: 19, right: 19, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5, //height of button
                      width: MediaQuery.of(context).size.width / 3.6,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.6,
                            height: MediaQuery.of(context).size.height / 15,
                            child: Text(
                              'cash'.tr,
                              style: customisedStyle(context, Colors.black, FontWeight.w500, 19.00),
                              textAlign: TextAlign.center,
                            ),
                            // color: Colors.grey,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.6,
                            height: MediaQuery.of(context).size.height / 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  //   height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.w400, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('5');
                                      },
                                      child: const Text('5')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('10.00');
                                      },
                                      child: const Text('10')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('100.00');
                                      },
                                      child: const Text('100')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('200.00');
                                      },
                                      child: const Text('200')),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            //color: Colors.yellow,
                            width: MediaQuery.of(context).size.width / 3.6,
                            height: MediaQuery.of(context).size.height / 16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  //  height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('20.00');
                                        // cashReceivedController.text = "20.00";
                                      },
                                      child: const Text('20')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  //  height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('50.00');
                                        // cashReceivedController.text = "50.00";
                                      },
                                      child: const Text('50')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  //   height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('500.00');
                                        // cashReceivedController.text = "500.00";
                                      },
                                      child: const Text('500')),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 15,
                                  //   height: MediaQuery.of(context).size.height / 16,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff262626),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.normal, 11.00),
                                      ),
                                      onPressed: () {
                                        addCashReceived('1000.00');
                                        //   cashReceivedController.text = "1000.00";
                                      },
                                      child: const Text('1000')),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 3.6,
                              height: MediaQuery.of(context).size.height / 15,
                              //   color: Colors.red,
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width / 10,
                                  // height: MediaQuery.of(context).size.height / 18,
                                  child: Text(
                                    'tot_cash'.tr,
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 11,
                                  //  height: MediaQuery.of(context).size.height / 18,
                                  child: TextField(
                                    focusNode: cashReceivedFcNode,
                                    controller: cashReceivedController,
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                    ],
                                    onTap: () => cashReceivedController.selection =
                                        TextSelection(baseOffset: 0, extentOffset: cashReceivedController.value.text.length),
                                    onChanged: (val) {
                                      if (val.isEmpty) {
                                        val = "0";
                                      }
                                      else {
                                        calculationOnPayment();
                                      }

                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5.0),
                                  width: MediaQuery.of(context).size.width / 12,
                                  //  height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),

                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff10C103),
                                        textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                                      ),
                                      onPressed: () {
                                        bankReceivedController.text = '0.00';
                                        cashReceivedController.text = grandTotalAmount;
                                        calculationOnPayment();
                                      },
                                      child: Text(
                                        'full_cash'.tr,
                                        style: customisedStyle(context, Colors.white, FontWeight.normal, 10.00),
                                      )
                                  ),
                                ),

                              ])
                              // color: Colors.grey,
                              ),
                        ],
                      ),
                      //color: Colors.grey,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5, //height of button
                      width: MediaQuery.of(context).size.width / 3.7,
                      //bank
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3.6,
                            height: MediaQuery.of(context).size.height / 15,
                            child: Text(
                              'bank'.tr,
                              style: customisedStyle(context, Colors.black, FontWeight.w500, 19.00),
                              textAlign: TextAlign.center,
                            ),
                            // color: Colors.grey,
                          ),
                          Container(
                            //  width: MediaQuery.of(context).size.width / 4,
                            height: MediaQuery.of(context).size.height / 18,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'amt'.tr,
                                  style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: TextField(
                                    focusNode: amountFcNode,
                                    controller: bankReceivedController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                    ],
                                    style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                                    onTap: () => bankReceivedController.selection =
                                        TextSelection(baseOffset: 0, extentOffset: bankReceivedController.value.text.length),
                                    onChanged: (val) {
                                      if (val.isEmpty) {
                                      } else {
                                        if (checkBank(val)) {
                                          calculationOnPayment();
                                        } else {}
                                      }
                                    },
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(cardType);
                                    },
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffBFBFBF), width: .1)),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 14,
                                  //  height: MediaQuery.of(context).size.height / 18,
                                  child: TextButton(
                                      style: TextButton.styleFrom(
                                        //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color(0xff10C103),
                                        textStyle: customisedStyle(context, Colors.black, FontWeight.w500, 10.00),
                                      ),
                                      onPressed: () {
                                        cashReceivedController.text = '0.00';
                                        bankReceivedController.text = grandTotalAmount;
                                        calculationOnPayment();
                                      },
                                      child: Text(
                                        'pay_full'.tr,
                                        style: customisedStyle(context, Colors.white, FontWeight.normal, 10.00),
                                      )),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            //  width: MediaQuery.of(context).size.width / 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'disc'.tr,
                                  style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 12,
                                  height: MediaQuery.of(context).size.height / 21,
                                  child: TextField(
                                    focusNode: discountFcNode,
                                    controller: discountAmountController,
                                    style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
                                    //   focusNode: netTotalFocusNode,
                                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),

                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('[-, ]')),
                                    ],
                                    onChanged: (text) async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      var country = prefs.getString("CountryName") ?? "";
                                      print("-country--$country");

                                      if (text.isEmpty) {
                                        // discountAmountController.text = '0.00';
                                        discountCalc(2, '0.00');
                                      } else {
                                        /// discount
                                        discountCalc(2, text);

                                        // if (country == "Saudi Arabia") {
                                        //   getVatChangedDetails(2, text);
                                        //
                                        // } else {
                                        //
                                        //   discountCalc(2, text);
                                        // }
                                      }
                                    },
                                    onTap: () => discountAmountController.selection =
                                        TextSelection(baseOffset: 0, extentOffset: discountAmountController.value.text.length),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width / 12,
                                  height: MediaQuery.of(context).size.height / 21,
                                  child: TextField(
                                    controller: discountPerController,
                                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                                    ],
                                    style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
                                    onTap: () => discountPerController.selection =
                                        TextSelection(baseOffset: 0, extentOffset: discountPerController.value.text.length),
                                    onChanged: (text) async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      var country = prefs.getString("CountryName") ?? "";

                                      if (text.isEmpty) {
                                      } else {
                                        discountCalc(1, text);

                                        /// discount
                                        // if (country == "Saudi Arabia") {
                                        //   getVatChangedDetails(1, text);
                                        //
                                        // } else {
                                        //   discountCalc(1, text);
                                        // }
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      suffixIcon: Icon(
                                        Icons.percent,
                                        color: Colors.black,
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(10),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),

                                /// to items
                                // Container(
                                //   width: MediaQuery.of(context).size.width / 14,
                                //   height: MediaQuery.of(context).size.height / 21,
                                //   child: TextButton(
                                //       style: TextButton.styleFrom(
                                //         //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
                                //         shape: const RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.all(
                                //                 Radius.circular(4))),
                                //
                                //         primary: Colors.white,
                                //         backgroundColor: const Color(0xffF38811),
                                //         textStyle: const TextStyle(
                                //             fontSize: 10,
                                //             fontWeight: FontWeight.w400),
                                //       ),
                                //       onPressed: () {},
                                //       child: const Text('To Items')),
                                // )
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          isComplimentory==true?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                             //   width: MediaQuery.of(context).size.width / 10,
                                //  height: MediaQuery.of(context).size.height / 18,
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                      //    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5),
                                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                                      foregroundColor: Colors.white,
                                      backgroundColor: const Color(0xff10C103),
                                      textStyle: customisedStyle(context, Colors.black, FontWeight.w500, 10.00),
                                    ),
                                    onPressed: () {
                                      discountAmountController.text =roundStringWith(grandTotalAmount.toString());
                                      discountCalc(2, grandTotalAmount.toString());
                                    },
                                    child: Text(
                                      'complimentary_bill'.tr,
                                      style: customisedStyle(context, Colors.white, FontWeight.normal, 12.00),
                                    )),
                              ),
                            ],
                          ):Container()

                        ],
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height / 12, //height of button
                width: MediaQuery.of(context).size.width / 1.7,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 17, //height of button
                      width: MediaQuery.of(context).size.width / 8,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(2.0),
                            backgroundColor: const Color(0xffFF0000),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'cancel'.tr,
                            style: customisedStyle(context, Colors.white, FontWeight.w500, 12.00),
                          )
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    printAfterPayment == false
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 17, //h //height of button
                            width: MediaQuery.of(context).size.width / 8,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.all(2.0),
                                  backgroundColor: const Color(0xff1155F3),
                                  textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                onPressed: ()async {

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var id = prefs.getInt("Cash_Account") ?? 1;

                                  print("ledger ID $ledgerID   id $id");



                                  if(ledgerID !=id){
                                    createSaleInvoice(printAfterPayment, context);
                                  }
                                  else{
                                    if ((cashReceived + bankReceived) >= double.parse(grandTotalAmount)) {
                                      createSaleInvoice(printAfterPayment, context);
                                    } else {
                                      dialogBox(context, "You cant make credit sale");
                                    }
                                  }




                                  // if ((cashReceived + bankReceived) >= double.parse(grandTotalAmount)) {
                                  //   createSaleInvoice(true, context);
                                  // } else {
                                  //   dialogBox(context, "You cant make credit sale");
                                  // }
                                },
                                child: Text('print_save'.tr, style: customisedStyle(context, Colors.white, FontWeight.w500, 12.00))),
                          )
                        : Container(),
                    const SizedBox(
                      width: 4,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 17,
                      width: MediaQuery.of(context).size.width / 8,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.all(2.0),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff0A9800),
                            textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          onPressed: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            var id = prefs.getInt("Cash_Account") ?? 1;
                            print("ledger ID $ledgerID   id $id");
                            if(ledgerID !=id){
                              createSaleInvoice(printAfterPayment, context);
                            }
                            else{
                              if ((cashReceived + bankReceived) >= double.parse(grandTotalAmount)) {
                                createSaleInvoice(printAfterPayment, context);
                              } else {
                                dialogBox(context, "You cant make credit sale");
                              }
                            }


                          },
                          child: Text('save'.tr, style: customisedStyle(context, Colors.white, FontWeight.w500, 12.00))),
                    )
                  ],
                ),
              ),
            ],
          ),
          //color: Colors.grey,
        ),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              height: MediaQuery.of(context).size.height / 1, //height of button
              width: MediaQuery.of(context).size.width / 3.3,
              child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: itemListPayment.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Container(
                            height: MediaQuery.of(context).size.height / 9,
                            // width: MediaQuery.of(context).size.width / 2.5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                GestureDetector(
                                  onTap: () async {},
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    // height: MediaQuery.of(context).size.height / 9,
                                    width: MediaQuery.of(context).size.width / 7,
                                    child: ListView(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                itemListPayment[index].productName,
                                                style: customisedStyle(context, Colors.black, FontWeight.bold, 12.00),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          itemListPayment[index].description,
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                        Text(
                                          itemListPayment[index].flavourName,
                                          style: customisedStyle(context, Colors.black, FontWeight.bold, 10.00),
                                        )
                                      ],
                                    ),
                                    // decoration: BoxDecoration(
                                    //     border: Border.all(
                                    //         color: Colors.grey, width: .2))
                                  ),
                                ),
                                Container(
                                  // color:Colors.red,
                                  padding: const EdgeInsets.all(3),
                                  // height: MediaQuery.of(context).size.height / 9,
                                  width: MediaQuery.of(context).size.width / 7.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                //' ',
                                                "Rate".tr,
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                "Qty".tr,
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                "Tax".tr,
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                "Net".tr,
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                //' ',
                                                roundStringWith(itemListPayment[index].unitPrice),
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                roundStringWith(itemListPayment[index].quantity),
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                returnTotalTax(itemListPayment[index].vatAmount, itemListPayment[index].exciseTaxAmount),
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 11.00),
                                              ),
                                              Text(
                                                roundStringWith(itemListPayment[index].netAmount),
                                                style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  // decoration: BoxDecoration(
                                  //   //color: Colors.red,
                                  //   border: Border.all(color: Colors.grey, width: .2),
                                  // )
                                ),
                              ]),
                            ),
                          ),
                        );
                      })),
            ))
      ],
    );
  }

  /// pos section
  Widget posDetailScreen() {
    return ListView(
      children: [
        tableNameHeader(),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  //   color: Colors.red,
                  border: Border(
                right: BorderSide(
                  //                   <--- left side
                  color: borderColor,
                  width: .5,
                ),
                bottom: BorderSide(
                  //                   <--- left side
                  color: borderColor,
                  width: .5,
                ),
                left: BorderSide(
                  //                   <--- left side
                  color: borderColor,
                  width: .5,
                ),
              )),
              height: MediaQuery.of(context).size.height / 1.14, //height of button
              width: MediaQuery.of(context).size.width / 1.8,
              //  padding: const EdgeInsets.all(5),
              child: ListView(
                children: [
                  addItemDetail(),
                  displayCategoryNames(),
                  displayProductDetails(),

                  /// commented bottom bar
                  // bottomNextPageList(),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: borderColor, width: .5)),
              child: ordersList(order),
            ),
          ],
        ),
      ],
    );
  }

  functionBack() async {
    var navigateResult = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff415369),
          title: Text("Are you sure?", style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
          content: Text("There are unsaved changes ,want to leave this page", style: customisedStyle(context, Colors.white, FontWeight.normal, 12.0)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("No", style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Yes", style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
            ),
          ],
        );
      },
    );

    if (navigateResult!) {
      Navigator.pop(context);
    }
  }

  Widget tableNameHeader() {
    return SafeArea(
      child: Container(
          padding: const EdgeInsets.only(left: 8, right: 8),
          decoration: BoxDecoration(
              //  color: Colors.red,
              border: Border(
            bottom: BorderSide(
              //                   <--- left side
              color: borderColor,
              width: .5,
            ),
          )),
          height: MediaQuery.of(context).size.height / 10,
          //height of button
          width: MediaQuery.of(context).size.width / 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 17,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () async {
                    functionBack();
                  },
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height / 9, //height of button
                width: MediaQuery.of(context).size.width / 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///table name
                    ///
                    Text(
                      widget.tableHead,
                      // style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xff717171), fontSize: 17.0),
                      style: customisedStyle(context, const Color(0xff717171), FontWeight.w500, 17.0),
                    ),
                    Text(
                      'choose_item'.tr,
                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 15.0),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  ///add customer button
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       displayLoyaltyListBox(context);
                  //     });
                  //   },
                  //   child: SizedBox(
                  //     height: MediaQuery.of(context).size.height /
                  //         18, //height of button
                  //     width: MediaQuery.of(context).size.width / 7,
                  //     child: TextButton(
                  //       style: TextButton.styleFrom(
                  //         primary: const Color(0xffFFFFFF),
                  //         backgroundColor:
                  //             const Color(0xff172026), // Background Color
                  //       ),
                  //       onPressed: () {
                  //         displayLoyaltyListBox(context);
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           IconButton(
                  //             icon: SvgPicture.asset('assets/svg/person.svg'),
                  //             iconSize: 40,
                  //             onPressed: () {
                  //               displayLoyaltyListBox(context);
                  //             },
                  //           ),
                  //           const Text(
                  //             'Add Customer',
                  //             style: TextStyle(fontSize: 12),
                  //           )
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 15,
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        focusNode: custNameHeaderFcNode,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(phoneNoHeaderFcNode);
                        },

                        onTap: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SelectPaymentCustomer()),
                          );

                          print(result);

                          if (result != null) {
                            customerNameController.text = result[0];
                            ledgerID = result[1];

                          }
                        },
               //         onTap: () => customerNameController.selection = TextSelection(baseOffset: 0, extentOffset: customerNameController.value.text.length),

                        controller: customerNameController,
                        decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'cus_name'.tr),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0, left: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height / 15,
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                        textCapitalization: TextCapitalization.words,
                        focusNode: phoneNoHeaderFcNode,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(saveFcNode);
                        },
                        controller: phoneNumberController,
                        decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'ph_no'.tr),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'token_no'.tr,
                          style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                        ),
                        Text(
                          tokenNumber,
                          style: customisedStyle(context, Colors.black, FontWeight.w700, 16.0),
                        ),
                      ],
                    ),
                  )

                  ///loyalty customer add
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       displayLoyalityAlertBox(context);
                  //     });
                  //   },
                  //   child: SizedBox(
                  //     height: MediaQuery.of(context).size.height /
                  //         17, //height of button
                  //     width: MediaQuery.of(context).size.width / 26,
                  //     child: TextButton(
                  //       style: TextButton.styleFrom(
                  //         primary: const Color(0xffFFFFFF),
                  //         backgroundColor:
                  //             const Color(0xff172026), // Background Color
                  //       ),
                  //       onPressed: () {
                  //         displayLoyalityAlertBox(context);
                  //       },
                  //       child: Icon(Icons.add),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              // UserDetailsAppBar(user_name: user_name),
            ],
          )),
    );
  }

// bool isProductCode = false;
// bool isProductName = true;
// bool isProductDescription = false;
  late ValueNotifier<int> productSearchNotifier;

  Widget addItemDetail() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          //                   <--- left side
          color: borderColor,
          width: 1,
        ),
      )),
      height: MediaQuery.of(context).size.height / 14,
      width: MediaQuery.of(context).size.width / 1.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder(
              valueListenable: productSearchNotifier,
              builder: (BuildContext context, int newIndex, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 16,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),backgroundColor: productSearchNotifier.value == 1 ? const Color(0xffF25F29) : Colors.white),
                          onPressed: () {
                            productSearchNotifier.value = 1;
                          },
                          child: Text(
                            'code'.tr,
                            style: customisedStyle(context, productSearchNotifier.value == 1 ? Colors.white : Colors.black, FontWeight.w600, 7.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 16,
                          child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: productSearchNotifier.value == 2 ? const Color(0xffF25F29) : Colors.white),
                          onPressed: () {
                            productSearchNotifier.value = 2;
                          },
                          child: Text(
                            'name'.tr,
                            style: customisedStyle(context, productSearchNotifier.value == 2 ? Colors.white : Colors.black, FontWeight.w600, 8.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              backgroundColor: productSearchNotifier.value == 3 ? const Color(0xffF25F29) : Colors.white),
                          onPressed: () {
                            productSearchNotifier.value = 3;
                            print(productSearchNotifier.value);
                          },
                          child: Text(
                            'description'.tr,
                            style: customisedStyle(context, productSearchNotifier.value == 3 ? Colors.white : Colors.black, FontWeight.w600, 7.0),
                          ),
                        ),
                      ),
                    ),
                    autoFocusField
                        ? Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 13,
                              width: MediaQuery.of(context).size.width / 9,
                              child: TextField(
                                controller: autoBarcodeController,
                                style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                                onEditingComplete: () {
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  getBarcodeProduct(context: context, barcode: autoBarcodeController.text);
                                },
                                textAlign: TextAlign.center,
                                // onChanged: (text) {
                                //   setState(() {
                                //     _selectedIndex = 1000;
                                //
                                //   });
                                // },
                                decoration: InputDecoration(
                                    hintText: 'Barcode'.tr,
                                    hintStyle: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                                    isDense: true,
                                    fillColor: const Color(0xffFFFFFF),
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.all(11)),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 14,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),backgroundColor: productSearchNotifier.value == 4 ? const Color(0xffF25F29) : Colors.white),
                                onPressed: () async {
                                  // productSearchNotifier.value = 4;
                                  // String? barcode = await BarcodeScannerClass.scanBarcode(context);
                                  // if (barcode != null) {
                                  //   getBarcodeProduct(context: context, barcode: barcode);
                                  // }
                                },
                                child: Text(
                                  'Barcode'.tr,
                                  style:
                                      customisedStyle(context, productSearchNotifier.value == 4 ? Colors.white : Colors.black, FontWeight.w600, 9.0),
                                ),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 13,
                        width: MediaQuery.of(context).size.width / 9,
                        child: TextField(
                          controller: searchController,
                          style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            setState(() {
                              _selectedIndex = 1000;
                              _searchData(text);
                            });
                          },
                          decoration: InputDecoration(
                              hintText: 'search'.tr,
                              hintStyle: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                              isDense: true,
                              fillColor: const Color(0xffFFFFFF),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(11)),
                        ),
                      ),
                    ),
                  ],
                );
              }),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'veg_only'.tr,
                  style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 05),
                  child: FlutterSwitch(
                    width: 40.0,
                    height: 20.0,
                    valueFontSize: 30.0,
                    toggleSize: 15.0,
                    value: veg,
                    borderRadius: 20.0,
                    padding: 1.0,
                    activeColor: Colors.green,
                    activeTextColor: Colors.green,
                    inactiveTextColor: Colors.white,
                    inactiveColor: Colors.grey,
                    onToggle: (val) {
                      setState(() {
                        productList.clear();
                        _selectedIndex = 1000;
                        veg = val;
                      });
                    },
                  ),
                ),
                // Container(
                //   alignment: Alignment.center,
                //   height: MediaQuery.of(context).size.height / 13,
                //   width: MediaQuery.of(context).size.width / 18,
                //   child: Text(
                //     'Veg Only',
                //     style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
                //   ),
                // ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 13,
                //   width: MediaQuery.of(context).size.width / 17,
                //   child: FlutterSwitch(
                //     width: 40.0,
                //     height: 20.0,
                //     valueFontSize: 30.0,
                //     toggleSize: 15.0,
                //     value: veg,
                //     borderRadius: 20.0,
                //     padding: 1.0,
                //     activeColor: Colors.green,
                //     activeTextColor: Colors.green,
                //     inactiveTextColor: Colors.white,
                //     inactiveColor: Colors.grey,
                //     onToggle: (val) {
                //       setState(() {
                //         productList.clear();
                //         _selectedIndex = 1000;
                //         veg = val;
                //       });
                //     },
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// barcode item add
  getBarcodeProduct({required BuildContext context, required String barcode}) async {
    var netWork = await checkNetwork();

    if (barcode == "") {
      dialogBox(context, "Barcode is empty");
    } else {
      if (netWork) {
        try {
          autoBarcodeController.clear();
          start(context);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var companyID = prefs.getString('companyID') ?? '';
           var branchID = prefs.getInt('branchID') ?? 1;
          var priceRounding = BaseUrl.priceRounding;
          String baseUrl = BaseUrl.baseUrl;
          var userID = prefs.getInt('user_id') ?? 0;
          var accessToken = prefs.getString('access') ?? '';
          final String url = '$baseUrl/posholds/products-search-pos/';
          print(url);
          var type = "";
          if (veg) {
            type = "veg";
          }
          Map data = {
            "IsCode": false,
            "IsDescription": false,
            "is_barcode": true,
            "BranchID": branchID,
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "PriceRounding": priceRounding,
            "product_name": barcode,
            "length": barcode.length,
            "type": type,
          };

          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $accessToken',
              },
              body: body);

          Map n = json.decode(utf8.decode(response.bodyBytes));

          print(response.body);
          var status = n["StatusCode"];
          print(status);

          List responseJson = n["data"] ?? [];
          print(responseJson);

          if (status == 6000) {
            stop();

            print("responseJson   $responseJson");
            if (responseJson.isEmpty) {
              dialogBox(context, "No Product with this barcode");
            } else {
              productList.clear();

              for (Map user in responseJson) {
                productList.add(ProductListModelDetail.fromJson(user));
              }

              searchController.clear();
              FocusScope.of(context).requestFocus(submitFocusButton);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              setState(() {
                order = 1;
                var checkVat = prefs.getBool("checkVat") ?? false;
                var checkGst = prefs.getBool("check_GST") ?? false;
                var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;
                // var selectedPrinter = prefs.getString('printer') ?? '';
                // var kot = prefs.getBool('KOT') ?? false;

                unitPriceAmountWR = productList[0].defaultSalesPrice;
                inclusiveUnitPriceAmountWR = productList[0].defaultSalesPrice;
                vatPer = double.parse(productList[0].vatsSalesTax);
                gstPer = double.parse(productList[0].gSTSalesTax);

                priceListID = productList[0].defaultUnitID;
                productName = productList[0].productName;
                item_status = "pending";
                unitName = productList[0].defaultUnitName;


                print(productList[0].taxDetails);



                var taxDetails = productList[0].taxDetails;
                if(taxDetails !=""){
                  productTaxID = taxDetails["TaxID"];
                  productTaxName = taxDetails["TaxName"];
                }

                // if (ch
                //
                //
                // eckVat == true) {
                //   productTaxName = productList[0].vATTaxName;
                //   productTaxID = productList[0].vatID;
                // } else if (checkGst == true) {
                //   productTaxName = productList[0].gSTTaxName;
                //   productTaxID = productList[0].gstID;
                // } else {
                //
                //
                //   productTaxName = "None";
                //   productTaxID = 1;
                // }

                detailID = 1;
                salesPrice = productList[0].defaultSalesPrice;
                detailDescriptionController.text = productList[0].description;
                purchasePrice = productList[0].defaultPurchasePrice;
                productID = productList[0].productID;
                isInclusive = productList[0].isInclusive;

                editProductItem = false;
                detailIdEdit = 0;
                flavourID = "";
                flavourName = "";

                var newTax = productList[0].exciseData;

                print(newTax);
                print("excise brfore $isExciseProduct");
                if (newTax != "") {
                  isExciseProduct = true;
                  exciseTaxID = newTax["TaxID"];
                  exciseTaxName = newTax["TaxName"];
                  BPValue = newTax["BPValue"].toString();
                  exciseTaxBefore = newTax["TaxBefore"].toString();
                  isAmountTaxBefore = newTax["IsAmountTaxBefore"];
                  isAmountTaxAfter = newTax["IsAmountTaxAfter"];
                  exciseTaxAfter = newTax["TaxAfter"].toString();
                } else {
                  exciseTaxID = 0;
                  exciseTaxName = "";
                  BPValue = "0";
                  exciseTaxBefore = "0";
                  isAmountTaxBefore = false;
                  isAmountTaxAfter = false;
                  isExciseProduct = false;
                  exciseTaxAfter = "0";
                }



                /// qty increment
                if (qtyIncrement == true) {
                  print("true in settings");
                  if (checking(priceListID)) {
                    print("true in function");
                    unique_id = orderDetTable[tableIndex].uniqueId;
                    updateQty(1, tableIndex);
                    tableIndex = 0;
                  } else {
                    unique_id = "0";
                    calculation();
                  }
                } else {
                  unique_id = "0";
                  calculation();
                }
              });
            }
          } else if (status == 6001) {
            stop();
            // stop();
            var msg = n["error"];
            dialogBox(context, msg);
          } else {
            stop();

            //   stop();
          }
        } catch (e) {
          stop();
          print(e.toString());
          // stop();
        }
      } else {
        dialogBox(context, "Check your network connection");
      }
    }
  }

  ///

  var a = 1;

  Widget displayCategoryNames() {
    return Container(
   //  color: Colors.grey,
      padding: const EdgeInsets.only(left: 2, right: 2),
      height: MediaQuery.of(context).size.height / 6, //height of button
   //   width: MediaQuery.of(context).size.width / 1.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(0),
            height: MediaQuery.of(context).size.height / 9,
            //height of button
            width: MediaQuery.of(context).size.width / 25,
            decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(5))),
            child: IconButton(
              onPressed: () {
                print("object data=================-=-=-=-=-$a");
                setState(() {
                  ///if condition
                  if (a != 0) {
                    a = a - 1;
                    _animateToIndex(a);
                  }
                  else {}
                });
              },
              icon: SvgPicture.asset(
                'assets/svg/arrowback.svg',
              ),
            ),
          ),

          ///here

          categoryList.isNotEmpty?
          Container(
            height: MediaQuery.of(context).size.height / 8, //height of button
           // width: _width,
           width: MediaQuery.of(context).size.width / 2.2,

            child: GridView.builder(
                controller: categoryController,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .18,
                  crossAxisSpacing: 2,
                ),
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    hoverColor: Colors.transparent,
                    selected: index == _selectedIndex,
                    onTap: () {
                      searchController.clear();
                      FocusScope.of(context).requestFocus(submitFocusButton);

                      setState(() {
                        _selectedIndex = index;
                        productList.clear();
                      });
                      getProductListDetails(categoryList[index].categoryGroupId);
                    },
                    title: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: _selectedIndex == index ? const Color(0xff172026) : Colors.white,
                          side: const BorderSide(color: Color(0xffB8B8B8), width: .2),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedIndex = index;
                            productList.clear();
                          });
                          getProductListDetails(categoryList[index].categoryGroupId);
                        },
                        child: Text(categoryList[index].categoryName,
                            style: customisedStyle(context, _selectedIndex == index ? Colors.white : const Color(0xff172026), FontWeight.w500, 10.5)
                            //    style: TextStyle(color:_selectedIndex == index ? Colors.white :const Color(0xff172026),),
                            )),
                  );
                }),
          ):Container(),

          Container(
            decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: const EdgeInsets.all(0),
            height: MediaQuery.of(context).size.height / 9,
            //height of button
            width: MediaQuery.of(context).size.width / 25,
            child: IconButton(
              onPressed: () {
                setState(() {

                  print("a $a   totalCategory   totalCategory  categoryList.length ${categoryList.length}");
                  a = a + 1;
                  _animateToIndex(a);
                });
              },

              icon: SvgPicture.asset('assets/svg/arrowforward.svg'),
            ),
          ),
        ],
      ),
    );
  }

  returnVegOrNonVeg(type) {
    if (type == "veg") {
      return "assets/svg/product_veg.svg";
    } else {
      return "assets/svg/product_non_veg.svg";
    }
  }

  returnProductName(String val) {
    var out = val;
    if (val.length > 30) {
      out = val.substring(0, 28);
    }
    return out;
  }

  Widget displayProductDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Container(
          height: MediaQuery.of(context).size.height / 1.5, //height of button
          width: MediaQuery.of(context).size.width / 1.6,
          child: GridView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 30),
              controller: productController,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.3, //2.4 will workk
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int i) {
                return GestureDetector(
                  onTap: () async {
                    searchController.clear();
                    FocusScope.of(context).requestFocus(submitFocusButton);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    setState(() {
                      order = 1;
                      var checkVat = prefs.getBool("checkVat") ?? false;
                      var checkGst = prefs.getBool("check_GST") ?? false;

                      var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                      unitPriceAmountWR = productList[i].defaultSalesPrice;
                      inclusiveUnitPriceAmountWR = productList[i].defaultSalesPrice;
                      vatPer = double.parse(productList[i].vatsSalesTax);
                      gstPer = double.parse(productList[i].gSTSalesTax);

                      priceListID = productList[i].defaultUnitID;
                      productName = productList[i].productName;
                      item_status = "pending";
                      unitName = productList[i].defaultUnitName;


                      var taxDetails = productList[i].taxDetails;
                      if(taxDetails !=""){
                        productTaxID = taxDetails["TaxID"];
                        productTaxName = taxDetails["TaxName"];
                      }




                      detailID = 1;
                      salesPrice = productList[i].defaultSalesPrice;
                      detailDescriptionController.text = productList[i].description;
                      purchasePrice = productList[i].defaultPurchasePrice;
                      productID = productList[i].productID;
                      isInclusive = productList[i].isInclusive;

                      editProductItem = false;
                      detailIdEdit = 0;
                      flavourID = "";
                      flavourName = "";

                      var newTax = productList[i].exciseData;


                      if (newTax != "") {
                        isExciseProduct = true;
                        exciseTaxID = newTax["TaxID"];
                        exciseTaxName = newTax["TaxName"];
                        BPValue = newTax["BPValue"].toString();
                        exciseTaxBefore = newTax["TaxBefore"].toString();
                        isAmountTaxBefore = newTax["IsAmountTaxBefore"];
                        isAmountTaxAfter = newTax["IsAmountTaxAfter"];
                        exciseTaxAfter = newTax["TaxAfter"].toString();
                      } else {
                        exciseTaxID = 0;
                        exciseTaxName = "";
                        BPValue = "0";
                        exciseTaxBefore = "0";
                        isAmountTaxBefore = false;
                        isAmountTaxAfter = false;
                        isExciseProduct = false;
                        exciseTaxAfter = "0";
                      }


                      /// commented for new tax working

                      /// qty increment
                      if (qtyIncrement == true) {
                        print("true in settings");

                        if (checking(priceListID)) {
                          print("true in function");
                          unique_id = orderDetTable[tableIndex].uniqueId;
                          updateQty(1, tableIndex);
                          tableIndex = 0;
                        } else {
                          unique_id = "0";
                          calculation();
                        }
                      } else {
                        unique_id = "0";
                        calculation();
                      }
                    });
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 8, //height of button
                    width: MediaQuery.of(context).size.width / 6,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffC9C9C9),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                            )),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          productList[i].productImage == ''
                              ? Container(
                                  height: MediaQuery.of(context).size.height / 15, //height of button
                                  width: MediaQuery.of(context).size.width / 22,
                                  decoration: BoxDecoration(
                                      //  color: Colors.red,
                                      border: Border.all(
                                        width: .1,
                                        color: const Color(0xffC9C9C9),
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                          )),

                                  child: SvgPicture.asset("assets/svg/Logo.svg"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 15, //height of button
                                    width: MediaQuery.of(context).size.width / 22,

                                    decoration: BoxDecoration(
                                        image: DecorationImage(image:
                                        NetworkImage(productList[i].productImage), fit: BoxFit.cover),
                                        border: Border.all(
                                          width: .1,
                                          color: const Color(0xffC9C9C9),
                                        ),
                                        borderRadius: const BorderRadius.all(Radius.circular(5.0) //                 <--- border radius here
                                            )),
                                  ),
                                ),

                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Container(
                              //   color: Colors.purple,
                              //  height: MediaQuery.of(context).size.height / 8.5,
                              //  height of button
                              width: MediaQuery.of(context).size.width / 9,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(returnProductName(productList[i].productName),
                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 11.5)),
                                  ),
                                  SizedBox(
                                    // height: MediaQuery.of(context).size.height /                                    17, //height of button
                                    //  width: MediaQuery.of(context).size.width / 11,
                                    child: Text(
                                      returnProductName(productList[i].description),
                                      style: customisedStyle(context, Colors.black, FontWeight.w600, 11.0),
                                    ),
                                  ),
                                  SizedBox(
                                    //  height: MediaQuery.of(context).size.height /                                   24, //height of button
                                    // width: MediaQuery.of(context).size.width / 11,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("$currency ${roundStringWith(productList[i].defaultSalesPrice)}",
                                            //'Rs.95 ',
                                            style: customisedStyle(context, Colors.blueGrey, FontWeight.w500, 12.0)),
                                        Container(
                                          height: MediaQuery.of(context).size.height / 42,
                                          child: SvgPicture.asset(returnVegOrNonVeg(productList[i].vegOrNonVeg)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })),
    );
  }

//15772100027983
  /// display order items
  ordersList(int order) {
    if (order == 1) {
      return displayOrderedList();
    } else if (order == 2) {
      return ProductEditWidget();
    } else {}
  }

  List selectedItemsDelivery = [];
  bool lngPress = false;

  selectAll() {
    setState(() {
      selectedItemsDelivery.clear();
      for (var i = 0; i < orderDetTable.length; i++) {
        print("_______________________________________");
        selectedItemsDelivery.add(i);
      }
      print(selectedItemsDelivery);
    });
  }

  changeStatusToDelivered(type) {
    for (var i = 0; i < selectedItemsDelivery.length; i++) {
      parsingJson[selectedItemsDelivery[i]]["Status"] = type;
    }

    setState(() {
      orderDetTable.clear();
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
      selectedItemsDelivery.clear();
      lngPress = false;
    });
  }

  returnStatusSelected(index) {
    setState(() {
      selectedItemsDelivery.clear();
      for (var i = 0; i < orderDetTable.length; i++) {
        print("_______________________________________");
        selectedItemsDelivery.add(i);
      }
      print(selectedItemsDelivery);
    });
  }

  bool newCheckValue = false;

  returnColorListItem(status) {
    if (status == "pending") {
      return Colors.green;
    } else if (status == "delivered") {
      return Colors.black12;
    } else {
      return Colors.blueAccent;
    }
  }

  returnHead(val1, val2) {
    if (lngPress) {
      return val1;
    } else {
      return val2;
    }
  }

  returnListHeight() {
    var a = lngPress ? 0.5 : 0.6;
    return MediaQuery.of(context).size.height * a;
  }

  returnTax(){
    return exciseAmountTotalP>0 ?  Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'excise_tax'.tr+" ",
                style:customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text(currency+" ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),
              Text(roundStringWith(exciseAmountTotalP.toString()), style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_vat'.tr+" ",
                style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text(currency+" ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),

              Text(roundStringWith(vatAmountTotalP.toString()), style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_tax'.tr+" ",
                style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text(currency+" ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),
              Text(roundStringWith(totalTaxMP.toString()),
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),


        ],
      ),
    ):
    isGst?
    Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CGst  ",
                style:customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text("$currency ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),
              Text(" "+roundStringWith(cGstAmountTotalP.toString()), style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SGst  ",
                style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text("$currency ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),

              Text(roundStringWith(sGstAmountTotalP.toString()), style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_tax'.tr+" ",
                style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0),
              ),
              Text(currency+" ", style: customisedStyle(context, Colors.grey, FontWeight.w500, 11.0)),
              Text(roundStringWith(totalTaxMP.toString()),
                  style: customisedStyle(context, Colors.black, FontWeight.w500, 13.0))
            ],
          ),


        ],
      ),
    )

        :   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'total_tax'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w400, 12.0),
        ),
        Text(currency + " " + "${roundStringWith(totalTaxMP.toString())}",
            style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0))
      ],
    );
  }

  Widget displayOrderedList() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.15, //height of button
      width: MediaQuery.of(context).size.width / 2.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 11,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),backgroundColor: const Color(0xff0347A1)),
                      onPressed: () {

                        print("object");
                        changeStatusToDelivered("take_away");
                      },
                      child: Text(
                        'Take_awy'.tr,
                        style: customisedStyle(context, Colors.white, FontWeight.w500, 10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 11,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),backgroundColor: const Color(0xff000000)),
                      onPressed: () {
                        changeStatusToDelivered("delivered");
                      },
                      child: Text(
                        'Delivered',
                        style: customisedStyle(context, Colors.white, FontWeight.w500, 10.0),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                  width: MediaQuery.of(context).size.width / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'no_of_items'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w400, 13.0),
                      ),
                      Text(
                        (orderDetTable.length).toString(),
                        style: customisedStyle(context, Colors.black, FontWeight.w600, 14.0),
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0),
                //   child: SizedBox(
                //     width: MediaQuery.of(context).size.width / 13,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(backgroundColor: Color(0xffF25F29)),
                //       onPressed: () {},
                //       child: Text(
                //         'Convert to >',
                //         style: customisedStyle(context, Colors.white, FontWeight.w500, 10.0),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          lngPress
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.00),
                  child: Container(
                    // height: mHeight * .12,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: const Color(0xff08A103),
                              value: newCheckValue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onChanged: (value) {
                                newCheckValue = !newCheckValue;
                                print(newCheckValue);
                                if (newCheckValue) {
                                  selectAll();
                                } else {
                                  setState(() {
                                    selectedItemsDelivery.clear();
                                    lngPress = false;
                                  });
                                }
                              },
                            ),
                            Text(
                              "Select all",
                              style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              height: returnListHeight(),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: orderDetTable.length,
                separatorBuilder: (BuildContext context, int index) => const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final item = orderDetTable[index];
                  print("_+______________item $item");
                  final isSelected = selectedItemsDelivery.contains(index);
                  print(isSelected);
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 9,
                    // width: MediaQuery.of(context).size.width / 2.5,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      lngPress == true
                          ? Checkbox(
                              checkColor: Colors.white,
                              activeColor: const Color(0xff08A103),
                              value: isSelected,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              onChanged: (value) {
                                setState(() {
                                  if (isSelected) {
                                    selectedItemsDelivery.remove(index);
                                  } else {
                                    selectedItemsDelivery.add(index);
                                  }
                                });
                              },
                            )
                          : Container(),
                      Container(
                        //   width: MediaQuery.of(context).size.width / 4.2,
                        decoration: BoxDecoration(
                            color: isSelected ? const Color(0xff82acd9) : const Color(0xffFffff),
                            //  color: isSelected ? Color(0xff82acd9) : returnColorListItem(orderDetTable[index].item_status),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 9,
                                width: 20,
                                child: SvgPicture.asset(returnIconStatus(orderDetTable[index].status)),
                              ),
                            ),
                            GestureDetector(
                              child: AbsorbPointer(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(3),

                                      // color:Colors.red,
                                      // height: MediaQuery.of(context).size.height / 9,
                                      width: MediaQuery.of(context).size.width / returnHead(7.5, 6.5),
                                      child: ListView(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  orderDetTable[index].productName,
                                                  style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
                                                  // style: customisedStyle(context, returnColorITem(orderDetTable[index].item_status), FontWeight.w600, 12.0),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            orderDetTable[index].description,
                                            style: customisedStyle(context, Colors.black, FontWeight.normal, 10.0),
                                          ),
                                          Text(
                                            orderDetTable[index].flavourName,
                                            style: customisedStyle(context, Colors.black, FontWeight.normal, 10.0),
                                          )
                                        ],
                                      ),
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //         color: Colors.grey, width: .2))
                                    ),
                                    Container(
                                      ///    color:Colors.yellow,
                                      padding: const EdgeInsets.all(3),
                                      // height: MediaQuery.of(context).size.height / 9,
                                      width: MediaQuery.of(context).size.width / returnHead(10, 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Rate".tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text("Qty".tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text("Tax".tr, style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text("Net".tr, style: customisedStyle(context, Colors.black, FontWeight.w600, 11.0)),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                      //' ',
                                                      roundStringWith(orderDetTable[index].unitPrice),
                                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text(roundStringWith(orderDetTable[index].quantity),
                                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text(returnTotalTax(orderDetTable[index].vatAmount,orderDetTable[index].exciseTaxAmount),
                                                      style: customisedStyle(context, Colors.black, FontWeight.w500, 10.0)),
                                                  Text(roundStringWith(orderDetTable[index].netAmount),
                                                      style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // decoration: BoxDecoration(
                                      //   //color: Colors.red,
                                      //   border: Border.all(color: Colors.grey, width: .2),
                                      // )
                                    ),
                                  ],
                                ),
                              ),
                              onLongPress: () {
                                setState(() {
                                  selectedItemsDelivery.clear();
                                  lngPress = !lngPress;
                                  selectedItemsDelivery.add(index);
                                });
                              },
                              onTap: () async {

                                if (lngPress) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedItemsDelivery.remove(index);
                                    } else {
                                      selectedItemsDelivery.add(index);
                                    }
                                  });
                                } else {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  setState(() {
                                    editProductItem = true;
                                    detailIdEdit = index;
                                    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
                                    var checkVat = prefs.getBool("checkVat") ?? false;
                                    var checkGst = prefs.getBool("check_GST") ?? false;

                                    unitPriceDetailController.text = roundStringWith(orderDetTable[index].unitPrice);
                                    inclusiveUnitPriceAmountWR = orderDetTable[index].inclusivePrice;
                                    qtyDetailController.text = orderDetTable[index].quantity;
                                    quantity = double.parse(orderDetTable[index].quantity);
                                    vatPer = double.parse(orderDetTable[index].vatPer);
                                    gstPer = double.parse(orderDetTable[index].gstPer);
                                    priceListID = orderDetTable[index].priceListId;
                                    productName = orderDetTable[index].productName;
                                    item_status = orderDetTable[index].status;
                                    unitName = orderDetTable[index].unitPriceName;
                                    flavourID = orderDetTable[index].flavourID;
                                    flavourName = orderDetTable[index].flavourName;
                                    unique_id = orderDetTable[index].uniqueId;
                                    netAmount = double.parse(orderDetTable[index].netAmount);

                                    if (checkVat == true) {
                                      productTaxName = orderDetTable[index].productTaxName;
                                      productTaxID = orderDetTable[index].productTaxID;
                                    } else if (checkGst == true) {
                                      productTaxName = orderDetTable[index].productTaxName;
                                      productTaxID = orderDetTable[index].productTaxID;
                                    } else {
                                      productTaxName = "None";
                                      productTaxID = 1;
                                    }

                                    detailID = orderDetTable[index].detailID;
                                    salesPrice = orderDetTable[index].salesPrice;
                                    detailDescriptionController.text = orderDetTable[index].description;
                                    purchasePrice = orderDetTable[index].costPerPrice;
                                    productID = orderDetTable[index].productId;
                                    isInclusive = orderDetTable[index].productInc;

                                    actualProductTaxName = orderDetTable[index].actualProductTaxName;
                                    actualProductTaxID = orderDetTable[index].actualProductTaxID;
                                    unitPriceAmountWR = orderDetTable[index].unitPrice;
                                    rateWithTax = double.parse(orderDetTable[index].rateWithTax);
                                    costPerPrice = orderDetTable[index].costPerPrice;
                                    discountPer = orderDetTable[index].discountPercentage;
                                    discountAmount = double.parse(orderDetTable[index].discountAmount);
                                    grossAmountWR = orderDetTable[index].grossAmount;
                                    vatAmount = double.parse(orderDetTable[index].vatAmount);
                                    sGSTPer = double.parse(orderDetTable[index].sgsPer);
                                    sGSTAmount = double.parse(orderDetTable[index].sgsAmount);
                                    cGSTPer = double.parse(orderDetTable[index].cgsPer);
                                    cGSTAmount = double.parse(orderDetTable[index].cgsAmount);
                                    iGSTPer = double.parse(orderDetTable[index].igsPer);
                                    iGSTAmount = double.parse(orderDetTable[index].igsAmount);
                                    createdUserID = orderDetTable[index].createUserId;
                                    dataBase = "";
                                    taxableAmountPost = double.parse(orderDetTable[index].taxableAmount);
                                    gstPer = double.parse(orderDetTable[index].gstPer);
                                    unitPriceRounded = roundDouble(double.parse(orderDetTable[index].unitPrice), qtyDecimal);
                                    quantityRounded = roundDouble(double.parse(orderDetTable[index].quantity), qtyDecimal);
                                    netAmountRounded = roundDouble(double.parse(orderDetTable[index].netAmount), qtyDecimal);
                                    totalTax = double.parse(orderDetTable[index].totalTaxRounded);
                                     exciseTaxID = orderDetTable[index].exciseTaxID;
                                     exciseTaxName = orderDetTable[index].exciseTaxName;
                                     BPValue = orderDetTable[index].bPValue;
                                     exciseTaxBefore = orderDetTable[index].exciseTaxBefore;
                                     isAmountTaxBefore = orderDetTable[index].isAmountTaxBefore;
                                     isAmountTaxAfter = orderDetTable[index].isAmountTaxAfter;
                                     isExciseProduct = orderDetTable[index].isExciseProduct;
                                     exciseTaxAfter = orderDetTable[index].exciseTaxAfter;
                                     exciseTaxAmount= double.parse(orderDetTable[index].exciseTaxAmount);

                                     order = 2;
                                    if (flavourList.isEmpty) {
                                      print('its empty-*------------------------------------its empty-*------------------------------------its empty-*------------------------------------its empty-*------------------------------------');
                                      getAllFlavours();
                                    } else {
                                      print('its already-*------------------------------------its already-*------------------------------------its already-*------------------------------------its already-*------------------------------------');
                                    }
                                  });
                                }
                              }, //
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 8,
                              width: 30,
                              color: Colors.red,
                              child: IconButton(
                                iconSize: 10,
                                onPressed: () async {
                                  var dictionary = {
                                    "unq_id": orderDetTable[index].uniqueId,
                                  };
                                  if (orderDetTable[index].detailID == 1) {
                                  } else {
                                    selectedItemsDelivery.remove(index);
                                    deletedList.add(dictionary);
                                  }
                                  orderDetTable.removeAt(index);
                                  orderDetTable.clear();
                                  parsingJson.removeAt(index);

                                  await deleteItem();
                                },
                                icon: SvgPicture.asset('assets/svg/clear.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  );
                },
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(4),

            height: MediaQuery.of(context).size.height / 6,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Column(
              children: [

                returnTax(),


                SizedBox(
                //  height: MediaQuery.of(context).size.height / 27,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'to_be_paid'.tr,
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
                      ),
                      Text(
                        currency + " " + "${roundStringWith(totalNetP.toString())}",
                        style: customisedStyle(context, Colors.black, FontWeight.w600, 16.0),
                      )
                    ],
                  ),
                ),
                Container(
                  // color: Colors.red,
               //   height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    SizedBox(
                      // height: MediaQuery.of(context).size.height / 20,
                   //   width: MediaQuery.of(context).size.width / 10,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          foregroundColor: const Color(0xffFFFFFF), backgroundColor: const Color(0xffFF0000), // Background Color
                        ),
                        onPressed: () {
                          functionBack();
                          //Navigator.pop(context);
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.asset("assets/svg/clear.svg", width: 10),
                          // IconButton(
                          //   icon: SvgPicture.asset('assets/svg/clear.svg'),
                          //   onPressed: () {
                          //     functionBack();
                          //   },
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'cancel'.tr+"  ",
                              style: customisedStyle(context, Colors.white, FontWeight.normal, 13.0),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(
                      //  height: MediaQuery.of(context).size.height / 17,
                     // width: MediaQuery.of(context).size.width / 10,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: const Color(0xff10C103), // Background Color
                        ),
                        onPressed: () async {
                          if (orderDetTable.isEmpty) {
                            dialogBox(context, "At least one product");
                          } else {
                            bool val = await checkNonRatableItem();
                            if (val) {
                              postingData(true);
                            } else {
                              dialogBox(context, "Price must be greater than 0");
                            }
                          }
                        },
                        child: InkWell(
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            SvgPicture.asset("assets/svg/check.svg", width: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(
                                'payment'.tr,
                                style: customisedStyle(context, Colors.white, FontWeight.normal, 13.0),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      //  height: MediaQuery.of(context).size.height / 17,
                    //  width: MediaQuery.of(context).size.width / 10,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          backgroundColor: const Color(0xff10C103), // Background Color
                        ),
                        onPressed: () async {
                          if (orderDetTable.isEmpty) {
                            dialogBox(context, "At least one product");
                          } else {

                            bool val = await checkNonRatableItem();
                            if (val) {
                              postingData(false);
                            } else {
                              dialogBox(context, "Price must be greater than 0");
                            }
                          }
                        },
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          SvgPicture.asset("assets/svg/check.svg", width: 15),
                          // IconButton(
                          //   icon: SvgPicture.asset('assets/svg/check.svg'),
                          //   onPressed: () {
                          //     //functionBack();
                          //   },
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Text(
                              'save'.tr+"    ",
                              style: customisedStyle(context, Colors.white, FontWeight.normal, 13.0),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  returnTotalTax(vatAmount,exciseAmount){
    print(vatAmount);
    print(exciseAmount);
    var total = double.parse(vatAmount)+double.parse(exciseAmount);
    return roundStringWith("$total");
  }


  returnIconStatus(status) {
    if (status == "pending") {
      return "assets/svg/pending.svg";
    } else if (status == "delivered") {
      return "assets/svg/delivered.svg";
    } else {
      return "assets/svg/take_away.svg";
    }
  }

  returnColorITem(status) {
    print(status);
    if (status == "pending") {
      return Colors.green;
    } else if (status == "delivered") {
      return Colors.black;
    } else {
      return const Color(0xff0347A1);
    }
  }

  checkNonRatableItem() {
    bool returnVal = true;
    for (var i = 0; i < orderDetTable.length; i++) {
      if (double.parse(orderDetTable[i].unitPrice) > 0.0) {
        returnVal = true;
      } else {
        print("its not");
        return false;
      }
    }

    return returnVal;
  }

  deleteItem() {
    setState(() {
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
      totalAmount();
    });
  }

  returnRadio(selectedInd, index) {
    return true;
  }

  Widget ProductEditWidget() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.15, //height of button
      width: MediaQuery.of(context).size.width / 3,

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 18, //height of button
              width: MediaQuery.of(context).size.width / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //alignment: Alignment.l,
                    height: MediaQuery.of(context).size.height / 18, //height of button
                    width: MediaQuery.of(context).size.width / 9,
                    child: Text(
                      productName,
                      style: customisedStyle(context, const Color(0xff000000), FontWeight.w600, 15.00),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 18, //height of button
                    width: MediaQuery.of(context).size.width / 7,
                    child: Row(
                      children: [
                        Container(
                          // alignment: Alignment.center,

                          height: MediaQuery.of(context).size.height / 13,
                          //height of button
                          width: MediaQuery.of(context).size.width / 29,
                          decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(3))),

                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (quantity <= 0) {
                                  } else {
                                    quantity = quantity - 1;
                                    calculationOnEditing(true);
                                  }
                                });
                              },
                              icon: SvgPicture.asset('assets/svg/increment_qty.svg')),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 13, //height of button
                          width: MediaQuery.of(context).size.width / 15,
                          child: TextField(
                            controller: qtyDetailController,
                            textAlign: TextAlign.center,
                            style: customisedStyle(context, const Color(0xff000000), FontWeight.w500, 14.00),
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                quantity = double.parse(text);
                                calculationOnEditing(false);
                              } else {}
                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(12),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          alignment: Alignment.center,

                          height: MediaQuery.of(context).size.height / 13,
                          //height of button
                          width: MediaQuery.of(context).size.width / 29,
                          decoration: const BoxDecoration(color: Color(0xffF25F29), borderRadius: BorderRadius.all(Radius.circular(3))),

                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  quantity = quantity + 1;
                                  calculationOnEditing(true);
                                });

                                // - assets/svg/increment_qty.svg
                                //     - assets/svg/decrease_item.svg
                              },
                              icon: SvgPicture.asset('assets/svg/decrease_item.svg')),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
//             Container(
// color: Colors.green,
//               // height: MediaQuery.of(context).size.height / 30, //height of button
//               width: MediaQuery.of(context).size.width / 2.8,
//               child: Text(
//                 "descriptionD",
//                 style: customisedStyle(context, Color(0xff717171), FontWeight.w400, 12.00),
//               ),
//             ),

            const SizedBox(
              height: 10,
            ),

            ///   total tax and net amount commented
            // Container(
            //   padding: const EdgeInsets.all(4),
            //   height: MediaQuery.of(context).size.height / 7,
            //   width: MediaQuery.of(context).size.width / 2.5,
            //   child: Column(
            //     children: [
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height / 30,
            //         width: MediaQuery.of(context).size.width / 2.5,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'Tax',
            //               //  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            //               style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
            //             ),
            //             Text(
            //               currency + " " + "$totalTax",
            //               //   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            //
            //               style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
            //             )
            //           ],
            //         ),
            //       ),
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height / 27,
            //         width: MediaQuery.of(context).size.width / 2.5,
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'To be Paid',
            //               style: customisedStyle(context, Colors.black, FontWeight.w600, 14.00),
            //             ),
            //             Text(
            //               currency + " " + "$netAmount",
            //               style: customisedStyle(context, Colors.black, FontWeight.w600, 14.00),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: MediaQuery.of(context).size.height / 17, //height of button
              width: MediaQuery.of(context).size.width / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 18, //height of button
                    //  width: MediaQuery.of(context).size.width / 13,
                    child: Text(
                      'Rate:',
                      style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w600, 12.00),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18, //height of button
                    width: MediaQuery.of(context).size.width / 10,
                    child: TextField(
                      textAlign: TextAlign.end,
                      controller: unitPriceDetailController,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 12.00),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                      ],
                      onChanged: (text) {
                        if (text.isNotEmpty) {
                          calculationOnEditing(false);
                        } else {}
                      },
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            /// flavour cratin commented
            Container(
              //  color: Colors.black,
              height: 50,
              child: Container(
                //   width: MediaQuery.of(context).size.width / 6,
                height: MediaQuery.of(context).size.height / 12,
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  //  focusNode: custNameHeaderFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).nextFocus();
                  },
                  onTap: () => detailDescriptionController.selection =
                      TextSelection(baseOffset: 0, extentOffset: detailDescriptionController.value.text.length),
                  controller: detailDescriptionController,
                  decoration: TextFieldDecoration.rectangleTextField(hintTextStr: 'description'.tr),
                ),
              ),
            ),
            Expanded(
              child: Container(
                //  color: Colors.purple,
                //  height: MediaQuery.of(context).size.height / 8, //height of button
                //      width: MediaQuery.of(context).size.width / 2.2,

                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: flavourList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: ListTile(
                        tileColor: flavourID == flavourList[index].id ? Colors.redAccent : const Color(0xffEEEEEE),
                        title: Text(
                          flavourList[index].flavourName,
                          style: customisedStyle(context, Colors.black, FontWeight.w400, 12.00),
                        ),
                        onTap: () async {
                          setState(() {
                            flavourID = flavourList[index].id;
                            flavourName = flavourList[index].flavourName;
                            // selectedIndexFlavour = index;
                          });
                        },
                      ));
                    }),
              ),
            ),

            Container(
              alignment: Alignment.bottomCenter,
              height: MediaQuery.of(context).size.height / 14, //height of button
              width: MediaQuery.of(context).size.width / 2.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    //  height: MediaQuery.of(context).size.height / 22, //,height of button
                    width: MediaQuery.of(context).size.width / 6.5,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: const Color(0xffFF0000),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          order = 1;
                        });
                      },
                      child: Text(
                        'cancel'.tr,
                        style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00),
                      ),
                    ),
                  ),
                  SizedBox(
                    // height: MediaQuery.of(context).size.height / 22, //height of button
                    width: MediaQuery.of(context).size.width / 6.5,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16.0),
                        backgroundColor: const Color(0xff309E10),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {

                          order = 1;
                          addData();

                      },
                      child: Text(
                        'save'.tr,
                        style: customisedStyle(context, Colors.white, FontWeight.w600, 12.00),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }




  /// product tax calculation
  calculation() async {
    var grossAmount;
    var unit;
    taxType = "None";
    taxID = 32;

    var discount;
    var inclusivePer = 0.0;
    var exclusivePer = 0.0;
    quantity = 1.0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var checkVat = prefs.getBool("checkVat") ?? false;
    var checkGst = prefs.getBool("check_GST") ?? false;
    var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

    if (checkVat == true) {
      taxType = "VAT";
      taxID = 32;
      if (isInclusive == true) {
        inclusivePer = inclusivePer + vatPer;
      } else {
        exclusivePer = exclusivePer + vatPer;
      }
    }
    if (checkGst == true) {
      taxType = "GST Intra-state B2C";
      taxID = 22;
      if (isInclusive == true) {
        inclusivePer = inclusivePer + gstPer;
      } else {
        exclusivePer = exclusivePer + gstPer;
      }
    }

    unit = double.parse(unitPriceAmountWR);
    if (inclusivePer == 0.0) {
      unitPriceAmountWR = (unit).toString();

      var taxAmount = (unit * exclusivePer) / 100;
      inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
      unit = unit;
    } else {
      var taxAmount = (unit * inclusivePer) / (100 + inclusivePer);
      print(taxAmount);
      unit = unit - taxAmount;
      inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
      unitPriceAmountWR = (unit).toString();
      print(unit);
    }

    discount = 0.0;
    percentageDiscount = 0;
    discountAmount = 0;

    grossAmount = quantity * unit;

      exciseTaxAmount = 0.0;
    if (isExciseProduct) {
      exciseTaxAmount = calculateExciseTax(
        breakEvenValue: double.parse(BPValue),
        greaterAmount: isAmountTaxAfter,
        greaterThanValue: double.parse(exciseTaxAfter),
        lessAmount: isAmountTaxBefore,
        lessThanValue: double.parse(exciseTaxBefore),
        price: grossAmount,
      );
    }
    grossAmountWR = "$grossAmount";
    taxableAmountPost = grossAmount - discount;
    vatAmount = ((taxableAmountPost+exciseTaxAmount) * vatPer / 100);

    gstAmount = (taxableAmountPost * gstPer / 100);




    var ga = roundDouble(gstAmount, priceDecimal);
    var va = roundDouble(vatAmount, priceDecimal);

    if (checkVat == false) {
      vatAmount = 0.0;
      print(vatAmount);
    }
    if (checkGst == false) {
      gstAmount = 0.0;
    }

    cGSTAmount = gstAmount / 2;
    sGSTAmount = gstAmount / 2;
    iGSTAmount = gstAmount;
    cGSTPer = gstPer / 2;
    iGSTPer = gstPer;
    sGSTPer = gstPer / 2;

    if (taxType == "Export") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
    } else if (taxType == "Import") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
      print('import');
    } else if (taxType == "GST Inter-state B2C") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      totalTax = iGSTAmount;
    } else if (taxType == "GST Inter-state B2B") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      totalTax = iGSTAmount;
    } else if (taxType == "GST Intra-state B2C") {
      iGSTAmount = 0.0;
      totalTax = cGSTAmount + cGSTAmount;
    } else if (taxType == "GST Intra-state B2B") {
      iGSTAmount = 0.0;
      totalTax = cGSTAmount + sGSTAmount;
    } else if (taxType == "None") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
      print(totalTax);
    } else if (taxType == "VAT") {
      totalTax = vatAmount+exciseTaxAmount;
    }

    netAmount = taxableAmountPost + totalTax;
    var singleTax = totalTax / quantity;
    rateWithTax = unit + singleTax;
    costPerPrice = purchasePrice;
    percentageDiscount = (discount * 100 / netAmount);
    discountAmount = discount;

    var tt = roundDouble(totalTax, priceDecimal);
    quantityRounded = roundDouble(quantity, qtyDecimal);
    netAmountRounded = roundDouble(netAmount, qtyDecimal);
    unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);

    Map data = {
      "ProductName": productName,
      "Status": item_status,
      "UnitName": unitName,
      "Qty": "$quantity",
      "ProductTaxName": productTaxName,
      "ProductTaxID": productTaxID,
      "SalesPrice": salesPrice,
      "ProductID": productID,
      "ActualProductTaxName": actualProductTaxName,
      "ActualProductTaxID": actualProductTaxID,
      "BranchID": 1,
      "SalesDetailsID": 1,
      "id": unique_id,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR,
      "RateWithTax": "$rateWithTax",
      "CostPerPrice": costPerPrice,
      "PriceListID": priceListID,
      "DiscountPerc": discountPer,
      "DiscountAmount": "$discountAmount",
      "GrossAmount": "$grossAmount",
      "VATPerc": "$vatPer",
      "VATAmount": "$vatAmount",
      "NetAmount": "$netAmount",
      "detailID": detailID,
      "SGSTPerc": "$sGSTPer",
      "SGSTAmount": "$sGSTAmount",
      "CGSTPerc": "$cGSTPer",
      "CGSTAmount": "$cGSTAmount",
      "IGSTPerc": "$iGSTPer",
      "IGSTAmount": "$iGSTAmount",
      "CreatedUserID": createdUserID,
      "DataBase": dataBase,
      "flavour": flavourID,
      "Flavour_Name": flavourName,
      "TaxableAmount": "$taxableAmountPost",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "$gstPer",
      "is_inclusive": isInclusive,
      "unitPriceRounded": "$unitPriceRounded",
      "quantityRounded": "$quantityRounded",
      "netAmountRounded": "$netAmountRounded",
      "InclusivePrice": inclusiveUnitPriceAmountWR,
      "TotalTaxRounded": "$tt",
      "Description": detailDescriptionController.text,
      "ExciseTaxID":exciseTaxID,
      "ExciseTaxName":exciseTaxName,
      "BPValue":BPValue,
      "ExciseTaxBefore":exciseTaxBefore,
      "IsAmountTaxAfter":isAmountTaxAfter,
      "IsAmountTaxBefore":isAmountTaxBefore,
      "IsExciseProduct":isExciseProduct,
      "ExciseTaxAfter":exciseTaxAfter,
      "ExciseTax":exciseTaxAmount.toString()
    };

    print(data);
    orderDetTable.clear();

    parsingJson.insert(0, data);

    setState(() {
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
    });

    totalAmount();
  }
/// update quantity
  updateQty(int val, int i) async {
    int indexChanging = i;
    quantity = double.parse(orderDetTable[indexChanging].quantity);
    if (val == 1) {
      quantity = quantity + 1.0;
    } else {
      quantity = quantity - 1.0;
    }

    detailID = orderDetTable[indexChanging].detailID;
    unitPriceAmountWR = orderDetTable[indexChanging].unitPrice;
    inclusiveUnitPriceAmountWR = orderDetTable[indexChanging].inclusivePrice;
    vatPer = double.parse(orderDetTable[indexChanging].vatPer);
    gstPer = double.parse(orderDetTable[indexChanging].gstPer);

    var uuid = orderDetTable[indexChanging].uniqueId;

    productName = orderDetTable[indexChanging].productName;
    item_status = orderDetTable[indexChanging].status;
    unitName = orderDetTable[indexChanging].unitPriceName;
    detailDescriptionController.text = orderDetTable[indexChanging].description;
    salesPrice = orderDetTable[indexChanging].salesPrice;
    purchasePrice = orderDetTable[indexChanging].costPerPrice;
    productID = orderDetTable[indexChanging].productId;
    isInclusive = orderDetTable[indexChanging].productInc;
    actualProductTaxName = orderDetTable[indexChanging].actualProductTaxName;
    actualProductTaxID = orderDetTable[indexChanging].actualProductTaxID;
    priceListID = orderDetTable[indexChanging].priceListId;

    var grossAmount;
    var unit;
    taxType = "None";
    taxID = 32;

    var discount;
    var inclusivePer = 0.0;
    var exclusivePer = 0.0;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var checkVat = prefs.getBool("checkVat") ?? false;
    var checkGst = prefs.getBool("check_GST") ?? false;
    var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
    var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

    if (checkVat == true) {
      taxType = "VAT";
      taxID = 32;

      if (isInclusive == true) {
        inclusivePer = inclusivePer + vatPer;
      } else {
        exclusivePer = exclusivePer + vatPer;
      }
    }
    if (checkGst == true) {
      taxType = "GST Intra-state B2C";
      taxID = 22;

      if (isInclusive == true) {
        inclusivePer = inclusivePer + gstPer;
      } else {
        exclusivePer = exclusivePer + gstPer;
      }
    }

    unit = double.parse(unitPriceAmountWR);

    discount = 0.0;
    percentageDiscount = 0;
    discountAmount = 0;


    exciseTaxAmount = 0.0;
    grossAmount = quantity * unit;
    if (isExciseProduct) {
      exciseTaxAmount = calculateExciseTax(
        breakEvenValue: double.parse(BPValue),
        greaterAmount: isAmountTaxAfter,
        greaterThanValue: double.parse(exciseTaxAfter),
        lessAmount: isAmountTaxBefore,
        lessThanValue: double.parse(exciseTaxBefore),
        price: grossAmount,
      );
    }
    grossAmountWR = "$grossAmount";
    taxableAmountPost = grossAmount - discount;
    vatAmount = ((taxableAmountPost+exciseTaxAmount) * vatPer / 100);

    gstAmount = (taxableAmountPost * gstPer / 100);
    var ga = roundDouble(gstAmount, priceDecimal);
    var va = roundDouble(vatAmount, priceDecimal);

    if (checkVat == false) {
      vatAmount = 0.0;
      print(vatAmount);
    }
    if (checkGst == false) {
      gstAmount = 0.0;
    }

    cGSTAmount = gstAmount / 2;
    sGSTAmount = gstAmount / 2;
    iGSTAmount = gstAmount;
    cGSTPer = gstPer / 2;
    iGSTPer = gstPer;
    sGSTPer = gstPer / 2;

    if (taxType == "Export") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
    } else if (taxType == "Import") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
      print('import');
    } else if (taxType == "GST Inter-state B2C") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      totalTax = iGSTAmount;
    } else if (taxType == "GST Inter-state B2B") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      totalTax = iGSTAmount;
    } else if (taxType == "GST Intra-state B2C") {
      iGSTAmount = 0.0;
      totalTax = cGSTAmount + cGSTAmount;
    } else if (taxType == "GST Intra-state B2B") {
      iGSTAmount = 0.0;
      totalTax = cGSTAmount + sGSTAmount;
    } else if (taxType == "None") {
      cGSTAmount = 0.0;
      sGSTAmount = 0.0;
      iGSTAmount = 0.0;
      vatAmount = 0.0;
      totalTax = 0.0;
      print(totalTax);
    } else if (taxType == "VAT") {
      totalTax = vatAmount+exciseTaxAmount;
    }

    netAmount = taxableAmountPost + totalTax;
    var singleTax = totalTax / quantity;
    rateWithTax = unit + singleTax;
    costPerPrice = purchasePrice;
    percentageDiscount = (discount * 100 / netAmount);
    discountAmount = discount;

    var tt = roundDouble(totalTax, priceDecimal);
    quantityRounded = roundDouble(quantity, qtyDecimal);
    netAmountRounded = roundDouble(netAmount, qtyDecimal);
    unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);

    Map data = {
      "ProductName": productName,
      "Status": item_status,
      "UnitName": unitName,
      "Qty": "$quantity",
      "ProductTaxName": productTaxName,
      "ProductTaxID": productTaxID,
      "SalesPrice": salesPrice,
      "ProductID": productID,
      "ActualProductTaxName": actualProductTaxName,
      "ActualProductTaxID": actualProductTaxID,
      "BranchID": 1,
      "SalesDetailsID": 1,
      "id": uuid,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR,
      "RateWithTax": "$rateWithTax",
      "CostPerPrice": costPerPrice,
      "PriceListID": priceListID,
      "DiscountPerc": discountPer,
      "DiscountAmount": "$discountAmount",
      "GrossAmount": "$grossAmount",
      "VATPerc": "$vatPer",
      "VATAmount": "$vatAmount",
      "NetAmount": "$netAmount",
      "detailID": detailID,
      "SGSTPerc": "$sGSTPer",
      "SGSTAmount": "$sGSTAmount",
      "CGSTPerc": "$cGSTPer",
      "CGSTAmount": "$cGSTAmount",
      "IGSTPerc": "$iGSTPer",
      "IGSTAmount": "$iGSTAmount",
      "CreatedUserID": createdUserID,
      "DataBase": dataBase,
      "flavour": flavourID,
      "Flavour_Name": flavourName,
      "TaxableAmount": "$taxableAmountPost",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "$gstPer",
      "is_inclusive": isInclusive,
      "unitPriceRounded": "$unitPriceRounded",
      "quantityRounded": "$quantityRounded",
      "netAmountRounded": "$netAmountRounded",
      "InclusivePrice": inclusiveUnitPriceAmountWR,
      "TotalTaxRounded": "$tt",
      "Description": detailDescriptionController.text,
      "ExciseTaxID":exciseTaxID,
      "ExciseTaxName":exciseTaxName,
      "BPValue":BPValue,
      "ExciseTaxBefore":exciseTaxBefore,
      "IsAmountTaxAfter":isAmountTaxAfter,
      "IsAmountTaxBefore":isAmountTaxBefore,
      "IsExciseProduct":isExciseProduct,
      "ExciseTaxAfter":exciseTaxAfter,
      "ExciseTax":exciseTaxAmount.toString()
    };
    print(data);
    parsingJson[indexChanging] = data;

    setState(() {
      orderDetTable.clear();
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
    });
    totalAmount();
  }

/// on edit data method
  calculationOnEditing(isQuantityButton) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print('----1');
      var grossAmount;
      var unit;
      taxType = "None";
      taxID = 32;

      var discount;
      var inclusivePer = 0.0;
      var exclusivePer = 0.0;

      var checkVat = prefs.getBool("checkVat") ?? false;
      var checkGst = prefs.getBool("check_GST") ?? false;
      var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
      var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
      print('----1');
      if (checkVat == true) {
        taxType = "VAT";
        taxID = 32;
        if (isInclusive == true) {
          inclusivePer = inclusivePer + vatPer;
        } else {
          exclusivePer = exclusivePer + vatPer;
        }
      }
      if (checkGst == true) {
        taxType = "GST Intra-state B2C";
        taxID = 22;
        if (isInclusive == true) {
          inclusivePer = inclusivePer + gstPer;
        } else {
          exclusivePer = exclusivePer + gstPer;
        }
      }
      print('-isQuantityButton--  $isQuantityButton');

      if (isQuantityButton) {
        unit = double.parse(orderDetTable[detailIdEdit].salesPrice);
      } else {
        unit = double.parse(unitPriceDetailController.text);
      }

      print("unit ---------$unit");
      if (inclusivePer == 0.0) {
        unitPriceAmountWR = (unit).toString();
        var taxAmount = (unit * exclusivePer) / 100;
        inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
        unit = unit;
      } else {
        var taxAmount = (unit * inclusivePer) / (100 + inclusivePer);
        print(taxAmount);
        unit = unit - taxAmount;
        inclusiveUnitPriceAmountWR = (unit + taxAmount).toString();
        unitPriceAmountWR = (unit).toString();
        print(unit);
      }
      print('----1');
      discount = 0.0;
      percentageDiscount = 0;
      discountAmount = 0;
      grossAmount = quantity * unit;

      exciseTaxAmount = 0.0;
      print("isExciseProduct  $isExciseProduct");
      if (isExciseProduct) {
        exciseTaxAmount = calculateExciseTax(
          breakEvenValue: double.parse(BPValue),
          greaterAmount: isAmountTaxAfter,
          greaterThanValue: double.parse(exciseTaxAfter),
          lessAmount: isAmountTaxBefore,
          lessThanValue: double.parse(exciseTaxBefore),
          price: grossAmount,
        );
      }
      grossAmountWR = "$grossAmount";
      taxableAmountPost = grossAmount - discount;
      vatAmount = ((taxableAmountPost+exciseTaxAmount) * vatPer / 100);

      gstAmount = (taxableAmountPost * gstPer / 100);
      print('----1');
      var ga = roundDouble(gstAmount, priceDecimal);
      var va = roundDouble(vatAmount, priceDecimal);

      if (checkVat == false) {
        vatAmount = 0.0;
        print(vatAmount);
      }
      if (checkGst == false) {
        gstAmount = 0.0;
      }

      cGSTAmount = gstAmount / 2;
      sGSTAmount = gstAmount / 2;
      iGSTAmount = gstAmount;
      cGSTPer = gstPer / 2;
      iGSTPer = gstPer;
      sGSTPer = gstPer / 2;

      if (taxType == "Export") {
        cGSTAmount = 0.0;
        sGSTAmount = 0.0;
        iGSTAmount = 0.0;
        vatAmount = 0.0;
        totalTax = 0.0;
      } else if (taxType == "Import") {
        cGSTAmount = 0.0;
        sGSTAmount = 0.0;
        iGSTAmount = 0.0;
        vatAmount = 0.0;
        totalTax = 0.0;
        print('import');
      } else if (taxType == "GST Inter-state B2C") {
        cGSTAmount = 0.0;
        sGSTAmount = 0.0;
        totalTax = iGSTAmount;
      } else if (taxType == "GST Inter-state B2B") {
        cGSTAmount = 0.0;
        sGSTAmount = 0.0;
        totalTax = iGSTAmount;
      } else if (taxType == "GST Intra-state B2C") {
        iGSTAmount = 0.0;
        totalTax = cGSTAmount + cGSTAmount;
      } else if (taxType == "GST Intra-state B2B") {
        iGSTAmount = 0.0;
        totalTax = cGSTAmount + sGSTAmount;
      } else if (taxType == "None") {
        cGSTAmount = 0.0;
        sGSTAmount = 0.0;
        iGSTAmount = 0.0;
        vatAmount = 0.0;
        totalTax = 0.0;
        print(totalTax);
      } else if (taxType == "VAT") {

        totalTax = vatAmount+exciseTaxAmount;
      }
      print('----1');
      netAmount = taxableAmountPost + totalTax;
      var singleTax = totalTax / quantity;
      rateWithTax = unit + singleTax;
      costPerPrice = purchasePrice;
      percentageDiscount = (discount * 100 / netAmount);
      discountAmount = discount;

      qtyDetailController.text = "$quantity";
      quantityRounded = roundDouble(quantity, qtyDecimal);
      netAmountRounded = roundDouble(netAmount, qtyDecimal);
      unitPriceRounded = roundDouble(unit.toDouble(), priceDecimal);

    });
  }
  addData() {
    Map data = {
      "ProductName": productName,
      "Status": item_status,
      "UnitName": unitName,
      "Qty": "$quantity",
      "ProductTaxName": productTaxName,
      "ProductTaxID": productTaxID,
      "SalesPrice": salesPrice,
      "ProductID": productID,
      "ActualProductTaxName": actualProductTaxName,
      "ActualProductTaxID": actualProductTaxID,
      "BranchID": 1,
      "SalesDetailsID": 1,
      "id": unique_id,
      "FreeQty": "0",
      "UnitPrice": unitPriceAmountWR,
      "RateWithTax": "$rateWithTax",
      "CostPerPrice": costPerPrice,
      "PriceListID": priceListID,
      "DiscountPerc": discountPer,
      "DiscountAmount": "$discountAmount",
      "GrossAmount": grossAmountWR,
      "VATPerc": "$vatPer",
      "VATAmount": "$vatAmount",
      "NetAmount": "$netAmount",
      "detailID": detailID,
      "SGSTPerc": "$sGSTPer",
      "SGSTAmount": "$sGSTAmount",
      "CGSTPerc": "$cGSTPer",
      "CGSTAmount": "$cGSTAmount",
      "IGSTPerc": "$iGSTPer",
      "IGSTAmount": "$iGSTAmount",
      "CreatedUserID": createdUserID,
      "DataBase": dataBase,
      "flavour": flavourID,
      "Flavour_Name": flavourName,
      "TaxableAmount": "$taxableAmountPost",
      "AddlDiscPerc": "0",
      "AddlDiscAmt": "0",
      "gstPer": "$gstPer",
      "is_inclusive": isInclusive,
      "unitPriceRounded": "$unitPriceRounded",
      "quantityRounded": "$quantityRounded",
      "netAmountRounded": "$netAmountRounded",
      "InclusivePrice": inclusiveUnitPriceAmountWR,
      "TotalTaxRounded": "$totalTax",
      "Description": detailDescriptionController.text,
      "ExciseTaxID":exciseTaxID,
      "ExciseTaxName":exciseTaxName,
      "BPValue":BPValue,
      "ExciseTaxBefore":exciseTaxBefore,
      "IsAmountTaxAfter":isAmountTaxAfter,
      "IsAmountTaxBefore":isAmountTaxBefore,
      "IsExciseProduct":isExciseProduct,
      "ExciseTaxAfter":exciseTaxAfter,
      "ExciseTax":exciseTaxAmount.toString()
    };
    log(" data $data");
    parsingJson[detailIdEdit] = data;
    setState(() {
      // selectedIndexFlavour = 1000;
      flavourID = "";
      flavourName = "";
      orderDetTable.clear();
      for (Map user in parsingJson) {
        orderDetTable.add(PassingDetails.fromJson(user));
      }
    });

    totalAmount();
  }

  checking(int proID) {
    for (var i = 0; i < orderDetTable.length; i++) {
      if (orderDetTable[i].priceListId == proID) {
        setState(() {
          tableIndex = i;
        });

        return true;
      }
    }
    return false;
  }

  var tableIndex = 0;
  var currencySymbol = "";



  calculateExciseTax(
      {required double price,
      required double breakEvenValue,
      required bool lessAmount,
      required bool greaterAmount,
      required double lessThanValue,
      required double greaterThanValue}) {
    // Define the threshold for tax rate change
    double exciseTaxAmount = 0.0;
    if (price >= breakEvenValue) {
      if (greaterAmount) {
        exciseTaxAmount = greaterThanValue;
      } else {
        exciseTaxAmount = (price * greaterThanValue / 100);
      }
    } else {
      if (lessAmount) {
        exciseTaxAmount = lessThanValue;
      } else {
        exciseTaxAmount = (price * lessThanValue / 100);
      }
    }

    print("----exciseTaxAmount-----$exciseTaxAmount");
    return exciseTaxAmount;
  }


  double totalNetP = 0;
  double totalTaxMP = 0;
  double totalGrossP = 0;
  double vatAmountTotalP = 0;
  double cGstAmountTotalP = 0;
  double sGstAmountTotalP = 0;
  double iGstAmountTotalP = 0;
  double exciseAmountTotalP = 0;

  totalAmount() {
    double totalNet = 0;
    double totalTaxM = 0;
    double totalDiscount = 0;
    double totalGross = 0;
    double vatAmountTotal = 0;
    double cGstAmountTotal = 0;
    double sGstAmountTotal = 0;
    double iGstAmountTotal = 0;
    double exciseTaxAmount = 0;
    double tax2AmountTotal = 0;
    double tax3AmountTotal = 0;
    for (var i = 0; i < orderDetTable.length; i++) {
      totalNet += double.parse(orderDetTable[i].netAmount);
      totalTaxM += double.parse(orderDetTable[i].totalTaxRounded);
      vatAmountTotal += double.parse(orderDetTable[i].vatAmount);
      cGstAmountTotal += double.parse(orderDetTable[i].cgsAmount);
      sGstAmountTotal += double.parse(orderDetTable[i].sgsAmount);
      iGstAmountTotal += double.parse(orderDetTable[i].igsAmount);
      totalGross += double.parse(orderDetTable[i].grossAmount);
      exciseTaxAmount += double.parse(orderDetTable[i].exciseTaxAmount);

    }
    setState(() {
      totalNetP = totalNet;
      totalTaxMP = totalTaxM;
      totalGrossP = totalGross;
      vatAmountTotalP = vatAmountTotal;
      cGstAmountTotalP = cGstAmountTotal;
      sGstAmountTotalP = sGstAmountTotal;
      iGstAmountTotalP = iGstAmountTotal;
      exciseAmountTotalP = exciseTaxAmount;
    });
  }

  postingData(isPayment) {
    var detailsList = [];

    print("=====================================================");
    print(orderDetTable.length);

    for (var i = 0; i < orderDetTable.length; i++) {
      var dictionary = {
        "detailID": orderDetTable[i].detailID,
        "Status": orderDetTable[i].status,
        "Qty": orderDetTable[i].quantity,
        "ProductID": orderDetTable[i].productId,
        "UnitPrice": orderDetTable[i].unitPrice,
        "RateWithTax": orderDetTable[i].rateWithTax,
        "PriceListID": orderDetTable[i].priceListId,
        "GrossAmount": orderDetTable[i].grossAmount,
        "TaxableAmount": orderDetTable[i].taxableAmount,
        "VATPerc": orderDetTable[i].vatPer,
        "VATAmount": orderDetTable[i].vatAmount,
        "SGSTPerc": orderDetTable[i].sgsPer,
        "SGSTAmount": orderDetTable[i].sgsAmount,
        "CGSTPerc": orderDetTable[i].cgsPer,
        "CGSTAmount": orderDetTable[i].cgsAmount,
        "IGSTPerc": orderDetTable[i].igsPer,
        "IGSTAmount": orderDetTable[i].igsAmount,
        "NetAmount": orderDetTable[i].netAmount,
        "InclusivePrice": orderDetTable[i].inclusivePrice,
        "Description": orderDetTable[i].description,
        "ProductTaxID": orderDetTable[i].productTaxID,
        "unq_id": orderDetTable[i].uniqueId,
        "Flavour": orderDetTable[i].flavourID,
        "ExciseTax": orderDetTable[i].exciseTaxAmount,
        "ExciseTaxID": orderDetTable[i].exciseTaxID,
        "FreeQty": "0",
        "DiscountPerc": "0",
        "DiscountAmount": "0",
        "TAX1Perc": "0",
        "TAX1Amount": "0",
        "TAX2Perc": "0",
        "TAX2Amount": "0",
        "TAX3Perc": "0",
        "TAX3Amount": "0",
        "KFCAmount": "0",
        "BatchCode": "0",
        "SerialNos": [],
      };

      print("=================================================================");
      print(i);
      print(dictionary);
      detailsList.add(dictionary);
    }

    if (widget.sectionType == "Edit") {
      updateSalesOrderRequest(detailsList, isPayment);
    } else {
      createSalesOrderRequest(detailsList, isPayment);
    }
  }

  var tokenNumber = "";

  /// create order
  Future<Null> createSalesOrderRequest(var detailsList, isPayment) async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {

        if (tokenNumber == "") {
          tokenNumber = "001";
        }

        HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String baseUrl = BaseUrl.baseUrl;

        var checkVat = prefs.getBool("checkVat") ?? false;
        var checkGst = prefs.getBool("check_GST") ?? false;
        var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
        var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";

        var taxTypeID = 31;
        if (checkVat == true) {
          taxTypeID = 32;
          taxType = "VAT";
        } else if (checkGst == true) {
          taxTypeID = 22;
          taxType = "GST Intra-state B2C";
        } else {
          taxTypeID = 31;
          taxType = "None";
        }

        var userID = prefs.getInt('user_id') ?? 0;
        var employeeID = prefs.getInt('employee_ID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var countryID = prefs.getString('Country') ?? 1;
        var stateID = prefs.getString('State') ?? 1;
        var printAfterOrder = prefs.getBool('print_after_order') ?? false;

        var dateTime = getDateWithHourCondition(DateTime.now(),1);
        print(dateTime);


        DateTime selectedDateAndTime = DateTime.now();
        String convertedDate = "$dateTime";
        dateOnly = convertedDate.substring(0, 10);
        var orderTime = "$selectedDateAndTime";
//a function for flutter that return data, with condition that hour is parameter of function
        // if passing hour is 2 then check the time , if time is greater than 2 am , then return current date till 2 am befor 2 am date return previous day,
        print("__________________________________$orderTime");

        var type = "Dining";
        var customerName = "walk in customer";
        var phoneNumber = "";
        var time = "";

        if (widget.orderType == 1) {
          type = "Dining";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else if (widget.orderType == 2) {
          type = "TakeAway";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        }
        // ignore: unrelated_type_equality_checks
        else if (widget.orderType == 3) {
          type = "Online";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;

          time = "";
        } else if (widget.orderType == 4) {
          type = "Car";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else {}


        final String url = '$baseUrl/posholds/create-pos/salesOrder/';

        Map data = {
          "Table": widget.tableID,
          "EmployeeID": employeeID,
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "OrderTime": orderTime,
          "Date": dateOnly,
          "DeliveryDate": dateOnly,
          "TotalTax": "$totalTaxMP",
          "NetTotal": "$totalNetP",
          "GrandTotal": "$totalNetP",
          "TotalGrossAmt": "$totalGrossP",
          "TaxType": taxType,
          "TaxID": taxTypeID,
          "VATAmount": "$vatAmountTotalP",
          "SGSTAmount": "$sGstAmountTotalP",
          "CGSTAmount": "$cGstAmountTotalP",
          "IGSTAmount": "$iGstAmountTotalP",
          "ExciseTaxAmount": "$exciseAmountTotalP",
          "Type": type,
          "LedgerID": ledgerID,
          "CustomerName": customerName,
          "Country_of_Supply": countryID,
          "State_of_Supply": stateID,
          "VAT_Treatment": "1",
          "TokenNumber": tokenNumber,
          "Phone": phoneNumber,
          "saleOrdersDetails": detailsList,
          "VoucherNo": "",
          "BillDiscAmt": "0",
          "BillDiscPercent": "0",
          "DeliveryTime": "",
          "GST_Treatment": "",
          "Address1": "",
          "Address2": "",
          "Notes": "",
          "PriceCategoryID": 1,
          "FinacialYearID": 1,
          "TAX1Amount": "0",
          "TAX2Amount": "0",
          "TAX3Amount": "0",
          "ShippingCharge": "0",
          "shipping_tax_amount": "0",
          "TaxTypeID": "",
          "SAC": "",
          "SalesTax": "0",
          "RoundOff": "0",
          "IsActive": true,
          "IsInvoiced": "N",
        };
        log_data(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);
        if (status == 6000) {
          stop();
          var id = n["OrderID"];



          Navigator.pop(context, [widget.orderType, isPayment, id, widget.tableID, widget.tableHead]);

          if(printAfterOrder){

            PrintDataDetails.type = "SO";
            PrintDataDetails.id = n["OrderID"];
            await printDetail(context);
          }



         // dialogBoxHide(context, 'Order created successfully !!!');

          Future.delayed(const Duration(seconds: 1), () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var kot = prefs.getBool("KOT") ?? false;
            if (kot == true) {
              PrintDataDetails.type = "SO";
              PrintDataDetails.id = id;
              printKOT(id, false, [], false);
            } else {}
          });


        } else if (status == 6001) {
          stop();
          var errorMessage = n["message"];
          dialogBox(context, errorMessage);
        } else if (status == 6003) {
          stop();
          dialogBox(context, "Change token number and retry please");
          tokenNumberController.text = "$tokenNumber";

          changeQtyTextField(context);
        }

        //DB Error
        else {
          stop();
          dialogBox(context, "Please try again later");
        }
      } catch (e) {
        stop();
        dialogBox(context, e.toString());
      }
    }
  }

  DateTime getDateWithHourCondition(DateTime date, int hour) {

    // Ensure the hour is within valid range (0 to 23)
    if (hour < 0 || hour > 23) {
      throw ArgumentError('Hour must be between 0 and 23');
    }

    DateTime specifiedTime = DateTime(date.year, date.month, date.day, hour);

    if (date.isAfter(specifiedTime)) {
      // If current time is after the specified hour, return the current date
      return DateTime(date.year, date.month, date.day);
    } else {
      // If current time is before the specified hour, return the previous day
      DateTime previousDay = date.subtract(Duration(days: 1));
      return DateTime(previousDay.year, previousDay.month, previousDay.day);
    }
  }

  changeQtyTextField(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xffEAF0F1),
            content: Container(
              height: MediaQuery.of(context).size.height / 7,
              width: 250,
              decoration: BoxDecoration(
                  color: const Color(0xffEAF0F1),
                  border: Border.all(
                    color: const Color(0xffEAF0F1),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(1))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.height / 20,
                        child: TextField(
                          //  textAlignVertical: TextAlignVertical.center,
                          controller: tokenNumberController,

                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9-.]')),
                          ],
                          onTap: () =>
                              tokenNumberController.selection = TextSelection(baseOffset: 0, extentOffset: tokenNumberController.value.text.length),

                          style: const TextStyle(fontSize: 12, color: Color(0xff000000)),
                          decoration: CommonStyleTextField.textFieldStyle(labelTextStr: "Token Number", hintTextStr: "Token Number"),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          var value = "001";
                          if (tokenNumberController.text == "") {
                            value = "001";
                          } else {
                            value = tokenNumberController.text;
                          }

                          setState(() {
                            tokenNumber = tokenNumberController.text;
                          });

                          Navigator.pop(context);
                        },
                        child: Text(
                          'Update',
                          style: customisedStyle(context, Colors.white, FontWeight.w500, 12.0),
                        ),
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff10c103),
                            textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// update order
  Future<Null> updateSalesOrderRequest(detailsList, isPayment) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      dialogBox(context, "Check your network connection");
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;

        var checkVat = prefs.getBool("checkVat") ?? false;
        var checkGst = prefs.getBool("check_GST") ?? false;
        var priceDecimal = prefs.getString("PriceDecimalPoint") ?? "2";
        var qtyDecimal = prefs.getString("QtyDecimalPoint") ?? "2";
        var employeeID = prefs.getInt('employee_ID') ?? 1;

        var taxTypeID;
        if (checkVat == true) {
          taxTypeID = 32;
          taxType = "VAT";
        } else if (checkGst == true) {
          taxTypeID = 22;
          taxType = "GST Intra-state B2C";
        } else {
          taxTypeID = 31;
          taxType = "None";
        }

        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var countryID = prefs.getString('Country') ?? 1;
        var stateID = prefs.getString('State') ?? 1;
        var printAfterOrder = prefs.getBool('print_after_order') ?? false;

        DateTime selectedDateAndTime = DateTime.now();
        String convertedDate = "$selectedDateAndTime";
        dateOnly = convertedDate.substring(0, 10);
        var customerName = "walk in customer";
        var phoneNumber = "";
        var time = "";
        var type = "Dining";
        if (widget.orderType == 1) {
          type = "Dining";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else if (widget.orderType == 2) {
          type = "TakeAway";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else if (widget.orderType == 3) {
          type = "Online";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else if (widget.orderType == 4) {
          type = "Car";
          customerName = customerNameController.text;
          phoneNumber = phoneNumberController.text;
          time = "";
        } else {}

        final String url = '$baseUrl/posholds/edit/pos-sales-order/${widget.UUID}/';
        print(url);
        Map data = {
          "EmployeeID": employeeID,
          "LedgerID": ledgerID,
          "deleted_data": deletedList,
          "Table": widget.tableID,
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "Date": dateOnly,
          "DeliveryDate": dateOnly,
          "TotalGrossAmt": totalGrossP,
          "TotalTax": "$totalTaxMP",
          "NetTotal": "$totalNetP",
          "GrandTotal": "$totalNetP",
          "TaxID": taxTypeID,
          "TaxType": taxType,
          "VATAmount": "$vatAmountTotalP",
          "SGSTAmount": "$sGstAmountTotalP",
          "CGSTAmount": "$cGstAmountTotalP",
          "IGSTAmount": "$iGstAmountTotalP",
          "saleOrdersDetails": detailsList,
          "Country_of_Supply": countryID,
          "State_of_Supply": stateID,
          "CustomerName": customerName,
          "Phone": phoneNumber,
          "ExciseTaxAmount": "$exciseAmountTotalP",
          "VoucherNo": "",
          "BillDiscAmt": "0",
          "BillDiscPercent": "0",
          "RoundOff": "0",
          "IsActive": true,
          "IsInvoiced": "N",
          "PriceCategoryID": 1,
          "FinacialYearID": 1,
          "TAX1Amount": "0",
          "TAX2Amount": "0",
          "TAX3Amount": "0",
          "ShippingCharge": "0",
          "shipping_tax_amount": "0",
          "TaxTypeID": "",
          "SAC": "",
          "SalesTax": "0",
          "Address1": "",
          "Address2": "",
          "Notes": "",
          "GST_Treatment": "",
          "DeliveryTime": "",
        };
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        var cancelPrint = n["final_data"] ?? [];

        print("Cancel print -----------Cancel print-----Cancel print--$cancelPrint");



        if (status == 6000) {
          stop();
          var id = n["OrderID"];
          Navigator.pop(context, [widget.orderType, isPayment, id, widget.tableID, widget.tableHead]);

          if(printAfterOrder){
            PrintDataDetails.type = "SO";
            PrintDataDetails.id = id;
            await printDetail(context);
          }

          // dialogBoxHide(context, 'Order updated successfully !!!');

          Future.delayed(const Duration(seconds: 1), () async {
            print("-------id-------");
            print(id);
            print("-------id-------");

            /// kot section
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var kot = prefs.getBool("KOT") ?? false;

            if (kot == true) {
              PrintDataDetails.type = "SO";
              PrintDataDetails.id = id;
              printKOT(id, false, cancelPrint, true);
            } else {}
          });
        } else if (status == 6001) {
          stop();
          var errorMessage = n["message"]??"";
          dialogBox(context, errorMessage);
        }

        //DB Error
        else {
          stop();
          dialogBox(context, "Some network error");
        }
      } catch (e) {
        stop();
        dialogBox(context, "Some network error");
      }
    }
  }

  Widget orderTypeDetailScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: mainPageIndexIcon == 1 ? Colors.black : Colors.transparent,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: mainPageIndexIcon ==1?Colors.white:Color(0xffE8E8E8),
          ),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/svg/dining.svg',
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Dining'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 11.0),
        ),
        const SizedBox(
          height: 15,
        ),

        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: mainPageIndexIcon == 2 ? Colors.black : Colors.transparent,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: mainPageIndexIcon ==2?Colors.white:Color(0xffE8E8E8),
            ),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svg/takeaway.svg'),
            )),
        const SizedBox(height: 3),
        Text(
          'Take_awy'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 11.0),
        ),
        // const SizedBox(
        //   height: 6,
        // ),
        // Container(
        //     decoration: BoxDecoration(
        //       border: Border.all(
        //         color: borderColor3,
        //         width: 1,
        //       ),
        //       borderRadius: const BorderRadius.all(
        //         Radius.circular(10),
        //       ),
        //       color: color3,
        //     ),
        //     child: IconButton(
        //       onPressed: () {
        //
        //       },
        //       icon: SvgPicture.asset('assets/svg/online.svg'),
        //     )),
        // const SizedBox(height: 3),
        // Text(
        //   'Online',
        //   style: customisedStyle(context, Colors.black, FontWeight.w600, 12.0),
        // ),
        const SizedBox(
          height: 15,
        ),
        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: mainPageIndexIcon == 4 ? Colors.black : Colors.transparent,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: mainPageIndexIcon ==4?Colors.white:Color(0xffE8E8E8),

            ),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset('assets/svg/car.svg'),
            )),
        const SizedBox(height: 3),
        Text(
          'Car'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 11.0),
        ),
      ],
    );
  }

  Future<void> displayLoyaltyListBox(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xffffffff),
            content: Container(
                width: MediaQuery.of(context).size.width / 3.7,
                height: MediaQuery.of(context).size.height / 2.1,
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                          //    width: MediaQuery.of(context).size.width / 5,
                          height: MediaQuery.of(context).size.height / 18,
                          child: const Text(
                            'Loyalty Customer',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 7,
                          child: const Text(
                            "Phone",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  charLength = text.length;

                                  _searchLoyaltyCustomer(text);
                                });
                              },
                              controller: loyaltyPhoneNumber,
                              focusNode: loyaltyPhoneFcNode,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      loyaltyPhoneNumber.clear();
                                      loyaltyCustLists.clear();
                                      pageNumber = 1;
                                      firstTime = 1;
                                      getLoyaltyCustomer();
                                    },
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                                  disabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xffC9C9C9))),
                                  contentPadding: const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                                  filled: true,
                                  hintStyle: const TextStyle(color: Color(0xff000000), fontSize: 14),
                                  hintText: 'search'.tr,
                                  fillColor: const Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                        // color: Color(0xffF5F5F5),

                        height: MediaQuery.of(context).size.height / 3,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: loyaltyCustLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: const Color(0xffF5F5F5),
                                child: ListTile(
                                    onTap: () {
                                      loyaltyCustomerID = loyaltyCustLists[index].loyaltyCustomerID;
                                      Navigator.pop(context);

                                      /// 123123      PaymentData.ledgerID=  loyaltyCustLists[index].
                                    },
                                    tileColor: const Color(0xffF5F5F5),
                                    trailing: const Icon(Icons.circle_rounded, color: Color(0xff008015)),
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Name',
                                              style: TextStyle(color: Color(0xff777777), fontSize: 10),
                                            ),
                                            Text(
                                              loyaltyCustLists[index].customerName,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'phone'.tr,
                                              style: const TextStyle(color: Color(0xff777777), fontSize: 10),
                                            ),
                                            Text(
                                              loyaltyCustLists[index].phone,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        // Text(taxLists[index].type),
                                      ],
                                    )),
                              );
                            })),

                    /// hide button cancel and done
                    Container(
                      height: MediaQuery.of(context).size.height / 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 17,
                            width: MediaQuery.of(context).size.width / 8,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                foregroundColor: const Color(0xffFF0000),
                              ),
                              child: Text(
                                'cancel'.tr,
                                style: const TextStyle(color: Color(0xffFFFFFF)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 17,
                            width: MediaQuery.of(context).size.width / 8,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  foregroundColor: const Color(0xff12AA07),
                                ),
                                child: const Text(
                                  'Done',
                                  style: TextStyle(color: Color(0xffFFFFFF)),
                                ),
                                onPressed: () {}),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          );
        });
  }

  ///list loylty customer

  ///loyalty create alert box
  Future<void> displayLoyalityAlertBox(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xffEAF0F1),
              content: Container(
                  width: MediaQuery.of(context).size.width / 3.7,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: ListView(
                    children: [
                      loyaltyNameField(),

                      /// commented customer selection (waiting api changes)
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       width: MediaQuery.of(context).size.width / 7,
                      //       child: const Text(
                      //         "Customer:",
                      //         style: TextStyle(fontSize: 15),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: MediaQuery.of(context).size.width / 3.5,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(bottom: 10),
                      //         child: TextField(
                      //           readOnly: true,
                      //           onTap: () async {
                      //
                      //             var result = await Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) => SelectCustomer()),
                      //             );
                      //
                      //             print(result);
                      //
                      //             if (result != null) {
                      //               setState(() {
                      //                 loyaltyCustomerNameController.text =
                      //                     result;
                      //               });
                      //             } else {}
                      //           },
                      //           controller: loyaltyCustomerNameController,
                      //           //  focusNode: customerFcNode,
                      //           onEditingComplete: () {
                      //             FocusScope.of(context)
                      //                 .requestFocus(phoneFcNode);
                      //           },
                      //           keyboardType: TextInputType.text,
                      //           textCapitalization: TextCapitalization.words,
                      //           decoration:
                      //               TextFieldDecoration.rectangleTextField(
                      //                   hintTextStr: ''),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      loyaltyPhoneNumberField(),
                      loyaltyLocationField(),
                      loyaltyCardTypeField(),
                      loyaltyCardNumberField(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text('Status'.tr),
                            ),
                            FlutterSwitch(
                              width: 40.0,

                              height: 20.0,

                              valueFontSize: 30.0,

                              toggleSize: 15.0,

                              value: loyaltyStatus,

                              borderRadius: 20.0,

                              padding: 1.0,

                              activeColor: const Color(0xff009253),

                              inactiveToggleColor: const Color(0xff606060),

                              inactiveColor: const Color(0xffDEDEDE),

                              // showOnOff: true,

                              onToggle: (val) {
                                setState(() {
                                  loyaltyStatus = val;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      loyaltyCancelAndSaveButton()
                    ],
                  )),
            );
          });
        });
  }

  Widget loyaltyNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
            'name'.tr,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: nameController,
              focusNode: nameFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(phoneFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget loyaltyPhoneNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
            'phone1'.tr,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: loyaltyPhoneController,
              focusNode: phoneFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(locationFcNode);
              },
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget loyaltyLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
            'loc'.tr,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: loyaltyLocationController,
              focusNode: locationFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(cardTypeFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget loyaltyCardTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
            'card_type'.tr,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelectCardType()),
                );

                print(result);

                if (result != null) {
                  setState(() {
                    loyltyCardTypeController.text = result;
                  });
                } else {}
              },
              controller: loyltyCardTypeController,
              focusNode: cardTypeFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(cardNoFcNode);
              },
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget loyaltyCardNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 7,
          child: Text(
            'card_no'.tr,
            style: const TextStyle(fontSize: 15),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: loyaltyCardNumberController,
              focusNode: cardNoFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(saveFcNode);
              },
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              decoration: TextFieldDecoration.rectangleTextField(hintTextStr: ''),
            ),
          ),
        ),
      ],
    );
  }

  Widget loyaltyCancelAndSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 18,
          width: MediaQuery.of(context).size.width / 8,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              foregroundColor: const Color(0xffFF0000),
            ),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: Color(0xffFFFFFF)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 18,
          width: MediaQuery.of(context).size.width / 8,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                foregroundColor: const Color(0xff12AA07),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xffFFFFFF)),
              ),
              onPressed: () {
                if (nameController.text == '' || loyaltyPhoneController.text == '') {
                  dialogBox(context, 'Please fill mandatory field');
                } else {
                  createLoyaltyCustomer();
                }
              }),
        )
      ],
    );
  }

  ///Api for create loyalty
  Future<Null> createLoyaltyCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        start(context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        String baseUrl = BaseUrl.baseUrl;

        final String url = '$baseUrl/posholds/rassassy/create_loyality_customer/';
        String loyaltyType = "";
        loyaltyStatus == true ? loyaltyType = "true" : loyaltyType = "false";
        print(loyaltyType);
        print('1111111111111111');
        print(url);

        ///card type,stats,status name
        Map data = {
          "CompanyID": companyID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "Phone": loyaltyPhoneController.text,
          "Name": nameController.text,
          "Location": loyaltyLocationController.text,
          "CardTypeName": loyltyCardTypeController.text,
          "CardNumber": loyaltyCardNumberController.text,
          "CardTypeID": "",
          "CardStatusID": "",
          "CardStatusName": loyaltyType
        };
        print(data);

        //encode Map to JSON
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        print(response.statusCode);
        print(response.body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];

        if (status == 6000) {
          setState(() {
            getLoyaltyCustomer();

            loyltyCardTypeController.clear();
            loyaltyCardNumberController.clear();
            nameController.clear();
            loyaltyPhoneController.clear();
            loyaltyLocationController.clear();
            stop();
            isAddLoyalty = false;

            Navigator.pop(context);
            // getLoyaltyCustomer();
          });
        } else if (status == 6001) {
          stop();
        } else {}
      } catch (e) {
        dialogBox(context, "Some thing went wrong");
        stop();
      }
    }
  }

  ///list loyalty customer
  Future<Null> getLoyaltyCustomer() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        final String url = '$baseUrl/posholds/rassassy/list_loyality_customer/';

        Map data = {
          "CompanyID": companyID,
          "BranchID": branchID,
          "CreatedUserID": userID,
        };

        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        if (status == 6000) {
          setState(() {
            loyaltyCustLists.clear();

            stop();
            for (Map user in responseJson) {
              loyaltyCustLists.add(LoyaltyCustomerModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }

  ///search customer

  Future _searchLoyaltyCustomer(string) async {
    if (string == '') {
      pageNumber = 1;
      loyaltyCustLists.clear();
      firstTime = 1;
      getLoyaltyCustomer();
    } else if (string.length > 2) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(context, "Unable to connect. Please Check Internet Connection");
      } else {
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var userID = prefs.getInt('user_id') ?? 0;
          var accessToken = prefs.getString('access') ?? '';
          var companyID = prefs.getString('companyID') ?? 0;
          var branchID = prefs.getInt('branchID') ?? 1;

          Map data = {
            "SearchVal": loyaltyPhoneNumber.text,
            "CompanyID": companyID,
            "BranchID": branchID,
          };
          String baseUrl = BaseUrl.baseUrl;
          final String url = "$baseUrl/posholds/rassassy/search_loyality_customer/";
          print(data);
          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $accessToken',
              },
              body: body);
          print("${response.statusCode}");
          print("${response.body}");
          Map n = json.decode(utf8.decode(response.bodyBytes));
          var status = n["StatusCode"];
          var responseJson = n["data"];
          print(responseJson);
          if (status == 6000) {
            loyaltyCustLists.clear();

            setState(() {
              netWorkProblem = true;
              loyaltyCustLists.clear();
              isLoading = false;
            });

            setState(() {
              for (Map user in responseJson) {
                loyaltyCustLists.add(LoyaltyCustomerModel.fromJson(user));
              }
            });
          } else if (status == 6001) {
            setState(() {
              netWorkProblem = true;
              isLoading = false;
            });

            dialogBox(context, "");
          } else {
            dialogBox(context, "Some Network Error please try again Later");
          }
        } catch (e) {
          setState(() {
            netWorkProblem = false;
            isLoading = false;
          });

          print(e);
        }
      }

      /// call function
      return;
    } else {}
  }

  /// commented flavour create option
//   Future<void> _createFlavour(BuildContext context) async {
//     return showDialog(
//         barrierDismissible: true,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             backgroundColor: Color(0xffEAF0F1),
//             content: Container(
//               height: MediaQuery.of(context).size.height / 12,
//               decoration: BoxDecoration(
//                   color: Color(0xffEAF0F1),
//                   border: Border.all(
//                     color: Color(0xffEAF0F1),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(1))),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: Container(
//                         //    width: MediaQuery.of(context).size.width / 5,
//                         //  height: MediaQuery.of(context).size.height / 18,
//                         child: TextField(
//                       //  textAlignVertical: TextAlignVertical.center,
//                       controller: flavourNameController,
//                       focusNode: nameNode,
//                       onEditingComplete: () {
//                         FocusScope.of(context).requestFocus(phoneNode);
//                       },
//                       style: const TextStyle(
//                           fontSize: 12, color: Color(0xff000000)),
//                       decoration: CommonStyleTextField.textFieldStyle(
//                           labelTextStr: "Flavour name",
//                           hintTextStr: "Flavour name"),
//                     )),
//                   ),
//                 ],
//               ),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 focusNode: okAlertButton,
//                 onPressed: () {
//                   if (flavourNameController.text == "") {
//                     Navigator.pop(context);
//                     dialogBox(context, "Please enter flavour");
//                   } else {
//                     createFlavourApi();
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: const [
//                     Text(
//                       'Save',
//                     ),
//                   ],
//                 ),
//                 style: TextButton.styleFrom(
//                     primary: Colors.white,
//                     backgroundColor: const Color(0xff10c103),
//                     textStyle: const TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.bold)),
//               )
//             ],
//           );
//         });
//   }

  Future<Null> getAllFlavours() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? "0";
        var userID = prefs.getInt('user_id') ?? 0;
         var branchID = prefs.getInt('branchID') ?? 1;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/flavours/flavours/';
        print(url);
        Map data = {"CompanyID": companyID, "BranchID": branchID, "CreatedUserID": userID};
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(responseJson);
        print(status);
        if (status == 6000) {
          setState(() {
            flavourList.clear();
            stop();
            for (Map user in responseJson) {
              flavourList.add(FlavourListModel.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"]??"";
          dialogBox(context, msg);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        setState(() {
          stop();
        });
      }
    }
  }



  Future<Null> getCategoryListDetail() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
         user_name = prefs.getString('user_name')!;
         autoFocusField = prefs.getBool('autoFocusField') ?? false;

        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/pos/product-group/list/';
        print(accessToken);
        print(url);
        DateTime selectedDateAndTime = DateTime.now();
        String convertedDate = "$selectedDateAndTime";
        var dateOnly = convertedDate.substring(0, 10);
        Map data = {"CompanyID": companyID, "BranchID": branchID, "Date": dateOnly};
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        if (status == 6000) {
          setState(() {
            categoryList.clear();
            stop();

            for (Map user in responseJson) {
              categoryList.add(CategoryListModel.fromJson(user));
            }

            if (widget.sectionType != "Edit") {
              tokenNumber = n["TokenNumber"];
              }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["error"]??"";
          dialogBox(context, msg);
        }
        //DB Error
        else {

          var msg = n["error"]??"";
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        print("${e.toString()}");
        dialogBox(context, e.toString());
        stop();
      }
    }
  }

  Future<Null> getProductListDetails(groupId) async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();

        String baseUrl = BaseUrl.baseUrl;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var companyID = prefs.getString('companyID') ?? '';
         var branchID = prefs.getInt('branchID') ?? 1;
        var priceRounding = BaseUrl.priceRounding;
        var accessToken = prefs.getString('access') ?? '';
        final String url = '$baseUrl/posholds/pos-product-list/';
        print(url);
        var type = "";
        if (veg) {
          type = "veg";
        }

        Map data = {"CompanyID": companyID, "BranchID": branchID, "GroupID": groupId, "type": type, "PriceRounding": priceRounding};
        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        print(accessToken);
        var status = n["StatusCode"];
        var responseJson = n["data"];
        print(status);
        print(responseJson);
        if (status == 6000) {
          setState(() {
            stop();
            for (Map user in responseJson) {
              productList.add(ProductListModelDetail.fromJson(user));
            }
          });
        } else if (status == 6001) {
          stop();
          var msg = n["message"]??"";
          dialogBox(context, msg);
        } else {
          var msg = n["message"]??"";
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        print(e.toString());
        dialogBox(context, e.toString());
        stop();
      }
    }
  }

  /// search item
  Future _searchData(String string) async {
    if (string == '') {
      setState(() {
        productList.clear();
      });
    } else {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        dialogBox(context, "Unable To Connect Please Check Internet Connection");
      } else {
        try {
          HttpOverrides.global = new MyHttpOverrides();
          productList.clear();
          String baseUrl = BaseUrl.baseUrl;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var companyID = prefs.getString('companyID') ?? '';
           var branchID = prefs.getInt('branchID') ?? 1;
          var priceRounding = BaseUrl.priceRounding;
          var userID = prefs.getInt('user_id') ?? 0;
          var accessToken = prefs.getString('access') ?? '';
          final String url = '$baseUrl/posholds/products-search-pos/';
          print(url);
          var type = "";
          if (veg) {
            type = "veg";
          }
          Map data = {
            "IsCode": productSearchNotifier.value == 1 ? true : false,
            "IsDescription": productSearchNotifier.value == 3 ? true : false,
            "BranchID": branchID,
            "CompanyID": companyID,
            "CreatedUserID": userID,
            "PriceRounding": priceRounding,
            "product_name": string,
            "length": string.length,
            "type": type,
          };
          print(url);
          print(data);
          var body = json.encode(data);
          var response = await http.post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Bearer $accessToken',
              },
              body: body);
          print("${response.statusCode}");
          print("${response.body}");
          Map n = json.decode(utf8.decode(response.bodyBytes));
          var status = n["StatusCode"];
          var responseJson = n["data"];

          print(responseJson);
          if (status == 6000) {
            productList.clear();
            setState(() {
              stop();
              for (Map user in responseJson) {
                productList.add(ProductListModelDetail.fromJson(user));
              }
            });

          } else if (status == 6001) {
            stop();
          } else {}
        } catch (e) {
          print(e);
        }
      }

      /// call function
      return;
    }
  }

  String roundStringWith(String val) {
    var decimal = 2;
    double convertedTodDouble = double.parse(val);
    var number = convertedTodDouble.toStringAsFixed(decimal);
    return number;
  }

  var billDiscPercent = 0.0;
  var totalDiscount;
  var netTotal = "0.00";
  var grandTotalAmount = "0.00";
  var totalTaxP = "0.00";
  var date;
  var roundOff;
  var balance = 0.0;
  var allowCashReceiptMoreSaleAmt = false;
  var disCount = 0.0;
  var cashReceived = 0.0;
  var bankReceived = 0.0;

  calculationOnPayment() {
    var net = double.parse(netTotal);
    print(net);
    if (discountAmountController.text == "") {
      print("1");
      disCount = 0.0;
    } else {
      print("2");
      disCount = double.parse(discountAmountController.text);
    }
    print(disCount);
    if (cashReceivedController.text == "") {
      cashReceived = 0.0;
    } else {
      cashReceived = double.parse(cashReceivedController.text);
    }

    if (bankReceivedController.text == "") {
      bankReceived = 0.0;
    } else {
      bankReceived = double.parse(bankReceivedController.text);
    }
    setState(() {
      var gt = (net - disCount).toString();
      grandTotalAmount = roundStringWith(gt).toString();
      billDiscPercent = (disCount * 100 / double.parse(grandTotalAmount));
      balance = (net - disCount) - (cashReceived + bankReceived);
      //  balanceCalculation();
    });
  }

  checkNan(value) {
    var val = value;
    if (value.isNaN) {
      return 0.0;
    } else {
      var val2 = val;
      return val2;
    }
  }

  findTaxableAmount() {
    print("=================Tax Type change Data ================");
    print(taxType);

    if (itemListPayment.isEmpty) {
    } else {
      double totalTaxableAmount = 0.0;
      double totalNonTaxableAmount = 0.0;
      for (var i = 0; i < itemListPayment.length; i++) {
        var tax = double.parse(itemListPayment[i].vatAmount);
        if (tax > 0) {
          totalTaxableAmount += double.parse(itemListPayment[i].taxableAmount);
        } else {
          totalNonTaxableAmount += double.parse(itemListPayment[i].taxableAmount);
        }
      }
      var list = [totalTaxableAmount, totalNonTaxableAmount];
      return list;
    }
  }

  findTotalGrossAmount() {
    if (itemListPayment.isEmpty) {

    }
    else {
      double grossAmount = 0.0;

      for (var i = 0; i < itemListPayment.length; i++) {
        grossAmount += double.parse(itemListPayment[i].grossAmount);
      }

      return grossAmount;
    }
  }

  getVatChangedDetails(int i, val) async {
    var net = double.parse(netTotal);
    //  var totalTax = double.parse(totalTaxP);
    if (i == 1) {
      billDiscPercent = double.parse(val);
      disCount = (net * billDiscPercent / 100);
      setState(() {
        var gt = (net - disCount).toString();
        grandTotalAmount = roundStringWith(gt).toString();
        discountAmountController.text = roundStringWith(disCount.toString());
      });
    }

    if (i == 2) {
      disCount = double.parse(val);
      billDiscPercent = (disCount * 100 / net);
      setState(() {
        var gt = (net - disCount).toString();
        grandTotalAmount = roundStringWith(gt).toString();
        discountPerController.text = roundStringWith(billDiscPercent.toString());
      });
    }

    var list = await findTaxableAmount();

    var taxTaxableAmount = (list[0]);
    var nonTaxTaxableAmount = list[1];

    print("-------------------------------");
    print(taxTaxableAmount);
    print(nonTaxTaxableAmount);
    print(disCount);
    print("-------------------------------");

    double taxSum = 0.0;
    if (taxTaxableAmount >= disCount) {
      var vatTax = (disCount / taxTaxableAmount) * 100;

      vatTax = checkNan(vatTax);

      print("--------------");
      print(vatTax);
      print("--------------");
      for (var i = 0; i < itemListPayment.length; i++) {
        var txAmt = (double.parse(itemListPayment[i].taxableAmount) * vatTax) / 100;
        var newTaxable = double.parse(itemListPayment[i].taxableAmount) - txAmt;
        taxSum += ((newTaxable) * double.parse(itemListPayment[i].vatPer)) / 100;
      }
    } else {
      taxSum = 0.0;
    }

    double gross = await findTotalGrossAmount();
    var gt = gross - disCount + taxSum;

    print("+++++++++++++++++++++++++++++++++");
    print(gross);
    print("++++++++-++++++++++++++++-++++++++");

    setState(() {
      totalTaxP = "$taxSum";
      grandTotalAmount = "$gt";
      //  balanceCalculation();
    });
  }

  // balanceCalculation() {
  //   var gt = double.parse(grandTotalAmount);
  //   setState(() {
  //     balance = gt - cashReceived - bankReceived;
  //   });
  // }

  discountCalc(int i, val) {
    var net = double.parse(netTotal);
    print(net);

    if (i == 1) {
      billDiscPercent = double.parse(val);
      disCount = (net * billDiscPercent / 100);
      setState(() {
        var gt = (net - disCount).toString();
        grandTotalAmount = roundStringWith(gt).toString();
        discountAmountController.text = roundStringWith(disCount.toString());
      });
    }

    if (i == 2) {
      disCount = double.parse(val);
      billDiscPercent = (disCount * 100 / net);
      setState(() {
        var gt = (net - disCount).toString();
        grandTotalAmount = roundStringWith(gt).toString();
        discountPerController.text = roundStringWith(billDiscPercent.toString());
      });
    }

    setState(() {
      balance = (net - disCount) - (cashReceived + bankReceived);

      // balanceCalculation();
    });
  }

  checkBank(String value) {
    print(value);
    var bankAmount = value;
    var amount = double.parse(value);
    var grandT = double.parse(grandTotalAmount);

    if (amount > grandT) {
      bankReceived = 0.0;
      bankReceivedController.text = "0";
      dialogBox(context, "Amount less than grand total");
      return false;
    } else {
      return true;
    }
  }

  /// create invoice
  Future<Null> createSaleInvoice(print_save, BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      stop();
    } else {
      try {
        start(context);
        HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrl;
        var userID = prefs.getInt('user_id') ?? 0;
        var accessToken = prefs.getString('access') ?? '';
        var companyID = prefs.getString('companyID') ?? "0";

        var branchID = prefs.getInt('branchID') ?? 1;
        var countryID = prefs.getString('Country') ?? "1";
        var stateID = prefs.getString('State') ?? "1";
        var tableVacant = prefs.getBool("tableClearAfterPayment") ?? false;
        var employeeID = prefs.getInt('employee_ID') ?? 1;

        DateTime selectedDateAndTime = DateTime.now();
        String convertedDate = "$selectedDateAndTime";
        dateOnly = convertedDate.substring(0, 10);

        var loyalty;
        if (loyaltyCustomerID == 0) {
          loyalty = null;
        } else {
          loyalty = loyaltyCustomerID;
        }

        var autoC = true;

        var cardNumber = "";
        if (cardNoController.text == "") {
          cardNumber = "";
        } else {
          cardNumber = cardNoController.text;
        }
        final String url = '$baseUrl/posholds/create-pos/salesInvoice/';
        print(url);
        Map data = {
          "EmployeeID": employeeID,
          'LoyaltyCustomerID': loyalty,
          "table_vacant": tableVacant,
          "Paid": autoC,
          "CompanyID": companyID,
          "Table": widget.tableID,
          "CreatedUserID": userID,
          "BranchID": branchID,
          "LedgerID": ledgerID,
          "GrandTotal": grandTotalAmount,
          "BillDiscPercent": "$billDiscPercent",
          "BidillDiscAmt": "$disCount",
          "CashReceived": "$cashReceived",
          "BankAmount": "$bankReceived",
          "CardTypeID": cardTypeId,
          "CardNumber": cardNumber,
          "SalesOrderID": widget.UUID,
          "TotalDiscount": "$disCount",
          "Date": dateOnly,
          "RoundOff": "0.0",
          "Balance": "$balance",
          "TotalTax": totalTaxP,
          "DeliveryManID": deliveryManID,
          "AllowCashReceiptMoreSaleAmt": false,
        };
        print(data);
        //encode Map to JSON
        var body = json.encode(data);

        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $accessToken',
            },
            body: body);

        print("${response.statusCode}");
        print("${response.body}");
        Map n = json.decode(utf8.decode(response.bodyBytes));
        var status = n["StatusCode"];
        var responseJson = n["data"];

        print(responseJson);
        if (status == 6000) {
          stop();
          dialogBoxHide(context, "Sales created successfully!!!");

          print("--0-----${widget.orderType}----");
          Navigator.pop(context, [widget.orderType, false]);
          Future.delayed(const Duration(milliseconds: 500), () {
            if (print_save == true) {
              PrintDataDetails.type = "SI";
              PrintDataDetails.id = n["invoice_id"];
              printDetail(context);
            }
          });
        } else if (status == 6001) {
          stop();
          var errorMessage = n["message"]??"";
          dialogBox(context, errorMessage);
        }
        //DB Error
        else {
          stop();
        }
      } catch (e) {
        dialogBox(context, "Some Network Error");
        stop();
      }
    }
  }

  /// card type
  var cardData = [
    {
      "id": "25600c2f-4536-40b1-a44f-fd7d697784c5",
      "TransactionTypesID": 33,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "None",
      "Notes": "None",
      "CreatedDate": "2021-08-14T08:18:27.934595+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true,
    },
    {
      "id": "85c2e2b6-8d0c-441a-90b6-85f5f9db59bb",
      "TransactionTypesID": 5,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "Discover",
      "Notes": "Discover",
      "CreatedDate": "2021-08-14T08:18:27.933462+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true,
    },
    {
      "id": "e2cca64e-89be-4cf8-8840-fe489b0c3a95",
      "TransactionTypesID": 4,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "American Express",
      "Notes": "American Express",
      "CreatedDate": "2021-08-14T08:18:27.932536+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true,
    },
    {
      "id": "b45b8307-e24b-4386-8d01-a95d14378b82",
      "TransactionTypesID": 3,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "Citibank",
      "Notes": "Citibank",
      "CreatedDate": "2021-08-14T08:18:27.931607+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true
    },
    {
      "id": "97d007dc-7f9c-4a6f-83b9-28c19e450e0a",
      "TransactionTypesID": 2,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "Mastercard",
      "Notes": "Mastercard",
      "CreatedDate": "2021-08-14T08:18:27.930380+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true
    },
    {
      "id": "f992d994-852f-45cc-b932-afbe547d628d",
      "TransactionTypesID": 1,
      "BranchID": 1,
      "Action": "A",
      "MasterTypeID": 1,
      "MasterTypeName": "Card Network",
      "Name": "Visa",
      "Notes": "Visa",
      "CreatedDate": "2021-08-14T08:18:27.928514+03:00",
      "UpdatedDate": "2020-06-01T00:00:00+03:00",
      "CreatedUserID": 1,
      "IsDefault": true
    }
  ];

  Future<Null> loadCard() async {
    var responseDiningTable = cardData;
    setState(() {
      for (Map user in responseDiningTable) {
        cardList.add(CardDetailsDetails.fromJson(user));
      }
    });
  }
}

List<CardDetailsDetails> cardList = [];
List<CategoryListModel> categoryList = [];
List<FlavourListModel> flavourList = [];
List<ProductListModelDetail> productList = [];
List<LoyaltyCustomerModel> loyaltyCustLists = [];

class Button extends StatelessWidget {
  const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {},
      ),
    );
    ;
  }
}

class UserDetailsAppBar extends StatelessWidget {
  UserDetailsAppBar({
    Key? key,
    required this.user_name,
    // required this.masterID,
  }) : super(key: key);

  String user_name;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        height: MediaQuery.of(context).size.height / 11, //height of button
        width: MediaQuery.of(context).size.width / 2.3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              user_name,
              style: customisedStyle(context, Colors.black, FontWeight.w700, 14.0),
            ),
            IconButton(
              icon: const Icon(Icons.login_outlined),
              onPressed: () async {
                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: AlertDialog(
                          title: Padding(
                            padding: const EdgeInsets.all(0.5),
                            child: Text(
                              "Alert!",
                              style: customisedStyle(context, Colors.black, FontWeight.w600, 15.00),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Text("Log out from POS", style: customisedStyle(context, Colors.black, FontWeight.w600, 15.0)),
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setBool('IsSelectPos', false);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EnterPinNumber()));
                                },
                                child: Text(
                                  'Ok',
                                  style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
                                )),
                            TextButton(
                                onPressed: () => {
                                      Navigator.pop(context),
                                    },
                                child: Text(
                                  'cancel'.tr,
                                  style: customisedStyle(context, Colors.black, FontWeight.w600, 12.00),
                                )),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ));
  }
}

class BackButtonAppBar extends StatelessWidget {
  BackButtonAppBar({
    Key? key,
    // required this.masterID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerRight,
        height: MediaQuery.of(context).size.height / 11, //height of button
        // width: MediaQuery.of(context).size.width / 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var selectPos = prefs.getBool('IsSelectPos') ?? false;
                if (selectPos) {
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ));
  }
}
