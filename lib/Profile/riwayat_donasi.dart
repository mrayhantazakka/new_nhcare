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
        title: const Text(
          'RIWAYAT DONASI',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA4C751)),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Menengahkan judul
      ),
    );
  }
}
