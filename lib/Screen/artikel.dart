import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/ArtikelData.dart';
import 'package:http/http.dart' as http;
import 'detailArtikel.dart';

class Artikel extends StatefulWidget {
  const Artikel({super.key});

  @override
  State<Artikel> createState() => _ArtikelState();
}

class _ArtikelState extends State<Artikel> {
  List<ArtikelData> _artikels = [];
  List<ArtikelData> _filteredArtikels = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchArtikelsFromServer();
  }

  Future<void> _fetchArtikelsFromServer() async {
    final url = Uri.parse('${IpConfig.baseUrl}/api/artikels');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _artikels =
              responseData.map((json) => ArtikelData.fromJson(json)).toList();
          _filteredArtikels = _artikels;
        });
      } else {
        print('Failed to load artikels: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching artikels: $e');
    }
  }

  String getFullImageUrl(String relativeUrl) {
    return '${IpConfig.baseUrl}/storage/artikels/$relativeUrl';
  }

  void _onProgramTap(ArtikelData artikel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArtikelDetail(artikel: artikel),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredArtikels = _artikels
          .where((artikel) =>
              artikel.judulArtikel.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ARTIKEL',
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
        child: Column(
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Cari Artikel',
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
              child: RefreshIndicator(
                onRefresh: _fetchArtikelsFromServer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: _filteredArtikels.length,
                    itemBuilder: (context, index) {
                      ArtikelData artikel = _filteredArtikels[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _onProgramTap(artikel);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  getFullImageUrl(artikel.gambarArtikel),
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  artikel.judulArtikel,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
