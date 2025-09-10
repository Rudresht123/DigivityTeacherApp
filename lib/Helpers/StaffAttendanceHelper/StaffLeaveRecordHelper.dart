import 'dart:convert';
import 'dart:io';

import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffLeaveRecordModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:path/path.dart' as path;

class StaffLeaveRecordHelper {
  int? userId;
  int? staffId;
  String? token;
  dynamic response;

  StaffLeaveRecordHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
    staffId = await SharedPrefHelper.getPreferenceValue('staff_id');
  }

  /// Get Staff Leave Record
  Future<List<StaffLeaveRecordModel>> getStaffLeaveRecord() async {
    if (userId == null || token == null || staffId == null) {
      await init();
    }
    try {
      final String url = "api/MobileApp/teacher/$userId/$staffId/MyLeave";
      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1 && response['success'] is List) {
        final recordlist = response['success'] as List;

        List<StaffLeaveRecordModel> leaveList = recordlist
            .map((e) => StaffLeaveRecordModel.fromJson(e))
            .toList();

        return leaveList;
      } else {
        return [];
      }
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Store Staff Leave Request
  Future<Map<String, dynamic>> storeStaffLeaveRequest(
    Map<String, dynamic>? formdata,
    List<File> files,
  ) async {
    if (userId == null || token == null || staffId == null) {
      await init();
    }

    try {
      final String url = "api/MobileApp/teacher/$userId/$staffId/StoreLeave";
      final Map<String, dynamic> requestData = {
        "user_id": userId,
        "staff_id": staffId,
        ...?formdata,
      };

      // Encode files to base64 and add as fileList0, fileList1,...
      for (int i = 0; i < files.length; i++) {
        final bytes = await files[i].readAsBytes();
        final base64Str = base64Encode(bytes);
        requestData['fileList$i'] = base64Str;
      }

      // Collect all file extensions joined with ~
      if (files.isNotEmpty) {
        requestData['fileExtension'] = files
            .map((file) => path.extension(file.path).replaceFirst('.', ''))
            .join('~');
      }

      final response = await getApiService.postRequestData(
        url,
        token!,
        requestData,
      );

      if (response['result'] == 1) {
        return response;
      } else {
        return {"error": response['message'] ?? "Unknown error"};
      }
    } catch (e, stacktrace) {
      print("storeStaffLeaveRequest error: $e");
      print(stacktrace);
      return {"error": e.toString()};
    }
  }
}
