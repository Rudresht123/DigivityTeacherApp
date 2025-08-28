import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/CourseModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamRemarkListModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamTermModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ExamTypeListModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentMarksResponse.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentRemarkEntry.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentMarksManagerCommonHelper {
  int? userId;
  String? token;
  dynamic response;

  StudentMarksManagerCommonHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Function For Getting The Exam Term
  Future<Map<String, dynamic>> getMarksmanagerData() async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/StudentExamMarksEntry";

    final response = await getApiService.getRequestData(url, token!);

    if (response['result'] == 1 && response['success'] != null) {
      final data = response['success'][0];
      final classList = data['classlist'] as List;
      final examTermList = data['examtermlist'] as List;
      final courseList = classList
          .map((e) => CourseModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final examTermListdata = examTermList
          .map((e) => Examtermmodel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return {'courseList': courseList, 'examTermList': examTermListdata};
    } else {
      return {
        'status': false,
        'courseList': [],
        'examTermList': [],
        'message': response['message'] ?? 'Failed to fetch marks manager data.',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getExamDynamicData(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null || token == null) {
      await init(); // Ensure userId and token are initialized
    }

    final url = "api/MobileApp/teacher/$userId/GetExamEntryConfigList";
    final response = await getApiService.postRequestData(url, token!, bodydata);
    try {
      if (response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final successData = (response['success'] as List)[0];

        // Make sure successData is a Map before casting
        if (successData is Map<String, dynamic>) {
          if (bodydata['getdata'] == 'examtypelist' &&
              successData['examtypelist'] is List) {
            final List<dynamic> examTypeList = successData['examtypelist'];
            return examTypeList.map<Map<String, dynamic>>((e) {
              if (e is Map<String, dynamic>) {
                return {'id': e['key'], 'name': e['value']};
              } else {
                return {'id': null, 'name': null};
              }
            }).toList();
          } else if (bodydata['getdata'] == 'examassessmentlist' &&
              successData['examassessmentlist'] is List) {
            final List<dynamic> examTypeList =
            successData['examassessmentlist'];
            return examTypeList.map<Map<String, dynamic>>((e) {
              if (e is Map<String, dynamic>) {
                return {'id': e['key'], 'name': e['value']};
              } else {
                return {'id': null, 'name': null};
              }
            }).toList();
          } else if (bodydata['getdata'] == 'examsubjectlist' &&
              successData['examsubjectlist'] is List) {
            final List<dynamic> examTypeList = successData['examsubjectlist'];
            return examTypeList.map<Map<String, dynamic>>((e) {
              if (e is Map<String, dynamic>) {
                return {'id': e['key'], 'name': e['value']};
              } else {
                return {'id': null, 'name': null};
              }
            }).toList();
          }
        }
      }
    } catch (e, stackTrace) {
      print("Error parsing exam type list: $e");
    }

    return [];
  }

  Future<StudentMarksResponse?> apistudentlistmarksentry(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/StudentListExamMarksEntry";

    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata,
      );

      if (response['result'] == 1 &&
          response['success'] != null &&
          response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final successData = response['success'][0];
        return StudentMarksResponse.fromJson(successData);
      }

      return null;
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }

  //   Store Student Marks FUnction
  Future<Map<String, dynamic>> storeStudentMarks(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null || token == null) {
      await init(); // Ensure userId and token are initialized
    }
    bodydata['user_id'] = userId;
    final url = "api/MobileApp/teacher/$userId/ApiStoreStudentExamMarksEntry";
    final response = await getApiService.postRequestData(url, token!, bodydata);

    if (response['result'] == 1) {
      return response;
    } else {
      return {
        'result': 0,
        'message': response['message'] ?? 'Failed to fetch marks manager data.',
      };
    }
  }



  /// Api For the Student Remark Entry
  Future<List<StudentRemarkEntry>?> apistudentlistremarksentry(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    bodydata['user_id'] = userId;
    final url = "api/MobileApp/teacher/$userId/StudentListForRemarkEntry";
    try {
      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata,
      );

      if (response['result'] == 1 &&
          response['success'] != null &&
          response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final successData = response['success'][0];

        if (successData['studentlist'] is List) {
          final List<StudentRemarkEntry> students = (successData['studentlist'] as List)
              .map((e) => StudentRemarkEntry.fromJson(e))
              .toList();

          return students;
        }
      }
      return null;
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }


  /// API for getting the ExamRemarks List
  Future<List<ExamRemarkList>> getExamRemarks() async {
    if (userId == null && token == null) {
      await init();
    }
    final url = "api/MobileApp/teacher/$userId/ExamRemarkList";
    try {
      final response = await getApiService.getRequestData(url, token!);
      if (response['result'] == 1 &&
          response['success'] != null &&
          response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final successData = response['success'][0];
        if (successData['remarklist'] is List) {
          final List<ExamRemarkList> examremarksList = (successData['remarklist'] as List)
              .map((e) => ExamRemarkList.fromJson(e))
              .toList();
          return examremarksList;
        }
      }
      return [];
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }



  /// api for the store studetn exam remarks
  Future<Map<String, dynamic>> storeStudentRemarks(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null || token == null) {
      await init(); // Ensure userId and token are initialized
    }
    bodydata['user_id'] = userId.toString();
    final url = "api/MobileApp/teacher/$userId/ApiStoreStudentExamRemarks";
    final response = await getApiService.postRequestData(url, token!, bodydata);

    if (response['result'] == 1) {
      return response;
    } else {
      return {
        'result': 0,
        'message': response['message'] ?? 'Failed to fetch marks manager data.',
      };
    }
  }


}
