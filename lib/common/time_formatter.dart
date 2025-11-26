import 'package:intl/intl.dart';

/// Formats a [DateTime] timestamp into 'yyyy-MM-dd HH:mm' format.
String formatTimestamp(DateTime timestamp, {String? locale}) {
  // The incoming timestamp is assumed to be in the correct local time.
  // We just need to format it.
  return DateFormat('yyyy-MM-dd HH:mm', locale).format(timestamp);
}
