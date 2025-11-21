part of 'post_action_bloc.dart';

@immutable
abstract class PostActionEvent {}

class LikePost extends PostActionEvent {
  final int postId;
  LikePost(this.postId);
}

class DislikePost extends PostActionEvent {
  final int postId;
  DislikePost(this.postId);
}

class FavoritePost extends PostActionEvent {
  final int postId;
  FavoritePost(this.postId);
}

class DeletePost extends PostActionEvent {
  final int postId;
  DeletePost(this.postId);
}
