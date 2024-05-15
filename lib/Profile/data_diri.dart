import 'package:flutter/material.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class dataDiri extends StatefulWidget {
  const dataDiri({Key? key}) : super(key: key);
  @override
  _dataDiriState createState() => _dataDiriState();
}

class _dataDiriState extends State<dataDiri> {
  late User? _user;
  late TextEditingController _answerController;
  late TextEditingController _usernameController;
  late TextEditingController _fullnameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _answerController = TextEditingController();
    _usernameController = TextEditingController();
    _fullnameController = TextEditingController();
    _phoneController = TextEditingController();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    User? user = await DatabaseHelper.getUserFromLocal(token);
    if (user != null) {
      setState(() {
        _user = user;
        _answerController.text = _user?.answer ?? '';
        _usernameController.text = _user?.username ?? '';
        _fullnameController.text = _user?.fullname ?? '';
        _phoneController.text = _user?.phone ?? '';
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _usernameController.dispose();
    _fullnameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _updateUserData() async {
    if (_answerController.text.isNotEmpty ||
        _usernameController.text.isNotEmpty ||
        _fullnameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null) {
        // Simpan data ke SQLite
        await DatabaseHelper.updateUserLocal(
            token,
            _answerController.text,
            _usernameController.text,
            _fullnameController.text,
            _phoneController.text);

        // Kirim data ke MySQL
        String url = "${IpConfig.baseUrl}/api/update-profile";
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {
            'answer': _answerController.text,
            'username': _usernameController.text,
            'fullname': _fullnameController.text,
            'phone': _phoneController.text,
          },
        );

        if (response.statusCode == 200) {
          _showMessageDialog(context, 'Data berhasil diperbarui');
        } else {
          _showMessageDialog(context, 'Gagal memperbarui data');
        }
      } else {
        _showMessageDialog(context, 'Pengguna belum login');
      }
    } else {
      _showMessageDialog(context, 'Semua field harus diisi');
    }
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pesan'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
            'Data diri',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFA4C751)),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/new_bg.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 50)),
                Container(
                  width: 360,
                  height: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
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
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: Color(0xFFA4C751),
                        child: Text(
                          _user != null &&
                                  _user!.username != null &&
                                  _user!.username!.isNotEmpty
                              ? _user!.username!
                                  .split(" ")
                                  .map((name) =>
                                      name.substring(0, 2).toUpperCase())
                                  .join("")
                              : '',
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 20,
                        ),
                        child: TextFormField(
                          controller:
                              TextEditingController(text: _user?.email ?? ''),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true, // Set filled to true
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.assignment_ind),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: _fullnameController,
                          decoration: InputDecoration(
                            hintText: 'Fullname',
                            hintStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: TextEditingController(
                              text: _user?.question ?? ''),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Pertanyaan',
                            hintStyle:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                            prefixIcon: Icon(Icons.question_answer),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: _answerController,
                          decoration: InputDecoration(
                            hintText: 'Jawaban Keamanan',
                            hintStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.edit),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone',
                            hintStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: Color(0xFFEAEAEA),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFA4C751),
                              minimumSize: Size(345, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Edit',
                                style: TextStyle(color: Colors.white)),
                            onPressed: _updateUserData),
                      )
                      // OutlinedButton(
                      //   style: OutlinedButton.styleFrom(
                      //     side: BorderSide(color: Color(0xFFA4C751)),
                      //     minimumSize: Size(160, 60),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   child: Text('Kembali',
                      //       style: TextStyle(color: Color(0xFFA4C751))),
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/profile');
                      //   },
                      // ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
