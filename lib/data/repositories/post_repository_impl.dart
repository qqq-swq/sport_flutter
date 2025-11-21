import 'package:sport_flutter/data/datasources/post_remote_data_source.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CommunityPost>> getCommunityPosts() async {
    return await remoteDataSource.getCommunityPosts();
  }

  @override
  Future<void> createCommunityPost(String title, String content, String? imageUrl, String? videoUrl) async {
    return await remoteDataSource.createCommunityPost(title, content, imageUrl, videoUrl);
  }

  @override
  Future<List<PostComment>> getPostComments(int postId) async {
    final commentModels = await remoteDataSource.getPostComments(postId);
    return commentModels.cast<PostComment>().toList();
  }

  @override
  Future<void> createPostComment(int postId, String content) async {
    return await remoteDataSource.createPostComment(postId, content);
  }

  @override
  Future<Map<String, dynamic>> likePost(int postId) async {
    return await remoteDataSource.likePost(postId);
  }

  @override
  Future<Map<String, dynamic>> dislikePost(int postId) async {
    return await remoteDataSource.dislikePost(postId);
  }

  @override
  Future<bool> favoritePost(int postId) async {
    return await remoteDataSource.favoritePost(postId);
  }

  @override
  Future<void> deletePost(int postId) async {
    return await remoteDataSource.deletePost(postId);
  }
}
