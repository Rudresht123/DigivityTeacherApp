class GradeModel {
  final String key;
  final String value;

  GradeModel({
    required this.key,
    required this.value,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key, // should not be 'id'
      'value': value,
    };
  }
}
