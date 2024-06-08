class DeliveryManModel {
  final int deliveryManID;

  final String userName;

  DeliveryManModel({

    required this.userName,
    required this.deliveryManID,
  });

  factory DeliveryManModel.fromJson(Map<String, dynamic> json) {
    return DeliveryManModel(

      userName: json['UserName'],
      deliveryManID: json['EmployeeID'],
    );
  }
}


