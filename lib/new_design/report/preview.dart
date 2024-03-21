import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:webcontent_converter/webcontent_converter.dart';
// import 'package:open_file_safe/open_file_safe.dart' as open_file;
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'new_report_page.dart';

//heading
// printType
// detailHead
// details
class PreviewPage extends StatefulWidget {
  String heading, printType,html;

  var details;

  PreviewPage({
    super.key,
    required this.html,
    required this.heading,
    required this.printType,
    required this.details,
  });

  @override
  _PreviewPageState createState() => new _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController controller = new TextEditingController();

  late io.File _file;
  var content;

  var detailList = [];
  var masterList = [];
  var updateData = [];

  var printDetailList = [];
  var printMasterList = [];

  var savedPath = "";

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  var grandTotal = "";
  var cashSum = "";
  var bankSum = "";
  var creditSum = "";

  loadReport() {
    print("-------------------${widget.printType}");
    if (widget.printType == "RMS Report") {
      generatePDFofRmsReport();
    }
    else if (widget.printType == "Product wise report") {
      generatePDFofProductReport();
    }
    else if (widget.printType == "TableWise report") {
      generatePDFofTableReport();
    }
    else {
      printSalesSummery();
    }
  }

  bool showInvoice = false;

  printSalesSummery() async {
    List<ReportListModel> reportListPreview = [];
    var responseJson = widget.details;
    for (Map user in responseJson) {
      reportListPreview.add(ReportListModel.fromJson(user));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dir = await getApplicationDocumentsDirectory();

    var companyName = prefs.getString('companyName') ?? '';
    var timeS = DateTime.now().millisecondsSinceEpoch.toString();
    String path_name = companyName + "$timeS" + "invoice.pdf";
    savedPath = p.join(dir.path, path_name);

    var printItems = """
   """;

//               <td>${tableDataDetailsPrint[i].productName}<br>(قلم باسكة)</td>

    for (var i = 0; i < reportListPreview.length; i++) {
      printItems += """ <tr>
     <td class="sm">${reportListPreview[i].date}</td>
     <td class="sm">${reportListPreview[i].voucherNo}</td>
     <td class="sm">${reportListPreview[i].custName}</td>
     <td class="right-align sm">${roundStringWith(reportListPreview[i].total)}</td>

     </tr>""";
    }

    var hhtml = """ <html>
     <head>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" />
     <style>
             table {
     font-family: Poppins, sans-serif;
     border-collapse: collapse;
     width: 100%;
     }

     td, th {
     border: 1px solid #dddddd;
     text-align: left;
     padding: 8px;
     }
     th.company {
     width: 35%
     }

     td.right-align {
     text-align: right
     }
     tr.hedding{
         background-color:#434343;
         border-radius:12px;
         
     }
     th.head{
        color:#FFFFFF;
        opacity: 1;
        text-align:center;
     }
     td.sm {
     font-size:12px;
     font-weight:500;
     line-height:15px;
     font-style:poppins;
     }


     </style>
     </head>
     <body>

     <h2>${widget.heading}</h2>

     <table>
     
     <tr class='hedding'>
     <th class='head'>Date</th>
     <th class='head'>Voucher No</th>
     <th class="company head">Ledger name</th>
     <th class='head'>Amount</th>
      </tr>
     
   
    
   $printItems
     </table>

     </body>
     </html>""";

    content = hhtml;
    var result = await WebcontentConverter.contentToPDF(
      content: hhtml,
      savedPath: savedPath,
      format: PaperFormat.a4,
      margins: PdfMargins.px(top: 30, bottom: 0, right: 0, left: 0),
    );

    setState(() => _file = io.File(savedPath));
    if (_file.path == "") {
      setState(() {
        showInvoice = false;
      });
      print('path is empty');
    } else {
      setState(() {
        showInvoice = true;
      });
      print('path not empty');
    }
  }



  generatePDFofRmsReport() async {


    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dir = await getApplicationDocumentsDirectory();

      var companyName = prefs.getString('companyName') ?? '';
      var timeS = DateTime.now().millisecondsSinceEpoch.toString();
      String path_name = companyName + "$timeS" + "invoice.pdf";
      savedPath = p.join(dir.path, path_name);

      content = widget.html;
      var result = await WebcontentConverter.contentToPDF(
        content: widget.html,
        savedPath: savedPath,
        format: PaperFormat.a4,
        margins: PdfMargins.px(top: 30, bottom: 0, right: 0, left: 0),
      );

      setState(() => _file = io.File(savedPath));
      if (_file.path == "") {
        setState(() {
          showInvoice = false;
        });
        print('path is empty');
      } else {
        setState(() {
          showInvoice = true;
        });
        print('path not empty');
      }
    }
    catch(e){
      print("=================${e.toString()}");
    }


  }

