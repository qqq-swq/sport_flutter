import 'package:equatable/equatable.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends VideoEvent {
  final Difficulty difficulty;

  const FetchVideos(this.difficulty);

  @override
  List<Object> get props => [difficulty];
}
