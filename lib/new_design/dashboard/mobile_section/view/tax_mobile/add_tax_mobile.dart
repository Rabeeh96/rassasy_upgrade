import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/tax_controller.dart';

class AddTaxMobile extends StatefulWidget {
  @override
  State<AddTaxMobile> createState() => _AddTaxMobileState();
}

class _AddTaxMobileState extends State<AddTaxMobile> {
  TaxController taxController = Get.put(TaxController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Tax',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  if (taxController.taxNameController.text == "") {

                    Get.snackbar("Error", "Please enter tax name");

                  }

                  else {
                    if(taxController.salesPercentageController.text==''&&taxController.purchasePercentageController.text==''){

                      Get.snackbar("Error", "Please enter mandatory fields");
                    }else{
                      print("object");
                      print(taxController.isEdit);
                      if (taxController.isEdit.value) {
                        taxController.editTax(
                             taxController.taxUid.value);
                      } else {
                        taxController.createTax();
                      }
                    }

                  }
                },
                icon: Text(
                  'Save'.tr,
                  style: customisedStyle(
                      context, const Color(0xffF25F29), FontWeight.w400, 14.0),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            DividerStyle(),
            const SizedBox(
              height: 15,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: taxController.taxNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // focusNode: diningController.customerNode,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.text,
              decoration:
                  TextFieldDecoration.defaultTextField(hintTextStr: 'Tax Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: taxController.salesPercentageController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // focusNode: diningController.customerNode,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.defaultTextField(
                  hintTextStr: 'Sales Percentage'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: taxController.purchasePercentageController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // focusNode: diningController.customerNode,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.defaultTextField(
                  hintTextStr: 'Purchase Percentage'),
            ),
          ],
        ),
      ),
    );
  }
}
