class ComplaintModel {
  final int complaintId;
  final String complaintFor;
  final dynamic courseId; // can be int or string
  final dynamic sectionId; // can be int or string
  final dynamic designationId; // string like "Teacher"
  final dynamic departmentId; // string like "Teacher"
  final dynamic complaintTypeId; // string like "Student Complaint"
  final String complaintType;
  final String complaint;
  final String course;
  final String complaintBy;
  final String complaintTo;
  final String department;
  final String designation;
  final dynamic complaintToStaff; // null sometimes
  final String complaintDate;
  final String withApp;
  final String withTextSms;
  final String withEmail;
  final String withWhatsapp;
  final String status;
  final String submittedBy;
  final String submittedByProfile;

  ComplaintModel({
    required this.complaintId,
    required this.complaintFor,
    required this.courseId,
    required this.sectionId,
    required this.designationId,
    required this.departmentId,
    required this.complaintTypeId,
    required this.complaintType,
    required this.complaint,
    required this.course,
    required this.complaintBy,
    required this.complaintTo,
    required this.department,
    required this.designation,
    required this.complaintToStaff,
    required this.complaintDate,
    required this.withApp,
    required this.withTextSms,
    required this.withEmail,
    required this.withWhatsapp,
    required this.status,
    required this.submittedBy,
    required this.submittedByProfile,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaintId: json['complaint_id'] ?? 0,
      complaintFor: json['complaint_for'] ?? '',
      courseId: json['course_id'],
      sectionId: json['section_id'],
      designationId: json['designation_id'],
      departmentId: json['department_id'],
      complaintTypeId: json['complaint_type_id'],
      complaintType: json['complaint_type'] ?? '',
      complaint: json['complaint'] ?? '',
      course: json['course'] ?? '',
      complaintBy: json['complaint_by'] ?? '',
      complaintTo: json['complaint_to'] ?? '',
      department: json['department'] ?? '',
      designation: json['designation'] ?? '',
      complaintToStaff: json['complaint_to_staff'],
      complaintDate: json['complaint_date'] ?? '',
      withApp: json['with_app'] ?? '',
      withTextSms: json['with_text_sms'] ?? '',
      withEmail: json['with_email'] ?? '',
      withWhatsapp: json['with_whatsapp'] ?? '',
      status: json['status'] ?? '',
      submittedBy: json['submitted_by'] ?? '',
      submittedByProfile: json['submitted_by_profile'] ?? '',
    );
  }
}
