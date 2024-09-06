class PlatformModel {
  final String id;
  final String name;

  PlatformModel({required this.id, required this.name});

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['id'],
      name: json['Name'],
    );
  }
}
