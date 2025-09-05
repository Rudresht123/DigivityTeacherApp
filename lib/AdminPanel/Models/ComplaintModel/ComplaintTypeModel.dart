class ComplaintTypeModel {
  final int complaintTypeId;
  final String? complaintType;

  ComplaintTypeModel({
    required this.complaintType,
    required this.complaintTypeId,
  });

  factory ComplaintTypeModel.fromJson(Map<String, dynamic> json) {
    return ComplaintTypeModel(
      complaintType:json['complaint_type'] ?? "",
      complaintTypeId:  json['complaint_type_id'] ?? 0,
    );
  }
}
