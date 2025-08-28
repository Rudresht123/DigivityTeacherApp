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

      final modules = response['success'][0]['module'][0]; // direct map access

      final quickActions = List<Map<String, dynamic>>.from(modules['quick-action'] ?? []);
      final reports = List<Map<String, dynamic>>.from(modules['important-links'] ?? []);
      final aboutschools = List<Map<String, dynamic>>.from(modules['about-school'] ?? []);

      return {
        'quickActions': quickActions,
        'reports': reports,
        'aboutschools': aboutschools,
      };
    }

    return {
      'quickActions': [],
      'reports': [],
      'aboutschools': [],
    };
  }

}
