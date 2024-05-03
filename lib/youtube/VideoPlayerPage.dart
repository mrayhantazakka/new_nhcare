import 'package:nhcoree/youtube/YoutubeApiService.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatelessWidget {
  final YoutubeVideo video;

  VideoPlayerPage({required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: video.id,
              flags: YoutubePlayerFlags(autoPlay: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  video.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                        'Published at: ${video.publishedAt}',
                        style: TextStyle(color: Colors.grey),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
