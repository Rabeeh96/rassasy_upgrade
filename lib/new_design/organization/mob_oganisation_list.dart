import 'package:flutter/material.dart';
import 'package:rassasy_new/global/HttpClient/HTTPClient.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/auth_user/user_pin/employee_pin_no.dart';
import 'package:rassasy_new/new_design/organization/controller/company_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MobOrganizationList extends StatefulWidget{
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
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Text("Organizations",style:customisedStyle(context, Colors.black, FontWeight.w500, 20.0) ,),
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
                      color: Colors.black,
                    ),
                  );
                } else {
                  return companyController.companyListDAta.isEmpty
                      ? const Center(child: Text("No Companies Found"))
                      : ListView.separated(
                      separatorBuilder: (context, index) => DividerStyle(),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                      companyController.companyListDAta.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                          onExpansionChanged: (v) async {



                              var expire =checkExpire(companyController.companyList[index].expiryDate);
                              if(expire){
                              dialogBox(context, "${companyController.companyList[index].companyName} Expired! Please Contact us(+91 95775 00400 | +966 53 313 4959 | +971 52295 6284)to continue");
                              }
                              else{

                              //var branchDetails=companyController.companyList[index].branchList??[];

                              ///print("branchDetails  $branchDetails");

                             /// if(branchDetails.isEmpty){
                              await defaultDataInitial(context:context);

                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('companyName', companyController.companyList[index].companyName);
                              prefs.setString('companyType', companyController.companyList[index].companyType);
                              prefs.setString('expiryDate', companyController.companyList[index].expiryDate);
                              prefs.setString('permission', companyController.companyList[index].permission);
                              prefs.setString('edition', companyController.companyList[index].permission);
                              prefs.setBool('isPosUser', companyController.companyList[index].isPosUser);
                              prefs.setString('companyID', companyController.companyList[index].id);
                              prefs.setBool('companySelected', true);
                              prefs.setInt('branchID',1);

                              await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                              builder: (BuildContext context) =>
                             const EnterPinNumber()));
                            ///  }
                          ///    else{

                              // var result = await  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectBranch(list: branchDetails)),);
                              // if(result !=null){
                              // await defaultDataInitial(context:context);
                              // SharedPreferences prefs = await SharedPreferences.getInstance();
                              // prefs.setString('companyName', companyController.companyList[index].companyName);
                              // prefs.setString('companyType', companyController.companyList[index].companyType);
                              // prefs.setString('expiryDate', companyController.companyList[index].expiryDate);
                              // prefs.setString('permission', companyController.companyList[index].permission);
                              // prefs.setString('edition', companyController.companyList[index].permission);
                              // prefs.setBool('isPosUser', companyController.companyList[index].isPosUser);
                              // prefs.setString('companyID', companyController.companyList[index].id);
                              // prefs.setBool('companySelected', true);
                              // await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EnterPinNumber()));
                              // }
                              // else{
                              // dialogBox(context, "Select branch, before go to next step");
                              // }

                             /// }
                              }
                              },
                          trailing: SizedBox.shrink(),
                          shape: Border.all(
                            // color: Color(0xFFE8E8E8)
                              color: Colors.transparent),
                          title:Container(

                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey[300],
                                      backgroundImage: companyController.companyListDAta[index].companyLogo
                                          ==
                                          null
                                          ? NetworkImage(
                                          'https://www.gravatar.com/avatar/$index?s=46&d=identicon&r=PG&f=1')
                                          : NetworkImage(
                                          companyController.companyListDAta[index].companyLogo!),
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            companyController.companyListDAta[index].companyName!,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(right: 8.0),
                                              child: Text(
                                                  "Expires on",
                                                  style: TextStyle(
                                                      color: Color(0xff797979),
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 12)),
                                            ),
                                            Text(
                                                companyController.companyListDAta[index].expiryDate!,
                                                style: const TextStyle(
                                                    color: Color(0xffF25F29),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14)),
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
                              color:Color(0xffFBFBFB),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: ListView.separated(
                                  separatorBuilder: (context, index) => DividerStyle(),

                                  shrinkWrap: true,
                                  itemCount: companyController
                                      .companyListDAta[index].branches!
                                      .length,
                                  itemBuilder: (context, i) {
                                    // print("${companyController
                                    //     .companyListDAta[index].branches![i].branchName}");
                                    return GestureDetector(
                                      onTap: () async {


                                          // await defaultDataInitial(context:context);
                                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                                          // prefs.setString('companyName', companyController.companyListDAta[index].companyName);
                                          // prefs.setString('companyType', companyController.companyListDAta[index].companyType);
                                          // prefs.setString('expiryDate', companyController.companyListDAta[index].expiryDate);
                                          // prefs.setString('permission', companyController.companyListDAta[index].permission);
                                          // prefs.setString('edition', companyController.companyListDAta[index].permission);
                                          // prefs.setBool('isPosUser', companyController.companyListDAta[index].isPosUser);
                                          // prefs.setString('companyID', companyController.companyListDAta[index].id);
                                          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const EnterPinNumber()));



                                      },
                                      child:InkWell(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(right: 8),
                                          child: ListTile(
                                            tileColor: Color(0xffFBFBFB),

                                            title: Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                companyController
                                                    .companyListDAta[index].branches![i].branchName!,
                                                style: customisedStyle(
                                                    context,
                                                    Colors.black,
                                                    FontWeight.normal,
                                                    14.0),
                                              ),
                                            ),
                                            trailing: Text(
                                                companyController
                                                    .companyListDAta[
                                                index].branches![i].edition!,
                                                style: customisedStyle(
                                                    context,
                                                    const Color(
                                                        0xff28AAF4),
                                                    FontWeight.normal,
                                                    12.0)),
                                          ),
                                        ),
                                      )
                                    );


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