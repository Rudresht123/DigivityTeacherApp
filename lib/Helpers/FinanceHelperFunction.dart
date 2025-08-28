
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/FeeHeadModel.dart';
import 'package:digivity_admin_app/AdminPanel/Models/GlobalModels/PayModeModel.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class FinanceHelperFunction {
  int? userId;
  String? token;
  dynamic response;

  FinanceHelperFunction();

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<List<PaymodeModel>> getPaymodes() async {
    if (token == null) {
      await init();
    }

    if (token == null) {
      throw Exception("Token is still null after initialization.");
    }

    final localToken = token!;
    final url = "api/MobileApp/Finance/paymodes";
    final response = await getApiService.getRequestData(url, localToken);


    // Fix: Access nested list
    if (response['success'] != null &&
        response['success'] is List &&
        response['success'][0] is List) {
      final List<dynamic> innerList = response['success'][0];

      return innerList
          .map((item) => PaymodeModel.fromJson(item))
          .toList();
    }

    throw Exception("Failed to load paymodes.");
  }


  Future<List<Feeheadmodel>> getFeeheads() async {
    if (token == null) {
      await init();
    }
    if (token == null) {
      throw Exception("Token is still null after initialization.");
    }
    final localToken = token!;
    final url = "api/MobileApp/Finance/feeheads";
    final response = await getApiService.getRequestData(url, localToken);

    if (response['success'] != null && response['success'] is List && response['success'][0] is List) {

      final List<dynamic> innerList = response['success'][0];

      return innerList
          .map((item) => Feeheadmodel.fromJson(item))
          .toList();
    }
    throw Exception("Failed to load feeheads.");
  }

  Future<String?> apifeecollectionreport(String reportName, Map<String, dynamic> formData) async {
    if (userId == null || token == null) {
      await init();
    }

    // Map of report names to endpoint suffixes
    final reportEndpoints = {
      'apifeecollectionreport': 'apifeecollectionreport',
      'daybook-report': 'apidailybookreport',
      'feehead-wise-collection-report': 'apifeeheadcollectionreport',
      'paymode-wise-collection-report': 'apipaymodereport',
      'class-course-section-wise-collection-report': 'apiclasssectioncollectionreport',
      'monthly-fee-collection-report': 'apimonthmisreport',
      'daily-concession-report': 'apidaywiseconcessionreport',
      'class-course-wise-consolidate-report':'classconsolidatepayment',
      'class-course-section-wise-fee-defaulter-report':'apistudentdefaulter'
    };

    final endpoint = reportEndpoints[reportName];
    if (endpoint == null) return null;

    final url = "api/MobileApp/Finance/$userId/$endpoint";

    final response = await getApiService.postRequestData(url, token!, formData);

    if (response['result'] == 1 &&
        response['success'] != null &&
        response['success'].isNotEmpty &&
        response['success'][0]['data'] != null) {
      return response['success'][0]['data'];
    }

    return null;
  }

}


