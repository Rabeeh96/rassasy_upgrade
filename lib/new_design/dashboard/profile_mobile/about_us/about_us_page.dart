import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/vertion/vertion_history.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  @override
  Widget build(BuildContext context) {
    double mqh = MediaQuery.of(context).size.height;
    double mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(



        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color:  const Color(0xff000000),
        ),
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(),
              child: Text('about_us'.tr,
                  style: customisedStyle(
                      context,
                      Colors.black,
                      FontWeight.w500,
                      20.0)),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only( bottom: 10),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  GestureDetector(
                    onTap: (){

                    },
                    child: InkWell(
                      child: Acommoncontainer(
                        height: mqh * .070,
                        SvgPicture: Container(
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/svg/shield-security.svg",

                          ),
                        ),
                        IconButton: IconButton(
                            onPressed: () {
                              //    Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                              color:  Colors.black,
                            )),
                        text: 'privacy_policy'.tr,
                        widthS: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ),
                  ),
                  DividerStyle(),
                  GestureDetector(
                    onTap: (){
                      //Get.to(TermsAndCondition());
                    },
                    child: InkWell(
                      child: Acommoncontainer(
                        height: mqh * .070,
                        SvgPicture: Container(
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/svg/document-text.svg",

                          ),
                        ),
                        IconButton: IconButton(
                            onPressed: () {
                              //    Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                              color:  Colors.black,
                            )),
                        text: 'terms_condition'.tr,
                        widthS: MediaQuery.of(context).size.width / 2.5,
                      ),
                    ),
                  ),

                  DividerStyle(),
                  GestureDetector(
                    onTap: (){

                    },
                    child: SizedBox(
                      height: mqh * .098,
                      child: Padding(
                        padding: const EdgeInsets.only(left:15.0,right: 15),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/version_history.svg',

                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Version $appVersion',
                                  style: customisedStyle(
                                      context,
                                      Colors.black,
                                      FontWeight.w500,
                                      14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),

                            SizedBox(height: 50),
                            TextButton(
                                onPressed: () {
Get.to(VersionDetailPage());
//,
                                },
                                child: Text(
                                  'vertion_history'.tr,
                                  style: customisedStyle(context,
                                      Color(0xffF25F29), FontWeight.w500, 14.0),
                                  textAlign: TextAlign.left,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: mqh * .075,
                    // color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.only(left:15.0,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'power_by'.tr,
                            style: customisedStyle(
                                context,
                                 Colors.black,
                                FontWeight.w500,
                                14.0),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset(
                            'assets/svg/logo_vikn.svg',

                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            "VIKN CODES",
                            // style: customisedTextStyle(clr: Color(0xff000000), fontWeight: FontWeight.w400, fontsize: 19,),
                            style: customisedStyle(
                                context,
                                Colors.black,
                                FontWeight.w500,
                                19.0),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        Text(
                          'welcome_vikn'.tr,
                          style: customisedStyle(
                              context,
                              Colors.black,
                              FontWeight.w500,
                              12.0),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          "Welcome to Viknbooks "
                              "Your all-in-one financial management solution for individuals and businesses. Viknbooks empowers you to take control of your finances,"
                              "making smarter financial decisions and transforming the way you manage your money.",
                          style: customisedStyle(
                              context,
                               Colors.black,
                              FontWeight.w500,
                              12.0),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Say goodbye to the complexities of traditional accounting and embrace a brighter financial future with Viknbooks "
                              "oin thousands of satisfied users who are taking control of their finances and making more informed financial decisions."
                              "Whether you're an individual looking to manage personal finances or a business seeking a comprehensive financial solution, "
                              "Viknbooks is your trusted partner in financial management",
                          style: customisedStyle(
                              context,
                               Colors.black,
                              FontWeight.w500,
                              12.0),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'follow_us'.tr,
                  style: customisedStyle(
                      context, const Color(0xff858585), FontWeight.w500, 12.0),
                  textAlign: TextAlign.left,
                ),
              ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: mqh * .2,
                    child: Padding(
                      padding: const EdgeInsets.only(left:12.0,right: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/instagram.svg',

                              ),
                              Container(
                                height: mqh * .04,
                                child: TextButton(
                                  onPressed: () {
                                  },
                                  child: Text(
                                    "Vikncodes",
                                    style: customisedStyle(
                                        context,
                                        Colors.black,
                                        FontWeight.w500,
                                        12.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 1,
                              ),
                              SvgPicture.asset(
                                'assets/svg/facebook.svg',

                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              Container(
                                height: mqh * .04,
                                child: TextButton(
                                  onPressed: () {
                                  },
                                  child: Text(
                                    "Vikncodes",
                                    style: customisedStyle(
                                        context,
                                        Colors.black,
                                        FontWeight.w500,
                                        12.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/twitter.svg',

                              ),
                              Container(
                                height: mqh * .04,
                                child: TextButton(
                                  onPressed: () {
                                  },
                                  child: Text(
                                    "Vikncodes",
                                    style: customisedStyle(
                                        context,
                                         Colors.black,
                                        FontWeight.w500,
                                        12.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/youtube.svg',

                              ),
                              Container(
                                height: mqh * .04,
                                child: TextButton(
                                  onPressed: () {

                                  },
                                  child: Text(
                                    "Vikncodes",
                                    style: customisedStyle(
                                        context,
                                         Colors.black,
                                        FontWeight.w500,
                                        12.0),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container Acommoncontainer(
      {required double? widthS,
        required String text,
        required double height,
        required SvgPicture,
        IconButton}) {
    return Container(

      height: height,

      child: Padding(
        padding: const EdgeInsets.only(
            left: 15.0,right: 15
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [


            Row(
              children: [
                SvgPicture,
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    text,
                    style: customisedStyle(
                        context,
                        Colors.black,
                        FontWeight.w500,
                        15.0),
                    textAlign: TextAlign.left,
                  ),
                ),

              ],
            ),

            IconButton,
          ],
        ),
      ),
    );
  }
}
