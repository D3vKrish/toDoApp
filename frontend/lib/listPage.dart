import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'checkToken.dart';
import 'editPage.dart';
import 'newPage.dart';
import 'package:to_do_project/model/task_model.dart';
import 'service/Task_HTTP.dart';
import 'service/Put_HTTP.dart';
import 'service/Delete_HTTP.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<Task> tasks = [];
  bool isLoading = true;
  late String userId = "";
  static const storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      isLoading = true;
    });
    String? token = await storage.read(key: 'jwtToken');
    if (token != null) {
      userId = JwtDecoder.decode(token)['userId'];
      await _loadTasks();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _loadTasks() async {
    try {
      final fetchedTasks = await TaskService.fetchTasks(userId);
      setState(() {
        tasks = fetchedTasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tasks: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "List",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade200,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              storage.delete(key: 'jwtToken');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(
                  child: Text(
                    "NO ITEMS YET",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditPage(task: tasks[index].toJson()),
                            ),
                          ).then((_) => _loadTasks());
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.black, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: tasks[index].status,
                                  onChanged: (value) async {
                                    setState(() {
                                      tasks[index].status = value!;
                                      print(tasks[index].status);
                                    });

                                    try {
                                      final data = {
                                        "taskId": tasks[index].id,
                                        "userId": tasks[index].userId,
                                        "title": tasks[index].title,
                                        "description": tasks[index].description,
                                        "ddate": tasks[index]
                                            .ddate
                                            .toIso8601String(),
                                        "status": value,
                                      };

                                      final response =
                                          await Update.updateTask(data);

                                      if (response != null &&
                                          response.statusCode == 200) {
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed to update task status'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Error updating status: $e')),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tasks[index].title,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Date created: ${DateFormat('dd-MM-yyyy').format(tasks[index].createdAt)}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                //Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    try {
                                      final String taskId = tasks[index].id;
                                      final response =
                                          await Delete.deleteTask(taskId);
                                      if (response != null &&
                                          response.statusCode == 200) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Task deleted successfully!')),
                                        );
                                        await _loadTasks();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Failed: ${response.body}'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.black87),
                                  onPressed: () async {
                                    _showLoadingDialog();
                                    final valid =
                                        await AuthService.isTokenValid();
                                    Navigator.pop(context);

                                    if (!valid) {
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('User session timed out'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPage(
                                            task: tasks[index].toJson()),
                                      ),
                                    ).then((_) => _loadTasks());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade200,
        onPressed: () async {
          _showLoadingDialog();
          final valid = await AuthService.isTokenValid();
          Navigator.pop(context);

          if (!valid) {
            Navigator.pushReplacementNamed(context, '/login');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User session timed out'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewPage(userId: userId)),
          ).then((_) => _loadTasks());
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
