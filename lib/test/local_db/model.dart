import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class ProductListModelHive extends HiveObject {
  @HiveField(0)
  String groupName;

  @HiveField(1)
  int categoryID;

  @HiveField(2)
  String categoryName;

  @HiveField(3)
  int productGroupId;

  @HiveField(4)
  String uID;

  ProductListModelHive({
    required this.groupName,
    required this.categoryID,
    required this.categoryName,
    required this.productGroupId,
    required this.uID,
  });

  factory ProductListModelHive.fromJson(Map<String, dynamic> json) {
    return ProductListModelHive(
      groupName: json['groupName'] ?? '',
      categoryID: json['categoryID'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      productGroupId: json['productGroupId'] ?? 0,
      uID: json['uID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'categoryID': categoryID,
      'categoryName': categoryName,
      'productGroupId': productGroupId,
      'uID': uID,
    };
  }
}
