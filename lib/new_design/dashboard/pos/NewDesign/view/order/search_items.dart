import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/search_controlletr.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchItems extends StatefulWidget {
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  OrderController orderController = Get.put(OrderController());
  var selectedItem = '';
//  orderController orderController = Get.put(orderController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderController.searchItems(productName: "", isCode: false, isDescription: false);
    orderController.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title:  Text(
          'search'.tr,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
                onPressed: () {
                  Get.back();

                },
                icon: const Icon(
                  Icons.clear,
                  color: Colors.black,
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1,
            color: const Color(0xffE9E9E9),
          ),
          SearchFieldWidgetNew(
            autoFocus: true,
            mHeight: MediaQuery.of(context).size.height / 18,
            hintText: 'search'.tr,
            controller: orderController.searchController,
            onChanged: (quary) async {

             // productSearchNotifier.value == 1 ? true : false,
              orderController.searchItems(productName: quary, isCode: orderController.dropdownvalue.value=="Code"?true:false, isDescription:orderController.dropdownvalue.value=="Description"?true:false);
            },
          ),
          DividerStyle(),
          const SizedBox(
            height: 10,
          ),

           Container(
            height: MediaQuery.of(context).size.height / 18,
            decoration: BoxDecoration(
                color: const Color(0xffFFF6F2),
                borderRadius: BorderRadius.circular(29)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0,right: 8.0),
              child: Obx(() =>   DropdownButton(
                // Initial Value
                value: orderController.dropdownvalue.value,
                underline: Container(color: Colors.transparent),
                // Down Arrow Icon
                icon: SvgPicture.asset("assets/svg/drop_arrow.svg"),
                // Array list of items
                items: orderController.items.map((String item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8),
                      child: Text(item,
                          style: customisedStyle(
                              context, const Color(0xffF25F29), FontWeight.w400, 12.0)),
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {

                  orderController.dropdownvalue.value = newValue!;

                },
              ))
            ),
          )  
          ,
          const SizedBox(
            height: 10,
          ),
          DividerStyle(),
          Expanded(child: Obx(() {

            if (orderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return orderController.searchProductList.isEmpty?const Center(child: Text("No results found")):

                ListView.separated(
                separatorBuilder: (context, index) => DividerStyle(),
                itemCount: orderController.searchProductList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Get.to(ProductDetailPage(
                            //   image:
                            //       'https://picsum.photos/250?image=9',
                            //   name: "Shwarama plate Mexican",
                            //   isColor: orderController.isVegNotifier.value,
                            //   total: '909.00',
                            // ));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/veg_mob.svg",
                               color:  orderController.searchProductList[index].vegOrNonVeg=="Non-veg"? const Color(0xff00775E) :
                               const Color(0xffDF1515),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8.0, top: 8),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    orderController.searchProductList[index].productName,
                                    style: customisedStyle(context,
                                        Colors.black, FontWeight.w400, 15.0),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              orderController.searchProductList[index].description !="" ?Padding(
                                padding:
                                    const EdgeInsets.only(right: 2.0, top: 2),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: Text(
                                    orderController.searchProductList[index].description,
                                    style: customisedStyle(context,
                                        Colors.black, FontWeight.w400, 15.0),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ):Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      orderController.currency.value,
                                      style: customisedStyle(
                                          context,
                                          const Color(0xffA5A5A5),
                                          FontWeight.w400,
                                          13.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        roundStringWith(orderController.searchProductList[index].defaultSalesPrice.toString()),
                                        style: customisedStyle(
                                            context,
                                            Colors.black,
                                            FontWeight.w400,
                                            15.0),
                                      ),
                                    ),
                                    //diningController.tableData[index].reserved!.isEmpty?Text("res"):Text(""),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Container(

                                height: MediaQuery.of(context).size.height / 7,
                                width: MediaQuery.of(context).size.width / 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Image.network(
                                      orderController.searchProductList[index].productImage != ""
                                          ? orderController.searchProductList[index].productImage
                                          : 'https://www.api.viknbooks.com/media/uploads/Rassasy.png',
                                      fit: BoxFit.cover,
                                    ),

                                    // orderController.searchProductList[index].productImage
                                    //     ==""?  Positioned.fill(
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     child: Image.network(
                                    //       'https://picsum.photos/250?image=9',
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ):
                                    // Positioned.fill(
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.circular(10),
                                    //     child: Image.network(
                                    //       orderController.searchProductList[index].productImage,
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 15,

                              child: GestureDetector(
                                onTap: ()async {
                                  SharedPreferences prefs = await SharedPreferences.getInstance();

                                  var qtyIncrement = prefs.getBool("qtyIncrement") ?? true;

                                  orderController.unitPriceAmount.value = orderController.searchProductList[index].defaultSalesPrice;
                                  orderController.inclusiveUnitPriceAmountWR.value = orderController.searchProductList[index].defaultSalesPrice;
                                  orderController.vatPer.value = double.parse(orderController.searchProductList[index].vatsSalesTax);
                                  orderController.gstPer.value = double.parse(orderController.searchProductList[index].gSTSalesTax);

                                  orderController.priceListID.value = orderController.searchProductList[index].defaultUnitID;
                                  orderController.productName.value = orderController.searchProductList[index].productName;
                                  orderController.item_status.value = "pending";
                                  orderController.unitName.value = orderController.searchProductList[index].defaultUnitName;

                                  var taxDetails = orderController.searchProductList[index].taxDetails;
                                  if (taxDetails != "") {
                                    orderController.productTaxID.value = taxDetails["TaxID"];
                                    orderController.productTaxName.value = taxDetails["TaxName"];
                                  }

                                  orderController.detailID.value = 1;
                                  orderController.salesPrice.value = orderController.searchProductList[index].defaultSalesPrice;
                                  orderController.purchasePrice.value =
                                      orderController.searchProductList[index].defaultPurchasePrice;
                                  orderController.productID.value = orderController.searchProductList[index].productID;
                                  orderController.isInclusive.value = orderController.searchProductList[index].isInclusive;

                                  orderController.detailIdEdit.value = 0;
                                  orderController.flavourID.value = "";
                                  orderController.flavourName.value = "";

                                  var newTax = orderController.searchProductList[index].exciseData;

                                  if (newTax != "") {
                                    orderController.isExciseProduct.value = true;
                                    orderController.exciseTaxID.value = newTax["TaxID"];
                                    orderController.exciseTaxName.value = newTax["TaxName"];
                                    orderController.BPValue.value = newTax["BPValue"].toString();
                                    orderController.exciseTaxBefore.value = newTax["TaxBefore"].toString();
                                    orderController.isAmountTaxBefore.value = newTax["IsAmountTaxBefore"];
                                    orderController.isAmountTaxAfter.value = newTax["IsAmountTaxAfter"];
                                    orderController.exciseTaxAfter.value = newTax["TaxAfter"].toString();
                                  } else {
                                    orderController.exciseTaxID.value = 0;
                                    orderController.exciseTaxName.value = "";
                                    orderController.BPValue.value = "0";
                                    orderController.exciseTaxBefore.value = "0";
                                    orderController.isAmountTaxBefore.value = false;
                                    orderController.isAmountTaxAfter.value = false;
                                    orderController.isExciseProduct.value = false;
                                    orderController.exciseTaxAfter.value = "0";
                                  }
                                  orderController.unique_id.value = "0";
                                  orderController.calculation();

                                  Get.back();
                                 // setState(() {});

                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 30,
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: DecoratedBox(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Color(0xffF25F29)),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child:  Center(
                                      child: Text(
                                        'add'.tr,
                                        style: const TextStyle(
                                          color: Color(0xffF25F29),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }))
        ],
      ),
    );
  }
}


