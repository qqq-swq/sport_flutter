import 'package:sport_flutter/domain/entities/video.dart';

enum Difficulty {
  Easy,
  Medium,
  Hard,
}

abstract class VideoRepository {
  Future<List<Video>> getVideos({
    required Difficulty difficulty,
    required int page,
  });
}
