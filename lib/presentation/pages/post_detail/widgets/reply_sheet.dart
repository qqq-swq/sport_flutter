import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/presentation/bloc/post_comment_bloc.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_item.dart';
import 'package:iconsax/iconsax.dart';

class ReplySheet extends StatelessWidget {
  final int parentCommentId;
  final int postId;
  final ScrollController scrollController;

  const ReplySheet({super.key, required this.parentCommentId, required this.postId, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<PostCommentBloc>(context),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            Text('Replies', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<PostCommentBloc, PostCommentState>(
                builder: (context, state) {
                  if (state is PostCommentLoaded) {
                    final parentComment = state.comments.firstWhere((c) => c.id == parentCommentId);
                    if (parentComment.replies.isEmpty) {
                      return const Center(child: Text('No replies yet.'));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: parentComment.replies.length,
                      itemBuilder: (context, index) {
                        final reply = parentComment.replies[index];
                        return CommentItem(
                          comment: reply,
                          postId: postId,
                          onReplyTapped: (tappedComment) {},
                          isReply: true,
                          showReplyButton: false,
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
