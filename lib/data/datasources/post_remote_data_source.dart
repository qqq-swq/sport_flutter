import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/data/models/community_post_model.dart';
import 'package:sport_flutter/data/models/post_comment_model.dart';

abstract class PostRemoteDataSource {
  Future<List<CommunityPostModel>> getCommunityPosts();
  Future<void> createCommunityPost(String title, String content, String? imageUrl, String? videoUrl);
  Future<List<PostCommentModel>> getPostComments(int postId);
  Future<void> createPostComment(int postId, String content);
  Future<Map<String, dynamic>> likePost(int postId);
  Future<Map<String, dynamic>> dislikePost(int postId);
  Future<bool> favoritePost(int postId);
  Future<void> deletePost(int postId);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  final String _baseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl();

  PostRemoteDataSourceImpl({required this.client});

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<CommunityPostModel>> getCommunityPosts() async {
    final headers = await _getAuthHeaders();
    final response = await client.get(Uri.parse('$_baseUrl/community/posts'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => CommunityPostModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load community posts');
    }
  }

  @override
  Future<void> createCommunityPost(String title, String content, String? imageUrl, String? videoUrl) async {
    final headers = await _getAuthHeaders();
    final body = jsonEncode({
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    });
    final response = await client.post(Uri.parse('$_baseUrl/community/posts'), headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception('Failed to create community post');
    }
  }

  @override
  Future<List<PostCommentModel>> getPostComments(int postId) async {
    final headers = await _getAuthHeaders();
    final response = await client.get(Uri.parse('$_baseUrl/posts/$postId/comments'), headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((json) => PostCommentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load post comments');
    }
  }

  @override
  Future<void> createPostComment(int postId, String content) async {
    final headers = await _getAuthHeaders();
    final body = jsonEncode({'content': content});
    final response = await client.post(Uri.parse('$_baseUrl/posts/$postId/comments'), headers: headers, body: body);
    if (response.statusCode != 201) {
      throw Exception('Failed to create post comment');
    }
  }

  @override
  Future<Map<String, dynamic>> likePost(int postId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/posts/$postId/like');
    final response = await client.post(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to like post. URL: $url, Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to like post. Status: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> dislikePost(int postId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/posts/$postId/dislike');
    final response = await client.post(url, headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Failed to dislike post. URL: $url, Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to dislike post. Status: ${response.statusCode}');
    }
  }

  @override
  Future<bool> favoritePost(int postId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/posts/$postId/favorite');
    final response = await client.post(url, headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['isFavorited'] as bool;
    } else {
      print('Failed to favorite post. URL: $url, Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to favorite post. Status: ${response.statusCode}');
    }
  }

  @override
  Future<void> deletePost(int postId) async {
    final headers = await _getAuthHeaders();
    final url = Uri.parse('$_baseUrl/community-posts/$postId'); // Assuming this is the correct endpoint for deletion
    final response = await client.delete(url, headers: headers);

    if (response.statusCode != 204) {
      print('Failed to delete post. URL: $url, Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to delete post. Status: ${response.statusCode}');
    }
  }
}
