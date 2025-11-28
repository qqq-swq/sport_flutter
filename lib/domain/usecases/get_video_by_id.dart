import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

class GetVideoById {
  final VideoRepository repository;

  GetVideoById(this.repository);

  Future<Video> call(int id) async {
    return await repository.getVideoById(id);
  }
}
