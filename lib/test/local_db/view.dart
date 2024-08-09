
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
////
import 'api_service.dart';

class ProductFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetch and Save Products')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await ApiService.fetchAndSaveProducts();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Products saved locally')),
              );
            } catch (error) {
              print("5687687687$error");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to fetch and save products$error' )),
              );
            }
          },
          child: Text('Fetch and Save Products'),
        ),
      ),
    );
  }
}
