class CustomerModelClass {
  String firstName,
      lastName,
      customerName,
      partyName,
      id,
      phone,
      email_api,
      address_api,
      partyImage;

  CustomerModelClass(
      {required this.firstName,
        required this.phone,
        required this.lastName,
        required this.customerName,
        required this.id,
        required this.partyName,
        required this.email_api,
        required this.partyImage,
        required this.address_api});

  factory CustomerModelClass.fromJson(Map<dynamic, dynamic> json) {
    return CustomerModelClass(
        lastName: json['LastName'] ?? '',
        phone: json['PhoneNumber'] ?? '',
        firstName: json['FirstName'] ?? '',
        partyImage: json['PartyImage'] ?? '',
        customerName: json['CustomerName'] ?? '',
        partyName: json['PartyName'] ?? '',
        id: json['id'],
        email_api: json['Email'] ?? '',
        address_api: json['Address1'] ?? '');
  }
}
