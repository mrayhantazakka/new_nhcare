import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class pusatBantuan extends StatelessWidget {
  const pusatBantuan({super.key});

  @override
  Widget build(BuildContext context) {
    final Uri whatsApp = Uri.parse(
        'https://wa.me/6281217329234?text=Saya%20mengalami%20masalah%20pada%20saat%20:');
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/notifikasi.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(children: [
              Padding(padding: EdgeInsets.only(top: 180)),
              Image.asset('assets/img/bantuan.png',
                  height: 251.61, width: 290.63),
              SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text(
                  'Mengalami masalah dalam penggunaan aplikasi? Tekan hubungi, untuk menghubungi admin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 246, 246, 246),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFFFFF),
                        minimumSize: Size(170, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Hubungi',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      onPressed: () async {
                        launchUrl(whatsApp);
                      }),
                  SizedBox(width: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFFFFFFFF)),
                      minimumSize: Size(170, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Kembali',
                        style: TextStyle(
                            color: Color(0xFFFFFFFFF),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
