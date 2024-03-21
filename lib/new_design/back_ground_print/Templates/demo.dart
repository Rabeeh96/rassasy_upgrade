

class Demoaaaaa {

  static String invoiceDesign() {

    var logoAvailable = true;
    var productDecBool = true;
    var isInvoice = true;
    var qrCodeAvailable = false;

    var invoiceType;
    var invoiceTypeArabic;

    invoiceType = "SIMPLIFIED TAX INVOICE";
    invoiceTypeArabic = "(فاتورة ضريبية مبسطة)";



    print("---------------------------");
    print(qrCodeAvailable);
    print(qrCodeAvailable);
    print("---------------------------");

    var companyName = ".companyName";
    var companyAddress1 = "buildingNumberCompany";
    // var companyAddress2 = BluetoothPrintThermalDetails.address2Company;
    var companyCountry = "countryNameCompany";
    var companyPhone = "phoneCompany";
    var companyTax = "vatNumberCompany";
    var companyCrNumber = "cRNumberCompany";
    var countyCodeCompany ="countyCodeCompany";
    var qrCodeData = "qrCodeImage";

    var voucherNumber = "1284";
    var name = "nme";
    var date = "235/8/2022";
    var phone ="2584684698468";
    var grossAmount = "5874";
    var discount = "5874";
    var totalTax = "5874";
    var grandTotal = "1235";
    var token = "tokenNumber";
    // var cashReceived = BluetoothPrintThermalDetails.cashReceived;
    // var bankReceived = BluetoothPrintThermalDetails.bankReceived;
    // var balance = BluetoothPrintThermalDetails.balance;
    // var salesOrderNo = BluetoothPrintThermalDetails.salesOrderNo;
    // var saleType = BluetoothPrintThermalDetails.salesType;
    //
    var salesOrderNo = "SO125";
    var cashReceived = "0.00";
    var bankReceived = "0.00";
    var balance = "0.00";
    var orderType = "Dining";

    var typeOfOrder = """""";
    typeOfOrder = """
        <tr>  <td colspan="2">$orderType</td> </tr>""";

    var orderVoucher = """""";
    var footerDetails = """""";
    if (isInvoice) {
      footerDetails = """ <b>


    <div class="leftToright">
    <label>Cash received (استلام النقود)</label>
    <label>$cashReceived</label>
    </div>

    <div class="leftToright">
    <label>Bank received (البنك المستلم)</label>
    <label>$bankReceived</label>
    </div>

    <div class="leftToright">
    <label>Balance (الرصيد)</label>
    <label>$balance</label>
    </div>
  <div class="line-1"></div>
    </b>""";

      orderVoucher = """  <tr>
          <td style="font-size: 20px;">Sales order No</td>
          <td style="text-align: center; font-size: 23px;">$salesOrderNo</td>
          <td style="text-align: right;">رقم طلب المبيعات</td>
        </tr>""";
    }

    var printHead = """<table style="margin-bottom:unset">
         <thead>
            <tr>
             <!-- <th class="textCenter">SL<br><font size="5">(رقم)</font></th>  -->
               <th style="width: 65%; padding:0px 15px">Product Name<br><font size="5">(اسم المنتج)</font></th>
               <th class="textRight" style="width: 17%; padding:0px 15px">Qty<br><font size="5">(كمية)</font></th>
               <th class="textRight" style=" padding:0px 15px">Net<br><font size="5">(مجموع)</font></th>
            </tr>
         </thead>
         <tbody>""";

    var printItems = """<table>
         <thead>
            <tr>
            
         </tr>
         </thead>
         <tbody>""";

    for (var i = 0; i < 1; i++) {
      var productName = "product name";
      if (productName.length > 40) {
        productName = productName.substring(0, 23);
      }

      printItems +=
      """<tr class="pd-2">
                 <td class="textLeft noPadding" colspan="5">(${i + 1}) $productName</td>

            </tr>""";

      printItems += """<tr>

               <td style="width: 65%;  padding:0px 15px"><span style="font-weight: 600;font-size: 23px;">productDescription</span></td>
               <td class="textRight" style="width: 17% ;  padding:0px 15px" >qty</td>
               <td class="textRight" style='font-weight: 800;  padding:0px 15px'>netAmount</td>

            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";

    var print_details = """<html>
   <head>
      <style>
         html, body {
         width: 200mm;
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
         width: 100%;
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


.parent {
	display: flex;
    justify-content: space-between
}
.parent-column {
	display: flex;
    flex-direction: column;
    justify-content: space-between
}
.round {
	border: 2px solid black;
    padding: 10px;
    border-radius: 10px;
}
.third {
	font-size: 20px;
    font-weight: 600;
      padding-right: 10px;
}

.b-right {
    line-height: 15px;
	  border: none;
    text-align: right;
    padding-right: 15px
}
.w-25 {
 width: 30%
}
.bold {
	font-weight: bold;
    font-size:18px
}
.footer
{
    line-height: 15px;
}

      </style>
   </head>
   <body>

      <!-- Head Section Starts Here -->
      <center>
      <table class="head-table" cellpadding="0" cellspacing="0" border="0">

  <tr>
    <td colspan="2" style='font-size: 30px;'>$companyName</td>
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
  </table>
  </center>

 
    <div class="parent">
	<div class="child parent-column">
    	<div>Inv No:$voucherNumber</div>
    	<div>$date</div>
    	<div>3.55</div>
    </div>
	<div class="child parent-column">
    	<div></div>
    	<div class="round">$token</div>
    	<div></div>
    </div>
	<div class="child parent-column">
    	<div></div>
    	<div class="third">$typeOfOrder</div>
    	<div></div>
    </div>
    
    
      </div>
       <div class="line-1"></div>
 
      $printHead
      $printItems

         <div style="height: 15px; border-top: 3px solid black;"></div>


     
         <table style="width:100%;border: none margin-bottom:unset">
             
              <tr>
                <td class="b-right">Gross total/المبلغ الإجمالي</td>
                <td class="b-right w-25">$grossAmount</td>
              </tr>
                     
              <tr>
                <td class="b-right">Discount/خصم</td>
                <td class="b-right w-25">$discount</td>
              </tr>
                      <tr>
                <td class="b-right">Total tax/مجموع الضريبة</td>
                <td class="b-right w-25">$totalTax</td>
              </tr>
                     
              <tr>
                <td class="b-right">Grand total/المبلغ الإجمالي</td>
                <td class="b-right w-25 bold">$grandTotal</td>
              </tr>
             
            </table> 
            <div style='border-top: 2px solid black;'></div>
  <br>
   </body>
</html>""";
    return print_details;
  }
}