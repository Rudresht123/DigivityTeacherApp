import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffProfileModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffUpdateProfileModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class StaffApis{

  int? userId;
  String? token;
  dynamic response;

StaffApis();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }


  Future<Map<String, dynamic>> submitStaffData(Map<String, dynamic> staffData) async {
    if(userId ==null && token ==null){
      await init();
    }
    try {

      final url = "api/MobileApp/master-admin/$userId/StoreStaff";
      final data = await getApiService.postRequestData(url, token!, staffData);
      return data ?? {'status': false, 'message': 'Something went wrong'};
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }
  }

  Future<StaffProfileModel> staffProfile(String? staffId) async {
    if (userId == null || token == null) {
      await init();
    }
    final url = "api/MobileApp/master-admin/$userId/$staffId/StaffProfile";
    final response = await getApiService.getRequestData(url, token!);
    if (response != null &&
        response['success'] != null &&
        response['success'] is List &&
        response['success'].isNotEmpty) {
      final data = StaffProfileModel.fromJson(response['success'][0]);
      return data;
    } else {
      throw Exception("Failed to fetch student profile.");
    }
  }


  Future<StaffUpdateProfileModel> getStaffUpdateData(String? staffId) async {
    if (userId == null || token == null) {
      await init();
    }
    final url = "api/MobileApp/master-admin/$userId/$staffId/StaffUpdateProfile";
    final response = await getApiService.getRequestData(url, token!);
    if (response != null && response['success'] != null && response['success'] is List) {
      final data = response['success'][0];
      return StaffUpdateProfileModel.fromJson(data);
    } else {
      throw Exception('Failed to load student profile');
    }
  }


  Future<Map<String, dynamic>> updateStaffRecord(String? staffId, Map<String, dynamic> formData) async {
    try {
      if (userId == null || token == null) {
        await init(); // Ensure userId and token are initialized
      }
      final url = "api/MobileApp/master-admin/$userId/$staffId/EditStaffRecord";
      final response = await getApiService.postRequestData(url, token!, formData);

      return response ?? {'status': false, 'message': 'Something went wrong'};
    } catch (e) {
      return {'status': false, 'message': 'Error: $e'};
    }
  }


  Future<Map<String, dynamic>> updateStaffAcount(int staffId, int status, String Remark) async {
    if (userId == null || token == null) {
      await init();
    }
    final formData = {
      'status': status,
      'remark': Remark,
    };

    final url = "api/MobileApp/master-admin/StaffStatus/$staffId/Update";
    final response = await getApiService.postRequestData(url, token!, formData);

    return response;
  }

  Future<List<StaffModel>> getStaffList() async {
    if (userId == null && token == null) {
      await init();
    }

    final url = "api/MobileApp/Common/$userId/StaffListData";
    final response = await getApiService.getRequestData(url, token!);

    if (response['result'] == 1 &&
        response['success'] is List &&
        response['success'].isNotEmpty &&
        response['success'] != null) {

      final List<dynamic> stafflist = response['success'];

      return stafflist
          .map<StaffModel>((item) => StaffModel.fromJson(item))
          .toList();
    }

    // Return an empty list if data not found or response is invalid
    return [];
  }


}