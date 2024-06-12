import 'package:flutter/material.dart';
import 'package:nhcoree/Models/ArtikelData.dart';
import 'package:nhcoree/Database/IpConfig.dart';
import 'package:flutter_html/flutter_html.dart';

class ArtikelDetail extends StatelessWidget {
  final ArtikelData artikel;

  const ArtikelDetail({Key? key, required this.artikel}) : super(key: key);

  String getFullImageUrl(String relativeUrl) {
    return '${IpConfig.baseUrl}/storage/artikels/$relativeUrl';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Artikel',
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFA4C751)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                getFullImageUrl(artikel.gambarArtikel),
                width: 360,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  artikel.judulArtikel,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 10)),
              Html(
                data: artikel.deskripsiArtikel,
                style: {
                  "body": Style(fontSize: FontSize(16.0)),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
