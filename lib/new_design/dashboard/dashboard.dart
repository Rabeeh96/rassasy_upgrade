import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/new_design/auth_user/profie/profile.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/back_ground_print/USB/test_page/usb_test_page.dart';
import 'package:rassasy_new/new_design/back_ground_print/bluetooth/test_page/test_page_bluetooth.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/test_page/print_settings.dart';
import 'package:rassasy_new/new_design/dashboard/invoices/view_invoice.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/view/flavour/floavour_list_mobile.dart';
import 'package:rassasy_new/new_design/dashboard/mobile_section/view/tax_mobile/tax_list_mobile.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/pos_main_page.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/tab_design/pos_list_tab_design.dart';
import 'package:rassasy_new/new_design/dashboard/pos/MobileDesign/view/tab_design/pos_order_page.dart';
import 'package:rassasy_new/new_design/dashboard/product_group/product_group_new.dart';
import 'package:rassasy_new/new_design/dashboard/profile_mobile/web.dart';
import 'package:rassasy_new/new_design/dashboard/tax/test.dart';
import 'package:rassasy_new/new_design/organization/mob_oganisation_list.dart';
import 'package:rassasy_new/new_design/report/new_report_page.dart';
import 'package:rassasy_new/setting/settings_page.dart';
import 'package:rassasy_new/test/local_db/data_base_working.dart';
import 'package:rassasy_new/test/local_db/view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customer/customer_detail_page.dart';
import 'flavour/view_flavour.dart';
import 'mobile_section/view/customer/customer_list_mobile.dart';
import 'mobile_section/view/invoice/invocie_list_mobile.dart';
import 'mobile_section/view/product/product_list_mobile.dart';
import 'mobile_section/view/product_group/product_group_list.dart';
import 'pos/new_method/pos_list_section.dart';
import 'product/create_products.dart';
import 'profile_mobile/about_us/about_us_page.dart';
import 'profile_mobile/contact_us/contact_us.dart';
import 'profile_mobile/profile_controller.dart';
import 'profile_mobile/settings/new_settingsSection.dart';
import 'tax/create_tax_new.dart';

class DashboardNew extends StatefulWidget {
  @override
  State<DashboardNew> createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {
  bool networkConnection = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataForStaff();
    profileController.getProfileData();
  }

  ProfileController profileController = Get.put(ProfileController());

