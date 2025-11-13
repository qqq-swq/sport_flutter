import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/usecases/get_community_posts.dart';
import 'package:sport_flutter/domain/usecases/create_community_post.dart';
import 'package:sport_flutter/services/oss_upload_service.dart';

// --- Events ---
abstract class CommunityEvent extends Equatable {
  const CommunityEvent();
  @override
  List<Object?> get props => [];
}

class FetchPosts extends CommunityEvent {}

class AddPost extends CommunityEvent {
  final String title;
  final String content;
  final File? mediaFile; // Optional file to upload

  const AddPost({
    required this.title,
    required this.content,
    this.mediaFile,
  });

  @override
  List<Object?> get props => [title, content, mediaFile];
}

// --- States ---
abstract class CommunityState extends Equatable {
  const CommunityState();
  @override
  List<Object> get props => [];
}

class CommunityInitial extends CommunityState {}

class CommunityLoading extends CommunityState {}

class CommunityLoaded extends CommunityState {
  final List<CommunityPost> posts;
  const CommunityLoaded(this.posts);
  @override
  List<Object> get props => [posts];
}

class CommunityPostSuccess extends CommunityState {}

class CommunityError extends CommunityState {
  final String message;
  const CommunityError(this.message);
  @override
  List<Object> get props => [message];
}

// --- Bloc ---
class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final GetCommunityPosts getCommunityPosts;
  final CreateCommunityPost createCommunityPost;
  final OssUploadService ossUploadService;

  CommunityBloc({
    required this.getCommunityPosts,
    required this.createCommunityPost,
    required this.ossUploadService,
  }) : super(CommunityInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<AddPost>(_onAddPost);
  }

  Future<void> _onFetchPosts(FetchPosts event, Emitter<CommunityState> emit) async {
    emit(CommunityLoading());
    try {
      final posts = await getCommunityPosts();
      emit(CommunityLoaded(posts));
    } catch (e) {
      emit(CommunityError('Failed to fetch posts: ${e.toString()}'));
    }
  }

  Future<void> _onAddPost(AddPost event, Emitter<CommunityState> emit) async {
    try {
      String? imageUrl;
      String? videoUrl;

      // 1. If a file is provided, upload it to OSS first.
      if (event.mediaFile != null) {
        final uploadedUrl = await ossUploadService.uploadFile(event.mediaFile!);
        // Basic logic to determine if it's an image or video based on extension
        if (['.jpg', '.jpeg', '.png', '.gif'].any((ext) => uploadedUrl.toLowerCase().endsWith(ext))) {
          imageUrl = uploadedUrl;
        } else {
          videoUrl = uploadedUrl;
        }
      }

      // 2. Create the post with the (optional) URL.
      await createCommunityPost(
        title: event.title,
        content: event.content,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
      );
      
      // 3. Refresh the list to show the new post.
      add(FetchPosts());

    } catch (e) {
      print('Failed to create post: ${e.toString()}');
      // Optionally emit an error state to the UI
      emit(CommunityError('发帖失败: ${e.toString()}'));
    }
  }
}
