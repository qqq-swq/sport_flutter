
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/usecases/delete_community_post.dart';
import 'package:sport_flutter/domain/usecases/like_post.dart';
import 'package:sport_flutter/domain/usecases/dislike_post.dart';
import 'package:sport_flutter/domain/usecases/favorite_post.dart';
import 'package:meta/meta.dart';

part 'post_action_event.dart';
part 'post_action_state.dart';

// Bloc
class PostActionBloc extends Bloc<PostActionEvent, PostActionState> {
  final LikePostUseCase likePost;
  final DislikePostUseCase dislikePost;
  final FavoritePostUseCase favoritePost;
  final DeleteCommunityPost deleteCommunityPost;

  PostActionBloc({
    required this.likePost,
    required this.dislikePost,
    required this.favoritePost,
    required this.deleteCommunityPost,
  }) : super(PostActionInitial()) {
    on<LikePost>(_onLikePost);
    on<DislikePost>(_onDislikePost);
    on<FavoritePost>(_onFavoritePost);
    on<DeletePost>(_onDeletePost);
  }

  Future<void> _onLikePost(LikePost event, Emitter<PostActionState> emit) async {
    try {
      final voteData = await likePost(event.postId);
      emit(PostLikeDislikeSuccess(voteData));
    } catch (e) {
      emit(PostActionFailure('Failed to like post: $e'));
    }
  }

  Future<void> _onDislikePost(DislikePost event, Emitter<PostActionState> emit) async {
    try {
      final voteData = await dislikePost(event.postId);
      emit(PostLikeDislikeSuccess(voteData));
    } catch (e) {
      emit(PostActionFailure('Failed to dislike post: $e'));
    }
  }

  Future<void> _onFavoritePost(FavoritePost event, Emitter<PostActionState> emit) async {
    try {
      final isFavorited = await favoritePost(event.postId);
      emit(PostFavoriteSuccess(isFavorited));
    } catch (e) {
      emit(PostActionFailure('Failed to favorite post: $e'));
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<PostActionState> emit) async {
    try {
      await deleteCommunityPost(event.postId);
      emit(PostDeletionSuccess());
    } catch (e) {
      emit(PostActionFailure('Failed to delete post: $e'));
    }
  }
}
