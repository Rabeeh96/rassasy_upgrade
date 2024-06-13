import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/main.dart';
import 'package:rassasy_new/new_design/organization/list_organization.dart';
import 'package:rassasy_new/new_design/organization/mob_oganisation_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/profile_mobile/web.dart';
import '../create_account/create_new_account.dart';
import '../create_account/select_country.dart';

class LoginPageNew extends StatefulWidget {
  @override
  State<LoginPageNew> createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // TextEditingController userNameController = TextEditingController()..text = "bawanland";
  // TextEditingController passwordController = TextEditingController()..text = "bawan@123";
  //  bawanland bawan@123
  //dogiwo78 aA@123456
  // TextEditingController userNameController = TextEditingController()
  //   ..text = "dogiwo78";
  //  TextEditingController passwordController = TextEditingController()
  //  ..text = "aA@123456";

  // TextEditingController userNameController = TextEditingController()..text = "Rabeeh@vk";
  // TextEditingController passwordController = TextEditingController()..text = "Rabeeh@000";

  FocusNode userNameFcNode = FocusNode();
  FocusNode passwordFcNode = FocusNode();
  FocusNode saveFCNode = FocusNode();

  //bool isAlert = false;
  bool showPassword = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  ///alert icon not working
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    /// chaged
    //bool isTablet = true;
    bool isTablet = screenWidth > 800;

