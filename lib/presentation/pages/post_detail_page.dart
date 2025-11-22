import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/presentation/bloc/post_comment_bloc.dart';
import 'package:sport_flutter/presentation/bloc/recommended_video_bloc.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_input_field.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_section.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/post_header.dart';
import 'package:iconsax/iconsax.dart';

// FIX: Changed to StatefulWidget to fetch comments on init
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
    // Fetch comments for the given post when the page loads
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
                // Use the existing context to find the BLoC
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
    // REMOVED the local BlocProvider. The page now relies on the BLoC
    // provided at the top of the widget tree in main.dart.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post.username),
        actions: [
          // TODO: Replace 'wyy' with a real check for post ownership
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
            // Pop with a `true` result to signal the previous page to refresh.
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
                  const SliverToBoxAdapter(child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text('评论', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  )),
                  CommentSection(postId: widget.post.id, onReplyTapped: _onReplyTapped),
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
