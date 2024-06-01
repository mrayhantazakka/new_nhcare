import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/IpConfig.dart';
import 'dart:convert';

import 'package:nhcoree/Profile/profile.dart';

class ubahKataSandi extends StatefulWidget {
  const ubahKataSandi({super.key});

  @override
  State<ubahKataSandi> createState() => _ubahKataSandiState();
}

class _ubahKataSandiState extends State<ubahKataSandi> {
  bool hiden = true;
  void visible() {
    setState(() {
      hiden = !hiden;
    });
  }

  TextEditingController answerController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String question = '';
  String email = '';
  String message = '';
  bool showEmailButton = true;
  bool showAnswerButton = false;
  bool showPasswordForm = false;

  Future<void> verifyEmail() async {
    final response = await http.post(
      Uri.parse("${IpConfig.baseUrl}/api/verify-email"),
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        question = responseData['question'];
        showEmailButton = false;
        showAnswerButton = true;
        message = '';
      });
    } else {
      setState(() {
        // message = 'Email not found';
        _showMessageDialog(context, 'Email Tidak Ditemukan');
      });
    }
  }

  Future<void> verifyAnswer() async {
    final response = await http.post(
      Uri.parse("${IpConfig.baseUrl}/api/verify-answer"),
      body: {
        'email': email,
        'answer': answerController.text,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        message = 'Answer is correct';
        showAnswerButton = false;
        showPasswordForm = true;
        message = '';
      });
    } else {
      setState(() {
        _showMessageDialog(context, 'Jawaban Salah!');
      });
    }
  }

  Future<void> resetPassword() async {
    final response = await http.post(
      Uri.parse("${IpConfig.baseUrl}/api/reset-password"),
      body: {
        'email': email,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _showMessageDialog(context, 'Password Berhasil Diubah');
      });
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const profile()),
      );
    } else {
      setState(() {
        _showMessageDialog(context, 'Password Gagal Diubah');
      });
    }
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pesan'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UBAH KATA SANDI',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA4C751)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              Container(
                width: 360,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showEmailButton)
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Masukkan Email Anda',
                          hintStyle: const TextStyle(fontSize: 14.0),
                          prefixIcon: const Icon(Icons.assignment_ind),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: const Color(0xFFEAEAEA),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    if (question.isNotEmpty && showAnswerButton)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: question,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: 'Question',
                              prefixIcon: const Icon(Icons.question_answer),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          TextFormField(
                            controller: answerController,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Jawaban Anda',
                              hintStyle: const TextStyle(fontSize: 14.0),
                              prefixIcon: const Icon(Icons.edit),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          if (showAnswerButton)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA4C751),
                                minimumSize: const Size(345, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: verifyAnswer,
                              child: const Text('Verifikasi Jawaban',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                        ],
                      ),
                    if (showPasswordForm)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            autofocus: true,
                            controller: passwordController,
                            obscureText: hiden,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Password Baru',
                              suffixIcon: IconButton(
                                icon: Icon(hiden
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: visible,
                              ),
                              prefixIcon: const Icon(Icons.lock_open),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 15)),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: 'Konfirmasi Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: const Color(0xFFEAEAEA),
                            ),
                            obscureText: true,
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA4C751),
                              minimumSize: const Size(345, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: resetPassword,
                            child: const Text('Ubah Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ),
                        ],
                      ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    if (message.isNotEmpty) Text(message),
                    if (showEmailButton)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA4C751),
                          minimumSize: const Size(345, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: verifyEmail,
                        child: const Text('Verifikasi Email',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
