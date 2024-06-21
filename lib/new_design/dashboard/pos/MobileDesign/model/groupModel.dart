class GroupListModelClass {
  final String id, groupName;
  final int groupID;


  GroupListModelClass({
    required this.id,
    required this.groupName,
    required this.groupID,

  });

  factory GroupListModelClass.fromJson(Map<dynamic, dynamic> json) {
    return GroupListModelClass(
      id: json['id'],
      groupName: json['GroupName'],
      groupID: json['ProductGroupID'],

    );
  }
}