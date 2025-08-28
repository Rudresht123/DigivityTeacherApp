import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentProfileModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentUpdateDataModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentApis {
  int? userId;
  String? token;
  dynamic response;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<Map<String, dynamic>> submitStudentData(
      Map<String, dynamic> studentData) async {
    try {
      final userId = await SharedPrefHelper.getPreferenceValue('user_id');
      final token = await SharedPrefHelper.getPreferenceValue('access_token');
      final url = "api/MobileApp/master-admin/$userId/StoreStudent";

      final data = await getApiService.postRequestData(url, token, studentData);

      return data ?? {'status': false, 'message': 'Something went wrong'};
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }
  }


  Future<Studentprofilemodel> studentProfile(String studentId) async {
    if (userId == null || token == null) {
      await init();
    }
    final url = "api/MobileApp/master-admin/$userId/$studentId/StudentProfile";
    final response = await getApiService.getRequestData(url, token!);
    if (response != null &&
        response['success'] != null &&
        response['success'] is List &&
        response['success'].isNotEmpty) {
      final data = Studentprofilemodel.fromJson(response['success'][0]);
      return data;
    } else {
      throw Exception("Failed to fetch student profile.");
    }
  }

  Future<StudentUpdateDataModel> getStudentUpdateData(String? studentId) async {
    if (userId == null || token == null) {
      await init();
    }
    final url = "api/MobileApp/master-admin/$userId/$studentId/StudentUpdateProfile";
    final response = await getApiService.getRequestData(url, token!);
    if (response != null && response['success'] != null &&
        response['success'] is List) {
      final data = response['success'][0];
      return StudentUpdateDataModel.fromJson(data);
    } else {
      throw Exception('Failed to load student profile');
    }
  }


  Future<Map<String, dynamic>> updateStudentRecord(String? studentId,
      Map<String, dynamic> formData) async {
    try {
      if (userId == null || token == null) {
        await init(); // Ensure userId and token are initialized
      }

      final url = "api/MobileApp/master-admin/$userId/$studentId/EditStudent";
      final response = await getApiService.postRequestData(
          url, token!, formData);

      return response ?? {'status': false, 'message': 'Something went wrong'};
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }
  }

}
