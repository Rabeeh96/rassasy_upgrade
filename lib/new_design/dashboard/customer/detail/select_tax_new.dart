
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class SelectTaxNew extends StatefulWidget {
  const SelectTaxNew({Key? key}) : super(key: key);

  @override
  State<SelectTaxNew> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<SelectTaxNew> {
  @override
  void initState() {
    checkTaxType();
    super.initState();
  }

  bool taxType = false;
  var vat = [
    { "value": "0", "name": "Business to Business(B2B)"},
    { "value": "1", "name": "Business to Customer(B2C)"},

  ];
  var gst = [
    { "value": "0", "name": "Registered Business - Regular"},
    { "value": "1", "name": "Registered Business - Composition"},
    { "value": "2", "name": "Unregistered Business"},
    { "value": "3", "name": "Consumer"},
    { "value": "4", "name": "Overseas"},
    { "value": "5", "name": "Special Economic Zone"},
    { "value": "6", "name": "Deemed Export"},
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          //
          title:  Text(
            'tax_type'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 23,
            ),
          ),
          backgroundColor: Colors.grey[300],
          actions: <Widget>[
            IconButton(
                icon: SvgPicture.asset('assets/svg/sidemenu.svg'),
                onPressed: () {}),
          ]),
      body: Container(
          height:
          MediaQuery
              .of(context)
              .size
              .height / 1, //height of button
          // width: MediaQuery.of(context).size.width / 1.1,
          color: Colors.grey[100],
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: treatmentModel.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    child: ListTile(
                      title: Text(treatmentModel[index].treatmentName),
                      onTap: () async {
                        //  ProductData.taxID=treatmentModel[index].taxId;
                        Navigator.pop(context, [treatmentModel[index].treatmentValue,treatmentModel[index].treatmentName]);
                      },
                    ));
              })),
    );
  }

  checkTaxType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? gstType = prefs.getBool("check_GST");
    bool? vatType = prefs.getBool("checkVat");
    if (taxType == true) {
      vatType == false;
      setState(() {
        treatmentModel.clear();
        for (Map user in gst) {
          treatmentModel.add(TreatmentModel.fromJson(user));
        }
      });
    } else if (taxType == false) {
      gstType == false;
      setState(() {
        treatmentModel.clear();
        for (Map user in vat) {
          treatmentModel.add(TreatmentModel.fromJson(user));
        }
      });
      print("gstType");
      print(gstType);
    } else {
     dialogBox(context, "No Treatment");
    }
  }

}


List<TreatmentModel> treatmentModel = [];

class TreatmentModel {
  String treatmentValue,treatmentName;

  TreatmentModel({
    required this.treatmentValue,
    required this.treatmentName,
  });

  factory TreatmentModel.fromJson(Map<dynamic, dynamic> json) {
    return TreatmentModel(
      treatmentValue: json['value'],
      treatmentName: json['name'],
    );
  }
}