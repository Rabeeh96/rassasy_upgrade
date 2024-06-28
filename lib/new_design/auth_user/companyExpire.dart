import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

/////
class CompanyExpired extends StatefulWidget {
  @override
  State<CompanyExpired> createState() => _CompanyExpiredState();
}

class _CompanyExpiredState extends State<CompanyExpired> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(const Duration(seconds: 10), (timer) {
      myFunction();

    });
    expiryDateCheck();
  }

  String india = "+91 905775 00400";

  String ksa = "+966 533133 4959";
  String expTitle = " ";
  late DateTime expDate;
  DateTime currDate = DateTime.now();

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: india));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copyPhone() async {
    await Clipboard.setData(ClipboardData(text: ksa));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  void myFunction()async{
    // Your function code goes here
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    var expiryDate = prefs.getBool('expiryDate') ?? false;
    var expire =checkExpire(expiryDate);
    if(expire){

    }
    else{

    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Repository.bgColor(context),

      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: SvgPicture.asset("assets/svg/company.svg"),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(expTitle,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Your Company Have Expired.\n Please Contact us to Renew Your Plan."
                ,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,

                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'call_us'.tr,
                style:
                TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _copyToClipboard();
                    },
                    child: Text(
                      india,
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    "|",
                    style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      copyPhone();
                    },
                    child: Text(
                      ksa,
                      style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,

                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "support@vikncodes.com",
                style: TextStyle(color: Colors.greenAccent),
              ),
              const SizedBox(
                height: 4,
              ),

            ],
          ),
        ),
      ),
    );
  }


  expiryDateCheck(){
    ///api value here
    var asd="2022-10-30";
    expDate=DateTime.parse(asd);
    ///current date
    currDate=DateTime.now();
    print("expDate========$expDate");
    print("currDate========$currDate");

    ///to get diff of exp date and current date
    var diff = expDate.difference(currDate).inDays;


    if(expDate.compareTo(currDate) > 0) {
      print("Date is not Expired");
      if(diff <= 15){
        print("Plan Expires In ${diff} Days");
        setState(() {
          expTitle="Your company expires in ${diff+1} days";
        });
      }
      else if(diff == 0){
        setState(() {
          expTitle="Company Expires Today";

        });
      }
      else{
        setState(() {
          expTitle="";

        });
        ///exp more thn valid date
      }

      ///working
    }

    else{
      if( diff == 0 && currDate.day == expDate.day){
        setState(() {
          expTitle="Company Expired today";
        });
      }
      else{
        setState(() {
          expTitle="Company Expired ";
        });
      }


      print("Expired");
    }
  }



}
