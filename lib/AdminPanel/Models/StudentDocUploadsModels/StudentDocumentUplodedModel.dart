class StudentDocumentUplodedModel {
  final int dbId;
  final int studentId;
  final String? srNo;
  final String admissionDate;
  final String admissionNo;
  final String studentName;
  final String gender;
  final int courseId;
  final int sectionId;
  final String course;
  final String dob;
  final String fatherName;
  final String contactNo;
  final String? motherName;
  final String studentStatus;
  final String profileImg;
  final int totalDoc;
  final int totalUploadedDoc;

  StudentDocumentUplodedModel({
    required this.dbId,
    required this.studentId,
    this.srNo,
    required this.admissionDate,
    required this.admissionNo,
    required this.studentName,
    required this.gender,
    required this.courseId,
    required this.sectionId,
    required this.course,
    required this.dob,
    required this.fatherName,
    required this.contactNo,
    this.motherName,
    required this.studentStatus,
    required this.profileImg,
    required this.totalDoc,
    required this.totalUploadedDoc,
  });

  factory StudentDocumentUplodedModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentUplodedModel(
      dbId: json['db_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      srNo: json['sr_no'],
      admissionDate: json['admission_date'] ?? '',
      admissionNo: json['admission_no'] ?? '',
      studentName: json['student_name'] ?? '',
      gender: json['gender'] ?? '',
      courseId: json['course_id'] ?? 0,
      sectionId: json['section_id'] ?? 0,
      course: json['course'] ?? '',
      dob: json['dob'] ?? '',
      fatherName: json['father_name'] ?? '',
      contactNo: json['contact_no'] ?? '',
      motherName: json['mother_name'],
      studentStatus: json['student_status'] ?? '',
      profileImg: json['profile_img'] ?? '',
      totalDoc: json['total_doc'] ?? 0,
      totalUploadedDoc: json['total_uploaded_doc'] ?? 0,
    );
  }
}
