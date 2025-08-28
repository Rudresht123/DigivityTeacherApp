class UsercopyModel {
  final int id;
  final String? role;
  final String name;
  final String contactNo;

  UsercopyModel({
    required this.id,
    this.role,
    required this.name,
    required this.contactNo,
  });

  factory UsercopyModel.fromJson(Map<String, dynamic> json) {
    return UsercopyModel(
      id: json['id'] as int,
      role: json['role'] as String?,
      name: json['name'] as String,
      contactNo: json['contact_no'] as String, // corrected key
    );
  }

  @override
  String toString() {
    return '{id: $id, role: $role, name: $name, contactNo: $contactNo}';
  }
}
