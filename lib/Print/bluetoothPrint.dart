// import 'package:pos_printer_manager/pos_printer_manager.dart';


// class InvoicePrintScreen extends StatefulWidget {
//   @override
//   _InvoicePrintScreenState createState() => _InvoicePrintScreenState();
// }
//
// class _InvoicePrintScreenState extends State<InvoicePrintScreen> {
//
//   bool _isLoading = false;
//   List<NetWorkPrinter> _printers = [];
//   NetworkPrinterManager? _manager;
//   List<int> _data = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     Future.delayed(Duration.zero, () {
//
//       // _scan();
//        printDetails();
//     });
//   }
//
//
//
//
//   final info = NetworkInfo();
//
//
//
//   List<ProductDetailsModelOld> printDalesDetails = [];
//
//   Future<Null> printDetails() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       stop();
//       dialogBox(context, "Check your internet connection");
//     } else {
//       try {
//         printDalesDetails.clear();
//
//         String baseUrl = BaseUrl.baseUrl;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         var userID = prefs.getInt('user_id') ?? 0;
//         var accessToken = prefs.getString('access') ?? '';
//         var companyID = prefs.getString('companyID') ?? 0;
//         var branchID = prefs.getInt('branchID') ?? 1;
//         var ip = prefs.get("defaultIP") ?? "";
//
//         var pk = PrintDataDetails.id;
//         final String url = '$baseUrl/posholds/view/pos-sale/invoice/$pk/';
//         print(url);
//         print(accessToken);
//         Map data = {
//           "CompanyID": companyID,
//           "BranchID": branchID,
//           "CreatedUserID": userID,
//           "PriceRounding": 2,
//           "Type": PrintDataDetails.type
//         };
//         print(data);
//         //encode Map to JSON
//         var body = json.encode(data);
//
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//               'Authorization': 'Bearer $accessToken',
//             },
//             body: body);
//
//         print("${response.statusCode}");
//         print("${response.body}");
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//
//         var status = n["StatusCode"];
//         var responseJson = n["data"];
//
//         if (status == 6000) {
//           _scan();
//           stop();
//
//
//           setState(() {
//             printDalesDetails.clear();
//             BluetoothPrintThermalDetails.voucherNumber = responseJson["VoucherNo"].toString();
//             BluetoothPrintThermalDetails.customerName = responseJson["CustomerName"] ?? 'Cash In Hand';
//             BluetoothPrintThermalDetails.date = responseJson["Date"];
//             BluetoothPrintThermalDetails.netTotal = responseJson["NetTotal_print"].toString();
//             BluetoothPrintThermalDetails.customerPhone = responseJson["OrderPhone"] ?? "";
//             BluetoothPrintThermalDetails.grossAmount = responseJson["GrossAmt_print"].toString();
//             BluetoothPrintThermalDetails.sGstAmount = responseJson["SGSTAmount"].toString();
//             BluetoothPrintThermalDetails.cGstAmount = responseJson["CGSTAmount"].toString();
//             BluetoothPrintThermalDetails.tokenNumber = responseJson["TokenNumber"].toString();
//             BluetoothPrintThermalDetails.discount = responseJson["TotalDiscount_print"].toString();
//             BluetoothPrintThermalDetails.totalTax = responseJson["TotalTax_print"].toString();
//             BluetoothPrintThermalDetails.grandTotal = responseJson["GrandTotal_print"].toString();
//             BluetoothPrintThermalDetails.qrCodeImage = responseJson["qr_image"];
//
//             BluetoothPrintThermalDetails.customerTaxNumber = responseJson["TaxNo"].toString();
//             BluetoothPrintThermalDetails.ledgerName =
//                 responseJson["LedgerName"] ?? '';
//             BluetoothPrintThermalDetails.customerAddress =
//             responseJson["Address1"];
//             BluetoothPrintThermalDetails.customerAddress2 =
//             responseJson["Address2"];
//             BluetoothPrintThermalDetails.customerCrNumber =
//                 responseJson["CustomerCRNo"] ?? "";
//
//             var companyDetails = responseJson["CompanyDetails"];
//
//
//             BluetoothPrintThermalDetails.salesDetails =
//             responseJson["SalesDetails"];
//             BluetoothPrintThermalDetails.companyName =
//                 companyDetails["CompanyName"] ?? '';
//             // companyLogo= companyDetails["Address1"].toString();
//             BluetoothPrintThermalDetails.address1Company =
//                 companyDetails["Address1"] ?? '';
//
//              BluetoothPrintThermalDetails.state =
//                 companyDetails["StateName"] ?? '';
//             BluetoothPrintThermalDetails.postalCodeCompany =
//                 companyDetails["PostalCode"] ?? '';
//             BluetoothPrintThermalDetails.phoneCompany =
//                 companyDetails["Phone"] ?? '';
//             BluetoothPrintThermalDetails.mobileCompany =
//                 companyDetails["Mobile"] ?? '';
//             BluetoothPrintThermalDetails.vatNumberCompany =
//                 companyDetails["VATNumber"] ?? '';
//             BluetoothPrintThermalDetails.companyGstNumber =
//                 companyDetails["GSTNumber"] ?? '';
//             BluetoothPrintThermalDetails.cRNumberCompany =
//                 companyDetails["CRNumber"] ?? '';
//             // BluetoothPrintThermalDetails.descriptionCompany= companyDetails["Description"]?? '';
//             BluetoothPrintThermalDetails.countryNameCompany =
//                 companyDetails["CountryName"] ?? '';
//             BluetoothPrintThermalDetails.stateNameCompany =
//                 companyDetails["StateName"] ?? '';
//             BluetoothPrintThermalDetails.companyLogoCompany = companyDetails["CompanyLogo"] ?? '';
//             BluetoothPrintThermalDetails.countyCodeCompany = companyDetails["CountryCode"] ?? '';
//             BluetoothPrintThermalDetails.buildingNumberCompany = companyDetails["Address1"] ?? '';
//
//
//
//           });
//         } else if (status == 6001) {
//           setState(() {
//             stop();
//           });
//         }
//
//         //DB Error
//         else {
//           setState(() {
//             stop();
//           });
//           // _scaffoldKey.currentState.showSnackBar(SnackBar(
//           //   content: Text('Some Network Error please try again Later'),
//           //   duration: Duration(seconds: 1),
//           // ));
//         }
//       } catch (e) {
//         setState(() {
//           stop();
//         });
//         print(e);
//         print('Error In Loading');
//       }
//     }
//   }
//
//   start() {
//     Loader.show(context,
//         progressIndicator: const CircularProgressIndicator(),
//         themeData: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff000000))),
//         overlayColor: const Color(0x99E8EAF6));
//   }
//
//   stop() {
//     Future.delayed(Duration(seconds: 0), () {
//       Loader.hide();
//     });
//   }
//   var bluetoothHelper = new AppBlocs();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:  Text('Print',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800),),
//         elevation: 0.0,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//               colors: [Color(0xffEF8106), Color(0xffFE6A37)],
//             ),
//           ),
//         ),
//         actions: [
//           ElevatedButton(
//               onPressed: (){
//
//
//
//               }
//               , child: Text('print'))
//         ],
//       ),
//
//       body: ListView(
//         children: [
//           ..._printers
//               .map((printer) => Card(
//             child: ListTile(
//               title: Text(
//                 "${printer.name}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.grey),
//               ),
//               subtitle: Text(
//                 "${printer.address}",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.grey),
//               ),
//               leading: const Icon(Icons.bluetooth),
//               onTap: () => _connect(printer),
//               onLongPress: () {
//                 _startPrinter();
//               },
//               selected: printer.connected,
//               trailing: IconButton(
//                 icon: const Icon(Icons.refresh),
//                 onPressed: () {
//                   setState(() {
//                     _printers.clear();
//                   });
//                   disconnect(printer);
//                   _scan();
//                 },
//               ),
//             ),
//           ))
//               .toList(),
// /// commented print
//           ElevatedButton(
//          onPressed: ()async{
//            SharedPreferences prefs = await SharedPreferences.getInstance();
//            var defaultIp = prefs.getString('defaultIP')??'';
//
//         //   NetWorkPrinter printer;
//             var  printer =await printHelper.funcRest(defaultIp);
//
//            print(printer.runtimeType);
//
//     }, child: Text("asd"),)
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Color(0xffEF8106),
//         child: _isLoading ? const Icon(Icons.stop) :const Icon(Icons.play_arrow),
//         onPressed: _isLoading ? null : _scan,
//       ),
//     );
//   }
// /// wifi
//
//
//   var printHelper = new AppBlocs();
//
//
//   // _scan() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //     _printers = [];
//   //   });
//   //   var printers = await BluetoothPrinterManager.discover();
//   //
//   //   setState(() {
//   //     _isLoading = false;
//   //     _printers = printers;
//   //   });
//   //   con();
//   // }
//
//   autoPrint()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var ip = prefs.get("defaultIP") ??"";
//     print(ip);
//     for(var i = 0; i <_printers.length; i++){
//       print("foor loop");
//       if(_printers[i].address == ip){
//          print(_printers[i].address);
//         _connect(_printers[i]);
//       }
//     }
//   }
//
//
//
//   _scan() async {
//     var stopwatch = Stopwatch()..start();
//     print("scan");
//
//
//     var printers = await NetworkPrinterManager.discover();
//     print("11111length---${printers.length}");
//      setState(() {
//       _isLoading = false;
//      _printers = printers;
//       autoPrint();
//       print("22222length---${_printers.length}");
//     });
//     print("completed executed in ${stopwatch.elapsed}");
//   }
//   _connect(NetWorkPrinter printer) async {
//
//
//     if(printer.connected){
//       _startPrinter();
//     }
//     else{
//       var paperSize = PaperSize.mm80;
//       var profile_mobile = await CapabilityProfile.load();
//       var manager = NetworkPrinterManager(printer, paperSize, profile_mobile);
//       await manager.connect();
//       setState(() {
//         _manager = manager;
//         printer.connected = true;
//         print("------------**********-------------${printer.connected}");
//         _startPrinter();
//       });
//     }
//   }
//
//
//
//   _startPrinter()async{
//     print("---------start print------");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var temp = prefs.getString("template") ?? "template1";
//
//     print('$temp');
//     final content = ThermalArabicShort.invoiceDesign("150mm");
//     // if(temp == 'template1'){
//     //   content = ArabicThermalPrint.getInvoiceContent();
//     // }
//     // else{
//     //   content = ThermalPrint.invoiceDesign();
//     // }
//
//
//     print("---------completed design------");
//     //     final content = ThermalEnglishDesign.getInvoiceContent();
//     var bytes = await WebcontentConverter.contentToImage(content: content);
//     var isoDate = DateTime.parse(BluetoothPrintThermalDetails.date).toIso8601String();
//     var service;
//
//     if (PrintDataDetails.type == "SO") {
//       BluetoothPrintThermalDetails.qrCodeImageBool = false;
//       /// old
//       ///service = ESCPrinterService(bytes, qrCode, false);
//       service = ESCPrinterService(bytes);
//     } else {
//
//       if(BluetoothPrintThermalDetails.qrCodeImageBool ==true){
//         /// old
//         ///service = ESCPrinterService(bytes, qrCode, false);
//         service = ESCPrinterService(bytes);
//       }
//       else{
//         service = ESCPrinterService(bytes);
//       }
//
//     }
//     var profile_mobile = await CapabilityProfile.load();
//     var data = await service.getBytes(profile_mobile: profile_mobile);
//      if (_manager != null) {
//       print("isConnected ${_manager!.isConnected}");
//       _manager!.writeBytes(data, isDisconnect: false);
//     }
//
//   }
//
//
//   after(val){
//     if(val ==0){
//       print("its 0");
//       _scan();
//     }
//     else{
//       print("its ok");
//     }
//   }
//
//
//   disconnect(NetWorkPrinter printer) async {
//     var paperSize = PaperSize.mm80;
//     var profile_mobile = await CapabilityProfile.load();
//     var manager = NetworkPrinterManager(printer, paperSize, profile_mobile);
//     await manager.disconnect();
//     print(" -==== connected =====- ");
//     setState(() {
//       _manager = manager;
//     });
//   }
//
//
//
//
//
// }


