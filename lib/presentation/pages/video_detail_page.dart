
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/usecases/favorite_video.dart';
import 'package:sport_flutter/domain/usecases/unfavorite_video.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/bloc/comment_bloc.dart';
import 'package:sport_flutter/presentation/bloc/favorites_bloc.dart';
import 'package:sport_flutter/presentation/widgets/comment_widgets.dart';
import 'package:sport_flutter/presentation/widgets/video_intro_panel.dart';
import 'package:sport_flutter/presentation/widgets/video_player_widget.dart';
import 'package:video_player/video_player.dart';

class VideoDetailPage extends StatefulWidget {
  final Video video;
  final List<Video> recommendedVideos;

  const VideoDetailPage({
    super.key,
    required this.video,
    this.recommendedVideos = const [],
  });

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  late VideoPlayerController _controller;
  late Video _currentVideo;
  late final CommentBloc _commentBloc;

  bool _isFullScreen = false;
  bool _isLiked = false;
  bool _isDisliked = false;
  bool _isFavorited = false;
  bool _viewRecorded = false;
  bool _isInteracting = false;
  bool _isLoading = true;

  final String _apiBaseUrl = AuthRemoteDataSourceImpl.getBaseApiUrl();

  @override
  void initState() {
    super.initState();
    _currentVideo = widget.video;
    _isFavorited = widget.video.isFavorited;
    _commentBloc = CommentBloc();
    _initializePlayer(_currentVideo.videoUrl);
    _fetchInitialStatus();
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _commentBloc.close();
    if (_isFullScreen) {
      _exitFullScreen();
    }
    super.dispose();
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('user_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token'
    };
  }

  void _initializePlayer(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        if (mounted) setState(() {});
        _controller.play();
      })
      ..addListener(_videoListener);
  }

  Future<void> _changeVideo(Video newVideo) async {
    if (!mounted) return;

    await _controller.dispose();
    setState(() {
      _currentVideo = newVideo;
      _isFavorited = newVideo.isFavorited;
      _viewRecorded = false;
      _isLiked = false;
      _isDisliked = false;
      _isLoading = true;
    });

    _initializePlayer(newVideo.videoUrl);
    await _fetchInitialStatus();
    _commentBloc.add(FetchComments(newVideo.id));
  }

  Future<void> _fetchInitialStatus() async {
    setState(() => _isLoading = true);
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/videos/${_currentVideo.id}/status'),
        headers: headers,
      );
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        final isLiked = data['isLikedByUser'] ?? false;
        final isDisliked = data['isDislikedByUser'] ?? false;
        final isFavorited = data['isFavorited'] ?? false;

        setState(() {
          _currentVideo = _currentVideo.copyWith(
            likeCount: data['like_count'] ?? _currentVideo.likeCount,
          );
          _isLiked = isLiked;
          _isDisliked = isDisliked;
          _isFavorited = isFavorited;
        });
      }
    } catch (_) {
      // Handle error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _videoListener() {
    if (!_viewRecorded &&
        !_controller.value.hasError &&
        _controller.value.position >= _controller.value.duration) {
      _recordView();
      _viewRecorded = true;
    }
  }

  Future<void> _recordView() async {
    try {
      final headers = await _getAuthHeaders();
      await http.post(
        Uri.parse('$_apiBaseUrl/videos/${_currentVideo.id}/view'),
        headers: headers,
      );
    } catch (_) {
      // Handle error
    }
  }

  Future<void> _toggleLike() async => _performVoteAction('like');
  Future<void> _toggleDislike() async => _performVoteAction('dislike');

  Future<void> _toggleFavorite() async {
    final isCurrentlyFavorited = _isFavorited;
    setState(() {
      _isFavorited = !isCurrentlyFavorited;
    });

    try {
      if (isCurrentlyFavorited) {
        await context.read<UnfavoriteVideo>()(_currentVideo.id);
        context.read<FavoritesBloc>().add(RemoveFavorite(_currentVideo));
      } else {
        await context.read<FavoriteVideo>()(_currentVideo.id);
        context.read<FavoritesBloc>().add(AddFavorite(_currentVideo));
      }
    } catch (e) {
      setState(() {
        _isFavorited = isCurrentlyFavorited;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Operation failed: $e')),
        );
      }
    }
  }

  Future<void> _performVoteAction(String action) async {
    if (_isInteracting) return;
    setState(() => _isInteracting = true);

    final bool previousIsLiked = _isLiked;
    final bool previousIsDisliked = _isDisliked;
    final int previousLikeCount = _currentVideo.likeCount;

    bool newIsLiked = previousIsLiked;
    bool newIsDisliked = previousIsDisliked;
    int newLikeCount = previousLikeCount;

    if (action == 'like') {
      if (previousIsLiked) {
        newIsLiked = false;
        newLikeCount--;
      } else {
        newIsLiked = true;
        newLikeCount++;
        if (previousIsDisliked) {
          newIsDisliked = false;
        }
      }
    } else if (action == 'dislike') {
      if (previousIsDisliked) {
        newIsDisliked = false;
      } else {
        newIsDisliked = true;
        if (previousIsLiked) {
          newIsLiked = false;
          newLikeCount--;
        }
      }
    }

    // 乐观更新UI，立即响应用户操作
    setState(() {
      _isLiked = newIsLiked;
      _isDisliked = newIsDisliked;
      _currentVideo = _currentVideo.copyWith(likeCount: newLikeCount);
    });

    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/videos/${_currentVideo.id}/$action'),
        headers: headers,
      );
      
      // 请求成功后，我们信任前端的乐观更新，不再根据服务器返回的数据二次刷新UI。
      // 这样做可以完全避免因网络延迟或服务器状态与客户端不一致导致的界面闪烁问题。
      // 只有在请求失败时，才需要将UI回滚到操作前的状态。
      if (response.statusCode != 200) {
        throw Exception('Failed to perform vote action: ${response.statusCode}');
      }
    } catch (_) {
      if (mounted) {
        // 网络请求失败或出错，回滚UI到操作前的状态
        setState(() {
          _isLiked = previousIsLiked;
          _isDisliked = previousIsDisliked;
          _currentVideo = _currentVideo.copyWith(likeCount: previousLikeCount);
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isInteracting = false);
      }
    }
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
      if (_isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      } else {
        _exitFullScreen();
      }
    });
  }

  void _exitFullScreen() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.isInitialized
              ? VideoPlayerWidget(
                  controller: _controller,
                  isFullScreen: _isFullScreen,
                  onToggleFullScreen: _toggleFullScreen,
                )
              : const CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_currentVideo.title)),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          Navigator.of(context).pop(_isFavorited);
        },
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _controller.value.isInitialized
                  ? VideoPlayerWidget(
                      controller: _controller,
                      isFullScreen: _isFullScreen,
                      onToggleFullScreen: _toggleFullScreen,
                    )
                  : Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
            ),
            Expanded(child: _buildMetaAndCommentsSection()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaAndCommentsSection() {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider.value(
      value: _commentBloc,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(tabs: [Tab(text: l10n.introduction), Tab(text: l10n.comments)]),
            Expanded(
              child: TabBarView(
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : VideoIntroPanel(
                          currentVideo: _currentVideo,
                          recommendedVideos: widget.recommendedVideos,
                          isLiked: _isLiked,
                          isDisliked: _isDisliked,
                          isFavorited: _isFavorited,
                          isInteracting: _isInteracting,
                          onChangeVideo: _changeVideo,
                          onLike: _toggleLike,
                          onDislike: _toggleDislike,
                          onFavorite: _toggleFavorite,
                        ),
                  CommentSection(videoId: _currentVideo.id),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
