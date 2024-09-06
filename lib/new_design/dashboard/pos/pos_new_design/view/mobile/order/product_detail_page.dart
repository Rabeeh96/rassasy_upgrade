import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/new_design/dashboard/pos/pos_new_design/controller/order_controller.dart';

class ProductDetailPage extends StatefulWidget {
  final int index;
  final String image;

  const ProductDetailPage({super.key, required this.index, required this.image});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {



    pr(orderController.orderItemList[widget.index]);

    orderController.flavourList.clear();
    await orderController.getAllFlavours();
    orderController.productName.value = orderController.orderItemList[widget.index]["ProductName"];
    orderController.item_status.value = orderController.orderItemList[widget.index]["Status"];
    orderController.unitName.value = orderController.orderItemList[widget.index]["UnitName"];
    orderController.quantity.value = double.parse(orderController.orderItemList[widget.index]["Qty"].toString());
    orderController.productTaxName.value = orderController.orderItemList[widget.index]["ProductTaxName"];
    orderController.productTaxID.value = orderController.orderItemList[widget.index]["ProductTaxID"];
    orderController.salesPrice.value = orderController.orderItemList[widget.index]["SalesPrice"].toString();
    orderController.productID.value = orderController.orderItemList[widget.index]["ProductID"];
    orderController.actualProductTaxName.value = orderController.orderItemList[widget.index]["ActualProductTaxName"];
    orderController.actualProductTaxID.value = orderController.orderItemList[widget.index]["ActualProductTaxID"];
    orderController.branchID.value = orderController.orderItemList[widget.index]["BranchID"];
    orderController.unique_id.value = orderController.orderItemList[widget.index]["unq_id"];
    orderController.unitPriceAmount.value = orderController.orderItemList[widget.index]["UnitPrice"].toString();
    orderController.rateWithTax.value = double.parse(orderController.orderItemList[widget.index]["RateWithTax"].toString());
    orderController.costPerPrice.value = orderController.orderItemList[widget.index]["CostPerPrice"].toString();
    orderController.priceListID.value = orderController.orderItemList[widget.index]["PriceListID"];
    orderController.discountPer.value = orderController.orderItemList[widget.index]["DiscountPerc"].toString();
    orderController.discountAmount.value = double.parse(orderController.orderItemList[widget.index]["DiscountAmount"].toString());
    orderController.grossAmountWR.value = orderController.orderItemList[widget.index]["GrossAmount"].toString();
    orderController.vatPer.value = double.parse(orderController.orderItemList[widget.index]["VATPerc"].toString());
    orderController.vatAmount.value = double.parse(orderController.orderItemList[widget.index]["VATAmount"].toString());
    orderController.netAmount.value = double.parse(orderController.orderItemList[widget.index]["NetAmount"].toString());
    orderController.detailID.value = orderController.orderItemList[widget.index]["detailID"];
    orderController.sGSTPer.value = double.parse(orderController.orderItemList[widget.index]["SGSTPerc"].toString());
    orderController.sGSTAmount.value = double.parse(orderController.orderItemList[widget.index]["SGSTAmount"].toString());
    orderController.cGSTPer.value = double.parse(orderController.orderItemList[widget.index]["CGSTPerc"].toString());
    orderController.cGSTAmount.value = double.parse(orderController.orderItemList[widget.index]["CGSTAmount"].toString());
    orderController.iGSTPer.value = double.parse(orderController.orderItemList[widget.index]["IGSTPerc"].toString());
    orderController.iGSTAmount.value = double.parse(orderController.orderItemList[widget.index]["IGSTAmount"].toString());
    orderController.createdUserID.value = orderController.orderItemList[widget.index]["CreatedUserID"];
    orderController.dataBase.value = orderController.orderItemList[widget.index]["DataBase"] ?? "";

    orderController.flavourID.value = orderController.orderItemList[widget.index]["Flavour"] ?? "";
    if(orderController.flavourID.value==""){
      orderController.flavourID.value = orderController.orderItemList[widget.index]["flavour"] ?? "";
    }
    orderController.flavourName.value = orderController.orderItemList[widget.index]["Flavour_Name"] ?? "";
    orderController.taxableAmountPost.value = double.parse(orderController.orderItemList[widget.index]["TaxableAmount"].toString());
    var gst = orderController.orderItemList[widget.index]["gstPer"] ?? '0';
    orderController.gstPer.value = double.parse(gst.toString());
    orderController.isInclusive.value = orderController.orderItemList[widget.index]["is_inclusive"];
    orderController.inclusiveUnitPriceAmountWR.value = orderController.orderItemList[widget.index]["InclusivePrice"].toString();
    orderController.totalTax.value = double.parse(orderController.orderItemList[widget.index]["TotalTaxRounded"].toString());


    print("orderController.flavourID.value ${orderController.flavourID.value} ");
    print("    orderController.flavourName.value ${    orderController.flavourName.value} ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    orderController.unitPriceEdit.value = prefs.getBool("Unit Price Edit")??true;

    print("------------------------${orderController.unitPriceEdit}---orderController.unitPriceEdit---------");

    /// excise tax not working
    // orderController.exciseTaxID.value = orderController.orderItemList[widget.index]["ExciseTaxID"];
    // orderController.exciseTaxName.value = orderController.orderItemList[widget.index]["ExciseTaxName"];
    // orderController.BPValue.value = orderController.orderItemList[widget.index]["BPValue"];
    // orderController.exciseTaxBefore.value = orderController.orderItemList[widget.index]["ExciseTaxBefore"];
    // orderController.isAmountTaxAfter.value = orderController.orderItemList[widget.index]["IsAmountTaxAfter"];
    // orderController.isAmountTaxBefore.value = orderController.orderItemList[widget.index]["IsAmountTaxBefore"];
    // orderController.isExciseProduct.value = orderController.orderItemList[widget.index]["IsExciseProduct"];
    // orderController.exciseTaxAfter.value = orderController.orderItemList[widget.index]["ExciseTaxAfter"];
    orderController.exciseTaxAmount.value = double.parse(orderController.orderItemList[widget.index]["ExciseTax"].toString());
    orderController.unitPriceChangingController.text = roundStringWith(orderController.unitPriceAmount.value);
    orderController.quantityForDetailsSection.value = double.parse(orderController.quantity.value.toString());
//    orderController.calculationOnEditing(index: widget.index, isQuantityButton: false, value: orderController.unitPriceAmountWR.value.toString());
  }

//listview working
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          'Product_Details'.tr,
          style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// image commented network

                    // Container(
                    //   height: MediaQuery.of(context).size.height / 11,
                    //   width: MediaQuery.of(context).size.width / 5,
                    //   child: ClipRRect(
                    //     child: productController.products[index].productImage.isEmpty
                    //         ? SvgPicture.asset("assets/svg/no_image.svg")
                    //         : Image.network(productController.products[index].productImage),
                    //   ),
                    // ),

                    Container(
                      height: MediaQuery.of(context).size.height / 11,
                      width: MediaQuery.of(context).size.width / 5,
                      child: ClipRRect(
                        child: SvgPicture.asset("assets/svg/no_image.svg")
                      ),
                    ),

                    // Container(
                    //   height: MediaQuery.of(context).size.height / 11,
                    //   width: MediaQuery.of(context).size.width / 5,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     // Set border radius to make the Container round
                    //   ),
                    //   child: ClipRRect(
                    //     borderRadius: BorderRadius.circular(10),
                    //     // Clip image to match the rounded corners of the Container
                    //     child: Image.network(
                    //       "https://www.api.viknbooks.com/media/uploads/Rassasy.png",
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          orderController.orderItemList[widget.index]["ProductName"],
                          style: customisedStyle(context, Colors.black, FontWeight.w400, 15.0),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/veg_mob.svg",
                      //       color: widget.isColor == true ? const Color(0xff00775E) : const Color(0xffDF1515),
                    ),
                    // Check if the current index is the selected index and the additem is true
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Obx(() =>   Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      orderController.currency.value,
                      style: customisedStyle(context, const Color(0xffA5A5A5), FontWeight.w400, 15.0),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 19,
                    width: MediaQuery.of(context).size.height / 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      // border: Border.all(color: Color(0xffE7E7E7))
                    ),
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
                      ],
                      readOnly: orderController.unitPriceEdit.value?false:true,
                      //  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                      onTap: () => orderController.unitPriceChangingController.selection =
                          TextSelection(baseOffset: 0, extentOffset: orderController.unitPriceChangingController.value.text.length),
                      onChanged: (value) {
                        if (value != "") {
                          orderController.quantity.value = double.parse(orderController.orderItemList[widget.index]["Qty"].toString());
                          orderController.calculationOnEditing(index: widget.index, isQuantityButton: false, value: value.toString());
                        }
                      },
                      controller: orderController.unitPriceChangingController,
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                      decoration: TextFieldDecoration.defaultTextField(hintTextStr: ""),
                    ),
                  )
                ],
              ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/minus_mob.svg",
                      ),
                      onPressed: () {
                        if (orderController.quantityForDetailsSection.value != 1.0) {
                          orderController.quantityForDetailsSection.value = orderController.quantityForDetailsSection.value - 1;
                          orderController.calculationOnEditing(
                              index: widget.index, isQuantityButton: true, value: orderController.quantityForDetailsSection.value.toString());
                        }
                      },
                    ),
                    Obx(
                      () => Container(
                        height: MediaQuery.of(context).size.height / 19,
                        width: MediaQuery.of(context).size.width / 5,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xffE7E7E7))),
                        child: Center(
                          child: Text(
                            roundStringWith(orderController.quantityForDetailsSection.value.toString()),
                            style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                            // style: TextStyle(
                            //   fontSize: 18,
                            //   color: Colors.black,
                            // ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/svg/plus_mob.svg"),
                      onPressed: () {
                        orderController.quantityForDetailsSection.value = orderController.quantityForDetailsSection.value + 1;
                        orderController.calculationOnEditing(
                            index: widget.index, isQuantityButton: true, value: orderController.quantityForDetailsSection.value.toString());
                      },
                    ),
                  ],
                )
              ],
            ),
          ),

          /// flavour commented on last

          const SizedBox(
            height: 20,
          ),
          Obx(() => orderController.flavourList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select a Flavour",
                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                      ),
                    ],
                  ),
                )
              : Container()),
          Obx(() => orderController.flavourList.isNotEmpty ? dividerStyle() : Container()),
          Obx(() => orderController.flavourList.isNotEmpty
              ? Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => dividerStyle(),
                      itemCount: orderController.flavourList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () async {

                            orderController.flavourName.value = orderController.flavourList[index].flavourName;
                            orderController.flavourID.value = orderController.flavourList[index].id;
                            orderController.update();
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .06,
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15.0, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      orderController.flavourList[index].flavourName,
                                      style: customisedStyle(context, Colors.black, FontWeight.w400, 13.0),
                                    ),
                                    Obx(() => orderController.flavourID.value == orderController.flavourList[index].id
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Color(0xffF25F29),
                                          )
                                        : Container()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }))
              : Container()),
          // DividerStyle()
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),
        ),
        height: MediaQuery.of(context).size.height / 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffDF1515))),
                    onPressed: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/close-circle.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Text(
                            'cancel'.tr,
                            style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 13.0),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xff10C103))),
                    onPressed: () {
                      orderController.addItemToList(index: widget.index);
                      Get.back();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/save_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            'Save'.tr,
                            style: customisedStyle(context, const Color(0xffffffff), FontWeight.normal, 12.0),
                          ),
                        )
                      ],
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
