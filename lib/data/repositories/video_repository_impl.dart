import 'package:sport_flutter/data/datasources/video_remote_data_source.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource remoteDataSource;

  VideoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Video>> getVideos({
    required Difficulty difficulty,
    required int page,
  }) async {
    // The client-side batching logic was incorrect and has been removed.
    // The avatar loading delay is a backend issue and must be solved by ensuring
    // the /videos API endpoint returns the complete user information.
    return await remoteDataSource.getVideos(difficulty: difficulty, page: page);
  }

  @override
  Future<void> favoriteVideo(int videoId) async {
    return await remoteDataSource.favoriteVideo(videoId);
  }

  @override
  Future<void> unfavoriteVideo(int videoId) async {
    return await remoteDataSource.unfavoriteVideo(videoId);
  }

  @override
  Future<List<Video>> getFavoriteVideos() async {
    return await remoteDataSource.getFavoriteVideos();
  }

  @override
  Future<List<Video>> getRecommendedVideos() async {
    return await remoteDataSource.getRecommendedVideos();
  }
}
