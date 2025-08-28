class StudentModel {
  final int? dbId;
  final int? studentId;
  final String? srNo;
  final String? admissionDate;
  final int? academicId;
  final int? financialId;
  final String? admissionNo;
  final int? rollNo;
  final String? studentName;
  final String? gender;
  final int? courseId;
  final int? sectionId;
  final String? course;
  final String? dob;
  final int? categoryId;
  final String? aadharNo;
  final String? fatherName;
  final String? contactNo;
  final String? altContactNo;
  final String? motherName;
  final String? residenceAddress;
  final int? transportId;
  final String? profileImg;
  final String? studentStatus;

  StudentModel({
    this.dbId,
    this.studentId,
    this.srNo,
    this.admissionDate,
    this.academicId,
    this.financialId,
    this.admissionNo,
    this.rollNo,
    this.studentName,
    this.gender,
    this.courseId,
    this.sectionId,
    this.course,
    this.dob,
    this.categoryId,
    this.aadharNo,
    this.fatherName,
    this.contactNo,
    this.altContactNo,
    this.motherName,
    this.residenceAddress,
    this.transportId,
    this.profileImg,
    this.studentStatus
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      dbId: json['db_id'],
      studentId: json['student_id'],
      srNo: json['sr_no'],
      admissionDate: json['admission_date'],
      academicId: json['academic_id'],
      financialId: json['financial_id'],
      admissionNo: json['admission_no'],
      rollNo: json['roll_no'],
      studentName: json['student_name'],
      gender: json['gender'],
      courseId: json['course_id'],
      sectionId: json['section_id'],
      course: json['course'],
      dob: json['dob'],
      categoryId: json['category_id'],
      aadharNo: json['aadhar_no'],
      fatherName: json['father_name'],
      contactNo: json['contact_no'],
      altContactNo: json['alt_contact_no'],
      motherName: json['mother_name'],
      residenceAddress: json['residence_address'],
      transportId: json['transport_id'],
      profileImg: json['profile_img'],
        studentStatus:json['status']
    );
  }

  @override
  String toString() {
    return 'StudentModel(dbId: $dbId, studentId: $studentId, srNo: $srNo, admissionDate: $admissionDate, academicId: $academicId, financialId: $financialId, admissionNo: $admissionNo, rollNo: $rollNo, studentName: $studentName, gender: $gender, courseId: $courseId, sectionId: $sectionId, course: $course, dob: $dob, categoryId: $categoryId, aadharNo: $aadharNo, fatherName: $fatherName, contactNo: $contactNo, altContactNo: $altContactNo, motherName: $motherName, residenceAddress: $residenceAddress, transportId: $transportId, profileImg: $profileImg,studentStatus:$studentStatus)';
  }
}
