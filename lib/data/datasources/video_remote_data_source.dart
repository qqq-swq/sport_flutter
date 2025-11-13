import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sport_flutter/data/models/video_model.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

// We will use the same base URL as the auth data source to ensure consistency.
import 'auth_remote_data_source.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
    required int page,
  });
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;
  // Using a centralized base URL from the auth data source implementation
  final String _baseUrl;

  VideoRemoteDataSourceImpl({required this.client}) : _baseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl(); // Assuming a static method to get the URL

  @override
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
    required int page,
  }) async {
    // The endpoint for videos is /videos, appended to the base /api URL
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
