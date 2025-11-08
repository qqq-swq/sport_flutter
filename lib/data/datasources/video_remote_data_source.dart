import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sport_flutter/data/models/video_model.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
    required int page,
  });
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "http://192.168.4.140:3000/api"; // Your API base URL

  VideoRemoteDataSourceImpl({required this.client});

  @override
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
    required int page,
  }) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/videos?difficulty=${difficulty.name}&page=$page&limit=5'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> videoList = data['videos'];
      return videoList.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }
}
