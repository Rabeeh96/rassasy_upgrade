import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:image_picker/image_picker.dart';
import '../../../global/textfield_decoration.dart';
import '../list_organization.dart';
import 'organization_address_detail_pg.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';
import 'package:rassasy_new/global/global.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';

class CreateOrganisationProfile extends StatefulWidget {
  @override
  State<CreateOrganisationProfile> createState() =>
      _CreateOrganisationProfileState();
}

class _CreateOrganisationProfileState extends State<CreateOrganisationProfile> {


  TextEditingController registrationNoController = TextEditingController();

  TextEditingController financialYear1Controller = TextEditingController();
  TextEditingController financialYear2Controller = TextEditingController();

  TextEditingController organizationNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  FocusNode orgNameFcNode = FocusNode();

  FocusNode saveFCNode = FocusNode();

  FocusNode registrationFcNode = FocusNode();

  FocusNode financialYear1FcNode = FocusNode();
  FocusNode financialYear2FcNode = FocusNode();

  FocusNode emailFcNode = FocusNode();

  FocusNode phoneFcNode = FocusNode();

  String _date = "2033/01/01";
  String fromDate = "2022/01/01";
  String toDate = "2022/01/01";
  var email = "";
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String nowFormat = formatter.format(now);


  @override
  void initState() {
    super.initState();
    loadData();
  }

/// load initial data
  loadData(){

    if(OrgData.firstSection!){
      getCurrentYear();
    }
    else{
      setState((){
        registrationNoController.text = OrgData.registrationNumber;
        organizationNameController.text =  OrgData.orgName;
        financialYear1Controller.text =  OrgData.fromOrgDate;
        financialYear2Controller.text =  OrgData.toOrgDate;
        fromDate = OrgData.fromOrgDateAPI;
        toDate = OrgData.toOrgDateAPI;
        emailController.text =  OrgData.email;
        phoneController.text =  OrgData.phone;
        if(OrgData.imageSelected!){
          imageView = true;
          imgFile =  OrgData.imgFile;
        }
      });
    }


  }


  getCurrentYear(){
      DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy');
    final String nowFormat = formatter.format(now);
    var intYear = int.parse(nowFormat);
    print('----date nowFormat --$nowFormat');
    print('----year $intYear');
    print('----year ${intYear+1}');
    financialYear1Controller.text = "01/04/$intYear";
    financialYear2Controller.text = "31/03/${intYear+1}";
        fromDate = "$intYear-04-01";
        toDate =  "${intYear+1}-03-31";
  }

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
              height: MediaQuery.of(context).size.height / 1.3,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 21,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 4,
                      child:   Text(
                        'create_org'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [



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
                                    '1',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),


                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          ),
                        ),
