import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:readmore/readmore.dart';

class VersionDetailPage extends StatefulWidget{


  @override
  State<VersionDetailPage> createState() => _VersionDetailPageState();
}

class _VersionDetailPageState extends State<VersionDetailPage> {
  List<Map<String,dynamic>> versionDataa=
  [

    {
      'version' : "Version 1.1.18",
      'date'    : "12/26/2023",
      'text1'   : "We've added detailed voucher number option",
      'text3'   : "-Explore the power of precision in your financial transactions with the detailed voucher number option!",
    },
    {
      'version' : "Version 1.1.17",
      'date'    : "12/26/2023",
      'text1'   : "System for automatically retrieving barcodes",
      'text3'   : "-Automatically retrieve the barcode from the device, and if the item barcode is exist, the item is automatically added to the item list",
    },
    {
      'version' : "Version 1.1.16",
      'date'    : "12/12/2023",
      'text1'   : "Issue solved",
      'text3'   : "Fixed a problem with update receipt in this version",
    },
    {
      'version' : "Version 1.1.15",
      'date'    : "07/12/2023",
      'text1'   : "Auto Focus in Barcode Scanning:",
      'text3'   : "- Auto focus is now enabled by default during barcode scanning for quicker and more accurate reads..",
    },
    {
      'version' : "Version 1.1.14",
      'date'    : "05/12/2023",
      'text1'   : "Easily split amounts on receipts and payments!",
      'text3'   : "-Effortlessly split amounts on receipts and payments . Simplify financial tracking with our user-friendly feature.",
    },
    {
      'version' : "Version 1.0.13",
      'date'    : "18/09/2023",
      'text1'   : "Customize Copies in A4",
      'text3'   : "Personalize A4 printing effortlessly! Select  your copies, and our smart feature remembers your choice for future use. Upgrade now for a tailored, efficient printing experience! 🖨️✨",
    },
    {
      'version' : "Version 1.0.12",
      'date'    : "22/08/2023",
      'text1'   : "Inclusive Pricing Unleashed ",
      'text3'   : "Simply enter the total price, and we'll  handle tax calculations, providing you with    a transparent unit price breakdown.",
    },
    {
      'version' : "Version 1.0.7",
      'date'    : "15/06/2023",
      'text1'   : "Zakha Rule for Discounts",
      'text3'   : "The Zakha rule is now implemented for  precise discount calculations.",
    },
    {
      'version' : "Version 1.0.6",
      'date'    : "05/05/2023",
      'text1'   : "Enhanced Printing Settings",
      'text3'   : "We've added new features to make your  workflow smoother.",
    },
    {
      'version' : "Version 1.0.5",
      'date'    : "15/03/2023",
      'text1'   : "Customer-Focused Pricing",
      'text3'   : "Discover the Customer Last Sale Price feature, along with Minimum Sales Price.",
    },
    {
      'version' : "Version 1.0.4 ",
      'date'    : "25/02/2023",
      'text1'   : "A4 Printing Options Galore",
      'text3'   : "Now enjoy a variety of templates for A4 printing.",
    },
    {
      'version' :"Version 1.0.3 ",
      'date'    : "01/02/2023",
      'text1'   : "Streamlined Tax Handling",
      'text3'   : "We've enhanced tax management for all your sales transactions.",
    },
    {
      'version' : "Version 1.0.2 ",
      'date'    : "16/01/2023",
      'text1'   : "Fresh Bluetooth Print Templates",
      'text3'   : "Introducing brand new templates for seamless Bluetooth printing.",
    },
    {
      'version' : "Version 1.0.1 ",
      'date'    : "25/12/2022",
      'text1'   : "Store Debut",
      'text3'   : "We're excited to announce the launch of our app on the store!",
    },

  ];

  @override

  Widget build(BuildContext context) {
    bool isShow = false;
    double mqh = MediaQuery.of(context).size.height;
    double mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Color(0xff09308C),
        appBar: AppBar(
          elevation: 0.0,


          titleSpacing: 0,

          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },icon: Icon(Icons.arrow_back,color: Colors.black,),),

          title: Text(
            "Version History",
            style:
            customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 18),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: versionDataa.length,
              itemBuilder: (context, index) {
                final item =versionDataa[index];
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.0,),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Container(
                                width: mqw*.023,
                                height: mqh*.025,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF25F29),
                                ),
                              ),
                              SizedBox(width: mqw*.038,),
                              Padding(
                                padding:  EdgeInsets.only(top: 2.0),
                                child: Container(
                                  width: mqw*.002,
                                  height: mqh*.18,
                                  color: Color(0xFFE5E5E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: mqw*.04,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              "${item['version']}",
                              style: customisedStyle(context,Colors.black,FontWeight.w500,16.0),


                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "${item['date']}",

                              style: customisedStyle(context,Color(0xff878787),FontWeight.w400,13.0),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height:10),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: mqh*.16,
                                maxWidth: mqw*.82,
                                minWidth:  mqw*.82,
                                minHeight: mqh*.08,
                              ),
                              decoration: BoxDecoration(
                                color:  Color(0xffF6F6F6),
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${item['text1']}",
                                      style: customisedStyle(context, Color(0xff000000),FontWeight.w600,14.0),

                                      textAlign: TextAlign.left,
                                    ),

                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          isShow = !isShow;
                                        });
                                      },
                                      child: ReadMoreText(
                                        "${item['text3']}",
                                        trimMode: TrimMode.Line,
                                        colorClickableText: Color(0xffF25F29),

                                        style: customisedStyle(context,Color(0xff757575),FontWeight.w400,13.0),
                                        textAlign: TextAlign.left,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: mqh*.008,)
                  ],
                );
              },
            ),
            SizedBox(height: mqh*.05,)
          ],
        )
    );
  }
}
