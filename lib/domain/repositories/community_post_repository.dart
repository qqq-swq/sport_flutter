import 'package:sport_flutter/domain/entities/community_post.dart';

// This is the contract that the data layer must implement.
abstract class CommunityPostRepository {
  Future<List<CommunityPost>> getPosts();
  Future<CommunityPost> createPost({
    required String title,
    required String content,
    String? imageUrl,
    String? videoUrl,
  });
}
