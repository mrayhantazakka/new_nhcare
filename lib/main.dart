import 'package:flutter/material.dart';
import 'package:nhcoree/Home.dart';
import 'package:nhcoree/Auth/Login.dart';
import 'package:nhcoree/Splash/Splashscreen.dart';
import 'package:nhcoree/Auth/Registerasi.dart';
import 'package:nhcoree/Splash/loading_page.dart';
import 'package:nhcoree/Auth/lupa_password.dart';

void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NURUL HUSNA',
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/register': (context) => daftar(),
        '/login': (context) => LoginPage(),
        '/home': (context) => homePage(),
        '/loadingPage': (context) => loadingPage(),
        '/forgotPassword': (context) => ForgotPasswordPage(),
        
      }, /*  */
    );
  }
}
