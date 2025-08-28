import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class AttendanceReportsHelperFunctions {
  int? userId;
  String? token;
  dynamic response;

  AttendanceReportsHelperFunctions();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }


  Future<String?> apiAttendanceReport(String reportName, Map<String, dynamic> formData) async {
    if (userId == null || token == null) {
      await init();
    }

    // Map of report names to endpoint suffixes
    final reportEndpoints = {
      'staff-attendance-report': 'StaffAttendanceReport',
    };

    final endpoint = reportEndpoints[reportName];
    if (endpoint == null) return null;

    final url = "api/MobileApp/master-admin/$userId/$endpoint";

    final response = await getApiService.postRequestData(url, token!, formData);

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'].isNotEmpty &&
        response['success'][0]['data'] != null) {
      return response['success'][0]['data'];
    }

    return null;
  }

}


