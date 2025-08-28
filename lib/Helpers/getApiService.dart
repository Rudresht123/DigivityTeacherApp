import 'dart:convert';
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:http/http.dart' as http;

class getApiService{
  // GET request
  static Future<dynamic> getApiServiceForLogin(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  static Future<dynamic> getRequestData(String url,String token) async{
    try {
      final baseUrl = await SharedPrefHelper.getPreferenceValue('base_url');
      final finalUrl = "$baseUrl/$url";

      print(finalUrl);
      final response = await http.get(Uri.parse(finalUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data (${response.statusCode})');
      }
    } catch (e) {
      print(e);
      throw Exception('Error: $e');
    }
  }

  static Future<dynamic> postRequestData(
      String url, String token, Map<String, dynamic> body) async {
    try {
      final baseUrl = await SharedPrefHelper.getPreferenceValue('base_url');
      final finalUrl = "$baseUrl/$url";
      print(finalUrl);
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        // Parse Laravel validation errors
        final errorBody = jsonDecode(response.body);
        return {
          'result': 0,
          'message': errorBody['message'] ?? 'Validation error',
          'errors': errorBody['errors'] ?? {},
        };
      } else {
        throw Exception('Failed to post data (${response.statusCode})');
      }
    } catch (e) {
      print("POST Error: $e");
      throw Exception('Error: $e');
    }
  }

}

