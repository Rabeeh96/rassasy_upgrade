class Demotest {
  static String getInvoiceContent() {

    var companyName = "Vikn Codes";
    var companyAddress1 = "Poonoor";
    var companyAddress2 = "Calicut";
    var companyCountry = "India";
    var companyPhone = "9876543210";
    var companyTax = "1234567890";
    var invoiceType = "SIMPLIFIED TAX INVOICE";
    var invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";
    var voucherNumber = "SI001";
    var name = "Rabeeh";
    var date = "16-12-2021";
    var phone = "8714152075";
    var grossAmount = "250.00";
    var discount = "10.00";
    var totalTax = "20.00";
    var grandTotal = "90.00";

    var printItems = """<table>
         <thead style='border-bottom: 1px solid black;'>
            <tr>
               <th class="textCenter">SL<br><font size="4">(رقم)</font></th>
               <th style="width: 30%;">Product Name<br><font size="4">(اسم المنتج)</font></th>
               <th class="textCenter" style="width: 10px;">Qty<br><font size="4">(كمية)</font></th>
               <th class="textRight">Rate<br><font size="4">(معدل)</font></th>
               <th class="textRight">Net<br><font size="4">(المبلغ الإجمالي)</font></th>
            </tr>
         </thead>
         <tbody>""";

    var items = [
      {"productName": "Coffee","qty": "1","rate": "10.00", "net": "10.00"},
      {"productName": "Tea","qty": "10","rate": "10.00", "net": "100.00"},
      {"productName": "Maggi","qty": "10","rate": "10.00", "net": "100.00"},
      {"productName": "مانجو","qty": "1","rate": "105.00", "net": "105.00"},
      {"productName": "قهوة باردة","qty": "2","rate": "20.00", "net": "40.00"},
    ];



    for (var i=0; i<3; i++) {
      printItems += """<tr>
               <td class="textCenter">$i+1</td>
               <td>Coffee<br>(قلم باسكة)</td>
               <td class="textCenter">1</td>
               <td class="textRight">10</td>
               <td class="textRight">10</td>
            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";


    var print_details = """<html>
   <head>
      <style>
         html, body {
         width: 160mm;
         position:absolute;
         font-size: 30px;
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
         }
         table th {
         text-align: left;
         border-bottom: 1px dashed #000;
         }
         .textCenter {
         text-align: center;
         }
         .textRight {
         text-align: right;
         }
         .line-1 {
          border-top: 1px solid black;
          width: 100%;
          height: 10px;
          margin-top: 10px;
         }
      </style>
   </head>
   <body>
      <!-- Head Section Starts Here -->
      <center>
         <b><span style="font-size: 35px;">$companyName</span></b>
         <br>
         <font size="6">
            $companyAddress1
            <br>
            $companyAddress2
            <br>
            $companyCountry
            <br>
            <bdo>الرقم الضريبي : $companyTax</bdo>
            <br>
            <bdo>هاتف : $companyPhone</bdo>
            <br><br>
            <u>$invoiceType</u>
            <br>
            $invoiceTypeArabic
            <br>
            <hr>
         </font>
      </center>
      <!-- Head Section Ends Here -->
      <!-- Sub Section Starts Here -->
      <font size="5">
         <div class="leftToright">
            <label>Voucher No (رقم الفاتورة)</label>
            <label>$voucherNumber</label>
         </div>
         <div class="leftToright">
            <label>Date (تاريخ)</label>
            <label>$date</label>
         </div>
         <div class="leftToright">
            <label>Name (اسم)</label>
            <label>$name</label>
         </div>
         <div class="leftToright">
            <label>Phone (هاتف)</label>
            <label>$phone</label>
         </div>
      </font>
      <div class="line-1"></div>
      <!-- Sub Section Ends Here -->
      <!-- Item Section Starts Here -->
      $printItems
      <!-- Item Section Ends Here -->
      <!-- Total Section Starts Here -->
      <font size="5">
         <div class="leftToright" style='border-top: 1px solid black; padding: 5px 0px'>
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
      </font>
      <hr>
      <!-- Total Section Ends Here -->
      <div style='border-top: 1px solid black;'></div>
      <!-- Grand Total Section Starts Here -->
      <font size="5">
         <b>
            <div class="leftToright">
               <label>Grand Total (المبلغ الإجمالي)</label>
               <label>SAR $grandTotal</label>
            </div>
         </b>
      </font>
      <hr>
      <!-- Grand Total Section Ends Here -->
      <div class="line-1"></div>
      
      <center>
         <font size="4">
         <br>
         <b>Powered By ViknCodes</b>
         </font>
      </center>
      <br>
   </body>
</html>""";
    return print_details;
  }
}