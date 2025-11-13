import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/repositories/community_post_repository.dart';

class GetCommunityPosts {
  final CommunityPostRepository repository;

  GetCommunityPosts(this.repository);

  // By using a `call` method, the class can be invoked like a function.
  Future<List<CommunityPost>> call() async {
    return await repository.getPosts();
  }
}
