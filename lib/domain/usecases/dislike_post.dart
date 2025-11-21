import 'package:sport_flutter/domain/repositories/community_post_repository.dart';

class DislikePostUseCase {
  final CommunityPostRepository repository;

  DislikePostUseCase(this.repository);

  Future<Map<String, dynamic>> call(int postId) {
    return repository.dislikePost(postId);
  }
}
