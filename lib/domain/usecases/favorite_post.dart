import 'package:sport_flutter/domain/repositories/community_post_repository.dart';

class FavoritePostUseCase {
  final CommunityPostRepository repository;

  FavoritePostUseCase(this.repository);

  Future<Map<String, dynamic>> call(int postId) {
    return repository.favoritePost(postId);
  }
}
