import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
//import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// dialogBox(BuildContext context, msg) {
//   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// }

start(context) {
  Loader.show(context,
      progressIndicator: CircularProgressIndicator(),
      overlayColor: Colors.transparent,
      themeData: ThemeData(colorScheme:ColorScheme.dark(primary: Color(0xffffab00))
      )
  );
}

//
// dialogBoxAutoHide(BuildContext context, msg) async {
//   Fluttertoast.showToast(
//     msg: msg,
//     toastLength: Toast.LENGTH_SHORT,
//     gravity: ToastGravity.CENTER,
//     timeInSecForIosWeb: 2,
//     backgroundColor: Colors.black,
//     textColor: Colors.white,
//     fontSize: 15.0,
//
//   );
// }
// dialogBoxHide1(BuildContext context, msg) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: true, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           msg+'.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         // content: const Text(
//         //     'Are Sure Want to Exit?.'),
//       );
//     },
//   );
// }

dialogBoxHide(BuildContext context, msg) async {
 //  Alert(message: msg).show();
}
dialogBox(BuildContext context, msg) async {
 // Alert(message: msg,shortDuration: false).show();
}


//
// dialogBox(BuildContext context, msg) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: true, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           msg+'.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         // content: const Text(
//         //     'Are Sure Want to Exit?.'),
//       );
//     },
//   );
// }
// dialogBoxHide(BuildContext context, msg) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: true, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           msg+'.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         // content: const Text(
//         //     'Are Sure Want to Exit?.'),
//       );
//     },
//   );
// }
//

//
// dialogBoxHide(BuildContext context, String msg) async {
//   showDialog(
//     context: context,
//     barrierDismissible: false, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           msg + '.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//       );
//     },
//   );
//
//   // Close the dialog after 2 seconds
//   closeDialogAfterDelay(context);
// }
//
// void closeDialogAfterDelay(BuildContext context) async {
//   await Future.delayed(Duration(seconds: 2));
//   if (Navigator.of(context, rootNavigator: true).canPop()) {
//     Navigator.of(context, rootNavigator: true).pop();
//   }
// }



// dialogBox(BuildContext context, msg) async {
//   return showDialog(
//     context: context,
//     barrierDismissible: true, // user must tap button for close dialog!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         title: Text(
//           msg+'.',
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.black, fontSize: 13),
//         ),
//         // content: const Text(
//         //     'Are Sure Want to Exit?.'),
//       );
//     },
//   );
// }


class CommonStyleTextField {
  static InputDecoration textFieldStyle(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      filled: true,
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(2.0),
        ),
        borderSide: BorderSide(color: Color(0xff000000)),
      ),
      hintStyle:  TextStyle(color: Colors.grey[800], fontSize: 12),
      hintText: hintTextStr,
      labelStyle:  TextStyle(color: Color(0xff9F9F9F), fontSize: 12),
      labelText: labelTextStr,
      fillColor: Color(0xffFAFAFA),
      contentPadding: EdgeInsets.fromLTRB(15, 3, 3, 3),

      // prefixIcon: Icon(Icons.keyboard_arrow_down),
    );
  }
}







String roundStringWith(String val) {

  var decimal = 2;
  double convertedTodDouble = double.parse(val);
  var number = convertedTodDouble.toStringAsFixed(decimal);
  return number;
}
class NoItemFound extends StatelessWidget {
  const NoItemFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'No Results Found',
                style: TextStyle(fontSize: 13, color: Colors.black),
              )
            ],
          ),
        ));
  }
}

class NoData extends StatelessWidget {
  const NoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              // IconButton(
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   icon: Image.asset('DashboardButton/Empty.png'),
              //   iconSize: 50,
              //   onPressed: () {},
              // ),
              Text(
                'No Data ',
                style: TextStyle(fontSize: 10, color: Colors.black),
              )
            ],
          ),
        ));
  }
}

  customisedStyle(context,Colors,FontWeight,fontSize){
  return GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight,color: Colors,fontSize: fontSize));
}
checkingPerm(item) async {

  print("object $item");
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool retData = true;
  retData = prefs.getBool(item)??true;
  print("object $retData");
  return retData;
}

dialogBoxPermissionDenied(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          "Permission denied",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 13),
        ),


      );
    },
  );
}

myLog(msg){
  log("___________________${msg.toString()}");
}
class BaseUrl{
/// server details

  static String baseUrlAuth = 'https://api.accounts.vikncodes.com/api/v1';
  static String baseUrl = "https://www.api.viknbooks.com/api/v10";
  static String baseUrlV11 = "https://www.api.viknbooks.com/api/v11";
  static String imageURL = 'https://www.api.viknbooks.com';

 // // api.accounts.vikncodes.in

  // static String baseUrlAuth = 'https://api.accounts.vikncodes.in/api/v1';
  // static String baseUrl = "https://www.api.viknbooks.in/api/v10";
  // static String imageURL = 'https://www.api.viknbooks.in';
  // static String baseUrlV11 = "https://www.api.viknbooks.in/api/v11";

 // local

  // static String baseUrlAuth = 'http://192.168.1.77:8000/api/v1';
  // static String baseUrl = "http://192.168.1.77:8002/api/v10";
  // static String baseUrlV11 = "http://192.168.1.77:8002/api/v11";
  // static String imageURL = 'http://192.168.1.77:8002';

  static String currentAppVersion ="1.1.4";
  static int branchID =1;
  static int priceRounding=2;
}


log_data(data){
  log("------$data");
}

Future<bool>? returnNetwork()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

stop() {
  Future.delayed(Duration(seconds: 0), () {
    Loader.hide();
  });
}

checkExpire(date) {

  var dt = DateTime.parse(date);
  var now = DateTime.now();


  if (dt.compareTo(now) < 0) {
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}
class Global {

  static InputDecoration textFieldBottomBorder(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      hintText: hintTextStr,
      hintStyle: const TextStyle(color: Colors.grey),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFAFAFA)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xffffab00)),
      ),
    );
  }

  static InputDecoration textField(
      {String labelTextStr = "",String hintTextStr = ""}) {
    return InputDecoration(
      filled:true,
    fillColor:Color(0xffF8F8F8),
      hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14),
      hintText:hintTextStr,
      labelStyle:
      const TextStyle(color: Color(0xff9F9F9F), fontSize: 14),
      labelText: labelTextStr,
      contentPadding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
    );
  }
}



class AutoClosingAlert extends StatefulWidget {
  final String message;
  final Duration duration;

  AutoClosingAlert({required this.message, required this.duration});

  @override
  _AutoClosingAlertState createState() => _AutoClosingAlertState();
}

class _AutoClosingAlertState extends State<AutoClosingAlert> {
  @override
  void initState() {
    super.initState();
    _showAutoClosingAlert();
  }

  void _showAutoClosingAlert() async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry; // Make overlayEntry nullable

    // Create an overlay entry with the alert dialog
    overlayEntry = OverlayEntry(
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text(widget.message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              overlayEntry?.remove(); // Use safe navigation to remove the overlay
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    overlayState.insert(overlayEntry);

    // Wait for the specified duration and then remove the overlay
    await Future.delayed(widget.duration);
    overlayEntry.remove(); // Use safe navigation to remove the overlay
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// Example usage:
// AutoClosingAlert(
//   message: 'This is an auto-closing alert!',
//   duration: Duration(seconds: 3),
// )
