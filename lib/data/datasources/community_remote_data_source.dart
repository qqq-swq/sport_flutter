import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/models/community_post_model.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart'; // For base URL

abstract class CommunityRemoteDataSource {
  Future<List<CommunityPostModel>> getPosts();
  Future<CommunityPostModel> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? videoUrl,
  });
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final http.Client client;
  final String _baseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl();

  CommunityRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    if (token == null) throw Exception('Authentication token not found');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<CommunityPostModel>> getPosts() async {
    final response = await client.get(Uri.parse('$_baseUrl/community'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CommunityPostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts from server');
    }
  }

  @override
  Future<CommunityPostModel> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? videoUrl,
  }) async {
    final headers = await _getAuthHeaders();
    final body = json.encode({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    });

    final response = await client.post(
      Uri.parse('$_baseUrl/community'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      return CommunityPostModel.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('Failed to create post. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
