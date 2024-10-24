import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

String appVersion = "1.1.60";
double defaultScreenWidth=550;
bool enableTabDesign = false;
start(context) {
  Loader.show(context,
      progressIndicator: const CircularProgressIndicator(),
      overlayColor: Colors.transparent,
      themeData: ThemeData(colorScheme:const ColorScheme.dark(primary: Color(0xffffab00))
      )
  );
}

dialogBoxHide(BuildContext context, msg) async {
}

dialogBox(BuildContext context, msg) async {
  await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xff415369),
           title: Text(msg, style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
         actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("OK", style: customisedStyle(context, Colors.white, FontWeight.w600, 14.0)),
          ),
        ],
      );
    },
  );
}


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
      labelStyle:  const TextStyle(color: Color(0xff9F9F9F), fontSize: 12),
      labelText: labelTextStr,
      fillColor: const Color(0xffFAFAFA),
      contentPadding: const EdgeInsets.fromLTRB(15, 3, 3, 3),

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

String roundStringWith1(String val) {

  double convertedTodDouble = double.parse(val);
  var number = convertedTodDouble.toStringAsFixed(0);
  return number;
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
String convertDateAndTime(DateTime time) {
  // Define the desired format
  final DateFormat formatter = DateFormat('hh:mm a dd-MM-yyyy');

  // Format the given DateTime object
  return formatter.format(time);
}

dialogBoxPermissionDenied(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return const AlertDialog(
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
String baseURlApi='';
class BaseUrl{
/// server details
   static String baseUrlAuth = 'https://api.accounts.vikncodes.com/api/v1';
   static String baseUrl = "$baseURlApi/api/v10";
   static String baseUrlV11 = "$baseURlApi/api/v11";
   static String imageURL = '$baseURlApi/media/';
///
   ///  test
  // static String baseUrlAuth = 'https://api.accounts.vikncodes.in/api/v1';
  // static String baseUrl = "$baseURlApi/api/v10";
  // static String baseUrlV11 = "$baseURlApi/api/v11";
  // static String imageURL = '$baseURlApi/media/';

  //
  // local
  // http://192.168.1.52:8002/

  // static String baseUrlAuth = 'http://192.168.1.78:8000/api/v1';
  // static String baseUrl = "http://192.168.1.78:8002/api/v10";
  // static String baseUrlV11 = "http://192.168.1.78:8002/api/v11";
  // static String imageURL = 'http://192.168.1.78:8002';
  //
   static int priceRounding=2;
}


pr(data){
  log("------$data");
}

String convertToSaudiArabiaTime(String utcTimeString,currencyCode) {
  DateTime utcTime = DateTime.parse(utcTimeString).toUtc();
  var timeZone = const Duration(hours: 5, minutes: 30);
  print("****************************************************************************************");
  print("utcTimeString $utcTimeString");
  print("timeZone $timeZone");
  print("currencyCode $currencyCode");
  if(currencyCode =="SAR"){
    timeZone = const Duration(hours: -3, minutes: 0);
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.parse(utcTimeString));
    print("formattedTime $formattedTime");

    return formattedTime;
  }
  else if (currencyCode =="INR"){
    timeZone = const Duration(hours: 0, minutes: -30);
  }
  print("timeZone $timeZone");
  print("utcTime $utcTime");
  DateTime saudiArabiaTime = utcTime.add(timeZone);

  String formattedTime = DateFormat('HH:mm:ss').format(saudiArabiaTime);
  print("formattedTime $formattedTime");

  return formattedTime;
}

// convertToSaudiArabiaTime(String utcTimeString,currencyCode) async {
//   // UTC timestamp from server
//   DateTime utcTime = DateTime.parse(utcTimeString);
//
//   // Function call to get times in India and Saudi Arabia
// //  DateTime indiaTime = await getTimeInTimeZone(utcTime, "Asia/Kolkata", -30);
//   DateTime saudiTime = await getTimeInTimeZone(utcTime, "Asia/Riyadh", -3 * 60);
//   print("India Time: $saudiTime");
//   print("Saudi Time: $saudiTime");
//   return saudiTime;
//   //print("India Time: $indiaTime");
//   print("Saudi Time: $saudiTime");
// }
//
// Future<DateTime> getTimeInTimeZone(DateTime utcTime, String timeZoneName, int offsetMinutes) async {
//   // Load the timezone
//
//   final location = tz.getLocation(timeZoneName);
//   // Convert to the timezone
//   tz.TZDateTime localTime = tz.TZDateTime.from(utcTime, location);
//   // Apply the offset
//   localTime = localTime.subtract(Duration(minutes: offsetMinutes));
//   return localTime;
// }
//
//
// String convertToLocalTime(String timestamp, String countryCode) {
//   print("timestamp    $timestamp  countryCode $countryCode");
//   // Parse the input timestamp
//   DateTime dateTime = DateTime.parse(timestamp);
//
//   // Define the format for the output
//   DateFormat formatter = DateFormat.yMd().add_jms();
//
//   // Get the timezone for the specified country code
//   String timeZone = getLocationTimezone(countryCode);
//   print("time zone      $timeZone");
//   // Convert the timestamp to local time
//   String localTime = formatter.format(dateTime.toUtc().add(Duration(hours: int.parse(timeZone))));
//   String formattedTime = DateFormat('HH:mm:ss').format(localTime);
//   print("localTime    $localTime");
//   return localTime;
// }
// String getLocationTimezone(String countryCode) {
//   // This function should return the timezone offset based on the country code
//   // You can implement a logic to fetch timezone based on the country code
//   // For simplicity, let's assume a fixed offset for demonstration
//   // Replace this with your own logic to get timezone offset for the given country code
//   switch (countryCode) {
//     case 'SAR':
//       return '+3'; // Eastern Time (ET)
//     case 'INR':
//       return '5'; // Indian Standard Time (IST)
//   // Add more cases for other country codes as needed
//     default:
//       return '+0'; // Default to UTC
//   }
// }

Future<bool>? returnNetwork()async{
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    return true;
  }
}

stop() {
  Future.delayed(const Duration(seconds: 0), () {
    Loader.hide();
  });
}


bool isDateExpired(String dateString) {

  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  DateTime expiryDate = dateFormat.parse(dateString);
  DateTime adjustedExpiryDate = expiryDate.add(const Duration(days: 1));
  DateTime currentDate = DateTime.now();
  return currentDate.isAfter(adjustedExpiryDate);
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
    fillColor:const Color(0xffF8F8F8),
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
        title: const Text('Alert'),
        content: Text(widget.message),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              overlayEntry?.remove(); // Use safe navigation to remove the overlay
            },
            child: const Text('OK'),
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
bottomDialogueFunction(
    {required BuildContext context,
      required String textMsg,
      required Function() fistBtnOnPressed,
      required Function() secondBtnPressed,
      required String secondBtnText,
      required bool isDismissible}) {
  return showModalBottomSheet(
    isDismissible: isDismissible,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  textMsg,
                  style: customisedStyle(
                      context, Colors.red, FontWeight.w400, 15.0),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                TextButton(
                    onPressed: fistBtnOnPressed,
                    child: Text(
                      'cancel',
                      style: customisedStyle(context, const Color(0xff5728C4),
                          FontWeight.w600, 13.0),
                    )),
                TextButton(
                    onPressed: secondBtnPressed,
                    child: Text(
                      secondBtnText,
                      style: customisedStyle(context, const Color(0xff5728C4),
                          FontWeight.w600, 13.0),
                    )),
              ],
            )),
      );
    },
  );
}