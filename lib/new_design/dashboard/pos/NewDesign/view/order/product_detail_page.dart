import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/new_design/dashboard/pos/NewDesign/controller/pos_controller.dart';
import 'package:get/get.dart';
class ProductDetailPage extends StatefulWidget {
  String? image;
  String? name;
  String? total;
  bool? isColor;

  ProductDetailPage(
      {super.key,
      required this.image,
      required this.total,
      required this.name,
      required this.isColor});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  POSController productDetailController=Get.put(POSController());
  final ValueNotifier<int> _counter = ValueNotifier<int>(1);
  ValueNotifier<List> _choices = ValueNotifier<List>(['Spicy', 'Arabic', 'Cold', ]) ;
  String selected = "Arabic";

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
        title: const Text(
          'Product Details',
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
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
              right:20,
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
                    Container(
                      height: MediaQuery.of(context).size.height / 11,
                      width: MediaQuery.of(context).size.width / 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // Set border radius to make the Container round
                      ),
                      child:  Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          // Clip image to match the rounded corners of the Container
                          child: Image.network(
                            widget.image!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          widget.name!,
                          style: customisedStyle(
                              context, Colors.black, FontWeight.w400, 15.0),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      "assets/svg/veg_mob.svg",
                      color: widget.isColor == true
                          ? const Color(0xff00775E)
                          : const Color(0xffDF1515),
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
              right:5,
            ),            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Text(productDetailController.currency,style: customisedStyle(context, Color(0xffA5A5A5), FontWeight.w400, 15.0),),
                    )
                    ,Container(
                      height: MediaQuery.of(context).size.height/19,
                      width: MediaQuery.of(context).size.height/7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        // border: Border.all(color: Color(0xffE7E7E7))
                      ),
                      child: TextField(
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: productDetailController.grandTotalController,
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w500, 14.0),

                        onEditingComplete: () {

                        },

                        decoration: TextFieldDecoration.defaultTextField(
                            hintTextStr: ""),
                      ),
                    )
                  ],
                ),

                ValueListenableBuilder(
                  valueListenable: _counter,
                  builder: (context, int value, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: SvgPicture.asset("assets/svg/minus_mob.svg"),

                          onPressed: () {
                            if (value > 1) {
                              _counter.value--;
                            }
                          },
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height/19,
                          width: MediaQuery.of(context).size.width/5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xffE7E7E7))
                          ),
                          child: Center(
                            child: Text(
                              '$value',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset("assets/svg/plus_mob.svg"),


                          onPressed: () {
                            _counter.value++;
                          },
                        ),
                      ],
                    );
                  },
                ),

              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right:20,
              top: 15,bottom: 10
            ),            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select a Flavour",style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),),
              ],
            ),
          ),
          DividerStyle(),
          Expanded(child: ListView.builder(
              itemCount: _choices.value.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: ()async {
                    // setState(()  {
                    selected = _choices.value[index];


                  },
                  child: Column(
                    children: [
                      SizedBox(

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
                                  _choices.value[index],
                                  style: customisedStyle(
                                      context,
                                       Colors.black,
                                      FontWeight.w400,
                                      13.0),
                                ),
                                selected == _choices.value[index]
                                    ? Icon(Icons.check_circle,color: Color(0xffF25F29),)
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                      DividerStyle()
                    ],
                  ),
                );



              }))
        ],
      ),
      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          border: Border(top: BorderSide(color: Color(0xFFE8E8E8))),

        ),
        height: MediaQuery.of(context).size.height/10,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xffDF1515))),
                    onPressed: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/close-circle.svg"),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, right: 12),
                          child: Text(
                            "Cancel",
                            style: customisedStyle(context, const Color(0xffffffff),
                                FontWeight.normal, 12.0),
                          ),
                        ),
                      ],
                    )),

                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(const Color(0xff10C103))),
                    onPressed: () {},
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/save_mob.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Text(
                            'Save'.tr,
                            style: customisedStyle(context, const Color(0xffffffff),
                                FontWeight.normal, 12.0),
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
