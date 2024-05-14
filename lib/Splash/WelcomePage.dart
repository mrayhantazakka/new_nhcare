import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFA4C751),
          image: DecorationImage(
            image: AssetImage('assets/img/loading_page.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Center(
                child: Image.asset(
                  'assets/img/lg_pth.png', // Pastikan Anda memiliki logo putih sesuai desain
                  height: MediaQuery.of(context).size.height * 0.25, // Tinggi yang lebih besar
                  width: MediaQuery.of(context).size.width * 0.5, // Lebar yang lebih besar
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'SELAMAT DATANG',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFA4C751),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'NHCARE merupakan aplikasi yang dibuat untuk memudahkan donatur dalam melakukan donasi untuk panti asuhan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFFA4C751),
                          minimumSize: Size(140, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFFA4C751)),
                          minimumSize: Size(140, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFA4C751),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

