import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhcoree/Donasi/snap_web_view_screen.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:nhcoree/Database/IpConfig.dart';

class InputUrlScreen extends StatefulWidget {
  const InputUrlScreen({Key? key}) : super(key: key);

  @override
  InputUrlState createState() => InputUrlState();
}

String formatRupiah(double amount) {
  final formatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0);
  return formatter.format(amount);
}

class InputUrlState extends State<InputUrlScreen> {
  final TextEditingController nominalController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController doaController = TextEditingController();
  String selectedTujuan = 'Pilih tujuan donasi';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      User? user = await DatabaseHelper.getUserFromLocal(token);
      if (user != null) {
        setState(() {
          nameController.text = user.nama_donatur!;
          phoneController.text = user.nomor_handphone!;
          emailController.text = user.email!;
        });
      }
    }
  }

  @override
  void dispose() {
    nominalController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    doaController.dispose();
    super.dispose();
  }

  Future<String> getSnapToken(
      int amount, String name, String email, String phone) async {
    const backendUrl = "${IpConfig.baseUrl}/api/create-transaction";

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'first_name': name,
        'email': email,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData['snap_token'] as String;
    } else {
      throw Exception('Failed to get Snap Token');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text('DONASI',
                    style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFFA4C751),
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                buildInputLabel('Data Diri'),
                buildInputField(nameController, 'Masukkan Nama Lengkap'),
                buildInputField(phoneController, 'Masukkan No WhatsApp'),
                SizedBox(height: 15),
                buildInputLabel('Konfirmasi Pembayaran'),
                buildInputField(emailController, 'Masukkan Email'),
                SizedBox(height: 15),
                buildInputLabel('Doa'),
                buildInputField(doaController,
                    'Cantumkan Doa Terbaik Untuk Diri dan Keluarga',
                    maxLines: 5),
                SizedBox(height: 15),
                buildInputLabel('Tujuan Donasi'),
                buildDropdownTujuan(),
                SizedBox(height: 15),
                buildInputLabel('Nominal Donasi'),
                buildInputField(nominalController, 'Masukkan Nominal Donasi',
                    keyboardType: TextInputType.number),
                buildNominalButtons(screenWidth),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final amount = int.parse(nominalController.text
                          .replaceAll(RegExp(r'[^0-9]'), ''));
                      final name = nameController.text;
                      final email = emailController.text;
                      final phone = phoneController.text;
                      final doa = doaController.text;
                      if (amount == 0 ||
                          name.isEmpty ||
                          email.isEmpty ||
                          phone.isEmpty ||
                          selectedTujuan == 'Pilih tujuan donasi' ||
                          selectedTujuan.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Harap isi semua field yang diperlukan')));
                        return;
                      }

                      final snapToken =
                          await getSnapToken(amount, name, email, phone);
                      final url =
                          'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

                      Navigator.of(context)
                          .pushNamed(SnapWebViewScreen.routeName, arguments: {
                        'url': url,
                        'nominal': nominalController.text,
                        'tujuan': selectedTujuan,
                        'name': name,
                        'phone': phone,
                        'email': email,
                        'doa': doa,
                      });
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Gagal mendapatkan Snap Token')));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA4C751),
                    minimumSize: Size(screenWidth * 0.4, 60), // Responsive size
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('BAYAR DONASI',
                      style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownTujuan() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0xFFEAEAEA),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedTujuan.isNotEmpty ? selectedTujuan : null,
            hint: const Text('Pilih tujuan donasi'),
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedTujuan = newValue ?? 'Pilih tujuan donasi';
              });
            },
            items: <String>['Pilih tujuan donasi', 'Pembangunan', 'Santunan']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: value != 'Pilih tujuan donasi'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(value),
                      )
                    : const Text('Pilih tujuan donasi',
                        style: TextStyle(color: Colors.grey)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildInputLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String hintText,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Color(0xff8F9BA1)),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Color(0xFFEAEAEA),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget buildNominalButtons(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: <Widget>[
          buildNominalButton(screenWidth, 'Rp. 10.000'),
          buildNominalButton(screenWidth, 'Rp. 20.000'),
          buildNominalButton(screenWidth, 'Rp. 50.000'),
          buildNominalButton(screenWidth, 'Rp. 100.000'),
        ],
      ),
    );
  }

  Widget buildNominalButton(double screenWidth, String nominal) {
    return SizedBox(
      width: (screenWidth - 60) / 2, // Membagi space secara rata
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            nominalController.text = nominal.replaceAll(RegExp(r'[^0-9]'), '');
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.white60, // Mengubah warna background menjadi putih
          padding: EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          nominal,
          style: TextStyle(
            fontSize: 20, // Memperbesar ukuran teks
            color: Colors.black, // Mengubah warna teks menjadi hitam
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
