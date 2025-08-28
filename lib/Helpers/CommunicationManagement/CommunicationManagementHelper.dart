import 'package:digivity_admin_app/AdminPanel/Models/SmsManagementModels/CmposeCommunicationReponce.dart';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';

class CommunicationManagementHelper {
  int? userId;
  String? token;
  dynamic response;

  /// Proper async initializer
  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    token = await SharedPrefHelper.getPreferenceValue('access_token');
  }


  /// Function for getting the lists of the contacts of the communication
  Future<CmposeCommunicationReponce?> getCommunicationContacts() async {
    if (userId == null && token == null) {
      await init();
    }
    try {
      final url = "api/MobileApp/master-admin/$userId/SendSMSindex";
      final response = await getApiService.getRequestData(url, token!);
      if (response['result'] == 1 && response['success'] != null &&
          response['success'].isNotEmpty) {
        final data = response['success'][0];
        return CmposeCommunicationReponce.jsonFrom(data);
      }
      else {
        return null;
      }
    } catch (e) {
      print("Error in fetching the data $e");
      return null;
    }
  }
}