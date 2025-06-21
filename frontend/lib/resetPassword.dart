import 'package:flutter/material.dart';
import 'dart:convert';
import 'service/Reset_HTTP.dart'; // Adjust the path as needed

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool showOldPassword = true;
  bool showNewPassword = true;
  bool showConfirmPassword = true;

  Widget buildField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    VoidCallback? toggleVisibility,
    bool showToggle = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: const OutlineInputBorder(),
            suffixIcon: showToggle
                ? IconButton(
              icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              onPressed: toggleVisibility,
            )
                : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Change Your Password',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            buildField(label: 'Username', controller: userIdController),

            buildField(
              label: 'New Password',
              controller: newPasswordController,
              obscure: showNewPassword,
              showToggle: true,
              toggleVisibility: () {
                setState(() {
                  showNewPassword = !showNewPassword;
                });
              },
            ),

            buildField(
              label: 'Confirm Password',
              controller: confirmPasswordController,
              obscure: showConfirmPassword,
              showToggle: true,
              toggleVisibility: () {
                setState(() {
                  showConfirmPassword = !showConfirmPassword;
                });
              },
            ),

            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed : () async {
                    final userId = userIdController.text.trim();
                    final newPassword = newPasswordController.text.trim();
                    final confirmPassword = confirmPasswordController.text.trim();

                    if (userId.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill out all fields")),
                      );
                      return;
                    }

                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("New passwords do not match")),
                      );
                      return;
                    }

                    final response = await Reset.resetPassword({
                      "userId": userId,
                      "newPassword": newPassword,
                    });

                    if (response != null && response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Password updated successfully")),
                      );
                      Navigator.pop(context);
                    } else {
                      final msg = response == null
                          ? "Failed to connect to server"
                          : jsonDecode(response.body)['message'] ?? "Error resetting password";
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reset',
                    style: TextStyle(fontSize: 18),
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
