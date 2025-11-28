import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sport_flutter/domain/entities/video.dart';
import 'package:sport_flutter/l10n/app_localizations.dart';
import 'package:sport_flutter/presentation/widgets/video_action_buttons.dart';
import 'package:iconsax/iconsax.dart';

class VideoIntroPanel extends StatefulWidget {
  final Video currentVideo;
  final List<Video> recommendedVideos;
  final bool isLiked;
  final bool isDisliked;
  final bool isFavorited;
  final bool isInteracting;
  final Function(Video) onChangeVideo;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onFavorite;

  const VideoIntroPanel({
    super.key,
    required this.currentVideo,
    required this.recommendedVideos,
    required this.isLiked,
    required this.isDisliked,
    required this.isFavorited,
    required this.isInteracting,
    required this.onChangeVideo,
    required this.onLike,
    required this.onDislike,
    required this.onFavorite,
  });

  @override
  State<VideoIntroPanel> createState() => _VideoIntroPanelState();
}

class _VideoIntroPanelState extends State<VideoIntroPanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthorInfo(context),
                const SizedBox(height: 12),
                Text(widget.currentVideo.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                _buildDescriptionSection(context),
                const SizedBox(height: 8),
                Text(
                  l10n.videoViews(widget.currentVideo.viewCount, _formatDate(context, widget.currentVideo.createdAt)),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                VideoActionButtons(
                  isLiked: widget.isLiked,
                  isDisliked: widget.isDisliked,
                  isFavorited: widget.isFavorited,
                  isInteracting: widget.isInteracting,
                  likeCount: widget.currentVideo.likeCount,
                  onLike: widget.onLike,
                  onDislike: widget.onDislike,
                  onFavorite: widget.onFavorite,
                ),
                const Divider(height: 32),
                Text(l10n.upNext, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (c, i) {
              final v = widget.recommendedVideos[i];
              if (v.id == widget.currentVideo.id) return const SizedBox.shrink();
              return _buildRecommendedItem(c, v);
            },
            childCount: widget.recommendedVideos.length,
          ),
        )
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    final description = widget.currentVideo.description;
    if (description == null || description.isEmpty) {
      return const SizedBox.shrink();
    }

    final textStyle = Theme.of(context).textTheme.bodyMedium!;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: description, style: textStyle);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: textStyle,
                maxLines: _isExpanded ? null : 2,
                overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    _isExpanded ? l10n.showLess : l10n.showMore,
                    style: textStyle.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text(description, style: textStyle);
        }
      },
    );
  }


  Widget _buildAuthorInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: widget.currentVideo.userAvatarUrl != null && widget.currentVideo.userAvatarUrl!.isNotEmpty
              ? NetworkImage(widget.currentVideo.userAvatarUrl!)
              : null,
          child: widget.currentVideo.userAvatarUrl == null || widget.currentVideo.userAvatarUrl!.isEmpty
              ? const Icon(Iconsax.profile)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(widget.currentVideo.authorName, style: Theme.of(context).textTheme.titleMedium)),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildRecommendedItem(BuildContext context, Video video) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => widget.onChangeVideo(video),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 150,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (c, u) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (c, u, e) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.authorName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime d) {
    final l10n = AppLocalizations.of(context)!;
    final diff = DateTime.now().difference(d);
    if (diff.inDays > 1) return l10n.daysAgo(diff.inDays);
    if (diff.inHours > 1) return l10n.hoursAgo(diff.inHours);
    return l10n.justNow;
  }
}
