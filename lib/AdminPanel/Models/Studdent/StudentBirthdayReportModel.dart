class StudentBirthdayReportModel {
  final int id;
  final int studentId;
  final String admissionNo;
  final String course;
  final String studentName;
  final String? gender;
  final String? fatherName;
  final String? contactNo;
  final String? dob;
  final String? birthdayNo;
  final String profileImage;
  final String? birthdayCard;

  StudentBirthdayReportModel({
    required this.id,
    required this.studentId,
    required this.course,
    required this.studentName,
    required this.gender,
    required this.fatherName,
    required this.contactNo,
    required this.admissionNo,
    required this.dob,
    required this.profileImage,
    required this.birthdayNo,
    this.birthdayCard,
  });

  factory StudentBirthdayReportModel.fromJson(Map<String, dynamic> json) {
    return StudentBirthdayReportModel(
      id: json['id'],
      studentId: json['student_id'],
      course: json['course'],
      studentName: json['student_name'] ?? "",
      gender: json['gender'] ?? "",
      fatherName: json["father_name"] ?? "",
      contactNo: json["contact_no"] ?? "",
      admissionNo: json["admission_no"] ?? "",
      dob: json["dob"] ?? "",
      profileImage: json["profile_image"] ?? "",
      birthdayNo: json["birthday_no"] ?? "",
      birthdayCard:json['birthday_card'] ?? ""
    );
  }
}
