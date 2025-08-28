class ClassTotalAttendanceModel {
  final String key;
  final String value;
  final String classTotalAttendance;

  ClassTotalAttendanceModel({
    required this.key,
    required this.value,
    required this.classTotalAttendance,
  });

  factory ClassTotalAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ClassTotalAttendanceModel(
      key: json['key']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      classTotalAttendance: json['class_total_attendance']?.toString() ?? '',
    );
  }


}
