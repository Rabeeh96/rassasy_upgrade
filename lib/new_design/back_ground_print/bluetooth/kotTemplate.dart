import 'back_ground_print_bt.dart';

class ThermalEnglishDesignKot {
  static String getInvoiceContent(id,data) {
    // var data;
    print("kot---------------------************************************************-+++++++++++++++++++++++++++++++++++++++");

    // print(printListData[id].items);

    List<ItemsDetails> dataPrint = [];
    dataPrint.clear();
    // data = printListData[id].items;
    print("/*/*/*/*/*");
    print(data);
    print("*-*-*-*-*-*-*");
    print("//////data length///////////");
    print(data.length);
    print("//////data length///////////");
    for (Map user in data) {
      print("00000000000000000");
      dataPrint.add(ItemsDetails.fromJson(user));
    }



    var kitchenName = printListData[id].kitchenName;
    var totalQty = printListData[id].totalQty;
    var tokenNumber = dataPrint[0].tokenNumber;
    var orderType = dataPrint[0].orderTypeI;


    var printItems = """<table>
         <thead style='border-bottom: 1px solid black;'>
            <tr>
               <th style="width: 10%;">SL</th>
               <th style="width: 70%;">Product</th>
               <th class="textCenter" style="width: 20%;">Qty</th>
            </tr>
         </thead>
         <tbody>""";

    for (var i=0; i<dataPrint.length; i++) {
      printItems += """<tr>
               <td>${i+1}</td>
               <td><font size="5">${dataPrint[i].productName}</font></td>
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
         <b><span style="font-size: 40px;">Kitchen Print</span></b>
         <br><br>
      </center>

      <table class="subsection-table">
        <tr>
          <td style="font-size: 25px;">Token No</td>
          <td font-size: 25px;">$kitchenName</td>
        </tr>

         <tr>
          <td style="font-size: 25px;">Kitchen Name</td>
          <td style="font-size: 25px;">$tokenNumber</td>
        </tr>
        <tr>
          <td style="font-size: 25px;">Order Type</td>
          <td style="font-size: 25px;">$orderType</td>
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
            <div class="leftToright" style='margin: 10px 10px;'>
               <label>Total Quantity </label>
               <label>$totalQty</label>
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