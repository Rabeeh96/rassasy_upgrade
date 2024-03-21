import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
 import 'package:rassasy_new/global/textfield_decoration.dart';
 import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

class ForgotPasswordNew extends StatefulWidget {
  @override
  State<ForgotPasswordNew> createState() => _ForgotPasswordNewState();
}

class _ForgotPasswordNewState extends State<ForgotPasswordNew> {
  TextEditingController userNameController=TextEditingController();
  FocusNode userNameFcNode=FocusNode();
  FocusNode saveFCNode=FocusNode();

  bool section = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/png/coverpage.png"),
              fit: BoxFit.cover),
        ),
        child:section ==true ?enterMailSection():otpSection(),
      ),
    );
  }
/// forgot Password section 1




  Widget enterMailSection (){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(


          width: MediaQuery.of(context).size.width / 3.3,
          height: MediaQuery.of(context).size.height / 2.5,
          child: ListView(
            children: [
              Container(
                child: SvgPicture.asset(
                  'assets/svg/logoimg.svg',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Container(
                  height: MediaQuery.of(context).size.height / 21,

                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text('forgot_account'.tr,style: TextStyle(fontWeight: FontWeight.w800),),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: userNameController,
                  focusNode: userNameFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(saveFCNode);
                  },
                  decoration:TextFieldDecoration.textFieldDecor1(
                      hintTextStr: 'user_or_email'.tr
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 9,top: 20,right: 0,bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ButtonTheme(
                          minWidth: 15.0,

                          child: MaterialButton(

                            shape: const CircleBorder(),
                            onPressed: () {
                              Navigator.pop(context);

                            },
                            child:  Padding(
                              padding: EdgeInsets.all(0),
                              child: SvgPicture.asset('assets/svg/go_baack_forgott.svg'),
                            ),
                          ),
                        ),

                        Container(

                          child:  TextButton(
                              onPressed: () {

                                Navigator.pop(context);


                              },
                              child: Text(
                                'go_back'.tr,
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.w500),
                              )),

                        ),


                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.only(left: 9,top: 20,right: 0,bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          shape: const CircleBorder(),
                          onPressed: () {
                            if(userNameController.text==''){
                              dialogBox(context, 'please_enter_email_username'.tr);
                            }
                            else{
                              forgotPassword();
                            }
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) =>  ResetPassword()),
                            // );
                          },
                          child:  Padding(
                            padding: EdgeInsets.all(0),
                            child: SvgPicture.asset('assets/svg/roundarrow.svg'),
                          ),
                        ),


                      ],
                    ),
                  ),
                ],
              )

            ],
          ),
        )
      ],
    );
  }
  Future<Null> forgotPassword() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        print(dialogBox(context, "Connect to internet"));
        stop();

    } else {
      try {
        String baseUrl = BaseUrl.baseUrlAuth;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final url = '$baseUrl/users/forgot-password/';
        print(url);
        Map data = {
          "data": userNameController.text,
          "is_mobile":true
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
        var status = n["success"];
        if (status == 6000) {
          setState(() {
            stop();
            prefs.setString('valForgot', userNameController.text);
            section = false;


          });
        } else if (status == 6001) {
          var msg = n["message"];
          print(dialogBox(context, msg));
          stop();
        }
      } catch (e) {

          print(dialogBox(context, "Error"));
          stop();

      }
    }
  }
/// forgot password section 2
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode confirmPasswordFcNode = FocusNode();
  FocusNode otpFcNode = FocusNode();
  FocusNode passwordFcNode = FocusNode();
  FocusNode saveFCNodeChange = FocusNode();
  Widget otpSection (){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          height: MediaQuery.of(context).size.height / 1.8,
          child: ListView(
            children: [

              Container(
                child: SvgPicture.asset(
                  'assets/svg/logoimg.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Container(
                  height: MediaQuery.of(context).size.height / 21,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Text(
                    'Reset password',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: TextField(
                  controller: tokenController,
                  focusNode: otpFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(passwordFcNode);
                  },

                  decoration: TextFieldDecoration.textFieldDecor1(
                      hintTextStr: 'Token'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        resend_otp();
                      },
                      child: Text(
                        'Resend ',
                        style: TextStyle(
                            color: Color(0xff002AB4),
                            fontWeight: FontWeight.w500),
                      )),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(

                  controller: passwordController,
                  focusNode: passwordFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(confirmPasswordFcNode);
                  },
                  obscureText: true,
                  decoration: TextFieldDecoration.textFieldDecor1(
                      hintTextStr: 'New password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: confirmPasswordController,
                  focusNode: confirmPasswordFcNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(saveFCNode);
                  },
                  obscureText: true,
                  decoration: TextFieldDecoration.textFieldDecor1(
                      hintTextStr: 'Confirm password'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 9, top: 0, right: 0, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: (){


                      setState((){
                        section = true;
                      });


                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ForgotPasswordNew()),
                      // );

                    }, child: Text(
                      'Change Email',
                      style: TextStyle(
                          color: Color(0xff208203),
                          fontWeight: FontWeight.w500),
                    )),

                    MaterialButton(
                      shape: const CircleBorder(),
                      onPressed: () {

                        if(tokenController.text ==""|| passwordController.text==''||confirmPasswordController.text==''){
                          dialogBox(context, "Please enter mandatory fields");
                        }
                        else{
                          if (RegExp(r'^[A-Za-z\d@$!%*?&]{8,}$').hasMatch(passwordController.text)) {
                            if (passwordController.text != confirmPasswordController.text) {
                              dialogBox(context, "Password miss match");
                            }
                            else{

                              resetPassword();
                            }
                          }
                          else{
                            dialogBox(context, "Use 8 or more characters with a mix of letters, numbers & symbols");
                          }
                        }

                        // if(tokenController.text==''|| passwordController.text==''||confirmPasswordController.text==''){
                        //
                        //   if( passwordController.text != confirmPasswordController.text){
                        //     dialogBox(context, "Password must be same as above");
                        //   }
                        //   else{
                        //     dialogBox(context, "Please enter mandatory fields");
                        //   }
                        // }
                        // else{
                        //
                        //
                        //   resetPassword();
                        // }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child:
                        SvgPicture.asset('assets/svg/roundarrow.svg'),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],        );
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
        String baseUrl = BaseUrl.baseUrlAuth;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var val= prefs.getString('valForgot');

//mail
        final url = '$baseUrl/users/forgot-password/';
        print(url);
        Map data = {
          "data": val,
          "is_mobile":true
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
        var status = n["success"];
        if (status == 6000) {

          stop();



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
  Future<Null> resetPassword() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {

        print(dialogBox(context, "Connect to internet"));

    } else {
      try {
        print("1");
        start(context);
        String baseUrl = BaseUrl.baseUrlAuth;
        var tokenNumber=tokenController.text;

        final url = '$baseUrl/users/forgot-password-confirm/$tokenNumber';

        Map data = {
          "new_password1": passwordController.text,
          "new_password2": confirmPasswordController.text
        };


        //encode Map to JSON
        var bdy = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
            },
            body: bdy);
        print(response.body);

///
        Map n = json.decode(utf8.decode(response.bodyBytes));


        var status = n["success"];
        print(status);
        if (status == 6000) {
          print("6566");

          stop();
          Navigator.pop(context);
          } else if (status == 6001) {
          var msg = n["message"];
          dialogBox(context, msg);
          stop();
        }
      } catch (e) {
        print("465656564646");

        dialogBox(context, "Error");
          stop();

      }
    }
  }
}
