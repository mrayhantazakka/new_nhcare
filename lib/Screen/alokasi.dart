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
        title: Text(
          'ALOKASI DANA',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.green),
      ),
      body: isLoading
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
    );
  }

  Widget buildExpansionTile(String title, double amount) {
    return ExpansionTile(
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }
}