  dataForStaff() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var isArabic = prefs.getBool('isArabic') ?? false;
      if (isArabic) {
        Get.updateLocale(const Locale('ar'));
      } else {
        Get.updateLocale(const Locale('en', 'US'));
      }
      baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
      userName = prefs.getString('user_name') ?? '';
      companyName = prefs.getString('companyName') ?? '';
      companyType = prefs.getString('companyType') ?? '';
      expireDate = prefs.getString('expiryDate') ?? '';
      organisationLogo = prefs.getString('companyLogo') ?? 'https://www.gravatar.com/avatar/0?s=46&d=identicon&r=PG&f=1';
      settingsPermission = prefs.getBool('General Setting') ?? false;
    });
  }

  Future<Null> defaultData() async {
    start(context);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        stop();
        networkConnection = false;
      });
    } else {
      try {
        //  HttpOverrides.global = MyHttpOverrides();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
        var userID = prefs.getInt('user_id') ?? 0;
        var companyID = prefs.getString('companyID') ?? 0;
        var branchID = prefs.getInt('branchID') ?? 1;
        var accessToken = prefs.getString('access') ?? '';

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
        print(response.body);

        var status = n["success"];
        if (status == 6000) {
          setState(() {
            userName = prefs.getString('user_name') ?? '';
            companyName = prefs.getString('companyName') ?? '';
            companyType = prefs.getString('companyType') ?? '';
            expireDate = prefs.getString('expiryDate') ?? '';

            networkConnection = true;
            var frmDate = n["financial_FromDate"].substring(0, 10);
            var toDate = n["financial_ToDate"].substring(0, 10);
            prefs.setString("financial_FromDate", frmDate);
            prefs.setString("financial_ToDate", toDate);
            prefs.setString("Country", n["Country"]);
            prefs.setString("CountryName", n["CountryName"]);
            prefs.setString("State", n["State"]);
            prefs.setString("CurrencySymbol", n["CurrencySymbol"]);
            var settingsData = n['settingsData'];
            prefs.setBool("checkVat", settingsData["VAT"]);
            prefs.setBool("check_GST", settingsData["GST"]);
            prefs.setInt("Cash_Account", n["Cash_Account"] ?? 1);
            prefs.setString("QtyDecimalPoint", settingsData["QtyDecimalPoint"]);
            prefs.setString("PriceDecimalPoint", settingsData["PriceDecimalPoint"]);
            prefs.setString("RoundingFigure", settingsData["RoundingFigure"]);
            prefs.setBool("EnableExciseTax", settingsData["EnableExciseTax"] ?? false);
            prefs.setInt("user_type", n["user_type"]);
          });
          stop();
        } else if (status == 6001) {
          stop();
        } else {
          stop();
        }
      } catch (e) {
        stop();

        print(e.toString());
        print('Error In Loading');
      }
    }
  }

  returnBool(String data) {
    if (data == "true") {
      return true;
    } else {
      return false;
    }
  }

  Future<void> selectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        await defaultDataInitial(context: context);
        await userTypeData(true);
        break;
      case 1:
        if (settingsPermission) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SettingsPage()));
        } else {
          dialogBoxPermissionDenied(context);
        }

        break;
      case 2:
        company_info(context);
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfilePage()));

        break;

      case 4:
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var printType = prefs.getString('PrintType') ?? "Wifi";


        if (printType == 'Wifi') {
          Get.to(PrintSettingsPage());
        } else if (printType == 'USB') {
          Get.to(const TestPrintUSB());
        } else {
          Get.to(const TestPrintBT());
        }



        // if (printType == "Wifi") {
        //   /// re paced with detailed settings
        //   // Navigator.of(context).push(
        //   //   MaterialPageRoute(builder: (context) => PrintSettings()),
        //   // );
        //
        //   Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => PrintSettingsDetailed()),
        //   );
        // }
        //
        //
        // else {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(builder: (context) => TestPrintUSB()),
        //   );
        // }

        break;
      case 5:
        SharedPreferences prefs = await SharedPreferences.getInstance();
      //  var posUser = prefs.getBool('isPosUser')??false;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const EnterPinNumber()),
        );

        // if (posUser == true) {
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => const EnterPinNumber()),
        //   );
        // } else if (posUser == false) {
        //   prefs.setBool('isLoggedIn', false);
        //   prefs.setBool('companySelected', false);
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(builder: (context) => LoginPageNew()),
        //   );
        // }

        break;
    }
  }

  var companyName = "";
  bool settingsPermission = false;
  var userName = "";
  String india = "+91 905775 00400";
  String ksa = "+966 533133 4959";
  var companyType = "";
  var expireDate = "";
  var organisationLogo = "";

  company_info(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
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
              Text(
                companyName,
                style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Your Company Will Expired on $expireDate.\n Please Contact us to Renew Your Plan",
                style: const TextStyle(
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
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      india,
                      style: const TextStyle(
                        color: Color(0xff000000),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  const Text(
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
                    onTap: () {},
                    child: Text(
                      ksa,
                      style: const TextStyle(
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
              const Text(
                "support@vikncodes.com",
                style: TextStyle(color: Colors.greenAccent),
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),

          // content: const Text(
          //     'Are Sure Want to Exit?.'),
        );
      },
    );
  }

  ValueNotifier<bool> isProfileNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

   bool isTablet = true;
  //  bool isTablet = screenWidth > defaultScreenWidth;
    return Scaffold(
      appBar: isProfileNotifier.value
          ?AppBar(
              toolbarHeight: .1,
            )
          :AppBar(
              elevation: 0.0,
              automaticallyImplyLeading: false,
              backgroundColor: isTablet == true ? Color(0xffF3F3F3) : Colors.white,
              titleSpacing: 25,
              title: isTablet == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dashboard'.tr,
                          style: customisedStyle(context, Colors.black, FontWeight.normal, 24.0),
                          //  style: TextStyle(color: Colors.black, fontSize: 24),
                        ),
                      ],
                    )
                  : Text(
                      'Home',
                      style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
                      //  style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
              actions: [

                // IconButton(
                //     onPressed: () {
                //       Get.to(PosListTabDesign());
                //     },
                //     icon:Text("Pos List")),
                // IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => PosOrderPage(
                //               orderType: 4,
                //               sectionType: "Create",
                //               uID: "",
                //               tableHead: "Order",
                //               tableID: "",
                //               cancelOrder: [],
                //             )),
                //       );
                //     },
                //     icon:Text("Pos Order")),
                isTablet == true
                    ? Theme(
                        data: Theme.of(context).copyWith(
                            textTheme: const TextTheme().apply(bodyColor: Colors.black),
                            dividerColor: Colors.white,
                            iconTheme: const IconThemeData(color: Colors.black)),
                        child: PopupMenuButton<int>(
                          color: Colors.white,
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                                value: 0,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.refresh,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'Refresh'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                            const PopupMenuDivider(),

                            // settings permission

                            PopupMenuItem<int>(
                                value: 1,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.settings,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'Settings'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(
                                value: 2,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'com_info'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(
                                value: 3,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.manage_accounts,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'Profile'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(
                                value: 4,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.print,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "Print test page".tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                            const PopupMenuDivider(),
                            PopupMenuItem<int>(
                                value: 5,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.info,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'user_log_out'.tr,
                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                    )
                                  ],
                                )),
                          ],
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          onSelected: (item) => selectedItem(context, item),
                        ),
                      )
                    : Icon(
                        Icons.remove,
                        color: Colors.transparent,
                      ),
              ],
            ),
      //body:networkConnection == true ? isTablet == true ? dashboardPage() : dashboardPageMobile() : noNetworkConnectionPage(),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          backgroundColor: Colors.black,
          content: Text('Tap back again to leave', style: customisedStyle(context, Colors.white, FontWeight.w400, 15.0)),
        ),
        child: networkConnection == true
            ? isTablet == true
                ? dashboardPage()
                : dashboardPageMobile()
            : noNetworkConnectionPage(),
      ),
      bottomNavigationBar: isTablet == true
          ? Container(
              height: 1,
            ):Container(
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xffE9E9E9), width: 1))),
              height: MediaQuery.of(context).size.height / 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(

                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        isProfileNotifier.value = false;
                        setState(() {});
                      },
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/_mobhome.svg",
                              color: isProfileNotifier.value ? Color(0xff9E9E9E) : Color(0xffF25F29),
                            ),
                            Text(
                              "Home",
                              style:
                                  customisedStyleBold(context, isProfileNotifier.value ? Color(0xff9E9E9E) : Color(0xffF25F29), FontWeight.normal, 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(

                    width: 100,
                    child: GestureDetector(
                      onTap: () {
                        isProfileNotifier.value = true;
                      setState(() {});
                      },
                      child: InkWell(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/profile_mob.svg",
                              color: isProfileNotifier.value ? Color(0xffF25F29) : Color(0xff9E9E9E),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 2.0),
                              child: Text(
                                'Profile'.tr,
                                style: customisedStyleBold(
                                    context, isProfileNotifier.value ? Color(0xffF25F29) : Color(0xff9E9E9E), FontWeight.normal, 12.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// set up user role
  setupWaiterRole() {}

  Widget noNetworkConnectionPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/svg/warning.svg",
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            'no_network'.tr,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Future.delayed(Duration.zero, () async {
                await userTypeData(true);
                await defaultData();
              });
            },
            child: Text('retry'.tr,
                style: const TextStyle(
                  color: Colors.white,
                )),
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xffEE830C))),
          ),
        ],
      ),
    );
  }

  Widget dashboardPage() {
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    bool isTablet = true;
  //  bool isTablet = screenWidth > defaultScreenWidth;
    print(isTablet);
    print(screenWidth);
    print("dash");
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4,
              height: MediaQuery.of(context).size.height / 1.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(onPressed: (){
                  //
                  // //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>   ProductFormPage()));
                  //
                  // }
                  //
                  //     , child: Text("Local DB")),


                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var perm = await checkingPerm("Groupview");
                                print(perm);
                                if (perm) {
                                  // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>  RMS()));
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const AddProductGroup()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder:
                                //             (BuildContext context) =>
                                //            testing()));
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/product_group.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'Group'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var perm = await checkingPerm("Productview");
                                print(perm);
                                if (perm) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateProductNew()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/product.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'Products'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var perm = await checkingPerm("Customerview");
                                print(perm);
                                if (perm) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AddCustomerNew()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/customer.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'customer'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/POS.svg'),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                var dinePerm = await checkingPerm("Diningview");
                                var takeAwayPerm = await checkingPerm("Take awayview");
                                var carPerm = await checkingPerm("Carview");

                                if (dinePerm == true || takeAwayPerm == true || carPerm == true) {
                                  isTablet
                                      ? Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const POSListItemsSection()))
                                      : Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const POSListItemsSection()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }

                                //
                                // if(waiterController.text ==""){
                                // //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const POSPage()));
                                //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const POSListItemsSection()));
                                // }
                                // else{
                                //  popupAlert("Confirm ${waiterController.text} is ready to use",1);
                                // }
                                //
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                "POS".tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var salesReport = await checkingPerm("Sale Report");
                                var tableWiseReport = await checkingPerm("Table Wise Report");
                                var productReport = await checkingPerm("Product Report");

                                var rmsReport = await checkingPerm("RMS Report");

                                var diningReport = await checkingPerm("Dining Report");

                                var takeAwayReport = await checkingPerm("Take Away Report");

                                var carReport = await checkingPerm("Car Report");

                                ///     var salesReport = await checkingPerm("Online Report");

                                if (salesReport == true ||
                                    tableWiseReport == true ||
                                    productReport == true ||
                                    rmsReport == true ||
                                    diningReport == true ||
                                    takeAwayReport == true ||
                                    carReport == true) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ReportPageNew()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/report.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'Report'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => SettingsPageDemo()),
                                // );

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddTax()),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/tax.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'tax'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var flavour = await checkingPerm("Flavourview");

                                if (flavour == true) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewFlavour()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => MyListView()),
                                // );
                                //
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/flavour.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'Flavour'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var invoices = await checkingPerm('Invoices'.tr);

                                if (invoices == true) {
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewInvoice()));
                                } else {
                                  dialogBoxPermissionDenied(context);
                                }

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => AddInvoice()),
                                // );
                              },
                              child: Container(
                                decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                height: MediaQuery.of(context).size.height / 12,
                                width: MediaQuery.of(context).size.width / 17,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 20,
                                      width: MediaQuery.of(context).size.width / 20,
                                      child: SvgPicture.asset('assets/svg/invoice.svg'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 12,
                              ),
                              child: Text(
                                'Invoices'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                          ],
                        ),

                        /// daily report commented
                        // Column(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () async {
                        //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DailyReport()));
                        //
                        //         // Navigator.push(
                        //         //     context,
                        //         //     MaterialPageRoute(
                        //         //         builder: (BuildContext context) =>
                        //         //             const DragableList()));
                        //
                        //         // var invoices = await checkingPerm('Invoices'.tr);
                        //         //
                        //         // if (invoices == true) {
                        //         //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewInvoice()));
                        //         //
                        //         // } else {
                        //         //   dialogBoxPermissionDenied(context);
                        //         // }
                        //       },
                        //       child: Container(
                        //         decoration: const BoxDecoration(
                        //             color: Color(0xffEEEEEE),
                        //             borderRadius:
                        //             BorderRadius.all(Radius.circular(20))),
                        //         height: isTablet
                        //             ? screenHeight / 12
                        //             : screenHeight / 15,
                        //         width: isTablet
                        //             ? screenWidth / 17
                        //             : screenWidth / 6,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Container(
                        //               height:
                        //               MediaQuery.of(context).size.height /
                        //                   20,
                        //               width: MediaQuery.of(context).size.width /
                        //                   20,
                        //               child: SvgPicture.asset(
                        //                   'assets/svg/report.svg'),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(
                        //         top: 12,
                        //       ),
                        //       child: Text(
                        //         'Daily Report'.tr,
                        //         style: const TextStyle(fontSize: 12),
                        //       ),
                        //     )
                        //   ],
                        // ),
                        /// new taxz commented
                        // Column(
                        //   children: [
                        //     GestureDetector(
                        //       onTap: () {
                        //
                        //         Navigator.push(
                        //           context,
                        //           MaterialPageRoute(builder: (context) => TaxCategory()),
                        //         );
                        //       },
                        //       child: Container(
                        //         decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                        //         height: MediaQuery.of(context).size.height / 12,
                        //         width: MediaQuery.of(context).size.width / 17,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Container(
                        //               height: MediaQuery.of(context).size.height / 20,
                        //               width: MediaQuery.of(context).size.width / 20,
                        //               child: SvgPicture.asset('assets/svg/tax.svg'),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     const Padding(
                        //       padding: EdgeInsets.only(
                        //         top: 12,
                        //       ),
                        //       child: Text(
                        //         'New tax',
                        //         style: TextStyle(fontSize: 12),
                        //       ),
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
  Future<void> _refresh() async {
    // Simulate network request
    userTypeData(true);
  }

  refreshData(){

  }
  Widget dashboardPageMobile() {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;

    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    // bool isTablet = true;
    bool isTablet = screenWidth > defaultScreenWidth;

    return isProfileNotifier.value
        ? SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Container(

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
                                width: mHeight * .92,
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFF6F2),

                                    // const Color(0xffE6E6E6)
                                    borderRadius: BorderRadius.circular(25)),
                                child: Obx(() => Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 16.0, left: 0, right: 6),
                                          child: Container(
                                            height: mHeight * .090,
                                            width: mWidth * .846,
                                            decoration: const BoxDecoration(
                                                // border: Border.all(color: Colors.black,width: 1),
                                                ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: mHeight * .080,
                                                    width: mWidth * .180,
                                                    decoration: BoxDecoration(color: Colors.white38, borderRadius: BorderRadius.circular(22)),
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Image.network("https://www.gravatar.com/avatar/1?s=46&d=identicon&r=PG&f=1")),
                                                    // child: Image.network(photo)),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        profileController.userName.value,
                                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.5),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Text(
                                                        profileController.mail.value,
                                                        style: customisedStyle(context, const Color(0xff7D7D7D), FontWeight.w400, 13.5),
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
                                            width: mWidth * .845,
                                            decoration: BoxDecoration(
                                                color: const Color(0xffffffff),
                                                border: Border.all(width: 1.5, color: Colors.grey.withOpacity(.05)),
                                                borderRadius: BorderRadius.circular(11)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Padding(
                                                  padding: const EdgeInsets.only(left: 16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Organization',
                                                        style: customisedStyle(context, const Color(0xff7D7D7D), FontWeight.w400, 14.0),
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      Text(
                                                        profileController.companyName.value,
                                                        style: customisedStyle(context, Colors.black, FontWeight.w500, 15.0),
                                                        textAlign: TextAlign.left,
                                                      )
                                                    ],
                                                  ),
                                                )),
                                                Column(
                                                  children: [
                                                    const Text(""),
                                                    Container(
                                                      height: mHeight * .05,
                                                      width: mWidth * .3,
                                                      decoration: const BoxDecoration(color: Color(0xffFFFFFF)),
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          bottomDialogueFunction(
                                                              isDismissible: true,
                                                              context: context,
                                                              textMsg: ' Change organisation ?',
                                                              fistBtnOnPressed: () {
                                                                Navigator.of(context).pop(true);
                                                              },
                                                              secondBtnPressed: () async {
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(builder: (context) => MobOrganizationList()),
                                                                );
                                                              },
                                                              secondBtnText: 'Yes');
                                                        },
                                                        child: Text(
                                                          'change'.tr,
                                                          style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 15.0),
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
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(builder: (BuildContext context) => DeleteAccount()));
                                                      },
                                                      secondBtnText: 'Ok');
                                                },
                                                child: Container(
                                                  height: mHeight * .06,
                                                  width: mWidth * .43,
                                                  decoration: BoxDecoration(color: const Color(0xffFfffff), borderRadius: BorderRadius.circular(25)),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                          left: 6.0,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          "assets/svg/delete_mobile.svg",
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 5.0, right: 6),
                                                        child: Text(
                                                          'dlt_acnt'.tr,
                                                          style: customisedStyle(context, const Color(0xffC80000), FontWeight.w400, 15.0),
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
                                                              builder: (context) => LoginPageNew(),
                                                            ),
                                                            (route) => false);
                                                      },
                                                      secondBtnText: 'Yes');
                                                },
                                                child: Container(
                                                  width: mWidth * .34,
                                                  height: mHeight * .06,
                                                  decoration: BoxDecoration(color: const Color(0xffFFCFCF), borderRadius: BorderRadius.circular(25)),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset("assets/svg/logout_mobile.svg"),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: Text(
                                                          'logout'.tr,
                                                          style: customisedStyle(context, const Color(0xffEA6262), FontWeight.w400, 15.0),
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
                          onTap: () async{
                            Get.to(SettingsMobilePage(generalSettingsPermission: settingsPermission,));


                          },
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 8, top: 15, bottom: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset("assets/svg/settings_mobile.svg"),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'Settings'.tr,
                                          style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
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
                        dividerStyle(),
                        GestureDetector(
                          onTap: () async {
                            ///
                            ///
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                            var printType =
                                prefs.getString('PrintType') ?? 'Wifi';
                            if (printType == 'Wifi') {
                              Get.to(PrintSettingsPage());
                            } else if (printType == 'USB') {
                              Get.to(TestPrintUSB());
                            } else {
                              Get.to(TestPrintBT());
                            }
                          },
                          child: InkWell(
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 15, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Icon(
                                            Icons.print_outlined,
                                            size: 25,
                                            color: Color(0xffF25F29),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10.0),
                                            child: Text(
                                              'Test Print',
                                              style: customisedStyle(
                                                  context,
                                                  Colors.black,
                                                  FontWeight.w400,
                                                  16.0),
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
                              )),
                        ),

                        dividerStyle(),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15, bottom: 15),
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
                                            style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
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

                        dividerStyle(),
                        GestureDetector(
                          onTap: () {
                            Get.to(AboutUs());
                          },
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15, bottom: 15),
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
                                          style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
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
                        dividerStyle(),
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            Locale? currentLocale = Get.locale;
                            if (currentLocale.toString() == "ar") {
                              prefs.setBool('isArabic', false);
                              Get.updateLocale(const Locale('en', 'US'));
                            } else {
                              prefs.setBool('isArabic', true);
                              Get.updateLocale(const Locale('ar'));
                            }
                          },
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 15, bottom: 15),
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
                                          'lang'.tr,
                                          style: customisedStyle(context, Colors.black, FontWeight.w400, 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'lang'.tr,
                                    style: customisedStyle(context, Color(0xff7D7D7D), FontWeight.normal, 14.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),



                      ],
                    ),
                  )),
            ),
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: RefreshIndicator(
              onRefresh: _refresh,

              child: ListView(
                children: [

                  dividerStyle(),
                  Container(
                    height: screenHeight / 12,
                    width: MediaQuery.of(context).size.width / 1,
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: .1, color: Colors.grey))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          //     Get.to(MobOrganizationList());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            organisationLogo == ''
                                ? const Icon(
                                    Icons.circle,
                                    color: Color(0xffF4F4F4),
                                    size: 30,
                                  )
                                : CircleAvatar(backgroundImage: NetworkImage(organisationLogo), maxRadius: 13),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                companyName,
                                style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),
                              ),
                            ),
                          ],
                        ),
                        // child: Row(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //
                        //
                        //     const Icon(
                        //       Icons.circle,
                        //       color: Color(0xffF4F4F4),
                        //     ),
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 8.0),
                        //       child: Text(
                        //         "Organization",
                        //         style: customisedStyleBold(
                        //             context, Colors.black, FontWeight.w400, 15.0),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth / 1.1,
                    height: screenHeight / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      //   updateAlert();
                                      var perm = await checkingPerm("Groupview");
                                      print(perm);
                                      if (perm) {
                                        Get.to(ProductGroupMobile());
                                      } else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 11,
                                            child: SvgPicture.asset('assets/svg/product_group.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'Group'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      var perm = await checkingPerm("Productview");

                                      if (perm) {
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductListMobile()));
                                      }
                                      else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 10,
                                            child: SvgPicture.asset('assets/svg/product.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'Products'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // updateAlert();
                                      // Get.to(TestPrintUSB());
                                      var perm = await checkingPerm("Customerview");
                                      print(perm);
                                      if (perm) {
                                        Get.to(CustomerListMobile());
                                      } else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: SvgPicture.asset('assets/svg/customer.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'customer'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      updateAlert();
                                      // var salesReport =
                                      //     await checkingPerm("Sale Report");
                                      // var tableWiseReport =
                                      //     await checkingPerm("Table Wise Report");
                                      // var productReport =
                                      //     await checkingPerm("Product Report");
                                      //
                                      // var rmsReport =
                                      //     await checkingPerm("RMS Report");
                                      //
                                      // var diningReport =
                                      //     await checkingPerm("Dining Report");
                                      //
                                      // var takeAwayReport =
                                      //     await checkingPerm("Take Away Report");
                                      //
                                      // var carReport =
                                      //     await checkingPerm("Car Report");
                                      //
                                      // ///     var salesReport = await checkingPerm("Online Report");
                                      //
                                      // if (salesReport == true ||
                                      //     tableWiseReport == true ||
                                      //     productReport == true ||
                                      //     rmsReport == true ||
                                      //     diningReport == true ||
                                      //     takeAwayReport == true ||
                                      //     carReport == true) {
                                      //   Navigator.push(
                                      //       context,
                                      //       MaterialPageRoute(
                                      //           builder: (BuildContext context) =>
                                      //               const ReportPageNew()));
                                      // } else {
                                      //   dialogBoxPermissionDenied(context);
                                      // }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 13,
                                            child: SvgPicture.asset('assets/svg/report.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'Report'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: SvgPicture.asset('assets/svg/POS.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      var dinePerm = await checkingPerm("Diningview");
                                      var takeAwayPerm = await checkingPerm("Take awayview");
                                      var carPerm = await checkingPerm("Carview");

                                      if (dinePerm == true || takeAwayPerm == true || carPerm == true) {
                                        Get.to(POSMobilePage());
                                      } else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      "POS".tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),

                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(TaxListMobile());
                                      ///  updateAlert();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 12,
                                            child: SvgPicture.asset('assets/svg/tax.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'tax'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {

                                      var flavour = await checkingPerm("Flavourview");
                                      if (flavour == true) {
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FlavourListMobile()));
                                      } else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 10,
                                            child: SvgPicture.asset('assets/svg/flavour.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'Flavour'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 35,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {

                                      var invoices = await checkingPerm('Invoices'.tr);
                                      if (invoices == true) {
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => InvoiceListMobile()));
                                      } else {
                                        dialogBoxPermissionDenied(context);
                                      }
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                                      height: screenHeight / 12,
                                      width: screenWidth / 5.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context).size.height / 20,
                                            width: MediaQuery.of(context).size.width / 14,
                                            child: SvgPicture.asset('assets/svg/invoice.svg'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 12,
                                    ),
                                    child: Text(
                                      'Invoices'.tr,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),

                              /// daily report commented
                              //      Column(
                              //        children: [
                              //          // GestureDetector(
                              //          //   onTap: () async {
                              //          //        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DailyReport()));
                              //          //
                              //          //     // Navigator.push(
                              //          //     //     context,
                              //          //     //     MaterialPageRoute(
                              //          //     //         builder: (BuildContext context) =>
                              //          //     //             const DragableList()));
                              //          //
                              //          //     // var invoices = await checkingPerm('Invoices'.tr);
                              //          //     //
                              //          //     // if (invoices == true) {
                              //          //     //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ViewInvoice()));
                              //          //     //
                              //          //     // } else {
                              //          //     //   dialogBoxPermissionDenied(context);
                              //          //     // }
                              //          //   },
                              //          //   child: Container(
                              //          //     decoration: const BoxDecoration(
                              //          //         color: Color(0xffEEEEEE),
                              //          //         borderRadius:
                              //          //             BorderRadius.all(Radius.circular(20))),
                              //          //     height: isTablet
                              //          //         ? screenHeight / 12
                              //          //         : screenHeight / 15,
                              //          //     width: isTablet
                              //          //         ? screenWidth / 17
                              //          //         : screenWidth / 6,
                              //          //     child: Row(
                              //          //       mainAxisAlignment: MainAxisAlignment.center,
                              //          //       crossAxisAlignment: CrossAxisAlignment.center,
                              //          //       children: [
                              //          //         Container(
                              //          //           height:
                              //          //               MediaQuery.of(context).size.height /
                              //          //                   20,
                              //          //           width: MediaQuery.of(context).size.width /
                              //          //               20,
                              //          //           child: SvgPicture.asset(
                              //          //               'assets/svg/report.svg'),
                              //          //         ),
                              //          //       ],
                              //          //     ),
                              //          //   ),
                              //          // ),
                              //          // Padding(
                              //          //   padding: const EdgeInsets.only(
                              //          //     top: 12,
                              //          //   ),
                              //          //   child: Text(
                              //          //     'Daily Report'.tr,
                              //          //     style: const TextStyle(fontSize: 12),
                              //          //   ),
                              //          // )
                              //        ],
                              //      ),

                              /// new taxz commented
                              // Column(
                              //   children: [
                              //     GestureDetector(
                              //       onTap: () {
                              //
                              //         Navigator.push(
                              //           context,
                              //           MaterialPageRoute(builder: (context) => TaxCategory()),
                              //         );
                              //       },
                              //       child: Container(
                              //         decoration: const BoxDecoration(color: Color(0xffEEEEEE), borderRadius: BorderRadius.all(Radius.circular(20))),
                              //         height: MediaQuery.of(context).size.height / 12,
                              //         width: MediaQuery.of(context).size.width / 17,
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.center,
                              //           crossAxisAlignment: CrossAxisAlignment.center,
                              //           children: [
                              //             Container(
                              //               height: MediaQuery.of(context).size.height / 20,
                              //               width: MediaQuery.of(context).size.width / 20,
                              //               child: SvgPicture.asset('assets/svg/tax.svg'),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     const Padding(
                              //       padding: EdgeInsets.only(
                              //         top: 12,
                              //       ),
                              //       child: Text(
                              //         'New tax',
                              //         style: TextStyle(fontSize: 12),
                              //       ),
                              //     )
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  Future<Null> userTypeData(type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
    } else {
      try {
        if (type) {
          start(context);
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var branchID = prefs.getInt('branchID') ?? 1;
        var companyID = prefs.getString('companyID') ?? '';
        userName = prefs.getString('user_name') ?? '';
        companyName = prefs.getString('companyName') ?? '';
        companyType = prefs.getString('companyType') ?? '';
        expireDate = prefs.getString('expiryDate') ?? '';
        baseURlApi = prefs.getString('BaseURL') ?? 'https://www.api.viknbooks.com';
        String baseUrl = BaseUrl.baseUrlV11;
        var token = prefs.getString('access') ?? '';
        var roleID = prefs.getString('role') ?? '';
        final String url = '$baseUrl/posholds/list-detail/pos-role/';
        print(url);
        Map data = {"CompanyID": companyID, "Role_id": roleID, "BranchID": branchID};
        print(data);
        var body = json.encode(data);
        var response = await http.post(Uri.parse(url),
            headers: {
              "Content-Type": "application/json",
              'Authorization': 'Bearer $token',
            },
            body: body);

        Map n = json.decode(utf8.decode(response.bodyBytes));
        print(response.body);
        print(token);
        var status = n["StatusCode"];
        var userRollData = n["data"] ?? [];
        if (status == 6000) {
          for (var i = 0; i < userRollData.length; i++) {
            if (userRollData[i]["Key"] == "other" || userRollData[i]["Key"] == "report") {
              prefs.setBool(userRollData[i]["Name"], userRollData[i]["Value"]);
            } else {
              prefs.setBool(userRollData[i]["Name"] + userRollData[i]["Key"], userRollData[i]["Value"]);
            }
          }
          dataForStaff();
          if (type) {
            stop();
          }
        } else if (status == 6001) {
          if (type) {
            stop();
          }
        } else {}
      } catch (e) {
        if (type) {
          stop();
        }
      }
    }
  }

  /// new user changes old method
