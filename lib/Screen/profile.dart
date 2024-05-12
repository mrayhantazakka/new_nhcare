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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 50.0,
            horizontal: 25.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50, // Adjust the size of the avatar as needed
                      backgroundImage: AssetImage('assets/images/profile.jpg'), // Set the image from local assets
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    FutureBuilder<User?>(
                      future: _getUserFromLocal(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    'Email: ${user.email}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return Text(
                                'Data pengguna tidak ditemukan.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _gotoDataDiriPage(context);
                      },
                      child: Text('Data Diri'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement logic for Button 2
                      },
                      child: Text('Riwayat Donasi'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement logic for Button 3
                      },
                      child: Text('Pengaturan'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _logout(context); // Call logout function
                      },
                      child: Text('Logout'), // Text for Logout button
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> _getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      return DatabaseHelper.getUserFromLocal(token);
    } else {
      // Handle case where token is not available
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
