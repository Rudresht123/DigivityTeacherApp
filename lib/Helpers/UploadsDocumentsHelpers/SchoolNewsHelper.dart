import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SchoolNewsModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class SchoolNewsHelper {
  int? userId;
  String? token;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id') ?? '';
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<SchoolNewsModel>> getCreateSchoolNews(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    String url = "api/MobileApp/teacher/$userId/SchoolNewsReport";
    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );
      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => SchoolNewsModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Bug Occured During The Fetching the School News ${e}");
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteSchoolNews(noticeId) async {
    try {
      if (userId == null && token == null) {
        await init();
      }

      final url = 'api/MobileApp/teacher/$userId/$noticeId/RemoveNotice';
      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1) {
        return response;
      } else {
        return {
          'result': 0,
          'message': response['message'] ?? 'Unknown error occurred.',
        };
      }
    } catch (e) {
      return {
        'result': 0,
        'message': 'Fetch failed: $e',
      };
    }
  }



}
