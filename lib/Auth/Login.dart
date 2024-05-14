import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Home.dart';
import 'package:nhcoree/Models/login_response.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
    // Cek jika token sudah tersimpan, maka langsung arahkan ke halaman Home
    checkLoginStatus();
  }

  // Fungsi untuk melakukan pengecekan status login saat aplikasi dimulai
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage()),
      );
    }
  }

  // Metode untuk melakukan login
  Future<void> _login() async {
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
      LoginResponse loginResponse = LoginResponse.fromMap(responseData);
      print("message : ${loginResponse.message}");
      print("status : ${loginResponse.status}");
      // LoginResponse loginResponse = LoginResponse.fromMap(responseData);
      // print("Pesannya : ${loginResponse.message}");
      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          String token = responseData['token'];

          // Simpan token ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          User? loggedInUser = await getUserFromToken(responseData['token']);

          if (loggedInUser != null) {
            await DatabaseHelper.saveUser(loggedInUser, responseData['token']);
            print(
                "Data pengguna tersimpan di SQLite: Email: ${loggedInUser.email}, Username: ${loggedInUser.username}");
            ("Anda berhasil login.", loggedInUser, responseData['token']);
          }

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Login Berhasil"),
              content: Text("Selamat datang, ${email}"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => homePage()),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Login Gagal"),
              content: Text(responseData['message']),
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
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Login Gagal"),
            content: Text("Silakan Coba Lagi"),
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
        print("HTTP Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error: $error");
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
      // Pastikan responseData berupa objek JSON yang sesuai dengan struktur User
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

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFA4C751), // Warna hijau untuk status bar
    ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFA4C751), // Warna hijau untuk AppBar
        elevation: 0, // Hilangkan bayangan di bawah AppBar
        toolbarHeight: 0, // Tinggi AppBar diatur menjadi 0 untuk menyembunyikannya
      ),
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
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
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Image.asset('assets/img/logo.jpg', height: 78, width: 65),
                  SizedBox(height: 50),
                  Container(
                    width: screenWidth * 0.9, // Responsive width
                    height: 380,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40), // Border lebih lebar
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
                          Padding(
                            padding: EdgeInsets.only(
                                top: 10, left: 10, right: 10, bottom: 20),
                          ),
                          TextFormField(
                            validator: (val) {
                              return val!.isEmpty ? "Email harus diisi" : null;
                            },
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 14.0),
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true, // Set filled to true
                              fillColor: Color(0xFFEAEAEA),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20)),
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
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true, // Set filled to true
                              fillColor: Color(0xFFEAEAEA),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, right: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () {
                                  // Navigasi ke halaman lupa password
                                  Navigator.pushNamed(
                                      context, '/forgotPassword');
                                },
                                child: Text(
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFA4C751),
                          minimumSize: Size(screenWidth * 0.4, 60), // Responsive size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('MASUK', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          if (_keyForm.currentState!.validate()) {
                            _login();
                          }
                        }),
                      SizedBox(width: 20),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFA4C751)),
                          minimumSize: Size(screenWidth * 0.4, 60), // Responsive size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('KEMBALI', style: TextStyle(color: Color(0xFFA4C751))),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loadingPage');
                        },
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Belum punya akun? '),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
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
    );
  }
}
