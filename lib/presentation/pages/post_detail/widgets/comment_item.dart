import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/common/time_formatter.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/bloc/post_comment_bloc.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/reply_sheet.dart';
import 'package:sport_flutter/services/translation_service.dart';
import 'package:iconsax/iconsax.dart';

class CommentItem extends StatelessWidget {
  final PostComment comment;
  final int postId;
  final Function(PostComment) onReplyTapped;
  final bool isReply;
  final bool showReplyButton;

  const CommentItem({
    super.key,
    required this.comment,
    required this.postId,
    required this.onReplyTapped,
    this.isReply = false,
    this.showReplyButton = true,
  });

  void _showReplySheet(BuildContext context, PostComment parentComment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<PostCommentBloc>(context),
        child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return ReplySheet(parentCommentId: parentComment.id, postId: postId, scrollController: scrollController);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(isReply ? 40.0 : 16.0, 8.0, 16.0, 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: comment.userAvatarUrl != null && comment.userAvatarUrl!.isNotEmpty
                    ? NetworkImage(comment.userAvatarUrl!)
                    : null,
                child: comment.userAvatarUrl == null || comment.userAvatarUrl!.isEmpty ? const Icon(Iconsax.profile, size: 16) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.username, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 4),
                    _TranslatedText(
                      key: ValueKey('comment_${comment.id}_${locale.languageCode}'),
                      text: comment.content,
                      style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildActionRow(context, Theme.of(context).textTheme, Theme.of(context).colorScheme),
          if (comment.replyCount > 0 && showReplyButton)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: GestureDetector(
                onTap: () => _showReplySheet(context, comment),
                child: Text(localizations.viewAllReplies(comment.replyCount), style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    final bloc = context.read<PostCommentBloc>();
    final voteStyle = textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold);
    final localizations = AppLocalizations.of(context)!;
    final timeString = formatTimestamp(comment.createdAt, localizations);
    final authState = context.watch<AuthBloc>().state;
    String? currentUserId;
    if (authState is AuthAuthenticated) {
      currentUserId = authState.user.id;
    }


    return Row(
      children: [
        Text(timeString, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        const Spacer(),
        IconButton(
          icon: Icon(Iconsax.like, size: 16, color: comment.userVote == 'like' ? colorScheme.primary : Colors.grey),
          onPressed: () => bloc.add(LikeComment(comment.id)),
        ),
        if (comment.likeCount > 0) Text(comment.likeCount.toString(), style: voteStyle),
        const SizedBox(width: 12),
        IconButton(
          icon: Icon(Iconsax.dislike, size: 16, color: comment.userVote == 'dislike' ? Colors.red : Colors.grey),
          onPressed: () => bloc.add(DislikeComment(comment.id)),
        ),
        if (comment.dislikeCount > 0) Text(comment.dislikeCount.toString(), style: voteStyle),
        const SizedBox(width: 12),
        IconButton(
          icon: const Icon(Iconsax.message_text_1, size: 16, color: Colors.grey),
          onPressed: () => onReplyTapped(comment),
        ),
        if (currentUserId != null && comment.userId == currentUserId)
          IconButton(
            icon: const Icon(Iconsax.trash, size: 16, color: Colors.grey),
            onPressed: () => bloc.add(DeleteComment(comment.id)),
          ),
      ],
    );
  }
}

class _TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TranslatedText({super.key, required this.text, required this.style});

  @override
  State<_TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<_TranslatedText> {
  String? _translatedText;

  @override
  void initState() {
    super.initState();
    _translateText();
  }

  @override
  void didUpdateWidget(covariant _TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _translateText();
    }
  }

  Future<void> _translateText() async {
    if (!mounted) return;
    final locale = Localizations.localeOf(context);
    final translationService = context.read<TranslationService>();
    final translated = await translationService.translate(widget.text, locale.languageCode);
    if (mounted) {
      setState(() {
        _translatedText = translated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText ?? widget.text,
      style: widget.style,
    );
  }
}
