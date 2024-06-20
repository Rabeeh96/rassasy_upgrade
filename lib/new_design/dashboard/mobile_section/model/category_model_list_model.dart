class ProductCategoryListModel {

  int categoryID;
  String uuid, categoryName, notes;

  ProductCategoryListModel({
    required this.uuid,
    required this.categoryID,
    required this.notes,
    required this.categoryName,
  });

  factory ProductCategoryListModel.fromJson(Map<dynamic, dynamic> json) {
    return ProductCategoryListModel(
      uuid: json['id'],
      categoryID: json['ProductCategoryID'],
      notes: json['Notes']??"",
      categoryName: json['ProductCategoryName'],
    );
  }
}

