import 'package:http/http.dart' as http;
import 'dart:convert';

class Delete {
  static const String url = "https://todoapp-krfv.onrender.com/api/";

  static deleteTask(String taskId) async {
    try {
      final uri = Uri.parse("${url}task/delete");
      final res = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"taskId" : taskId}),
      );
      return res;
    } catch (e) {
      return null;
    }
  }
}