// bool diningStatus = false;
// bool carStatus = false;
// bool onlineStatus = false;
// bool takeawayStatus = false;
// bool isSelectPos = false;
// bool isSelectWaiter = false;

// setUserRole(type, value) async {
//   print("_____________________________________-type   $type   $value");
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//
//   if (type == 1) {
//     prefs.setBool('IsSelectPos', value);
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => POSListItemsSection()));
//   }
//   if (type == 2) {
//     ///  waiterController.clear();
//     prefs.setBool('IsSelectPos', value);
//     prefs.setBool('IsSelectWaiter', value);
//   } else {
//     ///     prefs.setString('waiterNameInitial', waiterController.text);
//     prefs.setBool('IsSelectWaiter', value);
//     prefs.setBool('diningStatusPermission', diningStatus);
//     prefs.setBool('carStatusPermission', carStatus);
//     prefs.setBool('onlineStatusPermission', onlineStatus);
//     prefs.setBool('takeawayStatusPermission', takeawayStatus);
//   }
// }
//
// void popupAlert(content, type) {
//   showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return Padding(
//           padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//           child: AlertDialog(
//             title: const Padding(
//               padding: EdgeInsets.all(0.5),
//               child: Text(
//                 "Alert!",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             content: Text(content),
//             shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
//             actions: <Widget>[
//               TextButton(
//                   onPressed: () => {
//                         Navigator.pop(context),
//                         if (type == 2)
//                           {
//                             setUserRole(2, false),
//                           }
//                         else
//                           {
//                             setUserRole(1, true),
//                           }
//                       },
//                   child: const Text(
//                     'Ok',
//                     style: TextStyle(color: Colors.black),
//                   )),
//               TextButton(
//                   onPressed: () => {
//                         Navigator.pop(context),
//                       },
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(color: Colors.black),
//                   )),
//             ],
//           ),
//         );
//       });
// }
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
          style: const TextStyle(color: Colors.black, fontSize: 13),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Yes'.tr, style: const TextStyle(color: Colors.red)),
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
            child: Text('No'.tr, style: const TextStyle(color: Colors.black)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.cancel);
            },
          ),
        ],
      );
    },
  );
}
