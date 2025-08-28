class UserProfile {
  final String name;
  final String role;
  final String gender;
  final String? dob;
  final String? contact_no;
  final String? email;
  final String? tow_factor_auth;
  final String? academicyear;
  final String? lastlogin;
  final String? profile_image;

  UserProfile({
    required this.name,
    required this.role,
    required this.gender,
    this.dob,
    this.contact_no,
    this.email,
    this.tow_factor_auth,
    this.academicyear,
    this.lastlogin,
    this.profile_image,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['user_name'] ?? '',
      role: json['user_info'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'],
      contact_no: json['contact_no'],
      email: json['email'],
      tow_factor_auth: json['two_factor_auth'],
      academicyear: json['academic_session'],
      lastlogin: json['last_login'],
      profile_image: json['profile_img'],
    );
  }
}
