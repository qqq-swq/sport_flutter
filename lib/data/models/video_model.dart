import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

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
    required super.difficulty,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    String authorName = json['author_name'] ?? 'Unknown Author';
    String? userAvatarUrl = json['userAvatarUrl'];

    if (user is Map<String, dynamic>) {
      authorName = user['username'] ?? authorName;
      userAvatarUrl = user['avatar_url'] ?? userAvatarUrl;
    }

    DateTime createdAtDate;
    if (json['created_at'] != null) {
      final parsedDt = DateTime.parse(json['created_at'] as String);
      // Re-create the DateTime object as a UTC time. This corrects potential timezone issues
      // by ensuring that the time values are consistently treated as UTC.
      createdAtDate = DateTime.utc(
        parsedDt.year,
        parsedDt.month,
        parsedDt.day,
        parsedDt.hour,
        parsedDt.minute,
        parsedDt.second,
        parsedDt.millisecond,
        parsedDt.microsecond,
      );
    } else {
      createdAtDate = DateTime.now().toUtc(); // Fallback to current UTC time
    }

    return VideoModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Untitled Video',
      description: json['description'] ?? json['Description'] ?? json['desc'],
      videoUrl: json['video_url'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      authorName: authorName,
      userAvatarUrl: userAvatarUrl,
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      createdAt: createdAtDate,
      isFavorited: json['isFavorited'] ?? false,
      difficulty: Difficulty.values.firstWhere(
        (e) => e.toString().split('.').last == json['difficulty'],
        orElse: () => Difficulty.Easy,
      ),
    );
  }
}
