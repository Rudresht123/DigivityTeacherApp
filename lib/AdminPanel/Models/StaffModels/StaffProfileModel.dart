class StaffProfileModel {
  final int staffId;
  final String joiningDate;
  final String staffNo;
  final String? dateOfRetire;
  final String? dateOfExtend;
  final String professionType;
  final String? staffType;
  final String? department;
  final String? designation;
  final String? showInTransport;
  final String? transport;
  final String? hostel;
  final String? shift;
  final String? integrate;
  final String title;
  final String firstName;
  final String middleName;
  final String? lastName;
  final String gender;
  final String? bloodGroup;
  final String dob;
  final String? doa;
  final String? nationality;
  final String? religion;
  final String? category;
  final String? aadhaarNo;
  final String? panNo;
  final String? licenseNo;
  final String? passportNo;
  final String contactNo;
  final String? altMobileNo;
  final String? email;
  final String fatherName;
  final String? motherName;
  final String? spouseName;
  final String? residenceAddress;
  final String? permanentAddress;
  final String? accountNumber;
  final String? ifscCode;
  final String? bankName;
  final String? bankLocation;
  final String? nomineeName;
  final String? nomineeRelation;
  final String profile;
  final String? classTeacher;
  final String? attendance;

  StaffProfileModel({
    required this.staffId,
    required this.joiningDate,
    required this.staffNo,
    this.dateOfRetire,
    this.dateOfExtend,
    required this.professionType,
    required this.staffType,
    required this.department,
    required this.designation,
    this.showInTransport,
    this.transport,
    this.hostel,
    this.shift,
    this.integrate,
    required this.title,
    required this.firstName,
    required this.middleName,
    this.lastName,
    required this.gender,
    this.bloodGroup,
    required this.dob,
    this.doa,
    this.nationality,
    this.religion,
    this.category,
    this.aadhaarNo,
    this.panNo,
    this.licenseNo,
    this.passportNo,
    required this.contactNo,
    this.altMobileNo,
    this.email,
    required this.fatherName,
    this.motherName,
    this.spouseName,
    this.residenceAddress,
    this.permanentAddress,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.bankLocation,
    this.nomineeName,
    this.nomineeRelation,
    required this.profile,
    this.classTeacher,
    this.attendance,
  });

  factory StaffProfileModel.fromJson(Map<String, dynamic> json) {
    return StaffProfileModel(
      staffId: json['staff_id'] ?? 0,
      joiningDate: json['joining_date'] ?? '',
      staffNo: json['staff_no'] ?? '',
      dateOfRetire: json['date_of_retire'],
      dateOfExtend: json['date_of_extend'],
      professionType: json['profession_type'] ?? '',
      staffType: json['staff_type'],
      department: json['department'],
      designation: json['designation'],
      showInTransport: json['show_in_transpor'],
      transport: json['transport'],
      hostel: json['hostel'],
      shift: json['shift'],
      integrate: json['integrate'],
      title: json['title'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'],
      gender: json['gender'] ?? '',
      bloodGroup: json['blood_group'],
      dob: json['dob'] ?? '',
      doa: json['doa'],
      nationality: json['nationality'],
      religion: json['religion'],
      category: json['category'],
      aadhaarNo: json['aadhaar_no'],
      panNo: json['pan_no'],
      licenseNo: json['license_no'],
      passportNo: json['passport_no'],
      contactNo: json['contact_no'] ?? '',
      altMobileNo: json['alt_mobile_no'],
      email: json['email'],
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'],
      spouseName: json['spouse_name'],
      residenceAddress: json['residence_address'],
      permanentAddress: json['permanent_address'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
      bankLocation: json['bank_location'],
      nomineeName: json['nominee_name'],
      nomineeRelation: json['nominee_relation'],
      profile: json['profile'] ?? '',
      classTeacher: json['class_teacher'],
      attendance: json['attendance'],
    );
  }

  @override
  String toString() {
    return 'StaffProfileModel(staffId: $staffId, name: $title $firstName $middleName $lastName, contact: $contactNo, profession: $professionType)';
  }
}
