import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/models/video_model.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

import 'auth_remote_data_source.dart';

abstract class VideoRemoteDataSource {
  Future<VideoModel> getVideoById(int id);
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
  });
  Future<void> favoriteVideo(int videoId);
  Future<void> unfavoriteVideo(int videoId);
  Future<List<VideoModel>> getFavoriteVideos();
  Future<List<VideoModel>> getRecommendedVideos();
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final http.Client client;
  final String _baseUrl;

  VideoRemoteDataSourceImpl({required this.client}) : _baseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl();

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<VideoModel> getVideoById(int id) async {
    final headers = await _getAuthHeaders();
    final response = await client.get(
      Uri.parse('$_baseUrl/videos/$id'),
      headers: headers,
    );

    print('GET /videos/$id RAW RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return VideoModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load video detail');
    }
  }

  @override
  Future<List<VideoModel>> getVideos({
    required Difficulty difficulty,
  }) async {
    final headers = await _getAuthHeaders();
    final response = await client.get(
      Uri.parse('$_baseUrl/videos?difficulty=${difficulty.name}&limit=100'),
      headers: headers,
    );

    print('GET /videos RAW RESPONSE for ${difficulty.name}: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> videoList = data['videos'];
      return videoList.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load videos');
    }
  }

  @override
  Future<void> favoriteVideo(int videoId) async {
    final headers = await _getAuthHeaders();
    final response = await client.post(
      Uri.parse('$_baseUrl/videos/$videoId/favorite'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to favorite video. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  @override
  Future<void> unfavoriteVideo(int videoId) async {
    final headers = await _getAuthHeaders();
    final response = await client.delete(
      Uri.parse('$_baseUrl/videos/$videoId/favorite'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to unfavorite video. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  @override
  Future<List<VideoModel>> getFavoriteVideos() async {
    final headers = await _getAuthHeaders();
    final response = await client.get(
      Uri.parse('$_baseUrl/videos/favorites'),
      headers: headers,
    );

    print('GET /videos/favorites RAW RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> videoList = json.decode(response.body);
      return videoList.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load favorite videos. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  @override
  Future<List<VideoModel>> getRecommendedVideos() async {
    final response = await client.get(
      Uri.parse('$_baseUrl/videos/recommended'),
    );

    print('GET /videos/recommended RAW RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> videoList = json.decode(response.body);
      return videoList.map((json) => VideoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommended videos. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}