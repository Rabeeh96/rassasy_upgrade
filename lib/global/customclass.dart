import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rassasy_new/global/global.dart';

DateTime dateTime =DateTime.now();
//  DateFormat dateFormat = DateFormat("dd/MM/yyy");
// DateFormat apiDateFormat = DateFormat("y-M-d");

late ValueNotifier<String> dateNotifier ;
btmDialogueFunction({required BuildContext context,required String textMsg,required Function() fistBtnOnPressed ,required Function() secondBtnPressed, required String secondBtnText,required bool isDismissible }) {
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
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(textMsg,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                SizedBox(width: MediaQuery.of(context).size.width*.05,),
                TextButton(onPressed:fistBtnOnPressed,  child:   Text('cancel'.tr.tr,style: TextStyle(color: Color(0xffB53211)),)),
                TextButton(onPressed: secondBtnPressed, child: Text(secondBtnText,style: const TextStyle(color: Color(0xffB53211)),)),
              ],
            )
        ),
      );
    },
  );
}


popAlert({required String head,required String message,required SnackPosition position}){
  Get.snackbar(
    head,
    message,

    snackPosition: position,
      animationDuration:const Duration(seconds: 2)
  );
}

popAlertWithColor({required String head,required String message,required SnackPosition position,required Color backGroundColor,
  required Color forGroundColor}){
  Get.snackbar(
    head,
    message,
      backgroundColor: backGroundColor,
      colorText: forGroundColor,
    snackPosition: position,
      animationDuration:const Duration(seconds: 2)
  );
}


updateAlert(){
  Get.snackbar(
      "Alert",
      "We're thrilled to share a sneak peek into our upcoming update! In the next release, get ready for a game-changing feature",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
     animationDuration:const Duration(seconds: 2)
  );
}
checkNetwork() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;

  } else {
    return true;
  }

}

showDatePickerFunction(context,ValueNotifier dateNotifier) {
  final mHeight = MediaQuery.of(context).size.height;
  final mWidth = MediaQuery.of(context).size.width/2;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: SizedBox(
        width: mWidth * .98,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  EdgeInsets.only(left: mWidth * .13, top: mHeight * .01),
                  child:  Center(
                    child: Text(
                      'select_date'.tr,
                      style: GoogleFonts.poppins(textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CalendarDatePicker(
              onDateChanged: (selectedDate) {
                dateNotifier.value = selectedDate;

                Navigator.pop(context);
              },
              initialDate: dateNotifier.value,
              firstDate: DateTime.now().add(
                const Duration(days: -100000000),
              ),
              lastDate: DateTime.now().add(const Duration(days: 6570)),
            ),
          ],
        ),
      ),
    ),
  );
}

 DividerStyle(){
  // Color(0xffE8E8E8): Color(0xff1C3347)
  Color lightgrey = const Color(0xFFE8E8E8);
  Color grey= const Color(0xFFE8E8E8).withOpacity(.3);
//  themeChangeController.isDarkMode.value ? Color(0xffE8E8E8): Color(0xff1C3347)
  return Container(
    height: 1,
    width: double.infinity,
    decoration: BoxDecoration(
        gradient:LinearGradient(colors: [
          grey, // Transparent color
          lightgrey, // Middle color
          grey, // Transparent color
        ],
          stops: [0.1,0.4,1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )
    ),
  );
}
class SearchFieldWidgetNew extends StatelessWidget {
  SearchFieldWidgetNew(
      {super.key,
        required this.mHeight,
        required this.hintText,
        required this.controller,
        this.onChanged,
        required this.autoFocus});

  final double mHeight;
  final String hintText;
  final TextEditingController controller;
  final bool autoFocus;
  Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    return Container(

        margin: const EdgeInsets.only(left: 15, right: 10,
        ),
        height: mHeight * .055,
        // decoration: BoxDecoration(
        //
        //   border: Border.all(width: .1, color: const Color(0xffE8E8E8)),
        // ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                  autofocus: autoFocus,
                  textCapitalization: TextCapitalization.words,
                  onChanged: onChanged,
                  controller: controller,

                  style: customisedStyle(context, Colors.black, FontWeight.normal, 15.0),
                  decoration: InputDecoration(
                    filled: true,
                      fillColor: Color(0xffFBFBFB),
                      hintText: hintText,
                      hintStyle: customisedStyle(context, const Color(0xff929292), FontWeight.normal, 15.0),
                      contentPadding:
                      const EdgeInsets.only(left: 10.0, bottom: 10, top: 8),
                      border: InputBorder.none)
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/search-normal.svg',color: Color(0xffB4B4B4),
                width: mWidth * .02,
                height: mHeight * .02,

              ),
              onPressed: (){

              },
            ),
          ],
        ));
  }
}
