class UserInfo {
  final int userNo;
  final String userName;
  final String userInfo;
  final String profileImg;
  final String lastLogin;
  final String todayAttendance;

  UserInfo({
    required this.userNo,
    required this.userName,
    required this.userInfo,
    required this.profileImg,
    required this.lastLogin,
    required this.todayAttendance,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
        userNo: json['user_no'] ?? 0,
        userName: json['user_name'] ?? "",
        userInfo: json['user-info'],
        profileImg: json['profile_img'] ?? "",
        lastLogin: json['last_login'] ?? "",
        todayAttendance: json['today_attendance'] ?? ""
    );
  }

}
