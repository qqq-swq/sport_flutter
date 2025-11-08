import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

class GetVideos {
  final VideoRepository repository;

  GetVideos(this.repository);

  Future<List<Video>> call({required Difficulty difficulty, required int page}) {
    return repository.getVideos(difficulty: difficulty, page: page);
  }
}