    return Scaffold(
      appBar:isTablet?AppBar(): AppBar(
        title:GestureDetector(
          onTap: () async {
            SharedPreferences prefs =
                await SharedPreferences.getInstance();
            Locale? currentLocale = Get.locale;
            if (currentLocale.toString() == "ar") {
              prefs.setBool('isArabic', false);
              Get.updateLocale(const Locale('en', 'US'));
            } else {
              prefs.setBool('isArabic', true);
              Get.updateLocale(const Locale('ar'));
            }
          },
          child:
          InkWell(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svg/language-hiragana.svg"),
                Text('lang'.tr,style: customisedStyle(context, Colors.black, FontWeight.w400, 14.0),),
              ],
            ),
          ),
        )


      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: isTablet
              ? const DecorationImage(
                  image: AssetImage("assets/png/coverpage.png"),
                  fit: BoxFit.cover)
              : const DecorationImage(
                  image: AssetImage("assets/png/mobile_back.png"),
                  fit: BoxFit.cover),
        ),
        child: isTablet ? tabletScreen() : mobileScreen(),
      ),
      bottomNavigationBar:isTablet ?Container(height: .1,): Container(

        height: MediaQuery.of(context).size.height / 9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8,),
            GestureDetector(
              child: InkWell(
                child: Text(
                  'dont_have_account'.tr,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w400, 15.0),
                ),
              ),
            ),
            const SizedBox(height: 5,),
            GestureDetector(
              child: InkWell(
                child: Text(
                  'sign_up'.tr,
                  style: customisedStyle(
                      context, const Color(0xffF25F29), FontWeight.w500, 16.0),
                ),
              ),
            ),
            const SizedBox(height: 18,)
          ],
        ),
      ),
    );
  }

  Widget tabletScreen() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    /// chaged
    //bool isTablet = true;
    bool isTablet = screenWidth > 800;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: screenWidth / 3.5,
          // width: isTablet ? screenWidth /3.5 : screenWidth / 1.5,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: SvgPicture.asset(
                    'assets/svg/logoimg.svg',
                  )),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth / 4,
                      child: Text(
                        'sign_in_vikn_account'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(

                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: userNameController,
                      focusNode: userNameFcNode,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(passwordFcNode);
                      },
                      decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide:
                                  BorderSide(color: Color(0xffC9C9C9))),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Color(0xffC9C9C9))),
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, right: 15, bottom: 10),
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Color(0xff000000), fontSize: 14),
                          hintText: 'username'.tr,
                          fillColor: const Color(0xffffffff)),
                    ),
                  ),
                  passwordField(),
                  MaterialButton(
                    shape: const CircleBorder(),
                    onPressed: () async {
                      if (userNameController.text == '' ||
                          passwordController.text == '') {

                        popAlert(head: "Alert", message:  'please_enter_details'.tr,  position: SnackPosition.TOP);

                      } else {
                        loginAccount(context);

                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // prefs.setBool('isLoggedIn', true);
                        // prefs.setString('access', "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxMzA4MTcxLCJpYXQiOjE2ODk3NzIxNzEsImp0aSI6ImQwMzBhOWI1MWYxNDRjODJiMzlkNDhjM2UzZjU1YzU0IiwidXNlcl9pZCI6NjJ9.sngN1G8smd0QwaTStCHxYLozgQWCe6MGfhWONjrPyAplOSOQeDfFqi93hyWsAwSGDo6NEhSQC3yB8PjXDJ8q_Tg_OhU5NJ3vJEZZJ1gEdXo7gZwR_Q7usKaKpIRrI6O6zTYefIi2yHBDz4IsJIVOmq-qTH93NTRWhG0umEHMtVH_pdZUcuC3-QxTRUIdIIJG5-g5u3T2n-fTln8LghxBNOMrzxb_XPSUuwS6Af50kDMdqnJo-tTpGtbZrr1POX7KCT6hSsJvYfc0A3_elWHT4TqLXBc7BFWcSuRqIZDJOSSQmcqk6JM92skCcOPmUiJonWlFVilKKuj6PZNOggsC6362GPwc-stpiVWtlfStEN1c2-o1hJ_kExywmG01GytOUB-qVuyAR8z4xMSsZmP5m3nf3whP7hCB2xVvj6Zp_6avRIYncinuu309o6jRGrEWxpIbYQCcBsK6MCoKuqypR5wvFVqeFR9EytBlL8b9ThfHJrgpVMwdpHT0mB-Uw8vSt4Ey-xlppLKKpc7YXfeT61o6PRL3zqIoO5zyYS6D_NLZqlaPaCb_pywFH0FYlroiNopPEqwwtu1Hn4aYqq865_jA4D0RcxJxoAmIpuXf4D9PSTHhV5ehSpaQu_1LgEvYB14iq6YDoN-Yx4BSx4HaxnesKyQlgm5X9Koa_x5h7Ck");
                        // prefs.setInt('user_id', 62);
                        // prefs.setString('user_name', userNameController.text);
                        //
                        //
                        //
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => OrganizationList()));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: SvgPicture.asset('assets/svg/roundarrow.svg'),
                    ),
                  )

                  /// commented
                  // TextButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => ForgotPasswordNew()),
                  //       );
                  //     },
                  //     child: Text(
                  //      'forgot_account'.tr,
                  //       style: const TextStyle(
                  //           color: Color(0xff002AB4),
                  //           fontWeight: FontWeight.w500),
                  //     )
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 16, top: 0, right: 9, bottom: 0),
                  //   child: Text(
                  //     'or'.tr,
                  //     style: const TextStyle(
                  //         color: Color(0xffF26716),
                  //         fontWeight: FontWeight.w500),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //       left: 7, top: 0, right: 0, bottom: 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Container(
                  //           child: TextButton(
                  //         onPressed: () {
                  //           UserCreation.verifyMail = false;
                  //           Navigator.pushReplacement(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (BuildContext context) =>
                  //                       ///CreateNewAccount()));
                  //                   CreateNewAccount()));
                  //         },
                  //         child: Text(
                  //           'create_an_accnt'.tr,
                  //           style: const TextStyle(
                  //               color: Color(0xff208203),
                  //               fontWeight: FontWeight.w500),
                  //         ),
                  //       )),
                  //       MaterialButton(
                  //         shape: const CircleBorder(),
                  //         onPressed: () async{
                  //           if (userNameController.text == '' || passwordController.text == '') {
                  //             dialogBox(context, 'please_enter_details'.tr);
                  //
                  //             setState(() {
                  //               isAlert = true;
                  //             });
                  //            } else {
                  //             isAlert = false;
                  //             loginAccount(context);
                  //
                  //             // SharedPreferences prefs = await SharedPreferences.getInstance();
                  //             // prefs.setBool('isLoggedIn', true);
                  //             // prefs.setString('access', "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxMzA4MTcxLCJpYXQiOjE2ODk3NzIxNzEsImp0aSI6ImQwMzBhOWI1MWYxNDRjODJiMzlkNDhjM2UzZjU1YzU0IiwidXNlcl9pZCI6NjJ9.sngN1G8smd0QwaTStCHxYLozgQWCe6MGfhWONjrPyAplOSOQeDfFqi93hyWsAwSGDo6NEhSQC3yB8PjXDJ8q_Tg_OhU5NJ3vJEZZJ1gEdXo7gZwR_Q7usKaKpIRrI6O6zTYefIi2yHBDz4IsJIVOmq-qTH93NTRWhG0umEHMtVH_pdZUcuC3-QxTRUIdIIJG5-g5u3T2n-fTln8LghxBNOMrzxb_XPSUuwS6Af50kDMdqnJo-tTpGtbZrr1POX7KCT6hSsJvYfc0A3_elWHT4TqLXBc7BFWcSuRqIZDJOSSQmcqk6JM92skCcOPmUiJonWlFVilKKuj6PZNOggsC6362GPwc-stpiVWtlfStEN1c2-o1hJ_kExywmG01GytOUB-qVuyAR8z4xMSsZmP5m3nf3whP7hCB2xVvj6Zp_6avRIYncinuu309o6jRGrEWxpIbYQCcBsK6MCoKuqypR5wvFVqeFR9EytBlL8b9ThfHJrgpVMwdpHT0mB-Uw8vSt4Ey-xlppLKKpc7YXfeT61o6PRL3zqIoO5zyYS6D_NLZqlaPaCb_pywFH0FYlroiNopPEqwwtu1Hn4aYqq865_jA4D0RcxJxoAmIpuXf4D9PSTHhV5ehSpaQu_1LgEvYB14iq6YDoN-Yx4BSx4HaxnesKyQlgm5X9Koa_x5h7Ck");
                  //             // prefs.setInt('user_id', 62);
                  //             // prefs.setString('user_name', userNameController.text);
                  //             //
                  //             //
                  //             //
                  //             // Navigator.pushReplacement(
                  //             //     context,
                  //             //     MaterialPageRoute(
                  //             //         builder: (BuildContext context) => OrganizationList()));
                  //
                  //
                  //
                  //           }
                  //         },
                  //         child: Padding(
                  //           padding: const EdgeInsets.all(0),
                  //           child:
                  //               SvgPicture.asset('assets/svg/roundarrow.svg'),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget mobileScreen() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    /// chaged
    //bool isTablet = true;
    bool isTablet = screenWidth > 800;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: screenWidth / 1.2,
          // width: isTablet ? screenWidth /3.5 : screenWidth / 1.5,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: SvgPicture.asset(
                      'assets/svg/logoimg.svg',
                      height: screenHeight * .05,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth / 1.7,
                      child: Text(
                        'login'.tr,
                        style: customisedStyle(
                            context, Colors.black, FontWeight.w500, 19.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth / 1.7,
                      child: Text(
                        'sign_in_vikn_account'.tr,
                        style: customisedStyle(
                            context, const Color(0xff838383), FontWeight.w400, 15.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  TextField(

                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text,
                    controller: userNameController,
                    focusNode: userNameFcNode,
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(passwordFcNode);
                    },
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/svg/user-2.svg',
                            width: MediaQuery.of(context).size.width / 25,
                            height: MediaQuery.of(context).size.height / 40,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                            borderSide: BorderSide(color: Color(0xffE6E6E6))),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                            borderSide: BorderSide(color: Color(0xffE6E6E6))),
                        disabledBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(11),topRight: Radius.circular(11)),
                            borderSide: BorderSide(color: Color(0xffE6E6E6))),
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, right: 15, bottom: 10),
                        filled: true,
                        hintStyle: const TextStyle(
                            color: Color(0xff7D7D7D), fontSize: 14),
                        hintText: 'username'.tr,
                        fillColor: const Color(0xffffffff)),
                  ),
                  TextField(
                      controller: passwordController,
                      focusNode: passwordFcNode,
                      obscuringCharacter: "*",
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(saveFCNode);
                      },
                      obscureText: showPassword,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              'assets/svg/key-round.svg',
                              width: MediaQuery.of(context).size.width / 25,
                              height: MediaQuery.of(context).size.height / 40,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xffF25F29),
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(11),bottomRight: Radius.circular(11)),
                              borderSide: BorderSide(color: Color(0xffE6E6E6))),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(11),bottomRight: Radius.circular(11)),
                              borderSide: BorderSide(color: Color(0xffE6E6E6))),
                          disabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(11),bottomRight: Radius.circular(11)),
                              borderSide: BorderSide(color: Color(0xffE6E6E6))),
                          contentPadding: const EdgeInsets.only(
                              left: 20, top: 10, right: 10, bottom: 10),
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Color(0xff7D7D7D), fontSize: 14),
                          hintText: 'Password'.tr,
                          fillColor: const Color(0xffffffff))),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => DeleteAccount(
                            )));
                      },
                      child: Text(
                        'forgot_account'.tr,
                        style: customisedStyle(
                            context, const Color(0xffF25F29), FontWeight.w400, 15.0),
                      )),
                  const SizedBox(
                    height: 6,
                  ),
                  MaterialButton(

                    onPressed: () async {
                      if (userNameController.text == '' ||
                          passwordController.text == '') {
                        popAlert(head: "Warning", message:  'please_enter_details'.tr,  position: SnackPosition.TOP);

                      } else {
                        loginAccount(context);

                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // prefs.setBool('isLoggedIn', true);
                        // prefs.setString('access', "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxMzA4MTcxLCJpYXQiOjE2ODk3NzIxNzEsImp0aSI6ImQwMzBhOWI1MWYxNDRjODJiMzlkNDhjM2UzZjU1YzU0IiwidXNlcl9pZCI6NjJ9.sngN1G8smd0QwaTStCHxYLozgQWCe6MGfhWONjrPyAplOSOQeDfFqi93hyWsAwSGDo6NEhSQC3yB8PjXDJ8q_Tg_OhU5NJ3vJEZZJ1gEdXo7gZwR_Q7usKaKpIRrI6O6zTYefIi2yHBDz4IsJIVOmq-qTH93NTRWhG0umEHMtVH_pdZUcuC3-QxTRUIdIIJG5-g5u3T2n-fTln8LghxBNOMrzxb_XPSUuwS6Af50kDMdqnJo-tTpGtbZrr1POX7KCT6hSsJvYfc0A3_elWHT4TqLXBc7BFWcSuRqIZDJOSSQmcqk6JM92skCcOPmUiJonWlFVilKKuj6PZNOggsC6362GPwc-stpiVWtlfStEN1c2-o1hJ_kExywmG01GytOUB-qVuyAR8z4xMSsZmP5m3nf3whP7hCB2xVvj6Zp_6avRIYncinuu309o6jRGrEWxpIbYQCcBsK6MCoKuqypR5wvFVqeFR9EytBlL8b9ThfHJrgpVMwdpHT0mB-Uw8vSt4Ey-xlppLKKpc7YXfeT61o6PRL3zqIoO5zyYS6D_NLZqlaPaCb_pywFH0FYlroiNopPEqwwtu1Hn4aYqq865_jA4D0RcxJxoAmIpuXf4D9PSTHhV5ehSpaQu_1LgEvYB14iq6YDoN-Yx4BSx4HaxnesKyQlgm5X9Koa_x5h7Ck");
                        // prefs.setInt('user_id', 62);
                        // prefs.setString('user_name', userNameController.text);
                        //
                        //
                        //
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => OrganizationList()));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width/3,
                      decoration: BoxDecoration(
                        color: const Color(0xffF25F29),
                        borderRadius: BorderRadius.circular(120.0)
                      ),
                     
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10,right: 8,top:7,bottom: 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text('login'.tr,style: customisedStyle(context, Colors.white, FontWeight.w400, 16.0),),
                            ),
                            const Icon(Icons.arrow_forward,color: Colors.white,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
          controller: passwordController,
          focusNode: passwordFcNode,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(saveFCNode);
          },
          obscureText: showPassword,
          obscuringCharacter: "*",
          decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),

              enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Color(0xffC9C9C9))),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Color(0xffC9C9C9))),
              disabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(color: Color(0xffC9C9C9))),
              contentPadding: const EdgeInsets.only(
                  left: 20, top: 10, right: 10, bottom: 10),
              filled: true,
              hintStyle:
                  const TextStyle(color: Color(0xff000000), fontSize: 14),
              hintText: 'Password'.tr,
              fillColor: const Color(0xffffffff))),
    );
  }

  /// working
  Future<Null> loginAccount(BuildContext context) async {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    bool isTablet = screenWidth > 800;
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      popAlert(head: "Alert", message: "Connect to internet",  position: SnackPosition.TOP);
      stop();
    } else {
      try {
        HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String baseUrl = BaseUrl.baseUrlAuth;
        final url = '$baseUrl/users/login';
        print(url);
        Map data = {
          "username": userNameController.text,
          "password": passwordController.text,
          "service": "rassasy_new"
        };

        print(data);
        //encode Map to JSON
        var bdy = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: bdy);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print("${response.statusCode}");
        print("${response.body}");
        //     var status = n["success"];
        var status = n["success"];

        if (status == 6000) {
          var datas = n["data"];
          print(datas);
          stop();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('access', datas["access"]);
          prefs.setInt('user_id', datas["user_id"]);
          prefs.setString('user_name', userNameController.text);

          ///here checking tab or mobile
          if (isTablet) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => OrganizationList()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MobOrganizationList()));
          }
        } else if (status == 6001) {
          var msg = n["error"] ?? "";
          popAlert(head: "Alert", message:  msg,  position: SnackPosition.TOP);

          if (msg == "Please Verify Your Email to Login") {
            UserCreation.verifyMail = true;
            prefs.setString('email', n['user_email']);
            prefs.setInt('user_id', n['data']);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CreateNewAccount()));
          }

          stop();
        } else {

          stop();
          popAlert(head: "Alert", message:  "Some thing went wrong",  position: SnackPosition.TOP);

        }
      } catch (e) {
        stop();

        popAlert(head: "Alert", message:  "Some thing went wrong ${e.toString()}",  position: SnackPosition.TOP);

      }
    }
  }
}
