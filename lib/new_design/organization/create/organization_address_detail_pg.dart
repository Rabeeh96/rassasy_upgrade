
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:rassasy_new/global/global.dart';

import '../../../global/textfield_decoration.dart';
import '../list_organization.dart';
import 'detail/select_org_country.dart';
import 'detail/select_org_state.dart';
import 'organization_tax_detail.dart';
import 'organization_profile_pg.dart';
import 'package:get/get.dart';



class CreateOrganisation extends StatefulWidget {
  @override
  State<CreateOrganisation> createState() => _CreateOrganisationState();
}

class _CreateOrganisationState extends State<CreateOrganisation> {
  TextEditingController buildingNameController = TextEditingController();

  TextEditingController landmarkController = TextEditingController();

  TextEditingController countryController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController pinCodeController = TextEditingController();

  FocusNode buildingNameFcNode = FocusNode();

  FocusNode landmarkFcNode = FocusNode();

  FocusNode countryFcNode = FocusNode();

  FocusNode stateFcNode = FocusNode();

  FocusNode cityFcNode = FocusNode();

  FocusNode pinCodeFcNode = FocusNode();

  FocusNode saveFCNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      loadData();
    });
  }

  loadData(){
    //
    // if(OrgData.secondSection!){
    //   cityController.text = "";
    //   pinCodeController.text =  "";
    //   buildingNameController.text =  "";
    //   landmarkController.text =  "";
    //   countryController.text =  "";
    //   stateController.text =  "";
    // }
    // else{
      setState((){

        // OrgData.city=cityController.text;
        // OrgData.postalCode=pinCodeController.text;
        // OrgData.buildName=buildingNameController.text;
        // OrgData.landMark=landmarkController.text;
        // OrgData.countryName=countryController.text;
        // OrgData.stateName=stateController.text;
        // OrgData.city=cityController.text;
        // OrgData.postalCode=pinCodeController.text;


        cityController.text = OrgData.city;
        pinCodeController.text =  OrgData.postalCode;
        buildingNameController.text =  OrgData.buildName;
        landmarkController.text =  OrgData.landMark;
        countryController.text =  OrgData.countryName;
        stateController.text =  OrgData.stateName;


      });
  //  }


  }


  ///alert icon not working
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/png/coverpage.png"), fit: BoxFit.cover),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2.2,
              height: MediaQuery.of(context).size.height / 1.4,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6,bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      child:  Text(
                        'create_org'.tr
                        ,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:5,left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      GestureDetector(
                        child:    Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Container(
                            height: 36,
                            width:  36,
                            decoration: const BoxDecoration(
                              color: Color(0xffffffff),
                              shape: BoxShape.circle,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text(
                                    '1',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Card(
                        //   elevation: 10,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(200),
                        //   ),
                        //   child: SvgPicture.asset('assets/svg/addressdetail1.svg'),
                        // ),
                          onTap: (){

                            OrgData.city=  cityController.text;
                            OrgData.postalCode= pinCodeController.text;
                             OrgData.buildName = buildingNameController.text;
                            OrgData.landMark = landmarkController.text;
                             OrgData.countryName  =countryController.text;
                            OrgData.stateName  =stateController.text;
                            OrgData.firstSection = false;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CreateOrganisationProfile()),
                            );
                          }
                          ,
                      ),



                        const Expanded(
                          child: Divider(
                            color: Color(0xffF68522),
                            height: 36,
                          ),
                        ),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Container(
                            height: 36,
                            width:  36,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFFEE4709),
                                  Color(0xFFF68522),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text(
                                    '2',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Card(
                        //     elevation: 10,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(200),
                        //     ),
                        //     child:   SvgPicture.asset('assets/svg/addressIcon2.svg'),
                        // ),
                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          ),
                        ),

                      //  SvgPicture.asset('assets/svg/addressdetail3.svg'),
                        GestureDetector(
                          child:    Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                            child: Container(
                              height: 36,
                              width:  36,
                              decoration: const BoxDecoration(
                                color: Color(0xffffffff),
                                shape: BoxShape.circle,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: const Text(
                                      '3',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Card(
                          //   elevation: 10,
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(200),
                          //   ),
                          //   child: Container(
                          //     height: MediaQuery.of(context).size.height / 21,
                          //     width: MediaQuery.of(context).size.width / 35,
                          //     decoration: const BoxDecoration(
                          //       color: Color(0xFFffffff),
                          //       shape: BoxShape.circle,
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Container(
                          //           child: const Text(
                          //             '3',
                          //             style: TextStyle(color: Colors.black),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          onTap: (){


                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           CreateOrganisationAddress()),
                            // );
                          }
                          ,
                        ),



                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 21,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      child:   Text(
                        'address_detail'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xff7A7A7A)),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('build'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: buildingNameController,
                              focusNode: buildingNameFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(landmarkFcNode);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: TextFieldDecoration.textFieldDecor(
                                  hintTextStr: ''),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('landmark'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: landmarkController,
                              focusNode: landmarkFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(countryFcNode);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: TextFieldDecoration.textFieldDecor(
                                  hintTextStr: ''),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('country'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectOrgCountry()),
                                );

                                if (result != null) {
                                  setState(() {
                                    stateController.text = "";
                                    countryController.text = result;
                                  });
                                } else {}
                              },
                              controller: countryController,
                              focusNode: countryFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(cityFcNode);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: TextFieldDecoration.textFieldDecorIcon(
                                  hintTextStr: 'Required'.tr),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('City'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: cityController,
                              focusNode: cityFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(saveFCNode);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: TextFieldDecoration.textFieldDecor(
                                  hintTextStr: 'Required'.tr),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('State/Province'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              readOnly: true,
                              onTap: () async {
                               if(countryController.text==''){
                                 dialogBox(context, 'Please Select Country');
                               }else{
                                 final result = await Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => SelectOrgState()),
                                 );

                                 if (result != null) {
                                   setState(() {
                                     stateController.text = result;
                                   });
                                 } else {}
                               }
                              },
                              controller: stateController,
                              focusNode: saveFCNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(pinCodeFcNode);
                              },
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              decoration: TextFieldDecoration.textFieldDecorIcon(
                                  hintTextStr: 'Required'.tr),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('postal_code'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: pinCodeController,
                              focusNode: pinCodeFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(saveFCNode);
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: TextFieldDecoration.textFieldDecor(
                                  hintTextStr: 'Required'.tr),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 100, right: 100, top: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                              onPressed: () {
                                clearAll();
                                Navigator.pop(context);
                              },
                              child:  Text(
                                'cancel'.tr,
                                style: TextStyle(color: Color(0xff8D0000)),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width / 10,
                            height: MediaQuery.of(context).size.height / 17,
                            decoration: const BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(24)),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFFEE4709),
                                  Color(0xFFF68522),
                                ],
                              ),
                            ),
                            child: TextButton(
                              focusNode: saveFCNode,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 14),
                              ),
                              onPressed: () {

                                if(cityController.text=='' ||
                                    pinCodeController.text == ''
                                    || countryController.text == ''
                                    || stateController.text== ''||OrgData.countryID==''||OrgData.stateID=='')
                                  {
                                  dialogBox(context, 'Please Enter Mandatory Field');
                                  }
                                else{
                                  OrgData.city=cityController.text;
                                  OrgData.postalCode=pinCodeController.text;
                                  OrgData.buildName=buildingNameController.text;
                                  OrgData.landMark=landmarkController.text;
                                  OrgData.countryName=countryController.text;
                                  OrgData.stateName=stateController.text;
                                  OrgData.postalCode=pinCodeController.text;




                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreateOrganisationAddress()),
                                  );
                                }

                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children:   [
                                  Text('Next'.tr),
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  clearAll() {
    OrgData.orgName = '';
    OrgData.fromOrgDateAPI = '';
    OrgData.fromOrgDate = '';
    OrgData.toOrgDateAPI = '';
    OrgData.toOrgDate = '';
    OrgData.registrationNumber = '';
    OrgData.phone = '';
    OrgData.email = '';
    OrgData.imgFile;
    OrgData.imageSelected = false;
    OrgData.firstSection = true;
    OrgData.secondSection = true;
    OrgData.thirdSection = true;

    OrgData.countryID = '';
    OrgData.countryName = '';
    OrgData.stateID = '';
    OrgData.stateCode = '';
    OrgData.stateName = '';
    OrgData.city = '';
    OrgData.postalCode = '';
    OrgData.buildName = '';
    OrgData.landMark = '';
    OrgData.taxNumber = '';
    OrgData.taxShow = false;
    OrgData.isZetka = false;
  }
}
