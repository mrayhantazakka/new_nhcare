import 'package:flutter/material.dart';

class notifikasi extends StatefulWidget {
  const notifikasi({super.key});

  @override
  State<notifikasi> createState() => _notifikasiState();
}

class _notifikasiState extends State<notifikasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Center(child: Text('Ini Notifikasi', style: TextStyle(fontSize: 40))),
    );
  }
}
