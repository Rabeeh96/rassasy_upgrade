import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
class PosListTabDesign extends StatefulWidget {
  @override
  State<PosListTabDesign> createState() => _PosListTabDesignState();
}

class _PosListTabDesignState extends State<PosListTabDesign> {
  Color _getBackgroundColor(String? status) {
    if (status == 'Vacant') {
      return const Color(0xff6C757D); // Set your desired color for pending status
    } else if (status == 'Ordered') {
      return const Color(0xff03C1C1); // Set your desired color for completed status
    } else if (status == 'Paid') {
      return const Color(0xff2B952E); // Set your desired color for cancelled status
    } else if (status == 'Billed') {
      return const Color(0xff034FC1); // Set your desired color for cancelled status
    } else {
      return const Color(0xffEFEFEF); // Default color if status is not recognized
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Table",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xffE9E9E9)))),
        child: Row(
          children: [
            Flexible(
                flex: 20,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      toolbarHeight: MediaQuery.of(context).size.height / 30,
                      pinned: true,
                      leading: const SizedBox.shrink(),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.only(left: 25,right: 25),

                        height: MediaQuery.of(context).size.height *.77, // Specify your desired height here
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 20,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                                borderRadius: BorderRadius.circular(
                                 8
                                ),child:Container(
                              decoration:   BoxDecoration(

                                border: Border(

                                  left: BorderSide(color:   _getBackgroundColor('Vacant'), width: 3,),
                                  right: BorderSide(color: Color(0xffE9E9E9),width: 1),
                                  bottom: BorderSide(color: Color(0xffE9E9E9),width: 1),
                                  top: BorderSide(color: Color(0xffE9E9E9),width: 1),
                                ),
                              ),
                              child: GridTile(
                                footer: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all<Color>(
                                          _getBackgroundColor('Vacant')
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Vacant",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ),
                                header: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Table name",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Text(
                                        "12 min ago",
                                        style: TextStyle(
                                          color: Color(0xff828282),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "To be paid:",
                                        style: TextStyle(
                                          color: Color(0xff757575),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                      Text(
                                        "RS .1323",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height*.12,
                          alignment: Alignment.bottomCenter,
                          decoration: const BoxDecoration(
                              border: Border(top: BorderSide(color: Color(0xffE9E9E9)))
                          ),

                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color(0xffFFF6F2))),
                                  onPressed: () {
                                   /// addTable();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        color: Color(0xffF25F29),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                                        child: Text(
                                          'Add_Table'.tr,
                                          style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w500, 14.0),
                                        ),
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffEFF6F5))),
                                  onPressed: () {
                                    // if(posController.reservation_perm.value){
                                    //   Get.to(ReservationPage());
                                    // }else{
                                    //   dialogBoxPermissionDenied(context);
                                    //
                                    // }

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                                    child: Text(
                                      'Reservations'.tr,
                                      style: customisedStyle(context, const Color(0xff00775E),FontWeight.w500, 14.0),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ,


            ),
            Flexible(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                  decoration: const BoxDecoration(
                border: Border(
                    left: BorderSide(color: Color(0xffE9E9E9), width: 1)),
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconWithText(
                      assetName: 'assets/svg/dine.svg',
                      text: 'Dining',
                      onPressed: () {},
                    ),

                    SizedBox(height: 7,),
                    IconWithText(
                      assetName: 'assets/svg/takeout_dining.svg',
                      text: 'Takeout',
                      onPressed: () {},
                    ),
                    SizedBox(height: 7,),
                    IconWithText(
                      assetName: 'assets/svg/online_img.svg',
                      text: 'Online',
                      onPressed: () {},
                    ),
                    SizedBox(height: 7),
                    IconWithText(
                      assetName: 'assets/svg/car_inmgs.svg',
                      text: 'Car',
                      onPressed: () {},
                    ),
                    ],
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  final String assetName;
  final String text;
  final VoidCallback onPressed;

  IconWithText({required this.assetName, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetName,
            height: 24, // Adjust the size as needed
            width: 24,
          ),
          SizedBox(height: 8), // Space between icon and text
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
