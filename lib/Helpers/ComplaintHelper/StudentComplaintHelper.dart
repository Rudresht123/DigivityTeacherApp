import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/ComplaintModel/ComplaintTypeModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StudentComplaintHelper {
  int? userId;
  String? token;
  dynamic response;

  StudentComplaintHelper();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Getting The Complaint Type
  Future<List<ComplaintTypeModel>> getComplaintType() async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url = "/api/MobileApp/teacher/$userId/ComplaintType";

      final response = await getApiService.getRequestData(url, token!);

      if (response['result'] == 1 && response['success'] is List) {
        final List<dynamic> complaint = response['success'];
        return complaint
            .map(
              (item) =>
                  ComplaintTypeModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Student Complaints List Section Start Here
  Future<List<ComplaintModel>> getStudentComplaints(
    Map<String, dynamic> formdta,
  ) async {
    if (userId == null || token == null) {
      await init();
    }
    try {
      final String url = "api/MobileApp/teacher/$userId/RaisedComplaintList";
      print(formdta);
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdta,
      );

      if (response['result'] == 1 && response['success'] is List) {
        final responsedata = response['success'] as List;
        return responsedata.map((e) => ComplaintModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print("${e}");
      return [];
    }
  }

  /// Store Student Complaint Section Function
  Future<Map<String, dynamic>> storeStudentComplaint(
    Map<String, dynamic>? formdata,
  ) async {
    if (userId == null || token == null) {
      await init();
    }

    try {
      print(formdata);
      final String url = "api/MobileApp/teacher/$userId/StoreComplaint";
      final response = await getApiService.postRequestData(
        url,
        token!,
        formdata!,
      );


      print(formdata);
      if (response['result'] == 1) {
        return response;
      }
      return {}; // if result != 1
    } catch (e) {
      print("Error in storeStudentComplaint: $e");
      return {}; // return empty map on error
    }
  }
}
