import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhcoree/Auth/Login.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:nhcoree/Screen/datadiri.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    void _gotoDataDiriPage(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DataDiri()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
           decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 50.0,
                horizontal: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'PROFIL',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA4C751),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/img/user.png'),
                  ),
                  SizedBox(height: 20.0),
                  FutureBuilder<User?>(
                    future: _getUserFromLocal(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.hasData && snapshot.data != null) {
                            User user = snapshot.data!;
                            return Column(
                              children: [
                                Text(
                                  'Nama: ${user.username}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Email: ${user.email}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Text(
                              'Data pengguna tidak ditemukan.',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  _buildProfileButton(
                    context,
                    icon: Icons.person,
                    text: 'Data Diri',
                    onPressed: () {
                      _gotoDataDiriPage(context);
                    },
                  ),
                  _buildProfileButton(
                    context,
                    icon: Icons.history,
                    text: 'Riwayat Donasi',
                    onPressed: () {
                      // Implement logic for Button 2
                    },
                  ),
                  _buildProfileButton(
                    context,
                    icon: Icons.phone,
                    text: 'Telepon',
                    onPressed: () {
                      // Implement logic for Button 3
                    },
                  ),
                  _buildProfileButton(
                    context,
                    icon: Icons.settings,
                    text: 'Pengaturan',
                    onPressed: () {
                      // Implement logic for Button 4
                    },
                  ),
                  _buildProfileButton(
                    context,
                    icon: Icons.logout,
                    text: 'Keluar',
                    onPressed: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, {required IconData icon, required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          minimumSize: Size(double.infinity, 50),
          alignment: Alignment.centerLeft,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        icon: Icon(icon, color: Colors.black),
        label: Text(text),
        onPressed: onPressed,
      ),
    );
  }

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DatabaseHelper.getUserFromLocal(token);
    } else {
      return null;
    }
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

