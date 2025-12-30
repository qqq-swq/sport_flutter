import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_flutter/domain/entities/community_post.dart';
import 'package:sport_flutter/domain/entities/post_comment.dart';
import 'package:sport_flutter/domain/entities/user.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/bloc/auth_bloc.dart';
import 'package:sport_flutter/presentation/bloc/post_comment_bloc.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_input_field.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/comment_section.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/post_header.dart';
import 'package:sport_flutter/presentation/pages/post_detail/widgets/sliver_persistent_header_delegate.dart';
import 'package:sport_flutter/presentation/widgets/shimmer.dart';
import 'package:sport_flutter/services/translation_service.dart';
import 'package:iconsax/iconsax.dart';

class PostDetailPage extends StatefulWidget {
  final CommunityPost post;

  const PostDetailPage({super.key, required this.post});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  PostComment? _replyingTo;
  final _scrollController = ScrollController();
  final _postHeaderKey = GlobalKey();
  bool _isAppBarTitleVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<PostCommentBloc>().add(FetchPostComments(widget.post.id));
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_postHeaderKey.currentContext == null) return;

    final renderSliver =
        _postHeaderKey.currentContext!.findRenderObject() as RenderSliver;
    final postHeaderHeight = renderSliver.geometry!.scrollExtent;

    // Show the title when the user has scrolled past the post header.
    final shouldShow = _scrollController.offset >= postHeaderHeight;

    if (shouldShow != _isAppBarTitleVisible) {
      setState(() {
        _isAppBarTitleVisible = shouldShow;
      });
    }
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
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          title: Text(l10n.deletePost),
          content: Text(l10n.deletePostConfirmation),
          actions: <Widget>[
            TextButton(
              child: Text(l10n.cancel),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
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
    final authState = context.watch<AuthBloc>().state;
    final currentUser = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        titleSpacing: 0.0,
        title: AnimatedOpacity(
          opacity: _isAppBarTitleVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: widget.post.userAvatarUrl != null && widget.post.userAvatarUrl!.isNotEmpty
                    ? CachedNetworkImageProvider(widget.post.userAvatarUrl!)
                    : null,
                child: widget.post.userAvatarUrl == null || widget.post.userAvatarUrl!.isEmpty
                    ? const Icon(Iconsax.profile, size: 18)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(widget.post.username),
            ],
          ),
        ),
        actions: [
          if (currentUser != null && widget.post.userId.toString() == currentUser.id)
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
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            _onCancelReply();
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(key: _postHeaderKey, child: PostHeader(post: widget.post)),
              SliverPersistentHeader(
                pinned: true,
                delegate: SportSliverPersistentHeaderDelegate(
                  maxHeight: 40,
                  minHeight: 40,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(AppLocalizations.of(context)!.comments, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              BlocBuilder<PostCommentBloc, PostCommentState>(
                builder: (context, state) {
                  if (state is PostCommentLoading) {
                    return const SliverToBoxAdapter(
                      child: SizedBox(height: 400, child: ShimmerLoading()),
                    );
                  }
                  if (state is PostCommentLoaded) {
                    if (state.comments.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40.0),
                            child: Text(
                              AppLocalizations.of(context)!.beTheFirstToComment,
                              style: const TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }
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
      ),
      bottomNavigationBar: CommentInputField(
        postId: widget.post.id,
        replyingTo: _replyingTo,
        onCancelReply: _onCancelReply,
      ),
    );
  }
}

// A widget that translates the given text and displays it.
class _TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _TranslatedText({required this.text, required this.style});

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
