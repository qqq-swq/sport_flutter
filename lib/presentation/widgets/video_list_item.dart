import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/presentation/bloc/video_bloc.dart';
import 'package:sport_flutter/presentation/bloc/video_event.dart';
import 'package:sport_flutter/presentation/bloc/video_state.dart';
import 'package:sport_flutter/presentation/pages/video_detail_page.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoListItem extends StatefulWidget {
  final Video video;
  final List<Video> allVideos;

  const VideoListItem({
    super.key,
    required this.video,
    this.allVideos = const [],
  });

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  VideoPlayerController? _controller;

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initializeAndPlay() async {
    if (_controller != null) {
      return;
    }

    final cacheManager =
        RepositoryProvider.of<CacheManager>(context, listen: false);
    final fileInfo = await cacheManager.getFileFromCache(widget.video.videoUrl) ??
        await cacheManager.downloadFile(widget.video.videoUrl);

    if (!mounted) return;

    final controller = VideoPlayerController.file(fileInfo.file);
    _controller = controller;
    setState(() {}); // Show the first frame

    try {
      await controller.initialize();

      if (!mounted || _controller != controller) {
        await controller.dispose();
        return;
      }

      await controller.setLooping(true);
      await controller.play();
      if (mounted) setState(() {});
    } catch (e) {
      if (_controller == controller) {
        _controller = null;
        if (mounted) setState(() {});
      }
      await controller.dispose();
    }
  }

  void _disposePlayer() {
    final oldController = _controller;
    if (oldController != null) {
      _controller = null;
      if (mounted) {
        setState(() {});
      }
      oldController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<VideoBloc>().add(const PausePlayback());
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VideoDetailPage(
              video: widget.video,
              recommendedVideos: widget.allVideos,
            ),
          ),
        );

        if (result is bool && result != widget.video.isFavorited) {
          context
              .read<VideoBloc>()
              .add(UpdateFavoriteStatus(widget.video.id, result));
        }
      },
      child: BlocListener<VideoBloc, VideoState>(
        listener: (context, state) {
          if (state is VideoLoaded) {
            final bool isMyTurnToPlay = state.activeVideoId == widget.video.id;
            if (isMyTurnToPlay && _controller == null) {
              _initializeAndPlay();
            } else if (!isMyTurnToPlay && _controller != null) {
              _disposePlayer();
            }
          }
        },
        child: VisibilityDetector(
          key: Key(widget.video.id.toString()),
          onVisibilityChanged: (visibilityInfo) {
            if (mounted) {
              context.read<VideoBloc>().add(UpdateVideoVisibility(
                    widget.video.id,
                    visibilityInfo.visibleFraction,
                  ));
            }
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  height: 90,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: [
                      if (_controller != null &&
                          _controller!.value.isInitialized)
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(_controller!),
                        )
                      else
                        CachedNetworkImage(
                          imageUrl: widget.video.thumbnailUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Center(child: Icon(Icons.error)),
                        ),
                      if (_controller == null || !_controller!.value.isPlaying)
                        const Icon(Icons.play_arrow,
                            size: 50, color: Colors.white70),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.video.authorName,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}