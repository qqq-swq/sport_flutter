import 'package:sport_flutter/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.content,
    required super.username,
    required super.likeCount,
    required super.dislikeCount,
    required super.createdAt,
    required super.replyCount, // Added required field
    super.replies = const [],
    super.userVote,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    // Recursively parse replies
    var repliesFromJson = json['replies'] as List? ?? [];
    List<Comment> replyList = repliesFromJson.map((i) => CommentModel.fromJson(i)).toList();

    return CommentModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      username: json['username'] ?? 'Unknown User',
      likeCount: json['like_count'] ?? 0,
      dislikeCount: json['dislike_count'] ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      replies: replyList,
      // Parse new fields from JSON
      replyCount: json['reply_count'] ?? 0,
      userVote: json['user_vote'], // This can be null
    );
  }
}
