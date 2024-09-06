import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/group_controller.dart';
import '../controller/product_controller.dart';
import 'saved_data.dart';

class ProductGrpPage extends StatefulWidget {
  @override
  State<ProductGrpPage> createState() => _ProductGrpPageState();
}

class _ProductGrpPageState extends State<ProductGrpPage> {
  @override
  Widget build(BuildContext context) {
    final ProductGrpController groupController = Get.put(ProductGrpController());
    final ProductController productController = Get.put(ProductController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Groups'),
        actions: [
          // IconButton(
          //     onPressed: () {
          //      Get.to(SavedData());
          //     },
          //     icon: Text("Next")),
          IconButton(
              onPressed: () async {
                await Get.to(SavedData());
              },
              icon: const Text("Save")),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    groupController.fetchProductGroups();
                    for (int i = 0;
                        i < groupController.productGroupID.length;
                        i++) {
                      print(groupController.productGroupID[i]);
                      productController
                          .fetchProducts(groupController.productGroupID[i]);
                    }
                    print(groupController.productGroupID);
                  },
                  icon: Text("Sync")),
              IconButton(
                  onPressed: () {
                    productController.displayProductsByGroupId(12);
                    productController.update();
                  },
                  icon: Text("POS")),
            ],
          ),
          Container(
            height: 500,
            child: Row(
              children: [
                ///grp
                Container(
                  width: 170,
                  color: Colors.grey.shade50,
                  child: Obx(() {
                    if (groupController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (groupController.errorMessage.isNotEmpty) {
                      return Center(
                          child: Text(groupController.errorMessage.value));
                    }


                    return ListView.builder(
                      itemCount: groupController.productGroups.length,
                      itemBuilder: (context, index) {
                        final group = groupController.productGroups[index];
                        return ListTile(
                          onTap: (){
                           // productController.getProductsByGroupId(group['ProductGroupID']);
                            productController.displayProductsByGroupId(group['ProductGroupID']);
                            productController.update();
                          },
                          title: Text(
                            group['GroupName'],
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      },
                    );
                  }),
                ),

                Container(
                  width: 170,
                  color: Colors.green.shade50,
                  child: Obx(() {
                    if (productController.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (productController.errorMessage.value.isNotEmpty) {
                      return Center(
                          child: Text(productController.errorMessage.value));
                    }

                    return ListView.builder(
                      itemCount: productController.productsForGroup.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(productController.productsForGroup[index]
                            ['ProductName']));
                      },
                    );
                  }),
                ),

                ///
              ],
            ),
          ),
        ],
      ),
    );
  }
}
