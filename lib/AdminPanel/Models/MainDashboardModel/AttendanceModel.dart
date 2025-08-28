class AttendanceModel {
  final int total;
  final int present;
  final int absent;
  final int leave;
  final int late;
  final int unmarked;

  AttendanceModel({
    required this.total,
    required this.present,
    required this.absent,
    required this.leave,
    required this.late,
    required this.unmarked,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      total: json['total'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      leave: json['leave'] ?? 0,
      late: json['late'] ?? 0,
      unmarked: json['unmarked'] ?? 0,
    );
  }
}
