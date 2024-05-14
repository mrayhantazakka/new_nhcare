import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:nhcoree/Models/AnakData.dart';

class AnakAsuh extends StatefulWidget {
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
    // Panggil fungsi untuk mengambil data dari server saat inisialisasi widget.
    _fetchAnakAsuhsFromServer();
  }

  Future<void> _fetchAnakAsuhsFromServer() async {
    // Ganti URL ini dengan URL endpoint API kamu.
    final url = Uri.parse('${IpConfig.baseUrl}/api/anakasuh');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Jika respons sukses, parse data JSON ke dalam List<AnakAsuh>.
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          _anakAsuhs =
              responseData.map((json) => AnakData.fromJson(json)).toList();
          _filteredAnakAsuhs =
              _anakAsuhs; // Mengisi _filteredAnakAsuhs dengan data awal
        });
      } else {
        // Jika respons gagal, tampilkan pesan kesalahan.
        print('Failed to load anak asuhs: ${response.statusCode}');
      }
    } catch (e) {
      // Tangani kesalahan jika ada.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anak Asuh'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/new_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
             decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/new_bg.png'),
                fit: BoxFit.fill,
                ),
              ),
              child: Padding(
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
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: _filteredAnakAsuhs.length,
                itemBuilder: (context, index) {
                  AnakData anakAsuh = _filteredAnakAsuhs[index];
                  return GestureDetector(
                    onTap: () {
                      _onProgramTap(anakAsuh);
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
                            anakAsuh
                                .img_anak, // Menggunakan Image.network untuk URL gambar
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            anakAsuh.nama,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            anakAsuh.deskripsi,
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
      ),
    );
  }
}

class DetailAnakAsuh extends StatelessWidget {
  final AnakData anakAsuh;

  const DetailAnakAsuh({required this.anakAsuh});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(anakAsuh.nama),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/new_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                anakAsuh.img_anak,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              Text(
                'Nama: ${anakAsuh.nama}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Sekolah: ${anakAsuh.nama_sekolah}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Kelas: ${anakAsuh.kelas}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Deskripsi: ${anakAsuh.deskripsi}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

