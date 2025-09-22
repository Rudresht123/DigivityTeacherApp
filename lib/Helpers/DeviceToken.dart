import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceToken {
  int? userId;
  String? accessToken;

  DeviceToken();

  Future<void> init() async {
    userId = await SharedPrefHelper.getPreferenceValue('user_id');
    accessToken = await SharedPrefHelper.getPreferenceValue('access_token');
  }

  /// Call this function to fetch and save device token safely
  Future<void> registerDeviceToken() async {
    if (userId == null || accessToken == null) {
      await init();
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized &&
        settings.authorizationStatus != AuthorizationStatus.provisional) {
      print('Notification permission denied');
      return;
    }

    // Listen for FCM token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print('FCM Token refreshed: $newToken');
      await _saveTokenToBackend(newToken);
    });

    // Get initial FCM token
    String? firebaseToken = await messaging.getToken();
    if (firebaseToken != null) {
      print('FCM Token obtained: $firebaseToken');
      await _saveTokenToBackend(firebaseToken);
    } else {
      print('FCM Token not available yet, waiting for token refresh...');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // Optionally show a local notification here
    });
  }

  /// Save token to backend
  Future<void> _saveTokenToBackend(String token) async {
    final url = "api/MobileApp/master-admin/$userId/PushNotificationDeviceToken";
    final body = {
      "appname": "AdminApp",
      "ac_user_id": userId.toString(),
      "token_id": token,
      "active_status": "1",
    };
    final response = await getApiService.postRequestData(url, accessToken!, body);

    if (response != null && response['result'] == 1) {
      print('✅ FCM Device Token saved successfully: $token');
    } else {
      print('⚠️ Failed to save FCM token: $token');
    }
  }
}
