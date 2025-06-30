import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_do_project/model/task_model.dart';

class Http{
  static String url = "https://todoapp-krfv.onrender.com/api/";

  static getTask(String userId) async{
    try{
      final res = await http.post(Uri.parse("${url}task/all"), body: {'userId': userId});

      if (res.statusCode == 200){
        var data = jsonDecode(res.body);
        List<Task> taskList = data.map<Task>((json) => Task.fromJson(json)).toList();
        return taskList;
      }
      else{
        return [];
      }
    }
    catch(e){
      return [];
    }
  }
}