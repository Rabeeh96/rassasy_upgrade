import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rassasy_new/test/loc/controller/product_controller.dart';
import '../controller/group_controller.dart';
import 'group.dart';

class ProductPage extends StatefulWidget {
  int? productGroup;
  ProductPage({required this.productGroup, super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController productController = Get.put(ProductController());
  final ProductGrpController groupController = Get.put(ProductGrpController());

  getID() {
    print(productController.products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
              onPressed: () {

                //  getID();
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                for(int i=0;i<groupController.productGroupID.length;i++){
                  print(groupController.productGroupID[i]);
                  productController.fetchProducts(groupController.productGroupID[i]);
                }
                print(groupController.productGroupID);
                //  getID();
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [


          Obx(() {
            if (productController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (productController.errorMessage.value.isNotEmpty) {
              return Center(child: Text(productController.errorMessage.value));
            }

            return Expanded(child: ListView.builder(
              itemCount: productController.productDatasList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productController.productDatasList[index]['ProductName'])
                );
              },
            ));
          }),

        ],
      ),
    );
  }
}
