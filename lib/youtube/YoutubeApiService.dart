import 'dart:convert';

import 'package:http/http.dart' as http;

class YoutubeApiService {
  static const String apiKey = 'AIzaSyB1YMDRoNLVfXutxYBJQGSauwv7p0YPmb0';
  static const String channelId = 'UCtUjNSRBwiBtdLPw5yfeOwg';

  static Future<List<YoutubeVideo>> fetchVideos() async {
    final videos = <YoutubeVideo>[];

    String url = 'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&channelId=$channelId'
        '&type=video'
        '&maxResults=50'
        '&key=$apiKey';

    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      for (var video in data['items']) {
        var snippet = video['snippet'];
        videos.add(YoutubeVideo(
          id: video['id']['videoId'],
          title: video['snippet']['title'],
          description: video['snippet']['description'],
          thumbnailUrl: video['snippet']['thumbnails']['medium']['url'],
          publishedAt: DateTime.parse(snippet['publishedAt']),
        ));
      }
    }
    return videos;
  }
}

class YoutubeVideo {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String description;
  final DateTime publishedAt;

  YoutubeVideo(
      {required this.id,
      required this.title,
      required this.thumbnailUrl,
      required this.description,
      required this.publishedAt});
}
