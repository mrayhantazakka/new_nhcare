import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:intl/intl.dart';

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
        title: Text(
          'ALOKASI DANA',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFA4C751),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildCard('Pembangunan', totalPembangunan),
                  SizedBox(height: 16),
                  buildCard('Santunan', totalSantunan),
                ],
              ),
            ),
    );
  }

  Widget buildCard(String title, double amount) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.orange,
                  size: 10,
                ),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Dana Terkumpul: ${formatRupiah(amount)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: amount / 1000000, // Assuming 1,000,000 as the goal for simplicity
                color: Colors.green,
                backgroundColor: Colors.grey[300],
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
