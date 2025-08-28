import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/CourseDocStatus.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/StudentDocumentUpload.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StudentDocUploadsModels/StudentDocumentUplodedModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class Studentdocumentsuploadhelpers{
  int? userId;
  String? token;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id') ?? '';
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<CourseDocStatus>?> getClassWiseUplodedDocumentsDetails() async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/teacher/$userId/CourseWiseUploadedDocuments';

      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => CourseDocStatus.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }

  Future<List<StudentDocumentUplodedModel>?> getClasswiseStudentUplodedDocuments(Map<String,dynamic> bodydata) async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/$userId/StudentWiseDocUploadedReport';
      final response = await getApiService.postRequestData(url, token!,bodydata!);
      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => StudentDocumentUplodedModel.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }


  Future<List<StudentDocumentUpload>?> getStudentUploadDocuments(int StudentId) async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/$StudentId/StudentUploadDocuments';

      final response = await getApiService.getRequestData(url, token!);
      if (response['result'] == 1) {
        final List<dynamic> data = response['success'];
        return data.map((e) => StudentDocumentUpload.fromJson(e)).toList();
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }


  Future<Map<String,dynamic>> uploadStudentDocuemnt(Map<String,dynamic> bodydata) async {
    try {
      if (userId == null || token == null) {
        await init();
      }
      final url = 'api/MobileApp/$userId/uploadStudentDocument';
      final response = await getApiService.postRequestData(url, token!,bodydata!);
      if (response['result'] == 1) {
        print(response);
        return response;
      } else {
        throw Exception('Fetch failed: ${response['message']}');
      }
    } catch (e) {
      print({'result': 0, 'message': 'Fetch failed: $e'});
      rethrow;
    }
  }

}