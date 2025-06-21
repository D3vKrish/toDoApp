import 'package:flutter/material.dart';
import 'package:to_do_project/splashPage.dart';
import 'loginPage.dart';
import 'registerPage.dart';
import 'listPage.dart';
import 'resetPassword.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/list': (context) => const ListPage(),
        '/reset': (context) => const PasswordReset()
      },
    );
  }
}
