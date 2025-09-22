class UserProfileModel {
  final String? joining_date;
  final String name;
  final String role;
  final String gender;
  final String? dob;
  final String? contact_no;
  final String? alt_contact_no;
  final String? email;
  final String? tow_factor_auth;
  final String? academicyear;
  final String? lastlogin;
  final String profile_image;
  final String? residence_address;
  final String? permanent_address;
  final String? academic_session;
  UserProfileModel({
    this.joining_date,
    required this.name,
    required this.role,
    required this.gender,
    this.dob,
    this.contact_no,
    this.email,
    this.tow_factor_auth,
    this.academicyear,
    this.lastlogin,
    this.alt_contact_no,
    required this.profile_image,
    this.permanent_address,
    this.residence_address,
    this.academic_session
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      joining_date: json['joining_date'] ?? "",
      name: (json['first_name'] ?? '') + ' ' + (json['middle_name'] ?? '') + ' ' + (json['last_name'] ?? '')?? "",
      role: json['department'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? "",
      contact_no: json['contact_no'] ?? "",
      alt_contact_no:json['alt_mobile_no'] ?? "",
      email: json['email'] ?? "",
      tow_factor_auth: json['two_factor_auth'] ?? "",
      academicyear: json['academic_session'] ?? "",
      lastlogin: json['last_login'] ?? "",
      profile_image: json['profile'] ?? "",
      residence_address: json['residence_address'] ?? "",
      permanent_address: json['permanent_address'] ?? "",
        academic_session:json['academic_session'] ?? ""
    );
  }
}
