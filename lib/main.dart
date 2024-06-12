import 'package:flutter/material.dart';
import 'package:nhcoree/Home.dart';
import 'package:nhcoree/Auth/Login.dart';
import 'package:nhcoree/Profile/profile.dart';
import 'package:nhcoree/Screen/beranda.dart';
import 'package:nhcoree/Splash/LoadingPage.dart';
import 'package:nhcoree/Splash/Splashscreen.dart';
import 'package:nhcoree/Auth/Registerasi.dart';
import 'package:nhcoree/Auth/lupa_password.dart';
import 'package:nhcoree/Screen/programm.dart';
import 'package:nhcoree/Donasi/input_url_screen.dart';
import 'package:nhcoree/Donasi/snap_web_view_screen.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';


void main() {
  runApp(LoginApp());
}
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await DatabaseHelper.deleteDatabase(); // Hapus database sebelum inisialisasi
//   runApp(LoginApp());
// }

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NURUL HUSNA',
      initialRoute: '/',
      routes: {
        '/': (context) => const Splashscreen(),
        '/register': (context) => const daftar(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const homePage(),
        '/beranda': (context) => const Beranda(),
        '/loadingPage': (context) => LoadingPage(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/progamPage': (context) => Programm(),
        '/profile' : (context) => const profile(),
        SnapWebViewScreen.routeName: (context) => SnapWebViewScreen(),
        '/inputUrl': (context) => InputUrlScreen(),
      }, /*  */
    );
  }
}
