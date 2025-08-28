
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';

class StudentDataProvider with ChangeNotifier {
  List<StudentModel> _students = [];

  List<StudentModel> get students => _students; // Optional getter

  Future<List<StudentModel>> fetchStudents({
    required String? courseId,
    required String? sortByMethod,
    required String? orderByMethod,
    required String? selectedStatus,
  }) async {
    final userid = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');

    final url = "api/MobileApp/master-admin/$userid/StudentList";

    final body = {
      "course_id": courseId,
      "sort_by_method": 'sortBy',
      "order_by": sortByMethod,
      "status": selectedStatus,
    };
    try {
      final response = await getApiService.postRequestData(url, token, body);

      if (response is Map<String, dynamic> &&
          response['success'] != null &&
          response['success'] is List) {
        final List<dynamic> studentData = response['success'];

        _students = studentData
            .map((item) => StudentModel.fromJson(item as Map<String, dynamic>))
            .toList();

        notifyListeners();
        return _students;
      } else {
        print("Unexpected response format: $response");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }



  void removeStudentById(String studentId) {
    _students.removeWhere((student) => student.studentId.toString() == studentId);
    notifyListeners();
  }


}
