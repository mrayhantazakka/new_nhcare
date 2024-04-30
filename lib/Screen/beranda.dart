import 'package:flutter/material.dart';

class beranda extends StatefulWidget {
  const beranda({Key? key}) : super(key: key);

  @override
  _berandaState createState() => _berandaState();
}

class _berandaState extends State<beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // child: Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: AssetImage('assets/img/bg.png'),
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Image.asset('assets/img/logo_nhcare.png', height: 50),
              Padding(padding: EdgeInsets.only(top: 20)),
              Container(
                width: 445,
                height: 95,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFA4C751),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 209, 209, 209).withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Text(
                  "TOTAL DANA DONASI :",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Card Donasi diklik');
                        },
                        child: Container(
                          transform: Matrix4.translationValues(0.1, -5.0, 0.0),
                          child: Card(
                            elevation: 9,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/ic_donasi.png',
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Donasi',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 22),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Card Anak Asuh diklik');
                        },
                        child: Container(
                          transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                          child: Card(
                            elevation: 9,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/ic_anak.png',
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Anak Asuh',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 22),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Card Alokasi Dana diklik');
                        },
                        child: Container(
                          transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                          child: Card(
                            elevation: 9,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/ic_alokasi.png',
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8.0, bottom: 8.0),
                                  child: Text(
                                    'Alokasi Dana',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 22),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          print('Card Program diklik');
                        },
                        child: Container(
                          transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                          child: Card(
                            elevation: 9,
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/img/ic_program.png',
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Program',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Text(
                      "Artikel",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: 10,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Container(
                    height: 350,
                    width: 200,
                    margin: EdgeInsets.only(right: 35),
                    child: Center(
                      child: Text("card $index"),
                    ),
                    color: Color(0xFFA4C751),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Text(
                      "Video",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                itemCount: 5,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  height: 250,
                  margin: EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: Center(
                    child: Text("video $index"),
                  ),
                  color: Color(0xFFA4C751),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
