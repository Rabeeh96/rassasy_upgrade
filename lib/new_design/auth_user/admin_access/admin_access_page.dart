// import 'package:flutter_svg/svg.dart';
//
// import 'package:flutter/material.dart';
// import 'package:rassasy_new/new_design/new_global/new_global.dart';
// import 'package:rassasy_new/new_design/organization/list_organization.dart';
//
// import '../create_account/create_new_account.dart';
// import '../create_account/select_country.dart';
// import '../password/forgot_password.dart';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:rassasy_new/main.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:http/http.dart' as http;
//
// class AdminAccessPage extends StatefulWidget {
//   @override
//   State<AdminAccessPage> createState() => _AdminAccessPageState();
// }
//
// class _AdminAccessPageState extends State<AdminAccessPage> {
//
//
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   // TextEditingController userNameController = TextEditingController()..text = "Rabeeh@vikn1";
//   // TextEditingController passwordController = TextEditingController()..text = "Rabeeh@333";
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     loadData();
//   }
//
//   loadData(){
//
//   }
//
//   FocusNode userNameFcNode = FocusNode();
//   FocusNode passwordFcNode = FocusNode();
//   FocusNode saveFCNode = FocusNode();
//
//   bool isAlert = false;
//   bool showPassword = true;
//
//   ///alert icon not working
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage("assets/png/coverpage.png"), fit: BoxFit.cover),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width / 4,
//               height: MediaQuery.of(context).size.height / 1.8,
//               child: ListView(
//                 children: [
//                   Container(
//                     child: SvgPicture.asset(
//                       'assets/svg/logoimg.svg',
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 21,
//                       alignment: Alignment.center,
//                       width: MediaQuery.of(context).size.width / 4,
//                       child: Text(
//                         'Admin Access Required',
//                         style: TextStyle(fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Container(
//                       height: MediaQuery.of(context).size.height / 21,
//                       alignment: Alignment.center,
//                       width: MediaQuery.of(context).size.width / 4,
//                       child: Text(
//                         'Admin Access Required',
//                         style: TextStyle(fontWeight: FontWeight.w800),
//                       ),
//                     ),
//                   ),
//
//                   ///isAlert== true border color,fill color,icon color change
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextField(
//                       textCapitalization: TextCapitalization.words,
//                       keyboardType: TextInputType.text,
//                       controller: userNameController,
//                       focusNode: userNameFcNode,
//                       onEditingComplete: () {
//                         FocusScope.of(context).requestFocus(passwordFcNode);
//                       },
//                       decoration: InputDecoration(
//                           suffixIcon: isAlert == true
//                               ? IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 Icons.remove_circle_rounded,
//                                 color: Color(0xffB40000),
//                               ))
//                               :
//                           //  },icon: SvgPicture.asset('assets/svg/WarningAlert.svg',color: Color(0xffB40000),)):
//                           SizedBox(),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(30.0)),
//                               borderSide: BorderSide(
//                                   color: isAlert == true
//                                       ? Colors.red
//                                       : Color(0xffC9C9C9))),
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(30.0)),
//                               borderSide: BorderSide(
//                                   color: isAlert == true
//                                       ? Colors.red
//                                       : Color(0xffC9C9C9))),
//                           disabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(30.0)),
//                               borderSide: BorderSide(
//                                   color: isAlert == true
//                                       ? Colors.red
//                                       : Color(0xffC9C9C9))),
//                           contentPadding: EdgeInsets.only(
//                               left: 20, top: 10, right: 10, bottom: 10),
//                           filled: true,
//                           hintStyle:
//                           TextStyle(color: Color(0xff000000), fontSize: 14),
//                           hintText: 'Username',
//                           fillColor: isAlert == true
//                               ? Color(0xffFFFBFB)
//                               : Color(0xffffffff)),
//                       // decoration: TextFieldDecoration.textFieldDecor(
//                       //     hintTextStr: 'user name'),
//                     ),
//                   ),
//                   passwordField(),
//                   // TextButton(
//                   //     onPressed: () {
//                   //       Navigator.push(
//                   //         context,
//                   //         MaterialPageRoute(builder: (context) => ForgotPasswordNew()),
//                   //       );
//                   //
//                   //
//                   //     },
//                   //     child: Text(
//                   //       'Forgot Password?',
//                   //       style: TextStyle(
//                   //           color: Color(0xff002AB4),
//                   //           fontWeight: FontWeight.w500),
//                   //     )),
//
//
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget passwordField() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//           controller: passwordController,
//           focusNode: passwordFcNode,
//           onEditingComplete: () {
//             FocusScope.of(context).requestFocus(saveFCNode);
//           },
//           obscureText: showPassword,
//           decoration: InputDecoration(
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   showPassword ? Icons.visibility : Icons.visibility_off,
//                   color: Colors.black,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     showPassword = !showPassword;
//                   });
//                 },
//               ),
//               enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                   borderSide: BorderSide(color: Color(0xffC9C9C9))),
//               focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                   borderSide: BorderSide(color: Color(0xffC9C9C9))),
//               disabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(30.0)),
//                   borderSide: BorderSide(color: Color(0xffC9C9C9))),
//               contentPadding:
//               EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
//               filled: true,
//               hintStyle: TextStyle(color: Color(0xff000000), fontSize: 14),
//               hintText: 'Password',
//               fillColor: Color(0xffffffff))),
//     );
//   }
//
//   Future<Null> loginAccount(BuildContext context) async {
//     start(context);
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         dialogBox(context, "Connect to internet");
//         stop();
//       });
//     } else {
//       try {
//         HttpOverrides.global = MyHttpOverrides();
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//
//         String baseUrl = BaseUrl.baseUrlAuth;
//         //             https://api.accounts.vikncodes.in/api/v1/users/login
//         // final url = 'https://api.accounts.vikncodes.in/api/v1/users/login';
//         final url = '$baseUrl/users/login';
//         print(url);
//         Map data = {
//           "username": userNameController.text,
//           "password": passwordController.text,
//           "service": "viknbooks"
//         };
//
//         print(data);
//         //encode Map to JSON
//         var bdy = json.encode(data);
//         var response = await http.post(Uri.parse(url),
//             headers: {
//               "Content-Type": "application/json",
//             },
//             body: bdy);
//         Map n = json.decode(utf8.decode(response.bodyBytes));
//         print("${response.statusCode}");
//         print("${response.body}");
//         var status = n["success"];
//         var datas = n["data"];
//         if (status == 6000) {
//           setState(() {
//             stop();
//
//             prefs.setBool('isLoggedIn', true);
//             prefs.setString('access', datas["access"]);
//             prefs.setInt('user_id', datas["user_id"]);
//             prefs.setString('user_name', userNameController.text);
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => OrganizationList()));
//
//           });
//         } else if (status == 6001) {
//           var msg = n["error"];
//           print('3');
//           dialogBox(context, msg);
//           // if (msg == "Please Verify Your Email to Login") {
//           //   UserCreation.verifyMail =true;
//           //   prefs.setString('email', n['user_email']);
//           //   prefs.setInt('user_id', n['data']);
//           //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CreateNewAccount()));
//           //
//           // }
//
//           stop();
//         } else {
//           setState(() {
//             print('4');
//
//             stop();
//             dialogBox(context, "Some thing went wrong 1");
//           });
//         }
//       } catch (e) {
//         print('5');
//
//         setState(() {
//           dialogBox(context, "Some thing went wrong 2");
//           stop();
//         });
//       }
//     }
//   }
// }
