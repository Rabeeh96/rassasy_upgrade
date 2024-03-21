import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class select_code_page extends StatefulWidget {
  @override
  State<select_code_page> createState() => _select_code_pageState();
}

class _select_code_pageState extends State<select_code_page> {




  TextEditingController searchController = TextEditingController();


  @override
  void initState() {

  }

  List<String> printerModels = [
    "ISO_8859-6",
    "CP864",
    "ISO-8859-6",
    ""
  ];

  customisedStyle(context,Colors,FontWeight,fontSize){
    return GoogleFonts.poppins(textStyle:TextStyle(fontWeight: FontWeight,color: Colors,fontSize: fontSize));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor:  Colors.redAccent,

        title:   Text(
          "Select code page",style: customisedStyle(context, Colors.white, FontWeight.w400, 18.0),
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //height: 200,


          child: ListView.builder(
              padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 180),
              shrinkWrap: true,
              itemCount: printerModels.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context,printerModels[index]);
                    },

                    title: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              printerModels[index],

                            ),
                            const SizedBox(
                              height: 5,
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                );

              }),
        ),
      ),


    );
  }




}
//not complete


