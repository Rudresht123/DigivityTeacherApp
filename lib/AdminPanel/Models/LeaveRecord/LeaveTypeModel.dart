class LeaveTypeModel {
  final int id;
  final String leaveType;
  final String isDefault;

  LeaveTypeModel({
    required this.id,
    required this.isDefault,
    required this.leaveType,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'],
      isDefault: json['is_default'],
      leaveType: json['leave_type'],
    );
  }
}
