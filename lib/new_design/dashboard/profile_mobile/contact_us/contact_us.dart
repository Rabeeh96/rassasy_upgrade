import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';
import 'package:flutter_svg/svg.dart';
class Contact_us extends StatefulWidget {
  @override
  State<Contact_us> createState() => _SaleListState();
}

class _SaleListState extends State<Contact_us> {
  TextEditingController helpController = TextEditingController();
  FocusNode helpNode = FocusNode();
  FocusNode saveNode = FocusNode();
  String india = "+91 9577500400";
  String ksa = "+966 54 598 2976";
  String support = "+91-9037 444 800";
  String supportMail = "support@vikncodes.com";
  String infoMail = "info@vikncodes.com";
  String ksa1 = "+966 55 912 4428";

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: india));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copyPhone() async {
    await Clipboard.setData(ClipboardData(text: ksa));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copySupportPhone() async {
    await Clipboard.setData(ClipboardData(text: support));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copySupportMail() async {
    await Clipboard.setData(ClipboardData(text: supportMail));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copyInfoMail() async {
    await Clipboard.setData(ClipboardData(text: infoMail));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  Future<void> copyPhone1() async {
    await Clipboard.setData(ClipboardData(text: ksa1));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          centerTitle: false,
          title: Text(
            'Contact_Us'.tr,
            style: customisedStyle(context, Colors.black, FontWeight.w500, 20.0),
          ),
        ),
        body:ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Container(
                height: 1,
                color: const Color(0xffE9E9E9),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 15,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  onTap: () {},
                  decoration: TextFieldDecoration.defaultStyle(context,
                      hintTextStr: 'msg_hlp'.tr),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xffF24809),
                    borderRadius: BorderRadius.circular(3)),
                height: MediaQuery.of(context).size.height / 19,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Send'.tr,
                    style: customisedStyle(
                        context, Colors.white, FontWeight.w500, 14.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 4, top: 8),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Support'.tr,
                      style: customisedStyle(
                          context, Color(0xff6B6B6B), FontWeight.w500, 13.0),
                    ),
                    IconButton(
                        onPressed: () {
                          copySupportPhone();
                        },
                        icon: SvgPicture.asset('assets/svg/phone_about.svg')),
                    Text(
                      '+91-9037 444 800',
                      style: customisedStyle(
                          context, Color(0xff000000), FontWeight.w500, 13.0),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right:20, bottom: 8, top: 4),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 26,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'mail_us'.tr,
                      style: customisedStyle(
                          context, Color(0xff6B6B6B), FontWeight.w500, 13.0),
                    ),
                    IconButton(
                        onPressed: () {
                          copySupportMail();
                        },
                        icon: SvgPicture.asset('assets/svg/email-open.svg')),
                    Text(
                      'support@vikncodes.com',
                      style: customisedStyle(
                          context, Colors.black, FontWeight.w500, 13.0),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8,right: 20,left: 20),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xffF6F6F6)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15,bottom: 10,top: 10),
                      child: Row(
                        children: [

                          Text(
                            'India'.tr,
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w600, 18.0),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Sales_Team'.tr,
                        style: customisedStyle(context, Color(0xff6B6B6B),
                            FontWeight.w500, 13.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _copyToClipboard();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _copyToClipboard();
                                },
                                icon:
                                SvgPicture.asset('assets/svg/phone_about.svg')),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                india,
                                style: customisedStyle(context, Colors.black,
                                    FontWeight.w600, 13.0),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                copyInfoMail();
                              },
                              icon: SvgPicture.asset('assets/svg/email-open.svg')),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'info@vikncodes.com',
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w600, 13.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,bottom: 10),
                      child: Row(
                        children: [

                          Text(
                            'Arabia'.tr,
                            style: customisedStyle(
                                context, Colors.black, FontWeight.w600, 18.0),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Sales_Team'.tr,
                        style: customisedStyle(context, Color(0xff6B6B6B),
                            FontWeight.w600, 13.0),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        copyPhone();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  copyPhone();
                                },
                                icon:
                                SvgPicture.asset('assets/svg/phone_about.svg')),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                ksa,
                                style: customisedStyle(context, Colors.black,
                                    FontWeight.w500, 13.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        copyPhone1();
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  copyPhone1();
                                },
                                icon:
                                SvgPicture.asset('assets/svg/phone_about.svg')),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                ksa1,
                                style: customisedStyle(context, Colors.black,
                                    FontWeight.w500, 13.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 25,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                copyInfoMail();
                              },
                              icon: SvgPicture.asset('assets/svg/email-open.svg')),
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'info@vikncodes.com',
                              style: customisedStyle(context, Colors.black,
                                  FontWeight.w500, 13.0),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
