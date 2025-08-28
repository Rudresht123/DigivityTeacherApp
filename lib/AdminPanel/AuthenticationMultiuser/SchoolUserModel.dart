class SchoolUserModel {
  String schoolName;
  String baseUrl;
  String authToken;
  String schoolCode;
  bool isActive;

  SchoolUserModel({
    required this.schoolName,
    required this.baseUrl,
    required this.authToken,
    required this.schoolCode,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'schoolName': schoolName,
    'baseUrl': baseUrl,
    'authToken': authToken,
    'schoolCode': schoolCode,
    'isActive': isActive,
  };

  factory SchoolUserModel.fromJson(Map<String, dynamic> json) => SchoolUserModel(
    schoolName: json['schoolName'],
    baseUrl: json['baseUrl'],
    authToken: json['authToken'],
    schoolCode: json['schoolCode'],
    isActive: json['isActive'],
  );
}
