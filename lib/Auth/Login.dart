import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Home.dart';
// import 'package:nhcoree/Models/login_response.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  bool _isLoading = false;

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  // Metode untuk melakukan login
  Future<void> _login() async {
    _toggleLoading(true);
    String email = _emailController.text;
    String password = _passwordController.text;

    String url = "${IpConfig.baseUrl}/api/login";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          String token = responseData['token'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          User? loggedInUser = await getUserFromToken(responseData['token']);

          if (loggedInUser != null) {
            await DatabaseHelper.saveUser(loggedInUser, responseData['token']);
          }

          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Sukses!',
              message: 'Selamat Datang, ${email}',
              contentType: ContentType.success,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => homePage()),
          );
        } else {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Gagal!',
              message: responseData['message'],
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Kesalahan!',
            message: 'Silakan coba lagi, Periksa Email dan Password Anda!',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (error) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Terjadi kesalahan: $error',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } finally {
      _toggleLoading(false);
    }
  }

  bool hiden = true;
  void visible() {
    setState(() {
      hiden = !hiden;
    });
  }

  Future<User?> getUserFromToken(String token) async {
    String url = "${IpConfig.baseUrl}/api/get_user";

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    print("Response getUserFromToken: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      print("Failed to get user data: ${response.statusCode}");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFFA4C751),
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA4C751),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _keyForm,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    const Padding(
                      padding: EdgeInsets.only(top: 50),
                    ),
                    Image.asset('assets/img/logo.jpg', height: 78, width: 65),
                    const SizedBox(height: 50),
                    Container(
                      width: screenWidth * 0.9, // Responsive width
                      height: 380,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Padding(padding: EdgeInsets.all(10)),
                            const Center(
                              child: Text(
                                "MASUK",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF8F9BA1),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Container(
                                height: 3,
                                color: Colors.grey,
                                width: 105,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                  top: 10, left: 10, right: 10, bottom: 20),
                            ),
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Email harus diisi"
                                    : null;
                              },
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                prefixIcon: const Icon(Icons.account_circle),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: const Color(0xFFEAEAEA),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            TextFormField(
                              validator: (val) {
                                return val!.isEmpty
                                    ? "Password harus diisi"
                                    : null;
                              },
                              controller: _passwordController,
                              obscureText: hiden,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: IconButton(
                                  icon: Icon(hiden
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: visible,
                                ),
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true, // Set filled to true
                                fillColor: const Color(0xFFEAEAEA),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 10),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Navigasi ke halaman lupa password
                                    Navigator.pushNamed(
                                        context, '/forgotPassword');
                                  },
                                  child: const Text(
                                    'Lupa Password?',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA4C751),
                          minimumSize:
                              Size(screenWidth * 0.9, 60), // Responsive size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text('MASUK',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            _login();
                          }
                        }),
                    const Padding(padding: EdgeInsets.only(top: 20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Belum punya akun? '),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'Daftar sekarang',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF004D40),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.2),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }
}
