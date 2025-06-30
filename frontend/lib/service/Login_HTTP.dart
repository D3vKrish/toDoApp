import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Http {
  static const String baseUrl = "https://todoapp-krfv.onrender.com/api/user";
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<Map<String, dynamic>> loginUser(String userId, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'password': password,
      }),
    );

    final Map<String, dynamic> resData = jsonDecode(response.body.toString());
    if (response.statusCode == 200 &&
        resData['data'].containsKey('token')) {
      final token = resData['data']['token'];
      await _storage.write(key: "jwtToken", value: token);
    }
    return {
      'statusCode': response.statusCode,
      'response': resData,
    };
  }
}
