import 'package:flutter/material.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';

class PostDetailPage extends StatelessWidget {
  final CommunityPost post;

  const PostDetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('作者: ${post.username}'),
            const SizedBox(height: 16),
            Text(post.content),
            // TODO: Implement comment section here
          ],
        ),
      ),
    );
  }
}
