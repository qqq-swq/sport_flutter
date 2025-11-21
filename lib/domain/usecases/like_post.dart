import 'package:sport_flutter/domain/repositories/community_post_repository.dart';

class LikePostUseCase {
  final CommunityPostRepository repository;

  LikePostUseCase(this.repository);

  Future<Map<String, dynamic>> call(int postId) {
    return repository.likePost(postId);
  }
}
