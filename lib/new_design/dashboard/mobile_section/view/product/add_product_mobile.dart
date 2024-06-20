import 'package:file/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';

import '../../controller/product_controller.dart';
import 'detail_page/select_group.dart';
import 'detail_page/select_tax_mobile.dart';

import 'package:flutter_svg/svg.dart';

class CreateProductMobile extends StatefulWidget {
  String? uid;
  String? type;
  CreateProductMobile({this.uid,this.type});
  @override
  State<CreateProductMobile> createState() => _CreateProductMobileState();
}

class _CreateProductMobileState extends State<CreateProductMobile> {

  ProductController productController = Get.put(ProductController());

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

 loadData(){
  if(widget.type=="Edit"){
    productController.getProductSingleView(widget.uid!);
  }else{

  }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add a Product',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {

                if (productController.productNameController.text.isEmpty ||
                    productController.salesPriceController.text.isEmpty ||
                    productController.purchasePriceController.text.isEmpty ||
                    productController.groupController.text.isEmpty) {
                  Get.snackbar('Error', "Please fill in all required fields");


                }else{
                  if(widget.type=="Edit"){
                    print("ghdfdhfhghf");
                    productController.editProduct(widget.uid!);
                  }
                  else{
                    if(productController.createPermission){
                      productController.createProduct();
                    }else{
                      Get.snackbar('Error', "Permission Denied");
                    }
                  }


                }
                },
                icon: Text(
                  "Save",
                  style: customisedStyle(
                      context, Color(0xffF25F29), FontWeight.w400, 14.0),
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: ListView(
          children: [
            DividerStyle(),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffFFF6F2)),
                      color: Color(0xffFFF6F2),
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  height: MediaQuery.of(context).size.height / 7,
                  width: MediaQuery.of(context).size.width / 4,
                  child: productController.imageSelect == true
                      ? productController.displayImage()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  productController.type = 1;
                                  productController.showOptionsDialog(context);
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xffF25F29),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: productController.isVegNotifier,
                    builder: (context, isVegValue, child) {
                      return GestureDetector(
                        onTap: () {
                          productController.isVegNotifier.value =
                              !isVegValue; // Toggle the value
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffDBDBDB)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/veg_mob.svg",
                                  color: isVegValue
                                      ? const Color(0xff00775E)
                                      : const Color(0xffDF1515),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'veg_only'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff585858),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: productController.isNonVegNotifier,
                    builder: (context, isNonVeg, child) {
                      return GestureDetector(
                        onTap: () {
                          productController.isNonVegNotifier.value =
                              !isNonVeg; // Toggle the value
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xffDBDBDB)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 4, bottom: 4),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/veg_mob.svg",
                                  color: isNonVeg
                                      ? Color(0xff00775E)
                                      : const Color(0xffDF1515),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Non Veg',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff585858),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.productNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: productController.nameFCNode,
              onEditingComplete: () {
                if(productController.productNameController.text !=""){
                  if(productController.isGst ==false){
                    productController.convertToArabic( name: productController.productNameController.text,);
                  }
                  else{
                    productController.descriptionController.text = productController.productNameController.text;
                  }
                }
                FocusScope.of(context).requestFocus(productController.descriptionFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.descriptionController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),

              focusNode: productController.descriptionFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.categoryFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Description'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.groupController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // /focusNode: nameFCNode,
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SelectGroupMobile()),
                );

                if (result != null) {
                  productController.groupID   = result[0];
                  productController.groupController.text = result[1];
                }
              },
              focusNode: productController.categoryFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.priceFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Group'),
            ),

            SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.salesPriceController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
              ],
              onTap: () => productController.salesPriceController.selection = TextSelection(baseOffset: 0, extentOffset: productController.salesPriceController.value.text.length),
              focusNode: productController.priceFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.purchasePriceFcNode);
              },
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Sales Price'),
            ),
            SizedBox(
              height: 10,
            ),  TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.purchasePriceController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
              ],

              onTap: () => productController.purchasePriceController.selection =
                  TextSelection(baseOffset: 0, extentOffset: productController.purchasePriceController.value.text.length),
              focusNode: productController.purchasePriceFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.taxFCNode);
              },
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Purchase Price'),
            ),    SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.taxPriceController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // /focusNode: nameFCNode,
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectTaxMobile(taxType: '1',)),
                );

                if (result != null) {
                  productController.taxID   = result[0];
                  productController.taxPriceController.text = result[1];
                }
              },
              focusNode: productController.taxFCNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.saveFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Tax'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height:
                  MediaQuery.of(context).size.height / 17, //height of button
              // child: paidList(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: MediaQuery.of(context).size.height /
                        18, //height of button
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text('Inclusive Tax',
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w500, 14.0)),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: MediaQuery.of(context).size.height /
                        18, //height of button
                    width: MediaQuery.of(context).size.width / 7,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: productController.isInclusiveTax,
                      builder: (context, value, child) {
                        return FlutterSwitch(
                          width: 40.0,
                          height: 20.0,
                          valueFontSize: 30.0,
                          toggleSize: 15.0,
                          value: value,
                          borderRadius: 20.0,
                          padding: 1.0,
                          activeColor: const Color(0xffF25F29),
                          activeTextColor: Colors.green,
                          toggleColor: const Color(0xffffffff),
                          inactiveTextColor: Color(0xffffffff),
                          inactiveColor: const Color(0xffD9D9D9),
                          onToggle: (val) {
                            productController.isInclusiveTax.value = val;
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            productController.isExcise?  const SizedBox():TextField(
              textCapitalization: TextCapitalization.words,
              controller: productController.execiveTaxPriceController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // /focusNode: nameFCNode,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectTaxMobile(taxType: '2',)),
                );

                if (result != null) {
                  productController.execiveID   = result[0];
                  productController.execiveTaxPriceController.text = result[1];
                }
              },
              focusNode: productController.taxFCNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productController.saveFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Execive Tax'),
            ),
          ],
        ),
      ),
    );
  }
}
