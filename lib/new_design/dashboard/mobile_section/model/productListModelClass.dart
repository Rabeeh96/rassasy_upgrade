class Product {
  final String id;
  final String productName;
  final String defaultUnitName;
  final String defaultSalesPrice;
  final int productID;
  final String productImage;
  // Add more fields if needed

  Product({
    required this.id,
    required this.productName,
    required this.defaultUnitName,
    required this.defaultSalesPrice,
    required this.productID,
    required this.productImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productName: json['ProductName'],
      defaultUnitName: json['DefaultUnitName'],
      defaultSalesPrice: json['DefaultSalesPrice'].toString(),
      productID: json['ProductID'],
      productImage: json['ProductImage'],
    );
  }
}
