import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/SyllabusModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/UploadsModel/HomeworkModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class SyllabusHelper{
  int? userId;
  String? token;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id') ?? '';
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<SyllabusModel>> getCreatedSyllabuss(Map<String, dynamic>? bodydata) async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/teacher/$userId/SyllabusReport';

      final response = await getApiService.postRequestData(
          url, token!, bodydata!);
      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => SyllabusModel.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteSyllabus(syllabusId) async {
    try {
      if (userId == null && token == null) {
        await init();
      }

      final url = 'api/MobileApp/teacher/$userId/$syllabusId/RemoveSyllabus';
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