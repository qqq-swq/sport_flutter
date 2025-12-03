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

    if (difference.inDays >= 7) {
        final weeks = (difference.inDays / 7).floor();
        return localizations.weeksAgo(weeks);
    }
    if (difference.inDays >= 1) {
        return localizations.daysAgo(difference.inDays);
    }
    if (difference.inHours >= 1) {
        return localizations.hoursAgo(difference.inHours);
    }
    if (difference.inMinutes >= 1) {
        return localizations.minutesAgo(difference.inMinutes);
    }

    return localizations.justNow;
}
