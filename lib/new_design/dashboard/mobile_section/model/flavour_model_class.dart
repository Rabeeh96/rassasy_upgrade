class FlavourListModelClass {
  final String id, flavourName, bgColor;
  final int flavourID;
  final bool isActive;

  FlavourListModelClass({
    required this.id,
    required this.flavourID,
    required this.flavourName,
    required this.bgColor,
    required this.isActive,
  });

  factory FlavourListModelClass.fromJson(Map<dynamic, dynamic> json) {
    return FlavourListModelClass(
      id: json['id'],
      flavourID: json['FlavourID'],
      flavourName: json['FlavourName'],
      bgColor: json['BgColor'],
      isActive: json['IsActive'],
    );
  }
}