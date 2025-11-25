import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/presentation/bloc/post_comment_bloc.dart';
import 'package:sport_flutter/presentation/bloc/recommended_video_bloc.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_input_field.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_section.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/post_header.dart';
import 'package:sport_flutter/presentation/widgets/shimmer.dart';
import 'package:iconsax/iconsax.dart';

class PostDetailPage extends StatefulWidget {
  final CommunityPost post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostComment? _replyingTo;

  @override
  void initState() {
    super.initState();
    context.read<PostCommentBloc>().add(FetchPostComments(widget.post.id));
    context.read<RecommendedVideoBloc>().add(FetchRecommendedVideos());
  }

  void _onReplyTapped(PostComment comment) {
    setState(() {
      _replyingTo = comment;
    });
  }

  void _onCancelReply() {
    setState(() {
      _replyingTo = null;
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('删除帖子'),
          content: const Text('您确定要删除这个帖子吗？此操作无法撤销。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('删除', style: TextStyle(color: Colors.red)),
              onPressed: () {
                context.read<PostCommentBloc>().add(DeletePost(widget.post.id));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.username),
        actions: [
          if (widget.post.username == 'wyy')
            IconButton(
              icon: const Icon(Iconsax.trash),
              onPressed: _showDeleteConfirmationDialog,
            ),
        ],
      ),
      body: BlocListener<PostCommentBloc, PostCommentState>(
        listener: (context, state) {
          if (state is PostDeletionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('帖子已成功删除'), duration: Duration(seconds: 1)),
            );
            Navigator.of(context).pop(true);
          } else if (state is PostDeletionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('删除失败: ${state.message}')),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: PostHeader(post: widget.post)),
                  const SliverToBoxAdapter(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('评论', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
                  BlocBuilder<PostCommentBloc, PostCommentState>(
                    builder: (context, state) {
                      if (state is PostCommentLoading) {
                        // Use a SliverToBoxAdapter to embed the ShimmerLoading
                        return const SliverToBoxAdapter(
                          child: SizedBox(height: 400, child: ShimmerLoading()),
                        );
                      }
                      if (state is PostCommentLoaded) {
                        return CommentSection(postId: widget.post.id, onReplyTapped: _onReplyTapped);
                      }
                      if (state is PostCommentError) {
                        return SliverToBoxAdapter(
                          child: Center(child: Text('Error: ${state.message}')),
                        );
                      }
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),
                ],
              ),
            ),
            CommentInputField(
              postId: widget.post.id,
              replyingTo: _replyingTo,
              onCancelReply: _onCancelReply,
            ),
          ],
        ),
      ),
    );
  }
}
