import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nhcoree/Donasi/Donasi.dart';
import 'package:nhcoree/Screen/anak.dart';
import 'package:nhcoree/youtube/VideoListPage.dart';
import 'package:nhcoree/youtube/VideoPlayerPage.dart';
import 'package:nhcoree/youtube/YoutubeApiService.dart';
import 'programm.dart';

class Beranda extends StatefulWidget {
  const Beranda({Key? key}) : super(key: key);

  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/new_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Image.asset('assets/img/logo_nhcare.png', height: 50),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Container(
                  width: 360,
                  height: 95,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFA4C751),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 209, 209, 209).withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Text(
                    "TOTAL DANA DONASI :",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Donasi()),
                            );
                          },
                          child: Container(
                            transform:
                                Matrix4.translationValues(0.1, -5.0, 0.0),
                            child: Card(
                              elevation: 9,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/img/ic_donasi.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Donasi',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AnakAsuh()),
                            );
                          },
                          child: Container(
                            transform:
                                Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: Card(
                              elevation: 9,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/img/ic_anak.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Anak Asuh',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Programm()),
                            );
                          },
                          child: Container(
                            transform:
                                Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: Card(
                              elevation: 9,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/img/ic_program.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Program',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            print('Card Program diklik');
                          },
                          child: Container(
                            transform:
                                Matrix4.translationValues(0.0, -5.0, 0.0),
                            child: Card(
                              elevation: 9,
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/img/ic_alokasi.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                  ),
                                  const Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8.0, bottom: 8.0),
                                    child: Text(
                                      'Alokasi Dana',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Text(
                        "Artikel",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: 10,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                      height: 350,
                      width: 200,
                      margin: EdgeInsets.only(right: 35),
                      child: Center(
                        child: Text("card $index"),
                      ),
                      color: const Color.fromARGB(255, 225, 225, 225),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Video",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(right: 40)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoListPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Selengkapnya',
                          style: TextStyle(
                            color: Color.fromARGB(255, 159, 159, 159),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                FutureBuilder<List<YoutubeVideo>>(
                  future: YoutubeApiService.fetchVideos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      snapshot.data!.sort(
                          (a, b) => b.publishedAt.compareTo(a.publishedAt));
                      return Column(
                        children: [
                          for (var video in snapshot.data!.take(2)) ...[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VideoPlayerPage(video: video),
                                  ),
                                );
                              },
                              child: Container(
                                height: 250,
                                width: 355,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 238, 238, 238),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 209, 209, 209)
                                          .withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 8,
                                      offset: Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Thumbnail video
                                    CachedNetworkImage(
                                      imageUrl: video.thumbnailUrl,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                    // Icon video
                                    Positioned.fill(
                                      child: Icon(
                                        Icons.play_circle_fill,
                                        // color: Color(0xffA4C751),
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                    ),
                                    // Judul video
                                    Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Text(
                                          video.title,
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 0, 0, 0)),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
