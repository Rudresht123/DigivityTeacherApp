import 'dart:convert';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentAttendanceModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';

class StudentAttendanceProvider with ChangeNotifier {
  List<StudentAttendanceModel> _attendanceList = [];

  List<StudentAttendanceModel> get attendanceList => _attendanceList;

  Future<List<StudentAttendanceModel>> fetchAttendanceList({
    required String? courseId,
    required String? selectedSortBy,
    required String? selectedDate,
    required String? selectedOrderBy
  }) async {
    final userId = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');

    final formdata = {
      "sort_by_method":selectedSortBy,
      "order_by":selectedOrderBy,
    };

    final shortby = selectedSortBy != 'sortBy' ? selectedSortBy : 'first_name';
    final url = "api/MobileApp/teacher/$userId/$courseId/$shortby/$selectedDate/StudentAttendance"; // <- replace with actual URL
    try {
      final response = await getApiService.postRequestData(url, token!,formdata!);
      if (response is Map<String, dynamic> &&
          response['success'] != null &&
          response['success'] is List) {
        final List<dynamic> data = response['success'];

        _attendanceList = data
            .map((item) =>
            StudentAttendanceModel.fromJson(item as Map<String, dynamic>))
            .toList();

        notifyListeners();
        return _attendanceList;
      } else {
        print("Unexpected attendance response format: $response");
        return [];
      }
    } catch (e) {
      print("Attendance Fetch Error: $e");
      return [];
    }
  }

  void updateAttendanceStatus(int studentId, String newStatus) {
    final index =
    _attendanceList.indexWhere((student) => student.studentId == studentId);
    if (index != -1) {
      _attendanceList[index] = StudentAttendanceModel(
        studentId: _attendanceList[index].studentId,
        admissionNo: _attendanceList[index].admissionNo,
        rollNo: _attendanceList[index].rollNo,
        studentName: _attendanceList[index].studentName,
        course: _attendanceList[index].course,
        gender: _attendanceList[index].gender,
        fatherName: _attendanceList[index].fatherName,
        profileImg: _attendanceList[index].profileImg,
        attendance: newStatus,
        holiday: _attendanceList[index].holiday,
      );
      notifyListeners();
    }
  }


  Future<String> submitAttendanceData(Map<String, dynamic> payload) async {
    try {
      final token = await SharedPrefHelper.getPreferenceValue('access_token');
      final userId = await SharedPrefHelper.getPreferenceValue('user_id');

      final url = "api/MobileApp/teacher/$userId/StoreStudentAttendance";

      final response = await getApiService.postRequestData(url, token, payload);

      if (response is Map && response['result'] == 1) {
        return response['message'];
      } else {
        print("Submission failed: $response");
        return 'Faild To Submit Attendace';
      }
    } catch (e) {
      print("Error submitting attendance: $e");
      return 'Faild To Submit Attendace';
    }
  }


  void clearData() {
    _attendanceList = [];
    notifyListeners();
  }
}
