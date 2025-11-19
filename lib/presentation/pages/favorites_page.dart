import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/presentation/bloc/favorites_bloc.dart';
import 'package:sport_flutter/presentation/pages/video_detail_page.dart';
import 'package:sport_flutter/presentation/widgets/video_list_item.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(FetchFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavoritesLoaded) {
            if (state.videos.isEmpty) {
              return const Center(child: Text('你还没有收藏任何视频'));
            }
            return ListView.builder(
              itemCount: state.videos.length,
              itemBuilder: (context, index) {
                final video = state.videos[index];
                return InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoDetailPage(video: video),
                      ),
                    );

                    // After returning, if the result is a boolean (the favorite status),
                    // and it has changed to false, refresh the favorites list.
                    if (result is bool && !result && mounted) {
                      context.read<FavoritesBloc>().add(FetchFavorites());
                    }
                  },
                  child: VideoListItem(video: video),
                );
              },
            );
          }
          return const Center(child: Text('加载失败'));
        },
      ),
    );
  }
}
