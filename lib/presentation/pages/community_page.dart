import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_flutter/domain/usecases/create_community_post.dart';
import 'package:sport_flutter/domain/usecases/get_community_posts.dart';
import 'package:sport_flutter/presentation/bloc/community_bloc.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/presentation/pages/post_detail_page.dart';
import 'package:sport_flutter/services/oss_upload_service.dart';
import 'package:video_player/video_player.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CommunityBloc(
        getCommunityPosts: RepositoryProvider.of<GetCommunityPosts>(context),
        createCommunityPost: RepositoryProvider.of<CreateCommunityPost>(context),
        ossUploadService: RepositoryProvider.of<OssUploadService>(context),
      )..add(FetchPosts()),
      child: const _CommunityView(),
    );
  }
}

class _CommunityView extends StatelessWidget {
  const _CommunityView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社区'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<CommunityBloc, CommunityState>(
        listener: (context, state) {
          if (state is CommunityError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('操作失败: ${state.message}')));
          }
          if (state is CommunityPostSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(content: Text('发表成功!')));
          }
        },
        builder: (context, state) {
          // Success case: show the list of posts.
          if (state is CommunityLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('还没有人发言，快来抢个沙发吧！'));
            }
            return RefreshIndicator(
              onRefresh: () async => context.read<CommunityBloc>().add(FetchPosts()),
              child: ListView.separated(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return _PostItem(post: state.posts[index]);
                },
                separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
              ),
            );
          }
          // Error case: show a retry button.
          if (state is CommunityError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('加载失败'),
                  const SizedBox(height: 8),
                  TextButton(onPressed: () => context.read<CommunityBloc>().add(FetchPosts()), child: const Text('点击重试')),
                ],
              ),
            );
          }
          // For all other states (Initial, Loading), show a spinner.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<CommunityBloc>(),
            child: const _AddPostDialog(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AddPostDialog extends StatefulWidget {
  const _AddPostDialog();

  @override
  State<_AddPostDialog> createState() => _AddPostDialogState();
}

class _AddPostDialogState extends State<_AddPostDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedFile;
  bool _isSubmitting = false;

  Future<void> _pickMedia(ImageSource source, {bool isVideo = false}) async {
    final picker = ImagePicker();
    final pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<CommunityBloc, CommunityState>(
      listener: (context, state) {
        // This will now correctly listen for the success state and close the dialog.
        if (state is CommunityPostSuccess) {
          Navigator.of(context).pop();
        } 
      },
      child: AlertDialog(
        title: const Text('发表新帖'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _titleController, decoration: const InputDecoration(labelText: '标题', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _contentController, decoration: const InputDecoration(labelText: '内容', border: OutlineInputBorder()), maxLines: 5),
              const SizedBox(height: 12),
              _buildMediaPreview(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(icon: const Icon(Icons.photo_library_outlined), label: const Text('图片'), onPressed: () => _pickMedia(ImageSource.gallery)),
                  TextButton.icon(icon: const Icon(Icons.videocam_outlined), label: const Text('视频'), onPressed: () => _pickMedia(ImageSource.gallery, isVideo: true)),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('取消')),
          BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              final isSubmitting = state is CommunityLoading;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                onPressed: isSubmitting ? null : () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                        setState(() => _isSubmitting = true);
                        context.read<CommunityBloc>().add(AddPost(
                            title: _titleController.text,
                            content: _contentController.text,
                            mediaFile: _selectedFile,
                        ));
                    }
                },
                child: isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('发表'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview() {
    if (_selectedFile == null) return const SizedBox.shrink();
    final isImage = ['.jpg', '.jpeg', '.png', '.gif'].any((ext) => _selectedFile!.path.toLowerCase().endsWith(ext));
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: isImage
          ? Image.file(_selectedFile!, height: 100, fit: BoxFit.cover)
          : const Row(children: [Icon(Icons.movie_creation_outlined), SizedBox(width: 8), Text('已选择视频')]),
    );
  }
}



class _PostItem extends StatefulWidget {
  final CommunityPost post;
  const _PostItem({required this.post});
  @override
  State<_PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<_PostItem> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    if (widget.post.videoUrl != null && widget.post.videoUrl!.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.post.videoUrl!));
      _initializeVideoPlayerFuture = _controller!.initialize()..then((_) {
        if (mounted) setState(() {});
      });
      _controller!.setLooping(true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (_controller != null && _controller!.value.isInitialized) {
          return AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                VideoPlayer(_controller!),
                IconButton(
                  onPressed: () => setState(() => _controller!.value.isPlaying ? _controller!.pause() : _controller!.play()),
                  icon: Icon(_controller!.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline, color: Colors.white.withOpacity(0.85), size: 48),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PostDetailPage(post: widget.post))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [const CircleAvatar(radius: 12, child: Icon(Icons.person, size: 14)), const SizedBox(width: 8), Text(widget.post.username, style: Theme.of(context).textTheme.bodySmall)]),
            const SizedBox(height: 8),
            Text(widget.post.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            if (widget.post.imageUrl != null) Padding(padding: const EdgeInsets.only(top: 12.0), child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.network(widget.post.imageUrl!, height: 150, width: double.infinity, fit: BoxFit.cover))),
            if (widget.post.videoUrl != null) Padding(padding: const EdgeInsets.only(top: 12.0), child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: _buildVideoPlayer())),
            const SizedBox(height: 12),
            Row(children: [if (widget.post.tags?.isNotEmpty ?? false) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(widget.post.tags!.first, style: TextStyle(color: Colors.blue.shade700, fontSize: 10))), const Spacer(), const Icon(Icons.comment_outlined, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(widget.post.commentCount.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12)), const SizedBox(width: 16), const Icon(Icons.thumb_up_outlined, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(widget.post.likeCount.toString(), style: const TextStyle(color: Colors.grey, fontSize: 12))]),
          ],
        ),
      ),
    );
  }
}
