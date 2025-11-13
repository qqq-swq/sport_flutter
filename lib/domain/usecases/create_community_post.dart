import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/repositories/community_post_repository.dart';

class CreateCommunityPost {
  final CommunityPostRepository repository;

  CreateCommunityPost(this.repository);

  Future<CommunityPost> call({
    required String title,
    required String content,
    String? imageUrl,
    String? videoUrl,
  }) async {
    // This use case simply forwards the call to the repository.
    // In a more complex app, it might contain additional business logic.
    return await repository.createPost(
      title: title,
      content: content,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
    );
  }
}
