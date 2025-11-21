part of 'post_action_bloc.dart';

@immutable
abstract class PostActionState {}

class PostActionInitial extends PostActionState {}

class PostActionLoading extends PostActionState {}

class PostLikeDislikeSuccess extends PostActionState {
  final Map<String, dynamic> voteData;
  PostLikeDislikeSuccess(this.voteData);
}

class PostFavoriteSuccess extends PostActionState {
  final Map<String, dynamic> favoriteData;
  PostFavoriteSuccess(this.favoriteData);
}

class PostDeletionSuccess extends PostActionState {}

class PostActionFailure extends PostActionState {
  final String message;
  PostActionFailure(this.message);
}
