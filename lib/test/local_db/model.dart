class Product {
  final String id;
  final int productId;
  final String name;
  final String salePrice;
  final String purchasePrice;
  final String salesTax;
  final String description;

  Product({
    required this.id,
    required this.productId,
    required this.name,
    required this.salePrice,
    required this.purchasePrice,
    required this.salesTax,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'salePrice': salePrice,
      'purchasePrice': purchasePrice,
      'salesTax': salesTax,
      'description': description,
    };
  }

  static Product fromMap(Map<dynamic, dynamic> map) {
    return Product(
      id: map['id'],
      productId: map['ProductID'],
      name: map['ProductName'],
      salePrice: map['DefaultSalesPrice'].toString(),
      purchasePrice: map['DefaultPurchasePrice'].toString(),
      salesTax: map['SalesTax'].toString(),
      description: map['Description'],
    );
  }
}
