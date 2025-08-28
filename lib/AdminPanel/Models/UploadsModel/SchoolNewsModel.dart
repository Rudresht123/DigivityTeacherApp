import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/AssignmentModel.dart';

class SchoolNewsModel{
  final int newsId;
  final String? newsFor;
  final String? newsDate;
  final String? uptoDate;
  final String? newsTime;
  final String? referenceBy;
  final String? newsWroteBy;
  final String? newTitleSubject;
  final String? newsDescription;
  final String? urlLink;
  final String? showApp;
  final String? showTextSms;
  final String? showWhatsapp;
  final String? showEmail;
  final String? showWebsite;
  final String? showAppBanner;
  final String? status;
  final String? submittedBy;
  final String? submittedByProfile;
  final List<Attachment> attachments;

  SchoolNewsModel({
    required this.newsId,
    this.newsFor,
    this.newsDate,
    this.uptoDate,
    this.newsTime,
    this.referenceBy,
    this.newsWroteBy,
    this.newTitleSubject,
    this.newsDescription,
    this.urlLink,
    this.showApp,
    this.showTextSms,
    this.showWhatsapp,
    this.showEmail,
    this.showWebsite,
    this.showAppBanner,
    this.status,
    this.submittedBy,
    this.submittedByProfile,
    required this.attachments,
  });


  factory SchoolNewsModel.fromJson(Map<String, dynamic> json) {
    return SchoolNewsModel(
      newsId: json['news_id'] ?? "",   // accepts both
      newsFor: json['news_for'] ?? "",
      newsDate: json['news_date'] ?? "",
      uptoDate: json['upto_date'] ?? "",
      newsTime: json['news_time'] ?? "",
      referenceBy: json['reference_by'] ?? "",
      newsWroteBy: json['news_wrote_by'] ?? "",
      newTitleSubject: json['new_title_subject'] ?? "",
      newsDescription: json['news_description'] ?? "",
      urlLink: json['url_link'] ?? "",
      showApp: json['show_app'] ?? "",
      showTextSms: json['show_text_sms'] ?? "",
      showWhatsapp: json['show_whatsapp'] ?? "",
      showEmail: json['show_email'] ?? "",
      showWebsite: json['show_website'] ?? "",
      showAppBanner: json['show_app_banner'] ?? "",
      status: json['status'] ?? "",
      submittedBy: json['submitted_by'] ?? "",
      submittedByProfile: json['submitted_by_profile'] ?? "",
      attachments: (json['attachments'] as List<dynamic>? ?? [])
          .map((e) => Attachment.fromJson(e))
          .toList(),
    );
  }

}
