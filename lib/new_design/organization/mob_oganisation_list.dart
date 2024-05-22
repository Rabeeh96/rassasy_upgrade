import 'package:flutter/material.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/organization/controller/company_controller.dart';
import 'package:get/get.dart';

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
        title: Text("Organizations",style:customisedStyle(context, Colors.black, FontWeight.w500, 16.0) ,),
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
                          shape: Border.all(
                            // color: Color(0xFFE8E8E8)
                              color: Colors.transparent),
                          title: GestureDetector(
                            onTap: () async {

                            },
                            child: Container(
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
                                                  fontSize: 12)),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.only(right: 8.0),
                                                child: Text(
                                                    "Expires on",
                                                    style: TextStyle(
                                                        color: Color(0xff797979),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12)),
                                              ),
                                              Text(
                                                  companyController.companyListDAta[index].expiryDate!,
                                                  style: const TextStyle(
                                                      color: Color(0xffF25F29),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // trailing: const SizedBox.shrink(),
                          children: [
                            ListView.separated(
                              separatorBuilder: (context, index) => DividerStyle(),

                              shrinkWrap: true,
                              itemCount: companyController
                                  .companyListDAta[index].branches!
                                  .length,
                              itemBuilder: (context, i) {
                                // print("${companyController
                                //     .companyListDAta[index].branches![i].branchName}");
                                return Padding(
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
                                            15.0),
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
                                            14.0)),
                                  ),
                                );
                              },
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