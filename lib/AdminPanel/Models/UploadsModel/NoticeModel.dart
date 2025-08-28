import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SyllabusModel.dart';

class NoticeModel {
  final int noticeId;
  final String course;
  final String studentType;
  final String? designationId;
  final String? staffType;
  final String noticeType;
  final String noticeNo;
  final String noticeDate;
  final String noticeTime;
  final String noticeTitle;
  final String notice;
  final String? showDateTime;
  final String? endDateTime;
  final String withApp;
  final String withTextSms;
  final String withEmail;
  final String withWebsite;
  final String withWhatsapp;
  final String urlLink;
  final String authorizeBy;
  final String status;
  final String submittedBy;
  final String submittedByProfile;
  final List<Attachment> attachments;

  NoticeModel({
    required this.noticeId,
    required this.course,
    required this.studentType,
    this.designationId,
    this.staffType,
    required this.noticeType,
    required this.noticeNo,
    required this.noticeDate,
    required this.noticeTime,
    required this.noticeTitle,
    required this.notice,
    this.showDateTime,
    this.endDateTime,
    required this.withApp,
    required this.withTextSms,
    required this.withEmail,
    required this.withWebsite,
    required this.withWhatsapp,
    required this.urlLink,
    required this.authorizeBy,
    required this.status,
    required this.submittedBy,
    required this.submittedByProfile,
    required this.attachments,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      noticeId: json['notice_id'] ?? 0,
      course: json['course'] ?? '',
      studentType: json['student_type'] ?? '',
      designationId: json['designation_id'],
      staffType: json['staff_type'],
      noticeType: json['notice_type'] ?? '',
      noticeNo: json['notice_no'] ?? '',
      noticeDate: json['notice_date'] ?? '',
      noticeTime: json['notice_time'] ?? '',
      noticeTitle: json['notice_title'] ?? '',
      notice: json['notice'] ?? '',
      showDateTime: json['show_date_time'],
      endDateTime: json['end_date_time'],
      withApp: json['with_app'] ?? 'no',
      withTextSms: json['with_text_sms'] ?? 'no',
      withEmail: json['with_email'] ?? 'no',
      withWebsite: json['with_website'] ?? 'no',
      withWhatsapp: json['with_whatsapp'] ?? 'no',
      urlLink: json['url_link'] ?? '',
      authorizeBy: json['authorize_by'] ?? '',
      status: json['status'] ?? '',
      submittedBy: json['submitted_by'] ?? '',
      submittedByProfile: json['submitted_by_profile'] ?? '',
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e))
          .toList() ??
          [],
    );
  }
}

