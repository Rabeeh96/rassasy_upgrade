import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/car_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/payment/payment_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/pos_main_page.dart';
import 'package:rassasy_new/new_design/organization/mob_oganisation_list.dart';
import 'package:rassasy_new/test/local_db/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart' if (dart.library.html) '';

import 'global/global.dart';
import 'localisation/localisation.dart';
import 'new_design/auth_user/user_pin/employee_pin_no.dart';
import 'new_design/organization/list_organization.dart';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
///code commented here
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//
//
//   bool isTablet = isTabletDevice();
//   print("main  $isTablet");
//   /// Set preferred orientations based on the device type
//   ///
//   if (isTablet) {
//
//
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]).then((_) {
//       runApp(MyApp());
//     });
//
//
//   } else {
//     print("else  $isTablet");
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]).then((_) {
//       runApp(MyApp());
//     });
//   }
// }


import 'package:path_provider/path_provider.dart' as path_provider;
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    doWhenWindowReady(() {
      const initialSize = Size(800, 600);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.maximize();
      appWindow.show();
    });
  }


  SharedPreferences.getInstance().then((prefs) {

    //   bool isTablet = true;
     bool isTablet = prefs.getBool('isTablet')??isTabletDevice();
     isTabDesign=isTablet;
     prefs.setBool('isTablet',isTablet); // Save isTablet value to SharedPreferences
     print("main isTablet: $isTablet");

    SystemChrome.setPreferredOrientations([
       isTablet ? DeviceOrientation.landscapeLeft : DeviceOrientation.portraitUp,
       isTablet ? DeviceOrientation.landscapeRight : DeviceOrientation.portraitDown,
    ]).then((_) {
      runApp(MyApp(isTablet: isTablet));
    });
  });
}

bool isTabletDevice() {

  /// Determine if the device is a tablet based on the screen width
  double screenWidth = MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
  print("--screenWidth  $screenWidth   ---------  defaultScreenWidth   $defaultScreenWidth");

  /// You may need to adjust this threshold based on your requirements
  return screenWidth > defaultScreenWidth;
}



class MyApp extends StatelessWidget {
  final bool isTablet;

  MyApp({required this.isTablet});



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash dashboard while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          //  return MaterialApp(home: TestDemoPrintingOption());
          return GetMaterialApp(
              translations: LocaleChange(), locale: const Locale('en', 'US'), fallbackLocale: const Locale('en', 'US'), home: Splash());
        } else {
          // Loading is done, return the app:
          return GetMaterialApp(
            translations: LocaleChange(),
            locale: const Locale('en', 'US'),

            ///device language is not supported, we need to show the default langauge.
            ///For this, we’ve configured the fallbackLocale for the default language
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
                fontFamily: 'Poppins',
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                textSelectionTheme: const TextSelectionThemeData(
                  //  cursorColor: Colors.green,
                  selectionColor: Colors.transparent,
                  //  selectionHandleColor: Colors.blue,
                )),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(isTablet: isTablet),
            //  home: WaiterApi (),
            //       home: DragableList (),
          );
        }
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final bool isTablet;

  MyHomePage({required this.isTablet});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
     navigateUser();
    });
  }

//test
  void navigateUser() async {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isTablet = screenWidth > defaultScreenWidth;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    var companySelected = prefs.getBool('companySelected') ?? false;
    var isPosUser = true;

    /// var isPosUser = prefs.getBool('isPosUser') ?? false;
    print("isPosUser  $isPosUser");
    print(companySelected);
    if (status) {
      if (companySelected) {
        await defaultData(context: context,);
        var expireDate = prefs.getString('expiryDate') ?? '';
        var companyName = prefs.getString('companyName') ?? '';


        var expire = isDateExpired(expireDate);
        // var expire = checkExpire(expireDate);
        if (expire == true) {
          prefs.setBool('companySelected', false);
          await dialogBox(context, "$companyName Expired! Please Contact us(+91 95775 00400 | +966 53 313 4959 | +971 52295 6284)to continue");
/// commented
          // if (isTablet) {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OrganizationList()));
          // } else {
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MobOrganizationList()));
          // }

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OrganizationList()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EnterPinNumber()));

          /// pos user commented

          // if(isPosUser){
          //   if(selectPos){
          //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => POSListItemsSection()));
          //   }
          //   else{
          //     //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RassassyScreen()));
          //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EnterPinNumber()));
          //   }
          //
          // }
          // else{
          //   Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => DashboardNew()));
          // }
        }
      } else {


        /// commented

        if (isTablet) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OrganizationList()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MobOrganizationList()));
        }

        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => OrganizationList()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPageNew()));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
    }
  }

  Future defaultData({context}) async {

    final response;
    try {

      HttpOverrides.global = MyHttpOverrides();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var userID = prefs.getInt('user_id') ?? 0;
      var companyID = prefs.getString('companyID') ?? 0;
      var branchID = prefs.getInt('branchID') ?? 1;
      var accessToken = prefs.getString('access') ?? '';
      baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';

      String baseUrl = BaseUrl.baseUrl;

      final String url = '$baseUrl/users/get-default-values/';
      print(url);
      Map data = {"CompanyID": companyID, "userId": userID, "BranchID": branchID};
      print(data);
      print(accessToken);
      //encode Map to JSON
      var body = json.encode(data);
      var response = await http.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $accessToken',
          },
          body: body);
      Map n = json.decode(response.body);
      log("res ${response.body}");


      var status = n["StatusCode"];
      var msg = n["message"];
      if(status ==6000){

        var frmDate = n["financial_FromDate"].substring(0, 10);
        var toDate = n["financial_ToDate"].substring(0, 10);
        prefs.setString("financial_FromDate", frmDate);
        prefs.setString("financial_ToDate", toDate);
        prefs.setString("Country", n["Country"]);
        prefs.setString("CountryName", n["CountryName"]);
        prefs.setString("State", n["State"]);
        prefs.setString("CurrencySymbol", n["CurrencySymbol"]);
        prefs.setInt("Cash_Account", n["Cash_Account"]??1);
        var settingsData = n['settingsData'];
        prefs.setBool("checkVat", settingsData["VAT"]);
        prefs.setBool("check_GST", settingsData["GST"]);
        prefs.setString("QtyDecimalPoint", settingsData["QtyDecimalPoint"]);

        prefs.setString("expiryDate", settingsData["ExpiryDate"]);
        prefs.setString("PriceDecimalPoint", settingsData["PriceDecimalPoint"]);
        prefs.setString("RoundingFigure", settingsData["RoundingFigure"]);
        prefs.setBool("EnableExciseTax", settingsData["EnableExciseTax"]??false);
        prefs.setInt("user_type", n["user_type"]);
      }
      else{
        var errorMessage = n["error"]??n["error"]??"";
        dialogBox(context, errorMessage.toString());
      }

    } catch (e) {

      print(e.toString());


      dialogBox(context, e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/Logo.svg'),
              Text(
                appVersion,
                style: customisedStyle(context, Colors.grey, FontWeight.w500, 19.0),
              ),
            ],
          )),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/Logo.svg'),
          Text(
            appVersion,
            style: customisedStyle(context, Colors.grey, FontWeight.w500, 19.0),
          ),
        ],
      )),
    );
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
