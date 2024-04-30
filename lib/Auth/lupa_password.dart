import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: ForgotPasswordPage(),
  ));
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  late TextEditingController _answerController;
  late TextEditingController _passwordController;

  bool _verificationSuccess = false;

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

    final response = await http.post(
      Uri.parse('http://localhost:8000/api/auth/reset-password'),
      body: {
        'email': email,
        'answer': answer,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          _verificationSuccess = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message']),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi.'),
        ),
      );
    }
  }

  Future<void> _resetPassword(BuildContext context) async {
    String email = _emailController.text;
    String newPassword = _passwordController.text;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password berhasil direset.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Image.asset('assets/img/logo.jpg', height: 78, width: 65),
                  SizedBox(height: 50),
                  Container(
                    width: 380,
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
                          Padding(padding: EdgeInsets.all(10)),
                          Center(
                            child: Text(
                              "RESET PASSWORD",
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 20),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Color(0xFFEAEAEA),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20)),
                          TextFormField(
                            controller: _answerController,
                            style: TextStyle(fontSize: 14.0),
                            decoration: InputDecoration(
                              hintText: 'Jawaban Pertanyaan Keamanan',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Color(0xFFEAEAEA),
                            ),
                          ),
                          SizedBox(height: 20),
                          if (!_verificationSuccess)
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
                              child: Text('Kirim Email Reset Password',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          if (_verificationSuccess)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height:20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: TextStyle(fontSize: 14.0),
                                  decoration: InputDecoration(
                                    hintText: 'Password Baru',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    filled: true,
                                    fillColor: Color(0xFFEAEAEA),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _resetPassword(context);
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
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ],
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
