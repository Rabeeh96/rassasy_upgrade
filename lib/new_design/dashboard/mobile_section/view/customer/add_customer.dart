import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/controller/customer_controller.dart';

import 'detail/TAX_TREATMENT.dart';
import 'detail/price_category.dart';
import 'detail/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
class AddCustomerMobile extends StatefulWidget {
  @override
  State<AddCustomerMobile> createState() => _AddCustomerMobileState();
}

class _AddCustomerMobileState extends State<AddCustomerMobile> {
  CustomerController customerController = Get.put(CustomerController());

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
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Add Customer',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  if (customerController.customerNameController.text.isEmpty ||
                      customerController.balanceController.text.isEmpty ||
                      customerController.creditLimitController.text.isEmpty ||
                      customerController.creditPeriodController.text.isEmpty) {
                    Get.snackbar('Error', "Please fill in all required fields");


                  }else{
                    // customerController.createCustomer(
                    //     email: customerController.emailController.text,
                    //     address:customerController.addressController.text,
                    //     customerName: customerController.customerNameController.text,
                    //     displayName: customerController.displayNameController.text,
                    //     creditLimitText: customerController.creditLimitController.text,
                    //
                    //     balanceText: customerController.balanceController.text,
                    //     dropdownvalue: customerController.dropdownvalue,
                    //     as_on_date_api: DateFormat('yyyy-MM-dd').format(statementController.endDate.value)customerController.dateFormat(customerController.purchaseDateValue),
                    //    // as_on_date_api: customerController.apiDateFormat(customerController.purchaseDateValue.value),
                    //     workPhone: customerController.workPhoneController.text,
                    //     webUrl: customerController.webUrlController.text,
                    //     creditPeriod: customerController.creditPeriodController.text,
                    //     priceCategoryId: customerController.priceCategoryID,
                    //     panNo: customerController.panNoController.text,
                    //     routeId: customerController.routeID.toString(),
                    //     crNo: customerController.crNoController.text,
                    //     bankName: customerController.bankNameController.text,
                    //     accName: customerController.accNameController.text,
                    //     accNo: customerController.accNoController.text,
                    //     ibanIfsc:  customerController.ibanIfscController.text,
                    //     vatNumber: customerController.vatNumberController.text,
                    //     treatmentID: customerController.taxID);
                    // if(widget.type=="Edit"){
                    //   print("ghdfdhfhghf");
                    //   productController.editProduct(widget.uid!);
                    // }
                    // else{
                    //   if(productController.createPermission){
                    //     productController.createProduct();
                    //   }else{
                    //     Get.snackbar('Error', "Permission Denied");
                    //   }
                    // }


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
        child: ListView(
          children: [
            dividerStyle(),
            const SizedBox(
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
                    child: customerController.imageSelect == true
                        ? customerController.displayImage()
                        : Obx(() {
                            return customerController.imageSelect.value
                                ? customerController.displayImage()
                                : Center(
                                    child: IconButton(
                                        onPressed: () {
                                          customerController
                                              .showOptionsDialog(context);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Color(0xffF25F29),
                                        )));
                          }))
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.customerNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.customerNameFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.balanceFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'Customer Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.displayNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.displayFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.displayFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Display Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.balanceController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.balanceFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.emailFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'Balance'),
            ),
            const SizedBox(
              height: 10,
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 18,
                  width: MediaQuery.of(context).size.width / 5.5,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Color(0xffD9D9D9))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: DropdownButton(
                      // Initial Value
                      value: customerController.dropdownvalue,
                      underline: Container(color: Colors.transparent),

                      // Down Arrow Icon
                      icon: const Icon(Icons.keyboard_arrow_down),
                      // Array list of items
                      items: customerController.items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (String? newValue) {
                        setState(() {
                          customerController.dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  decoration: BoxDecoration(
                      color: const Color(0xffEEF9FF),
                      borderRadius: BorderRadius.circular(5)),
                  child: ValueListenableBuilder(
                      valueListenable: customerController.purchaseDateValue,
                      builder: (BuildContext ctx, DateTime purchaseDateValuee, _) {
                        return GestureDetector(
                          onTap: () {
                            showDatePickerFunction(context, customerController.purchaseDateValue);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "As on. ",
                                  style: customisedStyle(context, const Color(0xff5B5B5B), FontWeight.w400, 15.0),
                                ),
                               Icon(Icons.calendar_today,color: Colors.black,),
                                SizedBox(width:10),
                                Text(
                                  customerController.dateFormat.format(purchaseDateValuee),
                                  style: customisedStyle(
                                      context, const Color(0xff000000), FontWeight.w400, 15.0),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.addressController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.addressFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.emailFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Address'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.emailController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.emailFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.workPhoneFcNode);
              },
              keyboardType: TextInputType.emailAddress,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Email'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.workPhoneController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.workPhoneFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.webUrlFcNode);
              },
              keyboardType: TextInputType.phone,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Work Phone'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.webUrlController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.webUrlFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.creditPeriodFcNode);
              },
              keyboardType: TextInputType.url,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Website Url'),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Transactions",
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.creditPeriodController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.creditPeriodFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.creditLimitFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'Credit Period'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.creditLimitController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.creditLimitFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.priceCategoryFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIc(
                  hintTextStr: 'Credit Limit'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectPriceCategoryMobile()),
                );

                if (result != null) {
                  customerController.priceCategoryID   = result[0];
                  customerController.priceCategoryController.text = result[1];
                }
              },
              readOnly: true,
              textCapitalization: TextCapitalization.words,
              controller: customerController.priceCategoryController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.priceCategoryFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.panNoFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Price Category'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.panNoController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.panNoFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.routesFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'PAN Number'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.routesController,
              readOnly: true,
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectRouteMobile()),
                );

                if (result != null) {
                customerController.routeID   = result[0];
                customerController.routesController.text = result[1];
                }

              },
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.routesFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.crNoFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Routes'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.crNoController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.crNoFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.treatmentNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'CR No'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              onTap: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaxTreatment()),
                );

                if (result != null) {
                  customerController.taxID   = result[0];
                  customerController.treatmentController.text = result[1];
                }
              },
              textCapitalization: TextCapitalization.words,
              controller: customerController.treatmentController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.treatmentNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.treatmentNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatoryIcon(
                  hintTextStr: 'Tax treatment'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.taxNoController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              // focusNode: customerController.creditLimitFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.priceCategoryFcNode);
              },
              keyboardType: TextInputType.number,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Tax NO  '),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Bank Details",
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 16.0),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.bankNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.bankNameNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.acc_nameFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Bank Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.accNameController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.acc_nameFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.acc_nameFcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Account Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.accNoController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.acc_nameFcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.iban_ifsc_FcNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'Account No'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: customerController.ibanIfscController,
              style:
                  customisedStyle(context, Colors.black, FontWeight.w500, 14.0),
              focusNode: customerController.iban_ifsc_FcNode,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(customerController.saveNode);
              },
              keyboardType: TextInputType.text,
              decoration: TextFieldDecoration.mobileTextfieldMandatory(
                  hintTextStr: 'IBAN/IFSC Code'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
