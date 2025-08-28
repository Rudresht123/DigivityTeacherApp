
import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/SubjectModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:url_launcher/url_launcher.dart';
class CustomFunctions {
  int? userId;
  int? userId1;
  String? token;
  dynamic response;


  CustomFunctions();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    userId1 = await SharedPrefHelper.getPreferenceValue('staff_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Fetches and returns user profile data
  Future<Map<String, dynamic>> getUserProfileData() async {
    if (userId == null || token == null) {
      await init();
    }

    final url = "api/MobileApp/profile/$userId";
    print(url);
    response = await getApiService.getRequestData(url, token!);

    return response['success'];
  }

  /// Sessions Data
  Future<List<Map<String, dynamic>>> getSessionsList() async {
    if (token == null) {
      await init();
    }
    if (token == null) {
      throw Exception("Token is still null after initialization.");
    }
    final localToken = token!;
    final url = "api/MobileApp/Common/SessionsList";

    final response = await getApiService.getRequestData(url, localToken);

    final sessionslist = response['success'];
    final academicSessionsList = List<Map<String, dynamic>>.from(
        sessionslist['academic_sessions'] ?? []);
    final financialSessionsList = List<Map<String, dynamic>>.from(
        sessionslist['financial_session'] ?? []);

    final activeAcademicId = sessionslist["active_academic"];
    final activeFinancialId = sessionslist["active_financial"];


    return [
      {
        'key': 'academic_sessions',
        'value': academicSessionsList,
      },
      {
        'key': 'financial_sessions',
        'value': financialSessionsList,
      },
      {
        'key': 'active_academic',
        'value': activeAcademicId
      },
      {
        'key': 'active_financial',
        'value': activeFinancialId
      }
    ];
  }

  Future<Map<String, dynamic>> changeSession({
    required dynamic academicId,
    required dynamic financialId,
  }) async {
    if (userId == null || token == null) {
      await init();
    }

    final formData = {
      'academic_id': academicId,
      'financial_id': financialId,
    };


    // Optional: make POST request if needed
    final url = "api/MobileApp/Common/UserYearChange/$userId/change";

    final response = await getApiService.postRequestData(url, token!, formData);
    return response;
  }


//   Dial Phone Number function

  Future<void> dialPhoneNumber(String phoneNumber) async {
    final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);
    print('Dialing: $telUri');

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } else {
      print("⚠️ Could not launch dialer for: $phoneNumber");
      throw 'Could not launch $telUri';
    }
  }

  Future<Map<String, dynamic>> updateStudentAcount(String studentId,
      String status, String Remark) async {
    if (userId == null || token == null) {
      await init();
    }
    final formData = {
      'status': status,
      'remark': Remark,
    };

    final url = "api/MobileApp/teacher/StudentStatus/$studentId/Update";
    final response = await getApiService.postRequestData(url, token!, formData);

    return response;
  }

//   Attedance Reports Section Start Here
  Future<String?> fetchDayWiseAttendanceHtml(String courseId,String reportDate) async {
    if (userId == null || token == null) {
      await init(); // Your user/token initialization logic
    }

    final url = "api/MobileApp/teacher/$userId/Daywiseattendancereport";

    final formData = {
      'course_id': courseId,
      'from_date':reportDate,
      'to_date':reportDate
    };

    final response = await getApiService.postRequestData(url, token!, formData);

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'].isNotEmpty &&
        response['success'][0]['data'] != null) {
      return response['success'][0]['data'];
    }

    return null;
  }


  Future<String?> fetchCourseAttendanceHtml(String reportDate) async {
    if (userId == null || token == null) {
      await init(); // Your user/token initialization logic
    }

    final url = "api/MobileApp/teacher/$userId/Coursewiseattendancereport";

    final formData = {
      'from_date':reportDate,
      'to_date':reportDate
    };

    final response = await getApiService.postRequestData(url, token!, formData);

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'].isNotEmpty &&
        response['success'][0]['data'] != null) {
      return response['success'][0]['data'];
    }

    return null;
  }


  Future<List<SubjectModel>> getCourseSubjects(String courseId) async {
    if (userId == null || token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/$courseId/SubjectList";
    final response = await getApiService.getRequestData(url, token!);
    final List<dynamic> successList = response['success'] ?? [];

    final List<SubjectModel> subjects = [
      SubjectModel(id: 0, subject: 'Please Select The Subject'),
      ...successList.map((item) => SubjectModel.fromJson(item)).toList(),
    ];
    print(subjects);
    return subjects;
  }



  Future<Map<String,dynamic>> uploadImages(String ForImage,Map<String, dynamic> formData) async{

    try {
      if (userId == null || token == null) {
        await init(); // Ensure userId and token are initialized
      }
      String url='';
      if(ForImage =='student') {
        url = "api/MobileApp/teacher/$userId/StoreStudentPhoto";
      }
      else if(ForImage =='staff'){
        url = "api/MobileApp/teacher/$userId/StoreStaffPhoto";
      }
      final response = await getApiService.postRequestData(url, token!,formData);
      return response ?? {'status': false, 'message': 'Something went wrong'};
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }

  }


  /// Fetches and returns user profile data
  Future<Map<String, dynamic>> getAppUserProfileData() async {
    if (userId == null && token == null || userId1 == null) {
      await init();
    }
    final url = "api/MobileApp/teacher/$userId1/$userId/StaffProfile";
    print(url);
    response = await getApiService.getRequestData(url, token!);

    return response['success'];
  }

}







