import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:http/http.dart' as http;

class Event {
  final DateTime date;
  final String title;

  Event({required this.date, required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.parse(json['date']),
      title: json['title'],
    );
  }
}

Future<List<Event>> fetchEvents(int year, int month) async {
  final response = await http.get(Uri.parse('https://your-laravel-backend.com/api/events?year=$year&month=$month'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<Event> events = jsonData.map((json) => Event.fromJson(json)).toList();
    return events;
  } else {
    throw Exception('Failed to load events: ${response.statusCode}');
  }
}

class Acara extends StatefulWidget {
  const Acara({Key? key}) : super(key: key);

  @override
  State<Acara> createState() => _AcaraState();
}

class _AcaraState extends State<Acara> {
  List<Event>? _events;
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final events = await fetchEvents(_selectedYear, _selectedMonth);
      setState(() {
        _events = events;
      });
    } catch (error) {
      print('Error fetching events: $error');
      // Tambahkan dialog atau snackbar untuk memberi tahu pengguna tentang kesalahan.
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_selectedYear, _selectedMonth),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime(_selectedYear, _selectedMonth)) {
      setState(() {
        _selectedYear = picked.year;
        _selectedMonth = picked.month;
      });
      _fetchEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: Center(
        child: _events != null
            ? CalendarView(
                events: _events!,
                onDateChanged: (date) {
                  print('Selected date: $date');
                },
              )
            : CircularProgressIndicator(), // Tampilkan indikator loading jika events masih null
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Acara(),
  ));
}
