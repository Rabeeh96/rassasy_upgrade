import 'package:rassasy_new/Print/bluetoothPrint.dart';
import 'package:rassasy_new/global/global.dart';

class ArabicThermalPrint {
  static String getInvoiceContent(width) {
    List<ProductDetailsModelOld> tableDataDetailsPrint = [];

    var salesDetails = BluetoothPrintThermalDetails.salesDetails;
    print(salesDetails);
    for (Map user in salesDetails) {
      tableDataDetailsPrint.add(ProductDetailsModelOld.fromJson(user));
    }

    var logoAvailable = true;
    var productDecBool = true;
    var qrCodeAvailable = true;

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
      invoiceType = "ORDER";
      invoiceTypeArabic = "(طلب المبيعات)";
    }

    print("---------------------------");
    print(qrCodeAvailable);
    print(qrCodeAvailable);
    print("---------------------------");

    var companyName = BluetoothPrintThermalDetails.companyName;
    var companyAddress1 = BluetoothPrintThermalDetails.buildingNumber;
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
               <th class="textCenter"><font size="6">SL<br><font size="7">(رقم)</font></th>
               <th style="width: 30%;"><font size="6">Product Name<br><font size="7">(اسم المنتج)</font></th>
               <th class="textCenter" style="width: 15px;"><font size="6">Qty<br><font size="7">(كمية)</font></th>
               <th class="textRight"><font size="6">Rate<br><font size="7">(معدل)</font></th>
               <th class="textRight"><font size="6">Net<br><font size="7">(مجموع)</font></th>
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
               <td class="textCenter"><font size="7">${i + 1}</td>
               <td style='font-weight: 800;'><font size="7">${tableDataDetailsPrint[i].productName}$productDesc</font></td>
               <td class="textCenter style='font-weight: 800;"><font size="7">${roundStringWith(tableDataDetailsPrint[i].qty)}</td>
               <td class="textRight style='font-weight: 800;"><font size="7">${roundStringWith(tableDataDetailsPrint[i].unitPrice)}</td>
               <td class="textRight" style='font-weight: 800;'><font size="7">${roundStringWith(tableDataDetailsPrint[i].netAmount)}</td>
               
            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";

    var logoHtml = """""";

    if (logoAvailable == true && companyLogo != "") {
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
       
      """;
    }

    var phone_customer = """""";

    if (phone != "") {
      phone_customer = """
        <tr>
          <td style="font-size: 50px;;">Phone</td>
          <td style="text-align: center; font-size: 50px;">$phone</td>
          <td style="text-align: right;font-size: 50px;">هاتف</td>
        </tr>
      """;
    }

    var companyAddressTag = """""";

    if (companyAddress1 != "") {
      companyAddressTag = """
        <tr>
    <td colspan="2" style='font-size: 50px;'>$companyAddress1</td>
    </tr>
      """;
    }

    var companyTaxTag = """""";

    if (companyTax != "") {
      companyTaxTag = """
        <tr>
    <td style='font-size: 45px;' >$companyTax</td>
    <td style='font-size: 45px;'>الرقم الضريبي</td>
    </tr>
      """;
    }

    var companyCrNumberTag = """""";

    if (companyCrNumber != "") {
      companyCrNumberTag = """
       <tr>
    <td style='font-size: 45px;'>$companyCrNumber</td>
    <td style='font-size: 45px;'>س. ت</td>
    </tr>
      """;
    }
    var companyPhoneTag = """""";

    if (companyPhone != "") {
      companyPhoneTag = """
       <tr >
    <td colspan="2" style='font-size: 45px;'>$companyPhone</td>
    </tr>
    <tr>
      """;
    }

    //

    var print_details = """<html>
   <head>
      <style>
         html, body {
         width: $width;
         position:absolute;
         font-weight: 600;
         }
         .leftToright {
         display: flex;
         justify-content: space-between;
         margin-left: 10px;
         margin-right: 10px;
         font-weight: 600;
         font-size: 50px;
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
            width: 230px;
         
       
         }
         .qrCodeImage {
            width: 400px;
     
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

      <center>
        
         <table class="head-table" cellpadding="0" cellspacing="0" border="0">
      $logoHtml
  <tr>
    <td colspan="2" style='font-size: 55px;'>$companyName</td>
  </tr>

  
$companyAddressTag
$companyTaxTag
$companyCrNumberTag
$companyPhoneTag
  
  

  <tr>
    <td colspan="2" style='font-size: 45px;'>$invoiceType</td>
  </tr>
  <tr>
    <td colspan="2" style='font-size: 45px;'>$invoiceTypeArabic</td>
  </tr>
</table>
      </center>

      <table class="subsection-table">
        <tr>
          <td style="font-size: 50px;">Token No</td>
          <td style="text-align: center; font-size: 50px;">$token</td>
          <td style="text-align: right;font-size: 50px;">رقم الرمز</td>
        </tr>   
           <tr>
          <td style="font-size: 50px;">Voucher No</td>
          <td style="text-align: center; font-size: 50px;">$voucherNumber</td>
          <td style="text-align: right;font-size: 50px;">رقم الفاتورة</td>
        </tr>
        
        <tr>
        
          <td style="font-size: 50px;;">Date</td>
          <td style="text-align: center; font-size: 50px;">$date</td>
          <td style="text-align: right;font-size: 50px;">تاريخ</td>
        </tr>
        <tr>
        
          <td style="font-size: 50px;;">Name</td>
          <td style="text-align: center; font-size: 50px;;">$name</td>
          <td style="text-align: right;font-size: 50px;">اسم</td>
        </tr>
  
        $phone_customer

        
      </table>
      <div class="line-1"></div>

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
 
      <div style='border-top: 2px solid black;'></div>
      <!-- Grand Total Section Starts Here -->
         <b>
            <div class="leftToright" style='margin: 10px 10px; font-size: 50px; font-weight: 900;'>
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
