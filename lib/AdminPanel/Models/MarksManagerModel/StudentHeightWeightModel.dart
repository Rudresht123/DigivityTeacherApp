class StudentHeightWeightModel {
  final int dbId;
  final int? studentId;
  final String? admissionNo;
  final int? rollNo;
  final String studentName;
  final String gender;
  final String fatherName;
  final String? contactNo;
  final String? motherName;
  final String? profileImg;
  final String? height;
  final String? weight;

  StudentHeightWeightModel({
    required this.dbId,
    required this.studentId,
    this.admissionNo,
    this.rollNo,
    required this.studentName,
    required this.gender,
    required this.fatherName,
    this.contactNo,
    this.motherName,
    this.profileImg,
    this.height,
    this.weight
  });

  factory StudentHeightWeightModel.fromJson(Map<String, dynamic> json) {
    return StudentHeightWeightModel(
      dbId: json['db_id'] ?? 0,
      studentId: json['student_id'],
      admissionNo: json['admission_no'],
      rollNo: json['roll_no'] ?? 0, // nullable
      studentName: json['student_name'] ?? '',
      gender: json['gender'] ?? '',
      fatherName: json['father_name'] ?? '',
      contactNo: json['contact_no'],
      motherName: json['mother_name'],
      profileImg: json['profile_img'],
      height: json['height'],
      weight: json['weight']
    );
  }
}
