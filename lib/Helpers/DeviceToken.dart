
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceToken {
  int? userId;
  String? accessToken;  // renamed from 'token' to 'accessToken' to avoid confusion

  DeviceToken();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    accessToken = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  Future<void> getDeviceToken() async {
    if (userId == null || accessToken == null) {
      await init();
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // iOS permission request
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional ||
        true) {
      String? firebaseToken = await messaging.getToken();

      if (firebaseToken == null) {
        print("Failed to get Firebase token");
        return;
      }

      final url = "api/MobileApp/master-admin/$userId/PushNotificationDeviceToken";

      final body = {
        "appname": "AdminApp",
        "ac_user_id": userId.toString(),
        "token_id": firebaseToken,
        "active_status": "1",
      };

      final response = await getApiService.postRequestData(url, accessToken!, body);

      if (response != null && response['result'] == 1) {
        print('FCM Device Token saved successfully: $firebaseToken');
      } else {
        print('FCM Device Token: $firebaseToken');
        print("Some Bug Not Saved Token");
      }
    } else {
      print('Notification permission declined');
    }
  }
}
