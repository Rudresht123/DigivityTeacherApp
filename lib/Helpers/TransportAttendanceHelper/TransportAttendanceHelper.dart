import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/AssignedTransportRouteModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/RouteStopModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/TransportAttendanceModels/StudentTransportAttendanceModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class TransportAttendanceHelper {
  int? staffId;
  int? userId;
  String? token;
  dynamic response;

  TransportAttendanceHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
    staffId = await SharedPrefHelper.getPreferenceValue('staff_id');
  }

  /// Get the assigned users route
  Future<List<AssignedTransportRouteModel>> getAssignedRoute() async {
    if (userId == null || token == null || staffId == null) {
      await init();
    }

    try {
      final String url =
          "api/MobileApp/teacher/$userId/$staffId/getAssignedRoute";

      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1 && response['success'] is List) {
        final List<dynamic> data = response['success'];
        return data
            .map(
              (e) => AssignedTransportRouteModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      return [];
    } catch (e, stackTrace) {
      print("Error in getAssignedRoute: $e");
      print(stackTrace);
      return [];
    }
  }

  /// For getting the Route related Stops
  Future<List<RouteStopModel>> getRouteStop(int stopId) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url = "/api/MobileApp/teacher/$stopId/getRouteStops";
      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1 && response['success'] is List) {
        final List<dynamic> data = response['success'];
        return data.map((e) {
          return RouteStopModel.fromJson(e as Map<String, dynamic>);
        }).toList();
      }
      return [];
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Get Students For The Student Transport Attendance
  Future<List<StudentTransportAttendanceModel>>
  getStudentForTransportAttendance(Map<String, dynamic> formdata) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url =
          "api/MobileApp/teacher/$userId/getStudentsForAttendance";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata,
      );

      if (response["result"] == 1 && response["success"] is List) {
        final List<dynamic> students = response["success"];
        return students.map((e) {
          return StudentTransportAttendanceModel.fromJson(
            e as Map<String, dynamic>,
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Save Record
  Future<Map<String, dynamic>> submitStudentTransportAttendance(
    Map<String, dynamic> formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final url =
          "api/MobileApp/teacher/$userId/CreateStudentsTranportAttendance";
      final response = await getApiService.postRequestData(
        url,token!, formdata,
      );
      return response;
    } catch (e) {
      print("${e}");
      return {};
    }
  }
}
