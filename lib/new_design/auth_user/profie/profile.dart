import 'dart:async';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController()..text = "Rabeeh@vk";

  TextEditingController emailController = TextEditingController()..text = "rabeeh.amk@gmail.com";

  bool checkBoxValue = false;
  bool isButtonDisabled = false;

   var image =  "";

   @override
   void initState(){
     super.initState();
     getProfileData();
   }


  Future<Null> getProfileData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
        stop();
    } else {
      try {
        print("1");
        start(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var userID = prefs.getInt('user_id') ?? 0;
        var companyID = prefs.getString('companyID') ?? 0;

        var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';

        String baseUrl = BaseUrl.baseUrl;
        final url = '$baseUrl/users/user-view/$userID/';
        //encode Map to JSON
        var response = await http.get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
        );


        Map n = json.decode(response.body);
        var status = n["StatusCode"];

        var responseJson = n["data"];
        print(responseJson);
        var customerData = n["customer_data"];
        print("6");
        if (status == 6000) {
          stop();

            nameController.text = responseJson['username'] ?? '';
            emailController.text = responseJson['email'] ?? '';
            image = customerData['photo'] ?? '';

        } else if (status == 6001) {
          print("666");

          stop();
        }

        //DB Error
        else {}
      } catch (e) {
        print(e);

        stop();
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mWidth = MediaQuery.of(context).size.width;
    final mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title:   Text(
          'Profile'.tr,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(

        padding: EdgeInsets.only(left: mWidth * .35, right: mWidth * .35),
        height: mHeight,
        width: mWidth,
        color: Colors.white,
        child: Card(
          elevation: 10,
          //padding: EdgeInsets.only(left: mWidth * .35, right: mWidth * .35),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: mHeight * .01,
                ),
                Container(
                  height: mHeight * .18,
                  width: mWidth * .15,
                  decoration: BoxDecoration(
                    //   color: Colors.red,
                      borderRadius: BorderRadius.circular(10),

                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              image.isNotEmpty ? image :"https://www.gravatar.com/avatar/?s=46&d=identicon&r=PG&f=1"
                              // image.isNotEmpty ? image :"data:image/png;base64,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"
                          ))),


                ),
                SizedBox(
                  height: mHeight * .05,
                ),
                cardWidget(
                    mWidth: mWidth, mHeight: mHeight, controller: nameController),
                SizedBox(
                  height: mHeight * .01,
                ),
                cardWidget(
                    mWidth: mWidth, mHeight: mHeight, controller: emailController),
                SizedBox(
                  height: mHeight * .01,
                ),
                Card(
                  elevation: 5,
                  child: Container(
                      color: const Color(0xffF1F1F1),
                      width: mWidth * .95,
                      height: mHeight * .10,
                      child:  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'msg1'.tr,style: customisedStyle(context, Colors.blueGrey, FontWeight.w500
                            ,14.0),),
                      )),
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: Colors.red,
                      value: isButtonDisabled,
                      onChanged: (value) {
                        setState(() {
                          isButtonDisabled = value!;
                        });
                      },
                    ),
                      Text('msg2'.tr,style: customisedStyle(context, Colors.black, FontWeight.w500
                          ,13.0))
                  ],
                ),
                SizedBox(
                  height: mHeight * .1,
                ),
                SizedBox(
                    height: mHeight * .08,
                    width: mWidth * .3,
                    child: ElevatedButton(
                        style:
                        ElevatedButton.styleFrom(
                            backgroundColor:isButtonDisabled ? Colors.red : Colors.red.shade200
                        ),
                        onPressed:  () {
                          print("$isButtonDisabled");

                           if(isButtonDisabled){
                             Navigator.of(context).push(MaterialPageRoute(
                                 builder: (BuildContext context) => MyWebView(
                                   selectedUrl:
                                   "https://accounts.vikncodes.com/",
                                 )));

                           }
                           else{
                             dialogBox(context, 'msg2'.tr);
                           }

                        }  ,
                        child:   Text('dlt_acnt'.tr,style: customisedStyle(context, Colors.white, FontWeight.w600
                            ,13.0),))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class cardWidget extends StatelessWidget {
  const cardWidget({
    super.key,
    required this.mWidth,
    required this.mHeight,
    required this.controller,
  });

  final double mWidth;
  final double mHeight;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
          color: const Color(0xffF2F2F2),
          width: mWidth * .95,
          child: Center(
            child: Padding(

              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  style: customisedStyle(context, Colors.black, FontWeight.w500
                      ,13.0),
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          )),
    );
  }
}


class MyWebView extends StatelessWidget {
  final String selectedUrl;

  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  MyWebView({
    required this.selectedUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,


        body: SafeArea(
          child: Container()
          // WebView(
          //   initialUrl: selectedUrl,
          //    javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (WebViewController webViewController) {
          //     _controller.complete(webViewController);
          //   },
          // ),


        ));
  }
}
