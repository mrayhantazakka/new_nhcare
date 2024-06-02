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
    _fetchProgramsFromServer();
  }

  Future<void> _fetchProgramsFromServer() async {
    final url = Uri.parse('${IpConfig.baseUrl}/api/programs');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _programs =
              responseData.map((json) => ProgramData.fromJson(json)).toList();
          _filteredPrograms = _programs;
        });
      } else {
        print('Failed to load programs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching programs: $e');
    }
  }

  String getFullImageUrl(String relativeUrl) {
    return '${IpConfig.baseUrl}/storage/programs/$relativeUrl';
  }

  void _onProgramTap(ProgramData program) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double imageWidth = screenWidth *
            0.8; 

        return AlertDialog(
          title: Center(
            child: Text(program.namaProgram, textAlign: TextAlign.center),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                getFullImageUrl(program.gambarProgram),
                width: imageWidth,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(program.deskripsiProgram),
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
              program.namaProgram.toLowerCase().contains(value.toLowerCase()))
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
                      children: [
                        Image.network(
                          getFullImageUrl(program.gambarProgram),
                          width: 200,
                          height: 140,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 1),
                        Text(
                          program.namaProgram,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
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