  generatePDFofProductReport() async {
    List<ProductReport> productReportLists = [];

    var responseJson = widget.details;

    for (Map user in responseJson) {
      productReportLists.add(ProductReport.fromJson(user));
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dir = await getApplicationDocumentsDirectory();

    var companyName = prefs.getString('companyName') ?? '';
    var timeS = DateTime.now().millisecondsSinceEpoch.toString();
    String path_name = companyName + "$timeS" + "invoice.pdf";
    savedPath = p.join(dir.path, path_name);


    var printItems = """
    """;
    for (var i = 0; i < productReportLists.length; i++) {
      printItems += """ <tr>
     <td class="sm">${productReportLists[i].date}</td>
     <td class="sm">${productReportLists[i].productName}</td>
     <td class="right-align sm">${roundStringWith(productReportLists[i].rate)}</td>
     <td class="right-align sm"">${roundStringWith(productReportLists[i].noOfSold)+ " "+productReportLists[i].unitName}</td>
     <td class="right-align sm"">${roundStringWith(productReportLists[i].grandTotal)}</td>

     </tr>""";
    }

    var html = """ <html>
         <head>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" />
     <style>
             table {
     font-family: Poppins, sans-serif;
     border-collapse: collapse;
     width: 100%;
     }
 
     td, th {
     border: 1px solid #dddddd;
     text-align: left;
     padding: 8px;
     }
     th.company {
     width: 35%
     }
     

     td.right-align {
     text-align: right
     }
     tr.hedding{
         background-color:#434343;
         border-radius:12px;
         
     }
     th.head{
        color:#FFFFFF;
        opacity: 1;
        text-align:center;
     }
     td.sm {
     font-size:12px;
     font-weight:500;
     line-height:15px;
     font-style:poppins;
     }


     </style>
     </head>
     <body>

     <h2>${widget.heading}</h2>

     <table>
      <tr class='hedding'>
     <th class='head'>Date</th>
     <th class="company head">Product name</th>
     <th class='head'>price</th>
     <th class='head'>No of sold</th>
     <th class='head'>Total</th>
      </tr>
    
   $printItems
     </table>

     </body>
     </html>""";
    log("content $content");

    content = html;
    var result = await WebcontentConverter.contentToPDF(
      content: html,
      savedPath: savedPath,
      format: PaperFormat.a4,
      margins: PdfMargins.px(top: 30, bottom: 0, right: 0, left: 0),
    );

    setState(() => _file = io.File(savedPath));
    if (_file.path == "") {
      setState(() {
        showInvoice = false;
      });
      print('path is empty');
    } else {
      setState(() {
        showInvoice = true;
      });
      print('path not empty');
    }
  }

  generatePDFofTableReport() async {
    try {
      List<TableReport> tableReportListsPreview = [];

      var responseJson = widget.details;

      for (Map user in responseJson) {
        tableReportListsPreview.add(TableReport.fromJson(user));
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var dir = await getApplicationDocumentsDirectory();

      var companyName = prefs.getString('companyName') ?? '';
      print(companyName);
      var timeS = DateTime.now().millisecondsSinceEpoch.toString();
      String path_name = companyName + "$timeS" + "invoice.pdf";
      savedPath = p.join(dir.path, path_name);

      var printItems = """
 
    """;

      for (var i = 0; i < tableReportListsPreview.length; i++) {
        printItems += """ <tr>
     <td class="sm">${tableReportListsPreview[i].date}</td>
     <td class="sm">${tableReportListsPreview[i].voucherNo}</td>
     <td class="sm">${tableReportListsPreview[i].custName}</td>
     <td class="right-align sm">${roundStringWith(tableReportListsPreview[i].total)}</td>
     </tr>""";
      }

      var hhtml = """ <html>
           <head>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" />
     <style>
             table {
     font-family: Poppins, sans-serif;
     border-collapse: collapse;
     width: 100%;
     }
 
     td, th {
     border: 1px solid #dddddd;
     text-align: left;
     padding: 8px;
     }
     th.company {
     width: 35%
     }

     td.right-align {
     text-align: right
     }
     tr.hedding{
         background-color:#434343;
         border-radius:12px;
         
     }
     th.head{
        color:#FFFFFF;
        opacity: 1;
        text-align:center;
     }
     td.sm {
     font-size:12px;
     font-weight:500;
     line-height:15px;
     font-style:poppins;
     }

     </style>
     </head>
     <body>

     <h2>${widget.heading}</h2>

     <table>
     
       <tr class='hedding'>
     <th class='head'>Date</th>
     <th class='head'>Voucher no</th>
     <th class="company head">Customer name</th>
     <th class='head'>Amount</th>
      </tr>
    
   $printItems
     </table>

     </body>
     </html>""";

      log("log $hhtml");

      content = hhtml;
      var result = await WebcontentConverter.contentToPDF(
        content: hhtml,
        savedPath: savedPath,
        format: PaperFormat.a4,
        margins: PdfMargins.px(top: 30, bottom: 0, right: 0, left: 0),
      );

      setState(() => _file = io.File(savedPath));
      if (_file.path == "") {
        setState(() {
          showInvoice = false;
        });
        print('path is empty');
      } else {
        setState(() {
          showInvoice = true;
        });
        print('path not empty');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Colors.black,
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'report_preview'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: const Color(0xffF3F3F3),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.black,
                ),
                onPressed: () {
                  loadReport();
                }),
          ]),

      body: Column(
        children: [
          //
          Expanded(
              child: Column(
            children: [
              showInvoice == true
                  ? Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width - 10,
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: PdfPreview(
                        build: (format) async {
                          return await _file.readAsBytes();
                        },
                        useActions: false,
                        scrollViewDecoration: BoxDecoration(color: Colors.transparent),
                      ),
                    )
                  : Container(),
            ],
          )),

          Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Card(
                //    elevation: 10,
                color: Colors.black,
                child: Container(
                  height: MediaQuery.of(context).size.height / 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ElevatedButton(
                      //     onPressed: (){
                      //       print_pdf();
                      //     }, child: Text("")),
                      // ElevatedButton(onPressed: (){
                      //   printPdf();
                      // }, child: Text("")),
                      // ElevatedButton(onPressed: (){
                      //   share();
                      // }, child: Text("")),
                      //
                      //

                      IconButton(icon: SvgPicture.asset('assets/svg/download_pdf.svg'), iconSize: 20, onPressed: () {}),
                      IconButton(
                          icon: SvgPicture.asset('assets/svg/print_pdf.svg'),
                          iconSize: 20,
                          onPressed: () {
                            if (content == "") {
                              dialogBox(context, "Refresh");
                            } else {
                              printPdf();
                            }
                          }),
                      IconButton(
                          icon: SvgPicture.asset('assets/svg/share_pdf.svg'),
                          iconSize: 20,
                          onPressed: () {
                            share();
                          }),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ///sales summery \

  @override
  void dispose() {
    super.dispose();
  }

  share() async {
    Uint8List image_byte = await _file.readAsBytes();
    Printing.sharePdf(bytes: image_byte);
  }

  printPdf() async {
    try {
      await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
                format: format,
                html: content,
              ));
    } catch (e) {
      print(e.toString());
    }
    // await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
  }

  print_pdf() async {
   // await open_file.OpenFile.open(savedPath);
  }

  dateConverter(String dt) {
    DateTime todayDate = DateTime.parse(dt);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    var asd = formatter.format(todayDate);
    return asd;
  }

  getBytes(int id, Uint8List value) {
    Uint8List va = Uint8List(2 + value.length);
    va[0] = id;
    va[1] = value.length;

    for (var i = 0; i < value.length; i++) {
      va[2 + i] = value[i];
    }
    return va;
  }
}

// class PrintPreview {
//   static String heading = "";
//   static String printType = "";
//   static String detailHead = "";
//   static var details;
// }

class ReportListModel {
  String id, voucherNo, date, custName, tableName, total;

  ReportListModel(
      {required this.id, required this.tableName, required this.voucherNo, required this.date, required this.custName, required this.total});

  factory ReportListModel.fromJson(Map<dynamic, dynamic> json) {
    return ReportListModel(
      id: json['id'] ?? "",
      voucherNo: json['VoucherNo'] ?? "",
      date: json['Date'] ?? "",
      custName: json['CustomerName'] ?? "",
      tableName: json['TableName'] ?? '',
      total: json['GrandTotal'].toString(),
    );
  }
}
