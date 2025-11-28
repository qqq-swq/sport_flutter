import 'package:sport_flutter/domain/entities/community_post.dart';

class CommunityPostModel extends CommunityPost {
  const CommunityPostModel({
    required int id,
    required String username,
    String? userAvatarUrl,
    required String title,
    required String content,
    required DateTime createdAt,
    List<String> imageUrls = const [],
    List<String> videoUrls = const [],
    int commentCount = 0,
    int likeCount = 0,
    List<String>? tags,
  }) : super(
          id: id,
          username: username,
          userAvatarUrl: userAvatarUrl,
          title: title,
          content: content,
          createdAt: createdAt,
          imageUrls: imageUrls,
          videoUrls: videoUrls,
          commentCount: commentCount,
          likeCount: likeCount,
          tags: tags,
        );

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    // Parse the date string. If it lacks timezone info, it's treated as local time by default.
    final parsedDt = DateTime.parse(json['createdAt'] as String);

    // Re-create the DateTime object as a UTC time. This corrects the timezone issue
    // by telling Dart that the time values from the server represent UTC.
    final createdAtUtc = DateTime.utc(
      parsedDt.year,
      parsedDt.month,
      parsedDt.day,
      parsedDt.hour,
      parsedDt.minute,
      parsedDt.second,
      parsedDt.millisecond,
      parsedDt.microsecond,
    );
    
    return CommunityPostModel(
      id: json['id'] as int,
      username: json['username'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: createdAtUtc, // Use the UTC DateTime
      imageUrls: json['imageUrls'] != null ? List<String>.from(json['imageUrls']) : [],
      videoUrls: json['videoUrls'] != null ? List<String>.from(json['videoUrls']) : [],
      commentCount: json['commentCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'imageUrls': imageUrls,
      'videoUrls': videoUrls,
      'commentCount': commentCount,
      'likeCount': likeCount,
      'tags': tags,
    };
  }
}
