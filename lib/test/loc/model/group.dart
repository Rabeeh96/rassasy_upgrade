class ProductGroup {
  final String id;
  final int productGroupID;
  final String groupName;
  final String image;
  final int categoryID;
  final String categoryName;
  final String kitchenName;

  ProductGroup({
    required this.id,
    required this.productGroupID,
    required this.groupName,
    required this.image,
    required this.categoryID,
    required this.categoryName,
    required this.kitchenName,
  });

  factory ProductGroup.fromJson(Map<String, dynamic> json) {
    return ProductGroup(
      id: json['id'] ?? '',
      productGroupID: json['ProductGroupID'] ?? 0,
      groupName: json['GroupName'] ?? '',
      image: json['Image'] ?? '',
      categoryID: json['CategoryID'] ?? 0,
      categoryName: json['CategoryName'] ?? '',
      kitchenName: json['KitchenName'] ?? '',
    );
  }
}
