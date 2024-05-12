// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Auth/Login.dart';
import 'package:nhcoree/Database/IpConfig.dart';
// import 'package:nhcoree/Screen/UserData.dart';

class daftar extends StatefulWidget {
  const daftar({super.key});

  @override
  State<daftar> createState() => _daftarState();
}

class _daftarState extends State<daftar> {
  // TextEditingController _dateController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // TextEditingController _alamatController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _kofirmPwController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  String? _selectedQuestion;
  List<String> _questions = [
    'Surah Favorit',
    'Nama Sahabat Nabi',
    'Mukjizat Nabi',
    'Nama Nabi',
    'Tempat Favorit',
    'Apa Saja Untuk Diingat!'
  ];
  TextEditingController _answerController = TextEditingController();

  // String? gender;
  // DateTime? _selectedDate;

  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

//method pilih gender
  // List<String> listGender = ['Laki-laki', 'Perempuan'];
  // void pilihGender(String? value) {
  //   setState(() {
  //     gender = value;
  //   });
  // }

  // method untuk hide show pw
  bool hiden = true;
  void visible() {
    setState(() {
      hiden = !hiden;
    });
  }

//method pilih tanggal
  // void _selectDate() async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //       _dateController.text = DateFormat('dd-MM-yyyy').format(_selectedDate!);
  //     });
  // }

  Future<void> _register() async {
    //menyimpan nilai data dari controller ke variabel
    String fullname = _fullnameController.text;
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmpassword = _kofirmPwController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String? question = _selectedQuestion;
    String answer = _answerController.text; // Jawaban dari pertanyaan

    //url endpoint untuk register api
    String url = "${IpConfig.baseUrl}/api/daftar";

    try {
      //mengirim permintaan http post ke url dengan data yang ada pada body
      final response = await http.post(
        Uri.parse(url),
        body: {
          'fullname': fullname,
          'username': username,
          'password': password,
          'confirmpassword': confirmpassword,
          'email': email,
          'phone': phone,
          'question': question,
          'answer': answer, // Sertakan jawaban dalam body request
        },
      );

      //cek kondisi
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Registrasi Berhasil"),
            content: Text("Silakan Login"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Registrasi Gagal"),
            content: Text("Silakan Coba Lagi"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
        print("HTTP Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (error) {
      print("Error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _keyForm, //untuk validasi form
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
              ),
              Image.asset('assets/img/logo.jpg', height: 78, width: 65),
              SizedBox(height: 50),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(padding: EdgeInsets.all(10)),
                      Center(
                        child: Text(
                          "DAFTAR",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8F9BA1),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          height: 3,
                          color: Colors.grey,
                          width: 105,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 20),
                      ),
                      TextFormField(
                        controller: _fullnameController,
                        validator: (val) {
                          return val!.isEmpty ? "fullname harus diisi" : null;
                        },
                        decoration: InputDecoration(
                          hintText: 'fullname',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          return val!.isEmpty ? "username harus diisi" : null;
                        },
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'username',
                          prefixIcon: Icon(Icons.assignment_ind),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Email harus diisi";
                          } else if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(val)) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "nomor hp harus diisi";
                          } else if (val.length > 13 || val.length < 10) {
                            return "nomor hp tidak valid";
                          }
                          return null;
                        },
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: 'phone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "password harus diisi";
                          } else if (val.length < 6) {
                            return "Password harus diisi minimal 6 karakter";
                          }
                          return null;
                        },
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: hiden,
                        decoration: InputDecoration(
                          hintText: 'password',
                          suffixIcon: IconButton(
                            icon: Icon(hiden
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: visible,
                          ),
                          prefixIcon: Icon(Icons.lock_open),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Konfirmasi password harus diisi";
                          } else if (val != _passwordController.text) {
                            return "Password tidak cocok";
                          }
                          return null;
                        },
                        controller: _kofirmPwController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'konfirmasi password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10)),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedQuestion,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedQuestion = newValue;
                          });
                        },
                        items: _questions.map((question) {
                          return DropdownMenuItem(
                            child: Text(question),
                            value: question,
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: 'Pilih Pertanyaan',
                          prefixIcon: Icon(Icons.question_answer),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(
                          height:
                              10), // Penambahan SizedBox untuk jarak antara dropdown dan teks penjelasan
                      Text(
                        ' Pertanyaan ini digunakan sebagai antisipasi jika Anda lupa password. Harap selalu ingat Jawaban Anda! ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _answerController,
                        decoration: InputDecoration(
                          hintText: 'Jawaban',
                          prefixIcon: Icon(Icons.edit),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Color(0xFFEAEAEA),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(padding: EdgeInsets.only(bottom: 20))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFA4C751),
                      minimumSize: Size(170, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:
                        Text('Register', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      if (_keyForm.currentState!.validate()) {
                        // jika Semua field terisi dengan benar
                        // UserData userData = UserData(
                        //   //objek UserData dari data yang diinputkan
                        //   fullname: _fullnameController.text,
                        //   username: _usernameController.text,
                        //   email: _emailController.text,
                        //   phone: _phoneController.text,
                        //   alamat: _alamatController.text,
                        //   agama: agama!,
                        //   gender: gender!,
                        //   password: _passwordController.text,
                        //   konfirmasiPassword: _kofirmPwController.text,
                        // );
                        // Pindah ke halaman login dengan membawa data user yang telah diregistrasi
                        // Navigator.pushReplacementNamed(context, '/login',
                        //     arguments: userData);
                        _register();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Mohon Lengkapi Data')),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 30),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFFA4C751)),
                      minimumSize: Size(180, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Kembali',
                        style: TextStyle(color: Color(0xFFA4C751))),
                    onPressed: () {
                      Navigator.pushNamed(context, '/loadingPage');
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 20.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Sudah punya akun? '),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login sekarang',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 20.0)),
            ],
          ),
        ),
      )),
    );
  }
}
