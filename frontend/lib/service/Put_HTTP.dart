import 'package:http/http.dart' as http;
import 'dart:convert';

class Update {
  static const String url = "https://todoapp-krfv.onrender.com/api/";

  static Future<http.Response?> updateTask(Map<String, dynamic> tData) async {
    try {
      final uri = Uri.parse("${url}task/update");
      final res = await http.put(
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
