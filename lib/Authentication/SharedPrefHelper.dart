
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  /// Store all key-value pairs from a Map into SharedPreferences
  static Future<void> storeSuccessData(Map<String, dynamic> dataMap) async {
    final prefs = await SharedPreferences.getInstance();

    for (final entry in dataMap.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == null) {
        await prefs.remove(key);
      } else if (value is String) {
        await prefs.setString(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is double) {
        await prefs.setDouble(key, value);
      } else {
        await prefs.setString(key, value.toString());
      }
    }
  }

  /// Get value from SharedPreferences by key (returns dynamic type)
  static Future<dynamic> getPreferenceValue(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      return prefs.get(key); // Returns appropriate type (String, int, bool, etc.)
    }
    return null;
  }
  static Future<Map<String, dynamic>> getSharedPrefData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    final Map<String, dynamic> allPrefs = {};
    for (var key in keys) {
      allPrefs[key] = prefs.get(key);
    }
    return allPrefs;
  }


  Future<Map<String, dynamic>> fetchHomeData() async {
    final userId = await SharedPrefHelper.getPreferenceValue('user_id');
    final token = await SharedPrefHelper.getPreferenceValue('access_token');

    final url = "api/MobileApp/master-admin/$userId/home";
    final response = await getApiService.getRequestData(url, token);

    return {
      'userId': userId,
      'token': token,
      'response': response,
    };
  }





}
