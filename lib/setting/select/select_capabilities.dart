import 'dart:convert';
import 'package:flutter/material.dart' hide Image;
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';




class SelectCapabilities extends StatefulWidget {
  @override
  _SelectCapabilitiesState createState() => _SelectCapabilitiesState();
}

class _SelectCapabilitiesState extends State<SelectCapabilities> {



  TextEditingController code_page_controller = TextEditingController();

  @override
  void initState() {
    super.initState();

  }



    @override
  void dispose() {
    super.dispose();
    stop();
  }

  List<String> printerModels = [
    "default",
    "XP-N160I",
    "RP80USE",
    "AF-240",
    "CT-S651",
    "NT-5890K",
    "OCD-100",
    "simple",
    "OCD-300",
    "P822D",
    "POS-5890",
    "RP326",
    "SP2000",
    "ZKP8001",
    "TP806L",
    "Sunmi-V2",
    "TEP-200M",
    "TM-P80",
    "TM-P80-42col",
    "TM-T88II",
    "TM-T88III",
    "TM-T88IV",
    "TM-T88IV-SA",
    "TM-T88V",
    "TM-U220",
    "TSP600",
    "TUP500",
    "ZJ-5870",
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ), //

          title:   Text(
            'select_capability'.tr,
            style:  customisedStyle(context, Colors.black, FontWeight.w600, 20.0)

          ),
          backgroundColor: Colors.grey[300],

      ),


      body: Center(
        child: Container(

            height: MediaQuery.of(context).size.height / 1, //height of button
            width: MediaQuery.of(context).size.width / 3,
            color: Colors.grey[100],
            // color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all (20.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: printerModels.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                          title:  Text(printerModels[index],style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),),
                          onTap: () async {

                         //   print(printerModels[index]);
                             Navigator.pop(context, printerModels[index]);
                          },
                        )
                    );
                  }
              ),
            ),))

    );
  }






  bool Check(String text) {

    var val = false;
    bool both = true;
    if (text.contains(RegExp(r'[A-Z,a-z]'))) {
      for (int i = 0; i < text.length;) {
        int c = text.codeUnitAt(i);
        if (c >= 0x0600 && c <= 0x06FF || (c >= 0xFE70 && c <= 0xFEFF)) {
          both = false;
          return both;
        }
        else {
          both = true;
          return both;
        }
      }
    }
    else {
      val = false;
      for (int i = 0; i < text.length; i++) {
        if (val = double.tryParse(text[i]) != null) {
          if (val == true) {
            both = false;
          } else {
            both = true;
          }
          return both;
        }
      }

      // both = true;
    }
    print('result of check $both');

    return both;
  }

  setString(String tex) {
    if(tex ==""){

    }

    String value = "";
    try {
      var listSplit = [];
      var beforeSplit = [];

      if (Check(tex)) {
        beforeSplit = set(tex);
        listSplit = beforeSplit.reversed.toList();
      } else {
        listSplit = set(tex);
      }
      for (int i = 0; i < listSplit.length; i++) {
        if (listSplit[i] == null)
          value += "";
        else if (isArabic(listSplit[i])) {
          if (value == "")
            value += listSplit[i];
          else value += "" + listSplit[i];
        } else if (isN(listSplit[i])) {
          if (value == "")
            value += listSplit[i].toString().split('').reversed.join();
          else
            value += "" + listSplit[i].toString().split('').reversed.join();
        }
        else {
          if (value == "")
            value += listSplit[i].toString().split('').reversed.join();
          else
            value += "" + listSplit[i].toString().split('').reversed.join();
        }
      }
    } catch (e) {
      return e.toString();
    }
    return value;
  }

  returnBlankSpace(length){
    List<String> list = [];
    for (int i = 0; i < length; i++) {
      list.add('');

    }
    return list;
  }
  set(String str) {

    try{
      if(str ==""){

      }


      var listData = [];
      List<String> test = [];

      List<String> splitA = str.split('');
      test  = returnBlankSpace(splitA.length);


      // test.length = splitA.length;


      if (str.contains('')) {
        for (int i = 0; i < splitA.length; i++) {
          test[i] = splitA[splitA.length - 1 - i];
          print(splitA);
        }
        splitA = test;
      }

      listData.length = splitA.length;
      bool ar = false;
      int index = 0;

      for (int i = 0; i < splitA.length; i++) {
        if(isArabic(splitA[i])) {
          if (ar) {
            if (listData[index] == null)
              listData[index] = splitA[i];
            else
              listData[index] += "" + splitA[i];
          } else {
            if (listData[index] == null)
              listData[index] = splitA[i];
            else {
              index++;
              listData[index] = splitA[i];
            }
          }
          ar = true;
        }
        else if (isEnglish(splitA[i])) {
          if (!ar) {
            if (listData[index] == null)
              listData[index] = splitA[i];
            else
              listData[index] += "" + splitA[i];
          }
          else {
            index++;
            listData[index] = splitA[i];
          }
          ar = false;
        }
        else if (isN(splitA[i])) {
          if (!ar) {
            if (listData[index] == null)
              listData[index] = splitA[i];
            else
              listData[index] += "" + splitA[i];
          } else {
            index++;
            listData[index] = splitA[i];
          }
          ar = false;
        }
      }



      return listData;
    }


    catch(e){
      print("set function error ${e.toString()}");

    }

  }
  bool isArabic(String text) {
    if(text ==""){

    }

    String arabicText = text.trim().replaceAll(" ", "");
    for (int i = 0; i < arabicText.length;) {
      int c = arabicText.codeUnitAt(i);
      //range of arabic chars/symbols is from 0x0600 to 0x06ff
      //the arabic letter 'لا' is special case having the range from 0xFE70 to 0xFEFF
      if (c >= 0x0600 && c <= 0x06FF || (c >= 0xFE70 && c <= 0xFEFF))
        i++;
      else
        return false;
    }
    return true;
  }
  bool isEnglish(String text) {
    if(text ==""){

    }

    bool onlyEnglish = false;

    String englishText = text.trim().replaceAll(" ", "");
    if (englishText.contains(RegExp(r'[A-Z,a-z]'))) {
      onlyEnglish = true;
      print(onlyEnglish);
    } else {
      onlyEnglish = false;
      print(onlyEnglish);
    }
    return onlyEnglish;
  }
  bool isN(String value) {
    if(value ==""){
      print("str is nll");
    }
    var val = false;
    val = double.tryParse(value) != null;
    return val;
  }

  getBytes(int id,value) {
    if(value ==""){

    }
    int datas = value.length;
    Uint8List va = Uint8List(2+datas);
    va[0] = id;
    va[1] = value.length;

    for (var i = 0; i < value.length; i++) {
      va[2+i]= value[i];
    }
    return va;
  }
  b64Qrcode(customer,vatNumber,dateTime,invoiceTotal,vatTotal){

    List<int> newList1 = [];
    var data = [utf8.encode(customer),utf8.encode(vatNumber),utf8.encode(dateTime),utf8.encode(invoiceTotal),utf8.encode(vatTotal)];
    print(data.runtimeType);
    for(var i = 0;i<data.length ;i++){
      List<int> dat = List.from(getBytes(i+1, data[i]));
      newList1 = newList1+dat;
    }

    var res = base64Encode(newList1);
    print(res);
    return res;

  }
/// new method


}
List<ProductDetailsModel> printDalesDetails = [];
class ProductDetailsModel {
  final String unitName, qty, netAmount, productName, unitPrice, productDescription;

  ProductDetailsModel({
    required this.unitName,
    required this.qty,
    required this.netAmount,
    required this.productName,
    required this.unitPrice,
    required this.productDescription,
  });

  factory ProductDetailsModel.fromJson(Map<dynamic, dynamic> json) {
    return  ProductDetailsModel(
      unitName: json['UnitName'],
      qty: json['quantityRounded'].toString(),
      netAmount: json['netAmountRounded'].toString(),
      productName: json['ProductName'],
      unitPrice: json['unitPriceRounded'].toString(),
      productDescription: json['ProductDescription'],
    );
  }
}

