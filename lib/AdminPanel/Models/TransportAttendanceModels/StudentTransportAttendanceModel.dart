class StudentTransportAttendanceModel {
  final int studentId;
  final String admissionNo;
  final int? rollNo;
  final String studentName;
  final String course;
  final String gender;
  final String fatherName;
  final String profileImg;
  final String attendance;
  final String holiday;
  final int courseId;
  final String? pcikedUp;
  final String? dropepdOut;
  final int sectionId;

  StudentTransportAttendanceModel({
    required this.studentId,
    required this.admissionNo,
    this.rollNo,
    required this.studentName,
    required this.course,
    required this.gender,
    required this.fatherName,
    required this.profileImg,
    required this.attendance,
    required this.holiday,
    required this.courseId,
    required this.sectionId,
    this.pcikedUp,
    this.dropepdOut,
  });

  factory StudentTransportAttendanceModel.fromJson(Map<String, dynamic> json) {
    return StudentTransportAttendanceModel(
      studentId: json['student_id'],
      admissionNo: json['admission_no'],
      rollNo: json['roll_no'],
      studentName: json['student_name'],
      course: json['course'],
      gender: json['gender'],
      fatherName: json['father_name'],
      profileImg: json['profile_img'],
      attendance: json['attendance'],
      holiday: json['holiday'],
      courseId: json["course_id"],
      sectionId: json['section_id'],
      pcikedUp: json["pickup_time"],
      dropepdOut:json['droped_time']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'admission_no': admissionNo,
      'roll_no': rollNo,
      'student_name': studentName,
      'course': course,
      'gender': gender,
      'father_name': fatherName,
      'profile_img': profileImg,
      'attendance': attendance,
      'holiday': holiday,
      'courseId':courseId,
      'sectionId':sectionId,
      'pcikedUp':pcikedUp,
      'dropepdOut':dropepdOut
    };
  }

  @override
  String toString() {
    return 'StudentAttendanceModel(studentId: $studentId, admissionNo: $admissionNo, '
        'rollNo: $rollNo, studentName: $studentName, course: $course, gender: $gender, '
        'fatherName: $fatherName, profileImg: $profileImg, attendance: $attendance, holiday: $holiday, courseId:$courseId,sectionId:$sectionId)';
  }
}
