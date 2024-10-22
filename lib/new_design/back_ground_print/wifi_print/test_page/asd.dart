
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:flutter_image/flutter_image.dart';

import 'package:arabic_font/arabic_font.dart';


Uint8List convertArabicToUint8List(String arabicText) {
  // Convert Arabic string to UTF-8 encoded bytes
  List<int> utf8Bytes = utf8.encode(arabicText);

  // Convert the List<int> to Uint8List
  Uint8List uint8List = Uint8List.fromList(utf8Bytes);

  return uint8List;
}


Future<Uint8List> createArabicTextImage(String text) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);


  TextSpan span = TextSpan(
    style: TextStyle(
      color: Colors.black,
      fontSize: 10,
      fontFamily: ArabicFont.amiri,
    ),
    text: text,
  );

  TextPainter tp = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.rtl, // RTL for Arabic text
  );

  tp.layout();
  tp.paint(canvas, Offset.zero);

  final picture = recorder.endRecording();
  final img = await picture.toImage(tp.width.toInt(), tp.height.toInt());

  ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}