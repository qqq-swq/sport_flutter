import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/repositories/community_post_repository.dart';
import 'package:sport_flutter/data/datasources/community_remote_data_source.dart';

class CommunityPostRepositoryImpl implements CommunityPostRepository {
  final CommunityRemoteDataSource remoteDataSource;

  CommunityPostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CommunityPost>> getPosts() async {
    try {
      return await remoteDataSource.getPosts();
    } catch (e) {
      print('Error in CommunityPostRepositoryImpl (getPosts): $e');
      rethrow;
    }
  }

  @override
  Future<CommunityPost> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? videoUrl,
  }) async {
    try {
      // Forward the call, including optional media URLs, to the data source.
      return await remoteDataSource.createPost(
        title: title,
        content: content,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );
    } catch (e) {
      print('Error in CommunityPostRepositoryImpl (createPost): $e');
      rethrow;
    }
  }
}
