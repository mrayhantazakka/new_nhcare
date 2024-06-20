import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nhcoree/Database/DatabaseHelper.dart';
import 'package:nhcoree/Models/user.dart';
import 'package:nhcoree/Database/IpConfig.dart';

class RiwayatDonasi extends StatefulWidget {
  const RiwayatDonasi({super.key});

  @override
  State<RiwayatDonasi> createState() => _RiwayatDonasiState();
}

class _RiwayatDonasiState extends State<RiwayatDonasi> {
  List<dynamic> donations = [];
  bool isLoading = true;
  String? idDonatur;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      User? user = await DatabaseHelper.getUserFromLocal(token);
      if (user != null) {
        setState(() {
          idDonatur = user.id_donatur;
          fetchDonations();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDonations() async {
    if (idDonatur == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final String apiUrl = '${IpConfig.baseUrl}/api/donations/$idDonatur';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          donations = data['Donasi'] ?? [];
          donations.sort((a, b) => DateTime.parse(b['tanggal_donasi'])
              .compareTo(DateTime.parse(a['tanggal_donasi'])));
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load donation history');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(String dateStr) {
    final date = DateTime.parse(dateStr);
    return DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(date);
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RIWAYAT DONASI',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFA4C751),
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : donations.isEmpty
              ? Center(child: Text('No donation history available.'))
              : ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        leading: Icon(Icons.circle, color: Colors.orange),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              donation['tujuan'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              formatCurrency(donation['nominal']),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            formatDate(donation['tanggal_donasi']),
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
