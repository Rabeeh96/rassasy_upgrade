
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/global/global.dart';
import 'package:rassasy_new/new_design/back_ground_print/wifi_print/test_page/print_settings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../../../global/customclass.dart';
import '../../../../../../global/textfield_decoration.dart';
import '../../controller/platform_controller.dart';

class OnlinePlatforms extends StatefulWidget {
  @override
  State<OnlinePlatforms> createState() => _OnlinePlatformsState();
}

class _OnlinePlatformsState extends State<OnlinePlatforms> {
  final PlatformController controller = Get.put(PlatformController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text('Platforms',style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),),
        actions: [
          TextButton(onPressed: (){
            controller.platformNameController.clear();

            addPlatform(platformName: '', platformID: '', isEdit: false);
          }, child: Text("Add"))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return controller.platforms.isEmpty?Text("No Platforms found "): Center(
          child: Container(
            width: MediaQuery.of(context).size.width/3,
            child: SlidableAutoCloseBehavior(
                closeWhenOpened: true,
                child: ListView.separated(
                  itemCount: controller.platforms.length,
                  itemBuilder: (context, index) {
                    final platform = controller.platforms[index];
                    return Slidable(
                        key: ValueKey(
                            controller.platforms[index]),
                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),
                          // A pane can dismiss the Slidable.
                          // All actions are defined in the children parameter.
                          children: [
                            // A LiableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext context) async {

                                // bool hasPermission =
                                // await checkingPerm("Flavourdelete");
                                //
                                // if (hasPermission) {
                                bottomDialogueFunction(
                                    isDismissible: true,
                                    textMsg: "Sure want to delete",
                                    fistBtnOnPressed: () {
                                      Get.back(); // Close the dialog
                                    },
                                    secondBtnPressed: () async {
                                      controller.deletePlatform(controller.platforms[index].id);

                                    },
                                    secondBtnText: 'Ok',
                                    context: context);
                                // } else {
                                //   dialogBoxPermissionDenied(
                                //       context); // Assuming this function also uses Get.dialog
                                // }
                              },
                              // onPressed: doNothing ,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),
                          // A pane can dismiss the Slidable.
                          // All actions are defined in the children parameter.
                          children: [
                            // A LiableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext context) async {
                                print("entetr");

                                controller.platformNameController.text=platform.name;
                                controller.platformID.value=platform.id;
                                controller.isEdit.value=true;

                                addPlatform(platformName: platform.name, platformID: platform.id, isEdit: true,);


                              },
                              // onPressed: doNothing ,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        // The end action pane is the one at the right or the bottom side.

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child:  Card(
                          child: ListTile(

                            onTap: (){
                              Get.back(result: [platform.name,platform.id]);
                            },
                            title: Text(platform.name),

                          ),
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      dividerStyle(),
                )),
          ),
        );
     
      }),
    );
  }

  void addPlatform({required String platformName,required String platformID,required bool isEdit}) {
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
                    'Platform',
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
                  controller: controller.platformNameController,
                  style: customisedStyle(
                      context, Colors.black, FontWeight.w500, 14.0),
                 // focusNode: posController.customerNode,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus();
                  },
                  keyboardType: TextInputType.text,
                  decoration: TextFieldDecoration.defaultTextField(
                      hintTextStr: 'Name'),
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
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Adjust the radius as needed
                      ),
                    ),
                    backgroundColor:
                    WidgetStateProperty.all(const Color(0xffF25F29)),
                  ),
                  onPressed: () {
                    if (controller.platformNameController.text == "") {
                      dialogBox(context, "Please enter a  platform ");
                    } else {
                      controller.isEdit.value?controller.editPlatform(controller.platformNameController.text,platformID):
                      controller.createPlatform(controller.platformNameController.text);
                    }
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
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rassasy_new/global/global.dart';
// import 'package:rassasy_new/new_design/back_ground_print/wifi_print/test_page/print_settings.dart';
//
// import '../../../../../../global/textfield_decoration.dart';
// import '../../controller/platform_controller.dart';
//
// class OnlinePlatforms extends StatefulWidget {
//   @override
//   State<OnlinePlatforms> createState() => _OnlinePlatformsState();
// }
//
// class _OnlinePlatformsState extends State<OnlinePlatforms> {
//   final PlatformController controller = Get.put(PlatformController());
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         titleSpacing: 0,
//         title: Text('Platforms',style: customisedStyle(context, Colors.black, FontWeight.w500, 18.0),),
//         actions: [
//           TextButton(onPressed: (){
//             controller.platformNameController.clear();
//
//             addPlatform(platformName: '', platformID: '', isEdit: false);
//           }, child: Text("Add"))
//         ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return ListView.separated(
//           itemCount: controller.platforms.length,
//           itemBuilder: (context, index) {
//             final platform = controller.platforms[index];
//             return
//
//
//               ListTile(
//               onLongPress: (){
//                 controller.platformNameController.text=platform.name;
//                 controller.platformID.value=platform.id;
//                 controller.isEdit.value=true;
//
//                 addPlatform(platformName: platform.name, platformID: platform.id, isEdit: true,);
//               },
//               onTap: (){
//                 Get.back(result: [platform.name,platform.id]);
//               },
//               title: Text(platform.name),
//
//             );
//           }, separatorBuilder: (BuildContext context, int index) => DividerStyle(),
//         );
//       }),
//     );
//   }
//
//   void addPlatform({required String platformName,required String platformID,required bool isEdit}) {
//     Get.bottomSheet(
//       isDismissible: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10.0),
//           // Set border radius to the top left corner
//           topRight: Radius.circular(
//               10.0), // Set border radius to the top right corner
//         ),
//       ),
//       backgroundColor: Colors.white,
//       Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0, top: 16, bottom: 14),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Platform',
//                     style: customisedStyle(
//                         context, Colors.black, FontWeight.w500, 14.0),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       icon: const Icon(
//                         Icons.clear,
//                         color: Colors.black,
//                       ))
//                 ],
//               ),
//             ),
//             Container(
//               height: 1,
//               color: const Color(0xffE9E9E9),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Container(
//                 width: MediaQuery.of(context).size.width / 4,
//                 child: TextField(
//                   textCapitalization: TextCapitalization.words,
//                   controller: controller.platformNameController,
//                   style: customisedStyle(
//                       context, Colors.black, FontWeight.w500, 14.0),
//                  // focusNode: posController.customerNode,
//                   onEditingComplete: () {
//                     FocusScope.of(context)
//                         .requestFocus();
//                   },
//                   keyboardType: TextInputType.text,
//                   decoration: TextFieldDecoration.defaultTextField(
//                       hintTextStr: 'Name'),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   left: 16.0, right: 16, bottom: 16, top: 5),
//               child: Container(
//                 height: MediaQuery.of(context).size.height / 17,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     shape: WidgetStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                             8.0), // Adjust the radius as needed
//                       ),
//                     ),
//                     backgroundColor:
//                     WidgetStateProperty.all(const Color(0xffF25F29)),
//                   ),
//                   onPressed: () {
//                     if (controller.platformNameController.text == "") {
//                       dialogBox(context, "Please enter a  platform ");
//                     } else {
//                       controller.isEdit.value?controller.editPlatform(controller.platformNameController.text,platformID):
//                       controller.createPlatform(controller.platformNameController.text);
//                     }
//                   },
//                   child: Text(
//                     'save'.tr,
//                     style: customisedStyle(
//                         context, Colors.white, FontWeight.normal, 12.0),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
