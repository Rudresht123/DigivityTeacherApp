import 'package:digivity_admin_app/AdminPanel/Models/OnlineClassModel/OnlineClasses.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class OnlineClassHelper {
  int? userId;
  String? token;
  dynamic response;
  OnlineClassHelper();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// For getting the user classes
  Future<List<OnlineClasses>> getUserOnlineClasses(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url =
          "api/MobileApp/teacher/$userId/GetTeacherOnlineClassList";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );
      if (response['result'] == 1 && response['success'] is List) {
        final classes = response['success'];
        return (classes as List).map((e) => OnlineClasses.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("${e}");
      return [];
    }
    return [];
  }

  /// Delete Online Classes
  Future<Map<String, dynamic>> deleteCreateClass(int classId) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url =
          "api/MobileApp/teacher/$userId/$classId/RemoveOnlineClassByTeacher";
      final response = await getApiService.getRequestData(url, token!);
      return response;
    } catch (e) {
      print("${e}");
      return {};
    }
  }

  /// Class Create Function
  Future<Map<String, dynamic>> createOnlineClass(
    Map<String, dynamic>? formData,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url =
          "api/MobileApp/teacher/$userId/CreateOnlineClassByMobileApp";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formData!,
      );
      return response;
    } catch (e) {
      return {};
    }
  }


  /// Edit Online Class
  Future<Map<String, dynamic>> editOnlineClass(
      int classId,
      Map<String, dynamic>? formData,
      ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url =
          "api/MobileApp/teacher/$userId/$classId/UpdateOnlineClassByTeacher";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formData!,
      );
      return response;
    } catch (e) {
      return {};
    }
  }


}
