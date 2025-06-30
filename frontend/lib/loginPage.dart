import 'package:flutter/material.dart';
import 'resetPassword.dart';
import 'service/Login_HTTP.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = true;
  final TextEditingController userId = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    userId.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Center(
              child: Text(
                'Welcome Back!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),

            // Username Field
            const Text('Username', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: userId,
              decoration: const InputDecoration(
                hintText: "Enter your username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Password Field
            const Text('Password', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextFormField(
              controller: password,
              obscureText: showPassword,
              decoration: InputDecoration(
                hintText: "Enter your password",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                ),
              ),
            ),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PasswordReset()));
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final userName = userId.text.trim();
                  final Password = password.text.trim();

                  if (userName.isEmpty || Password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter all fields")),
                    );
                    return;
                  }

                  try {
                    final result = await Http.loginUser(userName, Password);
                    final status = result['statusCode'];
                    final data = result['response'];

                    if (status == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login Successful")),
                      );
                      Navigator.pushReplacementNamed(context, '/list');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Login Failed: ${data['message']}")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
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
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Register Option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("New User?", style: TextStyle(fontSize: 14)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
