class PriceCategoryModel {
  String priceCategoryName, id;
  int catId;

  PriceCategoryModel({
    required this.priceCategoryName,
    required this.id,
    required this.catId,
  });

  factory PriceCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    return PriceCategoryModel(
        priceCategoryName: json['PriceCategoryName'] ?? '',
        id: json['id'],
        catId: json['PriceCategoryID']);
  }
}