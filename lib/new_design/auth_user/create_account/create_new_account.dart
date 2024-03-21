import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/new_design/auth_user/create_account/select_country.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:rassasy_new/global/global.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class CreateNewAccount extends StatefulWidget {
  @override
  State<CreateNewAccount> createState() => _CreateNewAccountState();
}

class _CreateNewAccountState extends State<CreateNewAccount> {
  // TextEditingController userNameController = TextEditingController()..text ="lawedam899";
  // TextEditingController firstNameController = TextEditingController()..text = "test123";
  // TextEditingController secondNameController = TextEditingController()..text = "456";
  // TextEditingController emailController = TextEditingController()..text ="lawedam899@galotv.com";
  // TextEditingController countryController = TextEditingController();
  // TextEditingController phoneController = TextEditingController()..text = "8714152075";
  // TextEditingController passwordController = TextEditingController()..text = "aA@123456";
  // TextEditingController confirmController = TextEditingController()..text = "aA@123456";

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  TextEditingController otpController = TextEditingController();
  TextEditingController mailShowController = TextEditingController();

  FocusNode userNameFcNode = FocusNode();
  FocusNode otpFcNode = FocusNode();
  FocusNode firstNameFcNode = FocusNode();
  FocusNode secondNameFcNode = FocusNode();

  FocusNode emailFcNode = FocusNode();
  FocusNode countryFcNode = FocusNode();
  FocusNode phoneFcNode = FocusNode();
  FocusNode passwordFcNode = FocusNode();
  FocusNode confirmFcNode = FocusNode();

  FocusNode saveFCNode = FocusNode();
  Color iconColor = Colors.transparent;

