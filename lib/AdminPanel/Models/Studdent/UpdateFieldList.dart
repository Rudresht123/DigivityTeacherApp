class UpdateFieldList {
  final String fieldId;
  final String fieldName;

  UpdateFieldList({required this.fieldId, required this.fieldName});

  factory UpdateFieldList.fromJson(Map<String, dynamic> json) {
    return UpdateFieldList(
      fieldId: json['field_id'],
      fieldName: json['field_name'],
    );
  }
}
