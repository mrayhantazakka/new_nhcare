import 'package:flutter/material.dart';
import 'package:nhcoree/Screen/acara.dart';
import 'package:nhcoree/Screen/beranda.dart';
import 'package:nhcoree/Screen/notifikasi.dart';
import 'package:nhcoree/Screen/profile.dart';

// class homePage extends StatelessWidget {
//   const homePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final UserData userData =
//         ModalRoute.of(context)!.settings.arguments as UserData;

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Selamat datang, ${userData.fullname}!',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Text('Username: ${userData.username}'),
//             SizedBox(height: 5),
//             Text('Email: ${userData.email}'),
//             SizedBox(height: 5),
//             Text('Phone: ${userData.phone}'),
//             SizedBox(height: 5),
//             Text('Alamat: ${userData.alamat}'),
//             SizedBox(height: 5),
//             Text('Agama: ${userData.agama}'),
//             SizedBox(height: 5),
//             Text('Gender: ${userData.gender}'),
//           ],
//         ),
//       ),
//     );
//   }
// }

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  int _selectedTabIndex = 1;

  void _onNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[
      acara(),
      beranda(),
      notifikasi(),
      profile(),
    ];

    final _bottomNavBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Acara'),
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.notifications), label: 'Notifikasi'),
      const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ];

    final _bottomNavBar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      items: _bottomNavBarItems,
      currentIndex: _selectedTabIndex,
      unselectedItemColor: Color(0xFFA6A5A5),
      selectedItemColor: Color(0xFFA4C751),
      onTap: _onNavBarTapped,
    );

    return Scaffold(
      body: Center(
        child: _listPage[_selectedTabIndex],
      ),
      bottomNavigationBar: _bottomNavBar,
    );
  }
}
