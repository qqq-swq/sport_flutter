import 'package:equatable/equatable.dart';

class CommunityPost extends Equatable {
  final int id;
  final String username;
  final String title;
  final String content;
  final DateTime createdAt;
  final String? imageUrl; // Optional: URL for an image
  final String? videoUrl; // Optional: URL for a video
  final int commentCount;
  final int likeCount;
  final List<String>? tags;

  const CommunityPost({
    required this.id,
    required this.username,
    required this.title,
    required this.content,
    required this.createdAt,
    this.imageUrl,
    this.videoUrl,
    this.commentCount = 0,
    this.likeCount = 0,
    this.tags,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        title,
        content,
        createdAt,
        imageUrl,
        videoUrl,
        commentCount,
        likeCount,
        tags,
      ];
}
