import 'package:sport_flutter/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.authorName,
    required super.viewCount,
    required super.likeCount,
    required super.createdAt,
  });

  // This factory constructor is now updated to match the new, flattened API response.
  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Video',
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      // Directly read 'author_name' from the top-level JSON object
      authorName: json['author_name'] ?? 'Unknown Author',
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }
}
