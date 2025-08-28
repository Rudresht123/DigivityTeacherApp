// Cleaned version without unused import
import 'dart:convert';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';
import 'package:digivity_admin_app/AdminPanel/Models/StaffModels/StaffModel.dart';
import 'package:digivity_admin_app/helpers/CommonFunctions.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';

class StaffDataProvider with ChangeNotifier {
  List<StaffModel> _staffs = [];

  List<StaffModel> get staffs => _staffs;

  Future<List<StaffModel>> fetchStaffs({
    required Map<String, dynamic> bodyData,
  }) async {
    final userid = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');
    final url = "api/MobileApp/master-admin/$userid/StaffList";

    try {
      final response = await getApiService.postRequestData(url, token, bodyData);

      if (response is Map<String, dynamic> &&
          response['success'] != null &&
          response['success'] is List) {
        final List<dynamic> staffData = response['success'];

        _staffs = staffData
            .map((item) => StaffModel.fromJson((item as Map<String, dynamic>)))
            .toList();

        notifyListeners();
        return _staffs;
      } else {
        print("Unexpected response format: $response");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  void removeStaffById(String staffId) {
    _staffs.removeWhere((staff) => staff.dbId.toString() == staffId);
    notifyListeners();
  }
}
