import 'package:flutter/material.dart';

class acara extends StatefulWidget {
  const acara({super.key});

  @override
  State<acara> createState() => _acaraState();
}

class _acaraState extends State<acara> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Ini Acara', style: TextStyle(fontSize: 40))),
    );
  }
}
