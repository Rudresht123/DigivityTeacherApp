import 'dart:convert';
import 'dart:io';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:path/path.dart' as path;

class UploadHomeWorksEtc {
  int? userId;
  String? token;

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<Map<String, dynamic>> uploadData(
      String forUpload,
      Map<String, dynamic> formData,
      List<File> files,
      ) async {
    try {
      final token = await SharedPrefHelper.getPreferenceValue('access_token');
      final userId = await SharedPrefHelper.getPreferenceValue('user_id');

      String url = '';
      if (forUpload == 'homework') {
        url = 'api/MobileApp/teacher/$userId/StoreHomework';
      }
      else if(forUpload == 'syllabus'){
        url = 'api/MobileApp/teacher/$userId/StoreSyllabus';
      }
      else if(forUpload == 'assignment'){
        url = 'api/MobileApp/teacher/$userId/StoreAssignment';
      }
      else if(forUpload=='notice'){
        url = 'api/MobileApp/teacher/$userId/StoreNotice';
      }
      else if(forUpload=='circular'){
        url = 'api/MobileApp/teacher/$userId/StoreCircular';
      }

      // Encode files to base64 and add as fileList0, fileList1,...
      for (int i = 0; i < files.length; i++) {
        final bytes = await files[i].readAsBytes();
        final base64Str = base64Encode(bytes);
        formData['fileList$i'] = base64Str;
      }

      formData['fileExtension'] = files
          .map((file) {
        return path.extension(file.path).replaceFirst('.', '');
      })
          .join('~');
      formData['user_id'] = userId;

      final response = await getApiService.postRequestData(
        url,
        token!,
        formData,
      );
      return response;
    } catch (e) {
      return {'result': 0, 'message': 'Upload failed: $e'};
    }
  }
}
