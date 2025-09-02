import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentBirthdayReportModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentBirthdayReport {
  int? userId;
  String? token;
  dynamic response;

  StudentBirthdayReport();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Get The Student Birthday Data
  Future<List<StudentBirthdayReportModel>> getStudentBirthdayData(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null && token == null) {
      await init();
    }

    final String url = "api/MobileApp/teacher/$userId/StudentBirthdayList";
    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );
      if (response['result'] == 1 && response['success'] is List) {
        return (response['success'] as List)
            .map((e) => StudentBirthdayReportModel.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Bug Occured During The Fetch Data ${e}");
      return [];
    }
  }
}
