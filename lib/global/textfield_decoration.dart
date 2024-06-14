import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rassasy_new/global/global.dart';
/// s
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

  static InputDecoration defaultTextField(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(

        enabledBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xffe9e9e9))),
        focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),

            borderSide: BorderSide(color: Color(0xffe9e9e9))),
        disabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),

            borderSide: const BorderSide(color: Color(0xffe9e9e9))),
        contentPadding:const EdgeInsets.only(left: 10, top: 10, bottom: 10),


        hintStyle: const TextStyle(color:Colors.grey,fontSize: 14),

        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));

  }
  static InputDecoration defaultTextFieldIcon(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        suffixIcon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.black,
        ),
        enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xffe9e9e9))),
        focusedBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),

            borderSide: BorderSide(color: Color(0xffe9e9e9))),
        disabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),

            borderSide: const BorderSide(color: Color(0xffe9e9e9))),
        contentPadding:const EdgeInsets.only(left: 10, top: 10, bottom: 10),


        hintStyle: const TextStyle(color:Colors.grey,fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffffffff));

  }
  static InputDecoration defaultStyle(context,
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Color(0xffE6E6E6)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Color(0xffE6E6E6)),
        ),
        contentPadding: const EdgeInsets.all(7),

        labelText: hintTextStr,
        labelStyle: customisedStyle(context, const Color(0xffACACAC), FontWeight.w600, 12.0),
        hintText: hintTextStr,
        hintStyle: customisedStyle(context, const Color(0xffACACAC), FontWeight.w600, 13.0),
        //  hintStyle: TextStyle(color: Color(0xffACACAC)),
        border: InputBorder.none,
        filled: true,

        fillColor: const Color(0xffFfffff));
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

  static InputDecoration mobileTextfieldMandatory(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(

        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe7e7e7))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe7e7e7))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe7e7e7))),
        contentPadding:const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        filled: true,


        hintStyle: const TextStyle(color: Color(0xff878787),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffFDFDFD));

  }
  static InputDecoration mobileTextfieldMandatoryIcon(
      {String labelTextStr = "", String hintTextStr = ""}) {
    return InputDecoration(
suffixIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
        enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe7e7e7))),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe7e7e7))),
        disabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffe7e7e7))),
        contentPadding:const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        filled: true,


        hintStyle: const TextStyle(color: Color(0xff878787),fontSize: 14),
        hintText: hintTextStr,
        fillColor: const Color(0xffFDFDFD));

  }
}
