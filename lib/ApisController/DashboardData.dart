
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class DashboardData {
  DashboardData();

  Future<Map<String, dynamic>?> getFilteredData(String filterKey) async {
    try {
      final userId = await SharedPrefHelper.getPreferenceValue('user_id');
      final token = await SharedPrefHelper.getPreferenceValue('access_token');
      final url = "api/MobileApp/master-admin/$userId/home";

      final response = await getApiService.getRequestData(url, token);

      // Check if key exists safely
      if (response != null &&
          response['success'] != null &&
          response['success'] is List &&
          response['success'].isNotEmpty &&
          response['success'][0] is Map &&
          response['success'][0].containsKey(filterKey)) {

        final filteredData = response['success'][0][filterKey];

        if (filteredData is List && filteredData.isNotEmpty) {
          return Map<String, dynamic>.from(filteredData[0]);
        } else if (filteredData is Map<String, dynamic>) {
          return filteredData; // direct Map
        }

      }

      return null;

    } catch (e) {
      print("Error in getFilteredData: $e");
      return null;
    }
  }
}
