import 'package:sport_flutter/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.userId,
    super.parentCommentId,
    required super.content,
    required super.username,
    super.userAvatarUrl,
    required super.likeCount,
    required super.dislikeCount,
    required super.createdAt,
    required super.replyCount,
    super.replies = const [],
    super.userVote,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    var repliesFromJson = json['replies'] as List? ?? [];
    List<Comment> replyList = repliesFromJson.map((i) => CommentModel.fromJson(i)).toList();

    var createdAtString = json['created_at'] as String? ?? '';
    if (createdAtString.endsWith('ZZ')) {
      createdAtString = createdAtString.substring(0, createdAtString.length - 1);
    }

    DateTime createdAtDate;
    if (createdAtString.isNotEmpty) {
      final parsedDt = DateTime.parse(createdAtString);
      // Re-create the DateTime object as a UTC time. This corrects the timezone issue
      // by telling Dart that the time values from the server represent UTC.
      createdAtDate = DateTime.utc(
        parsedDt.year,
        parsedDt.month,
        parsedDt.day,
        parsedDt.hour,
        parsedDt.minute,
        parsedDt.second,
        parsedDt.millisecond,
        parsedDt.microsecond,
      );
    } else {
      createdAtDate = DateTime.now().toUtc(); // Fallback to current UTC time
    }

    return CommentModel(
      id: json['id'] ?? 0,
      userId: (json['user_id'] ?? '').toString(),
      parentCommentId: json['parent_comment_id'] as int?,
      content: json['content'] ?? '',
      username: json['username'] ?? 'Unknown User',
      userAvatarUrl: json['userAvatarUrl'],
      likeCount: json['like_count'] ?? 0,
      dislikeCount: json['dislike_count'] ?? 0,
      createdAt: createdAtDate,
      replies: replyList,
      replyCount: json['reply_count'] ?? 0,
      userVote: json['user_vote'],
    );
  }
}
