import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductGrpController extends GetxController {
  var productGroups = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final String token =  "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU0NzMzOTkwLCJpYXQiOjE3MjMxOTc5OTAsImp0aSI6IjY1ZmQwOTQwMDI2ZjQzMTJhYTk2OTBmNTlkNTQwYjZkIiwidXNlcl9pZCI6MzcxfQ.ngqkBT3aH7DmzmpcDZUpcvvH7ktE8WpwWmUzarawNBtP75IFqfGA3YyqV0vQfl7ZrgROTGyigDvtFWqRR2hUmDhbyF2a58WaVP0YktcdcysL6fHIzzBUVEz6knbujQZaoDKom_UI8FW8wDx-JzYnNFxlfOfDBdXkt9AB6TRo_3VBz2_8TwzcYSI2ccHIiK-xo0LMGNDnAXSSXZLyPUB24Uje2ei06s4D1WAkInsi2zMo-cRfaqn7AFamICprY4KlCY5uKPg27luK_XthmS2vySwijf7gQkMMZi3Z1yQvEgVgq6O3Ry5f3l0FmM6NAC9jr5x80oEj6DXHtvX21Z0SckrGLty0jlWJEA4wDrNDfHNFGWYRex4CLHJMi6900qns4Zd_i-PSEg7JiLy7CQArzRk34cUvqsErfJr7xtxtsLHmqpkDMBFNWXxDE_mU5uCsyT5ltR4XQa0yDkQbnGKeioxulQGMVS0Kdg3YyYiVft7d3_8dP9e1VoS1W8kHkFRm4D_Sk-oJ5x3sbKPat-cX3lrOXJA4nR6zzgy46qlPJrgu5ddhdiGQnsKZSKGrCC2AiIXxhcpwAOo1hlS4_1no3tKZuUPIvk846TTBPdYiIysC9MY3tj7E_XAnotuDgcigXl3fC1Sgho_2mno2698rB5qk6UCuPWmSQ13DCs92HDM";
  final String apiUrl = 'https://www.api.viknbooks.com/api/v10/posholds/pos/product-group/list/';

  @override
  void onInit() {

    super.onInit();
    fetchProductGroups();
  }
  var productGroupID = [].obs; // Observable list to store product IDs

  void fetchProductGroups() async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode({
          'CompanyID': '5a09676a-55ef-47e3-ab02-bac62005d847',
          'BranchID': '1',
          'Date': '2024-08-10',
          'is_used_group': 'true',
        }),

      );


      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        productGroups.value = data['data'] as List<dynamic>;
      //  productGroupID.addAll( productGroups[0]['ProductGroupID']);
        print("productGroupID ..$productGroupID");
        for(int i=0;i<productGroups.length;i++){



          print("productGroupID ..${productGroups[i]['ProductGroupID']}");
          productGroupID.add(productGroups[i]['ProductGroupID']);
        }
        print("productGroupIDs ..$productGroupID");
        print("productGroupID ..${productGroups[0]['ProductGroupID']}");
      } else {
        errorMessage.value = 'Failed to load product groups';
      }
    } catch (e) {
      errorMessage.value = 'An error occurred: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
