import 'dart:convert';
import 'package:http/http.dart' as http;

class Http {
  static const String baseUrl = "https://todoapp-krfv.onrender.com/api/user";

  static Future<Map<String, dynamic>> registerUser(String userId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'password': password,
      }),
    );

    final Map<String, dynamic> resData = jsonDecode(response.body);
    return {
      'statusCode': response.statusCode,
      'response': resData,
    };
  }
}