///svg image commented here
                        // Card(
                        //     elevation: 0,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(200),
                        //     ),
                        //     child: SvgPicture.asset('assets/svg/2.svg')),

                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Container(
                            height: 36,
                            width:  36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFffffff),
                              shape: BoxShape.circle,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: const Text(
                                    '2',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                            height: 36,
                          ),
                        ),
                     //   SvgPicture.asset('assets/svg/3.svg'),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(200),
                          ),
                          child: Container(
                            height: 36,
                            width:  36,
                            decoration: const BoxDecoration(
                              color: Color(0xFFffffff),
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
                        'org_profile'.tr,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Color(0xff7A7A7A)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      addLogo(),
                      organizationName(),
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
                            child: Text('reg_no'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                             // keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.words,
                              controller: registrationNoController,
                              focusNode: registrationFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(financialYear1FcNode);
                              },
                              decoration: TextFieldDecoration.textFieldDecor(
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
                            child: Text('financial_year'.tr),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffffffff),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Color(0xffC9C9C9),
                                width: 1,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 50,
                                  child: Icon(Icons.calendar_today),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 12,
                                  child: TextField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: 11),
                                    onTap: () {
                                      _selectDate(context, 1);
                                    },
                                    controller: financialYear1Controller,
                                    focusNode: financialYear1FcNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(financialYear2FcNode);
                                    },
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration:
                                        TextFieldDecoration.selectFinancialYearCal(
                                            hintTextStr: 'Required'.tr),
                                  ),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(fontWeight: FontWeight.w800),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 12,
                                  child: TextField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: 11),
                                    onTap: () {
                                      _selectDate(context, 2);
                                    },
                                    controller: financialYear2Controller,
                                    focusNode: financialYear2FcNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(emailFcNode);
                                    },
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration:
                                        TextFieldDecoration.selectFinancialYearCal(
                                            hintTextStr: 'Required'.tr),
                                  ),
                                ),
                              ],
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
                            child: Text('Email'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: emailController,
                              focusNode: emailFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context)
                                    .requestFocus(phoneFcNode);
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: TextFieldDecoration.textFieldDecor(
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
                            child: Text('phone'.tr),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 4.5,
                            child: TextField(
                              controller: phoneController,
                              focusNode: phoneFcNode,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(saveFCNode);
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textCapitalization: TextCapitalization.words,
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

                                final bool isValid = EmailValidator.validate(emailController.text);
                                if (emailController.text == ''||organizationNameController.text == ''||phoneController.text == '' || financialYear2Controller.text=='' || financialYear1Controller.text == ''){
                                  dialogBox(context, 'Please fill mandatory fields');
                                }
                                else {

                                  if(isValid==false){
                                    dialogBox(context, 'Please enter valid mail address');

                                  }

                                  else{
                                    var phoneValidation = isValidPhoneNumber(phoneController.text);
                                    print('phone number validation $phoneValidation');
                                    if(phoneValidation==false){
                                      dialogBox(context, 'Please enter valid phone number');
                                     }
                                    else{

                                      OrgData.orgName = organizationNameController.text;
                                      OrgData.fromOrgDateAPI = fromDate;
                                      OrgData.toOrgDateAPI = toDate;
                                      OrgData.toOrgDate = financialYear2Controller.text;
                                      OrgData.fromOrgDate = financialYear1Controller.text;

                                      OrgData.phone = phoneController.text;
                                      OrgData.email = emailController.text;
                                      OrgData.registrationNumber = registrationNoController.text;
                                      OrgData.imageSelected = imageView;
                                      OrgData.imgFile = imgFile;

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateOrganisation()),
                                      );
                                    }

                                  }
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
  bool isValidPhoneNumber(String str) {
    if(str.length >9){
      return true;
    }
    else{
      return false;
    }

  }
  Widget addLogo() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Logo',
          ),
        ),

       imageView ==false? GestureDetector(
         child: Container(
           decoration: const BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.all(Radius.circular(20))),
           height: MediaQuery.of(context).size.height / 7,
           width: MediaQuery.of(context).size.width / 12,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Container(
                 decoration: const BoxDecoration(
                   shape: BoxShape.circle,
                   color: Colors.grey,
                 ),
                 height: MediaQuery.of(context).size.height / 20,
                 width: MediaQuery.of(context).size.width / 20,
                 child: const Icon(
                   Icons.add,
                   color: Colors.white,
                 ),
               ),
             ],
           ),
         ),
         onTap: () {
           showOptionsDialog(context);
         },
       ):
       ClipRRect(
         borderRadius: BorderRadius.circular(20.0),
         child: Image.file(
           imgFile!,
           fit: BoxFit.cover,
           width: MediaQuery.of(context).size.width / 12,
           height: MediaQuery.of(context).size.height / 7,
         ),
       )
       // Container(
       //   decoration: const BoxDecoration(
       //   //    color: Colors.white,
       //       borderRadius: BorderRadius.all(Radius.circular(20))),
       //   child: Image.file(
       //
       //   imgFile!,
       //   fit: BoxFit.cover,
       //   width: MediaQuery.of(context).size.width / 12,
       //   height: MediaQuery.of(context).size.height / 7,
       // ),),
      ],
    );
  }
  final imgPicker = ImagePicker();
  bool imageView = false;
  File? imgFile;
  Widget logoIc (){
    return    CircleAvatar(
      radius: 60,
      backgroundColor: Color(0xff858585),
      child: ClipOval(
        child: imageView == true
            ? GestureDetector(
          child: displayImage(),
          onTap: () {
            showOptionsDialog(context);
          },
        )
            : IconButton(
          onPressed: () {
            imageView = true;
            showOptionsDialog(context);
          },
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }




  Widget displayImage() {
    if (imgFile == null) {
      return Text('msg5'.tr);
    } else {
      return Image.file(
        imgFile!,
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 6,
      );

      //  return Image.file(imgFile!, width: 350, height: 350);
    }
  }


  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            // backgroundColor: Color(0xff0634A1),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ElevatedButton(
                    // elevation: 0,
                    // hoverElevation: 0,
                    // focusElevation: 0,
                    // highlightElevation: 0,
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor:  Color(0xff09308C)
                        ///     backgroundColor: Color(0xff09308C),
                      ),

                      onPressed: (){
                        Navigator.pop(context);
                        openCamera();
                      },

                      child: Text('Camera')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor:  Color(0xff09308C)
                        ///     backgroundColor: Color(0xff09308C),
                      ),

                      onPressed: (){


                        Navigator.pop(context);
                        openGallery();
                      }, child: Text('Gallery')),

                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      print("camera");
      print(imgFile);
    });



    if(imgFile!.path != ""){
      setState(() {
        imageView = true;
      });
     // _uploadImage();
    }


  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
       print(imgFile);
    });
    if(imgFile!.path != ""){
      setState(() {
        imageView = true;
      });
    //  _uploadImage();
    }
  }



  Widget organizationName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Organization Name'),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3.5,
          child: TextField(
            onTap: () {},
            controller: organizationNameController,
            focusNode: orgNameFcNode,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(registrationFcNode);
            },
            decoration: TextFieldDecoration.textFieldDecor(hintTextStr: 'Required'.tr),
          ),
        ),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context, type) async {
    // DatePicker.showDatePicker(context,
    //     // theme: const DatePickerTheme(
    //     //   containerHeight: 200.0,
    //     // ),
    //     showTitleActions: true,
    //     minTime: DateTime(2000, 01, 01),
    //     maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
    //   print('confirm $date');
    //   _date = '${date.year} - ${date.month} - ${date.day}';
    //
    //   setState(() {
    //     final DateFormat formatter = DateFormat('dd/MM/yyyy');
    //     final DateFormat formatter1 = DateFormat('yyyy-MM-dd');
    //     final String formatted = formatter.format(date);
    //     print(formatted);
    //     _date = '$formatted';
    //
    //     if (type == 1) {
    //
    //       fromDate = formatter1.format(date);
    //       financialYear1Controller.text = _date;
    //     } else if (type == 2) {
    //       toDate = formatter1.format(date);
    //       financialYear2Controller.text = _date;
    //     }
    //   });
    // }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
