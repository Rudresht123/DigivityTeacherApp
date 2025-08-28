import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/CourseData.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/DashboardResponse.dart';
import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/UserInfo.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/Loader.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/cupertino.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  List<UserInfo> userInfo = [];
  List<CourseData> courseeslist = [];
  Future<void> fetchDashboardData(BuildContext context) async {
    try {
      notifyListeners();
      final userid = await SharedPrefHelper.getPreferenceValue('user_id');
      final token = await SharedPrefHelper.getPreferenceValue('access_token');

      final url = "api/MobileApp/teacher/$userid/home";
      showLoaderDialog(context);
      final response = await getApiService.getRequestData(url, token);
      final dashboardResponse = DashboardResponse.fromJson(response);
      this.userInfo = dashboardResponse.success[0].userInfo;

      /// Course Data
      final courseJson = response['success'][0]['course'] as List;
      courseeslist = courseJson
          .map((e) => CourseData.fromJson(e as Map<String, dynamic>))
          .toList();

    } catch (e, st) {
      debugPrint("Error fetching dashboard data: $e\n$st");
      showBottomMessage(context, "Null Error", true);
    } finally {
      hideLoaderDialog(context);
      notifyListeners();
    }
  }

  /// Optional: Getter for dropdown with Map
  List<Map<String, String>> get courseDropdownMap => courseeslist
      .map(
        (e) => {
          'id': e.keyid,
          'value': e.value,
          'count': e.count?.toString() ?? '0',
        },
      )
      .toList();
}
