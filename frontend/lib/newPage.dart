import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'service/Post_HTTP.dart';

class NewPage extends StatefulWidget {
  final userId;
  const NewPage({super.key, required this.userId});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController ddate = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    desc.dispose();
    ddate.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        ddate.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text(
          "New Task",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title
            const Text(
              'What is to be done?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: name,
              decoration: const InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: desc,
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: ddate,
              readOnly: true,
              onTap: _selectDate,
              decoration: const InputDecoration(
                hintText: 'Pick a date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 40),

            // Create Button
            Center(
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      var date;
                      try {
                        date = DateFormat('dd-MM-yyyy').parse(ddate.text).toIso8601String();
                      } catch (e) {
                        date = DateTime.now().toIso8601String(); // or handle error
                      }
                      var data = {
                        "userId": widget.userId,
                        "title": name.text,
                        "ddate": date,
                        "description": desc.text
                      };

                      final response = await Http.createTask(data);
                      if (response != null && response.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Task created successfully!')),
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
                      print("Exception: $e");
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
                    "Create",
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
