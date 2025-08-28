class Studentprofilemodel {
  final int? dbId;
  final String? studentId;
  final String? admissionNo;
  final String? admissionDate;
  final String? course;
  final String? fullName;
  final String? gender;
  final String? dob;
  final String? bloodGroup;
  final String? nationality;
  final String? religion;
  final String? category;
  final String? caste;
  final String? aadharCardNo;
  final String? birthCertificateNo;
  final String? contactNo;
  final String? email;
  final String? fatherName;
  final String? fatherMobileNo;
  final String? motherName;
  final String? motherMobileNo;
  final String? localGuardianRelation;
  final String? localGuardianName;
  final String? residenceAddress;
  final String? permanentAddress;
  final String? profile;
  final String? academicSession;
  Studentprofilemodel({
    this.dbId,
    this.studentId,
    this.admissionNo,
    this.admissionDate,
    this.course,
    this.fullName,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.nationality,
    this.religion,
    this.category,
    this.caste,
    this.aadharCardNo,
    this.birthCertificateNo,
    this.contactNo,
    this.email,
    this.fatherName,
    this.fatherMobileNo,
    this.motherName,
    this.motherMobileNo,
    this.localGuardianRelation,
    this.localGuardianName,
    this.residenceAddress,
    this.permanentAddress,
    this.profile,
    this.academicSession,
  });

  factory Studentprofilemodel.fromJson(Map<String, dynamic> json) {
    return Studentprofilemodel(
      dbId: json['db_id'],
      studentId: json['student_id'],
      admissionNo: json['admission_no'],
      admissionDate: json['admission_date'],
      course: json['course'],
      fullName: json['full_name'],
      gender: json['gender'],
      dob: json['dob'],
      bloodGroup: json['blood_group'],
      nationality: json['nationality'],
      religion: json['religion'],
      category: json['category'],
      caste: json['caste'],
      aadharCardNo: json['aadhar_card_no'],
      birthCertificateNo: json['birth_certificate_no'],
      contactNo: json['contact_no'],
      email: json['email'],
      fatherName: json['father_name'],
      fatherMobileNo: json['father_mobile_no'],
      motherName: json['mother_name'],
      motherMobileNo: json['mother_mobile_no'],
      localGuardianRelation: json['local_guardian_relation'],
      localGuardianName: json['local_guardian_name'],
      residenceAddress: json['residence_address'],
      permanentAddress: json['permanent_address'],
      profile: json['profile'],
      academicSession: json['academicSession'],
    );
  }

  @override
  @override
  String toString() {
    return 'Studentprofilemodel('
        'dbId: $dbId, '
        'studentId: $studentId, '
        'admissionNo: $admissionNo, '
        'admissionDate: $admissionDate, '
        'course: $course, '
        'fullName: $fullName, '
        'gender: $gender, '
        'dob: $dob, '
        'bloodGroup: $bloodGroup, '
        'nationality: $nationality, '
        'religion: $religion, '
        'category: $category, '
        'caste: $caste, '
        'aadharCardNo: $aadharCardNo, '
        'birthCertificateNo: $birthCertificateNo, '
        'contactNo: $contactNo, '
        'email: $email, '
        'fatherName: $fatherName, '
        'fatherMobileNo: $fatherMobileNo, '
        'motherName: $motherName, '
        'motherMobileNo: $motherMobileNo, '
        'localGuardianRelation: $localGuardianRelation, '
        'localGuardianName: $localGuardianName, '
        'residenceAddress: $residenceAddress, '
        'permanentAddress: $permanentAddress, '
        'profile: $profile, '
        'academicSession: $academicSession'
        ')';
  }

}
