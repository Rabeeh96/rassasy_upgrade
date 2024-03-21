



import 'package:rassasy_new/new_design/dashboard/pos/new_method/model/model_class.dart';

class ThermalEnglishDesignKot {
  static String getInvoiceContent(id,data,width) {
    List<PrintDetails> printListData = [];
    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();

      for (Map user in data) {
         dataPrint.add(ItemsDetails.fromJson(user));
      }



    var kitchenName = printListData[id].kitchenName;
    var totalQty = printListData[id].totalQty;
    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI;


    var printItems = """<table>
         <thead style='border-bottom: 1px solid black;'>
            <tr> 
               <th style="width: 10%;font-size: 50px">SL</th>
               <th style="width: 70%;font-size: 50px">Product</th>
               <th class="textCenter" style="width: 20%;font-size: 50px">Qty</th>
            </tr>
         </thead>
         <tbody>""";

    for (var i=0; i<dataPrint.length; i++) {
      printItems += """<tr>
               <td style='font-size: 50px;font-weight: 600;'>${i+1}</td>
               <td style='font-weight: 600;'><font size="7">${dataPrint[i].productName}</font></td>
               <td class="textCenter">${dataPrint[i].qty}</td>
            </tr>""";
    }
    printItems += """
         </tbody>
      </table>""";


    var print_details = """<html>
   <head>
      <style>
         html, body {
          width: $width;
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
         border-bottom: 2px dashed #000;
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
         font-size: 50px;
         font-weight: 800
         }
         .textRight {
         text-align: right;
         }
         .line-1 {
          border-top: 2px dashed black;
          width: 100%;
          height: 10px;
          margin-top: 10px;
         }

         .subsection-table td{
            padding: 5px;
            font-size: 50px;
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
         <b><span style="font-size: 60px;">Kitchen Print</span></b>
         <br><br>
      </center>

      <table class="subsection-table">
        <tr>
          <td>Token No</td>
          <td>$tokenNumber</td>
        </tr>

         <tr>
          <td style="font-size: 50px;">Kitchen Name</td>
          <td style="font-size: 50px;">$kitchenName</td>
        </tr>
        <tr>
          <td style="font-size: 50px;">Order Type</td>
          <td style="font-size: 50px;">$orderType</td>
        </tr>

      </table>
      <div class="line-1"></div>
      <!-- Sub Section Ends Here -->
      <!-- Item Section Starts Here -->
      $printItems
      <!-- Item Section Ends Here -->
      <!-- Total Section Starts Here -->

      <div class="line-1"></div>
      
     
      <!-- Grand Total Section Starts Here -->
      <font size="6">
         <b>
            <div class="leftToright" style='margin: 10px 10px;"font-size: 50px;'>
               <label style='font-size: 50px;font-weight: 600;'>Total Quantity </label>
               <label style='font-size: 50px;font-weight: 600;'>$totalQty</label>
            </div>
         </b>
      </font>
      <!-- Grand Total Section Ends Here -->
      <div class="line-1"></div>
      <div class="line-1"></div>
   </body>
</html>""";
    return print_details;
  }
}