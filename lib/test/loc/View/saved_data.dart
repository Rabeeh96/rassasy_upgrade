import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';

class SavedData extends StatefulWidget {
  @override
  State<SavedData> createState() => _SavedDataState();
}

class _SavedDataState extends State<SavedData> {
  final ProductController controller = Get.put(ProductController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadProductDatasList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        return  ListView.builder(
          itemCount: controller.fetchedList.length,
          itemBuilder: (context, index) {
            var product = controller.fetchedList[index];
            return ListTile(
              title: Text(product['ProductName'] ?? 'No Name'), // Adjust keys as necessary
              subtitle:Text(index.toString()), // Adjust keys as necessary
            );
          },
        );
      }),
    );
  }
}
