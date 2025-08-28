class StudentRemarkEntry {
  final int dbId;
  final int studentId;
  final String admissionNo;
  final int? rollNo;
  final String studentName;
  final String gender;
  final String fatherName;
  final String contactNo;
  final String? motherName;
  final String profileImg;
  final String? remark;
  final String remarkEntryMode;

  StudentRemarkEntry({
    required this.dbId,
    required this.studentId,
    required this.admissionNo,
    this.rollNo,
    required this.studentName,
    required this.gender,
    required this.fatherName,
    required this.contactNo,
    this.motherName,
    required this.profileImg,
    this.remark,
    required this.remarkEntryMode,
  });

  factory StudentRemarkEntry.fromJson(Map<String, dynamic> json) {
    return StudentRemarkEntry(
      dbId: json['db_id'],
      studentId: json['student_id'],
      admissionNo: json['admission_no'],
      rollNo: json['roll_no'],
      studentName: json['student_name'],
      gender: json['gender'],
      fatherName: json['father_name'],
      contactNo: json['contact_no'],
      motherName: json['mother_name'],
      profileImg: json['profile_img'],
      remark: json['remark'],
      remarkEntryMode: json['remark_entry_mode'],
    );
  }

  @override
  String toString() {
    return 'StudentRemarkEntry(dbId: $dbId, studentId: $studentId, admissionNo: $admissionNo, '
        'rollNo: $rollNo, studentName: $studentName, gender: $gender, '
        'fatherName: $fatherName, contactNo: $contactNo, motherName: $motherName, '
        'profileImg: $profileImg, remark: $remark, remarkEntryMode: $remarkEntryMode)';
  }
}
