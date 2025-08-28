class StudentUpdateDataModel {
  final int studentId;
  final String admissionNo;
  final String? formNo;
  final String? caste;
  final String courseId;
  final int? transportId;
  final String admissionDate;
  final String firstName;
  final String gender;
  final String dob;
  final String contactNo;
  final String? altContactNo;
  final String fatherName;
  final String motherName;
  final String residenceAddress;
  final String? bloodGroup;
  final int? houseId;
  final int? admissionTypeId;
  final int? categoryId;

  StudentUpdateDataModel({
    required this.studentId,
    required this.admissionNo,
    this.formNo,
    this.caste,
    required this.courseId,
    this.transportId,
    required this.admissionDate,
    required this.firstName,
    required this.gender,
    required this.dob,
    required this.contactNo,
    this.altContactNo,
    required this.fatherName,
    required this.motherName,
    required this.residenceAddress,
    this.bloodGroup,
    this.houseId,
    this.admissionTypeId,
    this.categoryId,
  });

  factory StudentUpdateDataModel.fromJson(Map<String, dynamic> json) {
    return StudentUpdateDataModel(
      studentId: json['student_id'],
      admissionNo: json['admission_no'],
      formNo: json['form_no'],
      caste: json['caste'],
      courseId: json['course_id'],
      transportId: json['transport_id'],
      admissionDate: json['admission_date'],
      firstName: json['first_name'],
      gender: json['gender'],
      dob: json['dob'],
      contactNo: json['contact_no'],
      altContactNo: json['alt_contact_no'],
      fatherName: json['father_name'],
      motherName: json['mother_name'],
      residenceAddress: json['residence_address'],
      bloodGroup: json['blood_group'],
      houseId: json['house_id'],
      admissionTypeId: json['admission_type_id'],
      categoryId: json['caregory_id'], // Note: "caregory_id" seems to be a typo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'admission_no': admissionNo,
      'form_no': formNo,
      'caste': caste,
      'course_id': courseId,
      'transport_id': transportId,
      'admission_date': admissionDate,
      'first_name': firstName,
      'gender': gender,
      'dob': dob,
      'contact_no': contactNo,
      'alt_contact_no': altContactNo,
      'father_name': fatherName,
      'mother_name': motherName,
      'residence_address': residenceAddress,
      'blood_group': bloodGroup,
      'house_id': houseId,
      'admission_type_id': admissionTypeId,
      'caregory_id': categoryId,
    };
  }

  @override
  String toString() {
    return 'StudentUpdateDataModel(studentId: $studentId, admissionNo: $admissionNo, formNo: $formNo, caste: $caste, courseId: $courseId, transportId: $transportId, admissionDate: $admissionDate, firstName: $firstName, gender: $gender, dob: $dob, contactNo: $contactNo, altContactNo: $altContactNo, fatherName: $fatherName, motherName: $motherName, residenceAddress: $residenceAddress, bloodGroup: $bloodGroup, houseId: $houseId, admissionTypeId: $admissionTypeId, categoryId: $categoryId)';
  }
}
