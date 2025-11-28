import 'package:sport_flutter/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    super.description,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.authorName,
    super.userAvatarUrl,
    required super.viewCount,
    required super.likeCount,
    required super.createdAt,
    required super.isFavorited,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    String authorName = json['author_name'] ?? 'Unknown Author';
    String? userAvatarUrl = json['userAvatarUrl'];

    if (user is Map<String, dynamic>) {
      authorName = user['username'] ?? authorName;
      userAvatarUrl = user['avatar_url'] ?? userAvatarUrl;
    }

    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Video',
      // Attempt to parse description with multiple possible keys for robustness
      description: json['description'] ?? json['Description'] ?? json['desc'],
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      authorName: authorName,
      userAvatarUrl: userAvatarUrl,
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isFavorited: json['isFavorited'] ?? false,
    );
  }
}
