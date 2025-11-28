import 'package:equatable/equatable.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends VideoEvent {
  final Difficulty difficulty;
  final bool isRefresh;

  const FetchVideos(this.difficulty, {this.isRefresh = false});

  @override
  List<Object> get props => [difficulty, isRefresh];
}

class PausePlayback extends VideoEvent {
  const PausePlayback();
}

class UpdateVideoVisibility extends VideoEvent {
  final int videoId;
  final double visibleFraction;

  const UpdateVideoVisibility(this.videoId, this.visibleFraction);

  @override
  List<Object> get props => [videoId, visibleFraction];
}

// New event to update the favorite status in the BLoC state
class UpdateFavoriteStatus extends VideoEvent {
  final int videoId;
  final bool isFavorited;

  const UpdateFavoriteStatus(this.videoId, this.isFavorited);

  @override
  List<Object> get props => [videoId, isFavorited];
}
