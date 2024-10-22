import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rassasy_new/global/global.dart';


class RassassyScreen extends StatefulWidget {
  const RassassyScreen({Key? key}) : super(key: key);

  @override
  State<RassassyScreen> createState() => _RassassyScreenState();
}

class _RassassyScreenState extends State<RassassyScreen> {
  String text = "savad faroodqu  savad faroodque";

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    // double width = mWidth*.57;
    double width = mWidth * 0.5; // Start with half the screen width
    int maxLength = 5; // Set the maximum allowed length
    if (text.length > maxLength) {
      // Reduce the width if the text length exceeds the maximum
      width = width * (maxLength / text.length);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,


      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height/11,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,

              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.red,
                    width: mWidth*.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Dining",style: customisedStyle(context, Color(0xff717171), FontWeight.w500, 21.0),),
                        Text("Choose a Table",style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(color: Colors.red, width: width),
                        SvgPicture.asset("assets/Refresg (1).svg"),
                        Container(child: Text(text,style: customisedStyle(context, Colors.black, FontWeight.w500, 17.0),)),
                        IconButton(onPressed: (){}, icon: Icon(Icons.logout))

                      ],
                    ),
                  ),
                )


              ],
            ),
          )
        ],
      ),

    );
  }
}
