import 'dart:convert';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class UserPermissions {
  UserPermissions();

  Future<Map<String, List<Map<String, dynamic>>>> getPermissions() async {
    final userId = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');

    final url = "api/MobileApp/teacher/$userId/home";

    final response = await getApiService.getRequestData(url, token);

    if (response != null &&
        response['success'] != null &&
        response['success'].isNotEmpty &&
        response['success'][0]['module'] != null) {
      final modules = response['success'][0]['module'];


      final quickActions = modules.isNotEmpty && modules[0]['quick-action'] != null
          ? List<Map<String, dynamic>>.from(modules[0]['quick-action'])
          : <Map<String, dynamic>>[];

      final reports = modules.isNotEmpty && modules[0]['important-links'] != null
          ? List<Map<String, dynamic>>.from(modules[0]['important-links'])
          : <Map<String, dynamic>>[];

      final aboutSchools = modules.isNotEmpty && modules[0]['about-school'] != null
          ? List<Map<String, dynamic>>.from(modules[0]['about-school'])
          : <Map<String, dynamic>>[];

      return {
        'quickActions': quickActions,
        'reports': reports,
        'aboutschools': aboutSchools,
      };
    }

    return {
      'quickActions': [],
      'reports': [],
      'aboutschools': [],
    };
  }
}
