import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';

class PostHeader extends StatelessWidget {
  final CommunityPost post;

  const PostHeader({super.key, required this.post});

  // Helper to check for a valid URL
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: _isValidUrl(post.userAvatarUrl)
                    ? CachedNetworkImageProvider(post.userAvatarUrl!)
                    : null,
                child: !_isValidUrl(post.userAvatarUrl)
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(post.createdAt),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (post.title.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(post.title, style: Theme.of(context).textTheme.titleLarge),
            ),
          Text(post.content, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            AspectRatio(
              aspectRatio: 1 / 1,
              child: CachedNetworkImage(
                imageUrl: post.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
        ],
      ),
    );
  }
}
