import 'package:equatable/equatable.dart';
import 'package:sport_flutter/domain/entities/video.dart';

class VideoState extends Equatable {
  const VideoState();

  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final List<Video> videos;
  final bool hasReachedMax;

  const VideoLoaded({required this.videos, required this.hasReachedMax});

  @override
  List<Object> get props => [videos, hasReachedMax];
}

class VideoError extends VideoState {
  final String message;

  const VideoError(this.message);

  @override
  List<Object> get props => [message];
}
