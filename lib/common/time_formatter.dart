import 'package:sport_flutter/l10n/app_localizations.dart';

String formatDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

String formatDurationWithHours(Duration d) {
  if (d.inHours > 0) {
    final hours = d.inHours.toString();
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  } else {
    return formatDuration(d);
  }
}

String formatTimestamp(DateTime timestamp, AppLocalizations localizations) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.isNegative) {
        return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
    }

    if (difference.inMinutes < 1) {
      return localizations.justNow;
    }
    if (difference.inHours < 1) {
      return localizations.minutesAgo(difference.inMinutes);
    }
    if (difference.inHours < 24) {
      return localizations.hoursAgo(difference.inHours);
    }
    
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final timeString = '$hour:$minute';

    if (difference.inDays < 7) {
      return '${localizations.daysAgo(difference.inDays)} $timeString';
    }
    
    final month = timestamp.month.toString().padLeft(2, '0');
    final day = timestamp.day.toString().padLeft(2, '0');

    if (timestamp.year == now.year) {
      return '$month-$day $timeString';
    } else {
      return '${timestamp.year}-$month-$day $timeString';
    }
}
