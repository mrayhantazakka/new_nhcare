import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nhcoree/youtube/VideoPlayerPage.dart';
import 'YoutubeApiService.dart';

class VideoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<YoutubeVideo>>(
        future: YoutubeApiService.fetchVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // snapshot.data!
            //     .sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var video = snapshot.data![index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(video.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(video.description),
                      SizedBox(height: 4),
                      Text(
                        'Published at: ${video.publishedAt}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerPage(video: video),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
