import 'package:sport_flutter/domain/entities/community_post.dart';

class CommunityPostModel extends CommunityPost {
  const CommunityPostModel({
    required int id,
    required int userId,
    required String username,
    String? userAvatarUrl,
    required String title,
    required String content,
    required DateTime createdAt,
    List<String> imageUrls = const [],
    List<String> videoUrls = const [],
    int commentCount = 0,
    int likeCount = 0,
    int dislikeCount = 0,
    List<String>? tags,
  }) : super(
          id: id,
          userId: userId,
          username: username,
          userAvatarUrl: userAvatarUrl,
          title: title,
          content: content,
          createdAt: createdAt,
          imageUrls: imageUrls,
          videoUrls: videoUrls,
          commentCount: commentCount,
          likeCount: likeCount,
          dislikeCount: dislikeCount,
          tags: tags,
        );

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    List<String> imageUrls = [];
    if (json['imageUrls'] != null && json['imageUrls'] is List && (json['imageUrls'] as List).isNotEmpty) {
      imageUrls = List<String>.from(json['imageUrls']);
    } else if (json['imageUrl'] != null && json['imageUrl'] is String) {
      imageUrls = [json['imageUrl'] as String];
    }

    List<String> videoUrls = [];
    if (json['videoUrls'] != null && json['videoUrls'] is List && (json['videoUrls'] as List).isNotEmpty) {
      videoUrls = List<String>.from(json['videoUrls']);
    } else if (json['videoUrl'] != null && json['videoUrl'] is String) {
      videoUrls = [json['videoUrl'] as String];
    }
    
    return CommunityPostModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      username: json['username'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrls: imageUrls,
      videoUrls: videoUrls,
      commentCount: json['commentCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      dislikeCount: json['dislikeCount'] as int? ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'dislikeCount': dislikeCount,
      'tags': tags,
    };
  }
}
