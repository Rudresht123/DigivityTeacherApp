import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ClassTotalAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/ClasswiseTotalConductedPtmModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/OtherEntrytypeList.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentHeightWeightModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentPtmListModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MarksManagerModel/StudentTotalAttendanceModel.dart';
import 'package:digivity_admin_app/AdminPanel/Screens/ExamMarksManager/StudentExamOtherEntry/EntryList/ClassWiseTotalConductedPtm.dart';

import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentExamOtherEntryHelper {
  int? userId;
  String? token;
  String? role;
  dynamic response;

  StudentExamOtherEntryHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
    role = await SharedPrefHelper.getPreferenceValue('role');
  }

  /// Get Exam Other Entry Types List
  Future<List<OtherEntrytypeList>> getExamOtherEntryTypes() async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/OtherEntryTypeList";

    final response = await getApiService.getRequestData(url, token!);

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'] is List &&
        (response['success'] as List).isNotEmpty) {
      final data = response['success'][0];
      final typelist = data['entrytype'];

      if (typelist is List) {
        return typelist
            .map<OtherEntrytypeList>((e) => OtherEntrytypeList.fromJson(e))
            .toList();
      }
    }
    // Return empty list in case of failure
    return [];
  }

  // Api For Student Total Attendance List
  Future<List<StudentTotalAttendanceModel>> getStudentTotalAttendance(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/StudentListExamAttendanceEntry";

    final response = await getApiService.postRequestData(
      url,
      token!,
      bodydata!,
    );

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'] is List &&
        (response['success'] as List).isNotEmpty) {
      final data = response['success'][0];
      final studenttotalatt = data['studentlist'];

      if (studenttotalatt is List) {
        return studenttotalatt
            .map<StudentTotalAttendanceModel>(
              (e) => StudentTotalAttendanceModel.fromJson(e),
        )
            .toList();
      }
    }
    // Return empty list in case of failure
    return [];
  }

  // Api For Student Total Attendance List
  Future<Map<String, dynamic>> storeStudentTotalAttendance(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      bodydata['user_id'] = userId;

      final url =
          "api/MobileApp/teacher/$userId/ApiStoreStudentTotalAttendance";

      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata!,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {'result': 1, 'message': 'Class Attendance Submission Failed.'};
      }
    } catch (e) {
      return {};
      print("Data Saved Error $e");
    }
  }

  //   Get Data for The Class total attendance
  Future<List<ClassTotalAttendanceModel>> apiclasswisetotalattendance(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null && role == null) {
      await init();
    }
    try {
      bodydata['staff_id'] = userId.toString();
      bodydata['role'] = role.toString();

      final url =
          "api/MobileApp/teacher/$userId/StudentClassWithTotalAttendance";

      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata,
      );

      if (response['result'] == 1 &&
          response['success'] != null &&
          response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final data = response['success'][0];
        final classtotalattendance = data['classlist'];
        if (classtotalattendance is List) {
          return classtotalattendance
              .map<ClassTotalAttendanceModel>(
                (e) => ClassTotalAttendanceModel.fromJson(e),
          )
              .toList();
        }
      }
      return []; // return empty list if no data
    } catch (e) {
      print("Data Saved Error: $e");
      return []; // also return empty list on error
    }
  }

  Future<Map<String, dynamic>> storeClassWiseAttendance(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      final url = "api/MobileApp/teacher/$userId/ApiStoreClassTotalAttendance";

      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata!,
      );
      if (response['result'] == 1) {
        return response;
      } else {
        return {'result': 1, 'message': 'Class Attendance Submission Failed.'};
      }
    } catch (e) {
      return {};
      print("Data Saved Error $e");
    }
  }

  //   Student Height Weight List
  Future<List<StudentHeightWeightModel>> getStudentHeightWeight(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/teacher/$userId/StudentListForHeightWeight";

    final response = await getApiService.postRequestData(
      url,
      token!,
      bodydata!,
    );

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'] is List &&
        (response['success'] as List).isNotEmpty) {
      final data = response['success'][0];
      final students = data['studentlist'];

      if (students is List) {
        return students
            .map<StudentHeightWeightModel>(
              (e) => StudentHeightWeightModel.fromJson(e),
        )
            .toList();
      }
    }
    // Return empty list in case of failure
    return [];
  }

  // Api For Student Height Weight Store
  Future<Map<String, dynamic>> storeStudentHeightWeight(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      final url = "api/MobileApp/teacher/$userId/ApiStoreStudentHeightWeight";

      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata!,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {
          'result': 1,
          'message': 'Class Height Weight Submission Failed.',
        };
      }
    } catch (e) {
      return {};
      print("Data Saved Error $e");
    }
  }

  // Api For the Student Total Attend PTM List

  Future<List<StudentPtmListModel>> getStudentTotalAttendPtm(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    final url = "api/MobileApp/teacher/$userId/StudentListPTMEntry";
    final response = await getApiService.postRequestData(
      url,
      token!,
      bodydata!,
    );
    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'] is List &&
        (response['success'] as List).isNotEmpty) {
      final data = response['success'][0];
      final studenttotalatt = data['studentlist'];
      if (studenttotalatt is List) {
        return studenttotalatt
            .map<StudentPtmListModel>((e) => StudentPtmListModel.fromJson(e))
            .toList();
      }
    }
    // Return empty list in case of failure
    return [];
  }

  Future<Map<String, dynamic>> storeStudentTotalAttendptm(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      final url = "api/MobileApp/teacher/$userId/ApiStoreStudentTotalAttendPtm";
      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata!,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {'result': 1, 'message': 'Class Attendance Submission Failed.'};
      }
    } catch (e) {
      return {};
      print("Data Saved Error $e");
    }
  }


//   Class wise total Conducted PTM
  Future<List<ClasswiseTotalConductedPtmModel>> apiclasswisetotalconductedptm(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null && role == null) {
      await init();
    }
    try {
      bodydata['staff_id'] = userId.toString();
      bodydata['role'] = role.toString();

      final url =
          "api/MobileApp/teacher/$userId/StudentClassWithTotalConductedPTM";

      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata,
      );

      if (response['result'] == 1 &&
          response['success'] != null &&
          response['success'] is List &&
          (response['success'] as List).isNotEmpty) {
        final data = response['success'][0];
        final classtotalattendance = data['classlist'];
        if (classtotalattendance is List) {
          return classtotalattendance
              .map<ClasswiseTotalConductedPtmModel>(
                (e) => ClasswiseTotalConductedPtmModel.fromJson(e),
          )
              .toList();
        }
      }
      return []; // return empty list if no data
    } catch (e) {
      print("Data Saved Error: $e");
      return []; // also return empty list on error
    }
  }

// Api submit total class wise conducted ptm
  Future<Map<String, dynamic>> storeStudentClasswiseCondcutedPTM(
      Map<String, dynamic> bodydata,
      ) async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      final url = "api/MobileApp/teacher/$userId/ApiStoreClassTotalConductedPTM";
      final response = await getApiService.postRequestData(
        url,
        token!,
        bodydata!,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {'result': 1, 'message': 'Class Attendance Submission Failed.'};
      }
    } catch (e) {
      return {};
      print("Data Saved Error $e");
    }
  }

}
