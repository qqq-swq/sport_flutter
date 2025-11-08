import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:video_player/video_player.dart';

class VideoListItem extends StatefulWidget {
  final Video video;

  const VideoListItem({super.key, required this.video});

  @override
  State<VideoListItem> createState() => _VideoListItemState();
}

class _VideoListItemState extends State<VideoListItem> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Do not initialize the controller here to save resources.
    // It will be initialized on user tap.
  }

  void _initAndPlay() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.videoUrl))
      ..initialize().then((_) {
        // Ensure the first frame is shown
        setState(() {});
        _controller?.play();
        _isPlaying = true;
      });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (_controller == null) {
                _initAndPlay();
              } else {
                setState(() {
                  _isPlaying ? _controller?.pause() : _controller?.play();
                  _isPlaying = !_isPlaying;
                });
              }
            },
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_controller != null && _controller!.value.isInitialized)
                    VideoPlayer(_controller!)
                  else
                    // Use CachedNetworkImage for the thumbnail
                    CachedNetworkImage(
                      imageUrl: widget.video.thumbnailUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  if (!_isPlaying)
                    const Icon(Icons.play_arrow, size: 60, color: Colors.white70),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.video.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('by ${widget.video.authorName}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          )
        ],
      ),
    );
  }
}
