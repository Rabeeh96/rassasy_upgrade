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
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/product_group_controller.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/view/product_group/detail/select_kitchen.dart';

import '../../controller/product_controller.dart';


import 'package:flutter_svg/svg.dart';

import 'detail/select_category.dart';

class CreateProductGroup extends StatefulWidget {
  String? uid;
  int? intID;
  String? type;
  CreateProductGroup({this.uid,this.type});
  @override
  State<CreateProductGroup> createState() => _CreateProductMobileState();
}

class _CreateProductMobileState extends State<CreateProductGroup> {

  ProductGroupController productGroupController = Get.put(ProductGroupController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData(){
    if(widget.type=="Edit"){
      productGroupController.getProductGroupSingleView(widget.uid!);
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
            'product_group'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {

                  if (productGroupController.groupNameController.text.isEmpty ) {
                    Get.snackbar('Error', "Please fill in all required fields");


                  }else{
                      if(widget.type=="Edit"){
                        print("ghdfdhfhghf");
                        productGroupController.editProductGroup( groupID: widget.uid!);
                      }
                      else{
                        if(productGroupController.createPermission==true){
                          productGroupController.createProductGroup();
                        }else{
                          Get.snackbar('Error', "Permission Denied");
                        }
                      }




                  }

                },
                icon: Text(
                  'save'.tr,
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


            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productGroupController.groupNameController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: productGroupController.productNameFocusNode,
              onEditingComplete: () {
                // if(productController.productNameController.text !=""){
                //   if(productController.isGst ==false){
                //     productController.convertToArabic( name: productController.productNameController.text,);
                //   }
                //   else{
                //     productController.descriptionController.text = productController.productNameController.text;
                //   }
                // }
                FocusScope.of(context).requestFocus(productGroupController.kitchenFocusNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'grp_name'.tr),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productGroupController.kitchenController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // /focusNode: nameFCNode,
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SelectKitchenMobile()),
                );

                if (result != null) {
                  productGroupController.kitchenID   = result[0];
                  productGroupController.kitchenController.text = result[1];
                }
              },
              focusNode: productGroupController.kitchenFocusNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productGroupController.descriptionFocusNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'select_kitchens'.tr),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productGroupController.productCategoryController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // /focusNode: nameFCNode,
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  SelectCategoryMobile()),
                );

                if (result != null) {
                  productGroupController.categoryID   = result[0];
                  productGroupController.productCategoryController.text = result[1];
                }
              },
              focusNode: productGroupController.catFocusNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productGroupController.descriptionFocusNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'select_cat'.tr),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: productGroupController.descriptionController,
              style:
              customisedStyle(context, Colors.black, FontWeight.w500, 14.0),

              focusNode: productGroupController.descriptionFocusNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(productGroupController.saveIconFocusNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'description'.tr),
            ),




          ],
        ),
      ),
    );
  }
}
