class KitchenListModelClass {
  final String ipAddress, kitchenName, id;
  final bool isActive;

  KitchenListModelClass({
    required this.ipAddress,
    required this.kitchenName,
    required this.isActive,
    required this.id,
  });

  factory KitchenListModelClass.fromJson(Map<dynamic, dynamic> json) {
    return KitchenListModelClass(id: json['id'], ipAddress: json['IPAddress'], kitchenName: json['KitchenName'], isActive: json['IsActive']);
  }
}
