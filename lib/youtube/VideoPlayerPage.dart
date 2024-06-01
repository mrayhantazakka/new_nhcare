import 'package:nhcoree/youtube/YoutubeApiService.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerPage extends StatelessWidget {
  final YoutubeVideo video;

  const VideoPlayerPage({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: video.id,
              flags: const YoutubePlayerFlags(autoPlay: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  video.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                        'Published at: ${video.publishedAt}',
                        style: const TextStyle(color: Colors.grey),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
