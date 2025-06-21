import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:to_do_project/model/task_model.dart';

class TaskService {

  static const String baseUrl = 'https://todoapp-krfv.onrender.com/api/task';

  static Future<List<Task>> fetchTasks(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/all?userId=$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((task) => Task.fromJson(task)).toList();
    } else{
      throw Exception('Failed to load tasks');
    }
  }
}
