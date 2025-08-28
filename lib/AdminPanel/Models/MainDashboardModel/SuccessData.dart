import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/CourseData.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/DataInfo.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/ModuleData.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/UserInfo.dart';

class SuccessData {
  final List<UserInfo> userInfo;
  final List<DataInfo> dataInfo;
  final List<ModuleData> module;
  final List<CourseData> course;
  final String? website;
  final String academicSession;
  final String lastLoginAt;

  SuccessData({
    required this.userInfo,
    required this.dataInfo,
    required this.module,
    required this.course,
    required this.website,
    required this.academicSession,
    required this.lastLoginAt,
  });

  factory SuccessData.fromJson(Map<String, dynamic> json) {
    return SuccessData(
      userInfo: (json['user-info'] as List<dynamic>)
          .map((e) => UserInfo.fromJson(e))
          .toList(),
      dataInfo: (json['data-info'] as List)
          .map((e) => DataInfo.fromJson(e))
          .toList(),
      module: (json['module'] as List)
          .map((e) => ModuleData.fromJson(e))
          .toList(),
      course: (json['course'] as List)
          .map((e) => CourseData.fromJson(e))
          .toList(),
      website: json['website'],
      academicSession: json['academic_session'],
      lastLoginAt: json['last_login_at'],
    );
  }
}
