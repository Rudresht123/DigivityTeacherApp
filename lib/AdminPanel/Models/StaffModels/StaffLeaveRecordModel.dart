import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';

class StaffLeaveRecordModel {
  int lvId;
  String? applyDate;
  String? lvFromDate;
  String? lvToDate;
  String? lvDays;
  String? lvTitle;
  String? lvDescription;
  List<Attachment> attachment;
  String? lvStatus;
  String? leaveApplyBy;
  String? leaveApplyByProfile;
  String? lvStatusReason;

  StaffLeaveRecordModel({
    required this.lvId,
    this.applyDate,
    this.lvFromDate,
    this.lvToDate,
    this.lvDays,
    this.lvTitle,
    this.lvDescription,
    required this.attachment,
    this.lvStatus,
    this.leaveApplyBy,
    this.leaveApplyByProfile,
    this.lvStatusReason,
  });

  factory StaffLeaveRecordModel.fromJson(Map<String, dynamic> json) {
    return StaffLeaveRecordModel(
      lvId: json['lv_id'],
      applyDate: json['apply_date'] ?? "",
      lvFromDate: json['lv_from_date'] ?? "",
      lvToDate: json['lv_to_date'] ?? "",
      lvDays: json['lv_days'] ?? "",
      lvTitle: json['lv_title'] ?? "",
      lvStatusReason: json['leave_status_reason'] ?? "",
      lvDescription: json['lv_description'] ?? "",
      attachment:
          (json['attachment'] as List)
              .map((e) => Attachment.fromJson(e))
              .toList() ??
          [],
      lvStatus: json['lv_status'] ?? "",
      leaveApplyBy: json['leave_apply_by'] ?? "",
      leaveApplyByProfile: json['leave_apply_by_profile'] ?? "",
    );
  }
}
