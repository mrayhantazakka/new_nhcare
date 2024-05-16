import 'package:flutter/material.dart';

class riwayatDonasi extends StatefulWidget {
  const riwayatDonasi({super.key});

  @override
  State<riwayatDonasi> createState() => _riwayatDonasiState();
}

class _riwayatDonasiState extends State<riwayatDonasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Donasi',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // backgroundColor: Color(0xFFA4C751),
      ),
    );
  }
}
