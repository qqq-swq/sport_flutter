import 'package:flutter/material.dart';

class VideoActionButtons extends StatelessWidget {
  final bool isLiked;
  final bool isDisliked;
  final bool isFavorited;
  final bool isInteracting;
  final int likeCount;
  final VoidCallback onLike;
  final VoidCallback onDislike;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  const VideoActionButtons({
    super.key,
    required this.isLiked,
    required this.isDisliked,
    required this.isFavorited,
    required this.isInteracting,
    required this.likeCount,
    required this.onLike,
    required this.onDislike,
    required this.onFavorite,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          context: context,
          icon: isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
          label: _formatNumber(likeCount),
          onPressed: onLike,
        ),
        _buildActionButton(
          context: context,
          icon: isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
          label: '不喜欢',
          onPressed: onDislike,
        ),
        _buildActionButton(
          context: context,
          icon: isFavorited ? Icons.star : Icons.star_border,
          label: '收藏',
          onPressed: onFavorite,
        ),
        const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    // Making the button unresponsive when an interaction is in progress
    final bool isButtonDisabled = isInteracting && (onPressed == onLike || onPressed == onDislike);
    
    return InkWell(
      onTap: isButtonDisabled ? null : onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isButtonDisabled ? Colors.grey : Theme.of(context).iconTheme.color,
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }

  String _formatNumber(int n) => (n >= 10000) ? '${(n / 10000).toStringAsFixed(1)}万' : n.toString();
}