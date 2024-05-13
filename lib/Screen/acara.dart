import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:nhcoree/Database/IpConfig.dart';

class Acara {
  final DateTime tanggalAcara;
  final String judul;
  final String deskripsi;

  Acara({
    required this.tanggalAcara,
    required this.judul,
    required this.deskripsi,
  });

  factory Acara.fromJson(Map<String, dynamic> json) {
    return Acara(
      tanggalAcara: DateTime.parse(json['tanggal_acara']),
      judul: json['judul'],
      deskripsi: json['deskripsi'],
    );
  }
}

Future<List<Acara>> fetchEventsForDate(DateTime date) async {
  final response = await http.get(Uri.parse('${IpConfig.baseUrl}/api/acaras'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<Acara> events = jsonData
        .map((json) => Acara.fromJson(json))
        .where((acara) =>
            acara.tanggalAcara.year == date.year &&
            acara.tanggalAcara.month == date.month &&
            acara.tanggalAcara.day == date.day) // Filter acara berdasarkan tahun, bulan, dan tanggal yang sesuai
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
  List<Acara>? _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchEvents(_selectedDay!); // Panggil fetchEvents saat inisialisasi dengan tanggal sekarang
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
        title: Text('Acara'),
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.black,
              ),
              todayTextStyle: TextStyle(color: Colors.green),
              selectedTextStyle: TextStyle(color: Colors.white),
            ),
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
          SizedBox(height: 10),
          if (_events != null && _events!.isNotEmpty) // Tampilkan daftar acara jika tidak kosong
            _buildEventList()
          else // Tampilkan pesan jika tidak ada acara pada tanggal yang dipilih
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tidak ada acara pada tanggal ini',
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
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
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(acara.judul),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    acara.deskripsi,
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text(
                    '${DateFormat('yyyy/MM/dd').format(acara.tanggalAcara)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AcaraScreen(),
  ));
}
