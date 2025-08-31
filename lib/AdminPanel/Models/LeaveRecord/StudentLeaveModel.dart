import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/LeaveRecordModel.dart';

class StudentLeaveModel {
  final int studentId;
  final int dbId;
  final String profileImage;
  final String leaveApplyBy;
  final String? admissionNo;
  final String? fatherName;
  final String courseSection;
  final List<LeaveRecord> leaverecord;

  StudentLeaveModel({
    required this.studentId,
    required this.dbId,
    required this.profileImage,
    required this.leaveApplyBy,
    required this.courseSection,
    required this.leaverecord,
    this.admissionNo,
    this.fatherName
  });

  factory StudentLeaveModel.fromJson(Map<String, dynamic> json) {
    return StudentLeaveModel(
      studentId: json['student_id'] ?? 0,
      dbId: json['db_id'] ?? 0,
      admissionNo:json['admission_no'] ?? "",
      fatherName: json['father_name']??'',
      profileImage: json['profile_image'] ?? '',
      leaveApplyBy: json['leave_apply_by'] ?? '',
      courseSection: json['courseSection'] ?? '',
      leaverecord: (json['leaverecord'] as List<dynamic>?)
          ?.map((e) => LeaveRecord.fromJson(e))
          .toList() ??
          [],
    );
  }
}

