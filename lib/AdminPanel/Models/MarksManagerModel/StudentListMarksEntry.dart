class StudentListMarksEntry {
  final int dbId;
  final int studentId;
  final String? admissionNo;
  final int? rollNo;
  final String studentName;
  final String gender;
  final String fatherName;
  final String contactNo;
  final String motherName;
  final String profileImg;
  final String marks;
  String attendStatus;
  final String markingType;

  StudentListMarksEntry({
    required this.dbId,
    required this.studentId,
    required this.admissionNo,
    this.rollNo,
    required this.studentName,
    required this.gender,
    required this.fatherName,
    required this.contactNo,
    required this.motherName,
    required this.profileImg,
    required this.marks,
    required this.attendStatus,
    required this.markingType,
  });

  factory StudentListMarksEntry.fromJson(Map<String, dynamic> json) {
    return StudentListMarksEntry(
      dbId: json['db_id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      admissionNo: json['admission_no'] ?? '',
      rollNo: json['roll_no'] ?? 0,
      studentName: json['student_name'] ?? '',
      gender: json['gender'] ?? '',
      fatherName: json['father_name'] ?? '',
      contactNo: json['contact_no'] ?? '',
      motherName: json['mother_name'] ?? '',
      profileImg: json['profile_img'] ?? '',
      marks: json['marks'] ?? '',
      attendStatus: json['attend_status'] ?? '',
      markingType: json['marking_type'] ?? '',
    );
  }
}
