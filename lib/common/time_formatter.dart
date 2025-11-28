import 'package:intl/intl.dart';

/// Formats a [DateTime] timestamp into 'yyyy-MM-dd HH:mm' format in the user's local timezone.
String formatTimestamp(DateTime timestamp, {String? locale}) {
  // Convert the timestamp to the user's local time zone before formatting.
  final localTimestamp = timestamp.toLocal();
  return DateFormat('yyyy-MM-dd HH:mm', locale).format(localTimestamp);
}
