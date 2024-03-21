import 'package:rassasy_new/global/global.dart';

import 'bluetoothPrint.dart';

class ArabicThermalPrint {
  static String getInvoiceContent() {


    List<ProductDetailsModelOld> tableDataDetailsPrint = [];

    var salesDetails = BluetoothPrintThermalDetails.salesDetails;
    print(salesDetails);
    for (Map user in salesDetails) {
      tableDataDetailsPrint.add(ProductDetailsModelOld.fromJson(user));
    }



    var logoAvailable= true;
    var productDecBool= true;
    var qrCodeAvailable= BluetoothPrintThermalDetails.qrCodeImageBool;


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
      productDecBool= false;
      invoiceType = "ORDER";
      invoiceTypeArabic = "(طلب المبيعات)";
    }



    print("---------------------------");
    print(qrCodeAvailable);
    print(qrCodeAvailable);
    print("---------------------------");


    var companyName = BluetoothPrintThermalDetails.companyName;
    var companyAddress1 = BluetoothPrintThermalDetails.address1Company;
    // var companyAddress2 = BluetoothPrintThermalDetails.address2Company;
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
    var grossAmount = roundStringWith(BluetoothPrintThermalDetails.grossAmount);
    var discount = roundStringWith(BluetoothPrintThermalDetails.discount);
    var totalTax = roundStringWith(BluetoothPrintThermalDetails.totalTax);
    var grandTotal = roundStringWith(BluetoothPrintThermalDetails.grandTotal);
    var companyLogo = BluetoothPrintThermalDetails.companyLogoCompany;
    var token = BluetoothPrintThermalDetails.tokenNumber;



    var printItems = """<table>
         <thead style='border-bottom: 1px solid black;'>
            <tr>
               <th class="textCenter">SL<br><font size="5">(رقم)</font></th>
               <th style="width: 30%;">Product Name<br><font size="5">(اسم المنتج)</font></th>
               <th class="textCenter" style="width: 15px;">Qty<br><font size="5">(كمية)</font></th>
               <th class="textRight">Rate<br><font size="5">(معدل)</font></th>
               <th class="textRight">Net<br><font size="5">(مجموع)</font></th>
            </tr>
         </thead>
         <tbody>""";




    for (var i = 0; i < tableDataDetailsPrint.length; i++) {
      var productDesc = """""";
      if (productDecBool) {
        productDesc = """
       <br>${tableDataDetailsPrint[i].productDescription}

      """;
      }


      printItems += """<tr>
               <td class="textCenter">${i + 1}</td>
               <td><font size="4">${tableDataDetailsPrint[i].productName}$productDesc</font></td>
               <td class="textCenter">${roundStringWith(tableDataDetailsPrint[i].qty)}</td>
               <td class="textRight">${roundStringWith(tableDataDetailsPrint[i].unitPrice)}</td>
               <td class="textRight" style='font-weight: 800;'>${roundStringWith(tableDataDetailsPrint[i].netAmount)}</td>

            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";

    var logoHtml = """""";

    if (logoAvailable) {
      logoHtml = """
        <tr>
          <td colspan="2"><img class='company-logo' src='$companyLogo'/></td>
        </tr>
      """;
    }
    var qrCodeHtml = """""";

    if (qrCodeAvailable) {
      qrCodeHtml = """
        <img class='qrCodeImage' src='$qrCodeData'/>
        <br>
         <br>
        <label>Powered by ViknCodes</label>
      """;
    }

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
         font-weight: 600;
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

      </style>
   </head>
   <body>

      <!-- Head Section Starts Here -->
      <center>

          <table class="head-table" cellpadding="0" cellspacing="0" border="0">
      $logoHtml
  <tr>
    <td colspan="2" style='font-size: 40px;'>$companyName</td>
  </tr>
  <tr>
    <td colspan="2">$companyAddress1</td>
  </tr>

  <!-- <tr>
    <td colspan="2">$companyCountry</td>
  </tr> -->
  <tr>
  	<td>$companyTax</td>
    <td>الرقم الضريبي</td>
  </tr>
  <tr>
  	<td>$companyCrNumber</td>
    <!-- <td>رقم تسجيل الشركة</td> -->
     <td>س. ت</td>
  </tr>
  <tr>
    <td colspan="2">$companyPhone</td>
  </tr>
  <tr>
    <td colspan="2">$invoiceType</td>
  </tr>
  <tr>
    <td colspan="2">$invoiceTypeArabic</td>
  </tr>
</table>
      </center>

      <table class="subsection-table">
        <tr>
          <td style="font-size: 20px;">Token No</td>
          <td style="text-align: center; font-size: 23px;">$token</td>
          <td style="text-align: right;">رقم الرمز</td>
        </tr>
           <tr>
          <td style="font-size: 20px;">Voucher No</td>
          <td style="text-align: center; font-size: 23px;">$voucherNumber</td>
          <td style="text-align: right;">رقم الفاتورة</td>
        </tr>

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
          <td style="text-align: right;">هاتف</td>
        </tr>
      </table>
      <div class="line-1"></div>
      <!-- Sub Section Ends Here -->
      <!-- Item Section Starts Here -->
      $printItems
      <!-- Item Section Ends Here -->
      <!-- Total Section Starts Here -->
         <div style="height: 15px; border-top: 3px solid black;"></div>
        <!--
         <div class="leftToright">
            <label>Total Quantity (الكمية الإجمالية)</label>
            <label>totalQty</label>
         </div>
         -->

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

      <!-- Total Section Ends Here -->
      <div style='border-top: 2px solid black;'></div>
      <!-- Grand Total Section Starts Here -->
         <b>
            <div class="leftToright" style='margin: 10px 10px; font-size: 25px; font-weight: 900;'>
               <label>Grand Total (المبلغ الإجمالي)</label>
               <label>$countyCodeCompany $grandTotal</label>
            </div>
         </b>
         <center>
         $qrCodeHtml
         </center>


      <!-- Grand Total Section Ends Here -->
      <div class="line-1"></div>
      <br>
   </body>
</html>""";
    return print_details;
  }

}
///PrintDataDetails.type check print t