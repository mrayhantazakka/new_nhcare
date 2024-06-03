// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Auth/Login.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class daftar extends StatefulWidget {
  const daftar({super.key});

  @override
  State<daftar> createState() => _daftarState();
}

class _daftarState extends State<daftar> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _namaDonaturController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nomorHandphoneController =
      TextEditingController();
  final TextEditingController _kofirmPwController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jawabanController = TextEditingController();
  String? _jenisKelamin;
  String? _selectedQuestion;
  List<String> _questions = [
    'Surah Favorit',
    'Nama Sahabat Nabi',
    'Mukjizat Nabi',
    'Nama Nabi',
    'Tempat Favorit',
    'Apa Saja Untuk Diingat!'
  ];

  GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  //visible password
  bool hiden = true;
  void visible() {
    setState(() {
      hiden = !hiden;
    });
  }

  //state untuk loading
  bool _isLoading = false;

  void _toggleLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _register() async {
    _toggleLoading(true); // loading aktif saat registrasi dimulai

    String nama_donatur = _namaDonaturController.text;
    String alamat = _alamatController.text;
    String password = _passwordController.text;
    String confirmpassword = _kofirmPwController.text;
    String email = _emailController.text;
    String nomor_handphone = _nomorHandphoneController.text;
    String? pertanyaan = _selectedQuestion;
    String jawaban = _jawabanController.text;
    String? jenis_kelamin = _jenisKelamin;

    String url = "${IpConfig.baseUrl}/api/daftar";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'nama_donatur': nama_donatur,
          'alamat': alamat,
          'password': password,
          'confirmpassword': confirmpassword,
          'email': email,
          'nomor_handphone': nomor_handphone,
          'pertanyaan': pertanyaan,
          'jawaban': jawaban,
          'jenis_kelamin': jenis_kelamin,
        },
      );

      if (response.statusCode == 201) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Registrasi Berhasil!',
            message: 'Silakan Login',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Registrasi Gagal',
            message: 'Silakan Coba Lagi',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (error) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Error!',
          message: 'Terjadi kesalahan: $error',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }

    _toggleLoading(false); // Matikan loading setelah registrasi selesai
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xFFA4C751),
      ),
      child: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _keyForm,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 50),
                      ),
                      Image.asset('assets/img/logo.jpg', height: 78, width: 65),
                      SizedBox(height: 50),
                      Container(
                        width: screenWidth * 0.9,
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
                              const Padding(padding: EdgeInsets.all(10)),
                              const Center(
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
                              const Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 20),
                              ),
                              TextFormField(
                                controller: _namaDonaturController,
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "nama harus diisi"
                                      : null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Nama',
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                  hintText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "nomor hp harus diisi";
                                  } else if (val.length > 13 ||
                                      val.length < 10) {
                                    return "nomor hp tidak valid";
                                  }
                                  return null;
                                },
                                controller: _nomorHandphoneController,
                                decoration: InputDecoration(
                                  hintText: 'Phone',
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                validator: (val) {
                                  return val!.isEmpty
                                      ? "alamat harus diisi"
                                      : null;
                                },
                                controller: _alamatController,
                                decoration: InputDecoration(
                                  hintText: 'Alamat',
                                  prefixIcon: const Icon(Icons.assignment_ind),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // memastikan teks "Jenis Kelamin" ada di kiri
                                children: [
                                  const Text(
                                    'Jenis Kelamin',
                                    style: TextStyle(
                                        fontSize:
                                            16), // Anda dapat menyesuaikan ukuran font sesuai kebutuhan
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Laki-Laki',
                                            groupValue: _jenisKelamin,
                                            onChanged: (value) {
                                              setState(() {
                                                _jenisKelamin = value;
                                              });
                                            },
                                          ),
                                          const Text('Laki-Laki'),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 60,
                                      ), // Jarak antara dua radio button
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Perempuan',
                                            groupValue: _jenisKelamin,
                                            onChanged: (value) {
                                              setState(() {
                                                _jenisKelamin = value;
                                              });
                                            },
                                          ),
                                          const Text('Perempuan'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
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
                                  prefixIcon: const Icon(Icons.question_answer),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                ' Pertanyaan ini digunakan sebagai antisipasi jika Anda lupa password. Harap selalu ingat Jawaban Anda! ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _jawabanController,
                                decoration: InputDecoration(
                                  hintText: 'Jawaban',
                                  prefixIcon: const Icon(Icons.edit),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(hiden
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: visible,
                                  ),
                                  prefixIcon: const Icon(Icons.lock_open),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                  hintText: 'Konfirmasi Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10)),
                                  filled: true,
                                  fillColor: const Color(0xFFEAEAEA),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 20))
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white.withOpacity(
                                  0.8), backgroundColor: const Color(0xFFA4C751),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5, // Warna saat di-hover atau di-press
                            ),
                            child: const Text('DAFTAR',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                _register();
                              } else {
                                final snackBar = SnackBar(
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Data Tidak Lengkap!',
                                    message:
                                        'Mohon lengkapi semua data yang diperlukan untuk mendaftar.',
                                    contentType: ContentType.failure,
                                  ),
                                );

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            },
                          ),
                          const SizedBox(width: 30),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFA4C751)),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('KEMBALI',
                                style: TextStyle(color: Color(0xFFA4C751))),
                            onPressed: () {
                              Navigator.pushNamed(context, '/loadingPage');
                            },
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 20.0)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun? '),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              child: const Text(
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
                      const Padding(padding: EdgeInsets.only(bottom: 20.0)),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Tambahkan overlay loading jika _isLoading true
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child:
                    CircularProgressIndicator(), // Menggunakan CircularProgressIndicator standar
              ),
            ),
        ],
      ),
    );
  }
}
