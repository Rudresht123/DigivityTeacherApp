import 'dart:async';

import 'package:digivity_admin_app/AdminPanel/Models/EventCalender/EventCalenderModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class EventCalenderHelper {
  int? userId;
  String? token;
  dynamic response;
  EventCalenderHelper();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Get Calender Events
  Future<List<EventCalenderModel>> getThisMonthEvents(String month) async {
    if (userId == null || token == null) {
      await init();
    }
    final url = "api/MobileApp/teacher/$userId/$month/getMonthlyCalender";
    try {
      final response = await getApiService.getRequestData(url, token!);
      if (response['result'] == 1 && response['success'] is List) {
        return (response['success'] as List)
            .map((e) => EventCalenderModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print("${e}");
      return [];
    }
  }
}
