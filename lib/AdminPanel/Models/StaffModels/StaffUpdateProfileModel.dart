class StaffUpdateProfileModel {
  final String? empNo;
  final int staffId;
  final String joiningDate;
  final String staffNo;
  final String? dateOfRetire;
  final String? dateOfExtend;
  final int professionTypeId;
  final int staffTypeId;
  final int departmentId;
  final int designationId;
  final String title;
  final String firstName;
  final String gender;
  final String? bloodGroup;
  final String dob;
  final String? doa;
  final String? aadhaarNo;
  final String contactNo;
  final String? altMobileNo;
  final String? panNo;
  final String? email;
  final String fatherName;
  final String? spouseName;
  final String? residenceAddress;
  final String? accountNumber;
  final String? ifscCode;
  final String? bankName;
  final String maritalStatus;

  StaffUpdateProfileModel({
    this.empNo,
    required this.staffId,
    required this.joiningDate,
    required this.staffNo,
    this.dateOfRetire,
    this.dateOfExtend,
    required this.professionTypeId,
    required this.staffTypeId,
    required this.departmentId,
    required this.designationId,
    required this.title,
    required this.firstName,
    required this.gender,
    this.bloodGroup,
    required this.dob,
    this.doa,
    this.aadhaarNo,
    required this.contactNo,
    this.altMobileNo,
    this.panNo,
    this.email,
    required this.fatherName,
    this.spouseName,
    this.residenceAddress,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    required this.maritalStatus,
  });

  factory StaffUpdateProfileModel.fromJson(Map<String, dynamic> json) {
    return StaffUpdateProfileModel(
      empNo: json['emp_no'],
      staffId: json['staff_id'] ?? 0,
      joiningDate: json['joining_date'] ?? '',
      staffNo: json['staff_no'] ?? '',
      dateOfRetire: json['date_of_retire'],
      dateOfExtend: json['date_of_extend'],
      professionTypeId: json['profession_type_id'] ?? 0,
      staffTypeId: json['staff_type_id'] ?? 0,
      departmentId: json['department_id'] ?? 0,
      designationId: json['designation_id'] ?? 0,
      title: json['title'] ?? '',
      firstName: json['first_name'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['blood_group'],
      dob: json['dob'] ?? '',
      doa: json['doa'],
      aadhaarNo: json['aadhaar_no'],
      contactNo: json['contact_no'] ?? '',
      altMobileNo: json['alt_mobile_no'],
      panNo: json['pan_no'],
      email: json['email'],
      fatherName: json['father_name'] ?? '',
      spouseName: json['spouse_name'],
      residenceAddress: json['residence_address'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
      maritalStatus: json['marital_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emp_no': empNo,
      'staff_id': staffId,
      'joining_date': joiningDate,
      'staff_no': staffNo,
      'date_of_retire': dateOfRetire,
      'date_of_extend': dateOfExtend,
      'profession_type_id': professionTypeId,
      'staff_type_id': staffTypeId,
      'department_id': departmentId,
      'designation_id': designationId,
      'title': title,
      'first_name': firstName,
      'gender': gender,
      'blood_group': bloodGroup,
      'dob': dob,
      'doa': doa,
      'aadhaar_no': aadhaarNo,
      'contact_no': contactNo,
      'alt_mobile_no': altMobileNo,
      'pan_no': panNo,
      'email': email,
      'father_name': fatherName,
      'spouse_name': spouseName,
      'residence_address': residenceAddress,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'marital_status': maritalStatus,
    };
  }
}
