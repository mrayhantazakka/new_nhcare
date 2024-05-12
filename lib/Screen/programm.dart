import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/ProgramData.dart';

class Programm extends StatefulWidget {
  @override
  _ProgrammState createState() => _ProgrammState();
}

class _ProgrammState extends State<Programm> {
  List<ProgramData> _programs = [];
  List<ProgramData> _filteredPrograms = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk mengambil data dari server saat inisialisasi widget.
    _fetchProgramsFromServer();
  }

  Future<void> _fetchProgramsFromServer() async {
    // Ganti URL ini dengan URL endpoint API kamu.
    final url = Uri.parse('${IpConfig.baseUrl}/api/programs');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Jika respons sukses, parse data JSON ke dalam List<ProgramData>.
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _programs =
              responseData.map((json) => ProgramData.fromJson(json)).toList();
          _filteredPrograms =
              _programs; // Mengisi _filteredPrograms dengan data awal
        });
      } else {
        // Jika respons gagal, tampilkan pesan kesalahan.
        print('Failed to load programs: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani kesalahan jika ada.
      print('Error fetching programs: $e');
    }
  }

  void _onProgramTap(ProgramData program) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(program.judul),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                program
                    .img_program, // Menggunakan Image.network untuk URL gambar
                width: 200, // Atur lebar gambar sesuai kebutuhan
                height: 200, // Atur tinggi gambar sesuai kebutuhan
              ),
              SizedBox(height: 16),
              Text(program.deskripsi),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredPrograms = _programs
          .where((program) =>
              program.judul.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Program'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Program',
                          border: InputBorder.none,
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _filteredPrograms.length,
              itemBuilder: (context, index) {
                ProgramData program = _filteredPrograms[index];
                return GestureDetector(
                  onTap: () {
                    _onProgramTap(program);
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          program
                              .img_program, // Menggunakan Image.network untuk URL gambar
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 8),
                        Text(
                          program.judul,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          program.deskripsi,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
