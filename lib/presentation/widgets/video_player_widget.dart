import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController controller;
  final bool isFullScreen;
  final VoidCallback onToggleFullScreen;

  const VideoPlayerWidget({
    super.key,
    required this.controller,
    required this.isFullScreen,
    required this.onToggleFullScreen,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _showControls = !_showControls);
        if (_showControls) _startHideTimer();
      },
      child: AspectRatio(
        aspectRatio: widget.controller.value.isInitialized ? widget.controller.value.aspectRatio : 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.controller.value.isInitialized)
              VideoPlayer(widget.controller)
            else
              const Center(child: CircularProgressIndicator()),
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: _buildControls(context),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: IconButton(
            icon: Icon(widget.controller.value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
            onPressed: () {
              _startHideTimer();
              if (widget.controller.value.isPlaying) {
                widget.controller.pause();
              } else {
                widget.controller.play();
              }
              setState(() {});
            },
            color: Colors.white,
            iconSize: 60,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black38,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                VideoProgressIndicator(widget.controller, allowScrubbing: true),
                Row(
                  children: [
                    const SizedBox(width: 8),
                    _buildSpeedMenu(),
                    const Spacer(),
                    IconButton(
                      icon: Icon(widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                      onPressed: widget.onToggleFullScreen,
                      color: Colors.white,
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSpeedMenu() {
    return PopupMenuButton<double>(
      onSelected: (speed) {
        _startHideTimer();
        widget.controller.setPlaybackSpeed(speed);
      },
      itemBuilder: (context) => [0.5, 1.0, 1.5, 2.0]
          .map((speed) => PopupMenuItem(value: speed, child: Text('${speed}x')))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '${widget.controller.value.playbackSpeed}x',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
