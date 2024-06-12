import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/AcaraData.dart'; // Pastikan ini mengarah ke lokasi yang benar

Future<List<AcaraData>> fetchEventsForDate(DateTime date) async {
  final response = await http.get(Uri.parse('${IpConfig.baseUrl}/api/acaras'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<AcaraData> events = jsonData
        .map((json) => AcaraData.fromJson(json))
        .where((acara) =>
            acara.tanggalAcara.year == date.year &&
            acara.tanggalAcara.month == date.month &&
            acara.tanggalAcara.day ==
                date.day) // Filter acara berdasarkan tahun, bulan, dan tanggal yang sesuai
        .toList();
    return events;
  } else {
    throw Exception('Failed to update events: ${response.statusCode}');
  }
}

class AcaraScreen extends StatefulWidget {
  const AcaraScreen({Key? key}) : super(key: key);

  @override
  _AcaraScreenState createState() => _AcaraScreenState();
}

class _AcaraScreenState extends State<AcaraScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<AcaraData>? _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents(
        _selectedDay!); // Panggil fetchEvents saat inisialisasi dengan tanggal sekarang
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = selectedDay; // Perbarui focused day dengan selected day
    });
    _fetchEvents(selectedDay);
  }

  Future<void> _fetchEvents(DateTime selectedDay) async {
    try {
      final events = await fetchEventsForDate(selectedDay);
      setState(() {
        _events = events;
      });
    } catch (error) {
      print('Failed to load events: $error');
      // Add dialog or snackbar to inform user about the error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghapus tombol back
        title: const Text(
          'ACARA',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA4C751)),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true, // Menengahkan judul
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/new_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              calendarStyle: CalendarStyle(
                todayDecoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFFA4C751),
                  shape: BoxShape.circle,
                ),
                outsideDecoration: const BoxDecoration(
                  color: Color(
                      0xFFE0E0E0), // Warna abu-abu muda untuk hari di luar bulan
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.blue.shade400, // Warna default untuk marker
                  shape: BoxShape.circle,
                ),
                defaultDecoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(
                          0xFFD6D6D6)), // Garis tepi untuk semua hari
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: const TextStyle(color: Colors.black),
                weekendTextStyle: const TextStyle(
                    color: Colors.red), // Warna merah untuk hari Jumat
              ),
              eventLoader: (day) {
                var events = _events
                        ?.where((event) => isSameDay(event.tanggalAcara, day))
                        .toList() ??
                    [];
                if (events.isNotEmpty) {
                  // Menggunakan warna acak untuk setiap hari dengan acara
                  return [
                    Container(
                      margin: const EdgeInsets.all(1.5),
                      decoration: BoxDecoration(
                        color: events.length > 1
                            ? Colors.purple
                            : Colors
                                .blue, // Contoh: warna ungu jika lebih dari satu acara, biru jika satu
                        shape: BoxShape.circle,
                      ),
                    )
                  ];
                }
                return [];
              },
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            const SizedBox(height: 10),
            if (_events != null &&
                _events!.isNotEmpty) // Tampilkan daftar acara jika tidak kosong
              _buildEventList()
            else // Tampilkan pesan jika tidak ada acara pada tanggal yang dipilih
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tidak ada acara pada tanggal ini',
                  style: TextStyle(fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _events!.length,
        itemBuilder: (context, index) {
          final acara = _events![index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFA4C751),
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(acara.namaAcara),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Html(
                    data: acara.deskripsiAcara,
                    style: {
                      "body": Style(
                          fontSize: FontSize(16.0),
                          fontStyle: FontStyle.italic),
                    },
                  ),
                  Text(
                    DateFormat('yyyy/MM/dd').format(acara.tanggalAcara),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void main() {
    runApp(const MaterialApp(
      home: AcaraScreen(),
    ));
  }
}
