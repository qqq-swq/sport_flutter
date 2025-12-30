import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/domain/repositories/video_repository.dart';
import 'package:sport_flutter/domain/usecases/favorite_video.dart';
import 'package:sport_flutter/domain/usecases/get_videos.dart';
import 'package:sport_flutter/domain/usecases/unfavorite_video.dart';
import 'package:sport_flutter/presentation/bloc/video_bloc.dart';
import 'package:sport_flutter/presentation/bloc/video_event.dart';
import 'package:sport_flutter/presentation/bloc/video_state.dart';
import 'package:sport_flutter/presentation/pages/video_detail_page.dart';
import 'package:sport_flutter/presentation/widgets/translated_text.dart';

class VideoGridPage extends StatefulWidget {
  final String title;
  final Difficulty difficulty;

  const VideoGridPage({
    super.key,
    required this.title,
    required this.difficulty,
  });

  @override
  State<VideoGridPage> createState() => _VideoGridPageState();
}

class _VideoGridPageState extends State<VideoGridPage> {
  late final VideoBloc _videoBloc;

  @override
  void initState() {
    super.initState();
    final getVideosUseCase = RepositoryProvider.of<GetVideos>(context, listen: false);
    final favoriteVideoUseCase = RepositoryProvider.of<FavoriteVideo>(context, listen: false);
    final unfavoriteVideoUseCase = RepositoryProvider.of<UnfavoriteVideo>(context, listen: false);
    final cacheManager = RepositoryProvider.of<CacheManager>(context, listen: false);

    _videoBloc = VideoBloc(
      getVideos: getVideosUseCase,
      favoriteVideo: favoriteVideoUseCase,
      unfavoriteVideo: unfavoriteVideoUseCase,
      cacheManager: cacheManager,
    )..add(FetchVideos(widget.difficulty));
  }

  @override
  void dispose() {
    _videoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocProvider.value(
        value: _videoBloc,
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoLoaded) {
              if (state.videos.isEmpty) {
                return const Center(child: Text('No videos found.'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  final video = state.videos[index];
                  return _GridItem(video: video);
                },
              );
            }
            if (state is VideoError) {
              return Center(child: Text('Failed to fetch videos: ${state.message}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _GridItem extends StatelessWidget {
  final Video video;

  const _GridItem({required this.video});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailPage(
              video: video,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TranslatedText(
                key: ValueKey('${video.title}_${locale.languageCode}'),
                text: video.title,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
