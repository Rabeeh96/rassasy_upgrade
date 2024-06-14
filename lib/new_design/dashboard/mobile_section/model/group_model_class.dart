
class GroupModelClassMobile {
  final String uID, groupName;
  final int productGroupId;

  GroupModelClassMobile({
    required this.groupName,
    required this.productGroupId,
    required this.uID,
  });

  factory GroupModelClassMobile.fromJson(Map<dynamic, dynamic> json) {
    return GroupModelClassMobile(
        groupName: json['GroupName'],
        productGroupId: json['ProductGroupID'],
        uID: json['id']);
  }
}
