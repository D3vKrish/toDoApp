import 'package:http/http.dart' as http;
import 'dart:convert';

class Http {
  static const String url = "https://todoapp-krfv.onrender.com/api/";

  static Future<http.Response?> createTask(Map<String, dynamic> tData) async {
    try {
      final uri = Uri.parse("${url}task/create");
      final res = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(tData),
      );
      return res;
    } catch (e) {
      return null;
    }
  }
}
