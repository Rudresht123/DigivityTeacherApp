import 'package:digivity_admin_app/AdminPanel/Models/LeaveRecord/StudentLeaveModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';

class StudentLeaveRecordHelper {
  int? userId;
  int? userId1;
  String? token;
  dynamic response;
  StudentLeaveRecordHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    userId1 = await SharedPrefHelper.getPreferenceValue('staff_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Leave Record Data
  Future<List<StudentLeaveModel>> getStudentLeaveRecord(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/AppliedLeaveList";
    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );
      if (response['result'] == 1 && response['success'] is List) {
        final successdata = response['success'] as List;
        return successdata.map((e) => StudentLeaveModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Student Leave Request Cancle
  Future<Map<String, dynamic>> leaveRecordStatus(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url = "api/MobileApp/teacher/$userId/LeaveStatus";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Color getLeaveStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getLeaveStatusIcon(String status) {
    switch (status) {
      case "Pending":
        return Icons.hourglass_top;
      case "Approved":
        return Icons.check_circle;
      case "Rejected":
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }
}
