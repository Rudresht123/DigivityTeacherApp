import 'package:digivity_admin_app/AdminPanel/Models/Studdent/StudentModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/Studdent/UpdateFieldList.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentsData {
  int? userId;
  String? token;
  dynamic response;
  StudentsData();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<StudentModel>> fetchStudents({
    required String? courseId,
    required String? sortByMethod,
    required String? orderByMethod,
    required String? selectedStatus,
  }) async {
    if (userId == null && token == null) {
      await init();
    }
    final url = "api/MobileApp/teacher/$userId/StudentList";

    final body = {
      "course_id": courseId,
      "sort_by_method": 'sortBy',
      "order_by": sortByMethod ?? "",
      "student_status": selectedStatus,
    };

    try {
      final response = await getApiService.postRequestData(url, token!, body);

      if (response is Map<String, dynamic> &&
          response['success'] != null &&
          response['success'] is List) {
        final List<dynamic> studentData = response['success'];

        return studentData
            .map((item) => StudentModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        print("Unexpected response format: $response");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> filterStudents({
    required List<Map<String, dynamic>> originalList,
    required String query,
  }) {
    final lowerQuery = query.toLowerCase();

    return originalList.where((student) {
      final studentName = student['student_name']?.toLowerCase() ?? '';
      final admissionNo = student['admission_no']?.toLowerCase() ?? '';
      final course = student['course']?.toLowerCase() ?? '';
      final rollNo = student['roll_no']?.toString().toLowerCase() ?? '';

      return studentName.contains(lowerQuery) ||
          admissionNo.contains(lowerQuery) ||
          course.contains(lowerQuery) ||
          rollNo.contains(lowerQuery);
    }).toList();
  }

  Future<List<UpdateFieldList>> getFieldsForUpdate() async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/UpdateFieldList";
    final response = await getApiService.getRequestData(url, token!);

    if (response['success'] != null &&
        response['success'] is List &&
        response['success'].isNotEmpty &&
        response['success'][0]['fieldlist'] != null) {
      final List<dynamic> fieldlist = response['success'][0]['fieldlist'];

      return fieldlist
          .map<UpdateFieldList>((item) => UpdateFieldList.fromJson(item))
          .toList();
    }

    // Return an empty list if data not found or response is invalid
    return [];
  }

  String? getFieldValueFromStudent(StudentModel student, String fieldName) {
    switch (fieldName) {
      case 'db_id':
        return student.dbId?.toString();
      case 'student_id':
        return student.studentId?.toString();
      case 'sr_no':
        return student.srNo;
      case 'admission_date':
        return student.admissionDate;
      case 'academic_id':
        return student.academicId?.toString();
      case 'financial_id':
        return student.financialId?.toString();
      case 'admission_no':
        return student.admissionNo;
      case 'roll_no':
        return student.rollNo?.toString();
      case 'student_name':
        return student.studentName;
      case 'gender':
        return student.gender;
      case 'course_id':
        return student.courseId?.toString();
      case 'section_id':
        return student.sectionId?.toString();
      case 'course':
        return student.course;
      case 'dob':
        return student.dob;
      case 'category_id':
        return student.categoryId?.toString();
      case 'aadhar_no':
        return student.aadharNo;
      case 'father_name':
        return student.fatherName;
      case 'contact_no':
        return student.contactNo;
      case 'alt_contact_no':
        return student.altContactNo;
      case 'mother_name':
        return student.motherName;
      case 'residence_address':
        return student.residenceAddress;
      case 'transport_id':
        return student.transportId?.toString();
      case 'profile_img':
        return student.profileImg;
      case 'status':
        return student.studentStatus;
      default:
        return '';
    }
  }
}
