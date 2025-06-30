import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service/Put_HTTP.dart';

class EditPage extends StatefulWidget {
  final Map task;
  const EditPage({required this.task, super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool isChecked = false;
  final finished = ["Task finished?", "Task finished!"];
  late TextEditingController _taskController = TextEditingController();
  late TextEditingController _descController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController(text: widget.task['title']);
    _descController = TextEditingController(text: widget.task['description']);
    final DateTime parsedDate = DateTime.parse(widget.task['ddate']);
    final String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
    _dateController = TextEditingController(text: formattedDate);
    isChecked = widget.task['status'];
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime now = DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text(
          "Edit Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Task Title
            const Text(
              'What is to be done?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _taskController,
              decoration: const InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Description
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Enter task details",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Due Date
            const Text(
              'Due date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(
                hintText: 'Pick a date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Status Checkbox
            const Text(
              'Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text(
                  finished[isChecked ? 1 : 0],
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            //Update button
            Center(
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var data = {
                        "taskId": widget.task['_id'],
                        "userId": widget.task['userId'],
                        "title": _taskController.text,
                        "ddate": DateFormat('dd-MM-yyyy')
                            .parse(_dateController.text)
                            .toIso8601String(),
                        "description": _descController.text,
                        "status": isChecked?true:false
                      };

                      //Updating the task and getting status
                      final response = await Update.updateTask(data);

                      if (response != null && response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task updated successfully!')),
                        );
                        Navigator.pop(context);
                      } else if (response != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed: ${response.body}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No response from server.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
