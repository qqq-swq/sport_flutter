import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';
import 'package:sport_flutter/domain/usecases/get_videos.dart';
import 'video_event.dart';
import 'video_state.dart';
import '../../domain/entities/video.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final GetVideos getVideos;

  // Internal state for pagination and difficulty
  int _page = 1;
  Difficulty _currentDifficulty = Difficulty.Easy; // Default difficulty
  List<Video> _videos = [];
  bool _hasReachedMax = false;

  VideoBloc({required this.getVideos}) : super(VideoInitial()) {
    on<FetchVideos>(_onFetchVideos);
  }

  Future<void> _onFetchVideos(
    FetchVideos event, Emitter<VideoState> emit) async {
    // If the difficulty changes, reset everything
    if (event.difficulty != _currentDifficulty) {
      _page = 1;
      _videos = [];
      _hasReachedMax = false;
      _currentDifficulty = event.difficulty;
      emit(VideoLoading());
    } else if (_hasReachedMax) {
      return; // Do nothing if we have reached the end
    }

    try {
      final newVideos = await getVideos(difficulty: _currentDifficulty, page: _page);

      if (newVideos.isEmpty) {
        _hasReachedMax = true;
      } else {
        _page++;
        _videos.addAll(newVideos);
      }

      emit(VideoLoaded(videos: List.of(_videos), hasReachedMax: _hasReachedMax));
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