class ProductDetailsModelOld {
  final String unitName, qty, netAmount, productName, unitPrice, productDescription;

  ProductDetailsModelOld({
   required this.unitName,
   required this.qty,
   required this.netAmount,
   required this.productName,
   required this.unitPrice,
   required this.productDescription,
  });

  factory ProductDetailsModelOld.fromJson(Map<dynamic, dynamic> json) {
    return  ProductDetailsModelOld(
      unitName: json['UnitName'],
      qty: json['quantityRounded'].toString(),
      netAmount: json['netAmountRounded'].toString(),
      productName: json['ProductName'],
      unitPrice: json['unitPriceRounded'].toString(),
      productDescription: json['ProductDescription'],
    );
  }
}


class PrintDataDetails{
  static String type ="";
  static String id = "";
}
class BluetoothPrintThermalDetails {
  static String invoiceType = "";
  static String voucherID = "";
  static String voucherNumber = "";
  static String customerName = "";
  static String customerTaxNumber = "";
  static String companyGstNumber = "";
  static String customerCrNumber = "";
  static String ledgerName = "";
  static String customerAddress = "";
  static String customerAddress2 = "";
  static String customerPhone = "";
  static String date = "";
  static String grossAmount = "";
  static String netTotal = "";
  static String grandTotal = "";
  static String totalTax = "";
  static String discount = "";
  static String totalQty = "";
  static String companyName = "";
  static String buildingNumber = "";
  static String secondName = "";
  static String address2Company = "";
  static String address3Company = "";
  static String state = "";
  static String postalCodeCompany = "";
  static String phoneCompany = "";
  static String currency = "";
  static String mobileCompany = "";
  static String vatNumberCompany = "";
  static String cRNumberCompany = "";
  static String descriptionCompany = "";
  static String countryNameCompany = "";
  static String stateNameCompany = "";
  static String streetName = "";
  static String companyLogoCompany = "";
  static String countyCodeCompany = "";
  static String buildingNumberCompany = "";
  static bool companyLogo = false;
  static bool qrCodeImageBool = false;

  static var salesDetails;
  static String sGstAmount = "";
  static String qrCodeImage = "";
  static String cGstAmount = "";
  static String tokenNumber = "";
  static String cashReceived = "";
  static String bankReceived = "";
  static String balance = "";
  static String salesType = "";
  static String tableName = "";
  static String time = "";
  static String totalVATAmount = "";
  static String totalExciseAmount = "";
 }