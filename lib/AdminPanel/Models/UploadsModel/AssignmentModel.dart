class AssignmentModel {
  final int assignmentId;
  final String type;
  final String course;
  final String? student;
  final String subject;
  final String? submitStaff;
  final String assignmentDate;
  final String assignedDate;
  final String submittedDate;
  final String assignmentTitle;
  final String assignment;
  final String? showDateTime;
  final String? endDateTime;
  final String withApp;
  final String withTextSms;
  final String withEmail;
  final String withWebsite;
  final String status;
  final String submittedBy;
  final String submittedByProfile;
  final List<Attachment> attachment;

  AssignmentModel({
    required this.assignmentId,
    required this.type,
    required this.course,
    this.student,
    required this.subject,
    this.submitStaff,
    required this.assignmentDate,
    required this.assignedDate,
    required this.submittedDate,
    required this.assignmentTitle,
    required this.assignment,
    this.showDateTime,
    this.endDateTime,
    required this.withApp,
    required this.withTextSms,
    required this.withEmail,
    required this.withWebsite,
    required this.status,
    required this.submittedBy,
    required this.submittedByProfile,
    required this.attachment,
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      assignmentId: json['assignment_id'],
      type: json['type'],
      course: json['course'],
      student: json['student'],
      subject: json['subject'],
      submitStaff: json['submit_staff'],
      assignmentDate: json['assignment_date'],
      assignedDate: json['assigned_date'],
      submittedDate: json['submitted_date'],
      assignmentTitle: json['assignment_title'],
      assignment: json['assignment'],
      showDateTime: json['show_date_time'],
      endDateTime: json['end_date_time'],
      withApp: json['with_app'],
      withTextSms: json['with_text_sms'],
      withEmail: json['with_email'],
      withWebsite: json['with_website'],
      status: json['status'],
      submittedBy: json['submitted_by'],
      submittedByProfile: json['submitted_by_profile'],
      attachment: (json['attachment'] as List)
          .map((e) => Attachment.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Assignment(assignmentId: $assignmentId, type: $type, course: $course, subject: $subject, title: $assignmentTitle, attachment: $attachment)';
  }
}


class Attachment {
  final String fileName;
  final String filePath;
  final String extension;

  Attachment({
    required this.fileName,
    required this.filePath,
    required this.extension,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      fileName: json['file_name'],
      filePath: json['file_path'],
      extension: json['extension'],
    );
  }

  @override
  String toString() {
    return 'Attachment(fileName: $fileName, filePath: $filePath, extension: $extension)';
  }
}

