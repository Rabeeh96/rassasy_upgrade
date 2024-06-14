import 'package:flutter/material.dart';
import "package:webview_universal/webview_universal.dart";

import '../../../global/global.dart';




class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  WebViewController webViewController = WebViewController();

  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    await webViewController.init(
      context: context,
      uri: Uri.parse("https://accounts.vikncodes.com/"), setState: (void Function() fn) {  },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Profile ",style: customisedStyle(context, Colors.black, FontWeight.w500,MediaQuery.of(context).size.height*0.024),
          ),
          centerTitle: false,
          titleSpacing: 0,


      ),

      body:  WebView(
        controller: webViewController,
      ),
    );
  }
}