import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:nhcoree/Profile/data_diri.dart';
import 'package:nhcoree/Profile/pusat_bantuan.dart';
import 'package:nhcoree/Profile/riwayat_donasi.dart';
import 'package:nhcoree/Profile/ubah_kata_sandi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhcoree/Auth/Login.dart';
import 'package:path_provider/path_provider.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  late String _namaDonatur = '';
  late String _email = '';
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    loadProfileImage();
    _loadUserData();
  }

  Future<void> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profileImagePath');
    print("Image path from prefs: $imagePath"); // Debug print
    if (imagePath != null) {
      File profileImage = File(imagePath);
      print("File exists: ${await profileImage.exists()}"); // Debug print
      if (await profileImage.exists()) {
        setState(() {
          _profileImage = profileImage;
        });
      }
    } else {
      setState(() {
        _profileImage = null;
      });
    }
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      User? user = await DatabaseHelper.getUserFromLocal(token);
      if (user != null) {
        setState(() {
          _namaDonatur = user.nama_donatur!;
          _email = user.email!;
        });
      }
    }
  }

  void _gotoDataDiriPage(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dataDiri()),
    );
    _loadUserData();
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
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
        automaticallyImplyLeading: false, // Menghapus tombol back
        title: const Text(
          'PROFILE',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA4C751)),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Menengahkan judul
      ),
      body: Container(
        child: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                // const Padding(padding: EdgeInsets.only(top: 50)),
                // const Text('PROFILE',
                //     style: TextStyle(
                //         fontSize: 24,
                //         color: Color(0xFFA4C751),
                //         fontWeight: FontWeight.bold)),
                const Padding(padding: EdgeInsets.only(top: 20)),
                Container(
                  width: 360,
                  height: 250,
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
                      CircleAvatar(
                        radius: 75,
                        backgroundColor: const Color(0xFFA4C751),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Text(
                                _namaDonatur
                                    .split(" ")
                                    .where((name) => name.isNotEmpty)
                                    .map((name) =>
                                        name.substring(0, 1).toUpperCase())
                                    .join(""),
                                style: const TextStyle(
                                    fontSize: 36, color: Colors.white),
                              )
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$_namaDonatur',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_email',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: const EdgeInsets.only(top: 30)),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _gotoDataDiriPage(context);
                      },
                      child: Container(
                        width: 360,
                        height: 60,
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
                        padding: const EdgeInsets.only(left: 20),
                        child: const Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Data Diri',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const riwayatDonasi()),
                        );
                      },
                      child: Container(
                        width: 360,
                        height: 60,
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
                        padding: const EdgeInsets.only(left: 20),
                        child: const Row(
                          children: [
                            Icon(Icons.history, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Riwayat Donasi',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ubahKataSandi()),
                        );
                      },
                      child: Container(
                        width: 360,
                        height: 60,
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
                        padding: const EdgeInsets.only(left: 20),
                        child: const Row(
                          children: [
                            Icon(Icons.settings, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Ubah Password',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const pusatBantuan()),
                        );
                      },
                      child: Container(
                        width: 360,
                        height: 60,
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
                        padding: const EdgeInsets.only(left: 20),
                        child: const Row(
                          children: [
                            Icon(Icons.headphones_rounded, color: Colors.black),
                            SizedBox(width: 10),
                            Text(
                              'Pusat Bantuan',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 360,
                  height: 80,
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      maximumSize: const Size(360, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.logout, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