  bool otpPage = false;
  bool isFirstName = false;
  bool isUsername = false;
  bool isEmail = false;
  bool isPhone = false;
  bool isPassword = false;
  bool isConfirmPassword = false;
  bool showPassword2 = true;
  bool showPassword1 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitial();
  }

  loadInitial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (UserCreation.verifyMail == true) {
      setState(() {
        otpPage = true;
        mailShowController.text = prefs.getString('email') ?? '';
      });
    }
  }

  ///alert icon not working
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/png/coverpage.png"), fit: BoxFit.cover),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 2.8,
            height: MediaQuery.of(context).size.height / 1.25,

            ///OTP get
            child: otpPage == true ? otpEnteringField() : createAccountPage(),
          ),
        ),
      ),
    );
  }

  Widget otpEnteringField() {
    return ListView(
      children: [
        Container(
          child: SvgPicture.asset(
            'assets/svg/logoimg.svg',
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            height: MediaQuery.of(context).size.height / 21,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 4,
            child: Text(
              'Verify_your_account'.tr,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),

        ///RESEND OTP

        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: mailShowController,
            focusNode: otpFcNode,
            decoration:
            TextFieldDecoration.textFieldDecor1(hintTextStr: 'Email'.tr.tr),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Color(0xffC9C9C9))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Color(0xffC9C9C9))),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Color(0xffC9C9C9))),
                contentPadding:
                EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                filled: true,
                hintStyle: TextStyle(color: Color(0xff929292), fontSize: 14),
                hintText: 'enter_the_otp'.tr,
                fillColor: Color(0xffffffff)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    if (mailShowController.text == "") {
                      dialogBox(context, 'please_enter_email'.tr);
                    } else {
                      resend_otp();
                    }
                  },
                  child: Text(
                    'resend_opt'.tr,
                    style: TextStyle(color: Color(0xff00217B)),
                  )),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 9, top: 20, right: 0, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                shape: const CircleBorder(),
                onPressed: () {
                  if (otpController.text == "") {
                    dialogBox(context, 'please_enter_otp'.tr);
                  } else {
                    verify_otp();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: SvgPicture.asset('assets/svg/roundarrow.svg'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget createAccountPage() {
    return ListView(
      children: [
        Container(
          child: SvgPicture.asset(
            'assets/svg/logoimg.svg',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6),
          child: Container(
            height: MediaQuery.of(context).size.height / 21,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width / 4,
            child: Text(
              'create_vikn_acnt'.tr,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        firstNameField(),
        Padding(
          padding:
          const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 7),
          child: Container(
            width: MediaQuery.of(context).size.width / 3.2,
            child: TextField(
              onChanged: (v) {
                setState(() {
                  if (userNameController.text == '') {
                    isUsername = true;
                  } else if (userNameController.text.isNotEmpty) {
                    String leng = userNameController.text;
                    if (leng.length >5) {
                      checkUsername();
                    }
                  } else {
                    isUsername = false;
                  }
                });
              },
              keyboardType: TextInputType.text,
              controller: userNameController,
              focusNode: userNameFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(emailFcNode);
              },
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r' ')),
              ],
              decoration: InputDecoration(
                  suffixIcon: isUsername == true
                      ? IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg/exclamation.svg',
                      ))
                  // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                      : IconButton(
                      onPressed: () {},
                      icon: IconButton(
                        icon: Icon(
                          Icons.check_circle,
                          color: iconColor,
                        ),
                        onPressed: () {},
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isUsername == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isUsername == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isUsername == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  contentPadding:
                  EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
                  hintText: 'username'.tr,
                  fillColor: isUsername == true
                      ? Color(0xffFFFBFB)
                      : Color(0xffffffff)),
            ),
          ),
        ),
        emailField(),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'verification'.tr,
            style: TextStyle(color: Color(0xff8B8B8B), fontSize: 11),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 6.3,
                child: TextField(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelectCountry()),
                    );

                    if (result != null) {
                      setState(() {
                        countryController.text = result;
                      });
                    } else {}
                  },
                  readOnly: true,
                  controller: countryController,
                  focusNode: countryFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(phoneFcNode);
                  },
                  decoration: TextFieldDecoration.textFieldDecorIcon(
                      hintTextStr: 'country'.tr),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 6.3,
                child: TextField(
                  onChanged: (v) {
                    setState(() {
                      isPhone = false;
                    });
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    // for below version 2 use this
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    // for version 2 and greater youcan also use this
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: phoneController,
                  focusNode: phoneFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(passwordFcNode);
                  },
                  decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, top: 14, bottom: 14),
                        child: Text(UserCreation.isd_code),
                      ),
                      suffixIcon: isPhone == true
                          ? IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            'assets/svg/exclamation.svg',
                          ))
                      // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                          : SizedBox(),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: isPhone == true
                                  ? Colors.red
                                  : Color(0xffC9C9C9))),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: isPhone == true
                                  ? Colors.red
                                  : Color(0xffC9C9C9))),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: isPhone == true
                                  ? Colors.red
                                  : Color(0xffC9C9C9))),
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                      filled: true,
                      hintStyle:
                      TextStyle(color: Color(0xff000000), fontSize: 14),
                      hintText: 'phone'.tr,
                      fillColor: isPhone == true
                          ? Color(0xffFFFBFB)
                          : Color(0xffffffff)),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              passwordField(),
              confirmPasswordField(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, right: 15),
          child: Text(
            'msg'.tr,
            style: TextStyle(color: Color(0xff8B8B8B), fontSize: 11),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding:
          const EdgeInsets.only(left: 25, top: 0, right: 25, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPageNew()),
                    );
                  },
                  child: Text(
                    'sign_in_instead'.tr,
                    style: TextStyle(
                        color: Color(0xff006CB4), fontWeight: FontWeight.w500),
                  )),
              MaterialButton(
                focusNode: saveFCNode,
                shape: const CircleBorder(),
                onPressed: () {
                  if (firstNameController.text == '' ||
                      userNameController.text == '' ||
                      emailController.text == '' ||
                      phoneController.text == '' ||
                      passwordController.text == '' ||
                      confirmController.text == '') {
                    setState(() {
                      firstNameController.text == ''
                          ? isFirstName = true
                          : isFirstName = false;
                      userNameController.text == ''
                          ? isUsername = true
                          : isUsername = false;
                      emailController.text == ''
                          ? isEmail = true
                          : isEmail = false;
                      phoneController.text == ''
                          ? isPhone = true
                          : isPhone = false;
                      passwordController.text == ''
                          ? isPassword = true
                          : isPassword = false;
                      confirmController.text == ''
                          ? isConfirmPassword = true
                          : isConfirmPassword = false;
                    });
                  } else {
                    if (userNameController.text == "") {
                      setState(() {
                        isUsername = true;
                      });
                    } else {
                      if (emailController.text == '') {
                        setState(() {
                          isEmail = true;
                        });
                      } else {
                        bool emailValid = RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(emailController.text);

                        if (emailValid == false) {
                          setState(() {
                            isEmail = true;
                          });
                        } else {
                          if (countryController.text == '') {
                            dialogBox(context, "Please select country");
                          } else {
                            if (phoneController.text == '') {
                              setState(() {
                                isPhone = true;
                              });
                            } else {
                              String leng = phoneController.text;
                              if (leng.length < 9) {
                                setState(() {
                                  isPhone = true;
                                });
                              } else {
                                if (passwordController.text == '') {
                                  setState(() {
                                    isPassword = true;
                                  });
                                } else {
                                  if (RegExp(r'^[A-Za-z\d@$!%*?&.#]{8,}$')
                                      .hasMatch(passwordController.text)) {
                                    if (passwordController.text !=
                                        confirmController.text) {
                                      setState(() {
                                        isPassword = true;
                                        isConfirmPassword = true;
                                      });
                                    } else {
                                      signUpAccount();
                                    }
                                  } else {
                                    setState(() {
                                      isPassword = true;
                                      isConfirmPassword = true;
                                    });
                                    dialogBox(context,
                                        "Use 8 or more characters with a mix of letters, numbers & symbols");
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: SvgPicture.asset('assets/svg/roundarrow.svg'),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget firstNameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 6.3,
            child: TextField(
              onChanged: (v) {
                setState(() {
                  isFirstName = false;
                });
              },
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              controller: firstNameController,
              focusNode: firstNameFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(secondNameFcNode);
              },
              decoration: InputDecoration(
                  suffixIcon: isFirstName == true
                      ? IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/svg/exclamation.svg',
                      ))
                  // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                      : SizedBox(),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isFirstName == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isFirstName == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(
                          color: isFirstName == true
                              ? Colors.red
                              : Color(0xffC9C9C9))),
                  contentPadding:
                  EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
                  filled: true,
                  hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
                  hintText: 'first_name'.tr,
                  fillColor: isFirstName == true
                      ? Color(0xffFFFBFB)
                      : Color(0xffffffff)),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 6.3,
            child: TextField(
              textCapitalization: TextCapitalization.words,
              keyboardType: TextInputType.text,
              controller: secondNameController,
              focusNode: secondNameFcNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(userNameFcNode);
              },
              decoration: TextFieldDecoration.textFieldDecor(
                  hintTextStr: 'second_name'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 20, right: 15, bottom: 7),
      child: Container(
        width: MediaQuery.of(context).size.width / 3.2,
        child: TextField(
          onChanged: (value) {
            setState(() {
              isEmail = false;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          focusNode: emailFcNode,
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(countryFcNode);
          },
          decoration: InputDecoration(
              suffixIcon: isEmail == true
                  ? IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/svg/exclamation.svg',
                  ))
              // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                  : SizedBox(),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: isEmail == true ? Colors.red : Color(0xffC9C9C9))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: isEmail == true ? Colors.red : Color(0xffC9C9C9))),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  borderSide: BorderSide(
                      color: isEmail == true ? Colors.red : Color(0xffC9C9C9))),
              contentPadding:
              EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
              filled: true,
              hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
              hintText: 'Email'.tr,
              fillColor:
              isEmail == true ? Color(0xffFFFBFB) : Color(0xffffffff)),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      width: MediaQuery.of(context).size.width / 6.3,
      child: TextField(
        controller: passwordController,
        focusNode: passwordFcNode,
        onChanged: (v) {
          setState(() {
            isPassword = false;
          });
        },
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(confirmFcNode);
        },
        obscureText: showPassword1,
        decoration: InputDecoration(
            suffixIcon: isPassword == true
                ? IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/svg/exclamation.svg',
                ))
            // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                : IconButton(
              icon: Icon(
                showPassword1 ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  showPassword1 = !showPassword1;
                });
              },
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color:
                    isPassword == true ? Colors.red : Color(0xffC9C9C9))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color:
                    isPassword == true ? Colors.red : Color(0xffC9C9C9))),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color:
                    isPassword == true ? Colors.red : Color(0xffC9C9C9))),
            contentPadding:
            EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
            filled: true,
            hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
            hintText: 'Password'.tr,
            fillColor:
            isPassword == true ? Color(0xffFFFBFB) : Color(0xffffffff)),
      ),
    );
  }

  Widget confirmPasswordField() {
    return Container(
      width: MediaQuery.of(context).size.width / 6.3,
      child: TextField(
        controller: confirmController,
        focusNode: confirmFcNode,
        onChanged: (v) {
          setState(() {
            isConfirmPassword = false;
          });
        },
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(saveFCNode);
        },
        obscureText: showPassword2,
        decoration: InputDecoration(
            suffixIcon: isConfirmPassword == true
                ? IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/svg/exclamation.svg',
                ))
            // icon: Icon(Icons.remove_circle_rounded,color: Color(0xffB40000), ))
                : IconButton(
              icon: Icon(
                showPassword2 ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  showPassword2 = !showPassword2;
                });
              },
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color: isConfirmPassword == true
                        ? Colors.red
                        : Color(0xffC9C9C9))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color: isConfirmPassword == true
                        ? Colors.red
                        : Color(0xffC9C9C9))),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(
                    color: isConfirmPassword == true
                        ? Colors.red
                        : Color(0xffC9C9C9))),
            contentPadding:
            EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
            filled: true,
            hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
            hintText: 'confirm_password'.tr,
            fillColor: isConfirmPassword == true
                ? Color(0xffFFFBFB)
                : Color(0xffffffff)),
      ),
    );
  }

  Future<Null> signUpAccount() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        dialogBox(context, "Connect to internet");
        stop();
      });
    } else {
      try {
        print("1");
        String baseUrl = BaseUrl.baseUrlAuth;
        final url = '$baseUrl/users/user-signup';
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('2');
        print(url);
        Map data = {
          "first_name": firstNameController.text,
          "last_name": secondNameController.text,
          "username": userNameController.text,
          "email": emailController.text,
          "password1": passwordController.text,
          "password2": confirmController.text,
          "country": UserCreation.selectCountry,
          "phone": phoneController.text,
        };
        print("3");
        print(data);
        //encode Map to JSON
        var bdy = json.encode(data);
        print('4');
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: bdy);
        print('5');

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print("${response.statusCode}");
        print("${response.body}");
        print('6');
        var status = n["StatusCode"];
        var data1 = n["data"];
        print('7');
        if (status == 6000) {
          print('8');
          setState(() {
            print('9');

            stop();

            prefs.setInt('user_id', n["userID"]);
            prefs.setString('email', data1["email"]);

            mailShowController.text = emailController.text;

            ///otp page
            otpPage = true;
            print('enter');
          });
        } else if (status == 6001) {
          var msg = n["message"];

          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        setState(() {
          print("error90${e.toString()}");

          dialogBox(context, "Something went wrong");
          stop();
        });
      }
    }
  }

  Future<Null> verify_otp() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        print(dialogBox(context, "Connect to internet"));
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrlAuth;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt("user_id");
//mail
        final url = '$baseUrl/users/signup-verified/';
        print(url);
        Map data = {"UserID": userID, "token": otpController.text};
        print(data);
        //encode Map to JSON
        var bdy = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: bdy);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        print("${response.statusCode}");
        print("${response.body}");
        var status = n["StatusCode"];
        if (status == 6000) {
          setState(() {
            stop();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPageNew()),
            );
          });
        } else if (status == 6001) {
          var msg = n["message"];

          print(dialogBox(context, msg));
          stop();
        }
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Error"));
          stop();
        });
      }
    }
  }

  ///chek username exist or not
  Future<Null> checkUsername() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        print(dialogBox(context, "Connect to internet"));
        stop();
      });
    } else {
      try {
        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/users/check-username/';
        print(url);
        Map data = {"username": userNameController.text};
        print(data);
        //encode Map to JSON
        var bdy = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {"Content-Type": "application/json"}, body: bdy);
        Map n = json.decode(utf8.decode(response.bodyBytes));
        print("${response.statusCode}");
        print("${response.body}");
        bool username = n["is_username"];

        if (response.statusCode == 200) {
          setState(() {
            if (username == false) {
              setState(() {
                isUsername = false;
                iconColor = Colors.green;
              });
            } else {
              setState(() {
                isUsername = true;
              });
            }
            {}
            stop();
          });
        } else {
          print(dialogBox(context, "Username not exist"));
          stop();
        }
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Error"));
          stop();
        });
      }
    }
  }

  Future<Null> resend_otp() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        print(dialogBox(context, "Connect to internet"));
        stop();
      });
    } else {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String baseUrl = BaseUrl.baseUrlAuth;
        var email = prefs.getString("email");
        var user_id = prefs.getInt("user_id") ?? 0;

        final url = '$baseUrl/users/resend-verification-code/';
        print(url);
        Map data = {"data": mailShowController.text, "UserID": user_id};

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
        var status = n["success"];
        if (status == 6000) {
          var msg = n["message"];
          print(msg);
          dialogBox(context, msg);
          stop();
        } else if (status == 6001) {
          var msg = n["message"];
          print(msg);
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        setState(() {
          print(dialogBox(context, "Error"));
          stop();
        });
      }
    }
  }
}
