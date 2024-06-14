import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';

class ProductGroupMobile extends StatefulWidget{
  @override
  State<ProductGroupMobile> createState() => _ProductGroupMobileState();
}

class _ProductGroupMobileState extends State<ProductGroupMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Product Group',
          style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
        ),
      ),
    );
  }
}