import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

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
              initialDate: DateTime.now(),
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


