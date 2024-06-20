
class ProductGroupListModel {
  final String uID, groupName,
  //kitchenName,
      categoryName;
  final int productGroupId,categoryID;

  ProductGroupListModel({required this.groupName,/*required this.kitchenName,*/ required this.productGroupId, required this.uID, required this.categoryID, required this.categoryName});

  factory ProductGroupListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductGroupListModel(
        groupName: json['GroupName'],
        categoryID: json['CategoryID'],
        categoryName: json['CategoryName'],
        productGroupId: json['ProductGroupID'],
        //kitchenName: json['ProductGroupID'],
        uID: json['id']);
  }
}