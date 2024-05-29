class DeliveryManModel {
  final String id;
  final String userId;
  final String userName;
  final String role;
  final String roleName;
  final String pinNo;

  DeliveryManModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.role,
    required this.roleName,
    required this.pinNo,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    return DeliveryManModel(
      id: json['id'],
      userId: json['User'],
      userName: json['UserName'],
      role: json['Role'],
      roleName: json['RoleName'],
      pinNo: json['PinNo'],
    );
  }
}
