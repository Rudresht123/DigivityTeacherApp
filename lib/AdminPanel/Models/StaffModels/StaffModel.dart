class StaffModel {
  final int dbId;
  final String joiningDate;
  final String staffNo;
  final String profession;
  final String staffType;
  final String department;
  final String designation;
  final String firstName;
  final String fullName;
  final String fatherName;
  final String? spouseName;
  final String contactNo;
  final String? email;
  final String address;
  final String profileImg;
  final String retireDate;
  final int professionTypeId;
  final int staffTypeId;
  final int departmentId;
  final int designationId;
  final String title;
  final String gender;
  final String dob;
  final String? aadharNo;
  final String? panNo;
  final String maritalStatus;
  final String? accountNo;
  final String? ifscCode;
  final String? bankName;
  final int? status;

  StaffModel({
    required this.dbId,
    required this.joiningDate,
    required this.staffNo,
    required this.profession,
    required this.staffType,
    required this.department,
    required this.designation,
    required this.firstName,
    required this.fullName,
    required this.fatherName,
    this.spouseName,
    required this.contactNo,
    this.email,
    required this.address,
    required this.profileImg,
    required this.retireDate,
    required this.professionTypeId,
    required this.staffTypeId,
    required this.departmentId,
    required this.designationId,
    required this.title,
    required this.gender,
    required this.dob,
    this.aadharNo,
    this.panNo,
    required this.maritalStatus,
    this.accountNo,
    this.ifscCode,
    this.bankName,
    this.status
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      dbId: json['db_id'],
      joiningDate: json['joining_date'],
      staffNo: json['staff_no'],
      profession: json['profession'],
      staffType: json['staff_type'],
      department: json['department'],
      designation: json['designation'],
      firstName: json['first_name'],
      fullName: json['full_name'],
      fatherName: json['father_name'],
      spouseName: json['spouse_name'],
      contactNo: json['contact_no'],
      email: json['email'],
      address: json['address'],
      profileImg: json['profile_img'],
      retireDate: json['retire_date'],
      professionTypeId: json['profession_type_id'],
      staffTypeId: json['staff_type_id'],
      departmentId: json['department_id'],
      designationId: json['designation_id'],
      title: json['title'],
      gender: json['gender'],
      dob: json['dob'],
      aadharNo: json['aadhar_no'],
      panNo: json['pan_no'],
      maritalStatus: json['marital_status'],
      accountNo: json['account_no'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
        status:json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'db_id': dbId,
      'joining_date': joiningDate,
      'staff_no': staffNo,
      'profession': profession,
      'staff_type': staffType,
      'department': department,
      'designation': designation,
      'first_name': firstName,
      'full_name': fullName,
      'father_name': fatherName,
      'spouse_name': spouseName,
      'contact_no': contactNo,
      'email': email,
      'address': address,
      'profile_img': profileImg,
      'retire_date': retireDate,
      'profession_type_id': professionTypeId,
      'staff_type_id': staffTypeId,
      'department_id': departmentId,
      'designation_id': designationId,
      'title': title,
      'gender': gender,
      'dob': dob,
      'aadhar_no': aadharNo,
      'pan_no': panNo,
      'marital_status': maritalStatus,
      'account_no': accountNo,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'status':status
    };
  }

  @override
  String toString() {
    return 'StaffModel(dbId: $dbId, name: $fullName, contact: $contactNo, designation: $designation, department: $department, profileImg: $profileImg,status:$status)';
  }
}
