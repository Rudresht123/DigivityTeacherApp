import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> getSchoolData(String code) async {

  final url = Uri.parse('https://clients.erpcare.in/school/$code/search');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data; // Return the parsed JSON
    } else {
      return {
        'error': true,
        'statusCode': response.statusCode,
        'message': 'Failed to fetch data'
      };
    }
  } catch (e) {
    return {
      'error': true,
      'message': e.toString()
    };
  }
}
