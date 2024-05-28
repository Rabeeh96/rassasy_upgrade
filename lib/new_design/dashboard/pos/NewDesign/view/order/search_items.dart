import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/order_controller.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';

import 'product_detail_page.dart';

class SearchItems extends StatefulWidget {
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  OrderController orderController = Get.put(OrderController());
  var selectedItem = '';
  final ValueNotifier<int> _counter = ValueNotifier<int>(1);

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
        title: Text(
          'Search',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
                onPressed: () {
                 Get.back();
                },
                icon: Icon(
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
            autoFocus: false,
            mHeight: MediaQuery.of(context).size.height / 18,
            hintText: 'Search',
            controller: orderController.searchController,
            onChanged: (quary) async {

            },
          ),
          DividerStyle(),

          Padding(
            padding: const EdgeInsets.only(top: 15.0,bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/20,
                  decoration: BoxDecoration(color: Color(0xffFFF6F2),
                  borderRadius: BorderRadius.circular(29)),
                  child: TextButton(onPressed: (){}, child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,right: 8),
                        child: Text("Code",
                          style: customisedStyle(context, Color(0xffF25F29), FontWeight.w400, 12.0),
                        ),
                      ),
                      SvgPicture.asset("assets/svg/drop_arrow.svg"),
                    ],
                  )),
                ),
              ],
            ),
          ),
          DividerStyle(),

          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => DividerStyle(),
              itemCount: 3,
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
                          //       'https://www.api.viknbooks.com/media/uploads/Rassasy.png',
                          //   name: "Shwarama plate Mexican",
                          //   isColor: orderController.isVegNotifier.value,
                          //   total: '909.00',
                          // ));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/veg_mob.svg",
                              // color: orderController.isVegNotifier.value == true ? const Color(0xff00775E) :
                              // const Color(0xffDF1515),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, top: 8),
                              child: Container(
                                width: MediaQuery.of(context)
                                        .size
                                        .width *
                                    0.5,
                                child: Text(
                                  "Shwarama plate Mexican",
                                  style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w400,
                                      15.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
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
                                    padding: const EdgeInsets.only(
                                        left: 5.0),
                                    child: Text(
                                      "909.00",
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
                            Container(
                              height:
                                  MediaQuery.of(context).size.height /
                                      7,
                              width:
                                  MediaQuery.of(context).size.width /
                                      4,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10),
                                      child: Image.network(
                                        'https://www.api.viknbooks.com/media/uploads/Rassasy.png',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 15,
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: SizedBox(
                                  height: MediaQuery.of(context)
                                          .size
                                          .height /
                                      30,
                                  width: MediaQuery.of(context)
                                          .size
                                          .width /
                                      6,
                                  child: DecoratedBox(
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color(0xffF25F29)),
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
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
            ),
          ),


        ],
      ),
    );
  }

}
