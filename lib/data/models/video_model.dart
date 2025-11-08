import 'package:sport_flutter/domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.title,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.authorName,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'] ?? '',
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      authorName: json['author_name'] ?? 'Unknown Author',
    );
  }
}
