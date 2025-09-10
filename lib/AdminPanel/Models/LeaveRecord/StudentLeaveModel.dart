import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';

class StudentLeaveModel {
  final String lvTitle;
  final String lvDescription;
  final String lvStatus;
  final int lvId;
  final String applyDate;
  final String lvFromDate;
  final String lvToDate;
  final String lvDays;
  final String? fatherName;
  final String? courseSection;
  final List<Attachment> attachment;
  final String? leaveApplyBy;
  final String leaveApplyByProfile;
  final String? admissionNo;
  final String? lvStatusReason;

  StudentLeaveModel({
    required this.lvTitle,
    required this.lvDescription,
    required this.lvStatus,
    required this.lvId,
    required this.applyDate,
    required this.lvFromDate,
    required this.lvToDate,
    required this.lvDays,
    required this.attachment,
    required this.leaveApplyByProfile,
    this.fatherName,
    this.courseSection,
    this.leaveApplyBy,
    this.admissionNo,
    this.lvStatusReason
  });

  factory StudentLeaveModel.fromJson(Map<String, dynamic> json) {
    return StudentLeaveModel(
      leaveApplyBy: json['leave_apply_by'] ?? '',
      lvTitle: json['lv_title'] ?? '',
      lvDescription: json['lv_description'] ?? '',
      lvStatusReason:json['leave_status_reason'] ?? '',
      lvStatus: json['lv_status'] ?? '',
      lvId: json['lv_id'] ?? 0,
      applyDate: json['apply_date'] ?? '',
      courseSection: json['courseSection'] ?? '',
      lvFromDate: json['lv_from_date'] ?? '',
      lvToDate: json['lv_to_date'] ?? '',
      lvDays: json['lv_days'] ?? '',
      attachment:
          (json['attachment'] as List<dynamic>?)
              ?.map((e) => Attachment.fromJson(e))
              .toList() ??
          [],
      leaveApplyByProfile: json['leave_apply_by_profile'],
    );
  }
}
