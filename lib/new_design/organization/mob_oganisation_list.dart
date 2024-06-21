import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/login/login_page.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/organization/controller/company_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class MobOrganizationList extends StatefulWidget {
  @override
  State<MobOrganizationList> createState() => _MobOrganizationListState();
}

class _MobOrganizationListState extends State<MobOrganizationList> {
  final CompanyController companyController = Get.put(CompanyController());

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      companyController.getCompanyListDataDetails();
    });
  }



  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            _asyncConfirmDialog(context);
          //  Navigator.pop(context);
          },
        ),
        title: Text(
          "Organizations",
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
      body: Container(
        color: Colors.white,

        height: mHeight,
        // padding:  EdgeInsets.only(left: mWidth*.04, right: mWidth*.04),
        child: Column(
          children: [
            DividerStyle(),
            Expanded(
              child: Obx(() {
                if (companyController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffF25F29),
                    ),
                  );
                } else {
                  return companyController.companyListData.isEmpty
                      ? const Center(child: Text("No Companies Found"))
                      : ListView.separated(
                          separatorBuilder: (context, index) => DividerStyle(),
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: companyController.companyListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ExpansionTile(
                              onExpansionChanged: (v) async {
                                print("companyController.companyListDAta[index].branches!   ${companyController.companyListData[index].branches!}");

                                var expire = checkExpire(companyController.companyListData[index].expiryDate);
                                if (expire) {
                                  dialogBox(context, "${companyController.companyListData[index].companyName} Expired! Please Contact us(+91 95775 00400 | +966 53 313 4959 | +971 52295 6284)to continue");
                                } else {
                                  //var branchDetails=companyController.companyList[index].branchList??[];

                                  ///print("branchDetails  $branchDetails");

                                    if(companyController.companyListData[index].branches!.isEmpty){

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('companyName', companyController.companyListData[index].companyName!);
                                    prefs.setString('BaseURL', companyController.companyListData[index].BaseURL!);
                                    prefs.setString('expiryDate', companyController.companyListData[index].expiryDate!);
                                    prefs.setString('companyLogo', companyController.companyListData[index].companyLogo!);
                                  //  prefs.setString('permission', companyController.companyListData[index].);
                                    prefs.setString('edition', companyController.companyListData[index].edition!);
                                    //prefs.setBool('isPosUser', companyController.companyListData[index].isPosUser!);
                                    prefs.setString('companyID', companyController.companyListData[index].id!);
                                   /// prefs.setString('BaseURL', companyController.companyListData[index].BaseURL!);
                                    prefs.setBool('companySelected', true);
                                    prefs.setInt('branchID',1);
                                    baseURlApi=companyController.companyListData[index].BaseURL!;
                                    await defaultDataInitial(context:context);
                                    await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                    const EnterPinNumber()));
                                  }
                                }
                              },

                              // trailing:companyController.companyListData[index].branches!.isNotEmpty?Text("Head Office",textAlign: TextAlign.right,
                              //     style: customisedStyle(context, const Color(0xffF25F29), FontWeight.w400, 12.0)):const SizedBox.shrink(),
                              shape: Border.all(color: Colors.transparent),
                              title: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: Colors.grey[300],
                                          backgroundImage: companyController.companyListData[index].companyLogo == null
                                              ? NetworkImage('https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                              : NetworkImage(companyController.companyListData[index].companyLogo!),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(companyController.companyListData[index].companyName!,
                                           //     style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)
                                            style: customisedStyle(context, Colors.black, FontWeight.w700, 15.0)


                                            ),
                                            Row(
                                              children: [
                                                  Padding(
                                                  padding: EdgeInsets.only(right: 8.0),
                                                  child: Text("Expires on",
                                                   //   style: TextStyle(color: Color(0xff797979), fontWeight: FontWeight.normal, fontSize: 12)
                                                      style:   customisedStyle(context, Color(0xff797979), FontWeight.normal, 13.0)
                                                  ),
                                                ),
                                                Text(companyController.convertDate(companyController.companyListData[index].expiryDate!),
                                                //    style: const TextStyle(color: Color(0xffF25F29), fontWeight: FontWeight.w500, fontSize: 14)
                                                    style:   customisedStyle(context, Color(0xffF25F29), FontWeight.w500, 14.0)
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // trailing: const SizedBox.shrink(),
                              children: [
                                Container(
                                  color: Color(0xffFBFBFB),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 0),
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) => DividerStyle(),
                                      shrinkWrap: true,
                                      itemCount: companyController.companyListData[index].branches!.length,
                                      itemBuilder: (context, i) {
                                        // print("${companyController
                                        //     .companyListDAta[index].branches![i].branchName}");
                                        return GestureDetector(
                                            onTap: () async {

                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              prefs.setString('companyName', companyController.companyListData[index].companyName!);
                                              prefs.setString('expiryDate', companyController.companyListData[index].expiryDate!);
                                              prefs.setString('BaseURL', companyController.companyListData[index].BaseURL!);
                                           //   prefs.setString('permission', companyController.companyListData[index].permission!);
                                              prefs.setString('edition', companyController.companyListData[index].edition!);
                                          ///    prefs.setBool('isPosUser', companyController.companyListData[index].isPosUser!);
                                              prefs.setString('companyID', companyController.companyListData[index].id!);
                                              prefs.setString('companyLogo', companyController.companyListData[index].companyLogo??"");
                                              prefs.setString('branchName', companyController.companyListData[index].branches![i].branchName!);
                                              prefs.setBool('companySelected', true);
                                              prefs.setInt('branchID',companyController.companyListData[index].branches![i].branchID!);
                                              baseURlApi=companyController.companyListData[index].BaseURL!;
                                              await defaultDataInitial(context:context);
                                              await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EnterPinNumber()));
                                            },
                                            child: InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(right: 0),
                                                child: ListTile(
                                                  tileColor: Color(0xffFBFBFB),
                                                  title: Padding(
                                                    padding: const EdgeInsets.only(left: 2.0),
                                                    child: Text(
                                                      companyController.companyListData[index].branches![i].nickName?? companyController.companyListData[index].branches![i].branchName!,
                                                      style: customisedStyle(context, Colors.black, FontWeight.normal, 14.0),
                                                    ),
                                                  ),


                                                  trailing: Text(companyController.companyListData[index].branches![i].branchID ==1?"Head Office":"Branch",
                                                      textAlign: TextAlign.right,
                                                      style: customisedStyle(context,companyController.companyListData[index].branches![i].branchID ==1? Color(0xffF25F29): Color(0xff28AAF4), FontWeight.normal, 14.0)),
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                )
                              ],
                            );
                          });
                }
              }),
            )
          ],
        ),
      ),
    );
  }
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
              prefs.clear();
              Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => LoginPageNew()), (_) => false,);
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