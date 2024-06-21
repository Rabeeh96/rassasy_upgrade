
class Company {
 /// final bool isPosUser;
  final String id,
      companyName,
      baseurl,
      expiryDate,
      permission,
      edition,
      image;

  var branchList = [];
  Company(
      {required this.id,
        required this.image,
        required this.baseurl,
        required this.companyName,
      ///  required this.isPosUser,
        required this.edition,
        required this.branchList,
        required this.expiryDate,
        required this.permission});

  factory Company.fromJson(Map<dynamic, dynamic> json) {
    return Company(
      id: json['id'],
      permission: json['Permission']??"",
      baseurl: json['BaseURL'],
      edition: json['Edition'],
      expiryDate: json['ExpiryDate'],
      companyName: json['CompanyName'],
    ///  isPosUser: json['IsPosUser'],
      branchList: json['Branches']??[],
      image: json['CompanyLogo']??"",
    );
  }



}
