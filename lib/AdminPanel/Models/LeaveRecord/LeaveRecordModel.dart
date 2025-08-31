import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';

class LeaveRecord {
  final String lvTitle;
  final String lvDescription;
  final String lvStatus;
  final int lvId;
  final String applyDate;
  final String lvFromDate;
  final String lvToDate;
  final String lvDays;
  final List<Attachment> attchment;
  final String leaveApplyByProfile;

  LeaveRecord({
    required this.lvTitle,
    required this.lvDescription,
    required this.lvStatus,
    required this.lvId,
    required this.applyDate,
    required this.lvFromDate,
    required this.lvToDate,
    required this.lvDays,
    required this.attchment,
    required this.leaveApplyByProfile,
  });

  factory LeaveRecord.fromJson(Map<String, dynamic> json) {
    return LeaveRecord(
      lvTitle: json['lv_title'] ?? '',
      lvDescription: json['lv_description'] ?? '',
      lvStatus: json['lv_status'] ?? '',
      lvId: json['lv_id'] ?? 0,
      applyDate: json['apply_date'] ?? '',
      lvFromDate: json['lv_from_date'] ?? '',
      lvToDate: json['lv_to_date'] ?? '',
      lvDays: json['lv_days'] ?? '',
      attchment: (json['attchment'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e))
          .toList() ??
          [],
      leaveApplyByProfile: json['leave_apply_by_profile'] ?? '',
    );
  }
}
