

import 'bluetoothPrint.dart';

class ThermalEnglishDesign {
  static String getInvoiceContent() {
    print("-1--");
    List<ProductDetailsModelOld> tableDataDetailsPrint = [];
    var salesDetails = BluetoothPrintThermalDetails.salesDetails;

    for (Map user in salesDetails) {
      tableDataDetailsPrint.add(ProductDetailsModelOld.fromJson(user));
    }

    var logoAvailable= true;
    var invoiceType = "TAX INVOICE";

    if (PrintDataDetails.type == "SI") {
      invoiceType = "TAX INVOICE";
    }
    if (PrintDataDetails.type == "SO") {
      logoAvailable = false;
      invoiceType = "SALES ORDER";
    }


    print("-1--");

    var companyName = BluetoothPrintThermalDetails.companyName;
    var companyAddress1 = BluetoothPrintThermalDetails.buildingNumber;
    var companyCountry = BluetoothPrintThermalDetails.countryNameCompany;
    print("-2--");
    var companyPhone = BluetoothPrintThermalDetails.phoneCompany;
    var companyTax = BluetoothPrintThermalDetails.vatNumberCompany;

    var countyCodeCompany = BluetoothPrintThermalDetails.countyCodeCompany;
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
    var sGstAmount = BluetoothPrintThermalDetails.sGstAmount;
    var cGstAmount = BluetoothPrintThermalDetails.cGstAmount;





    var printItems = """<table>
         <thead style='border-bottom: 1px solid black;'>
            <tr>
               <th class="textCenter">SL</th>
               <th style="width: 30%;">Product Name</th>
               <th class="textCenter" style="width: 15px;">Qty</th>
               <th class="textRight">Rate<br><font size="5"></font></th>
               <th class="textRight">Net<br><font size="5"></font></th>
            </tr>
         </thead>
         <tbody>""";

    for (var i=0; i<tableDataDetailsPrint.length; i++) {
      printItems += """<tr>
               <td class="textCenter">${i+1}</td>
               <td><font size="4">${tableDataDetailsPrint[i].productName}</font></td>
               <td class="textCenter">${tableDataDetailsPrint[i].qty}</td>
               <td class="textRight">${tableDataDetailsPrint[i].unitPrice}</td>
               <td class="textRight">${tableDataDetailsPrint[i].netAmount}</td>

            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";

    var size= 160;
    var phone_html = """""";
    var phone_enabled = true;
    if (phone_enabled) {
      phone_html = """<tr>
          <td style="font-size: 20px;">Phone</td>
          <td style="text-align: right; font-size: 23px;">$phone</td>
        </tr>""";
    }
    var logo_html = """""";
    if (logoAvailable) {
      logo_html = """
          <img class='company-logo' src='$companyLogo'/>
      """;
    }


    var additionalTaxSection = """""";
    var taxType = true;
    if (taxType) {
      additionalTaxSection = """
        <div class="leftToright">
            <label>SGST </label>
            <label>$sGstAmount</label>
         </div>

         <div class="leftToright">
            <label>CGST </label>
            <label>$cGstAmount</label>
         </div>
      """;
    }
    else {
      additionalTaxSection = """
        <div class="leftToright">
            <label>IGST </label>
            <label>$totalTax</label>
         </div>
      """;
    }


    var print_details = """<html>
   <head>
      <style>
         html, body {
         width: 160mm;
         position:absolute;
         font-size: 30px;
         font-weight: 600;
         }
         .leftToright {
         display: flex;
         justify-content: space-between;
         margin-left: 10px;
         margin-right: 10px;
         }
         hr {
         border-top: 1px dashed;
         }
         table {
         border-collapse: collapse;
         width: 97%;
         font-size: 25px;
         margin-bottom: 25px;
         }
         table th {
         text-align: left;
         border-bottom: 1px dashed #000;
         font-weight: 900;
         }

         table tr {
          font-weight: 500;
         }

         td {
          padding-top:10px;
          padding-bottom:10px;
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
         }

         .company-logo {
            width: 150px;
            padding: 10px;
         }
      </style>
   </head>
   <body>

      <!-- Head Section Starts Here -->
            <center>
         $logo_html
         <br>
         <b><span style="font-size: 35px;">$companyName</span></b>
         <br>
         <font size="6">
            $companyAddress1
            <br>
            $companyCountry
            <br>
            <label>Gst Number : $companyTax</label>
            <br>
            <label>$companyPhone</label>
            <br><br>
            <u>$invoiceType</u>
            <br>
            <hr>
         </font>
      </center>

      <table class="subsection-table">
        <tr>
          <td style="font-size: 20px;">Token No</td>
          <td style="text-align: right; font-size: 23px;">$token</td>
        </tr>

         <tr>
          <td style="font-size: 20px;">Voucher No</td>
          <td style="text-align: right; font-size: 23px;">$voucherNumber</td>
        </tr>
        <tr>
          <td style="font-size: 20px;">Date</td>
          <td style="text-align: right; font-size: 23px;">$date</td>
        </tr>
        <tr>
          <td style="font-size: 20px;">Name</td>
          <td style="text-align: right; font-size: 23px;">$name</td>
        </tr>
      <!--  <tr>
          <td style="font-size: 20px;">Gst Number</td>
          <td style="text-align: right; font-size: 23px;">customerVatNumber</td>
        </tr>
        -->
        $phone_html
      </table>
      <div class="line-1"></div>
      <!-- Sub Section Ends Here -->
      <!-- Item Section Starts Here -->
      $printItems
      <!-- Item Section Ends Here -->
      <!-- Total Section Starts Here -->
      <font size="5">
         <div style="height: 15px; border-top: 2px solid black;"></div>

        <!-- <div class="leftToright">
            <label>Total Quantity </label>
            <label>totalQty</label>
         </div>
         -->

         <div class="leftToright">
            <label>Gross Amount </label>
            <label>$grossAmount</label>
         </div>

         <div class="leftToright">
            <label>Discount </label>
            <label>$discount</label>
         </div>
         $additionalTaxSection
         <div class="leftToright">
            <label>Total Tax </label>
            <label>$totalTax</label>
         </div>
      </font>
      <!-- Total Section Ends Here -->
      <div style='border-top: 2px solid black;'></div>
      <!-- Grand Total Section Starts Here -->
      <font size="6">
         <b>
            <div class="leftToright" style='margin: 10px 10px;'>
               <label>Grand Total </label>
               <label>$countyCodeCompany $grandTotal</label>
            </div>
         </b>
      </font>
      <!-- Grand Total Section Ends Here -->
      <div class="line-1"></div>

      <center>
         <font size="4">
         <br>
         </font>
      </center>
      <br>
   </body>
</html>""";
    return print_details;
  }
}