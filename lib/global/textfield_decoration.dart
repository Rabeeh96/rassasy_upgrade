import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextFieldDecoration {
  static InputDecoration textFieldDecor(

      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(

        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
            EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: Color(0xffffffff));
  }

  static InputDecoration textFieldDecorIcon(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
            EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: Color(0xffffffff));
  }

  static InputDecoration textFieldDecor1(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
            EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: Color(0xffffffff));
  }



  static InputDecoration rectangleTextField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(

        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration customerMandatoryField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(

        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        filled: true,
       suffixIcon: IconButton(icon: SvgPicture.asset('assets/svg/asterisk.svg'),onPressed: (){},),
        suffixStyle: TextStyle(
          color: Colors.red,
        ),
        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));

  }

  static InputDecoration rectangleTextField2(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),

        hintStyle: const TextStyle(color: Color(0xffC9C9C9),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration selectFinancialYearCal(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
        const EdgeInsets.only(left: 20,top:10,right:10,bottom:10),
        hintStyle: const TextStyle(color: Color(0xffC9C9C9),fontSize: 12),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }

  static InputDecoration rectangleTextField1(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      prefixIcon: Icon(Icons.calendar_today,color: Colors.black,),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration customerDateField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
      prefixIcon: Icon(Icons.calendar_today,color: Colors.black,),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        suffixIcon: IconButton(icon: SvgPicture.asset('assets/svg/asterisk.svg'),onPressed: (){},),
        suffixStyle: TextStyle(
          color: Colors.red,
        ),

        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration productField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        suffixIcon: IconButton(icon: SvgPicture.asset('assets/svg/asterisk.svg'),onPressed: (){},),
        suffixStyle: TextStyle(
          color: Colors.red,
        ),

        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration rectangleTextFieldIcon(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
  static InputDecoration rectangleTextFieldIconFillColor(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffEEEEEE))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffEEEEEE))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffEEEEEE))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffEEEEEE));
  }
  static InputDecoration searchField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffC9C9C9))),
        contentPadding:
        const EdgeInsets.only(left: 20, top: 10, right: 10, bottom: 10),
        filled: true,
        hintStyle: const TextStyle(color: Color(0xff000000),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));
  }
}
