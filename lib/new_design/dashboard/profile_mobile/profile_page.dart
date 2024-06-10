import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/new_design/dashboard/dashboard.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/profile_controller.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:rassasy_new/new_design/organization/mob_oganisation_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_us/about_us_page.dart';
import 'contact_us/contact_us.dart';
import 'settings/new_settingsSection.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
ProfileController profileController=Get.put(ProfileController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    double mqh = MediaQuery.of(context).size.height;
    double mqw = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SafeArea(
      child: Container(
          margin: const EdgeInsets.all(20),
          height: mHeight,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: mHeight * .03,
                ),

                Center(
                  child: Column(
                    children: [
                      Container(
                        //  height: mqh * .30,
                        width: mqw * .92,
                        decoration: BoxDecoration(
                            color: const Color(0xffFFF6F2),

                            // const Color(0xffE6E6E6)
                            borderRadius: BorderRadius.circular(25)),
                        child: Obx(() => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0, left:0, right: 6),
                              child: Container(
                                height: mqh * .090,
                                width: mqw * .846,
                                decoration: const BoxDecoration(
                                  // border: Border.all(color: Colors.black,width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: mqh * .080,
                                        width: mqw * .180,
                                        decoration: BoxDecoration(
                                            color: Colors.white38,
                                            borderRadius:
                                            BorderRadius.circular(22)),
                                        child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            child: Image.network(
                                                "https://www.gravatar.com/avatar/1?s=46&d=identicon&r=PG&f=1")),
                                        // child: Image.network(photo)),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text(
                                            profileController.userName.value,
                                            style: customisedStyle(
                                                context,
                                                Colors.black,
                                                FontWeight.w500,
                                                15.5),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            profileController.mail.value,
                                            style: customisedStyle(
                                                context,
                                                const Color(0xff7D7D7D),
                                                FontWeight.w400,
                                                13.5),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      // const SizedBox(
                                      //   height: 20,
                                      //   width: 15,
                                      // ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(
                                            'assets/svg/edit_mobile.svg',
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 11.0),
                              child: Container(
                                // height: mqh * .085,
                                width: mqw * .845,
                                decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    border: Border.all(
                                        width: 1.5,
                                        color: Colors.grey.withOpacity(.05)),
                                    borderRadius: BorderRadius.circular(11)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Padding(
                                      padding:
                                      const EdgeInsets.only(left: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Organization',
                                            style: customisedStyle(
                                                context,
                                                const Color(0xff7D7D7D),
                                                FontWeight.w400,
                                                14.0),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            profileController.companyName.value,
                                            style: customisedStyle(
                                                context,
                                                Colors.black,
                                                FontWeight.w500,
                                                15.0),
                                            textAlign: TextAlign.left,
                                          )
                                        ],
                                      ),
                                    )),
                                    Column(
                                      children: [
                                        const Text(""),
                                        Container(
                                          height: mqh * .05,
                                          width: mqw * .3,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffFFFFFF)),
                                          child: TextButton(
                                            onPressed: () async {
                                              bottomDialogueFunction(
                                                  isDismissible: true,
                                                  context: context,
                                                  textMsg:
                                                  ' Change organisation ?',
                                                  fistBtnOnPressed: () {
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  secondBtnPressed: () async {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MobOrganizationList()),
                                                    );
                                                  },
                                                  secondBtnText: 'Yes');
                                            },
                                            child: Text(
                                              'change'.tr,
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xffF25F29),
                                                  FontWeight.w400,
                                                  15.0),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      bottomDialogueFunction(
                                          isDismissible: true,
                                          context: context,
                                          textMsg: "Sure want to delete",
                                          fistBtnOnPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          secondBtnPressed: () async {
                                            Navigator.of(context).pop(true);
                                            // Navigator.of(context).push(MaterialPageRoute(
                                            //     builder: (BuildContext context) => DeleteAccount(
                                            //     )));
                                          },
                                          secondBtnText: 'Ok');
                                    },
                                    child: Container(
                                      height: mHeight * .06,
                                      width: mWidth * .43,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFfffff),
                                          borderRadius:
                                          BorderRadius.circular(25)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only( left: 6.0,),
                                            child: SvgPicture.asset(
                                              "assets/svg/delete_mobile.svg",
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0,right: 6),
                                            child: Text(
                                              'dlt_acnt'.tr,
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xffC80000),
                                                  FontWeight.w400,
                                                  15.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      bottomDialogueFunction(
                                          isDismissible: true,
                                          context: context,
                                          textMsg: 'Are you sure Logout ?',
                                          fistBtnOnPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          secondBtnPressed: () async {
                                            SharedPreferences preference = await SharedPreferences.getInstance();
                                            preference.clear();
                                            Navigator.of(context).pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                  builder: (context) =>  LoginPageNew(),
                                                ),
                                                    (route) => false);
                                          },
                                          secondBtnText: 'Yes');
                                    },
                                    child: Container(
                                      width: mWidth * .34,
                                      height: mHeight * .06,
                                      decoration: BoxDecoration(
                                          color: const Color(0xffFFCFCF),
                                          borderRadius:
                                          BorderRadius.circular(25)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/svg/logout_mobile.svg"),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              'logout'.tr,
                                              style: customisedStyle(
                                                  context,
                                                  const Color(0xffEA6262),
                                                  FontWeight.w400,
                                                  15.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20)
                          ],
                        )),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: mHeight * .01,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(SettingsMobilePage());
                  },
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 8, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                  "assets/svg/settings_mobile.svg"),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Settings'.tr,

                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 16.0),
                                ),
                              )
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                /// print settings commented
                DividerStyle(),
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8, top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(Contact_us());
                      },
                      child: InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/brand-hipchat.svg",
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    'contact_us'.tr,
                                    style: customisedStyle(context,
                                        Colors.black, FontWeight.w400, 16.0),
                                  ),
                                )
                              ],
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                DividerStyle(),
                GestureDetector(
                  onTap: () {
                    Get.to(AboutUs());
                  },
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/about_us_mob.svg",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'about_us'.tr,
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 16.0),
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 18,
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                DividerStyle(),
                GestureDetector(
                  onTap: () {
                    ///
                  },
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8, top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/language-hiragana.svg",
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'lng'.tr,
                                  style: customisedStyle(context, Colors.black,
                                      FontWeight.w400, 16.0),
                                ),
                              ),
                            ],
                          ),
                         Text("English",style: customisedStyle(context, Color(0xff7D7D7D), FontWeight.normal, 14.0),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Color(0xffE9E9E9), width: 1))),
        height: MediaQuery.of(context).size.height / 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Get.to(DashboardNew());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/_mobhome.svg",color: Color(0xff9E9E9E),),
                  Text(
                    "Home",
                    style: customisedStyleBold(context, Color(0xff9E9E9E),
                        FontWeight.normal, 12.0),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            GestureDetector(
              onTap: () {
               // Get.to(ProfileScreen());
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svg/profile_mob.svg",color: Color(0xffF25F29),),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      'Profile'.tr,
                      style: customisedStyleBold(context,
                          Color(0xffF25F29) , FontWeight.normal, 12.0),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}

bottomDialogueFunction(
    {required BuildContext context,
    required String textMsg,
    required Function() fistBtnOnPressed,
    required Function() secondBtnPressed,
    required String secondBtnText,
    required bool isDismissible}) {
  return showModalBottomSheet(
    isDismissible: isDismissible,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textMsg,
                  style: customisedStyle(
                      context, Colors.red, FontWeight.w400, 15.0),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                TextButton(
                    onPressed: fistBtnOnPressed,
                    child: Text(
                      'cancel',
                      style: customisedStyle(context, const Color(0xff5728C4),
                          FontWeight.w600, 13.0),
                    )),
                TextButton(
                    onPressed: secondBtnPressed,
                    child: Text(
                      secondBtnText,
                      style: customisedStyle(context, const Color(0xff5728C4),
                          FontWeight.w600, 13.0),
                    )),
              ],
            )),
      );
    },
  );
}
enum ConfirmAction { cancel, accept }

Future<Future<ConfirmAction?>> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'msg6'.tr,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: TextStyle(color: Colors.red)),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('isLoggedIn', false);
              prefs.setBool('companySelected', false);

              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (context) => LoginPageNew()),
                    (_) => false,
              );
            },
          ),
          TextButton(
            child: Text('No', style: TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
