import 'package:flutter/material.dart';
import 'package:nhcoree/Screen/acara.dart';
import 'package:nhcoree/Screen/beranda.dart';
import 'package:nhcoree/Screen/notifikasi.dart';
import 'package:nhcoree/Profile/profile.dart';

class homePage extends StatefulWidget {
  const homePage({Key? key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedTabIndex = 1;
  int _previousTabIndex = 1; // Menyimpan indeks halaman sebelumnya

  void _onNavBarTapped(int index) {
    setState(() {
      _previousTabIndex = _selectedTabIndex; // Simpan indeks sebelumnya
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listPage = <Widget>[
      const AcaraScreen(),
      const Beranda(),
      const Notifikasi(),
      const profile(),
    ];

    final bottomNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(Icons.dashboard), label: 'Acara'),
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notifications), label: 'Notifikasi'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    final bottomNavBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      items: bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      unselectedItemColor: const Color(0xFFA6A5A5),
      selectedItemColor: const Color(0xFFA4C751),
      onTap: _onNavBarTapped,
    );

    return WillPopScope(
      onWillPop: () async {
        if (_selectedTabIndex != 1) {
          setState(() {
            _selectedTabIndex = 1; // Kembali ke indeks Beranda
          });
          return false; // Mengembalikan false agar tidak keluar dari aplikasi
        }
        return true; // Keluar dari aplikasi jika berada di Beranda
      },
      child: Scaffold(
        body: Center(
          child: listPage[_selectedTabIndex],
        ),
        bottomNavigationBar: bottomNavBar,
      ),
    );
  }
}
