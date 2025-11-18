import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';
import 'package:sport_flutter/domain/usecases/get_videos.dart';
import 'package:sport_flutter/domain/usecases/favorite_video.dart';
import 'package:sport_flutter/domain/usecases/unfavorite_video.dart';
import 'video_event.dart';
import 'video_state.dart';
import '../../domain/entities/video.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final GetVideos getVideos;
  final FavoriteVideo favoriteVideo;
  final UnfavoriteVideo unfavoriteVideo;
  final CacheManager cacheManager;

  int _page = 1;
  Difficulty _currentDifficulty = Difficulty.Easy;
  List<Video> _videos = [];
  bool _hasReachedMax = false;
  final Map<int, double> _visibilityMap = {};

  VideoBloc({
    required this.getVideos,
    required this.favoriteVideo,
    required this.unfavoriteVideo,
    required this.cacheManager,
  }) : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
    on<UpdateFavoriteStatus>(_onUpdateFavoriteStatus); // New handler
    on<PausePlayback>(_onPausePlayback);
    on<UpdateVideoVisibility>(_onUpdateVideoVisibility);
  }

  void _onUpdateVideoVisibility(UpdateVideoVisibility event, Emitter<VideoState> emit) {
    if (state is VideoLoaded) {
      _visibilityMap[event.videoId] = event.visibleFraction;

      int? mostVisibleVideoId;
      double maxVisibility = 0.0;

      // Find the most visible video
      _visibilityMap.forEach((videoId, visibility) {
        if (visibility > maxVisibility) {
          maxVisibility = visibility;
          mostVisibleVideoId = videoId;
        }
      });

      final currentState = state as VideoLoaded;

      // Logic to decide which video to play.
      // Play the most visible video if it's visible enough (e.g., > 80%).
      // Otherwise, pause the current video.
      if (maxVisibility > 0.8) {
        if (currentState.activeVideoId != mostVisibleVideoId) {
          emit(currentState.copyWith(activeVideoId: mostVisibleVideoId));
        }
      } else {
        if (currentState.activeVideoId != null) {
          emit(currentState.copyWith(activeVideoId: null));
        }
      }
    }
  }

  void _onPausePlayback(PausePlayback event, Emitter<VideoState> emit) {
    if (state is VideoLoaded) {
      emit((state as VideoLoaded).copyWith(activeVideoId: null));
    }
  }

  // Handler for the new event
  void _onUpdateFavoriteStatus(UpdateFavoriteStatus event, Emitter<VideoState> emit) {
    if (state is VideoLoaded) {
      final currentState = state as VideoLoaded;
      final videoIndex = currentState.videos.indexWhere((v) => v.id == event.videoId);

      if (videoIndex != -1) {
        final updatedVideos = List<Video>.from(currentState.videos);
        final oldVideo = updatedVideos[videoIndex];
        updatedVideos[videoIndex] = oldVideo.copyWith(isFavorited: event.isFavorited);

        emit(currentState.copyWith(videos: updatedVideos));
      }
    }
  }

  Future<void> _onFetchVideos(FetchVideos event, Emitter<VideoState> emit) async {
    if (event.difficulty != _currentDifficulty) {
      _page = 1;
      _videos = [];
      _hasReachedMax = false;
      _visibilityMap.clear();
      _currentDifficulty = event.difficulty;
      emit(VideoLoading());
    } else if (_hasReachedMax || state is VideoLoading) {
      return;
    }

    try {
      final newVideos = await getVideos(difficulty: _currentDifficulty, page: _page);

      if (newVideos.isEmpty) {
        _hasReachedMax = true;
      } else {
        _page++;
        _videos.addAll(newVideos);
      }

      emit(VideoLoaded(
        videos: List.of(_videos),
        hasReachedMax: _hasReachedMax,
        activeVideoId: (state is VideoLoaded) ? (state as VideoLoaded).activeVideoId : null,
      ));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
