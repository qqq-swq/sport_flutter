import 'package:intl/intl.dart';

/// Formats a [DateTime] timestamp into 'yyyy-MM-dd HH:mm' format.
String formatTimestamp(DateTime timestamp, {String? locale}) {
  final localTimestamp = timestamp.toLocal();
  return DateFormat('yyyy-MM-dd HH:mm').format(localTimestamp);
}
