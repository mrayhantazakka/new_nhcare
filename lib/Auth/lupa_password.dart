import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nhcoree/Database/IpConfig.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  late TextEditingController _answerController;
  late TextEditingController _passwordController;
  bool _isPasswordVisible = false; // Untuk mengontrol visibilitas password

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _answerController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Future<void> _validateData(BuildContext context) async {
    String email = _emailController.text;
    String answer = _answerController.text;
    String newPassword = _passwordController.text;

    final response = await http.post(
      Uri.parse("${IpConfig.baseUrl}/api/resetpassword"),
      body: {
        'email': email,
        'answer': answer,
        'password': newPassword, // Kirim password baru ke server
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
        ),
      );
      if (data['message'] == 'Password berhasil diubah') {
        // Jika berhasil, kembali ke halaman login
        Navigator.pop(context);
        _showSuccessDialog(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mereset password'),
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Password Berhasil dirubah"),
        content: Text("Silahkan Login Menggunakan Password Baru Anda."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img/logo.jpg', height: 78, width: 65),
                SizedBox(height: 50),
                Container(
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "RESET PASSWORD",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8F9BA1),
                            ),
                          ),
                        ),
                        Divider(color: Colors.grey, thickness: 2),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                                                       filled: true,
                            fillColor: Color(0xFFEAEAEA),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _answerController,
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Jawaban Keamanan',
                            prefixIcon: Icon(Icons.security),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                                                       filled: true,
                            fillColor: Color(0xFFEAEAEA),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible, // Visibilitas password
                          style: TextStyle(fontSize: 14.0),
                          decoration: InputDecoration(
                            hintText: 'Password Baru Anda',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            _validateData(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFFA4C751),
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Reset Password',
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _answerController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

