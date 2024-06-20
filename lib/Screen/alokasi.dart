import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:intl/intl.dart'; // Library untuk format angka

class Alokasi extends StatefulWidget {
  @override
  _AlokasiState createState() => _AlokasiState();
}

class _AlokasiState extends State<Alokasi> {
  double totalPembangunan = 0;
  double totalSantunan = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTotalDonations();
  }

  Future<void> fetchTotalDonations() async {
    const getAlokasi = "${IpConfig.baseUrl}/api/alokasi";
    try {
      final response = await http.get(
        Uri.parse(getAlokasi),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10)); // Timeout setelah 10 detik

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            "Data received: $data"); // Logging untuk melihat data yang diterima
        setState(() {
          totalPembangunan = data['totalPembangunan'].toDouble();
          totalSantunan = data['totalSantunan'].toDouble();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load donations');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
      // Anda bisa menampilkan pesan error ke pengguna di sini
    }
  }

  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ALOKASI DANA',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA4C751)),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/new_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildExpansionTile('Pembangunan', totalPembangunan),
                    SizedBox(height: 8),
                    buildExpansionTile('Santunan', totalSantunan),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildExpansionTile(String title, double amount) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: Icon(
          Icons.circle,
          color: Colors.orange,
          size: 10,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dana Terkumpul: ${formatRupiah(amount)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: amount /
                      1000000, // Assuming 1,000,000 as the goal for simplicity
                  color: Colors.green,
                  backgroundColor: Colors.grey[300],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
