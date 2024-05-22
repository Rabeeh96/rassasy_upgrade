import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/customclass.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/global/textfield_decoration.dart';

import 'controller/online_platform_controller.dart';

class OnlinePlatform extends StatefulWidget {
  @override
  State<OnlinePlatform> createState() => _OnlinePlatformState();
}

class _OnlinePlatformState extends State<OnlinePlatform> {
  TextEditingController nameController = TextEditingController();
  var platformId='';

  OnlinePlatformController onlinePlatformController =
      Get.put(OnlinePlatformController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: const Text(
          'Online Platform',
          style: TextStyle(color: Color(0xff000000), fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 5),
            child: Obx(() {
              if (onlinePlatformController.dataList.isEmpty) {
                return Center(child: CircularProgressIndicator()); // Or any loading indicator
              } else {
                return ListView.builder(
                    // the number of items in the list
                    itemCount: onlinePlatformController.dataList.length,

                    // display each item of the product list
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          nameController.text=onlinePlatformController
                              .dataList[index].name!;
                          platformId=onlinePlatformController
                              .dataList[index].id!;
                          onlinePlatformController.isEdit.value=true;
                          addPlatform(onlinePlatformController
                              .dataList[index].name!,onlinePlatformController
                              .dataList[index].id!);
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 4.5,
                                  child: Text(
                                    onlinePlatformController
                                        .dataList[index].name!,
                                    style: customisedStyle(context, Colors.black,
                                        FontWeight.w400, 14.0),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.navigate_next))
                              ],
                            ),
                            DividerStyle()
                          ],
                        ),
                      );
                    });
              }
            }),
          ))
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffFFF6F2))),
                onPressed: () {
                  addPlatform('','');
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Color(0xffF25F29),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Text(
                        'add_platform',
                        style: customisedStyle(context, const Color(0xffF25F29),
                            FontWeight.normal, 12.0),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void addPlatform(String name,String id) {
    Get.bottomSheet(
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          // Set border radius to the top left corner
          topRight: Radius.circular(
              10.0), // Set border radius to the top right corner
        ),
      ),
      backgroundColor: Colors.white,
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'add_online_platform'.tr,
                    style: customisedStyle(
                        context, Colors.black, FontWeight.w500, 14.0),
                  ),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0xffE9E9E9),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width / 4,
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  controller: nameController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                  //  focusNode: diningController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration:
                      TextFieldDecoration.defaultTextField(hintTextStr: 'Name'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, bottom: 16, top: 5),
              child: Container(
                height: MediaQuery.of(context).size.height / 17,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffF25F29)),
                  ),
                  onPressed: () async{
                    if(onlinePlatformController.isEdit.value==true){
                      onlinePlatformController.updateData(name: nameController.text, id: platformId);
                    }
                    else{
                      onlinePlatformController.createPlatform(nameController.text);

                    }

                  Get.back();
                  },
                  child: Text(
                    'save'.tr,
                    style: customisedStyle(
                        context, Colors.white, FontWeight.normal, 12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
