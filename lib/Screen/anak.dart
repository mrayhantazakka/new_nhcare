import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/AnakData.dart';

class AnakAsuh extends StatefulWidget {
  const AnakAsuh({super.key});

  @override
  _AnakAsuhState createState() => _AnakAsuhState();
}

class _AnakAsuhState extends State<AnakAsuh> {
  List<AnakData> _anakAsuhs = [];
  List<AnakData> _filteredAnakAsuhs = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAnakAsuhsFromServer();
  }

  Future<void> _fetchAnakAsuhsFromServer() async {
    final url = Uri.parse('${IpConfig.baseUrl}/api/anakasuh');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _anakAsuhs =
              responseData.map((json) => AnakData.fromJson(json)).toList();
          _filteredAnakAsuhs = _anakAsuhs;
        });
      } else {
        print('Failed to load anak asuhs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching anak asuhs: $e');
    }
  }

  void _onProgramTap(AnakData anakAsuh) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DetailAnakAsuh(anakAsuh: anakAsuh)),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredAnakAsuhs = _anakAsuhs
          .where((anakAsuh) =>
              anakAsuh.nama.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  String getFullImageUrl(String relativeUrl) {
    return '${IpConfig.baseUrl}/storage/anakasuhs/Foto/$relativeUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ANAK ASUH',
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
                            hintText: 'Cari Anak Asuh',
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
                onRefresh: _fetchAnakAsuhsFromServer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: _filteredAnakAsuhs.length,
                    itemBuilder: (context, index) {
                      AnakData anakAsuh = _filteredAnakAsuhs[index];
                      return GestureDetector(
                        onTap: () {
                          _onProgramTap(anakAsuh);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  getFullImageUrl(anakAsuh.img_anak),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10)),
                              Text(
                                anakAsuh.nama,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
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

class DetailAnakAsuh extends StatelessWidget {
  final AnakData anakAsuh;

  const DetailAnakAsuh({super.key, required this.anakAsuh});
  String getFullImageUrl(String relativeUrl) {
    return '${IpConfig.baseUrl}/storage/anakasuhs/Foto/$relativeUrl';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DETAIL ANAK ASUH',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFA4C751),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/new_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Container(
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12.0), // Border radius
                          child: Image.network(
                            getFullImageUrl(anakAsuh.img_anak),
                            width: 360,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'NAMA',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${anakAsuh.nama}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'CABANG',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${anakAsuh.cabang}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'TINGKAT',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${anakAsuh.tingkat}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'KELAS',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${anakAsuh.kelas}',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 5),
                        anakAsuh.prestasi != null &&
                                anakAsuh.prestasi!.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'PRESTASI',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: anakAsuh.prestasi!.length,
                                    itemBuilder: (context, index) {
                                      return Text(
                                        anakAsuh.prestasi![index].nama_prestasi,
                                        style: const TextStyle(fontSize: 14.0),
                                      );
                                    },
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
