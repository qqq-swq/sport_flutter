import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final String authorName;

  const Video({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.authorName,
  });

  @override
  List<Object?> get props => [id, title, videoUrl, thumbnailUrl, authorName];
}
