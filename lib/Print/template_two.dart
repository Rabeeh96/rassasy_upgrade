import 'package:rassasy_new/global/global.dart';
import 'bluetoothPrint.dart';

class ThermalPrint {

  static String invoiceDesign() {
    List<ProductDetailsModelOld> tableDataDetailsPrint = [];
    var salesDetails = BluetoothPrintThermalDetails.salesDetails;

    for (Map user in salesDetails) {
      tableDataDetailsPrint.add(ProductDetailsModelOld.fromJson(user));
    }

    var logoAvailable = true;
    var productDecBool = true;
    var isInvoice = true;
    var qrCodeAvailable = BluetoothPrintThermalDetails.qrCodeImageBool;

    var invoiceType;
    var invoiceTypeArabic;

    invoiceType = "SIMPLIFIED TAX INVOICE";
    invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";

    if (PrintDataDetails.type == "SI") {
      invoiceType = "SIMPLIFIED TAX INVOICE";
      invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
    }
    if (PrintDataDetails.type == "SO") {
      logoAvailable = false;
      qrCodeAvailable = false;
      productDecBool = false;
      isInvoice = false;
      invoiceType = "ORDER";
      invoiceTypeArabic = "(طلب المبيعات)";
    }

    print("---------------------------");
    print(qrCodeAvailable);
    print(qrCodeAvailable);
    print("---------------------------");

    var companyName = BluetoothPrintThermalDetails.companyName;
    var companyAddress1 = BluetoothPrintThermalDetails.buildingNumberCompany;
     var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
    var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
    var companyTax = BluetoothPrintThermalDetails.vatNumberCompany;
    var companyCrNumber = BluetoothPrintThermalDetails.cRNumberCompany;
    var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
    var qrCodeData = BluetoothPrintThermalDetails.qrCodeImage;

    var voucherNumber = BluetoothPrintThermalDetails.voucherNumber;
    var name = BluetoothPrintThermalDetails.customerName;
    var date = BluetoothPrintThermalDetails.date;
    var phone = BluetoothPrintThermalDetails.customerPhone;
    var grossAmount = BluetoothPrintThermalDetails.grossAmount;
    var discount = BluetoothPrintThermalDetails.discount;
    var totalTax = BluetoothPrintThermalDetails.totalTax;
    var grandTotal = BluetoothPrintThermalDetails.grandTotal;
    var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
    var token = BluetoothPrintThermalDetails.tokenNumber;


    // var cashReceived = BluetoothPrintThermalDetails.cashReceived;
    // var bankReceived = BluetoothPrintThermalDetails.bankReceived;
    // var balance = BluetoothPrintThermalDetails.balance;
    // var salesOrderNo = BluetoothPrintThermalDetails.salesOrderNo;
    // var saleType = BluetoothPrintThermalDetails.salesType;



    var salesOrderNo = "";
    var cashReceived = "0.00";
    var bankReceived = "0.00";
    var balance = "0.00";
    var orderType = "";

    var qrCodeHtml = """""";

    if (qrCodeAvailable) {
      qrCodeHtml = """
        <img class='qrCodeImage' src='$qrCodeData'/>
        <br>
         <br>
        <label>Powered by ViknCodes</label>
      """;
    }


    var logoHtml = """""";

    if (logoAvailable) {
      logoHtml = """
        <tr>
          <td colspan="2"><img class='company-logo' src='$companyLogo'/></td>
        </tr>
      """;
    }

    var typeOfOrder = """""";
    /// new design
    // typeOfOrder = """
    //     <tr>  <td colspan="2">$orderType</td> </tr>""";
    //




    var orderVoucher = """""";
    var footerDetails = """""";

    /// new design
  //   if (isInvoice) {
  //     footerDetails = """ <b>
  //
  //
  //   <div class="leftToright">
  //   <label>Cash received (استلام النقود)</label>
  //   <label>$cashReceived</label>
  //   </div>
  //
  //   <div class="leftToright">
  //   <label>Bank received (البنك المستلم)</label>
  //   <label>$bankReceived</label>
  //   </div>
  //
  //   <div class="leftToright">
  //   <label>Balance (الرصيد)</label>
  //   <label>$balance</label>
  //   </div>
  // <div class="line-1"></div>
  //   </b>""";
  //
  //     orderVoucher = """  <tr>
  //         <td style="font-size: 20px;">Sales order No</td>
  //         <td style="text-align: center; font-size: 23px;">$salesOrderNo</td>
  //         <td style="text-align: right;">رقم طلب المبيعات</td>
  //       </tr>""";
  //
  //   }
  //




    var printHead = """<table>
         <thead>
            <tr>
             <!--
        <th class="textCenter">SL<br><font size="5">(رقم)</font></th>  -->
               <th style="width: 65%;">Product Name<br><font size="5">(اسم المنتج)</font></th>
               <th class="textRight" style="width: 15px;">Qty<br><font size="5">(كمية)</font></th>
               <th class="textRight">Net<br><font size="5">(مجموع)</font></th>
            </tr>
         </thead>
         <tbody>""";

    var printItems = """<table>
         <thead>
            <tr>



            </tr>
         </thead>
         <tbody>""";

    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var productName = tableDataDetailsPrint[i].productName;
      if (productName.length > 40) {
        productName = productName.substring(0, 23);
      }

      printItems += """<tr class="pd-2">
                 <td class="textLeft noPadding" colspan="5">(${i + 1}) $productName</td>

            </tr>""";

      printItems += """<tr>


               <td style="width: 65%;"><span style="font-weight: 600;font-size: 23px;">${tableDataDetailsPrint[i].productDescription}</span></td>
               <td class="textRight" style="width: 15px;">${roundStringWith(tableDataDetailsPrint[i].qty)}</td>
               <td class="textRight" style='font-weight: 800;'>${roundStringWith(tableDataDetailsPrint[i].netAmount)}</td>

            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";

    var print_details = """<html>
   <head>
      <style>
         html, body {
         width: 150mm;
         position:absolute;
         font-weight: 600;
         }
         .leftToright {
         display: flex;
         justify-content: space-between;
         margin-left: 10px;
         margin-right: 10px;
         font-weight: 800;
         font-size: 20px;
         }
         hr {
         border-top: 1px dashed;
         }
         table {
         border-collapse: collapse;
         width: 97%;
         font-size: 20px;
         margin-bottom: 25px;
         }
         table th {
         text-align: left;
         border-bottom: 2px solid black;
         font-weight: 900;
         }

         table tr {
          font-weight: 500;
         }

         td {
          padding-top:10px;
          padding-bottom:10px;
          font-size: 20px;
        }
         .textCenter {
         text-align: center;
         }
         .textRight {
         text-align: right;
         }
          .textLeft {
         text-align: left;
         font-weight: 600;
           font-size: 20px;
         }
         .line-1 {
          border-top: 2px solid black;
          width: 100%;
          height: 10px;
          margin-top: 10px;
         }

         .subsection-table td{
            padding: 5px;
            font-weight: 600;
         }
         .company-logo {
            width: 180px;

         }
         .qrCodeImage {
            width: 250px;

         }

         .head-table td{
            text-align: center;
            font-size: 28px;
            font-weight: 600;
            padding: 0;
            margin: 0;

         }

         .head-table {
          border-bottom: 2px solid black;
          border-spacing: 0px;
          border-collapse: collapse;
         }
         .maincontainer {
          display: flex,
          flex-direction: column
          }
          .flexRow {
            display:flex,
            flex-direction: row
          }
          .noPadding {
            padding: 0
            }
           .borderBottom {
               border-bottom: 2px solid black;
               padding-bottom: 10px
            }
            .pd-5{
              padding: 5px
            }
            .paddingleft{
              padding-left: 5px
            }

      </style>
   </head>
   <body>

      <center>
      <table class="head-table" cellpadding="0" cellspacing="0" border="0">
         $logoHtml
  <tr>
    <td colspan="2" style='font-size: 40px;'>$companyName</td>
  </tr>
  <tr>
    <td colspan="2">$companyAddress1</td>
  </tr>
     <tr>
    <td colspan="2">$companyCountry</td>
  </tr>

    <tr>
    <td colspan="2">$companyTax</td>
  </tr>
  <tr>
    <td colspan="2">$companyCrNumber</td>
  </tr>
  <tr>
    <td colspan="2">$companyPhone</td>
  </tr>

    <tr>
    <td style="padding-bottom:20px;"></td>
  </tr>
  <tr>
    <td colspan="2">$invoiceTypeArabic</td>
  </tr>
   <tr>
    <td colspan="2">$invoiceType</td>
  </tr>
    $typeOfOrder

  </table>
      </center>

      <table class="subsection-table">


            <tr>
          <td style="font-size: 20px;">Token No</td>
          <td style="text-align: center; font-size: 23px;">$token</td>
          <td style="text-align: right;">رمز لا</td>
        </tr>
           <tr>
          <td style="font-size: 20px;">Voucher No</td>
          <td style="text-align: center; font-size: 23px;">$voucherNumber</td>
          <td style="text-align: right;">رقم الفاتورة</td>
        </tr>

          $orderVoucher

        <tr>

          <td style="font-size: 20px;">Date</td>
          <td style="text-align: center; font-size: 23px;">$date</td>
          <td style="text-align: right;">تاريخ</td>
        </tr>
        <tr>

          <td style="font-size: 20px;">Name</td>
          <td style="text-align: center; font-size: 23px;">$name</td>
          <td style="text-align: right;">اسم</td>
        </tr>



        <tr>
          <td style="font-size: 20px;">Phone</td>
          <td style="text-align: center; font-size: 23px;">$phone</td>
          <td style="text-align: right;">الهاتف الخلوي</td>
        </tr>
      </table>


      <div class="line-1"></div>


      $printHead
      $printItems

         <div style="height: 15px; border-top: 3px solid black;"></div>


         <div class="leftToright">
            <label>Gross Amount (المبلغ الإجمالي)</label>
            <label>$grossAmount</label>
         </div>

         <div class="leftToright">
            <label>Discount (خصم)</label>
            <label>$discount</label>
         </div>
         <div class="leftToright">
            <label>Total Tax (مجموع الضريبة)</label>
            <label>$totalTax</label>
         </div>
           <div class="leftToright" style='margin: 10px 10px; font-size: 25px; font-weight: 900;'>
               <label>Grand Total (المبلغ الإجمالي)</label>
               <label>$grandTotal</label>
            </div>
      <!-- Total Section Ends Here -->
      <div style='border-top: 2px solid black;'></div>

        $footerDetails
         <center>

         $qrCodeHtml

         </center>


      <!-- Grand Total Section Ends Here -->

      <br>
   </body>
</html>""";
    return print_details;
  }
}

///PrintDataDetails.type check print t
