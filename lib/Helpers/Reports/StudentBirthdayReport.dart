import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentBirthdayReportModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:digivity_admin_app/Helpers/launchAnyUrl.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentBirthdayReport {
  int? userId;
  String? token;
  String? baseurl;
  dynamic response;

  StudentBirthdayReport();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
    baseurl = await SharedPrefHelper.getPreferenceValue("base_url");
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

  Future<String> openStudentBirthdayCard(String dob, int studentId) async {
    if (userId == null && token == null) {
      await init(); // make sure token is initialized
    }

    try {
      final url = "api/MobileApp/teacher/StudentBirthdayCard/$dob/$studentId/yes";
      final response = await getApiService.getRequestData(url, token!);


      if (response.containsKey('birthday_card')) {
        final imageUrl = response['birthday_card'];
        print("Image URL: $imageUrl");
        return imageUrl;
      } else if (response.containsKey('error')) {
        print("API Error: ${response['error']}");
        return "";
      } else {
        return "";
      }
    } catch (e) {
      print("Error opening URL: $e");
      return "";
    }
  }

}


