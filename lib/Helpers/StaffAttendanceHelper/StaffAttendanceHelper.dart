import 'package:digivity_admin_app/AdminPanel/Models/StaffAttendanceModel/StaffScheduleTimeList.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StaffAttendanceHelper {
  int? userId;
  int? StaffId;
  String? token;
  dynamic response;
  StaffAttendanceHelper();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    StaffId = await SharedPrefHelper.getPreferenceValue('staff_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// For Getting the Arrival and Departure time of the Staff Attendance
  Future<List<StaffScheduleTimeList>> getStaffArrivalAndDepartureTime() async {
    if (userId == null && token == null && StaffId == null) {
      await init();
    }
    if (userId == null || StaffId == null || token == null) {
      return [];
    }
    try {
      final url =
          "api/MobileApp/teacher/$userId/$StaffId/StaffScheduleTimeList";
      final response = await getApiService.getRequestData(url, token!);

      if (response['success'] != null && response['success'] is List) {
        return (response['success'] as List)
            .map(
              (item) => StaffScheduleTimeList.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("Some Error Occurred While Fetching Data From API: $e");
      return [];
    }
  }

  /// Staff Attendance Store Function
  Future<Map<String, dynamic>> storeStaffAttendance(
    Map<String, dynamic> formData,
  ) async {
    // Ensure userId and token are initialized
    if (userId == null || token == null) {
      await init();
    }
    final String url =
        "api/MobileApp/teacher/$userId/StoreStaffAttendanceRecord";
    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        formData,
      );
      if (response['result'] != null) {
        return response;
      } else {
        print("API returned failure: $response");
        return {};
      }
    } catch (e) {
      print("An error occurred while storing staff attendance: $e");
      return {};
    }
  }
}
