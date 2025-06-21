import 'package:http/http.dart' as http;
import 'dart:convert';

class Reset {
  static const String url = "https://todoapp-krfv.onrender.com/api/";

  static Future<http.Response?> resetPassword(Map<String, dynamic> uData) async {
    try {
      final uri = Uri.parse("${url}user/reset");
      final res = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(uData),
      );
      print(res.body);
      return res;
    } catch (e) {
      return null;
    }
  }
}
