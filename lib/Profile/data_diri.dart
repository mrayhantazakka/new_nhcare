import 'package:flutter/material.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class dataDiri extends StatefulWidget {
  const dataDiri({Key? key}) : super(key: key);
  @override
  _dataDiriState createState() => _dataDiriState();
}

class _dataDiriState extends State<dataDiri> {
  User? _user;
  late TextEditingController _jawabanController;
  late TextEditingController _namaDonaturController;
  late TextEditingController _alamatController;
  late TextEditingController _nomorHandphoneController;
  late TextEditingController _jenisKelaminController;

  File? _image;

  @override
  void initState() {
    super.initState();
    _jawabanController = TextEditingController();
    _namaDonaturController = TextEditingController();
    _alamatController = TextEditingController();
    _nomorHandphoneController = TextEditingController();
    _jenisKelaminController = TextEditingController();
    _getUserData();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
    User? user = await DatabaseHelper.getUserFromLocal(token);
    if (user != null) {
      setState(() {
        _user = user;
        _jawabanController.text = _user?.jawaban ?? '';
        _alamatController.text = _user?.alamat ?? '';
        _namaDonaturController.text = _user?.nama_donatur ?? '';
        _nomorHandphoneController.text = _user?.nomor_handphone ?? '';
        _jenisKelaminController.text = _user?.jenis_kelamin ?? '';
      });
    }
  }

  @override
  void dispose() {
    _jawabanController.dispose();
    _alamatController.dispose();
    _namaDonaturController.dispose();
    _nomorHandphoneController.dispose();
    _jenisKelaminController.dispose();
    super.dispose();
  }

  void _updateUserData() async {
  if (_jawabanController.text.isNotEmpty ||
      _alamatController.text.isNotEmpty ||
      _namaDonaturController.text.isNotEmpty ||
      _nomorHandphoneController.text.isNotEmpty ||
      _jenisKelaminController.text.isNotEmpty) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      // Simpan data ke SQLite
      await DatabaseHelper.updateUserLocal(
          token,
          _jawabanController.text,
          _alamatController.text,
          _namaDonaturController.text,
          _nomorHandphoneController.text,
          _jenisKelaminController.text);

      // Kirim data ke MySQL
      String url = "${IpConfig.baseUrl}/api/updateDntr";
      print('URL: $url');
      print('Token: $token');
      print('Data: ${{
        'jawaban': _jawabanController.text,
        'alamat': _alamatController.text,
        'nama_donatur': _namaDonaturController.text,
        'nomor_handphone': _nomorHandphoneController.text,
        'jenis_kelamin': _jenisKelaminController.text,
      }}');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {
          'jawaban': _jawabanController.text,
          'alamat': _alamatController.text,
          'nama_donatur': _namaDonaturController.text,
          'nomor_handphone': _nomorHandphoneController.text,
          'jenis_kelamin': _jenisKelaminController.text,
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  Future<void> removeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profileImagePath');
    setState(() {
      _image = null;
    });
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
                  height: 700,
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
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 20.0)),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: const Icon(Icons.camera),
                                      title: const Text('Kamera'),
                                      onTap: () {
                                        getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.image),
                                      title: const Text('Galeri'),
                                      onTap: () {
                                        getImage(ImageSource.gallery);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.delete),
                                      title: const Text('Hapus Foto'),
                                      onTap: () {
                                        removeImage();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: const Color(0xFFA4C751),
                          backgroundImage:
                              _image != null ? FileImage(_image!) : null,
                          child: _image == null
                              ? Icon(Icons.camera_alt,
                                  color: Colors.white, size: 40)
                              : null,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: _namaDonaturController,
                          decoration: InputDecoration(
                            hintText: 'Nama',
                            hintStyle: const TextStyle(fontSize: 14.0),
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                          ),
                        ),
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
                            hintStyle: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true, // Set filled to true
                            fillColor: const Color(0xFFEAEAEA),
                            contentPadding: const EdgeInsets.symmetric(
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
                          controller: _nomorHandphoneController,
                          decoration: InputDecoration(
                            hintText: 'Phone',
                            hintStyle: const TextStyle(fontSize: 14.0),
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),
                            contentPadding: const EdgeInsets.symmetric(
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
                          controller: _alamatController,
                          decoration: InputDecoration(
                            hintText: 'alamat',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: TextFormField(
                          controller: TextEditingController(
                              text: _user?.pertanyaan ?? ''),
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: 'Pertanyaan',
                            hintStyle: const TextStyle(
                                fontSize: 14.0, color: Colors.grey),
                            prefixIcon: Icon(Icons.question_answer),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                            filled: true,
                            fillColor: const Color(0xFFEAEAEA),
                            contentPadding: const EdgeInsets.symmetric(
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
                          controller: _jawabanController,
                          decoration: InputDecoration(
                            hintText: 'Jawaban Keamanan',
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
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 15,
                        ),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFA4C751),
                              minimumSize: Size(345, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Edit',
                                style: TextStyle(color: Colors.white)),
                            onPressed: _updateUserData),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ));
  }
}
