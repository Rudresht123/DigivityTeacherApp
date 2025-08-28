import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/NoticeModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class Noticehelper{
  int? userId;
  String? token;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id') ?? '';
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<NoticeModel>> getCreatedNotice(Map<String, dynamic>? bodydata) async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/teacher/$userId/NoticeReport';

      final response = await getApiService.postRequestData(
          url, token!, bodydata!);
      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => NoticeModel.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }
  Future<Map<String, dynamic>> deleteNotice(noticeId) async {
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