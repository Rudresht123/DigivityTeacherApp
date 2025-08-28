import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SyllabusModel.dart';

class CircularModel {
  final int circularId;
  final String course;
  final String studentType;
  final dynamic? designationId;
  final String? staffType;
  final String? circularType;
  final String? circularNo;
  final String? circularDate;
  final dynamic? circularTime;
  final String? circularTitle;
  final dynamic? circular;
  final String? showDateTime;
  final String? endDateTime;
  final String? withApp;
  final String? withTextSms;
  final String? withEmail;
  final String? withWebsite;
  final String? withWhatsapp;
  final String? urlLink;
  final String? authorizeBy;
  final String? status;
  final String? submittedBy;
  final String? submittedByProfile;
  final List<Attachment> attachments;

  CircularModel({
    required this.circularId,
    required this.course,
    required this.studentType,
    required this.designationId,
    required this.staffType,
    required this.circularType,
    required this.circularNo,
    required this.circularDate,
    required this.circularTime,
    required this.circularTitle,
    required this.circular,
    required this.showDateTime,
    required this.endDateTime,
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

  factory CircularModel.fromJson(Map<String, dynamic> json) {
    return CircularModel(
      circularId: json['circular_id'],
      course: json['course'] ?? "",
      studentType: json['student_type'] ?? "",
      designationId: json['designation_id'] ?? "",
      staffType: json['staff_type'] ?? "",
      circularType: json['circular_type'] ?? "",
      circularNo: json['circular_no'] ?? "",
      circularDate: json['circular_date'] ?? "",
      circularTime: json['circular_time'] ?? "",
      circularTitle: json['circular_title'] ?? "",
      circular: json['circular'] ?? "",
      showDateTime: json['show_date_time'] ?? "",
      endDateTime: json['end_date_time'] ?? "",
      withApp: json['with_app'] ?? "",
      withTextSms: json['with_text_sms'] ?? "",
      withEmail: json['with_email'] ?? "",
      withWebsite: json['with_website'] ?? "",
      withWhatsapp: json['with_whatsapp'] ?? "",
      urlLink: json['url_link'] ?? "",
      authorizeBy: json['authorize_by'] ?? "",
      status: json['status'] ?? "",
      submittedBy: json['submitted_by'] ?? "",
      submittedByProfile: json['submitted_by_profile'] ?? "",
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => Attachment.fromJson(e))
          .toList(),
    );
  }
}

