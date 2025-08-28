import 'package:digivity_admin_app/AdminPanel/Models/MainDashboardModel/SuccessData.dart';

class DashboardResponse {
  final int result;
  final List<SuccessData> success;

  DashboardResponse({required this.result, required this.success});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      result: json['result'],
      success: (json['success'] as List)
          .map((e) => SuccessData.fromJson(e))
          .toList(),
    );
  }
}
